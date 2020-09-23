Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582D7274F4A
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 04:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIWCzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 22:55:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:38328 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgIWCze (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Sep 2020 22:55:34 -0400
IronPort-SDR: +H7nHOFKfAIOXHn+lZzwuW1TCiTJjqzN3ojOEJmYMuCmRJUV44niY8XzG0q3DVFLybYu32pdH0
 mTRR6UQYkQTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9752"; a="245600244"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="245600244"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2020 19:55:34 -0700
IronPort-SDR: sdARMWkLzdRI9/oqjwfC+OhAv0Qr2KaH1bi3cdCzkWtJnxM8NTCGwRWSr3hVUGDo77oF+/6GPz
 KpFyP8XKvzLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="305190740"
Received: from unknown (HELO nodlab-S2600WFT.lm.intel.com) ([10.232.116.103])
  by orsmga003.jf.intel.com with ESMTP; 22 Sep 2020 19:55:33 -0700
From:   Revanth Rajashekar <revanth.rajashekar@intel.com>
To:     stable@vger.kernel.org
Cc:     hch@lst.de, kbusch@kernel.org, damien.lemoal@wdc.com,
        Revanth Rajashekar <revanth.rajashekar@intel.com>
Subject: [PATCH 1/3] [backport] nvme: Cleanup and rename nvme_block_nr()
Date:   Tue, 22 Sep 2020 20:58:06 -0600
Message-Id: <20200923025808.14698-2-revanth.rajashekar@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200923025808.14698-1-revanth.rajashekar@intel.com>
References: <20200923025808.14698-1-revanth.rajashekar@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 314d48dd224897e35ddcaf5a1d7d133b5adddeb7

Rename nvme_block_nr() to nvme_sect_to_lba() and use SECTOR_SHIFT
instead of its hard coded value 9. Also add a comment to decribe this
helper.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Revanth Rajashekar <revanth.rajashekar@intel.com>
---
 drivers/nvme/host/core.c | 6 +++---
 drivers/nvme/host/nvme.h | 7 +++++--
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 071b63146..f7d32eeee 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -633,7 +633,7 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	}

 	__rq_for_each_bio(bio, req) {
-		u64 slba = nvme_block_nr(ns, bio->bi_iter.bi_sector);
+		u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
 		u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;

 		if (n < segments) {
@@ -674,7 +674,7 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
 	cmnd->write_zeroes.opcode = nvme_cmd_write_zeroes;
 	cmnd->write_zeroes.nsid = cpu_to_le32(ns->head->ns_id);
 	cmnd->write_zeroes.slba =
-		cpu_to_le64(nvme_block_nr(ns, blk_rq_pos(req)));
+		cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
 	cmnd->write_zeroes.length =
 		cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);
 	cmnd->write_zeroes.control = 0;
@@ -698,7 +698,7 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,

 	cmnd->rw.opcode = (rq_data_dir(req) ? nvme_cmd_write : nvme_cmd_read);
 	cmnd->rw.nsid = cpu_to_le32(ns->head->ns_id);
-	cmnd->rw.slba = cpu_to_le64(nvme_block_nr(ns, blk_rq_pos(req)));
+	cmnd->rw.slba = cpu_to_le64(nvme_sect_to_lba(ns, blk_rq_pos(req)));
 	cmnd->rw.length = cpu_to_le16((blk_rq_bytes(req) >> ns->lba_shift) - 1);

 	if (req_op(req) == REQ_OP_WRITE && ctrl->nr_streams)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ed0226086..f93ba2da1 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -421,9 +421,12 @@ static inline int nvme_reset_subsystem(struct nvme_ctrl *ctrl)
 	return ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
 }

-static inline u64 nvme_block_nr(struct nvme_ns *ns, sector_t sector)
+/*
+ * Convert a 512B sector number to a device logical block number.
+ */
+static inline u64 nvme_sect_to_lba(struct nvme_ns *ns, sector_t sector)
 {
-	return (sector >> (ns->lba_shift - 9));
+	return sector >> (ns->lba_shift - SECTOR_SHIFT);
 }

 static inline void nvme_end_request(struct request *req, __le16 status,
--
2.17.1

