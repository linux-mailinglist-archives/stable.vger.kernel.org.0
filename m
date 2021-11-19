Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFDC457602
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhKSRns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:43:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237198AbhKSRnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C01C61351;
        Fri, 19 Nov 2021 17:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343603;
        bh=dmEqdOsvJ3tBHkRs/OAjfpRnVQBcUKK3M9r1mu7D3vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYUG4JisjIxj5iZk9VaCFempD920upd3i7n4ywIk6VQ2K7N6m34tP6/EE0rlho6Cx
         xAK4buP23ab9WbOdACa+ZCXPWfulE0waiT2mZtgJwqyeIoUk/v9+pV+Pzf3Lb2hwni
         QFMqLMPT7+02sjf9vd3bUDnHW8cLnHPW4Yl+Gb+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 06/20] btrfs: zoned: add a dedicated data relocation block group
Date:   Fri, 19 Nov 2021 18:39:24 +0100
Message-Id: <20211119171444.859826593@linuxfoundation.org>
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

commit c2707a25562343511bf9a3a6a636a16a822204eb upstream

Relocation in a zoned filesystem can fail with a transaction abort with
error -22 (EINVAL). This happens because the relocation code assumes that
the extents we relocated the data to have the same size the source extents
had and ensures this by preallocating the extents.

But in a zoned filesystem we currently can't preallocate the extents as
this would break the sequential write required rule. Therefore it can
happen that the writeback process kicks in while we're still adding pages
to a delalloc range and starts writing out dirty pages.

This then creates destination extents that are smaller than the source
extents, triggering the following safety check in get_new_location():

 1034         if (num_bytes != btrfs_file_extent_disk_num_bytes(leaf, fi)) {
 1035                 ret = -EINVAL;
 1036                 goto out;
 1037         }

Temporarily create a dedicated block group for the relocation process, so
no non-relocation data writes can interfere with the relocation writes.

This is needed that we can switch the relocation process on a zoned
filesystem from the REQ_OP_ZONE_APPEND writing we use for data to a scheme
like in a non-zoned filesystem using REQ_OP_WRITE and preallocation.

Fixes: 32430c614844 ("btrfs: zoned: enable relocation on a zoned filesystem")
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    1 
 fs/btrfs/ctree.h       |    7 ++++++
 fs/btrfs/disk-io.c     |    1 
 fs/btrfs/extent-tree.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/zoned.c       |   10 +++++++++
 fs/btrfs/zoned.h       |    3 ++
 6 files changed, 74 insertions(+), 2 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -902,6 +902,7 @@ int btrfs_remove_block_group(struct btrf
 	spin_unlock(&cluster->refill_lock);
 
 	btrfs_clear_treelog_bg(block_group);
+	btrfs_clear_data_reloc_bg(block_group);
 
 	path = btrfs_alloc_path();
 	if (!path) {
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1017,6 +1017,13 @@ struct btrfs_fs_info {
 	spinlock_t treelog_bg_lock;
 	u64 treelog_bg;
 
+	/*
+	 * Start of the dedicated data relocation block group, protected by
+	 * relocation_bg_lock.
+	 */
+	spinlock_t relocation_bg_lock;
+	u64 data_reloc_bg;
+
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2883,6 +2883,7 @@ void btrfs_init_fs_info(struct btrfs_fs_
 	spin_lock_init(&fs_info->buffer_lock);
 	spin_lock_init(&fs_info->unused_bgs_lock);
 	spin_lock_init(&fs_info->treelog_bg_lock);
+	spin_lock_init(&fs_info->relocation_bg_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
 	mutex_init(&fs_info->unused_bg_unpin_mutex);
 	mutex_init(&fs_info->reclaim_bgs_lock);
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3495,6 +3495,9 @@ struct find_free_extent_ctl {
 	/* Allocation is called for tree-log */
 	bool for_treelog;
 
+	/* Allocation is called for data relocation */
+	bool for_data_reloc;
+
 	/* RAID index, converted from flags */
 	int index;
 
@@ -3756,6 +3759,7 @@ static int do_allocation_zoned(struct bt
 	u64 avail;
 	u64 bytenr = block_group->start;
 	u64 log_bytenr;
+	u64 data_reloc_bytenr;
 	int ret = 0;
 	bool skip;
 
@@ -3773,13 +3777,31 @@ static int do_allocation_zoned(struct bt
 	if (skip)
 		return 1;
 
+	/*
+	 * Do not allow non-relocation blocks in the dedicated relocation block
+	 * group, and vice versa.
+	 */
+	spin_lock(&fs_info->relocation_bg_lock);
+	data_reloc_bytenr = fs_info->data_reloc_bg;
+	if (data_reloc_bytenr &&
+	    ((ffe_ctl->for_data_reloc && bytenr != data_reloc_bytenr) ||
+	     (!ffe_ctl->for_data_reloc && bytenr == data_reloc_bytenr)))
+		skip = true;
+	spin_unlock(&fs_info->relocation_bg_lock);
+	if (skip)
+		return 1;
+
 	spin_lock(&space_info->lock);
 	spin_lock(&block_group->lock);
 	spin_lock(&fs_info->treelog_bg_lock);
+	spin_lock(&fs_info->relocation_bg_lock);
 
 	ASSERT(!ffe_ctl->for_treelog ||
 	       block_group->start == fs_info->treelog_bg ||
 	       fs_info->treelog_bg == 0);
+	ASSERT(!ffe_ctl->for_data_reloc ||
+	       block_group->start == fs_info->data_reloc_bg ||
+	       fs_info->data_reloc_bg == 0);
 
 	if (block_group->ro) {
 		ret = 1;
@@ -3796,6 +3818,16 @@ static int do_allocation_zoned(struct bt
 		goto out;
 	}
 
+	/*
+	 * Do not allow currently used block group to be the data relocation
+	 * dedicated block group.
+	 */
+	if (ffe_ctl->for_data_reloc && !fs_info->data_reloc_bg &&
+	    (block_group->used || block_group->reserved)) {
+		ret = 1;
+		goto out;
+	}
+
 	avail = block_group->length - block_group->alloc_offset;
 	if (avail < num_bytes) {
 		if (ffe_ctl->max_extent_size < avail) {
@@ -3813,6 +3845,9 @@ static int do_allocation_zoned(struct bt
 	if (ffe_ctl->for_treelog && !fs_info->treelog_bg)
 		fs_info->treelog_bg = block_group->start;
 
+	if (ffe_ctl->for_data_reloc && !fs_info->data_reloc_bg)
+		fs_info->data_reloc_bg = block_group->start;
+
 	ffe_ctl->found_offset = start + block_group->alloc_offset;
 	block_group->alloc_offset += num_bytes;
 	spin_lock(&ctl->tree_lock);
@@ -3829,6 +3864,9 @@ static int do_allocation_zoned(struct bt
 out:
 	if (ret && ffe_ctl->for_treelog)
 		fs_info->treelog_bg = 0;
+	if (ret && ffe_ctl->for_data_reloc)
+		fs_info->data_reloc_bg = 0;
+	spin_unlock(&fs_info->relocation_bg_lock);
 	spin_unlock(&fs_info->treelog_bg_lock);
 	spin_unlock(&block_group->lock);
 	spin_unlock(&space_info->lock);
@@ -4085,6 +4123,12 @@ static int prepare_allocation(struct btr
 				ffe_ctl->hint_byte = fs_info->treelog_bg;
 			spin_unlock(&fs_info->treelog_bg_lock);
 		}
+		if (ffe_ctl->for_data_reloc) {
+			spin_lock(&fs_info->relocation_bg_lock);
+			if (fs_info->data_reloc_bg)
+				ffe_ctl->hint_byte = fs_info->data_reloc_bg;
+			spin_unlock(&fs_info->relocation_bg_lock);
+		}
 		return 0;
 	default:
 		BUG();
@@ -4129,6 +4173,8 @@ static noinline int find_free_extent(str
 	struct btrfs_space_info *space_info;
 	bool full_search = false;
 	bool for_treelog = (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
+	bool for_data_reloc = (btrfs_is_data_reloc_root(root) &&
+				       flags & BTRFS_BLOCK_GROUP_DATA);
 
 	WARN_ON(num_bytes < fs_info->sectorsize);
 
@@ -4143,6 +4189,7 @@ static noinline int find_free_extent(str
 	ffe_ctl.found_offset = 0;
 	ffe_ctl.hint_byte = hint_byte_orig;
 	ffe_ctl.for_treelog = for_treelog;
+	ffe_ctl.for_data_reloc = for_data_reloc;
 	ffe_ctl.policy = BTRFS_EXTENT_ALLOC_CLUSTERED;
 
 	/* For clustered allocation */
@@ -4220,6 +4267,8 @@ search:
 		if (unlikely(block_group->ro)) {
 			if (for_treelog)
 				btrfs_clear_treelog_bg(block_group);
+			if (ffe_ctl.for_data_reloc)
+				btrfs_clear_data_reloc_bg(block_group);
 			continue;
 		}
 
@@ -4408,6 +4457,7 @@ int btrfs_reserve_extent(struct btrfs_ro
 	u64 flags;
 	int ret;
 	bool for_treelog = (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID);
+	bool for_data_reloc = (btrfs_is_data_reloc_root(root) && is_data);
 
 	flags = get_alloc_profile_by_root(root, is_data);
 again:
@@ -4431,8 +4481,8 @@ again:
 
 			sinfo = btrfs_find_space_info(fs_info, flags);
 			btrfs_err(fs_info,
-			"allocation failed flags %llu, wanted %llu tree-log %d",
-				  flags, num_bytes, for_treelog);
+	"allocation failed flags %llu, wanted %llu tree-log %d, relocation: %d",
+				  flags, num_bytes, for_treelog, for_data_reloc);
 			if (sinfo)
 				btrfs_dump_space_info(fs_info, sinfo,
 						      num_bytes, 1);
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1530,3 +1530,13 @@ struct btrfs_device *btrfs_zoned_get_dev
 
 	return device;
 }
+
+void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg)
+{
+	struct btrfs_fs_info *fs_info = bg->fs_info;
+
+	spin_lock(&fs_info->relocation_bg_lock);
+	if (fs_info->data_reloc_bg == bg->start)
+		fs_info->data_reloc_bg = 0;
+	spin_unlock(&fs_info->relocation_bg_lock);
+}
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -66,6 +66,7 @@ int btrfs_sync_zone_write_pointer(struct
 				  u64 physical_start, u64 physical_pos);
 struct btrfs_device *btrfs_zoned_get_device(struct btrfs_fs_info *fs_info,
 					    u64 logical, u64 length);
+void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -199,6 +200,8 @@ static inline struct btrfs_device *btrfs
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg) { }
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)


