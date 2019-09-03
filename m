Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 916C9A7054
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbfICQiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730612AbfICQ0W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E3AE238CF;
        Tue,  3 Sep 2019 16:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527981;
        bh=yLsZpV7cm0p5dAUlxLIQ5H3Ph/pLc3PwTRFBWbiBskM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2nZDkJEWjSJ52uBKBkSYZa65kBdz0vZGZH4COrWPJhmkGHc5nvH8h12OjtMCQOdO
         0YB6sT0aW7gFgxbZQOO80ERCexj3+BAtkY0RnkX/t4lHL0JvgVxgsQBBNQLQGQO3xP
         F4zFiJ8ZlweEhAdhkeaw+79woeiEOmferxnbBO2o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Omar Sandoval <osandov@fb.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 036/167] Btrfs: clean up scrub is_dev_replace parameter
Date:   Tue,  3 Sep 2019 12:23:08 -0400
Message-Id: <20190903162519.7136-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

[ Upstream commit 32934280967d00dc2b5c4d3b63b21a9c8638326e ]

struct scrub_ctx has an ->is_dev_replace member, so there's no point in
passing around is_dev_replace where sctx is available.

Signed-off-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 3be1456b5116b..4bcc275f76128 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3022,8 +3022,7 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 					   struct map_lookup *map,
 					   struct btrfs_device *scrub_dev,
-					   int num, u64 base, u64 length,
-					   int is_dev_replace)
+					   int num, u64 base, u64 length)
 {
 	struct btrfs_path *path, *ppath;
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
@@ -3299,7 +3298,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 			extent_physical = extent_logical - logical + physical;
 			extent_dev = scrub_dev;
 			extent_mirror_num = mirror_num;
-			if (is_dev_replace)
+			if (sctx->is_dev_replace)
 				scrub_remap_extent(fs_info, extent_logical,
 						   extent_len, &extent_physical,
 						   &extent_dev,
@@ -3397,8 +3396,7 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 					  struct btrfs_device *scrub_dev,
 					  u64 chunk_offset, u64 length,
 					  u64 dev_offset,
-					  struct btrfs_block_group_cache *cache,
-					  int is_dev_replace)
+					  struct btrfs_block_group_cache *cache)
 {
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
@@ -3435,8 +3433,7 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 		if (map->stripes[i].dev->bdev == scrub_dev->bdev &&
 		    map->stripes[i].physical == dev_offset) {
 			ret = scrub_stripe(sctx, map, scrub_dev, i,
-					   chunk_offset, length,
-					   is_dev_replace);
+					   chunk_offset, length);
 			if (ret)
 				goto out;
 		}
@@ -3449,8 +3446,7 @@ static noinline_for_stack int scrub_chunk(struct scrub_ctx *sctx,
 
 static noinline_for_stack
 int scrub_enumerate_chunks(struct scrub_ctx *sctx,
-			   struct btrfs_device *scrub_dev, u64 start, u64 end,
-			   int is_dev_replace)
+			   struct btrfs_device *scrub_dev, u64 start, u64 end)
 {
 	struct btrfs_dev_extent *dev_extent = NULL;
 	struct btrfs_path *path;
@@ -3544,7 +3540,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		 */
 		scrub_pause_on(fs_info);
 		ret = btrfs_inc_block_group_ro(cache);
-		if (!ret && is_dev_replace) {
+		if (!ret && sctx->is_dev_replace) {
 			/*
 			 * If we are doing a device replace wait for any tasks
 			 * that started dellaloc right before we set the block
@@ -3609,7 +3605,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		dev_replace->item_needs_writeback = 1;
 		btrfs_dev_replace_write_unlock(&fs_info->dev_replace);
 		ret = scrub_chunk(sctx, scrub_dev, chunk_offset, length,
-				  found_key.offset, cache, is_dev_replace);
+				  found_key.offset, cache);
 
 		/*
 		 * flush, submit all pending read and write bios, afterwards
@@ -3670,7 +3666,7 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
 		btrfs_put_block_group(cache);
 		if (ret)
 			break;
-		if (is_dev_replace &&
+		if (sctx->is_dev_replace &&
 		    atomic64_read(&dev_replace->num_write_errors) > 0) {
 			ret = -EIO;
 			break;
@@ -3893,8 +3889,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	}
 
 	if (!ret)
-		ret = scrub_enumerate_chunks(sctx, dev, start, end,
-					     is_dev_replace);
+		ret = scrub_enumerate_chunks(sctx, dev, start, end);
 
 	wait_event(sctx->list_wait, atomic_read(&sctx->bios_in_flight) == 0);
 	atomic_dec(&fs_info->scrubs_running);
-- 
2.20.1

