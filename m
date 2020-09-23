Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6451B274F4B
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 04:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgIWCzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 22:55:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:38328 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgIWCzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 22:55:36 -0400
IronPort-SDR: v8WQ7OcQpo+vRIJhBc0iIM2i9xRseHYaucn+5hNnQ5FS7TlS00KmURADR5NogN6Mppo30PwtMa
 ZwrMZxSlCoEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="245600247"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="245600247"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 19:55:35 -0700
IronPort-SDR: j8wZiZSDMDH1b6dbliBiil/c2z387vwTtcubSFsHijFu+pXsxEYPzCIgf2skzkpP0hC/xJ7zjB
 gIJszMIppIdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="305190743"
Received: from unknown (HELO nodlab-S2600WFT.lm.intel.com) ([10.232.116.103])
  by orsmga003.jf.intel.com with ESMTP; 22 Sep 2020 19:55:35 -0700
From:   Revanth Rajashekar <revanth.rajashekar@intel.com>
To:     stable@vger.kernel.org
Cc:     hch@lst.de, kbusch@kernel.org, damien.lemoal@wdc.com,
        Revanth Rajashekar <revanth.rajashekar@intel.com>
Subject: [PATCH 2/3] [backport] nvme: Introduce nvme_lba_to_sect()
Date:   Tue, 22 Sep 2020 20:58:07 -0600
Message-Id: <20200923025808.14698-3-revanth.rajashekar@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923025808.14698-1-revanth.rajashekar@intel.com>
References: <20200923025808.14698-1-revanth.rajashekar@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit e08f2ae850929d40e66268ee47e443e7ea56eeb7

Introduce the new helper function nvme_lba_to_sect() to convert a device
logical block number to a 512B sector number. Use this new helper in
obvious places, cleaning up the code.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Revanth Rajashekar <revanth.rajashekar@intel.com>
---
 drivers/nvme/host/core.c | 14 +++++++-------
 drivers/nvme/host/nvme.h |  8 ++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f7d32eeee..9ac27c9a1 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1694,7 +1694,7 @@ static void nvme_init_integrity(struct gendisk *disk, u16 ms, u8 pi_type)

 static void nvme_set_chunk_size(struct nvme_ns *ns)
 {
-	u32 chunk_size = (((u32)ns->noiob) << (ns->lba_shift - 9));
+	u32 chunk_size = nvme_lba_to_sect(ns, ns->noiob);
 	blk_queue_chunk_sectors(ns->queue, rounddown_pow_of_two(chunk_size));
 }

@@ -1731,8 +1731,7 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)

 static void nvme_config_write_zeroes(struct gendisk *disk, struct nvme_ns *ns)
 {
-	u32 max_sectors;
-	unsigned short bs = 1 << ns->lba_shift;
+	u64 max_blocks;

 	if (!(ns->ctrl->oncs & NVME_CTRL_ONCS_WRITE_ZEROES) ||
 	    (ns->ctrl->quirks & NVME_QUIRK_DISABLE_WRITE_ZEROES))
@@ -1748,11 +1747,12 @@ static void nvme_config_write_zeroes(struct gendisk *disk, struct nvme_ns *ns)
 	 * nvme_init_identify() if available.
 	 */
 	if (ns->ctrl->max_hw_sectors == UINT_MAX)
-		max_sectors = ((u32)(USHRT_MAX + 1) * bs) >> 9;
+		max_blocks = (u64)USHRT_MAX + 1;
 	else
-		max_sectors = ((u32)(ns->ctrl->max_hw_sectors + 1) * bs) >> 9;
+		max_blocks = ns->ctrl->max_hw_sectors + 1;

-	blk_queue_max_write_zeroes_sectors(disk->queue, max_sectors);
+	blk_queue_max_write_zeroes_sectors(disk->queue,
+					   nvme_lba_to_sect(ns, max_blocks));
 }

 static int nvme_report_ns_ids(struct nvme_ctrl *ctrl, unsigned int nsid,
@@ -1786,7 +1786,7 @@ static bool nvme_ns_ids_equal(struct nvme_ns_ids *a, struct nvme_ns_ids *b)
 static void nvme_update_disk_info(struct gendisk *disk,
 		struct nvme_ns *ns, struct nvme_id_ns *id)
 {
-	sector_t capacity = le64_to_cpu(id->nsze) << (ns->lba_shift - 9);
+	sector_t capacity = nvme_lba_to_sect(ns, le64_to_cpu(id->nsze));
 	unsigned short bs = 1 << ns->lba_shift;
 	u32 atomic_bs, phys_bs, io_opt;

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index f93ba2da1..73065952f 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -429,6 +429,14 @@ static inline u64 nvme_sect_to_lba(struct nvme_ns *ns, sector_t sector)
 	return sector >> (ns->lba_shift - SECTOR_SHIFT);
 }

+/*
+ * Convert a device logical block number to a 512B sector number.
+ */
+static inline sector_t nvme_lba_to_sect(struct nvme_ns *ns, u64 lba)
+{
+	return lba << (ns->lba_shift - SECTOR_SHIFT);
+}
+
 static inline void nvme_end_request(struct request *req, __le16 status,
 		union nvme_result result)
 {
--
2.17.1

