Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E94594D69
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244474AbiHPBAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343555AbiHPA4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:56:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1872FB7282;
        Mon, 15 Aug 2022 13:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2A0961275;
        Mon, 15 Aug 2022 20:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFCFC433C1;
        Mon, 15 Aug 2022 20:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596478;
        bh=ZT7d3vi64Ldjk6F/M0BqkWhd+6Psc0GSzuNDJIb85JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lVhIxLGo9X8qv7IZ0BEKyfBn9LLrszw/53IQueaTb1aaWy2zfwXBrJeCKGKVnjGW
         cPwo9gnhrNxE8tyKbO/8qGFLErAN9/oQOPN/7OAr5f1mCQB3GAbZLU74yceCsvzyBr
         P1ZDdZVhty7pfqrnXcPyFxF7jEwxbVnGIRzZgV6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1093/1157] btrfs: zoned: activate metadata block group on flush_space
Date:   Mon, 15 Aug 2022 20:07:29 +0200
Message-Id: <20220815180523.933570407@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index ad13b9d207b1..b0c5b4738b1f 100644
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
index 16ed426a58c9..4df5b36dc574 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2226,3 +2226,56 @@ int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
 
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
index 329d28e2fd8d..e17462db3a84 100644
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -81,6 +81,8 @@ bool btrfs_zoned_should_reclaim(struct btrfs_fs_info *fs_info);
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
 				       u64 length);
 int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info);
+int btrfs_zoned_activate_one_bg(struct btrfs_fs_info *fs_info,
+				struct btrfs_space_info *space_info, bool do_finish);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int btrfs_get_dev_zone(struct btrfs_device *device, u64 pos,
 				     struct blk_zone *zone)
@@ -256,6 +258,14 @@ static inline int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info)
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



