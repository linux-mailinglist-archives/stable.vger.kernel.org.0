Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F319F35BD71
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238842AbhDLIva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238256AbhDLItR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B567361221;
        Mon, 12 Apr 2021 08:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217303;
        bh=FahmqO5l6zkBnFAAJEnN9bvxQp42gFhdFDixh+nHLqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTPqeIEn9dYyxh+TfugOZ7DgmvR8YG8NJLSU2o5rmt1erbzuFaAnZ2mLV3HDkr0+R
         PowImEFZ/6MYfx/QoNQqsg35T//+yiupiXx2ts3TAWA14YTYbl0l42vOKj4+hMhXE8
         J7zToaPV1dulRsBD5pYd9aA+PsiQE+3npTzXnmss=
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
Subject: [PATCH 5.4 077/111] scsi: ufs: Avoid busy-waiting by eliminating tag conflicts
Date:   Mon, 12 Apr 2021 10:40:55 +0200
Message-Id: <20210412084006.833613716@linuxfoundation.org>
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

[ Upstream commit 7252a3603015f1fd04363956f4b72a537c9f9c42 ]

Instead of tracking which tags are in use in the ufs_hba.lrb_in_use
bitmask, rely on the block layer tag allocation mechanism. This patch
removes the following busy-waiting loop if ufshcd_issue_devman_upiu_cmd()
and the block layer accidentally allocate the same tag for a SCSI request:

 * ufshcd_queuecommand() returns SCSI_MLQUEUE_HOST_BUSY.

 * The SCSI core requeues the SCSI command.

Cc: Can Guo <cang@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20191209181309.196233-2-bvanassche@acm.org
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 121 +++++++++++++++-----------------------
 drivers/scsi/ufs/ufshcd.h |   6 +-
 2 files changed, 50 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 289edf70ccb9..e84617172968 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -496,8 +496,8 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
 static void ufshcd_print_host_state(struct ufs_hba *hba)
 {
 	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
-	dev_err(hba->dev, "lrb in use=0x%lx, outstanding reqs=0x%lx tasks=0x%lx\n",
-		hba->lrb_in_use, hba->outstanding_reqs, hba->outstanding_tasks);
+	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
+		hba->outstanding_reqs, hba->outstanding_tasks);
 	dev_err(hba->dev, "saved_err=0x%x, saved_uic_err=0x%x\n",
 		hba->saved_err, hba->saved_uic_err);
 	dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",
@@ -1279,6 +1279,24 @@ out:
 	return ret;
 }
 
+static bool ufshcd_is_busy(struct request *req, void *priv, bool reserved)
+{
+	int *busy = priv;
+
+	WARN_ON_ONCE(reserved);
+	(*busy)++;
+	return false;
+}
+
+/* Whether or not any tag is in use by a request that is in progress. */
+static bool ufshcd_any_tag_in_use(struct ufs_hba *hba)
+{
+	struct request_queue *q = hba->cmd_queue;
+	int busy = 0;
+
+	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_is_busy, &busy);
+	return busy;
+}
 
 static int ufshcd_devfreq_get_dev_status(struct device *dev,
 		struct devfreq_dev_status *stat)
@@ -1633,7 +1651,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 
 	if (hba->clk_gating.active_reqs
 		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
-		|| hba->lrb_in_use || hba->outstanding_tasks
+		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
 		|| hba->active_uic_cmd || hba->uic_async_done)
 		goto rel_lock;
 
@@ -1687,7 +1705,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended
 		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
-		|| hba->lrb_in_use || hba->outstanding_tasks
+		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
 		|| hba->active_uic_cmd || hba->uic_async_done
 		|| ufshcd_eh_in_progress(hba))
 		return;
@@ -2457,22 +2475,9 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	hba->req_abort_count = 0;
 
-	/* acquire the tag to make sure device cmds don't use it */
-	if (test_and_set_bit_lock(tag, &hba->lrb_in_use)) {
-		/*
-		 * Dev manage command in progress, requeue the command.
-		 * Requeuing the command helps in cases where the request *may*
-		 * find different tag instead of waiting for dev manage command
-		 * completion.
-		 */
-		err = SCSI_MLQUEUE_HOST_BUSY;
-		goto out;
-	}
-
 	err = ufshcd_hold(hba, true);
 	if (err) {
 		err = SCSI_MLQUEUE_HOST_BUSY;
-		clear_bit_unlock(tag, &hba->lrb_in_use);
 		goto out;
 	}
 	WARN_ON(hba->clk_gating.state != CLKS_ON);
@@ -2494,7 +2499,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (err) {
 		ufshcd_release(hba);
 		lrbp->cmd = NULL;
-		clear_bit_unlock(tag, &hba->lrb_in_use);
 		goto out;
 	}
 	/* Make sure descriptors are ready before ringing the doorbell */
@@ -2641,44 +2645,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hba,
 	return err;
 }
 
-/**
- * ufshcd_get_dev_cmd_tag - Get device management command tag
- * @hba: per-adapter instance
- * @tag_out: pointer to variable with available slot value
- *
- * Get a free slot and lock it until device management command
- * completes.
- *
- * Returns false if free slot is unavailable for locking, else
- * return true with tag value in @tag.
- */
-static bool ufshcd_get_dev_cmd_tag(struct ufs_hba *hba, int *tag_out)
-{
-	int tag;
-	bool ret = false;
-	unsigned long tmp;
-
-	if (!tag_out)
-		goto out;
-
-	do {
-		tmp = ~hba->lrb_in_use;
-		tag = find_last_bit(&tmp, hba->nutrs);
-		if (tag >= hba->nutrs)
-			goto out;
-	} while (test_and_set_bit_lock(tag, &hba->lrb_in_use));
-
-	*tag_out = tag;
-	ret = true;
-out:
-	return ret;
-}
-
-static inline void ufshcd_put_dev_cmd_tag(struct ufs_hba *hba, int tag)
-{
-	clear_bit_unlock(tag, &hba->lrb_in_use);
-}
-
 /**
  * ufshcd_exec_dev_cmd - API for sending device management requests
  * @hba: UFS hba
@@ -2691,6 +2657,8 @@ static inline void ufshcd_put_dev_cmd_tag(struct ufs_hba *hba, int tag)
 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
 {
+	struct request_queue *q = hba->cmd_queue;
+	struct request *req;
 	struct ufshcd_lrb *lrbp;
 	int err;
 	int tag;
@@ -2704,7 +2672,11 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	 * Even though we use wait_event() which sleeps indefinitely,
 	 * the maximum wait time is bounded by SCSI request timeout.
 	 */
-	wait_event(hba->dev_cmd.tag_wq, ufshcd_get_dev_cmd_tag(hba, &tag));
+	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	tag = req->tag;
+	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
@@ -2729,8 +2701,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 			err ? "query_complete_err" : "query_complete");
 
 out_put_tag:
-	ufshcd_put_dev_cmd_tag(hba, tag);
-	wake_up(&hba->dev_cmd.tag_wq);
+	blk_put_request(req);
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -4863,7 +4834,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			cmd->result = result;
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
-			clear_bit_unlock(index, &hba->lrb_in_use);
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
@@ -4885,9 +4855,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	hba->outstanding_reqs ^= completed_reqs;
 
 	ufshcd_clk_scaling_update_busy(hba);
-
-	/* we might have free'd some tags above */
-	wake_up(&hba->dev_cmd.tag_wq);
 }
 
 /**
@@ -5873,6 +5840,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					int cmd_type,
 					enum query_opcode desc_op)
 {
+	struct request_queue *q = hba->cmd_queue;
+	struct request *req;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
 	int tag;
@@ -5882,7 +5851,11 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 
 	down_read(&hba->clk_scaling_lock);
 
-	wait_event(hba->dev_cmd.tag_wq, ufshcd_get_dev_cmd_tag(hba, &tag));
+	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	tag = req->tag;
+	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
 
 	init_completion(&wait);
 	lrbp = &hba->lrb[tag];
@@ -5956,8 +5929,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 		}
 	}
 
-	ufshcd_put_dev_cmd_tag(hba, tag);
-	wake_up(&hba->dev_cmd.tag_wq);
+	blk_put_request(req);
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -6250,9 +6222,6 @@ cleanup:
 	hba->lrb[tag].cmd = NULL;
 	spin_unlock_irqrestore(host->host_lock, flags);
 
-	clear_bit_unlock(tag, &hba->lrb_in_use);
-	wake_up(&hba->dev_cmd.tag_wq);
-
 out:
 	if (!err) {
 		err = SUCCESS;
@@ -8248,6 +8217,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 {
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
+	blk_cleanup_queue(hba->cmd_queue);
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
@@ -8411,9 +8381,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	init_rwsem(&hba->clk_scaling_lock);
 
-	/* Initialize device management tag acquire wait queue */
-	init_waitqueue_head(&hba->dev_cmd.tag_wq);
-
 	ufshcd_init_clk_gating(hba);
 
 	ufshcd_init_clk_scaling(hba);
@@ -8447,6 +8414,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto exit_gating;
 	}
 
+	hba->cmd_queue = blk_mq_init_queue(&hba->host->tag_set);
+	if (IS_ERR(hba->cmd_queue)) {
+		err = PTR_ERR(hba->cmd_queue);
+		goto out_remove_scsi_host;
+	}
+
 	/* Reset the attached device */
 	ufshcd_vops_device_reset(hba);
 
@@ -8456,7 +8429,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_host_regs(hba);
 		ufshcd_print_host_state(hba);
-		goto out_remove_scsi_host;
+		goto free_cmd_queue;
 	}
 
 	/*
@@ -8493,6 +8466,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	return 0;
 
+free_cmd_queue:
+	blk_cleanup_queue(hba->cmd_queue);
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
 exit_gating:
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4f1dec68a853..8fd6fd75cb5c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -213,13 +213,11 @@ struct ufs_query {
  * @type: device management command type - Query, NOP OUT
  * @lock: lock to allow one command at a time
  * @complete: internal commands completion
- * @tag_wq: wait queue until free command slot is available
  */
 struct ufs_dev_cmd {
 	enum dev_cmd_type type;
 	struct mutex lock;
 	struct completion *complete;
-	wait_queue_head_t tag_wq;
 	struct ufs_query query;
 };
 
@@ -484,7 +482,7 @@ struct ufs_stats {
  * @host: Scsi_Host instance of the driver
  * @dev: device handle
  * @lrb: local reference block
- * @lrb_in_use: lrb in use
+ * @cmd_queue: Used to allocate command tags from hba->host->tag_set.
  * @outstanding_tasks: Bits representing outstanding task requests
  * @outstanding_reqs: Bits representing outstanding transfer requests
  * @capabilities: UFS Controller Capabilities
@@ -543,6 +541,7 @@ struct ufs_hba {
 
 	struct Scsi_Host *host;
 	struct device *dev;
+	struct request_queue *cmd_queue;
 	/*
 	 * This field is to keep a reference to "scsi_device" corresponding to
 	 * "UFS device" W-LU.
@@ -563,7 +562,6 @@ struct ufs_hba {
 	u32 ahit;
 
 	struct ufshcd_lrb *lrb;
-	unsigned long lrb_in_use;
 
 	unsigned long outstanding_tasks;
 	unsigned long outstanding_reqs;
-- 
2.30.2



