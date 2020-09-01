Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97EE2594D6
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbgIAPng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731667AbgIAPne (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:43:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77383206FA;
        Tue,  1 Sep 2020 15:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975013;
        bh=Sjr8/goA5SUDV5EHxnPLgivfSrAg7FA/YC3bRLX7zfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVV6lKCES+ebxf3pSDEXFPGNJqVTB8ohn7uiU31E+v3tc7OkeqMftNIWzdnIUONqJ
         b8COcua1e5kPIGZBzHomzfCiHD9HbrdacEmoaHOSUPuPK/P3QqXowT8Y/yeOGvm1AE
         gvO+Y7OMcSw9XmXg/ruVJ+JlZVNP6+ZJ15DackGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omar Sandoval <osandov@osandov.com>,
        Boris Burkov <boris@bur.io>, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.8 175/255] btrfs: detect nocow for swap after snapshot delete
Date:   Tue,  1 Sep 2020 17:10:31 +0200
Message-Id: <20200901151009.080285230@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Burkov <boris@bur.io>

commit a84d5d429f9eb56f81b388609841ed993f0ddfca upstream.

can_nocow_extent and btrfs_cross_ref_exist both rely on a heuristic for
detecting a must cow condition which is not exactly accurate, but saves
unnecessary tree traversal. The incorrect assumption is that if the
extent was created in a generation smaller than the last snapshot
generation, it must be referenced by that snapshot. That is true, except
the snapshot could have since been deleted, without affecting the last
snapshot generation.

The original patch claimed a performance win from this check, but it
also leads to a bug where you are unable to use a swapfile if you ever
snapshotted the subvolume it's in. Make the check slower and more strict
for the swapon case, without modifying the general cow checks as a
compromise. Turning swap on does not seem to be a particularly
performance sensitive operation, so incurring a possibly unnecessary
btrfs_search_slot seems worthwhile for the added usability.

Note: Until the snapshot is competely cleaned after deletion,
check_committed_refs will still cause the logic to think that cow is
necessary, so the user must until 'btrfs subvolu sync' finished before
activating the swapfile swapon.

CC: stable@vger.kernel.org # 5.4+
Suggested-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.h       |    4 ++--
 fs/btrfs/extent-tree.c |   17 +++++++++++------
 fs/btrfs/file.c        |    2 +-
 fs/btrfs/inode.c       |   16 +++++++++-------
 4 files changed, 23 insertions(+), 16 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2468,7 +2468,7 @@ int btrfs_pin_extent_for_log_replay(stru
 				    u64 bytenr, u64 num_bytes);
 int btrfs_exclude_logged_extents(struct extent_buffer *eb);
 int btrfs_cross_ref_exist(struct btrfs_root *root,
-			  u64 objectid, u64 offset, u64 bytenr);
+			  u64 objectid, u64 offset, u64 bytenr, bool strict);
 struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     u64 parent, u64 root_objectid,
@@ -2854,7 +2854,7 @@ struct extent_map *btrfs_get_extent_fiem
 					   u64 start, u64 len);
 noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 			      u64 *orig_start, u64 *orig_block_len,
-			      u64 *ram_bytes);
+			      u64 *ram_bytes, bool strict);
 
 void __btrfs_del_delalloc_inode(struct btrfs_root *root,
 				struct btrfs_inode *inode);
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2306,7 +2306,8 @@ static noinline int check_delayed_ref(st
 
 static noinline int check_committed_ref(struct btrfs_root *root,
 					struct btrfs_path *path,
-					u64 objectid, u64 offset, u64 bytenr)
+					u64 objectid, u64 offset, u64 bytenr,
+					bool strict)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_root *extent_root = fs_info->extent_root;
@@ -2348,9 +2349,13 @@ static noinline int check_committed_ref(
 	    btrfs_extent_inline_ref_size(BTRFS_EXTENT_DATA_REF_KEY))
 		goto out;
 
-	/* If extent created before last snapshot => it's definitely shared */
-	if (btrfs_extent_generation(leaf, ei) <=
-	    btrfs_root_last_snapshot(&root->root_item))
+	/*
+	 * If extent created before last snapshot => it's shared unless the
+	 * snapshot has been deleted. Use the heuristic if strict is false.
+	 */
+	if (!strict &&
+	    (btrfs_extent_generation(leaf, ei) <=
+	     btrfs_root_last_snapshot(&root->root_item)))
 		goto out;
 
 	iref = (struct btrfs_extent_inline_ref *)(ei + 1);
@@ -2375,7 +2380,7 @@ out:
 }
 
 int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
-			  u64 bytenr)
+			  u64 bytenr, bool strict)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -2386,7 +2391,7 @@ int btrfs_cross_ref_exist(struct btrfs_r
 
 	do {
 		ret = check_committed_ref(root, path, objectid,
-					  offset, bytenr);
+					  offset, bytenr, strict);
 		if (ret && ret != -ENOENT)
 			goto out;
 
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1568,7 +1568,7 @@ int btrfs_check_can_nocow(struct btrfs_i
 	}
 
 	ret = can_nocow_extent(&inode->vfs_inode, lockstart, &num_bytes,
-			NULL, NULL, NULL);
+			NULL, NULL, NULL, false);
 	if (ret <= 0) {
 		ret = 0;
 		if (!nowait)
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1611,7 +1611,7 @@ next_slot:
 				goto out_check;
 			ret = btrfs_cross_ref_exist(root, ino,
 						    found_key.offset -
-						    extent_offset, disk_bytenr);
+						    extent_offset, disk_bytenr, false);
 			if (ret) {
 				/*
 				 * ret could be -EIO if the above fails to read
@@ -6957,7 +6957,7 @@ static struct extent_map *btrfs_new_exte
  */
 noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 			      u64 *orig_start, u64 *orig_block_len,
-			      u64 *ram_bytes)
+			      u64 *ram_bytes, bool strict)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_path *path;
@@ -7035,8 +7035,9 @@ noinline int can_nocow_extent(struct ino
 	 * Do the same check as in btrfs_cross_ref_exist but without the
 	 * unnecessary search.
 	 */
-	if (btrfs_file_extent_generation(leaf, fi) <=
-	    btrfs_root_last_snapshot(&root->root_item))
+	if (!strict &&
+	    (btrfs_file_extent_generation(leaf, fi) <=
+	     btrfs_root_last_snapshot(&root->root_item)))
 		goto out;
 
 	backref_offset = btrfs_file_extent_offset(leaf, fi);
@@ -7072,7 +7073,8 @@ noinline int can_nocow_extent(struct ino
 	 */
 
 	ret = btrfs_cross_ref_exist(root, btrfs_ino(BTRFS_I(inode)),
-				    key.offset - backref_offset, disk_bytenr);
+				    key.offset - backref_offset, disk_bytenr,
+				    strict);
 	if (ret) {
 		ret = 0;
 		goto out;
@@ -7293,7 +7295,7 @@ static int btrfs_get_blocks_direct_write
 		block_start = em->block_start + (start - em->start);
 
 		if (can_nocow_extent(inode, start, &len, &orig_start,
-				     &orig_block_len, &ram_bytes) == 1 &&
+				     &orig_block_len, &ram_bytes, false) == 1 &&
 		    btrfs_inc_nocow_writers(fs_info, block_start)) {
 			struct extent_map *em2;
 
@@ -10103,7 +10105,7 @@ static int btrfs_swap_activate(struct sw
 		free_extent_map(em);
 		em = NULL;
 
-		ret = can_nocow_extent(inode, start, &len, NULL, NULL, NULL);
+		ret = can_nocow_extent(inode, start, &len, NULL, NULL, NULL, true);
 		if (ret < 0) {
 			goto out;
 		} else if (ret) {


