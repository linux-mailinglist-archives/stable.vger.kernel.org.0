Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4BA274F4C
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 04:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgIWCzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 22:55:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:38328 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgIWCzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 22:55:38 -0400
IronPort-SDR: TUSHkZ4jbGWflteYN1ga4h6NuzxSzMEZpOClFWKn9qGozfS1QMJlZLoo7Nr1GN/zUsjjvAIKY5
 122FUebQvdbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="245600251"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="245600251"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 19:55:37 -0700
IronPort-SDR: JFEdBMYw+Ozyc0k1hkgtTsRP6QOIKbG6XWP/AIQ17VdPnbyhxz0nYge7NSJtbdnK7DClu7CeiJ
 Aqy0bWZZ75kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="305190747"
Received: from unknown (HELO nodlab-S2600WFT.lm.intel.com) ([10.232.116.103])
  by orsmga003.jf.intel.com with ESMTP; 22 Sep 2020 19:55:37 -0700
From:   Revanth Rajashekar <revanth.rajashekar@intel.com>
To:     stable@vger.kernel.org
Cc:     hch@lst.de, kbusch@kernel.org, damien.lemoal@wdc.com,
        Revanth Rajashekar <revanth.rajashekar@intel.com>
Subject: [PATCH 3/3] [backport] nvme: consolidate chunk_sectors settings
Date:   Tue, 22 Sep 2020 20:58:08 -0600
Message-Id: <20200923025808.14698-4-revanth.rajashekar@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923025808.14698-1-revanth.rajashekar@intel.com>
References: <20200923025808.14698-1-revanth.rajashekar@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit 38adf94e166e3cb4eb89683458ca578051e8218d

Move the quirked chunk_sectors setting to the same location as noiob so
one place registers this setting. And since the noiob value is only used
locally, remove the member from struct nvme_ns.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Revanth Rajashekar <revanth.rajashekar@intel.com>
---
 drivers/nvme/host/core.c | 22 ++++++++++------------
 drivers/nvme/host/nvme.h |  1 -
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9ac27c9a1..f8068d150 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1692,12 +1692,6 @@ static void nvme_init_integrity(struct gendisk *disk, u16 ms, u8 pi_type)
 }
 #endif /* CONFIG_BLK_DEV_INTEGRITY */

-static void nvme_set_chunk_size(struct nvme_ns *ns)
-{
-	u32 chunk_size = nvme_lba_to_sect(ns, ns->noiob);
-	blk_queue_chunk_sectors(ns->queue, rounddown_pow_of_two(chunk_size));
-}
-
 static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
 {
 	struct nvme_ctrl *ctrl = ns->ctrl;
@@ -1852,6 +1846,7 @@ static void nvme_update_disk_info(struct gendisk *disk,
 static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 {
 	struct nvme_ns *ns = disk->private_data;
+	u32 iob;

 	/*
 	 * If identify namespace failed, use default 512 byte block size so
@@ -1860,7 +1855,13 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	ns->lba_shift = id->lbaf[id->flbas & NVME_NS_FLBAS_LBA_MASK].ds;
 	if (ns->lba_shift == 0)
 		ns->lba_shift = 9;
-	ns->noiob = le16_to_cpu(id->noiob);
+
+	if ((ns->ctrl->quirks & NVME_QUIRK_STRIPE_SIZE) &&
+	    is_power_of_2(ns->ctrl->max_hw_sectors))
+		iob = ns->ctrl->max_hw_sectors;
+	else
+		iob = nvme_lba_to_sect(ns, le16_to_cpu(id->noiob));
+
 	ns->ms = le16_to_cpu(id->lbaf[id->flbas & NVME_NS_FLBAS_LBA_MASK].ms);
 	ns->ext = ns->ms && (id->flbas & NVME_NS_FLBAS_META_EXT);
 	/* the PI implementation requires metadata equal t10 pi tuple size */
@@ -1869,8 +1870,8 @@ static void __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 	else
 		ns->pi_type = 0;

-	if (ns->noiob)
-		nvme_set_chunk_size(ns);
+	if (iob)
+		blk_queue_chunk_sectors(ns->queue, rounddown_pow_of_two(iob));
 	nvme_update_disk_info(disk, ns, id);
 #ifdef CONFIG_NVME_MULTIPATH
 	if (ns->head->disk) {
@@ -2221,9 +2222,6 @@ static void nvme_set_queue_limits(struct nvme_ctrl *ctrl,
 		blk_queue_max_hw_sectors(q, ctrl->max_hw_sectors);
 		blk_queue_max_segments(q, min_t(u32, max_segments, USHRT_MAX));
 	}
-	if ((ctrl->quirks & NVME_QUIRK_STRIPE_SIZE) &&
-	    is_power_of_2(ctrl->max_hw_sectors))
-		blk_queue_chunk_sectors(q, ctrl->max_hw_sectors);
 	blk_queue_virt_boundary(q, ctrl->page_size - 1);
 	if (ctrl->vwc & NVME_CTRL_VWC_PRESENT)
 		vwc = true;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 73065952f..a177b918f 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -376,7 +376,6 @@ struct nvme_ns {
 #define NVME_NS_REMOVING	0
 #define NVME_NS_DEAD     	1
 #define NVME_NS_ANA_PENDING	2
-	u16 noiob;

 	struct nvme_fault_inject fault_inject;

--
2.17.1

