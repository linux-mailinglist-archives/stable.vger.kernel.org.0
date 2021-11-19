Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4674F4575F0
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhKSRnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237183AbhKSRnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E79C460D42;
        Fri, 19 Nov 2021 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343601;
        bh=v4m2LFhBtjMQJ5t5QyplKe8MfTwK7HVJRIIn7jpbh+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UnO1poB3cCvqDOEninTlNBD5aUve/xtp0bYc9kAyYlUcRnR/iQlSTWlftnm6cFwet
         CeivIBq7Yv06dUTjTLNsZ2E0eNMIa4JHxSyRvjIh/F3b2ud989SwCO3efBi76bXxFR
         nbJBPoqmWdMll4UbAc0PMpo49FYvZKbjzDeLW15c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 05/20] btrfs: introduce btrfs_is_data_reloc_root
Date:   Fri, 19 Nov 2021 18:39:23 +0100
Message-Id: <20211119171444.818189235@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 37f00a6d2e9c97d6e7b5c3d47c49b714c3d0b99f upstream

There are several places in our codebase where we check if a root is the
root of the data reloc tree and subsequent patches will introduce more.

Factor out the check into a small helper function instead of open coding
it multiple times.

Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.h       |    5 +++++
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/inode.c       |   19 ++++++++-----------
 fs/btrfs/relocation.c  |    3 +--
 5 files changed, 16 insertions(+), 15 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3842,6 +3842,11 @@ static inline bool btrfs_is_zoned(const
 	return fs_info->zoned != 0;
 }
 
+static inline bool btrfs_is_data_reloc_root(const struct btrfs_root *root)
+{
+	return root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID;
+}
+
 /*
  * We use page status Private2 to indicate there is an ordered extent with
  * unfinished IO.
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1500,7 +1500,7 @@ static int btrfs_init_fs_root(struct btr
 		goto fail;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID &&
-	    root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID) {
+	    !btrfs_is_data_reloc_root(root)) {
 		set_bit(BTRFS_ROOT_SHAREABLE, &root->state);
 		btrfs_check_and_init_root_item(&root->root_item);
 	}
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2376,7 +2376,7 @@ int btrfs_cross_ref_exist(struct btrfs_r
 
 out:
 	btrfs_free_path(path);
-	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+	if (btrfs_is_data_reloc_root(root))
 		WARN_ON(ret > 0);
 	return ret;
 }
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1151,7 +1151,7 @@ static noinline int cow_file_range(struc
 	 * fails during the stage where it updates the bytenr of file extent
 	 * items.
 	 */
-	if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+	if (btrfs_is_data_reloc_root(root))
 		min_alloc_size = num_bytes;
 	else
 		min_alloc_size = fs_info->sectorsize;
@@ -1187,8 +1187,7 @@ static noinline int cow_file_range(struc
 		if (ret)
 			goto out_drop_extent_cache;
 
-		if (root->root_key.objectid ==
-		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
+		if (btrfs_is_data_reloc_root(root)) {
 			ret = btrfs_reloc_clone_csums(inode, start,
 						      cur_alloc_size);
 			/*
@@ -1504,8 +1503,7 @@ static int fallback_to_cow(struct btrfs_
 			   int *page_started, unsigned long *nr_written)
 {
 	const bool is_space_ino = btrfs_is_free_space_inode(inode);
-	const bool is_reloc_ino = (inode->root->root_key.objectid ==
-				   BTRFS_DATA_RELOC_TREE_OBJECTID);
+	const bool is_reloc_ino = btrfs_is_data_reloc_root(inode->root);
 	const u64 range_bytes = end + 1 - start;
 	struct extent_io_tree *io_tree = &inode->io_tree;
 	u64 range_start = start;
@@ -1867,8 +1865,7 @@ out_check:
 			btrfs_dec_nocow_writers(fs_info, disk_bytenr);
 		nocow = false;
 
-		if (root->root_key.objectid ==
-		    BTRFS_DATA_RELOC_TREE_OBJECTID)
+		if (btrfs_is_data_reloc_root(root))
 			/*
 			 * Error handled later, as we must prevent
 			 * extent_clear_unlock_delalloc() in error handler
@@ -2207,7 +2204,7 @@ void btrfs_clear_delalloc_extent(struct
 		if (btrfs_is_testing(fs_info))
 			return;
 
-		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID &&
+		if (!btrfs_is_data_reloc_root(root) &&
 		    do_list && !(state->state & EXTENT_NORESERVE) &&
 		    (*bits & EXTENT_CLEAR_DATA_RESV))
 			btrfs_free_reserved_data_space_noquota(fs_info, len);
@@ -2532,7 +2529,7 @@ blk_status_t btrfs_submit_data_bio(struc
 		goto mapit;
 	} else if (async && !skip_sum) {
 		/* csum items have already been cloned */
-		if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+		if (btrfs_is_data_reloc_root(root))
 			goto mapit;
 		/* we're doing a write, do the async checksumming */
 		ret = btrfs_wq_submit_bio(inode, bio, mirror_num, bio_flags,
@@ -3304,7 +3301,7 @@ unsigned int btrfs_verify_data_csum(stru
 		u64 file_offset = pg_off + page_offset(page);
 		int ret;
 
-		if (root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID &&
+		if (btrfs_is_data_reloc_root(root) &&
 		    test_range_bit(io_tree, file_offset,
 				   file_offset + sectorsize - 1,
 				   EXTENT_NODATASUM, 1, NULL)) {
@@ -4005,7 +4002,7 @@ noinline int btrfs_update_inode(struct b
 	 * without delay
 	 */
 	if (!btrfs_is_free_space_inode(inode)
-	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
+	    && !btrfs_is_data_reloc_root(root)
 	    && !test_bit(BTRFS_FS_LOG_RECOVERING, &fs_info->flags)) {
 		btrfs_update_root_times(trans, root);
 
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4386,8 +4386,7 @@ int btrfs_reloc_cow_block(struct btrfs_t
 	if (!rc)
 		return 0;
 
-	BUG_ON(rc->stage == UPDATE_DATA_PTRS &&
-	       root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID);
+	BUG_ON(rc->stage == UPDATE_DATA_PTRS && btrfs_is_data_reloc_root(root));
 
 	level = btrfs_header_level(buf);
 	if (btrfs_header_generation(buf) <=


