Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9606A58BED4
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242164AbiHHBdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242063AbiHHBcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:32:17 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6E9BC08;
        Sun,  7 Aug 2022 18:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659922336; x=1691458336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Li3AcQqvWPFS5yhQcZu3nuMYh+jjP936Zdb1cpbCddU=;
  b=ZQz+yso92ROMyh14U87mk4W5zn9qfnjHohmFtz57XDzM7T8ouCxSiijp
   H5fk9pJSwbrU2m1dNFA31Mo95ql1Bweg27ziLRAQ+UK3K2h1CkVAFW4vD
   UzrH0UzuX2HZ8zxjyBa2dhXqPHYjlJYSyCZZmMMQKSWP2w/4wkaAMA2Eg
   +6Sv2RZtGyZS4lxMzUvbZiD9r4GPEjL7lJKqg+qUO/+Zc3u+6AN6Kejbg
   vRLPrd+ITUg2sV7XVgKG9+2C6VNyZtOJPlWl7npVOr68kRRHIfu4jKgh7
   IS0h6+v//ltgiqZgAqmsV5lvFnj++ubo27bS3hyG0O70lfMocXNHGGZ/B
   A==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="320180305"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 09:32:14 +0800
IronPort-SDR: phunDwEr8+AiEcsOLuyjdpaK6DLe37NL2rLW3iwfdKN9qrYMFTJOy80RgqxVjFxNvWX0OMVcUZ
 q2NabMnKf0nIiFDVerSMEXylCEB8c9r3/jkKxYq9r3qOtBdh64FUCn8boMLhWq0EVtlLwHAs2E
 xObUrDBU5PzxElrJXrNRHAv6nTijAn64yxfgPWOSCbvwKx70hfgspAO1BBlPi8xLlY1dCYBWVm
 h9cC3Y7IuJjtE0K+yZ8W+fihwCv/7dNw+tltPwtwBwtV5krRY6QfsvWIRuadTPC3uIA9NrVy/P
 hQdptdBhQc2EIFlOYL8dMSAT
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Aug 2022 17:47:55 -0700
IronPort-SDR: nsZYxloROoHb/YqIZgO0xKuEW5YV0QOmQvmLQJkDs/c9+idnllZ5b+a2WvZV5UfVNgOMumRseM
 sXh8ukomG8k1d4E20IQWIW6WG+5LoCyevsm63taFhT4Bkukg9yitm08O1eCkEhIZmNKBhT63n5
 DReWj3dRHYS0rRcScWtUAcjDLOHBz1jNoBYhu9Hqf/7pIxaL/TEQ9Sus096XIt9dJn5+AmQI1J
 Q2HM/iizXaKeEhd4RmbyBNN7GCoUOoRlYQM+Lf5fTWv/JLGe1AbSck5OXcpQzQPiYjVJ0j0ns8
 Vog=
WDCIronportException: Internal
Received: from ctl002.ad.shared (HELO naota-xeon.wdc.com) ([10.225.53.129])
  by uls-op-cesaip01.wdc.com with ESMTP; 07 Aug 2022 18:32:14 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.18 1/3] btrfs: zoned: prevent allocation from previous data relocation BG
Date:   Mon,  8 Aug 2022 10:32:08 +0900
Message-Id: <20220808013210.646680-2-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013210.646680-1-naohiro.aota@wdc.com>
References: <20220808013210.646680-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 343d8a30851c48a4ef0f5ef61d5e9fbd847a6883 upstream

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
---
 fs/btrfs/block-group.h |  1 +
 fs/btrfs/extent-tree.c | 20 ++++++++++++++++++--
 fs/btrfs/inode.c       |  2 ++
 fs/btrfs/zoned.c       | 27 +++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  5 +++++
 5 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 19db5693175f..2a0ead57db71 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -104,6 +104,7 @@ struct btrfs_block_group {
 	unsigned int relocating_repair:1;
 	unsigned int chunk_item_inserted:1;
 	unsigned int zone_is_active:1;
+	unsigned int zoned_data_reloc_ongoing:1;
 
 	int disk_cache_state;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6aa92f84f465..f45ecd939a2c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3836,7 +3836,7 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
 	       block_group->start == fs_info->data_reloc_bg ||
 	       fs_info->data_reloc_bg == 0);
 
-	if (block_group->ro) {
+	if (block_group->ro || block_group->zoned_data_reloc_ongoing) {
 		ret = 1;
 		goto out;
 	}
@@ -3898,8 +3898,24 @@ static int do_allocation_zoned(struct btrfs_block_group *block_group,
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
index 9ae79342631a..5d15e374d032 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3102,6 +3102,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->file_offset,
 						ordered_extent->file_offset +
 						logical_len);
+		btrfs_zoned_release_data_reloc_bg(fs_info, ordered_extent->disk_bytenr,
+						  ordered_extent->disk_num_bytes);
 	} else {
 		BUG_ON(root == fs_info->tree_root);
 		ret = insert_ordered_extent_file_extent(trans, ordered_extent);
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5091d679a602..2c0851d94eff 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2116,3 +2116,30 @@ void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info)
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
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 2d898970aec5..cf6320feef46 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -80,6 +80,8 @@ void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 				   struct extent_buffer *eb);
 void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
+void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
+				       u64 length);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -241,6 +243,9 @@ static inline void btrfs_schedule_zone_finish_bg(struct btrfs_block_group *bg,
 static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
 
 static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
+
+static inline void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info,
+						     u64 logical, u64 length) { }
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
-- 
2.35.1

