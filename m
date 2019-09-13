Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0B3B1EE7
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389445AbfIMNOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388309AbfIMNOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:02 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89CD9206BB;
        Fri, 13 Sep 2019 13:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380441;
        bh=sL72A4hxRpAYbspZ4kmMAqV4xMwTEav74LMlUp/8HeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1QpDz8uPlcBPkqya2T7TAaFORyxlZkYVKpPHYQCRRAxa9TsXT8uktLZe91Q0+mnM
         68mDkCXcSavvCK/0cFsa9UIZ/iReq6JyWZUcj8UzejZ42O90M5Fuk0+KmA2gDpA0GO
         B2I10gIxNS/UyNHu9P2n0zccZpFWv+ekkEwQ5aKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/190] Btrfs: clean up scrub is_dev_replace parameter
Date:   Fri, 13 Sep 2019 14:05:20 +0100
Message-Id: <20190913130604.929034148@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -3022,8 +3022,7 @@ out:
 static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 					   struct map_lookup *map,
 					   struct btrfs_device *scrub_dev,
-					   int num, u64 base, u64 length,
-					   int is_dev_replace)
+					   int num, u64 base, u64 length)
 {
 	struct btrfs_path *path, *ppath;
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
@@ -3299,7 +3298,7 @@ again:
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
@@ -3449,8 +3446,7 @@ out:
 
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



