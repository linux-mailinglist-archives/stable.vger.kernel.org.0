Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BC7594812
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245019AbiHOXYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243106AbiHOXW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:22:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5716BD5B;
        Mon, 15 Aug 2022 13:05:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84486B80EAB;
        Mon, 15 Aug 2022 20:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F50C433D6;
        Mon, 15 Aug 2022 20:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593929;
        bh=/MzQJ5n7+F1uV7sadg9ptua/nEpjYv7/PHCeA+5hmCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6+p9EvamKd+vUXSes+GSebPLNWlfSc3S7VARueU/F3JoR6k6s2uzLmB6U0Fbomwz
         0v2rSIj2i4U3w7QK3YxqwGRkVlDhuQUqe40hNyBoFgP3GDfTy29QCQ0xMYsUE2RnPp
         lWLtnSNlm8GtXSwGgZlIK+Y/Wi4Dr5dx90d3Ldv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1030/1095] btrfs: zoned: write out partially allocated region
Date:   Mon, 15 Aug 2022 20:07:09 +0200
Message-Id: <20220815180511.664298207@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 898793d992c23dac6126a6a94ad893eae1a2c9df ]

cow_file_range() works in an all-or-nothing way: if it fails to allocate an
extent for a part of the given region, it gives up all the region including
the successfully allocated parts. On cow_file_range(), run_delalloc_zoned()
writes data for the region only when it successfully allocate all the
region.

This all-or-nothing allocation and write-out are problematic when available
space in all the block groups are get tight with the active zone
restriction. btrfs_reserve_extent() try hard to utilize the left space in
the active block groups and gives up finally and fails with
-ENOSPC. However, if we send IOs for the successfully allocated region, we
can finish a zone and can continue on the rest of the allocation on a newly
allocated block group.

This patch implements the partial write-out for run_delalloc_zoned(). With
this patch applied, cow_file_range() returns -EAGAIN to tell the caller to
do something to progress the further allocation, and tells the successfully
allocated region with done_offset. Furthermore, the zoned extent allocator
returns -EAGAIN to tell cow_file_range() going back to the caller side.

Actually, we still need to wait for an IO to complete to continue the
allocation. The next patch implements that part.

CC: stable@vger.kernel.org # 5.16+
Fixes: afba2bc036b0 ("btrfs: zoned: implement active zone tracking")
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 10 +++++++
 fs/btrfs/inode.c       | 63 ++++++++++++++++++++++++++++++++----------
 2 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 56185541e188..eee68a6f2be7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4015,6 +4015,16 @@ static int can_allocate_chunk_zoned(struct btrfs_fs_info *fs_info,
 	if (ffe_ctl->max_extent_size >= ffe_ctl->min_alloc_size)
 		return -ENOSPC;
 
+	/*
+	 * Even min_alloc_size is not left in any block groups. Since we cannot
+	 * activate a new block group, allocating it may not help. Let's tell a
+	 * caller to try again and hope it progress something by writing some
+	 * parts of the region. That is only possible for data block groups,
+	 * where a part of the region can be written.
+	 */
+	if (ffe_ctl->flags & BTRFS_BLOCK_GROUP_DATA)
+		return -EAGAIN;
+
 	/*
 	 * We cannot activate a new block group and no enough space left in any
 	 * block groups. So, allocating a new block group may not help. But,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c50288d90c66..9753fc47e488 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -92,7 +92,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
 static noinline int cow_file_range(struct btrfs_inode *inode,
 				   struct page *locked_page,
 				   u64 start, u64 end, int *page_started,
-				   unsigned long *nr_written, int unlock);
+				   unsigned long *nr_written, int unlock,
+				   u64 *done_offset);
 static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
 				       u64 len, u64 orig_start, u64 block_start,
 				       u64 block_len, u64 orig_block_len,
@@ -884,7 +885,7 @@ static int submit_uncompressed_range(struct btrfs_inode *inode,
 	 * can directly submit them without interruption.
 	 */
 	ret = cow_file_range(inode, locked_page, start, end, &page_started,
-			     &nr_written, 0);
+			     &nr_written, 0, NULL);
 	/* Inline extent inserted, page gets unlocked and everything is done */
 	if (page_started) {
 		ret = 0;
@@ -1133,7 +1134,8 @@ static u64 get_extent_allocation_hint(struct btrfs_inode *inode, u64 start,
 static noinline int cow_file_range(struct btrfs_inode *inode,
 				   struct page *locked_page,
 				   u64 start, u64 end, int *page_started,
-				   unsigned long *nr_written, int unlock)
+				   unsigned long *nr_written, int unlock,
+				   u64 *done_offset)
 {
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -1326,6 +1328,21 @@ static noinline int cow_file_range(struct btrfs_inode *inode,
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 1);
 out_unlock:
+	/*
+	 * If done_offset is non-NULL and ret == -EAGAIN, we expect the
+	 * caller to write out the successfully allocated region and retry.
+	 */
+	if (done_offset && ret == -EAGAIN) {
+		if (orig_start < start)
+			*done_offset = start - 1;
+		else
+			*done_offset = start;
+		return ret;
+	} else if (ret == -EAGAIN) {
+		/* Convert to -ENOSPC since the caller cannot retry. */
+		ret = -ENOSPC;
+	}
+
 	/*
 	 * Now, we have three regions to clean up:
 	 *
@@ -1571,19 +1588,37 @@ static noinline int run_delalloc_zoned(struct btrfs_inode *inode,
 				       u64 end, int *page_started,
 				       unsigned long *nr_written)
 {
+	u64 done_offset = end;
 	int ret;
+	bool locked_page_done = false;
 
-	ret = cow_file_range(inode, locked_page, start, end, page_started,
-			     nr_written, 0);
-	if (ret)
-		return ret;
+	while (start <= end) {
+		ret = cow_file_range(inode, locked_page, start, end, page_started,
+				     nr_written, 0, &done_offset);
+		if (ret && ret != -EAGAIN)
+			return ret;
 
-	if (*page_started)
-		return 0;
+		if (*page_started) {
+			ASSERT(ret == 0);
+			return 0;
+		}
+
+		if (ret == 0)
+			done_offset = end;
+
+		if (done_offset == start)
+			return -ENOSPC;
+
+		if (!locked_page_done) {
+			__set_page_dirty_nobuffers(locked_page);
+			account_page_redirty(locked_page);
+		}
+		locked_page_done = true;
+		extent_write_locked_range(&inode->vfs_inode, start, done_offset);
+
+		start = done_offset + 1;
+	}
 
-	__set_page_dirty_nobuffers(locked_page);
-	account_page_redirty(locked_page);
-	extent_write_locked_range(&inode->vfs_inode, start, end);
 	*page_started = 1;
 
 	return 0;
@@ -1675,7 +1710,7 @@ static int fallback_to_cow(struct btrfs_inode *inode, struct page *locked_page,
 	}
 
 	return cow_file_range(inode, locked_page, start, end, page_started,
-			      nr_written, 1);
+			      nr_written, 1, NULL);
 }
 
 /*
@@ -2086,7 +2121,7 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct page *locked_page
 						 page_started, nr_written);
 		else
 			ret = cow_file_range(inode, locked_page, start, end,
-					     page_started, nr_written, 1);
+					     page_started, nr_written, 1, NULL);
 	} else {
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT, &inode->runtime_flags);
 		ret = cow_file_range_async(inode, wbc, locked_page, start, end,
-- 
2.35.1



