Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F93B330E42
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhCHMgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhCHMfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68BC96520D;
        Mon,  8 Mar 2021 12:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206950;
        bh=OcEMVJfVBt+nOephFiXn198MfIbAIiEozDK16lVr2ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6rzj5pej63DYoSLzAdMI8KiJdzjMNerwmLdKKljnLZ1pCfnntJ+uPVA5wUDTP1gJ
         4egzvDcGW2vTGquC2EoVNP5NzFBjnkQ1gHsjBj2gIT/M+ecCTmhPLqGXMy/KsZcxkR
         dwyGEG/Cpeej5fKdsAROVSEvOE5I8CI68xj9ayhU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.11 10/44] btrfs: fix race between writes to swap files and scrub
Date:   Mon,  8 Mar 2021 13:34:48 +0100
Message-Id: <20210308122719.083506823@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Filipe Manana <fdmanana@suse.com>

commit 195a49eaf655eb914896c92cecd96bc863c9feb3 upstream.

When we active a swap file, at btrfs_swap_activate(), we acquire the
exclusive operation lock to prevent the physical location of the swap
file extents to be changed by operations such as balance and device
replace/resize/remove. We also call there can_nocow_extent() which,
among other things, checks if the block group of a swap file extent is
currently RO, and if it is we can not use the extent, since a write
into it would result in COWing the extent.

However we have no protection against a scrub operation running after we
activate the swap file, which can result in the swap file extents to be
COWed while the scrub is running and operating on the respective block
group, because scrub turns a block group into RO before it processes it
and then back again to RW mode after processing it. That means an attempt
to write into a swap file extent while scrub is processing the respective
block group, will result in COWing the extent, changing its physical
location on disk.

Fix this by making sure that block groups that have extents that are used
by active swap files can not be turned into RO mode, therefore making it
not possible for a scrub to turn them into RO mode. When a scrub finds a
block group that can not be turned to RO due to the existence of extents
used by swap files, it proceeds to the next block group and logs a warning
message that mentions the block group was skipped due to active swap
files - this is the same approach we currently use for balance.

Fixes: ed46ff3d42378 ("Btrfs: support swap files")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |   33 ++++++++++++++++++++++++++++++++-
 fs/btrfs/block-group.h |    9 +++++++++
 fs/btrfs/ctree.h       |    5 +++++
 fs/btrfs/inode.c       |   19 ++++++++++++++++++-
 fs/btrfs/scrub.c       |    9 ++++++++-
 5 files changed, 72 insertions(+), 3 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1150,6 +1150,11 @@ static int inc_block_group_ro(struct btr
 	spin_lock(&sinfo->lock);
 	spin_lock(&cache->lock);
 
+	if (cache->swap_extents) {
+		ret = -ETXTBSY;
+		goto out;
+	}
+
 	if (cache->ro) {
 		cache->ro++;
 		ret = 0;
@@ -2253,7 +2258,7 @@ again:
 	}
 
 	ret = inc_block_group_ro(cache, 0);
-	if (!do_chunk_alloc)
+	if (!do_chunk_alloc || ret == -ETXTBSY)
 		goto unlock_out;
 	if (!ret)
 		goto out;
@@ -2262,6 +2267,8 @@ again:
 	if (ret < 0)
 		goto out;
 	ret = inc_block_group_ro(cache, 0);
+	if (ret == -ETXTBSY)
+		goto unlock_out;
 out:
 	if (cache->flags & BTRFS_BLOCK_GROUP_SYSTEM) {
 		alloc_flags = btrfs_get_alloc_profile(fs_info, cache->flags);
@@ -3345,6 +3352,7 @@ int btrfs_free_block_groups(struct btrfs
 		ASSERT(list_empty(&block_group->io_list));
 		ASSERT(list_empty(&block_group->bg_list));
 		ASSERT(refcount_read(&block_group->refs) == 1);
+		ASSERT(block_group->swap_extents == 0);
 		btrfs_put_block_group(block_group);
 
 		spin_lock(&info->block_group_cache_lock);
@@ -3411,3 +3419,26 @@ void btrfs_unfreeze_block_group(struct b
 		__btrfs_remove_free_space_cache(block_group->free_space_ctl);
 	}
 }
+
+bool btrfs_inc_block_group_swap_extents(struct btrfs_block_group *bg)
+{
+	bool ret = true;
+
+	spin_lock(&bg->lock);
+	if (bg->ro)
+		ret = false;
+	else
+		bg->swap_extents++;
+	spin_unlock(&bg->lock);
+
+	return ret;
+}
+
+void btrfs_dec_block_group_swap_extents(struct btrfs_block_group *bg, int amount)
+{
+	spin_lock(&bg->lock);
+	ASSERT(!bg->ro);
+	ASSERT(bg->swap_extents >= amount);
+	bg->swap_extents -= amount;
+	spin_unlock(&bg->lock);
+}
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -181,6 +181,12 @@ struct btrfs_block_group {
 	 */
 	int needs_free_space;
 
+	/*
+	 * Number of extents in this block group used for swap files.
+	 * All accesses protected by the spinlock 'lock'.
+	 */
+	int swap_extents;
+
 	/* Record locked full stripes for RAID5/6 block group */
 	struct btrfs_full_stripe_locks_tree full_stripe_locks_root;
 };
@@ -301,4 +307,7 @@ int btrfs_rmap_block(struct btrfs_fs_inf
 		     u64 physical, u64 **logical, int *naddrs, int *stripe_len);
 #endif
 
+bool btrfs_inc_block_group_swap_extents(struct btrfs_block_group *bg);
+void btrfs_dec_block_group_swap_extents(struct btrfs_block_group *bg, int amount);
+
 #endif /* BTRFS_BLOCK_GROUP_H */
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -523,6 +523,11 @@ struct btrfs_swapfile_pin {
 	 * points to a struct btrfs_device.
 	 */
 	bool is_block_group;
+	/*
+	 * Only used when 'is_block_group' is true and it is the number of
+	 * extents used by a swapfile for this block group ('ptr' field).
+	 */
+	int bg_extent_count;
 };
 
 bool btrfs_pinned_by_swapfile(struct btrfs_fs_info *fs_info, void *ptr);
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9993,6 +9993,7 @@ static int btrfs_add_swapfile_pin(struct
 	sp->ptr = ptr;
 	sp->inode = inode;
 	sp->is_block_group = is_block_group;
+	sp->bg_extent_count = 1;
 
 	spin_lock(&fs_info->swapfile_pins_lock);
 	p = &fs_info->swapfile_pins.rb_node;
@@ -10006,6 +10007,8 @@ static int btrfs_add_swapfile_pin(struct
 			   (sp->ptr == entry->ptr && sp->inode > entry->inode)) {
 			p = &(*p)->rb_right;
 		} else {
+			if (is_block_group)
+				entry->bg_extent_count++;
 			spin_unlock(&fs_info->swapfile_pins_lock);
 			kfree(sp);
 			return 1;
@@ -10031,8 +10034,11 @@ static void btrfs_free_swapfile_pins(str
 		sp = rb_entry(node, struct btrfs_swapfile_pin, node);
 		if (sp->inode == inode) {
 			rb_erase(&sp->node, &fs_info->swapfile_pins);
-			if (sp->is_block_group)
+			if (sp->is_block_group) {
+				btrfs_dec_block_group_swap_extents(sp->ptr,
+							   sp->bg_extent_count);
 				btrfs_put_block_group(sp->ptr);
+			}
 			kfree(sp);
 		}
 		node = next;
@@ -10246,6 +10252,17 @@ static int btrfs_swap_activate(struct sw
 			ret = -EINVAL;
 			goto out;
 		}
+
+		if (!btrfs_inc_block_group_swap_extents(bg)) {
+			btrfs_warn(fs_info,
+			   "block group for swapfile at %llu is read-only%s",
+			   bg->start,
+			   atomic_read(&fs_info->scrubs_running) ?
+				       " (scrub running)" : "");
+			btrfs_put_block_group(bg);
+			ret = -EINVAL;
+			goto out;
+		}
 
 		ret = btrfs_add_swapfile_pin(inode, bg, true);
 		if (ret) {
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3630,6 +3630,13 @@ int scrub_enumerate_chunks(struct scrub_
 			 * commit_transactions.
 			 */
 			ro_set = 0;
+		} else if (ret == -ETXTBSY) {
+			btrfs_warn(fs_info,
+		   "skipping scrub of block group %llu due to active swapfile",
+				   cache->start);
+			scrub_pause_off(fs_info);
+			ret = 0;
+			goto skip_unfreeze;
 		} else {
 			btrfs_warn(fs_info,
 				   "failed setting block group ro: %d", ret);
@@ -3719,7 +3726,7 @@ int scrub_enumerate_chunks(struct scrub_
 		} else {
 			spin_unlock(&cache->lock);
 		}
-
+skip_unfreeze:
 		btrfs_unfreeze_block_group(cache);
 		btrfs_put_block_group(cache);
 		if (ret)


