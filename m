Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1526055C20E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbiF0I20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 04:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiF0I20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 04:28:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E076B24
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 01:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91688B81038
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 08:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022C4C341CB;
        Mon, 27 Jun 2022 08:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656318502;
        bh=geSBhpneKPUZY10EMaWOxiyAY+aJgNuutzsX9eYOrHE=;
        h=Subject:To:Cc:From:Date:From;
        b=ZX5xr5U015U0pQjLVVisNNi1Q8dSWZkyPLRvDG+J+ZJsdazFl/p06rFV4EaoJwbYK
         7dQk4g/veF3+0aidN8Zpm0oBRAuss1vsb1KHTbC8E4N7y1fcAXmCSUkBbs9qFA0R/m
         Cq8peBe6S+eRR9nQr/7iFDgJa8i7eY4xnWIHM1os=
Subject: FAILED: patch "[PATCH] btrfs: zoned: prevent allocation from previous data" failed to apply to 5.18-stable tree
To:     naohiro.aota@wdc.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 10:28:19 +0200
Message-ID: <165631849915181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 343d8a30851c48a4ef0f5ef61d5e9fbd847a6883 Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naohiro.aota@wdc.com>
Date: Tue, 7 Jun 2022 16:08:29 +0900
Subject: [PATCH] btrfs: zoned: prevent allocation from previous data
 relocation BG

After commit 5f0addf7b890 ("btrfs: zoned: use dedicated lock for data
relocation"), we observe IO errors on e.g, btrfs/232 like below.

  [09.0][T4038707] WARNING: CPU: 3 PID: 4038707 at fs/btrfs/extent-tree.c:2381 btrfs_cross_ref_exist+0xfc/0x120 [btrfs]
  <snip>
  [09.9][T4038707] Call Trace:
  [09.5][T4038707]  <TASK>
  [09.3][T4038707]  run_delalloc_nocow+0x7f1/0x11a0 [btrfs]
  [09.6][T4038707]  ? test_range_bit+0x174/0x320 [btrfs]
  [09.2][T4038707]  ? fallback_to_cow+0x980/0x980 [btrfs]
  [09.3][T4038707]  ? find_lock_delalloc_range+0x33e/0x3e0 [btrfs]
  [09.5][T4038707]  btrfs_run_delalloc_range+0x445/0x1320 [btrfs]
  [09.2][T4038707]  ? test_range_bit+0x320/0x320 [btrfs]
  [09.4][T4038707]  ? lock_downgrade+0x6a0/0x6a0
  [09.2][T4038707]  ? orc_find.part.0+0x1ed/0x300
  [09.5][T4038707]  ? __module_address.part.0+0x25/0x300
  [09.0][T4038707]  writepage_delalloc+0x159/0x310 [btrfs]
  <snip>
  [09.4][    C3] sd 10:0:1:0: [sde] tag#2620 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
  [09.5][    C3] sd 10:0:1:0: [sde] tag#2620 Sense Key : Illegal Request [current]
  [09.9][    C3] sd 10:0:1:0: [sde] tag#2620 Add. Sense: Unaligned write command
  [09.5][    C3] sd 10:0:1:0: [sde] tag#2620 CDB: Write(16) 8a 00 00 00 00 00 02 f3 63 87 00 00 00 2c 00 00
  [09.4][    C3] critical target error, dev sde, sector 396041272 op 0x1:(WRITE) flags 0x800 phys_seg 3 prio class 0
  [09.9][    C3] BTRFS error (device dm-1): bdev /dev/mapper/dml_102_2 errs: wr 1, rd 0, flush 0, corrupt 0, gen 0

The IO errors occur when we allocate a regular extent in previous data
relocation block group.

On zoned btrfs, we use a dedicated block group to relocate a data
extent. Thus, we allocate relocating data extents (pre-alloc) only from
the dedicated block group and vice versa. Once the free space in the
dedicated block group gets tight, a relocating extent may not fit into
the block group. In that case, we need to switch the dedicated block
group to the next one. Then, the previous one is now freed up for
allocating a regular extent. The BG is already not enough to allocate
the relocating extent, but there is still room to allocate a smaller
extent. Now the problem happens. By allocating a regular extent while
nocow IOs for the relocation is still on-going, we will issue WRITE IOs
(for relocation) and ZONE APPEND IOs (for the regular writes) at the
same time. That mixed IOs confuses the write pointer and arises the
unaligned write errors.

This commit introduces a new bit 'zoned_data_reloc_ongoing' to the
btrfs_block_group. We set this bit before releasing the dedicated block
group, and no extent are allocated from a block group having this bit
set. This bit is similar to setting block_group->ro, but is different from
it by allowing nocow writes to start.

Once all the nocow IO for relocation is done (hooked from
btrfs_finish_ordered_io), we reset the bit to release the block group for
further allocation.

Fixes: c2707a255623 ("btrfs: zoned: add a dedicated data relocation block group")
CC: stable@vger.kernel.org # 5.16+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 3ac668ace50a..35e0e860cc0b 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -104,6 +104,7 @@ struct btrfs_block_group {
 	unsigned int relocating_repair:1;
 	unsigned int chunk_item_inserted:1;
 	unsigned int zone_is_active:1;
+	unsigned int zoned_data_reloc_ongoing:1;
 
 	int disk_cache_state;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fb367689d9d2..4515497d8a29 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3832,7 +3832,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	       block_group->start == fs_info->data_reloc_bg ||
 	       fs_info->data_reloc_bg == 0);
 
-	if (block_group->ro) {
+	if (block_group->ro || block_group->zoned_data_reloc_ongoing) {
 		ret = 1;
 		goto out;
 	}
@@ -3894,8 +3894,24 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 out:
 	if (ret && ffe_ctl->for_treelog)
 		fs_info->treelog_bg = 0;
-	if (ret && ffe_ctl->for_data_reloc)
+	if (ret && ffe_ctl->for_data_reloc &&
+	    fs_info->data_reloc_bg == block_group->start) {
+		/*
+		 * Do not allow further allocations from this block group.
+		 * Compared to increasing the ->ro, setting the
+		 * ->zoned_data_reloc_ongoing flag still allows nocow
+		 *  writers to come in. See btrfs_inc_nocow_writers().
+		 *
+		 * We need to disable an allocation to avoid an allocation of
+		 * regular (non-relocation data) extent. With mix of relocation
+		 * extents and regular extents, we can dispatch WRITE commands
+		 * (for relocation extents) and ZONE APPEND commands (for
+		 * regular extents) at the same time to the same zone, which
+		 * easily break the write pointer.
+		 */
+		block_group->zoned_data_reloc_ongoing = 1;
 		fs_info->data_reloc_bg = 0;
+	}
 	spin_unlock(&fs_info->relocation_bg_lock);
 	spin_unlock(&fs_info->treelog_bg_lock);
 	spin_unlock(&block_group->lock);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a642d34c1363..ba527da61732 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3195,6 +3195,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->file_offset,
 						ordered_extent->file_offset +
 						logical_len);
+		btrfs_zoned_release_data_reloc_bg(fs_info, ordered_extent->disk_bytenr,
+						  ordered_extent->disk_num_bytes);
 	} else {
 		BUG_ON(root == fs_info->tree_root);
 		ret = insert_ordered_extent_file_extent(trans, ordered_extent);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 057babaa3e05..8aec53528efa 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2140,3 +2140,30 @@ bool btrfs_zoned_should_reclaim(struct btrfs_fs_info *fs_info)
 	factor = div64_u64(used * 100, total);
 	return factor >= fs_info->bg_reclaim_threshold;
 }
+
+void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
+				       u64 length)
+{
+	struct btrfs_block_group *block_group;
+
+	if (!btrfs_is_zoned(fs_info))
+		return;
+
+	block_group = btrfs_lookup_block_group(fs_info, logical);
+	/* It should be called on a previous data relocation block group. */
+	ASSERT(block_group && (block_group->flags & BTRFS_BLOCK_GROUP_DATA));
+
+	spin_lock(&block_group->lock);
+	if (!block_group->zoned_data_reloc_ongoing)
+		goto out;
+
+	/* All relocation extents are written. */
+	if (block_group->start + block_group->alloc_offset == logical + length) {
+		/* Now, release this block group for further allocations. */
+		block_group->zoned_data_reloc_ongoing = 0;
+	}
+
+out:
+	spin_unlock(&block_group->lock);
+	btrfs_put_block_group(block_group);
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index bb1a189e11f9..6b2eec99162b 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -77,6 +77,8 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 bool btrfs_zoned_should_reclaim(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
+				       u64 length);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -243,6 +245,9 @@ static inline bool btrfs_zoned_should_reclaim(struct btrfs_fs_info *fs_info)
 {
 	return false;
 }
+
+static inline void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info,
+						     u64 logical, u64 length) { }
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)

