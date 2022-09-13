Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA7D5B720E
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbiIMOtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbiIMOsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:48:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A687B6F546;
        Tue, 13 Sep 2022 07:25:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 575BEB80EFE;
        Tue, 13 Sep 2022 14:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB63BC433C1;
        Tue, 13 Sep 2022 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078484;
        bh=hzHlMCpsGdkKTK0zWkUiYLwjSnS2cs+6PTOMwwjV36o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Y65BphkXOiWidwIvQXWli0bquotHl85G9zu5RCEOuZsM44h6hRuY0d+GmLqpV1xl
         SJzS/WL9WsS60JuRgOgeN4h7sAQxsi8SGD67OSNxbgMJFthiJGBUTvuHvXDfq6F4TB
         TMQ/NF481LyOCS6nrNnHJZsHnt71qPIB1pdev6W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 132/192] btrfs: zoned: fix mounting with conventional zones
Date:   Tue, 13 Sep 2022 16:03:58 +0200
Message-Id: <20220913140416.588500662@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 6ca64ac2763149fb66c0b4bf12f5e0977a88e51d ]

Since commit 6a921de58992 ("btrfs: zoned: introduce
space_info->active_total_bytes"), we're only counting the bytes of a
block group on an active zone as usable for metadata writes. But on a
SMR drive, we don't have active zones and short circuit some of the
logic.

This leads to an error on mount, because we cannot reserve space for
metadata writes.

Fix this by also setting the BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE bit in the
block-group's runtime flag if the zone is a conventional zone.

Fixes: 6a921de58992 ("btrfs: zoned: introduce space_info->active_total_bytes")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 81 ++++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 4949e0d82923d..1386362fad3b8 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1187,7 +1187,7 @@ int btrfs_ensure_empty_zones(struct btrfs_device *device, u64 start, u64 size)
  * offset.
  */
 static int calculate_alloc_pointer(struct btrfs_block_group *cache,
-				   u64 *offset_ret)
+				   u64 *offset_ret, bool new)
 {
 	struct btrfs_fs_info *fs_info = cache->fs_info;
 	struct btrfs_root *root;
@@ -1197,6 +1197,21 @@ static int calculate_alloc_pointer(struct btrfs_block_group *cache,
 	int ret;
 	u64 length;
 
+	/*
+	 * Avoid  tree lookups for a new block group, there's no use for it.
+	 * It must always be 0.
+	 *
+	 * Also, we have a lock chain of extent buffer lock -> chunk mutex.
+	 * For new a block group, this function is called from
+	 * btrfs_make_block_group() which is already taking the chunk mutex.
+	 * Thus, we cannot call calculate_alloc_pointer() which takes extent
+	 * buffer locks to avoid deadlock.
+	 */
+	if (new) {
+		*offset_ret = 0;
+		return 0;
+	}
+
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -1332,6 +1347,13 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 		else
 			num_conventional++;
 
+		/*
+		 * Consider a zone as active if we can allow any number of
+		 * active zones.
+		 */
+		if (!device->zone_info->max_active_zones)
+			__set_bit(i, active);
+
 		if (!is_sequential) {
 			alloc_offsets[i] = WP_CONVENTIONAL;
 			continue;
@@ -1398,45 +1420,23 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 			__set_bit(i, active);
 			break;
 		}
-
-		/*
-		 * Consider a zone as active if we can allow any number of
-		 * active zones.
-		 */
-		if (!device->zone_info->max_active_zones)
-			__set_bit(i, active);
 	}
 
 	if (num_sequential > 0)
 		cache->seq_zone = true;
 
 	if (num_conventional > 0) {
-		/*
-		 * Avoid calling calculate_alloc_pointer() for new BG. It
-		 * is no use for new BG. It must be always 0.
-		 *
-		 * Also, we have a lock chain of extent buffer lock ->
-		 * chunk mutex.  For new BG, this function is called from
-		 * btrfs_make_block_group() which is already taking the
-		 * chunk mutex. Thus, we cannot call
-		 * calculate_alloc_pointer() which takes extent buffer
-		 * locks to avoid deadlock.
-		 */
-
 		/* Zone capacity is always zone size in emulation */
 		cache->zone_capacity = cache->length;
-		if (new) {
-			cache->alloc_offset = 0;
-			goto out;
-		}
-		ret = calculate_alloc_pointer(cache, &last_alloc);
-		if (ret || map->num_stripes == num_conventional) {
-			if (!ret)
-				cache->alloc_offset = last_alloc;
-			else
-				btrfs_err(fs_info,
+		ret = calculate_alloc_pointer(cache, &last_alloc, new);
+		if (ret) {
+			btrfs_err(fs_info,
 			"zoned: failed to determine allocation offset of bg %llu",
-					  cache->start);
+				  cache->start);
+			goto out;
+		} else if (map->num_stripes == num_conventional) {
+			cache->alloc_offset = last_alloc;
+			cache->zone_is_active = 1;
 			goto out;
 		}
 	}
@@ -1504,13 +1504,6 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 		goto out;
 	}
 
-	if (cache->zone_is_active) {
-		btrfs_get_block_group(cache);
-		spin_lock(&fs_info->zone_active_bgs_lock);
-		list_add_tail(&cache->active_bg_list, &fs_info->zone_active_bgs);
-		spin_unlock(&fs_info->zone_active_bgs_lock);
-	}
-
 out:
 	if (cache->alloc_offset > fs_info->zone_size) {
 		btrfs_err(fs_info,
@@ -1535,10 +1528,16 @@ int btrfs_load_block_group_zone_info(struct btrfs_block_group *cache, bool new)
 		ret = -EIO;
 	}
 
-	if (!ret)
+	if (!ret) {
 		cache->meta_write_pointer = cache->alloc_offset + cache->start;
-
-	if (ret) {
+		if (cache->zone_is_active) {
+			btrfs_get_block_group(cache);
+			spin_lock(&fs_info->zone_active_bgs_lock);
+			list_add_tail(&cache->active_bg_list,
+				      &fs_info->zone_active_bgs);
+			spin_unlock(&fs_info->zone_active_bgs_lock);
+		}
+	} else {
 		kfree(cache->physical_map);
 		cache->physical_map = NULL;
 	}
-- 
2.35.1



