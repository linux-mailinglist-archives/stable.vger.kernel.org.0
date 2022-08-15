Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6350D5948E4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiHOXY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353388AbiHOXWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:22:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6C1D67;
        Mon, 15 Aug 2022 13:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D18896069E;
        Mon, 15 Aug 2022 20:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F6AC433D6;
        Mon, 15 Aug 2022 20:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593914;
        bh=HAit6q//nCXyfWWa9qlHHFJtTuNenQLXeie9SQkaEQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKszgwVpRT1rofZVgRCp/WrdwrG5pSYNCa8gxTMF+W1o6xgLtWtnTUzR7Rp9WDaZd
         n3EV8xVzHFrS9Cm+OeMs/thT4JfGJKXs46Z2dHqdmeNX1ZVuDF9xk7n3psDC844bLq
         MOXdseg3BfDpeH1k5WUtAty9iri3PXctc1G1dkg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 1028/1095] btrfs: zoned: activate metadata block group on flush_space
Date:   Mon, 15 Aug 2022 20:07:07 +0200
Message-Id: <20220815180511.572995227@linuxfoundation.org>
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

[ Upstream commit b0931513913633044ed6e3800334c28433c007b0 ]

For metadata space on zoned filesystem, reaching ALLOC_CHUNK{,_FORCE}
means we don't have enough space left in the active_total_bytes. Before
allocating a new chunk, we can try to activate an existing block group
in this case.

Also, allocating a chunk is not enough to grant a ticket for metadata
space on zoned filesystem we need to activate the block group to
increase the active_total_bytes.

btrfs_zoned_activate_one_bg() implements the activation feature. It will
activate a block group by (maybe) finishing a block group. It will give up
activating a block group if it cannot finish any block group.

CC: stable@vger.kernel.org # 5.16+
Fixes: afba2bc036b0 ("btrfs: zoned: implement active zone tracking")
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 30 ++++++++++++++++++++++++
 fs/btrfs/zoned.c      | 53 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/zoned.h      | 10 ++++++++
 3 files changed, 93 insertions(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 4867199cf983..104cbc901c0e 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -9,6 +9,7 @@
 #include "ordered-data.h"
 #include "transaction.h"
 #include "block-group.h"
+#include "zoned.h"
 
 /*
  * HOW DOES SPACE RESERVATION WORK
@@ -724,6 +725,18 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 		break;
 	case ALLOC_CHUNK:
 	case ALLOC_CHUNK_FORCE:
+		/*
+		 * For metadata space on zoned filesystem, reaching here means we
+		 * don't have enough space left in active_total_bytes. Try to
+		 * activate a block group first, because we may have inactive
+		 * block group already allocated.
+		 */
+		ret = btrfs_zoned_activate_one_bg(fs_info, space_info, false);
+		if (ret < 0)
+			break;
+		else if (ret == 1)
+			break;
+
 		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
@@ -734,6 +747,23 @@ static void flush_space(struct btrfs_fs_info *fs_info,
 				(state == ALLOC_CHUNK) ? CHUNK_ALLOC_NO_FORCE :
 					CHUNK_ALLOC_FORCE);
 		btrfs_end_transaction(trans);
+
+		/*
+		 * For metadata space on zoned filesystem, allocating a new chunk
+		 * is not enough. We still need to activate the block * group.
+		 * Active the newly allocated block group by (maybe) finishing
+		 * a block group.
+		 */
+		if (ret == 1) {
+			ret = btrfs_zoned_activate_one_bg(fs_info, space_info, true);
+			/*
+			 * Revert to the original ret regardless we could finish
+			 * one block group or not.
+			 */
+			if (ret >= 0)
+				ret = 1;
+		}
+
 		if (ret > 0 || ret == -ENOSPC)
 			ret = 0;
 		break;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 2ffc6d50d20d..0c2d81b0e3d3 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2222,3 +2222,56 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 
 	return ret < 0 ? ret : 1;
 }
+
+int btrfs_zoned_activate_one_bg(struct btrfs_fs_info *fs_info,
+				struct btrfs_space_info *space_info,
+				bool do_finish)
+{
+	struct btrfs_block_group *bg;
+	int index;
+
+	if (!btrfs_is_zoned(fs_info) || (space_info->flags & BTRFS_BLOCK_GROUP_DATA))
+		return 0;
+
+	/* No more block groups to activate */
+	if (space_info->active_total_bytes == space_info->total_bytes)
+		return 0;
+
+	for (;;) {
+		int ret;
+		bool need_finish = false;
+
+		down_read(&space_info->groups_sem);
+		for (index = 0; index < BTRFS_NR_RAID_TYPES; index++) {
+			list_for_each_entry(bg, &space_info->block_groups[index],
+					    list) {
+				if (!spin_trylock(&bg->lock))
+					continue;
+				if (btrfs_zoned_bg_is_full(bg) || bg->zone_is_active) {
+					spin_unlock(&bg->lock);
+					continue;
+				}
+				spin_unlock(&bg->lock);
+
+				if (btrfs_zone_activate(bg)) {
+					up_read(&space_info->groups_sem);
+					return 1;
+				}
+
+				need_finish = true;
+			}
+		}
+		up_read(&space_info->groups_sem);
+
+		if (!do_finish || !need_finish)
+			break;
+
+		ret = btrfs_zone_finish_one_bg(fs_info);
+		if (ret == 0)
+			break;
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/fs/btrfs/zoned.h b/fs/btrfs/zoned.h
index 0740458894ac..1cac32266276 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -80,6 +80,8 @@ void btrfs_free_zone_cache(struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
 				       u64 length);
 int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info);
+int btrfs_zoned_activate_one_bg(struct btrfs_fs_info *fs_info,
+				struct btrfs_space_info *space_info, bool do_finish);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -250,6 +252,14 @@ static inline int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 	return 1;
 }
 
+static inline int btrfs_zoned_activate_one_bg(struct btrfs_fs_info *fs_info,
+					      struct btrfs_space_info *space_info,
+					      bool do_finish)
+{
+	/* Consider all the block groups are active */
+	return 0;
+}
+
 #endif
 
 static inline bool btrfs_dev_is_sequential(struct btrfs_device *device, u64 pos)
-- 
2.35.1



