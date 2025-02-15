import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ramen_music_player/core/player.dart';
import 'package:ramen_music_player/core/song.dart';

class Playlist extends StatefulWidget {
  final String ref;
  const Playlist({Key? key, required this.ref}) : super(key: key);

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  @override
  Widget build(BuildContext context) {
    final songsRef = FirebaseDatabase.instance.ref(widget.ref);
    return FutureBuilder<DatabaseEvent>(
        future: songsRef.once(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DataSnapshot snap = snapshot.data!.snapshot;
            List<DataSnapshot> songList = snap.children.toList();
            initPlaylist(songList);
            return ListView.builder(
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  Song song = Song.fromJson(
                      songList.elementAt(index).value as Map<String, dynamic>);
                  return Column(
                    children: [
                      ListTile(
                        onTap: () async => {setSong(index)},
                        leading: const Icon(
                          Icons.music_note,
                        ),
                        title: Text(song.name),
                        subtitle: Text(song.artist),
                      ),
                      const Divider(),
                    ],
                  );
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
