Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32622283AED
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgJEPim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbgJEPa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:30:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 137692085B;
        Mon,  5 Oct 2020 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911855;
        bh=XOUTYVG2a3yotQL5srfT1iatkSW7dYJre/pBT2dojM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irRkET+V7ERBBs5XtqbN757KmjJS+Q53drdyPy3rcG3LvfGtRnQYeIe886gwpfnGQ
         EK3ON5FxYP9px4S/IJB9d9JCH+lBf1gRLMilTIaV3nPc8GMS5YZSZqRubNgbSBmAup
         GGaOVNjqPxErz6I4rY/fasfBkPjvlpV+VrG3Y7n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Revanth Rajashekar <revanth.rajashekar@intel.com>
Subject: [PATCH 5.4 51/57] nvme: Introduce nvme_lba_to_sect()
Date:   Mon,  5 Oct 2020 17:27:03 +0200
Message-Id: <20201005142112.254052588@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit e08f2ae850929d40e66268ee47e443e7ea56eeb7 upstream.

Introduce the new helper function nvme_lba_to_sect() to convert a device
logical block number to a 512B sector number. Use this new helper in
obvious places, cleaning up the code.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Revanth Rajashekar <revanth.rajashekar@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/core.c |   14 +++++++-------
 drivers/nvme/host/nvme.h |    8 ++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1682,7 +1682,7 @@ static void nvme_init_integrity(struct g
 
 static void nvme_set_chunk_size(struct nvme_ns *ns)
 {
-	u32 chunk_size = (((u32)ns->noiob) << (ns->lba_shift - 9));
+	u32 chunk_size = nvme_lba_to_sect(ns, ns->noiob);
 	blk_queue_chunk_sectors(ns->queue, rounddown_pow_of_two(chunk_size));
 }
 
@@ -1719,8 +1719,7 @@ static void nvme_config_discard(struct g
 
 static void nvme_config_write_zeroes(struct gendisk *disk, struct nvme_ns *ns)
 {
-	u32 max_sectors;
-	unsigned short bs = 1 << ns->lba_shift;
+	u64 max_blocks;
 
 	if (!(ns->ctrl->oncs & NVME_CTRL_ONCS_WRITE_ZEROES) ||
 	    (ns->ctrl->quirks & NVME_QUIRK_DISABLE_WRITE_ZEROES))
@@ -1736,11 +1735,12 @@ static void nvme_config_write_zeroes(str
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
@@ -1774,7 +1774,7 @@ static bool nvme_ns_ids_equal(struct nvm
 static void nvme_update_disk_info(struct gendisk *disk,
 		struct nvme_ns *ns, struct nvme_id_ns *id)
 {
-	sector_t capacity = le64_to_cpu(id->nsze) << (ns->lba_shift - 9);
+	sector_t capacity = nvme_lba_to_sect(ns, le64_to_cpu(id->nsze));
 	unsigned short bs = 1 << ns->lba_shift;
 	u32 atomic_bs, phys_bs, io_opt;
 
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -437,6 +437,14 @@ static inline u64 nvme_sect_to_lba(struc
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


