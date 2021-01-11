Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A192D2F163C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbhAKNJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:09:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730950AbhAKNJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:09:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D756229C4;
        Mon, 11 Jan 2021 13:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370545;
        bh=0stzJbUrAZcqs9NqQMB5BlC35WwMhLiKAJWDeHs7rkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FNu+Lgq3Wku+R/ZMPkD57zOHZ3qTAnqsQ70Gu+p1bm6FHm8CANYIxxgposZpkzEN
         3sJZN1zr/0aAnqOBAKwhxL3ptGBrnD/hHIGDx2DvbBV1/XFkglDLhsGb6zvX2mGwgO
         A2NupAKfevUJ9p0h4K8PJkILaqNb8PD1MwuWqOjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Massimo B." <massimo.b@gmx.net>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 70/77] btrfs: send: fix wrong file path when there is an inode with a pending rmdir
Date:   Mon, 11 Jan 2021 14:02:19 +0100
Message-Id: <20210111130039.772683307@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 0b3f407e6728d990ae1630a02c7b952c21c288d3 upstream.

When doing an incremental send, if we have a new inode that happens to
have the same number that an old directory inode had in the base snapshot
and that old directory has a pending rmdir operation, we end up computing
a wrong path for the new inode, causing the receiver to fail.

Example reproducer:

  $ cat test-send-rmdir.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  mkfs.btrfs -f $DEV >/dev/null
  mount $DEV $MNT

  mkdir $MNT/dir
  touch $MNT/dir/file1
  touch $MNT/dir/file2
  touch $MNT/dir/file3

  # Filesystem looks like:
  #
  # .                                     (ino 256)
  # |----- dir/                           (ino 257)
  #         |----- file1                  (ino 258)
  #         |----- file2                  (ino 259)
  #         |----- file3                  (ino 260)
  #

  btrfs subvolume snapshot -r $MNT $MNT/snap1
  btrfs send -f /tmp/snap1.send $MNT/snap1

  # Now remove our directory and all its files.
  rm -fr $MNT/dir

  # Unmount the filesystem and mount it again. This is to ensure that
  # the next inode that is created ends up with the same inode number
  # that our directory "dir" had, 257, which is the first free "objectid"
  # available after mounting again the filesystem.
  umount $MNT
  mount $DEV $MNT

  # Now create a new file (it could be a directory as well).
  touch $MNT/newfile

  # Filesystem now looks like:
  #
  # .                                     (ino 256)
  # |----- newfile                        (ino 257)
  #

  btrfs subvolume snapshot -r $MNT $MNT/snap2
  btrfs send -f /tmp/snap2.send -p $MNT/snap1 $MNT/snap2

  # Now unmount the filesystem, create a new one, mount it and try to apply
  # both send streams to recreate both snapshots.
  umount $DEV

  mkfs.btrfs -f $DEV >/dev/null

  mount $DEV $MNT

  btrfs receive -f /tmp/snap1.send $MNT
  btrfs receive -f /tmp/snap2.send $MNT

  umount $MNT

When running the test, the receive operation for the incremental stream
fails:

  $ ./test-send-rmdir.sh
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap1'
  At subvol /mnt/sdi/snap1
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap2'
  At subvol /mnt/sdi/snap2
  At subvol snap1
  At snapshot snap2
  ERROR: chown o257-9-0 failed: No such file or directory

So fix this by tracking directories that have a pending rmdir by inode
number and generation number, instead of only inode number.

A test case for fstests follows soon.

Reported-by: Massimo B. <massimo.b@gmx.net>
Tested-by: Massimo B. <massimo.b@gmx.net>
Link: https://lore.kernel.org/linux-btrfs/6ae34776e85912960a253a8327068a892998e685.camel@gmx.net/
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |   49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -238,6 +238,7 @@ struct waiting_dir_move {
 	 * after this directory is moved, we can try to rmdir the ino rmdir_ino.
 	 */
 	u64 rmdir_ino;
+	u64 rmdir_gen;
 	bool orphanized;
 };
 
@@ -308,7 +309,7 @@ static int is_waiting_for_move(struct se
 static struct waiting_dir_move *
 get_waiting_dir_move(struct send_ctx *sctx, u64 ino);
 
-static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino);
+static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino, u64 gen);
 
 static int need_send_hole(struct send_ctx *sctx)
 {
@@ -2304,7 +2305,7 @@ static int get_cur_path(struct send_ctx
 
 		fs_path_reset(name);
 
-		if (is_waiting_for_rm(sctx, ino)) {
+		if (is_waiting_for_rm(sctx, ino, gen)) {
 			ret = gen_unique_name(sctx, ino, gen, name);
 			if (ret < 0)
 				goto out;
@@ -2863,8 +2864,8 @@ out:
 	return ret;
 }
 
-static struct orphan_dir_info *
-add_orphan_dir_info(struct send_ctx *sctx, u64 dir_ino)
+static struct orphan_dir_info *add_orphan_dir_info(struct send_ctx *sctx,
+						   u64 dir_ino, u64 dir_gen)
 {
 	struct rb_node **p = &sctx->orphan_dirs.rb_node;
 	struct rb_node *parent = NULL;
@@ -2873,20 +2874,23 @@ add_orphan_dir_info(struct send_ctx *sct
 	while (*p) {
 		parent = *p;
 		entry = rb_entry(parent, struct orphan_dir_info, node);
-		if (dir_ino < entry->ino) {
+		if (dir_ino < entry->ino)
 			p = &(*p)->rb_left;
-		} else if (dir_ino > entry->ino) {
+		else if (dir_ino > entry->ino)
 			p = &(*p)->rb_right;
-		} else {
+		else if (dir_gen < entry->gen)
+			p = &(*p)->rb_left;
+		else if (dir_gen > entry->gen)
+			p = &(*p)->rb_right;
+		else
 			return entry;
-		}
 	}
 
 	odi = kmalloc(sizeof(*odi), GFP_KERNEL);
 	if (!odi)
 		return ERR_PTR(-ENOMEM);
 	odi->ino = dir_ino;
-	odi->gen = 0;
+	odi->gen = dir_gen;
 	odi->last_dir_index_offset = 0;
 
 	rb_link_node(&odi->node, parent, p);
@@ -2894,8 +2898,8 @@ add_orphan_dir_info(struct send_ctx *sct
 	return odi;
 }
 
-static struct orphan_dir_info *
-get_orphan_dir_info(struct send_ctx *sctx, u64 dir_ino)
+static struct orphan_dir_info *get_orphan_dir_info(struct send_ctx *sctx,
+						   u64 dir_ino, u64 gen)
 {
 	struct rb_node *n = sctx->orphan_dirs.rb_node;
 	struct orphan_dir_info *entry;
@@ -2906,15 +2910,19 @@ get_orphan_dir_info(struct send_ctx *sct
 			n = n->rb_left;
 		else if (dir_ino > entry->ino)
 			n = n->rb_right;
+		else if (gen < entry->gen)
+			n = n->rb_left;
+		else if (gen > entry->gen)
+			n = n->rb_right;
 		else
 			return entry;
 	}
 	return NULL;
 }
 
-static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino)
+static int is_waiting_for_rm(struct send_ctx *sctx, u64 dir_ino, u64 gen)
 {
-	struct orphan_dir_info *odi = get_orphan_dir_info(sctx, dir_ino);
+	struct orphan_dir_info *odi = get_orphan_dir_info(sctx, dir_ino, gen);
 
 	return odi != NULL;
 }
@@ -2959,7 +2967,7 @@ static int can_rmdir(struct send_ctx *sc
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = 0;
 
-	odi = get_orphan_dir_info(sctx, dir);
+	odi = get_orphan_dir_info(sctx, dir, dir_gen);
 	if (odi)
 		key.offset = odi->last_dir_index_offset;
 
@@ -2990,7 +2998,7 @@ static int can_rmdir(struct send_ctx *sc
 
 		dm = get_waiting_dir_move(sctx, loc.objectid);
 		if (dm) {
-			odi = add_orphan_dir_info(sctx, dir);
+			odi = add_orphan_dir_info(sctx, dir, dir_gen);
 			if (IS_ERR(odi)) {
 				ret = PTR_ERR(odi);
 				goto out;
@@ -2998,12 +3006,13 @@ static int can_rmdir(struct send_ctx *sc
 			odi->gen = dir_gen;
 			odi->last_dir_index_offset = found_key.offset;
 			dm->rmdir_ino = dir;
+			dm->rmdir_gen = dir_gen;
 			ret = 0;
 			goto out;
 		}
 
 		if (loc.objectid > send_progress) {
-			odi = add_orphan_dir_info(sctx, dir);
+			odi = add_orphan_dir_info(sctx, dir, dir_gen);
 			if (IS_ERR(odi)) {
 				ret = PTR_ERR(odi);
 				goto out;
@@ -3043,6 +3052,7 @@ static int add_waiting_dir_move(struct s
 		return -ENOMEM;
 	dm->ino = ino;
 	dm->rmdir_ino = 0;
+	dm->rmdir_gen = 0;
 	dm->orphanized = orphanized;
 
 	while (*p) {
@@ -3188,7 +3198,7 @@ static int path_loop(struct send_ctx *sc
 	while (ino != BTRFS_FIRST_FREE_OBJECTID) {
 		fs_path_reset(name);
 
-		if (is_waiting_for_rm(sctx, ino))
+		if (is_waiting_for_rm(sctx, ino, gen))
 			break;
 		if (is_waiting_for_move(sctx, ino)) {
 			if (*ancestor_ino == 0)
@@ -3228,6 +3238,7 @@ static int apply_dir_move(struct send_ct
 	u64 parent_ino, parent_gen;
 	struct waiting_dir_move *dm = NULL;
 	u64 rmdir_ino = 0;
+	u64 rmdir_gen;
 	u64 ancestor;
 	bool is_orphan;
 	int ret;
@@ -3242,6 +3253,7 @@ static int apply_dir_move(struct send_ct
 	dm = get_waiting_dir_move(sctx, pm->ino);
 	ASSERT(dm);
 	rmdir_ino = dm->rmdir_ino;
+	rmdir_gen = dm->rmdir_gen;
 	is_orphan = dm->orphanized;
 	free_waiting_dir_move(sctx, dm);
 
@@ -3278,6 +3290,7 @@ static int apply_dir_move(struct send_ct
 			dm = get_waiting_dir_move(sctx, pm->ino);
 			ASSERT(dm);
 			dm->rmdir_ino = rmdir_ino;
+			dm->rmdir_gen = rmdir_gen;
 		}
 		goto out;
 	}
@@ -3296,7 +3309,7 @@ static int apply_dir_move(struct send_ct
 		struct orphan_dir_info *odi;
 		u64 gen;
 
-		odi = get_orphan_dir_info(sctx, rmdir_ino);
+		odi = get_orphan_dir_info(sctx, rmdir_ino, rmdir_gen);
 		if (!odi) {
 			/* already deleted */
 			goto finish;


