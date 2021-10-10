Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718BC42806D
	for <lists+stable@lfdr.de>; Sun, 10 Oct 2021 12:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhJJKXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Oct 2021 06:23:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231244AbhJJKXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Oct 2021 06:23:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BC9E61056;
        Sun, 10 Oct 2021 10:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633861300;
        bh=loml9WZvamVAvJz4paWKjq0qSnAYvDi6NBIwTD6FdNI=;
        h=Subject:To:Cc:From:Date:From;
        b=oS0d9mkFYVH/+2k+sPbPmvfXAZnXIY5FaGdRhkNWi6JSEbS2kJS4Li96JzUycIvyf
         2Mt2lD4DnJK2/RkQR/fXc/wEtzuPi0M9nUozb8jt/ykl1KqWRVuwlz0TF+DqNKYevS
         1KhNoNm4RwgioIvKQ43Xd8tcKhUoUX7d/nCluqN0=
Subject: FAILED: patch "[PATCH] scsi: ufs: core: Fix task management completion" failed to apply to 5.4-stable tree
To:     adrian.hunter@intel.com, bvanassche@acm.org,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 10 Oct 2021 12:21:38 +0200
Message-ID: <16338612988264@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f5ef336fd2e4c36dedae4e7ca66cf5349d6fda62 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 22 Sep 2021 12:10:59 +0300
Subject: [PATCH] scsi: ufs: core: Fix task management completion

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

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 188de6f91050..95be7ecdfe10 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6377,27 +6377,6 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
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
@@ -6408,18 +6387,24 @@ static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
  */
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
-	unsigned long flags;
-	struct request_queue *q = hba->tmf_queue;
-	struct ctm_info ci = {
-		.hba	 = hba,
-	};
+	unsigned long flags, pending, issued;
+	irqreturn_t ret = IRQ_NONE;
+	int tag;
+
+	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ci.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
+	issued = hba->outstanding_tasks & ~pending;
+	for_each_set_bit(tag, &issued, hba->nutmrs) {
+		struct request *req = hba->tmf_rqs[tag];
+		struct completion *c = req->end_io_data;
+
+		complete(c);
+		ret = IRQ_HANDLED;
+	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
+	return ret;
 }
 
 /**
@@ -6542,9 +6527,9 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
-	blk_mq_start_request(req);
 
 	task_tag = req->tag;
+	hba->tmf_rqs[req->tag] = req;
 	treq->upiu_req.req_header.dword_0 |= cpu_to_be32(task_tag);
 
 	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
@@ -6585,6 +6570,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->tmf_rqs[req->tag] = NULL;
 	__clear_bit(task_tag, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
@@ -9635,6 +9621,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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
 	ufshcd_device_reset(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f0da5d3db1fa..41f6e06f9185 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -828,6 +828,7 @@ struct ufs_hba {
 
 	struct blk_mq_tag_set tmf_tag_set;
 	struct request_queue *tmf_queue;
+	struct request **tmf_rqs;
 
 	struct uic_command *active_uic_cmd;
 	struct mutex uic_cmd_mutex;

