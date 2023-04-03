Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC46F6D492A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbjDCOfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbjDCOfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77C516F08
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B8CEB81C9F
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C4DC433EF;
        Mon,  3 Apr 2023 14:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532518;
        bh=HAmpRxw9OS6Wjhv+ZYicU0vaifaZsVDZ1k/VT+HsPnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzIDI9291kbSSr6wyoBowI7p1y4rPKlm9lxfzBrNEL0LLj8FbxHFfPzU6IVMhBdSA
         1NG9kljsZK17nSk9PC5dj/C9ONkYVpOiK9/XtYL83GT0/XtoipjZMqZHLy29bQRE2e
         7J+fja0nwVAL4l37VQrXXIHC6ih66dbkvJ/C0l5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/181] btrfs: zoned: count fresh BG region as zone unusable
Date:   Mon,  3 Apr 2023 16:07:29 +0200
Message-Id: <20230403140415.583268495@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
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

[ Upstream commit fa2068d7e922b434eba5bfb0131e6d39febfdb48 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c |  8 +++++++-
 fs/btrfs/zoned.c            | 24 +++++++++++++++++++-----
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f4023651dd68b..6a8f2bd350f4b 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2684,8 +2684,13 @@ static int __btrfs_add_free_space_zoned(struct btrfs_block_group *block_group,
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
@@ -2713,7 +2718,8 @@ static int __btrfs_add_free_space_zoned(struct btrfs_block_group *block_group,
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
index 0d88cc46ac5db..e97c5a1ac95d6 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1575,9 +1575,19 @@ void btrfs_calc_zone_unusable(struct btrfs_block_group *cache)
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
@@ -1914,7 +1924,11 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
 
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
@@ -2277,7 +2291,7 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 		u64 avail;
 
 		spin_lock(&block_group->lock);
-		if (block_group->reserved ||
+		if (block_group->reserved || block_group->alloc_offset == 0 ||
 		    (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)) {
 			spin_unlock(&block_group->lock);
 			continue;
-- 
2.39.2



