Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAF658DEBB
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245749AbiHISXB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347204AbiHISV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:21:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012043191F;
        Tue,  9 Aug 2022 11:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5B04B81998;
        Tue,  9 Aug 2022 18:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A15C433B5;
        Tue,  9 Aug 2022 18:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068440;
        bh=uOqmvHyVPGr4OzJcrboci6revzGPg2fVNA1CygeyDr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGe208FmTZPJkzZhWox2qy1K46oP4rcZv5k+ELZZDLhLm4F4bjYY7fieA2FQ4cdew
         nmUp1r66NLdKq0R5PhJg/m0ph5mJWzbbgdQ1+KlbCztJp3jBADXjKHyEltrXCEBNyl
         UtcWJ3cBY0+OGtkIPxMuhVMks1l3dyTvNdwWZ8XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.18 20/35] btrfs: zoned: prevent allocation from previous data relocation BG
Date:   Tue,  9 Aug 2022 20:00:49 +0200
Message-Id: <20220809175515.790452677@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175515.046484486@linuxfoundation.org>
References: <20220809175515.046484486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 343d8a30851c48a4ef0f5ef61d5e9fbd847a6883 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.h |    1 +
 fs/btrfs/extent-tree.c |   20 ++++++++++++++++++--
 fs/btrfs/inode.c       |    2 ++
 fs/btrfs/zoned.c       |   27 +++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |    5 +++++
 5 files changed, 53 insertions(+), 2 deletions(-)

--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -104,6 +104,7 @@ struct btrfs_block_group {
 	unsigned int relocating_repair:1;
 	unsigned int chunk_item_inserted:1;
 	unsigned int zone_is_active:1;
+	unsigned int zoned_data_reloc_ongoing:1;
 
 	int disk_cache_state;
 
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3836,7 +3836,7 @@ static int do_allocation_zoned(struct bt
 	       block_group->start == fs_info->data_reloc_bg ||
 	       fs_info->data_reloc_bg == 0);
 
-	if (block_group->ro) {
+	if (block_group->ro || block_group->zoned_data_reloc_ongoing) {
 		ret = 1;
 		goto out;
 	}
@@ -3898,8 +3898,24 @@ static int do_allocation_zoned(struct bt
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
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3102,6 +3102,8 @@ static int btrfs_finish_ordered_io(struc
 						ordered_extent->file_offset,
 						ordered_extent->file_offset +
 						logical_len);
+		btrfs_zoned_release_data_reloc_bg(fs_info, ordered_extent->disk_bytenr,
+						  ordered_extent->disk_num_bytes);
 	} else {
 		BUG_ON(root == fs_info->tree_root);
 		ret = insert_ordered_extent_file_extent(trans, ordered_extent);
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2116,3 +2116,30 @@ void btrfs_free_zone_cache(struct btrfs_
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
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
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -80,6 +80,8 @@ void btrfs_schedule_zone_finish_bg(struc
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
+				       u64 length);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -241,6 +243,9 @@ static inline void btrfs_schedule_zone_f
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
+
+static inline void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info,
+						     u64 logical, u64 length) { }
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)


