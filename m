Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B09D5FB5DA
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiJKPAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiJKO5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:57:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8D19DF9D;
        Tue, 11 Oct 2022 07:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB620CE1884;
        Tue, 11 Oct 2022 14:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E58C433C1;
        Tue, 11 Oct 2022 14:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499934;
        bh=NKHmMtTJIlZQ2G0cLARMPeuKw8PR1Rk2F8vUThi4kJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiPbwKLmBxavgM6haZg0NFmY1/WmtYb6te47YbPOGuU+Mdw0BCr5yvyu6U+BtP8ED
         Rv62dN6J34vNU9pjlb9K8B/Y2Yojy+DBIrEPzw45dnXq56BqV6JpIczBK53wfbyCOF
         8Jl0ySzRVWE++XuOsyZMTMaC/IEx+lbY9lZLFr0nDKo0Sjrs7T69OZKerfO9LxLmMo
         UTSnbRHHQi0fPifdvCkcXJFUYN5gGSdMw1KtT9p6Fy29FSkHKGYLz52OCdlgldl5sw
         ioHcg7B76AHcSGfrE3kwyFIkxNcnfPT/IgMvl6sWK/182P78rXFtOn68JX/wWx6PqR
         CIV8I2kfECNdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 28/40] btrfs: get rid of block group caching progress logic
Date:   Tue, 11 Oct 2022 10:51:17 -0400
Message-Id: <20221011145129.1623487-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit 48ff70830bec1ccc714f4e31059df737f17ec909 ]

struct btrfs_caching_ctl::progress and struct
btrfs_block_group::last_byte_to_unpin were previously needed to ensure
that unpin_extent_range() didn't return a range to the free space cache
before the caching thread had a chance to cache that range. However, the
commit "btrfs: fix space cache corruption and potential double
allocations" made it so that we always synchronously cache the block
group at the time that we pin the extent, so this machinery is no longer
necessary.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c     | 13 ------------
 fs/btrfs/block-group.h     |  2 --
 fs/btrfs/extent-tree.c     |  9 ++-------
 fs/btrfs/free-space-tree.c |  8 --------
 fs/btrfs/transaction.c     | 41 --------------------------------------
 fs/btrfs/zoned.c           |  1 -
 6 files changed, 2 insertions(+), 72 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index a8ecd83abb11..b6b60da4270c 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -593,8 +593,6 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 
 			if (need_resched() ||
 			    rwsem_is_contended(&fs_info->commit_root_sem)) {
-				if (wakeup)
-					caching_ctl->progress = last;
 				btrfs_release_path(path);
 				up_read(&fs_info->commit_root_sem);
 				mutex_unlock(&caching_ctl->mutex);
@@ -618,9 +616,6 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 			key.objectid = last;
 			key.offset = 0;
 			key.type = BTRFS_EXTENT_ITEM_KEY;
-
-			if (wakeup)
-				caching_ctl->progress = last;
 			btrfs_release_path(path);
 			goto next;
 		}
@@ -655,7 +650,6 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 
 	total_found += add_new_free_space(block_group, last,
 				block_group->start + block_group->length);
-	caching_ctl->progress = (u64)-1;
 
 out:
 	btrfs_free_path(path);
@@ -725,8 +719,6 @@ static noinline void caching_thread(struct btrfs_work *work)
 	}
 #endif
 
-	caching_ctl->progress = (u64)-1;
-
 	up_read(&fs_info->commit_root_sem);
 	btrfs_free_excluded_extents(block_group);
 	mutex_unlock(&caching_ctl->mutex);
@@ -755,7 +747,6 @@ int btrfs_cache_block_group(struct btrfs_block_group *cache, bool wait)
 	mutex_init(&caching_ctl->mutex);
 	init_waitqueue_head(&caching_ctl->wait);
 	caching_ctl->block_group = cache;
-	caching_ctl->progress = cache->start;
 	refcount_set(&caching_ctl->count, 2);
 	btrfs_init_work(&caching_ctl->work, caching_thread, NULL, NULL);
 
@@ -2079,11 +2070,9 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 		/* Should not have any excluded extents. Just in case, though. */
 		btrfs_free_excluded_extents(cache);
 	} else if (cache->length == cache->used) {
-		cache->last_byte_to_unpin = (u64)-1;
 		cache->cached = BTRFS_CACHE_FINISHED;
 		btrfs_free_excluded_extents(cache);
 	} else if (cache->used == 0) {
-		cache->last_byte_to_unpin = (u64)-1;
 		cache->cached = BTRFS_CACHE_FINISHED;
 		add_new_free_space(cache, cache->start,
 				   cache->start + cache->length);
@@ -2147,7 +2136,6 @@ static int fill_dummy_bgs(struct btrfs_fs_info *fs_info)
 		/* Fill dummy cache as FULL */
 		bg->length = em->len;
 		bg->flags = map->type;
-		bg->last_byte_to_unpin = (u64)-1;
 		bg->cached = BTRFS_CACHE_FINISHED;
 		bg->used = em->len;
 		bg->flags = map->type;
@@ -2495,7 +2483,6 @@ struct btrfs_block_group *btrfs_make_block_group(struct btrfs_trans_handle *tran
 	set_free_space_tree_thresholds(cache);
 	cache->used = bytes_used;
 	cache->flags = type;
-	cache->last_byte_to_unpin = (u64)-1;
 	cache->cached = BTRFS_CACHE_FINISHED;
 	cache->global_root_id = calculate_global_root_id(fs_info, cache->start);
 
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 6b3cdc4cbc41..817b52ff4f7a 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -52,7 +52,6 @@ struct btrfs_caching_control {
 	wait_queue_head_t wait;
 	struct btrfs_work work;
 	struct btrfs_block_group *block_group;
-	u64 progress;
 	refcount_t count;
 };
 
@@ -111,7 +110,6 @@ struct btrfs_block_group {
 	/* Cache tracking stuff */
 	int cached;
 	struct btrfs_caching_control *caching_ctl;
-	u64 last_byte_to_unpin;
 
 	struct btrfs_space_info *space_info;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 92f3f5ed8bf1..48601ee08060 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2702,13 +2702,8 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 		len = cache->start + cache->length - start;
 		len = min(len, end + 1 - start);
 
-		down_read(&fs_info->commit_root_sem);
-		if (start < cache->last_byte_to_unpin && return_free_space) {
-			u64 add_len = min(len, cache->last_byte_to_unpin - start);
-
-			btrfs_add_free_space(cache, start, add_len);
-		}
-		up_read(&fs_info->commit_root_sem);
+		if (return_free_space)
+			btrfs_add_free_space(cache, start, len);
 
 		start += len;
 		total_unpinned += len;
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 1bf89aa67216..367bcfcf68f5 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1453,8 +1453,6 @@ static int load_free_space_bitmaps(struct btrfs_caching_control *caching_ctl,
 		ASSERT(key.type == BTRFS_FREE_SPACE_BITMAP_KEY);
 		ASSERT(key.objectid < end && key.objectid + key.offset <= end);
 
-		caching_ctl->progress = key.objectid;
-
 		offset = key.objectid;
 		while (offset < key.objectid + key.offset) {
 			bit = free_space_test_bit(block_group, path, offset);
@@ -1490,8 +1488,6 @@ static int load_free_space_bitmaps(struct btrfs_caching_control *caching_ctl,
 		goto out;
 	}
 
-	caching_ctl->progress = (u64)-1;
-
 	ret = 0;
 out:
 	return ret;
@@ -1531,8 +1527,6 @@ static int load_free_space_extents(struct btrfs_caching_control *caching_ctl,
 		ASSERT(key.type == BTRFS_FREE_SPACE_EXTENT_KEY);
 		ASSERT(key.objectid < end && key.objectid + key.offset <= end);
 
-		caching_ctl->progress = key.objectid;
-
 		total_found += add_new_free_space(block_group, key.objectid,
 						  key.objectid + key.offset);
 		if (total_found > CACHING_CTL_WAKE_UP) {
@@ -1552,8 +1546,6 @@ static int load_free_space_extents(struct btrfs_caching_control *caching_ctl,
 		goto out;
 	}
 
-	caching_ctl->progress = (u64)-1;
-
 	ret = 0;
 out:
 	return ret;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 875b801ab3d7..cb4a84dca46b 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -160,7 +160,6 @@ static noinline void switch_commit_roots(struct btrfs_trans_handle *trans)
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root, *tmp;
-	struct btrfs_caching_control *caching_ctl, *next;
 
 	/*
 	 * At this point no one can be using this transaction to modify any tree
@@ -195,46 +194,6 @@ static noinline void switch_commit_roots(struct btrfs_trans_handle *trans)
 	}
 	spin_unlock(&cur_trans->dropped_roots_lock);
 
-	/*
-	 * We have to update the last_byte_to_unpin under the commit_root_sem,
-	 * at the same time we swap out the commit roots.
-	 *
-	 * This is because we must have a real view of the last spot the caching
-	 * kthreads were while caching.  Consider the following views of the
-	 * extent tree for a block group
-	 *
-	 * commit root
-	 * +----+----+----+----+----+----+----+
-	 * |\\\\|    |\\\\|\\\\|    |\\\\|\\\\|
-	 * +----+----+----+----+----+----+----+
-	 * 0    1    2    3    4    5    6    7
-	 *
-	 * new commit root
-	 * +----+----+----+----+----+----+----+
-	 * |    |    |    |\\\\|    |    |\\\\|
-	 * +----+----+----+----+----+----+----+
-	 * 0    1    2    3    4    5    6    7
-	 *
-	 * If the cache_ctl->progress was at 3, then we are only allowed to
-	 * unpin [0,1) and [2,3], because the caching thread has already
-	 * processed those extents.  We are not allowed to unpin [5,6), because
-	 * the caching thread will re-start it's search from 3, and thus find
-	 * the hole from [4,6) to add to the free space cache.
-	 */
-	write_lock(&fs_info->block_group_cache_lock);
-	list_for_each_entry_safe(caching_ctl, next,
-				 &fs_info->caching_block_groups, list) {
-		struct btrfs_block_group *cache = caching_ctl->block_group;
-
-		if (btrfs_block_group_done(cache)) {
-			cache->last_byte_to_unpin = (u64)-1;
-			list_del_init(&caching_ctl->list);
-			btrfs_put_caching_control(caching_ctl);
-		} else {
-			cache->last_byte_to_unpin = caching_ctl->progress;
-		}
-	}
-	write_unlock(&fs_info->block_group_cache_lock);
 	up_write(&fs_info->commit_root_sem);
 }
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 4448b7b6ea22..f88dd6956072 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1563,7 +1563,6 @@ void btrfs_calc_zone_unusable(struct btrfs_block_group *cache)
 	free = cache->zone_capacity - cache->alloc_offset;
 
 	/* We only need ->free_space in ALLOC_SEQ block groups */
-	cache->last_byte_to_unpin = (u64)-1;
 	cache->cached = BTRFS_CACHE_FINISHED;
 	cache->free_space_ctl->free_space = free;
 	cache->zone_unusable = unusable;
-- 
2.35.1

