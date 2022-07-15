Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D789576284
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 15:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiGONGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 09:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiGONGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 09:06:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1484330C
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 06:06:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A7EE62389
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 13:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCD2C34115;
        Fri, 15 Jul 2022 13:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657890392;
        bh=ZDKBh6n3/Gc/K89uNG8/CwqKdtulnlJYlxQi3SR+q2Q=;
        h=Subject:To:Cc:From:Date:From;
        b=dGpGj6gkQabtrJrU10FdwzhU3TyaBcQiZYwXpAjx/6jM/NB4ztNfunG6lPYsQrnZ8
         7T0VuxU01J5Gts16uItRquxPCVc8+5CelqSW24WtdUCU7EnUpXsPynZGRutzEx50X3
         xxzLKlP1NXiViyjKidYh2AynahOrT+8TeTEJb7BI=
Subject: FAILED: patch "[PATCH] btrfs: zoned: drop optimization of zone finish" failed to apply to 5.18-stable tree
To:     naohiro.aota@wdc.com, dsterba@suse.com, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jul 2022 15:06:29 +0200
Message-ID: <165789038912014@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b3a3b0255797e1d395253366ba24a4cc6c8bdf9c Mon Sep 17 00:00:00 2001
From: Naohiro Aota <naohiro.aota@wdc.com>
Date: Wed, 29 Jun 2022 11:00:38 +0900
Subject: [PATCH] btrfs: zoned: drop optimization of zone finish

We have an optimization in do_zone_finish() to send REQ_OP_ZONE_FINISH only
when necessary, i.e. we don't send REQ_OP_ZONE_FINISH when we assume we
wrote fully into the zone.

The assumption is determined by "alloc_offset == capacity". This condition
won't work if the last ordered extent is canceled due to some errors. In
that case, we consider the zone is deactivated without sending the finish
command while it's still active.

This inconstancy results in activating another block group while we cannot
really activate the underlying zone, which causes the active zone exceeds
errors like below.

    BTRFS error (device nvme3n2): allocation failed flags 1, wanted 520192 tree-log 0, relocation: 0
    nvme3n2: I/O Cmd(0x7d) @ LBA 160432128, 127 blocks, I/O Error (sct 0x1 / sc 0xbd) MORE DNR
    active zones exceeded error, dev nvme3n2, sector 0 op 0xd:(ZONE_APPEND) flags 0x4800 phys_seg 1 prio class 0
    nvme3n2: I/O Cmd(0x7d) @ LBA 160432128, 127 blocks, I/O Error (sct 0x1 / sc 0xbd) MORE DNR
    active zones exceeded error, dev nvme3n2, sector 0 op 0xd:(ZONE_APPEND) flags 0x4800 phys_seg 1 prio class 0

Fix the issue by removing the optimization for now.

Fixes: 8376d9e1ed8f ("btrfs: zoned: finish superblock zone once no space left for new SB")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 9892f7413705..e33987cefbd4 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1889,7 +1889,6 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 {
 	struct btrfs_fs_info *fs_info = block_group->fs_info;
 	struct map_lookup *map;
-	bool need_zone_finish;
 	int ret = 0;
 	int i;
 
@@ -1946,12 +1945,6 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		}
 	}
 
-	/*
-	 * The block group is not fully allocated, so not fully written yet. We
-	 * need to send ZONE_FINISH command to free up an active zone.
-	 */
-	need_zone_finish = !btrfs_zoned_bg_is_full(block_group);
-
 	block_group->zone_is_active = 0;
 	block_group->alloc_offset = block_group->zone_capacity;
 	block_group->free_space_ctl->free_space = 0;
@@ -1967,15 +1960,13 @@ static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_writ
 		if (device->zone_info->max_active_zones == 0)
 			continue;
 
-		if (need_zone_finish) {
-			ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
-					       physical >> SECTOR_SHIFT,
-					       device->zone_info->zone_size >> SECTOR_SHIFT,
-					       GFP_NOFS);
+		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+				       physical >> SECTOR_SHIFT,
+				       device->zone_info->zone_size >> SECTOR_SHIFT,
+				       GFP_NOFS);
 
-			if (ret)
-				return ret;
-		}
+		if (ret)
+			return ret;
 
 		btrfs_dev_clear_active_zone(device, physical);
 	}

