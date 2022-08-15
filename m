Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3367594923
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243551AbiHOXX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353346AbiHOXWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:22:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33F014C34A;
        Mon, 15 Aug 2022 13:05:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52A2FB81135;
        Mon, 15 Aug 2022 20:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C5AC433D7;
        Mon, 15 Aug 2022 20:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593908;
        bh=VpCDzShdxFhdZnxU+YYKI2qg0GUWCXpqqGVdw0mJvoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pI5VN2DY5/vYCzZMRPBHUVn/EyIW3q9j6tliB/vAzPnPveRGemKqMbJbuTTOYjQ+k
         8jhyqzkPRRdLZsYwL/iTM71pSxPOafQUeemRBSztUb23F+g34IWQB3gpDPJFnvSPRY
         qKmco9NSCQxQ/HJtqm8FoAa8etSdCGm6ZBnaBm5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1027/1095] btrfs: zoned: introduce space_info->active_total_bytes
Date:   Mon, 15 Aug 2022 20:07:06 +0200
Message-Id: <20220815180511.534462522@linuxfoundation.org>
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

[ Upstream commit 6a921de589926a350634e6e279f43fa5b9dbf5ba ]

The active_total_bytes, like the total_bytes, accounts for the total bytes
of active block groups in the space_info.

With an introduction of active_total_bytes, we can check if the reserved
bytes can be written to the block groups without activating a new block
group. The check is necessary for metadata allocation on zoned
filesystem. We cannot finish a block group, which may require waiting
for the current transaction, from the metadata allocation context.
Instead, we need to ensure the ongoing allocation (reserved bytes) fits
in active block groups.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 12 +++++++++---
 fs/btrfs/space-info.c  | 41 ++++++++++++++++++++++++++++++++---------
 fs/btrfs/space-info.h  |  4 +++-
 fs/btrfs/zoned.c       |  6 ++++++
 4 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 1deca5164c23..88f59a2e4113 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1033,8 +1033,13 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			< block_group->zone_unusable);
 		WARN_ON(block_group->space_info->disk_total
 			< block_group->length * factor);
+		WARN_ON(block_group->zone_is_active &&
+			block_group->space_info->active_total_bytes
+			< block_group->length);
 	}
 	block_group->space_info->total_bytes -= block_group->length;
+	if (block_group->zone_is_active)
+		block_group->space_info->active_total_bytes -= block_group->length;
 	block_group->space_info->bytes_readonly -=
 		(block_group->length - block_group->zone_unusable);
 	block_group->space_info->bytes_zone_unusable -=
@@ -2102,7 +2107,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 	trace_btrfs_add_block_group(info, cache, 0);
 	btrfs_update_space_info(info, cache->flags, cache->length,
 				cache->used, cache->bytes_super,
-				cache->zone_unusable, &space_info);
+				cache->zone_unusable, cache->zone_is_active,
+				&space_info);
 
 	cache->space_info = space_info;
 
@@ -2172,7 +2178,7 @@ static int fill_dummy_bgs(struct btrfs_fs_info *fs_info)
 		}
 
 		btrfs_update_space_info(fs_info, bg->flags, em->len, em->len,
-					0, 0, &space_info);
+					0, 0, false, &space_info);
 		bg->space_info = space_info;
 		link_block_group(bg);
 
@@ -2553,7 +2559,7 @@ struct btrfs_block_group *btrfs_make_block_group(struct btrfs_trans_handle *tran
 	trace_btrfs_add_block_group(fs_info, cache, 1);
 	btrfs_update_space_info(fs_info, cache->flags, size, bytes_used,
 				cache->bytes_super, cache->zone_unusable,
-				&cache->space_info);
+				cache->zone_is_active, &cache->space_info);
 	btrfs_update_global_block_rsv(fs_info);
 
 	link_block_group(cache);
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 98a84b523be6..4867199cf983 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -295,7 +295,7 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
 void btrfs_update_space_info(struct btrfs_fs_info *info, u64 flags,
 			     u64 total_bytes, u64 bytes_used,
 			     u64 bytes_readonly, u64 bytes_zone_unusable,
-			     struct btrfs_space_info **space_info)
+			     bool active, struct btrfs_space_info **space_info)
 {
 	struct btrfs_space_info *found;
 	int factor;
@@ -306,6 +306,8 @@ void btrfs_update_space_info(struct btrfs_fs_info *info, u64 flags,
 	ASSERT(found);
 	spin_lock(&found->lock);
 	found->total_bytes += total_bytes;
+	if (active)
+		found->active_total_bytes += total_bytes;
 	found->disk_total += total_bytes * factor;
 	found->bytes_used += bytes_used;
 	found->disk_used += bytes_used * factor;
@@ -369,6 +371,22 @@ static u64 calc_available_free_space(struct btrfs_fs_info *fs_info,
 	return avail;
 }
 
+static inline u64 writable_total_bytes(struct btrfs_fs_info *fs_info,
+				       struct btrfs_space_info *space_info)
+{
+	/*
+	 * On regular filesystem, all total_bytes are always writable. On zoned
+	 * filesystem, there may be a limitation imposed by max_active_zones.
+	 * For metadata allocation, we cannot finish an existing active block
+	 * group to avoid a deadlock. Thus, we need to consider only the active
+	 * groups to be writable for metadata space.
+	 */
+	if (!btrfs_is_zoned(fs_info) || (space_info->flags & BTRFS_BLOCK_GROUP_DATA))
+		return space_info->total_bytes;
+
+	return space_info->active_total_bytes;
+}
+
 int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 			 struct btrfs_space_info *space_info, u64 bytes,
 			 enum btrfs_reserve_flush_enum flush)
@@ -386,7 +404,7 @@ int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 	else
 		avail = calc_available_free_space(fs_info, space_info, flush);
 
-	if (used + bytes < space_info->total_bytes + avail)
+	if (used + bytes < writable_total_bytes(fs_info, space_info) + avail)
 		return 1;
 	return 0;
 }
@@ -422,7 +440,7 @@ void btrfs_try_granting_tickets(struct btrfs_fs_info *fs_info,
 		ticket = list_first_entry(head, struct reserve_ticket, list);
 
 		/* Check and see if our ticket can be satisfied now. */
-		if ((used + ticket->bytes <= space_info->total_bytes) ||
+		if ((used + ticket->bytes <= writable_total_bytes(fs_info, space_info)) ||
 		    btrfs_can_overcommit(fs_info, space_info, ticket->bytes,
 					 flush)) {
 			btrfs_space_info_update_bytes_may_use(fs_info,
@@ -753,6 +771,7 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 {
 	u64 used;
 	u64 avail;
+	u64 total;
 	u64 to_reclaim = space_info->reclaim_size;
 
 	lockdep_assert_held(&space_info->lock);
@@ -767,8 +786,9 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 	 * space.  If that's the case add in our overage so we make sure to put
 	 * appropriate pressure on the flushing state machine.
 	 */
-	if (space_info->total_bytes + avail < used)
-		to_reclaim += used - (space_info->total_bytes + avail);
+	total = writable_total_bytes(fs_info, space_info);
+	if (total + avail < used)
+		to_reclaim += used - (total + avail);
 
 	return to_reclaim;
 }
@@ -778,9 +798,12 @@ static bool need_preemptive_reclaim(struct btrfs_fs_info *fs_info,
 {
 	u64 global_rsv_size = fs_info->global_block_rsv.reserved;
 	u64 ordered, delalloc;
-	u64 thresh = div_factor_fine(space_info->total_bytes, 90);
+	u64 total = writable_total_bytes(fs_info, space_info);
+	u64 thresh;
 	u64 used;
 
+	thresh = div_factor_fine(total, 90);
+
 	lockdep_assert_held(&space_info->lock);
 
 	/* If we're just plain full then async reclaim just slows us down. */
@@ -842,8 +865,8 @@ static bool need_preemptive_reclaim(struct btrfs_fs_info *fs_info,
 					   BTRFS_RESERVE_FLUSH_ALL);
 	used = space_info->bytes_used + space_info->bytes_reserved +
 	       space_info->bytes_readonly + global_rsv_size;
-	if (used < space_info->total_bytes)
-		thresh += space_info->total_bytes - used;
+	if (used < total)
+		thresh += total - used;
 	thresh >>= space_info->clamp;
 
 	used = space_info->bytes_pinned;
@@ -1560,7 +1583,7 @@ static int __reserve_bytes(struct btrfs_fs_info *fs_info,
 	 * can_overcommit() to ensure we can overcommit to continue.
 	 */
 	if (!pending_tickets &&
-	    ((used + orig_bytes <= space_info->total_bytes) ||
+	    ((used + orig_bytes <= writable_total_bytes(fs_info, space_info)) ||
 	     btrfs_can_overcommit(fs_info, space_info, orig_bytes, flush))) {
 		btrfs_space_info_update_bytes_may_use(fs_info, space_info,
 						      orig_bytes);
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index 137206b8049f..b8cee27df213 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -17,6 +17,8 @@ struct btrfs_space_info {
 	u64 bytes_may_use;	/* number of bytes that may be used for
 				   delalloc/allocations */
 	u64 bytes_readonly;	/* total bytes that are read only */
+	/* Total bytes in the space, but only accounts active block groups. */
+	u64 active_total_bytes;
 	u64 bytes_zone_unusable;	/* total bytes that are unusable until
 					   resetting the device zone */
 
@@ -122,7 +124,7 @@ int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
 void btrfs_update_space_info(struct btrfs_fs_info *info, u64 flags,
 			     u64 total_bytes, u64 bytes_used,
 			     u64 bytes_readonly, u64 bytes_zone_unusable,
-			     struct btrfs_space_info **space_info);
+			     bool active, struct btrfs_space_info **space_info);
 void btrfs_update_space_info_chunk_size(struct btrfs_space_info *space_info,
 					u64 chunk_size);
 struct btrfs_space_info *btrfs_find_space_info(struct btrfs_fs_info *info,
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 170681797283..2ffc6d50d20d 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1841,6 +1841,7 @@ struct btrfs_device *btrfs_zoned_get_device(struct btrfs_fs_info *fs_info,
 bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 {
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
+	struct btrfs_space_info *space_info = block_group->space_info;
 	struct map_lookup *map;
 	struct btrfs_device *device;
 	u64 physical;
@@ -1852,6 +1853,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 
 	map = block_group->physical_map;
 
+	spin_lock(&space_info->lock);
 	spin_lock(&block_group->lock);
 	if (block_group->zone_is_active) {
 		ret = true;
@@ -1880,7 +1882,10 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 
 	/* Successfully activated all the zones */
 	block_group->zone_is_active = 1;
+	space_info->active_total_bytes += block_group->length;
 	spin_unlock(&block_group->lock);
+	btrfs_try_granting_tickets(fs_info, space_info);
+	spin_unlock(&space_info->lock);
 
 	/* For the active block group list */
 	btrfs_get_block_group(block_group);
@@ -1893,6 +1898,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 
 out_unlock:
 	spin_unlock(&block_group->lock);
+	spin_unlock(&space_info->lock);
 	return ret;
 }
 
-- 
2.35.1



