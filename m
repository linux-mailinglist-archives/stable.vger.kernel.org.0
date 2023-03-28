Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD9E6CBE7F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjC1MF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjC1MFY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:05:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071839EC1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 05:04:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80F1CB81C35
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB90AC4339B;
        Tue, 28 Mar 2023 12:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680005090;
        bh=OoXnl3VUvs4nH1Hz+idGbgFKnb0DzweVbZbokFHGYKI=;
        h=Subject:To:Cc:From:Date:From;
        b=JsqHN/OaJssLrBElmeWfe0cZvggySywYG91LGXKcfpzZkzGL8kDnu6kqwik/RXQTm
         qv2N6z0ebzWSLCwFc8Z/fp0boSruWb+0hp5XRBT9bSojcz6BipNAmOPWlS6WHF8uS+
         P6o/Ko+WCyHq7FlEdIa3fFf3NBVovbkE9nFtS7Ac=
Subject: FAILED: patch "[PATCH] btrfs: zoned: count fresh BG region as zone unusable" failed to apply to 6.2-stable tree
To:     naohiro.aota@wdc.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Mar 2023 14:04:47 +0200
Message-ID: <168000508740232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.2.y
git checkout FETCH_HEAD
git cherry-pick -x fa2068d7e922b434eba5bfb0131e6d39febfdb48
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '168000508740232@kroah.com' --subject-prefix 'PATCH 6.2.y' HEAD^..

Possible dependencies:

fa2068d7e922 ("btrfs: zoned: count fresh BG region as zone unusable")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fa2068d7e922b434eba5bfb0131e6d39febfdb48 Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naohiro.aota@wdc.com>
Date: Mon, 13 Mar 2023 16:06:13 +0900
Subject: [PATCH] btrfs: zoned: count fresh BG region as zone unusable

The naming of space_info->active_total_bytes is misleading. It counts
not only active block groups but also full ones which are previously
active but now inactive. That confusion results in a bug not counting
the full BGs into active_total_bytes on mount time.

For a background, there are three kinds of block groups in terms of
activation.

  1. Block groups never activated
  2. Block groups currently active
  3. Block groups previously active and currently inactive (due to fully
     written or zone finish)

What we really wanted to exclude from "total_bytes" is the total size of
BGs #1. They seem empty and allocatable but since they are not activated,
we cannot rely on them to do the space reservation.

And, since BGs #1 never get activated, they should have no "used",
"reserved" and "pinned" bytes.

OTOH, BGs #3 can be counted in the "total", since they are already full
we cannot allocate from them anyway. For them, "total_bytes == used +
reserved + pinned + zone_unusable" should hold.

Tracking #2 and #3 as "active_total_bytes" (current implementation) is
confusing. And, tracking #1 and subtract that properly from "total_bytes"
every time you need space reservation is cumbersome.

Instead, we can count the whole region of a newly allocated block group as
zone_unusable. Then, once that block group is activated, release
[0 ..  zone_capacity] from the zone_unusable counters. With this, we can
eliminate the confusing ->active_total_bytes and the code will be common
among regular and the zoned mode. Also, no additional counter is needed
with this approach.

Fixes: 6a921de58992 ("btrfs: zoned: introduce space_info->active_total_bytes")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 0d250d052487..d84cef89cdff 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2693,8 +2693,13 @@ static int __btrfs_add_free_space_zoned(struct btrfs_block_group *block_group,
 		bg_reclaim_threshold = READ_ONCE(sinfo->bg_reclaim_threshold);
 
 	spin_lock(&ctl->tree_lock);
+	/* Count initial region as zone_unusable until it gets activated. */
 	if (!used)
 		to_free = size;
+	else if (initial &&
+		 test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &block_group->fs_info->flags) &&
+		 (block_group->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM)))
+		to_free = 0;
 	else if (initial)
 		to_free = block_group->zone_capacity;
 	else if (offset >= block_group->alloc_offset)
@@ -2722,7 +2727,8 @@ static int __btrfs_add_free_space_zoned(struct btrfs_block_group *block_group,
 	reclaimable_unusable = block_group->zone_unusable -
 			       (block_group->length - block_group->zone_capacity);
 	/* All the region is now unusable. Mark it as unused and reclaim */
-	if (block_group->zone_unusable == block_group->length) {
+	if (block_group->zone_unusable == block_group->length &&
+	    block_group->alloc_offset) {
 		btrfs_mark_bg_unused(block_group);
 	} else if (bg_reclaim_threshold &&
 		   reclaimable_unusable >=
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 22d1e930a916..6828712578ca 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1580,9 +1580,19 @@ void btrfs_calc_zone_unusable(struct btrfs_block_group *cache)
 		return;
 
 	WARN_ON(cache->bytes_super != 0);
-	unusable = (cache->alloc_offset - cache->used) +
-		   (cache->length - cache->zone_capacity);
-	free = cache->zone_capacity - cache->alloc_offset;
+
+	/* Check for block groups never get activated */
+	if (test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &cache->fs_info->flags) &&
+	    cache->flags & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_SYSTEM) &&
+	    !test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &cache->runtime_flags) &&
+	    cache->alloc_offset == 0) {
+		unusable = cache->length;
+		free = 0;
+	} else {
+		unusable = (cache->alloc_offset - cache->used) +
+			   (cache->length - cache->zone_capacity);
+		free = cache->zone_capacity - cache->alloc_offset;
+	}
 
 	/* We only need ->free_space in ALLOC_SEQ block groups */
 	cache->cached = BTRFS_CACHE_FINISHED;
@@ -1901,7 +1911,11 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 
 	/* Successfully activated all the zones */
 	set_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags);
-	space_info->active_total_bytes += block_group->length;
+	WARN_ON(block_group->alloc_offset != 0);
+	if (block_group->zone_unusable == block_group->length) {
+		block_group->zone_unusable = block_group->length - block_group->zone_capacity;
+		space_info->bytes_zone_unusable -= block_group->zone_capacity;
+	}
 	spin_unlock(&block_group->lock);
 	btrfs_try_granting_tickets(fs_info, space_info);
 	spin_unlock(&space_info->lock);
@@ -2265,7 +2279,7 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 		u64 avail;
 
 		spin_lock(&block_group->lock);
-		if (block_group->reserved ||
+		if (block_group->reserved || block_group->alloc_offset == 0 ||
 		    (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)) {
 			spin_unlock(&block_group->lock);
 			continue;

