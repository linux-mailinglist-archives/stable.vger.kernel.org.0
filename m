Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A733335BD70
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbhDLIv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238261AbhDLItS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A8676128C;
        Mon, 12 Apr 2021 08:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217305;
        bh=VVr/X18w8KeOWiDZ13XyL6zMPaR3FFgujFaKM9yjvQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8xBPu5GIrzcAV/YHmddMi11tlIFQ4t+5AqlbD9DcTgc+lbi0Qps2muP7T5mmdsAG
         tyoBCHI8vyv3eVzA/DnRAm20i9AH2yV2reJFnImQ29GcD1gTy06bpE6om/oYL62H3x
         nYmQkQ+2JQtiO275cES+29bk7RpiW6Jn+Z+mXEMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/111] scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs
Date:   Mon, 12 Apr 2021 10:40:56 +0200
Message-Id: <20210412084006.865835491@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 69a6c269c097d780a2db320ecd47f7a62fafd92e ]

Manage TMF tags with blk_{get,put}_request() instead of
ufshcd_get_tm_free_slot() / ufshcd_put_tm_slot(). Store a per-request
completion pointer in request.end_io_data instead of using a waitqueue to
report TMF completion.

Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20191209181309.196233-3-bvanassche@acm.org
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 130 ++++++++++++++++++++++----------------
 drivers/scsi/ufs/ufshcd.h |  12 ++--
 2 files changed, 80 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e84617172968..e7e6405401dd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -644,40 +644,6 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
 	return le32_to_cpu(lrbp->utr_descriptor_ptr->header.dword_2) & MASK_OCS;
 }
 
-/**
- * ufshcd_get_tm_free_slot - get a free slot for task management request
- * @hba: per adapter instance
- * @free_slot: pointer to variable with available slot value
- *
- * Get a free tag and lock it until ufshcd_put_tm_slot() is called.
- * Returns 0 if free slot is not available, else return 1 with tag value
- * in @free_slot.
- */
-static bool ufshcd_get_tm_free_slot(struct ufs_hba *hba, int *free_slot)
-{
-	int tag;
-	bool ret = false;
-
-	if (!free_slot)
-		goto out;
-
-	do {
-		tag = find_first_zero_bit(&hba->tm_slots_in_use, hba->nutmrs);
-		if (tag >= hba->nutmrs)
-			goto out;
-	} while (test_and_set_bit_lock(tag, &hba->tm_slots_in_use));
-
-	*free_slot = tag;
-	ret = true;
-out:
-	return ret;
-}
-
-static inline void ufshcd_put_tm_slot(struct ufs_hba *hba, int slot)
-{
-	clear_bit_unlock(slot, &hba->tm_slots_in_use);
-}
-
 /**
  * ufshcd_utrl_clear - Clear a bit in UTRLCLR register
  * @hba: per adapter instance
@@ -5580,6 +5546,27 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
 	return retval;
 }
 
+struct ctm_info {
+	struct ufs_hba	*hba;
+	unsigned long	pending;
+	unsigned int	ncpl;
+};
+
+static bool ufshcd_compl_tm(struct request *req, void *priv, bool reserved)
+{
+	struct ctm_info *const ci = priv;
+	struct completion *c;
+
+	WARN_ON_ONCE(reserved);
+	if (test_bit(req->tag, &ci->pending))
+		return true;
+	ci->ncpl++;
+	c = req->end_io_data;
+	if (c)
+		complete(c);
+	return true;
+}
+
 /**
  * ufshcd_tmc_handler - handle task management function completion
  * @hba: per adapter instance
@@ -5590,16 +5577,14 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
  */
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
-	u32 tm_doorbell;
+	struct request_queue *q = hba->tmf_queue;
+	struct ctm_info ci = {
+		.hba	 = hba,
+		.pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL),
+	};
 
-	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-	hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
-	if (hba->tm_condition) {
-		wake_up(&hba->tm_wq);
-		return IRQ_HANDLED;
-	} else {
-		return IRQ_NONE;
-	}
+	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_compl_tm, &ci);
+	return ci.ncpl ? IRQ_HANDLED : IRQ_NONE;
 }
 
 /**
@@ -5705,7 +5690,10 @@ out:
 static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		struct utp_task_req_desc *treq, u8 tm_function)
 {
+	struct request_queue *q = hba->tmf_queue;
 	struct Scsi_Host *host = hba->host;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct request *req;
 	unsigned long flags;
 	int free_slot, task_tag, err;
 
@@ -5714,7 +5702,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	 * Even though we use wait_event() which sleeps indefinitely,
 	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
 	 */
-	wait_event(hba->tm_tag_wq, ufshcd_get_tm_free_slot(hba, &free_slot));
+	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
+	req->end_io_data = &wait;
+	free_slot = req->tag;
+	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
@@ -5740,10 +5731,14 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_send");
 
 	/* wait until the task management command is completed */
-	err = wait_event_timeout(hba->tm_wq,
-			test_bit(free_slot, &hba->tm_condition),
+	err = wait_for_completion_io_timeout(&wait,
 			msecs_to_jiffies(TM_CMD_TIMEOUT));
 	if (!err) {
+		/*
+		 * Make sure that ufshcd_compl_tm() does not trigger a
+		 * use-after-free.
+		 */
+		req->end_io_data = NULL;
 		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete_err");
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
@@ -5762,9 +5757,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	__clear_bit(free_slot, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	clear_bit(free_slot, &hba->tm_condition);
-	ufshcd_put_tm_slot(hba, free_slot);
-	wake_up(&hba->tm_tag_wq);
+	blk_put_request(req);
 
 	ufshcd_release(hba);
 	return err;
@@ -8217,6 +8210,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
+	blk_cleanup_queue(hba->tmf_queue);
+	blk_mq_free_tag_set(&hba->tmf_tag_set);
 	blk_cleanup_queue(hba->cmd_queue);
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
@@ -8296,6 +8291,18 @@ out_error:
 }
 EXPORT_SYMBOL(ufshcd_alloc_host);
 
+/* This function exists because blk_mq_alloc_tag_set() requires this. */
+static blk_status_t ufshcd_queue_tmf(struct blk_mq_hw_ctx *hctx,
+				     const struct blk_mq_queue_data *qd)
+{
+	WARN_ON_ONCE(true);
+	return BLK_STS_NOTSUPP;
+}
+
+static const struct blk_mq_ops ufshcd_tmf_ops = {
+	.queue_rq = ufshcd_queue_tmf,
+};
+
 /**
  * ufshcd_init - Driver initialization routine
  * @hba: per-adapter instance
@@ -8365,10 +8372,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	hba->max_pwr_info.is_valid = false;
 
-	/* Initailize wait queue for task management */
-	init_waitqueue_head(&hba->tm_wq);
-	init_waitqueue_head(&hba->tm_tag_wq);
-
 	/* Initialize work queues */
 	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
@@ -8420,6 +8423,21 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_remove_scsi_host;
 	}
 
+	hba->tmf_tag_set = (struct blk_mq_tag_set) {
+		.nr_hw_queues	= 1,
+		.queue_depth	= hba->nutmrs,
+		.ops		= &ufshcd_tmf_ops,
+		.flags		= BLK_MQ_F_NO_SCHED,
+	};
+	err = blk_mq_alloc_tag_set(&hba->tmf_tag_set);
+	if (err < 0)
+		goto free_cmd_queue;
+	hba->tmf_queue = blk_mq_init_queue(&hba->tmf_tag_set);
+	if (IS_ERR(hba->tmf_queue)) {
+		err = PTR_ERR(hba->tmf_queue);
+		goto free_tmf_tag_set;
+	}
+
 	/* Reset the attached device */
 	ufshcd_vops_device_reset(hba);
 
@@ -8429,7 +8447,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_host_regs(hba);
 		ufshcd_print_host_state(hba);
-		goto free_cmd_queue;
+		goto free_tmf_queue;
 	}
 
 	/*
@@ -8466,6 +8484,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	return 0;
 
+free_tmf_queue:
+	blk_cleanup_queue(hba->tmf_queue);
+free_tmf_tag_set:
+	blk_mq_free_tag_set(&hba->tmf_tag_set);
 free_cmd_queue:
 	blk_cleanup_queue(hba->cmd_queue);
 out_remove_scsi_host:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8fd6fd75cb5c..92ef6e6a3e51 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -494,11 +494,9 @@ struct ufs_stats {
  * @irq: Irq number of the controller
  * @active_uic_cmd: handle of active UIC command
  * @uic_cmd_mutex: mutex for uic command
- * @tm_wq: wait queue for task management
- * @tm_tag_wq: wait queue for free task management slots
- * @tm_slots_in_use: bit map of task management request slots in use
+ * @tmf_tag_set: TMF tag set.
+ * @tmf_queue: Used to allocate TMF tags.
  * @pwr_done: completion for power mode change
- * @tm_condition: condition variable for task management
  * @ufshcd_state: UFSHCD states
  * @eh_flags: Error handling flags
  * @intr_mask: Interrupt Mask Bits
@@ -643,10 +641,8 @@ struct ufs_hba {
 	/* Device deviations from standard UFS device spec. */
 	unsigned int dev_quirks;
 
-	wait_queue_head_t tm_wq;
-	wait_queue_head_t tm_tag_wq;
-	unsigned long tm_condition;
-	unsigned long tm_slots_in_use;
+	struct blk_mq_tag_set tmf_tag_set;
+	struct request_queue *tmf_queue;
 
 	struct uic_command *active_uic_cmd;
 	struct mutex uic_cmd_mutex;
-- 
2.30.2



