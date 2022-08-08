Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4ED58BED7
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241998AbiHHBdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242068AbiHHBcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:32:18 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9E9BC2E;
        Sun,  7 Aug 2022 18:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659922336; x=1691458336;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ePe/leNB1O/kP2sUpa4Iv//3RWITAIwumR1lD34h+8Q=;
  b=hkInb3H3pBFFJAIpuJ4jlHM2SAvG/I21c2IIkMxmlEokOJB9HZWQo7od
   iyeq3PmMjLJJc9wjJJMTkNw+V6xxYKhwb1v8NyMxHQTjVsDa1qCDsxp6P
   T9ktE99jbeU+41Y3THbJ9uH43WtaJxEXeP+l1cgXtuD+s49GyLUpp1tw7
   YFDfk0gwLA2SXPxH6pcIZSMa7D5vgY1+K5Uo2k9IHe8UtfIpa/aDVFwT/
   RXxBmMyLwbVTDO/Nfu8IuJ65p5X1Oq0qO7/84YN2/JloGBds375HOlyPm
   GiPYrSfoCOlBBphAZNXZxzsrVOwboAy7bTHgzfegvmgcAHzYNMjs/4Jvb
   w==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="320180309"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 09:32:16 +0800
IronPort-SDR: VLovlB3K8O2CZMDS9tp6wOjibBq1CRaRRY2rzPKlzWx8khFgn4SvDLd2isQ3I8Pe4CkU9BncTa
 83sFbtS+Uzvk+0r3ke4IirDN/NczzrJuXha6wY3j6PcikgE1IkByJt+N3kZySnj5gqmvQIq2MZ
 f2JdN4mDuBP3s/VbnDb440Ll+DzVq+TifUWOGxxDXEWOJqJSuqiwSk282gr/73sRfJc+8qhFeT
 H4pZAcA6lVt3k0wEN+IbP+RMZc1JqXtzyEc2N6vxny/cFOgeYaaSg1E2YdOk+2lZBozbk36IGt
 wu25BCWbfHyxb01+VxflE+1m
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Aug 2022 17:47:57 -0700
IronPort-SDR: IJwsZcwgR8a5mM6YI59J5YDKMaKH2cVGUAndHCAEWMbY0fiGqVZkV0nBaxgeowDzNxxjoqKyLN
 AvNW2ues3WBS03tHKx9zSwC9GYGwoN12tO0g03TplXIdyFKdpM6zcPfyaQTgNpzuIn0Jpf/Lnh
 f4MAWBQfz2QuYEddNSmy09pxUnEB+SAQnpmVgy5r7+Tug3DEIYeSFCjNZYvnRqib3UpoEbKehb
 KB1K8HrksaKd72Rt4sUiPbtK1+R1UiIUwl4ignM7O0pStzP3Be7+f8XQU4c5lsEbtxpG0hbT0X
 8ww=
WDCIronportException: Internal
Received: from ctl002.ad.shared (HELO naota-xeon.wdc.com) ([10.225.53.129])
  by uls-op-cesaip01.wdc.com with ESMTP; 07 Aug 2022 18:32:16 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.18 3/3] btrfs: zoned: drop optimization of zone finish
Date:   Mon,  8 Aug 2022 10:32:10 +0900
Message-Id: <20220808013210.646680-4-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013210.646680-1-naohiro.aota@wdc.com>
References: <20220808013210.646680-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b3a3b0255797e1d395253366ba24a4cc6c8bdf9c upstream

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
---
 fs/btrfs/zoned.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 2c0851d94eff..b6b64da3422c 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2039,13 +2039,25 @@ void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 len
 	spin_unlock(&block_group->lock);
 
 	map = block_group->physical_map;
-	device = map->stripes[0].dev;
-	physical = map->stripes[0].physical;
+	for (i = 0; i < map->num_stripes; i++) {
+		int ret;
 
-	if (!device->zone_info->max_active_zones)
-		goto out;
+		device = map->stripes[i].dev;
+		physical = map->stripes[i].physical;
 
-	btrfs_dev_clear_active_zone(device, physical);
+		if (device->zone_info->max_active_zones == 0)
+			continue;
+
+		ret = blkdev_zone_mgmt(device->bdev, REQ_OP_ZONE_FINISH,
+				       physical >> SECTOR_SHIFT,
+				       device->zone_info->zone_size >> SECTOR_SHIFT,
+				       GFP_NOFS);
+
+		if (ret)
+			return;
+
+		btrfs_dev_clear_active_zone(device, physical);
+	}
 
 	spin_lock(&fs_info->zone_active_bgs_lock);
 	ASSERT(!list_empty(&block_group->active_bg_list));
-- 
2.35.1

