Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B41358C18A
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 04:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbiHHCYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 22:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241838AbiHHCYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 22:24:32 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E1B11811;
        Sun,  7 Aug 2022 19:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659924150; x=1691460150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=464mKJOcENT8/jWX3CKvvBL8fIiP88Nj5Nh21OYdmbc=;
  b=LMGIt4alZUtAmNFr+B9MXt2LRAviRuIGABdv4m/yB8mSq9g+NSch+2AR
   MQcsrZIvkCL8XXoP0RnosRUWh+wJhSK5WN0y4JTanVabqhBD1BrLny2gE
   5v8FQfyBxl9dY1OwmS0lJj0ocV9cN5lbDjkFPK27DdLvWZL20JTw3gOmE
   uS6qfDRz6bkahXCG/bQPTxeLF4kvIyqKcjYPpY1cMYb1bdBONXIZIKCpR
   KZ6+cyTCY20cXz4+20Q5mKb5OoaoxaMPmMyYjzO7DfMU9ibL3Bfa1MBLt
   jd/IFpl3O7RES4d3XwhbWFnPCpiyRsnan4906DoR1rdb7ukAxQUGsVTyG
   A==;
X-IronPort-AV: E=Sophos;i="5.93,221,1654531200"; 
   d="scan'208";a="320182420"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2022 10:02:30 +0800
IronPort-SDR: 04mWyEz27TtVNEckA0vUBt3mX58qxf78kNSn6OkcReA+iwWZ+voa0S0qzjGg8ilYfgnqSbe2aj
 OTsJaU744D7QFwgD/VKY0b+a605SgABsrTfz7gxfk/e4jdglI+qgly/WDJkSckvtxqJgqx48Wg
 AFv3USglZItFCQUKuwFPI+J8SQG7RC0/aYuAIWls/AwSYXnHKRlg1locFxi5reJzJ32mrIAm76
 c3R62MJ/NVaBVdkiPLRCWZu4gSI+2FzRlnVETbILyxA6swF3P5T1VAYx4ok1D7oHHvDTN9gszO
 JSzAx8Bzf4PTzf2aSOgkAxfW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Aug 2022 18:18:12 -0700
IronPort-SDR: Scd2HmbfaV1r1sYZd7ijC8AJuOSfloMjneI3PPFMm2SXddwXTHKDJXDfd0EX596goVzdT/A/3O
 8Ibq1QHpcVdmf04o6gXMZ/3oQvCrdfL2ty4ewqegXpOUFQbCw6Gr2Tg5IERSrBcAfom0Geipgc
 58WK2JYMsn0jxtCVzcEibWKgDR12sEQsVDLsLvdWUvzMIIng5xXJ62aDKscG2FZIVrrjEUBWzH
 a+hHXptbd/wEfMM8GpwSm5yYr0qDuXvoVZZo8K5RhxEYxbK5R2Qqye2edM+ow+Ei0U5RO/dlh7
 Gu8=
WDCIronportException: Internal
Received: from ctl002.ad.shared (HELO naota-xeon.wdc.com) ([10.225.53.129])
  by uls-op-cesaip02.wdc.com with ESMTP; 07 Aug 2022 19:02:30 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Cc:     Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH STABLE 5.18 v2 3/3] btrfs: zoned: drop optimization of zone finish
Date:   Mon,  8 Aug 2022 11:02:01 +0900
Message-Id: <20220808020201.712924-4-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808020201.712924-1-naohiro.aota@wdc.com>
References: <20220808020201.712924-1-naohiro.aota@wdc.com>
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
 fs/btrfs/zoned.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 2c0851d94eff..84b6d39509bd 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2005,6 +2005,7 @@ void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 len
 	struct btrfs_device *device;
 	u64 min_alloc_bytes;
 	u64 physical;
+	int i;
 
 	if (!btrfs_is_zoned(fs_info))
 		return;
@@ -2039,13 +2040,25 @@ void btrfs_zone_finish_endio(struct btrfs_fs_info *fs_info, u64 logical, u64 len
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
+
+		if (device->zone_info->max_active_zones == 0)
+			continue;
 
-	btrfs_dev_clear_active_zone(device, physical);
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

