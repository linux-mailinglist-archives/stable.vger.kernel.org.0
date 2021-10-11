Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30125428F98
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbhJKN7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238400AbhJKN6j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:58:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E16386120C;
        Mon, 11 Oct 2021 13:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960517;
        bh=fPz+VdkX106Mduow8rVFHChVJKKfmkGnLlUVKAZAGZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfEvKsMjZooJOiGzj2msrC2i+GwxJMfLtq7VNVKc8uVtH/Y3pqRbOUOxpmqpE7vDO
         jR3uSIF5gcDJ+24wT8Gsnh5FQbo1EUgdWMFvW0s+q8VfJuP4oZOehgvJtmgM6q9ia3
         iDtsM9VBibKiFKGA//mgo5TdCyc0ZFkraZg/LIUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 83/83] scsi: ufs: core: Fix task management completion
Date:   Mon, 11 Oct 2021 15:46:43 +0200
Message-Id: <20211011134511.235071707@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ufs/ufshcd.c |   54 +++++++++++++++++++++-------------------------
 drivers/scsi/ufs/ufshcd.h |    1 
 2 files changed, 26 insertions(+), 29 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6105,27 +6105,6 @@ static irqreturn_t ufshcd_check_errors(s
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
@@ -6136,14 +6115,24 @@ static bool ufshcd_compl_tm(struct reque
  */
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
-	struct request_queue *q = hba->tmf_queue;
-	struct ctm_info ci = {
-		.hba	 = hba,
-		.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL),
-	};
+	unsigned long flags, pending, issued;
+	irqreturn_t ret = IRQ_NONE;
+	int tag;
 
-	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
-	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
+	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	issued = hba->outstanding_tasks & ~pending;
+	for_each_set_bit(tag, &issued, hba->nutmrs) {
+		struct request *req = hba->tmf_rqs[tag];
+		struct completion *c = req->end_io_data;
+
+		complete(c);
+		ret = IRQ_HANDLED;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	return ret;
 }
 
 /**
@@ -6273,9 +6262,9 @@ static int __ufshcd_issue_tm_cmd(struct
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
-	blk_mq_start_request(req);
 
 	task_tag = req->tag;
+	hba->tmf_rqs[req->tag] = req;
 	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
 
 	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
@@ -6319,6 +6308,7 @@ static int __ufshcd_issue_tm_cmd(struct
 	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->tmf_rqs[req->tag] = NULL;
 	__clear_bit(task_tag, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
@@ -9246,6 +9236,12 @@ int ufshcd_init(struct ufs_hba *hba, voi
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
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -731,6 +731,7 @@ struct ufs_hba {
 
 	struct blk_mq_tag_set tmf_tag_set;
 	struct request_queue *tmf_queue;
+	struct request **tmf_rqs;
 
 	struct uic_command *active_uic_cmd;
 	struct mutex uic_cmd_mutex;


