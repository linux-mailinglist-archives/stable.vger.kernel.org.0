Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D122A5842
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731701AbgKCUtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729958AbgKCUr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:47:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFD142242A;
        Tue,  3 Nov 2020 20:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436475;
        bh=PTbtH+8PWJljjvhIhvmy7+KlgL1SOOyQMS65T1hStak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBZdipacO/kLnr+ly/I/GbpBQH8pmQ6lwFZfNEvbu+O/p+zn3AjOSSGiz7mXFUN7u
         nm5KabFjHjkaf/4Lbdq+7k1GiHHySz5mQGaqYPTU9HII58jmm1p0xf3rEWQD1zy4ai
         4+MHi1FyqzQm2OUAwMAEju2Gdxr8MloM/0oqRQvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.9 228/391] btrfs: send, recompute reference path after orphanization of a directory
Date:   Tue,  3 Nov 2020 21:34:39 +0100
Message-Id: <20201103203402.347230284@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 9c2b4e0347067396ceb3ae929d6888c81d610259 upstream.

During an incremental send, when an inode has multiple new references we
might end up emitting rename operations for orphanizations that have a
source path that is no longer valid due to a previous orphanization of
some directory inode. This causes the receiver to fail since it tries
to rename a path that does not exists.

Example reproducer:

  $ cat reproducer.sh
  #!/bin/bash

  mkfs.btrfs -f /dev/sdi >/dev/null
  mount /dev/sdi /mnt/sdi

  touch /mnt/sdi/f1
  touch /mnt/sdi/f2
  mkdir /mnt/sdi/d1
  mkdir /mnt/sdi/d1/d2

  # Filesystem looks like:
  #
  # .                           (ino 256)
  # |----- f1                   (ino 257)
  # |----- f2                   (ino 258)
  # |----- d1/                  (ino 259)
  #        |----- d2/           (ino 260)

  btrfs subvolume snapshot -r /mnt/sdi /mnt/sdi/snap1
  btrfs send -f /tmp/snap1.send /mnt/sdi/snap1

  # Now do a series of changes such that:
  #
  # *) inode 258 has one new hardlink and the previous name changed
  #
  # *) both names conflict with the old names of two other inodes:
  #
  #    1) the new name "d1" conflicts with the old name of inode 259,
  #       under directory inode 256 (root)
  #
  #    2) the new name "d2" conflicts with the old name of inode 260
  #       under directory inode 259
  #
  # *) inodes 259 and 260 now have the old names of inode 258
  #
  # *) inode 257 is now located under inode 260 - an inode with a number
  #    smaller than the inode (258) for which we created a second hard
  #    link and swapped its names with inodes 259 and 260
  #
  ln /mnt/sdi/f2 /mnt/sdi/d1/f2_link
  mv /mnt/sdi/f1 /mnt/sdi/d1/d2/f1

  # Swap d1 and f2.
  mv /mnt/sdi/d1 /mnt/sdi/tmp
  mv /mnt/sdi/f2 /mnt/sdi/d1
  mv /mnt/sdi/tmp /mnt/sdi/f2

  # Swap d2 and f2_link
  mv /mnt/sdi/f2/d2 /mnt/sdi/tmp
  mv /mnt/sdi/f2/f2_link /mnt/sdi/f2/d2
  mv /mnt/sdi/tmp /mnt/sdi/f2/f2_link

  # Filesystem now looks like:
  #
  # .                                (ino 256)
  # |----- d1                        (ino 258)
  # |----- f2/                       (ino 259)
  #        |----- f2_link/           (ino 260)
  #        |       |----- f1         (ino 257)
  #        |
  #        |----- d2                 (ino 258)

  btrfs subvolume snapshot -r /mnt/sdi /mnt/sdi/snap2
  btrfs send -f /tmp/snap2.send -p /mnt/sdi/snap1 /mnt/sdi/snap2

  mkfs.btrfs -f /dev/sdj >/dev/null
  mount /dev/sdj /mnt/sdj

  btrfs receive -f /tmp/snap1.send /mnt/sdj
  btrfs receive -f /tmp/snap2.send /mnt/sdj

  umount /mnt/sdi
  umount /mnt/sdj

When executed the receive of the incremental stream fails:

  $ ./reproducer.sh
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap1'
  At subvol /mnt/sdi/snap1
  Create a readonly snapshot of '/mnt/sdi' in '/mnt/sdi/snap2'
  At subvol /mnt/sdi/snap2
  At subvol snap1
  At snapshot snap2
  ERROR: rename d1/d2 -> o260-6-0 failed: No such file or directory

This happens because:

1) When processing inode 257 we end up computing the name for inode 259
   because it is an ancestor in the send snapshot, and at that point it
   still has its old name, "d1", from the parent snapshot because inode
   259 was not yet processed. We then cache that name, which is valid
   until we start processing inode 259 (or set the progress to 260 after
   processing its references);

2) Later we start processing inode 258 and collecting all its new
   references into the list sctx->new_refs. The first reference in the
   list happens to be the reference for name "d1" while the reference for
   name "d2" is next (the last element of the list).
   We compute the full path "d1/d2" for this second reference and store
   it in the reference (its ->full_path member). The path used for the
   new parent directory was "d1" and not "f2" because inode 259, the
   new parent, was not yet processed;

3) When we start processing the new references at process_recorded_refs()
   we start with the first reference in the list, for the new name "d1".
   Because there is a conflicting inode that was not yet processed, which
   is directory inode 259, we orphanize it, renaming it from "d1" to
   "o259-6-0";

4) Then we start processing the new reference for name "d2", and we
   realize it conflicts with the reference of inode 260 in the parent
   snapshot. So we issue an orphanization operation for inode 260 by
   emitting a rename operation with a destination path of "o260-6-0"
   and a source path of "d1/d2" - this source path is the value we
   stored in the reference earlier at step 2), corresponding to the
   ->full_path member of the reference, however that path is no longer
   valid due to the orphanization of the directory inode 259 in step 3).
   This makes the receiver fail since the path does not exists, it should
   have been "o259-6-0/d2".

Fix this by recomputing the full path of a reference before emitting an
orphanization if we previously orphanized any directory, since that
directory could be a parent in the new path. This is a rare scenario so
keeping it simple and not checking if that previously orphanized directory
is in fact an ancestor of the inode we are trying to orphanize.

A test case for fstests follows soon.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/send.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3813,6 +3813,72 @@ static int update_ref_path(struct send_c
 }
 
 /*
+ * When processing the new references for an inode we may orphanize an existing
+ * directory inode because its old name conflicts with one of the new references
+ * of the current inode. Later, when processing another new reference of our
+ * inode, we might need to orphanize another inode, but the path we have in the
+ * reference reflects the pre-orphanization name of the directory we previously
+ * orphanized. For example:
+ *
+ * parent snapshot looks like:
+ *
+ * .                                     (ino 256)
+ * |----- f1                             (ino 257)
+ * |----- f2                             (ino 258)
+ * |----- d1/                            (ino 259)
+ *        |----- d2/                     (ino 260)
+ *
+ * send snapshot looks like:
+ *
+ * .                                     (ino 256)
+ * |----- d1                             (ino 258)
+ * |----- f2/                            (ino 259)
+ *        |----- f2_link/                (ino 260)
+ *        |       |----- f1              (ino 257)
+ *        |
+ *        |----- d2                      (ino 258)
+ *
+ * When processing inode 257 we compute the name for inode 259 as "d1", and we
+ * cache it in the name cache. Later when we start processing inode 258, when
+ * collecting all its new references we set a full path of "d1/d2" for its new
+ * reference with name "d2". When we start processing the new references we
+ * start by processing the new reference with name "d1", and this results in
+ * orphanizing inode 259, since its old reference causes a conflict. Then we
+ * move on the next new reference, with name "d2", and we find out we must
+ * orphanize inode 260, as its old reference conflicts with ours - but for the
+ * orphanization we use a source path corresponding to the path we stored in the
+ * new reference, which is "d1/d2" and not "o259-6-0/d2" - this makes the
+ * receiver fail since the path component "d1/" no longer exists, it was renamed
+ * to "o259-6-0/" when processing the previous new reference. So in this case we
+ * must recompute the path in the new reference and use it for the new
+ * orphanization operation.
+ */
+static int refresh_ref_path(struct send_ctx *sctx, struct recorded_ref *ref)
+{
+	char *name;
+	int ret;
+
+	name = kmemdup(ref->name, ref->name_len, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+
+	fs_path_reset(ref->full_path);
+	ret = get_cur_path(sctx, ref->dir, ref->dir_gen, ref->full_path);
+	if (ret < 0)
+		goto out;
+
+	ret = fs_path_add(ref->full_path, name, ref->name_len);
+	if (ret < 0)
+		goto out;
+
+	/* Update the reference's base name pointer. */
+	set_ref_path(ref, ref->full_path);
+out:
+	kfree(name);
+	return ret;
+}
+
+/*
  * This does all the move/link/unlink/rmdir magic.
  */
 static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
@@ -3946,6 +4012,12 @@ static int process_recorded_refs(struct
 				struct name_cache_entry *nce;
 				struct waiting_dir_move *wdm;
 
+				if (orphanized_dir) {
+					ret = refresh_ref_path(sctx, cur);
+					if (ret < 0)
+						goto out;
+				}
+
 				ret = orphanize_inode(sctx, ow_inode, ow_gen,
 						cur->full_path);
 				if (ret < 0)


