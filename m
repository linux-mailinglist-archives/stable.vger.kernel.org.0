Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2920D45A25A
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 13:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbhKWMWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 07:22:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:15358 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233576AbhKWMWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 07:22:42 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10176"; a="232501962"
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="232501962"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 04:19:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,257,1631602800"; 
   d="scan'208";a="509007715"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 23 Nov 2021 04:19:33 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5.10 1/2] scsi: ufs: core: Fix task management completion
Date:   Tue, 23 Nov 2021 14:19:29 +0200
Message-Id: <20211123121930.1464738-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211123121930.1464738-1-adrian.hunter@intel.com>
References: <20211123121930.1464738-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f5ef336fd2e4c36dedae4e7ca66cf5349d6fda62 upstream.

The UFS driver uses blk_mq_tagset_busy_iter() when identifying task
management requests to complete, however blk_mq_tagset_busy_iter() doesn't
work.

blk_mq_tagset_busy_iter() only iterates requests dispatched by the block
layer. That appears as if it might have started since commit 37f4a24c2469
("blk-mq: centralise related handling into blk_mq_get_driver_tag") which
removed 'data->hctx->tags->rqs[rq->tag] = rq' from blk_mq_rq_ctx_init()
which gets called:

	blk_get_request
		blk_mq_alloc_request
			__blk_mq_alloc_request
				blk_mq_rq_ctx_init

Since UFS task management requests are not dispatched by the block layer,
hctx->tags->rqs[rq->tag] remains NULL, and since blk_mq_tagset_busy_iter()
relies on finding requests using hctx->tags->rqs[rq->tag], UFS task
management requests are never found by blk_mq_tagset_busy_iter().

By using blk_mq_tagset_busy_iter(), the UFS driver was relying on internal
details of the block layer, which was fragile and subsequently got
broken. Fix by removing the use of blk_mq_tagset_busy_iter() and having the
driver keep track of task management requests.

Link: https://lore.kernel.org/r/20210922091059.4040-1-adrian.hunter@intel.com
Fixes: 1235fc569e0b ("scsi: ufs: core: Fix task management request completion timeout")
Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs")
Cc: stable@vger.kernel.org
Tested-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 52 +++++++++++++++++----------------------
 drivers/scsi/ufs/ufshcd.h |  1 +
 2 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 930f35863cbb..5fd0a6ed181c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6099,27 +6099,6 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 	return retval;
 }
 
-struct ctm_info {
-	struct ufs_hba	*hba;
-	unsigned long	pending;
-	unsigned int	ncpl;
-};
-
-static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
-{
-	struct ctm_info *const ci = priv;
-	struct completion *c;
-
-	WARN_ON_ONCE(reserved);
-	if (test_bit(req->tag, &ci->pending))
-		return true;
-	ci->ncpl++;
-	c = req->end_io_data;
-	if (c)
-		complete(c);
-	return true;
-}
-
 /**
  * ufshcd_tmc_handler - handle task management function completion
  * @hba: per adapter instance
@@ -6130,14 +6109,22 @@ static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
  */
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
-	struct request_queue *q = hba->tmf_queue;
-	struct ctm_info ci = {
-		.hba	 = hba,
-		.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL),
-	};
+	unsigned long pending, issued;
+	irqreturn_t ret = IRQ_NONE;
+	int tag;
+
+	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+
+	issued = hba->outstanding_tasks & ~pending;
+	for_each_set_bit(tag, &issued, hba->nutmrs) {
+		struct request *req = hba->tmf_rqs[tag];
+		struct completion *c = req->end_io_data;
+
+		complete(c);
+		ret = IRQ_HANDLED;
+	}
 
-	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
-	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
+	return ret;
 }
 
 /**
@@ -6267,9 +6254,9 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
-	blk_mq_start_request(req);
 
 	task_tag = req->tag;
+	hba->tmf_rqs[req->tag] = req;
 	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
 
 	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
@@ -6313,6 +6300,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->tmf_rqs[req->tag] = NULL;
 	__clear_bit(task_tag, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
@@ -9235,6 +9223,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		err = PTR_ERR(hba->tmf_queue);
 		goto free_tmf_tag_set;
 	}
+	hba->tmf_rqs = devm_kcalloc(hba->dev, hba->nutmrs,
+				    sizeof(*hba->tmf_rqs), GFP_KERNEL);
+	if (!hba->tmf_rqs) {
+		err = -ENOMEM;
+		goto free_tmf_queue;
+	}
 
 	/* Reset the attached device */
 	ufshcd_vops_device_reset(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1ba9c786feb6..35dd5197ccb9 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -734,6 +734,7 @@ struct ufs_hba {
 
 	struct blk_mq_tag_set tmf_tag_set;
 	struct request_queue *tmf_queue;
+	struct request **tmf_rqs;
 
 	struct uic_command *active_uic_cmd;
 	struct mutex uic_cmd_mutex;
-- 
2.25.1

