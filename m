Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447FA3CDA77
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244818AbhGSOgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245603AbhGSOes (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:34:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BE8C611ED;
        Mon, 19 Jul 2021 15:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707671;
        bh=vBjN5xzRd++sJ/rfJRTBqHYaD1NrgVl1v6fW8VmJvZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFRUjxZjjV/R3NVdQuy+SwL+khmaY8K3iqKqINMXSneplyIKH4FyIqPN1+MmRMPW2
         nwjXHIKV2wpYlwU0BR9UiylmPyr2fRP65DudaOoC1tNB43c3HSpvwZ+ditA8xWzTF7
         j4udIFLa26BYFxo2bcy4KuwZDx4AvwU1l5FwoHeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.14 011/315] btrfs: send: fix invalid path for unlink operations after parent orphanization
Date:   Mon, 19 Jul 2021 16:48:20 +0200
Message-Id: <20210719144943.242463011@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit d8ac76cdd1755b21e8c008c28d0b7251c0b14986 upstream.

During an incremental send operation, when processing the new references
for the current inode, we might send an unlink operation for another inode
that has a conflicting path and has more than one hard link. However this
path was computed and cached before we processed previous new references
for the current inode. We may have orphanized a directory of that path
while processing a previous new reference, in which case the path will
be invalid and cause the receiver process to fail.

The following reproducer triggers the problem and explains how/why it
happens in its comments:

  $ cat test-send-unlink.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  mkfs.btrfs -f $DEV >/dev/null
  mount $DEV $MNT

  # Create our test files and directory. Inode 259 (file3) has two hard
  # links.
  touch $MNT/file1
  touch $MNT/file2
  touch $MNT/file3

  mkdir $MNT/A
  ln $MNT/file3 $MNT/A/hard_link

  # Filesystem looks like:
  #
  # .                                     (ino 256)
  # |----- file1                          (ino 257)
  # |----- file2                          (ino 258)
  # |----- file3                          (ino 259)
  # |----- A/                             (ino 260)
  #        |---- hard_link                (ino 259)
  #

  # Now create the base snapshot, which is going to be the parent snapshot
  # for a later incremental send.
  btrfs subvolume snapshot -r $MNT $MNT/snap1
  btrfs send -f /tmp/snap1.send $MNT/snap1

  # Move inode 257 into directory inode 260. This results in computing the
  # path for inode 260 as "/A" and caching it.
  mv $MNT/file1 $MNT/A/file1

  # Move inode 258 (file2) into directory inode 260, with a name of
  # "hard_link", moving first inode 259 away since it currently has that
  # location and name.
  mv $MNT/A/hard_link $MNT/tmp
  mv $MNT/file2 $MNT/A/hard_link

  # Now rename inode 260 to something else (B for example) and then create
  # a hard link for inode 258 that has the old name and location of inode
  # 260 ("/A").
  mv $MNT/A $MNT/B
  ln $MNT/B/hard_link $MNT/A

  # Filesystem now looks like:
  #
  # .                                     (ino 256)
  # |----- tmp                            (ino 259)
  # |----- file3                          (ino 259)
  # |----- B/                             (ino 260)
  # |      |---- file1                    (ino 257)
  # |      |---- hard_link                (ino 258)
  # |
  # |----- A                              (ino 258)

  # Create another snapshot of our subvolume and use it for an incremental
  # send.
  btrfs subvolume snapshot -r $MNT $MNT/snap2
  btrfs send -f /tmp/snap2.send -p $MNT/snap1 $MNT/snap2

  # Now unmount the filesystem, create a new one, mount it and try to
  # apply both send streams to recreate both snapshots.
  umount $DEV

  mkfs.btrfs -f $DEV >/dev/null

  mount $DEV $MNT

  # First add the first snapshot to the new filesystem by applying the
  # first send stream.
  btrfs receive -f /tmp/snap1.send $MNT

  # The incremental receive operation below used to fail with the
  # following error:
  #
  #    ERROR: unlink A/hard_link failed: No such file or directory
  #
  # This is because when send is processing inode 257, it generates the
  # path for inode 260 as "/A", since that inode is its parent in the send
  # snapshot, and caches that path.
  #
  # Later when processing inode 258, it first processes its new reference
  # that has the path of "/A", which results in orphanizing inode 260
  # because there is a a path collision. This results in issuing a rename
  # operation from "/A" to "/o260-6-0".
  #
  # Finally when processing the new reference "B/hard_link" for inode 258,
  # it notices that it collides with inode 259 (not yet processed, because
  # it has a higher inode number), since that inode has the name
  # "hard_link" under the directory inode 260. It also checks that inode
  # 259 has two hardlinks, so it decides to issue a unlink operation for
  # the name "hard_link" for inode 259. However the path passed to the
  # unlink operation is "/A/hard_link", which is incorrect since currently
  # "/A" does not exists, due to the orphanization of inode 260 mentioned
  # before. The path is incorrect because it was computed and cached
  # before the orphanization. This results in the receiver to fail with
  # the above error.
  btrfs receive -f /tmp/snap2.send $MNT

  umount $MNT

When running the test, it fails like this:

  $ ./test-send-unlink.sh
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap1'
  At subvol /mnt/sdi/snap1
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap2'
  At subvol /mnt/sdi/snap2
  At subvol snap1
  At snapshot snap2
  ERROR: unlink A/hard_link failed: No such file or directory

Fix this by recomputing a path before issuing an unlink operation when
processing the new references for the current inode if we previously
have orphanized a directory.

A test case for fstests will follow soon.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4078,6 +4078,17 @@ static int process_recorded_refs(struct
 				if (ret < 0)
 					goto out;
 			} else {
+				/*
+				 * If we previously orphanized a directory that
+				 * collided with a new reference that we already
+				 * processed, recompute the current path because
+				 * that directory may be part of the path.
+				 */
+				if (orphanized_dir) {
+					ret = refresh_ref_path(sctx, cur);
+					if (ret < 0)
+						goto out;
+				}
 				ret = send_unlink(sctx, cur->full_path);
 				if (ret < 0)
 					goto out;


