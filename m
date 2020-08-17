Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D45B246AF6
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730783AbgHQPqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730588AbgHQPp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:45:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F21BC2065D;
        Mon, 17 Aug 2020 15:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679157;
        bh=3k/Pe+4EocyDAyYj8y3w2fHBZq5GRyGyCLp0ggDHjlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SY1XGQb+y67cS/fJXEh90n1sSnC9XRb421WwO67S9Ve9ZE86aP86oIUudHD5cuKgP
         OdP78QNvb3TJeVfCty09WTQI/TErJRNqf6F0qthQswq4x6e2kEpUiKmAMDA+peJLG2
         RXN8LPAcmLdEMh9Vgfv6LFbeXi1ThQwelXV92tkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Doucha <martin.doucha@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 115/393] btrfs: allow btrfs_truncate_block() to fallback to nocow for data space reservation
Date:   Mon, 17 Aug 2020 17:12:45 +0200
Message-Id: <20200817143825.194095599@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 6d4572a9d71d5fc2affee0258d8582d39859188c ]

[BUG]
When the data space is exhausted, even if the inode has NOCOW attribute,
we will still refuse to truncate unaligned range due to ENOSPC.

The following script can reproduce it pretty easily:
  #!/bin/bash

  dev=/dev/test/test
  mnt=/mnt/btrfs

  umount $dev &> /dev/null
  umount $mnt &> /dev/null

  mkfs.btrfs -f $dev -b 1G
  mount -o nospace_cache $dev $mnt
  touch $mnt/foobar
  chattr +C $mnt/foobar

  xfs_io -f -c "pwrite -b 4k 0 4k" $mnt/foobar > /dev/null
  xfs_io -f -c "pwrite -b 4k 0 1G" $mnt/padding &> /dev/null
  sync

  xfs_io -c "fpunch 0 2k" $mnt/foobar
  umount $mnt

Currently this will fail at the fpunch part.

[CAUSE]
Because btrfs_truncate_block() always reserves space without checking
the NOCOW attribute.

Since the writeback path follows NOCOW bit, we only need to bother the
space reservation code in btrfs_truncate_block().

[FIX]
Make btrfs_truncate_block() follow btrfs_buffered_write() to try to
reserve data space first, and fall back to NOCOW check only when we
don't have enough space.

Such always-try-reserve is an optimization introduced in
btrfs_buffered_write(), to avoid expensive btrfs_check_can_nocow() call.

This patch will export check_can_nocow() as btrfs_check_can_nocow(), and
use it in btrfs_truncate_block() to fix the problem.

Reported-by: Martin Doucha <martin.doucha@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h |  2 ++
 fs/btrfs/file.c  | 12 ++++++------
 fs/btrfs/inode.c | 44 +++++++++++++++++++++++++++++++++++++-------
 3 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 09e6dff8a8f85..68bd89e3d4f09 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2982,6 +2982,8 @@ int btrfs_dirty_pages(struct inode *inode, struct page **pages,
 		      size_t num_pages, loff_t pos, size_t write_bytes,
 		      struct extent_state **cached);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
+int btrfs_check_can_nocow(struct btrfs_inode *inode, loff_t pos,
+			  size_t *write_bytes, bool nowait);
 
 /* tree-defrag.c */
 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 93244934d4f92..1e1af0ce70771 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1540,8 +1540,8 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 	return ret;
 }
 
-static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
-				    size_t *write_bytes, bool nowait)
+int btrfs_check_can_nocow(struct btrfs_inode *inode, loff_t pos,
+			  size_t *write_bytes, bool nowait)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_root *root = inode->root;
@@ -1656,8 +1656,8 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		if (ret < 0) {
 			if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 						      BTRFS_INODE_PREALLOC)) &&
-			    check_can_nocow(BTRFS_I(inode), pos,
-					    &write_bytes, false) > 0) {
+			    btrfs_check_can_nocow(BTRFS_I(inode), pos,
+						  &write_bytes, false) > 0) {
 				/*
 				 * For nodata cow case, no need to reserve
 				 * data space.
@@ -1936,8 +1936,8 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
 		 */
 		if (!(BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
 					      BTRFS_INODE_PREALLOC)) ||
-		    check_can_nocow(BTRFS_I(inode), pos, &nocow_bytes,
-				    true) <= 0) {
+		    btrfs_check_can_nocow(BTRFS_I(inode), pos, &nocow_bytes,
+					  true) <= 0) {
 			inode_unlock(inode);
 			return -EAGAIN;
 		}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e7bdda3ed069b..6cb3dc2748974 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4520,11 +4520,13 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	struct extent_state *cached_state = NULL;
 	struct extent_changeset *data_reserved = NULL;
 	char *kaddr;
+	bool only_release_metadata = false;
 	u32 blocksize = fs_info->sectorsize;
 	pgoff_t index = from >> PAGE_SHIFT;
 	unsigned offset = from & (blocksize - 1);
 	struct page *page;
 	gfp_t mask = btrfs_alloc_write_mask(mapping);
+	size_t write_bytes = blocksize;
 	int ret = 0;
 	u64 block_start;
 	u64 block_end;
@@ -4536,11 +4538,27 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	block_start = round_down(from, blocksize);
 	block_end = block_start + blocksize - 1;
 
-	ret = btrfs_delalloc_reserve_space(inode, &data_reserved,
-					   block_start, blocksize);
-	if (ret)
-		goto out;
 
+	ret = btrfs_check_data_free_space(inode, &data_reserved, block_start,
+					  blocksize);
+	if (ret < 0) {
+		if ((BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
+					      BTRFS_INODE_PREALLOC)) &&
+		    btrfs_check_can_nocow(BTRFS_I(inode), block_start,
+					  &write_bytes, false) > 0) {
+			/* For nocow case, no need to reserve data space */
+			only_release_metadata = true;
+		} else {
+			goto out;
+		}
+	}
+	ret = btrfs_delalloc_reserve_metadata(BTRFS_I(inode), blocksize);
+	if (ret < 0) {
+		if (!only_release_metadata)
+			btrfs_free_reserved_data_space(inode, data_reserved,
+					block_start, blocksize);
+		goto out;
+	}
 again:
 	page = find_or_create_page(mapping, index, mask);
 	if (!page) {
@@ -4609,14 +4627,26 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 	set_page_dirty(page);
 	unlock_extent_cached(io_tree, block_start, block_end, &cached_state);
 
+	if (only_release_metadata)
+		set_extent_bit(&BTRFS_I(inode)->io_tree, block_start,
+				block_end, EXTENT_NORESERVE, NULL, NULL,
+				GFP_NOFS);
+
 out_unlock:
-	if (ret)
-		btrfs_delalloc_release_space(inode, data_reserved, block_start,
-					     blocksize, true);
+	if (ret) {
+		if (only_release_metadata)
+			btrfs_delalloc_release_metadata(BTRFS_I(inode),
+					blocksize, true);
+		else
+			btrfs_delalloc_release_space(inode, data_reserved,
+					block_start, blocksize, true);
+	}
 	btrfs_delalloc_release_extents(BTRFS_I(inode), blocksize);
 	unlock_page(page);
 	put_page(page);
 out:
+	if (only_release_metadata)
+		btrfs_drew_write_unlock(&BTRFS_I(inode)->root->snapshot_lock);
 	extent_changeset_free(data_reserved);
 	return ret;
 }
-- 
2.25.1



