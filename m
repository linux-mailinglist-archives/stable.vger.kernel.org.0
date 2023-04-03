Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0A36D4A1A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbjDCOoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbjDCOoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:44:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D63A1B7E8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 114E5CE12F1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8525C433EF;
        Mon,  3 Apr 2023 14:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532988;
        bh=E9PId05J/ebYtm9trci939DeoQlZf31cw51CYdSOhBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvTJ4nZoGZ+cZhHqJme3++28jkwVvacNyiZDnulPlNuU8I9v+c6DiZspj/u7vi5V3
         aywJJhsl6qYsg0PVWrCD58iZjFEbSeDFcfms3fPpUw09v4PYIt9Beu47yzQL+ZND6q
         RMT6vR+tOSnr4gNkxx6f5S4mxo15z0A7kM4EniYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 012/187] btrfs: zoned: drop space_info->active_total_bytes
Date:   Mon,  3 Apr 2023 16:07:37 +0200
Message-Id: <20230403140416.444471333@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit e15acc25880cf048dba9df94d76ed7e7e10040e6 ]

The space_info->active_total_bytes is no longer necessary as we now
count the region of newly allocated block group as zone_unusable. Drop
its usage.

Fixes: 6a921de58992 ("btrfs: zoned: introduce space_info->active_total_bytes")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c |  6 ------
 fs/btrfs/space-info.c  | 40 +++++++++-------------------------------
 fs/btrfs/space-info.h  |  2 --
 fs/btrfs/zoned.c       |  4 ----
 4 files changed, 9 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index d628d545ffea7..8eb625318e785 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1036,14 +1036,8 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			< block_group->zone_unusable);
 		WARN_ON(block_group->space_info->disk_total
 			< block_group->length * factor);
-		WARN_ON(test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE,
-				 &block_group->runtime_flags) &&
-			block_group->space_info->active_total_bytes
-			< block_group->length);
 	}
 	block_group->space_info->total_bytes -= block_group->length;
-	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags))
-		block_group->space_info->active_total_bytes -= block_group->length;
 	block_group->space_info->bytes_readonly -=
 		(block_group->length - block_group->zone_unusable);
 	block_group->space_info->bytes_zone_unusable -=
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 2237685d1ed0c..3eecce86f63fc 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -308,8 +308,6 @@ void btrfs_add_bg_to_space_info(struct btrfs_fs_info *info,
 	ASSERT(found);
 	spin_lock(&found->lock);
 	found->total_bytes += block_group->length;
-	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags))
-		found->active_total_bytes += block_group->length;
 	found->disk_total += block_group->length * factor;
 	found->bytes_used += block_group->used;
 	found->disk_used += block_group->used * factor;
@@ -379,22 +377,6 @@ static u64 calc_available_free_space(struct btrfs_fs_info *fs_info,
 	return avail;
 }
 
-static inline u64 writable_total_bytes(struct btrfs_fs_info *fs_info,
-				       struct btrfs_space_info *space_info)
-{
-	/*
-	 * On regular filesystem, all total_bytes are always writable. On zoned
-	 * filesystem, there may be a limitation imposed by max_active_zones.
-	 * For metadata allocation, we cannot finish an existing active block
-	 * group to avoid a deadlock. Thus, we need to consider only the active
-	 * groups to be writable for metadata space.
-	 */
-	if (!btrfs_is_zoned(fs_info) || (space_info->flags & BTRFS_BLOCK_GROUP_DATA))
-		return space_info->total_bytes;
-
-	return space_info->active_total_bytes;
-}
-
 int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 			 struct btrfs_space_info *space_info, u64 bytes,
 			 enum btrfs_reserve_flush_enum flush)
@@ -413,7 +395,7 @@ int btrfs_can_overcommit(struct btrfs_fs_info *fs_info,
 	else
 		avail = calc_available_free_space(fs_info, space_info, flush);
 
-	if (used + bytes < writable_total_bytes(fs_info, space_info) + avail)
+	if (used + bytes < space_info->total_bytes + avail)
 		return 1;
 	return 0;
 }
@@ -449,7 +431,7 @@ void btrfs_try_granting_tickets(struct btrfs_fs_info *fs_info,
 		ticket = list_first_entry(head, struct reserve_ticket, list);
 
 		/* Check and see if our ticket can be satisfied now. */
-		if ((used + ticket->bytes <= writable_total_bytes(fs_info, space_info)) ||
+		if ((used + ticket->bytes <= space_info->total_bytes) ||
 		    btrfs_can_overcommit(fs_info, space_info, ticket->bytes,
 					 flush)) {
 			btrfs_space_info_update_bytes_may_use(fs_info,
@@ -829,7 +811,6 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 {
 	u64 used;
 	u64 avail;
-	u64 total;
 	u64 to_reclaim = space_info->reclaim_size;
 
 	lockdep_assert_held(&space_info->lock);
@@ -844,9 +825,8 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_fs_info *fs_info,
 	 * space.  If that's the case add in our overage so we make sure to put
 	 * appropriate pressure on the flushing state machine.
 	 */
-	total = writable_total_bytes(fs_info, space_info);
-	if (total + avail < used)
-		to_reclaim += used - (total + avail);
+	if (space_info->total_bytes + avail < used)
+		to_reclaim += used - (space_info->total_bytes + avail);
 
 	return to_reclaim;
 }
@@ -856,11 +836,10 @@ static bool need_preemptive_reclaim(struct btrfs_fs_info *fs_info,
 {
 	u64 global_rsv_size = fs_info->global_block_rsv.reserved;
 	u64 ordered, delalloc;
-	u64 total = writable_total_bytes(fs_info, space_info);
 	u64 thresh;
 	u64 used;
 
-	thresh = mult_perc(total, 90);
+	thresh = mult_perc(space_info->total_bytes, 90);
 
 	lockdep_assert_held(&space_info->lock);
 
@@ -923,8 +902,8 @@ static bool need_preemptive_reclaim(struct btrfs_fs_info *fs_info,
 					   BTRFS_RESERVE_FLUSH_ALL);
 	used = space_info->bytes_used + space_info->bytes_reserved +
 	       space_info->bytes_readonly + global_rsv_size;
-	if (used < total)
-		thresh += total - used;
+	if (used < space_info->total_bytes)
+		thresh += space_info->total_bytes - used;
 	thresh >>= space_info->clamp;
 
 	used = space_info->bytes_pinned;
@@ -1651,7 +1630,7 @@ static int __reserve_bytes(struct btrfs_fs_info *fs_info,
 	 * can_overcommit() to ensure we can overcommit to continue.
 	 */
 	if (!pending_tickets &&
-	    ((used + orig_bytes <= writable_total_bytes(fs_info, space_info)) ||
+	    ((used + orig_bytes <= space_info->total_bytes) ||
 	     btrfs_can_overcommit(fs_info, space_info, orig_bytes, flush))) {
 		btrfs_space_info_update_bytes_may_use(fs_info, space_info,
 						      orig_bytes);
@@ -1665,8 +1644,7 @@ static int __reserve_bytes(struct btrfs_fs_info *fs_info,
 	 */
 	if (ret && unlikely(flush == BTRFS_RESERVE_FLUSH_EMERGENCY)) {
 		used = btrfs_space_info_used(space_info, false);
-		if (used + orig_bytes <=
-		    writable_total_bytes(fs_info, space_info)) {
+		if (used + orig_bytes <= space_info->total_bytes) {
 			btrfs_space_info_update_bytes_may_use(fs_info, space_info,
 							      orig_bytes);
 			ret = 0;
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index fc99ea2b0c34f..2033b71b18cec 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -96,8 +96,6 @@ struct btrfs_space_info {
 	u64 bytes_may_use;	/* number of bytes that may be used for
 				   delalloc/allocations */
 	u64 bytes_readonly;	/* total bytes that are read only */
-	/* Total bytes in the space, but only accounts active block groups. */
-	u64 active_total_bytes;
 	u64 bytes_zone_unusable;	/* total bytes that are unusable until
 					   resetting the device zone */
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index c3c763cc06399..ce5ebba7fdd9a 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2330,10 +2330,6 @@ int btrfs_zoned_activate_one_bg(struct btrfs_fs_info *fs_info,
 	if (!btrfs_is_zoned(fs_info) || (space_info->flags & BTRFS_BLOCK_GROUP_DATA))
 		return 0;
 
-	/* No more block groups to activate */
-	if (space_info->active_total_bytes == space_info->total_bytes)
-		return 0;
-
 	for (;;) {
 		int ret;
 		bool need_finish = false;
-- 
2.39.2



