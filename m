Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2049594904
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345805AbiHOXaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353479AbiHOX2O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:28:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746D914EC87;
        Mon, 15 Aug 2022 13:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22661B80EAD;
        Mon, 15 Aug 2022 20:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A790C433C1;
        Mon, 15 Aug 2022 20:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594058;
        bh=gWsxSCTfUMFkP5mLAfYdZw5JsGtOXLYtNCGw75jvoI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMH1bwBIeBvbUNcdJaiBrDY1Sicgz6nK/tXYk5b5Wc7V2CLVL4inH9ELDvMo9LY11
         hCBeJRg5W8jvCZG3CECV0RqZDlTbB7t6eDHTQsxjbg9OREcQirbPwKhFZtYRP2uKIB
         2FjhM2aoCvKR9lGbGeHAH3gfEWNU24vQ3cofYC7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1022/1095] btrfs: zoned: finish least available block group on data bg allocation
Date:   Mon, 15 Aug 2022 20:07:01 +0200
Message-Id: <20220815180511.365198396@linuxfoundation.org>
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

[ Upstream commit 393f646e34c18b85d0f41272bfcbd475ae3a0d34 ]

When we run out of active zones and no sufficient space is left in any
block groups, we need to finish one block group to make room to activate a
new block group.

However, we cannot do this for metadata block groups because we can cause a
deadlock by waiting for a running transaction commit. So, do that only for
a data block group.

Furthermore, the block group to be finished has two requirements. First,
the block group must not have reserved bytes left. Having reserved bytes
means we have an allocated region but did not yet send bios for it. If that
region is allocated by the thread calling btrfs_zone_finish(), it results
in a deadlock.

Second, the block group to be finished must not be a SYSTEM block
group. Finishing a SYSTEM block group easily breaks further chunk
allocation by nullifying the SYSTEM free space.

In a certain case, we cannot find any zone finish candidate or
btrfs_zone_finish() may fail. In that case, we fall back to split the
allocation bytes and fill the last spaces left in the block groups.

CC: stable@vger.kernel.org # 5.16+
Fixes: afba2bc036b0 ("btrfs: zoned: implement active zone tracking")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 50 +++++++++++++++++++++++++++++++++---------
 fs/btrfs/zoned.c       | 40 +++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h       |  7 ++++++
 3 files changed, 87 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8bdcbc0c6d60..bdebd77f31b4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3985,6 +3985,45 @@ static void found_extent(struct find_free_extent_ctl *ffe_ctl,
 	}
 }
 
+static int can_allocate_chunk_zoned(struct btrfs_fs_info *fs_info,
+				    struct find_free_extent_ctl *ffe_ctl)
+{
+	/* If we can activate new zone, just allocate a chunk and use it */
+	if (btrfs_can_activate_zone(fs_info->fs_devices, ffe_ctl->flags))
+		return 0;
+
+	/*
+	 * We already reached the max active zones. Try to finish one block
+	 * group to make a room for a new block group. This is only possible
+	 * for a data block group because btrfs_zone_finish() may need to wait
+	 * for a running transaction which can cause a deadlock for metadata
+	 * allocation.
+	 */
+	if (ffe_ctl->flags & BTRFS_BLOCK_GROUP_DATA) {
+		int ret = btrfs_zone_finish_one_bg(fs_info);
+
+		if (ret == 1)
+			return 0;
+		else if (ret < 0)
+			return ret;
+	}
+
+	/*
+	 * If we have enough free space left in an already active block group
+	 * and we can't activate any other zone now, do not allow allocating a
+	 * new chunk and let find_free_extent() retry with a smaller size.
+	 */
+	if (ffe_ctl->max_extent_size >= ffe_ctl->min_alloc_size)
+		return -ENOSPC;
+
+	/*
+	 * We cannot activate a new block group and no enough space left in any
+	 * block groups. So, allocating a new block group may not help. But,
+	 * there is nothing to do anyway, so let's go with it.
+	 */
+	return 0;
+}
+
 static int can_allocate_chunk(struct btrfs_fs_info *fs_info,
 			      struct find_free_extent_ctl *ffe_ctl)
 {
@@ -3992,16 +4031,7 @@ static int can_allocate_chunk(struct btrfs_fs_info *fs_info,
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
 		return 0;
 	case BTRFS_EXTENT_ALLOC_ZONED:
-		/*
-		 * If we have enough free space left in an already
-		 * active block group and we can't activate any other
-		 * zone now, do not allow allocating a new chunk and
-		 * let find_free_extent() retry with a smaller size.
-		 */
-		if (ffe_ctl->max_extent_size >= ffe_ctl->min_alloc_size &&
-		    !btrfs_can_activate_zone(fs_info->fs_devices, ffe_ctl->flags))
-			return -ENOSPC;
-		return 0;
+		return can_allocate_chunk_zoned(fs_info, ffe_ctl);
 	default:
 		BUG();
 	}
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index a0bf2c20fa61..0a6a3d6f5af7 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2176,3 +2176,43 @@ void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logica
 	spin_unlock(&block_group->lock);
 	btrfs_put_block_group(block_group);
 }
+
+int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_group *block_group;
+	struct btrfs_block_group *min_bg = NULL;
+	u64 min_avail = U64_MAX;
+	int ret;
+
+	spin_lock(&fs_info->zone_active_bgs_lock);
+	list_for_each_entry(block_group, &fs_info->zone_active_bgs,
+			    active_bg_list) {
+		u64 avail;
+
+		spin_lock(&block_group->lock);
+		if (block_group->reserved ||
+		    (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)) {
+			spin_unlock(&block_group->lock);
+			continue;
+		}
+
+		avail = block_group->zone_capacity - block_group->alloc_offset;
+		if (min_avail > avail) {
+			if (min_bg)
+				btrfs_put_block_group(min_bg);
+			min_bg = block_group;
+			min_avail = avail;
+			btrfs_get_block_group(min_bg);
+		}
+		spin_unlock(&block_group->lock);
+	}
+	spin_unlock(&fs_info->zone_active_bgs_lock);
+
+	if (!min_bg)
+		return 0;
+
+	ret = btrfs_zone_finish(min_bg);
+	btrfs_put_block_group(min_bg);
+
+	return ret < 0 ? ret : 1;
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 2d6da8f4b55a..c424417e19bb 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -83,6 +83,7 @@ void btrfs_clear_data_reloc_bg(struct btrfs_block_group *bg);
 void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
 				       u64 length);
+int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -247,6 +248,12 @@ static inline void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info) { }
 
 static inline void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info,
 						     u64 logical, u64 length) { }
+
+static inline int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
+{
+	return 1;
+}
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
-- 
2.35.1



