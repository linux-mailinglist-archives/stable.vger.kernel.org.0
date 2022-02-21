Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473134BDEEC
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352281AbiBUJyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:54:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352301AbiBUJxu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:53:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F271236E38;
        Mon, 21 Feb 2022 01:23:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F6A260E77;
        Mon, 21 Feb 2022 09:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E21FC340E9;
        Mon, 21 Feb 2022 09:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435415;
        bh=Y8mJ3Ya3WHofLon6hVeI4auxwfiA0hRb9gJOOxNHznM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05gUJONy9s0UzU3YaDfp02DqEQJxYFxp3wgG8FVcKpPImyubGRIfjMzNIg4IA1/V7
         shkjAb9e/eWjfkzh41fI+XajIbGHZuk5idcWeazqjS6N6Tn5TCwqAZvgvFWC9sy84W
         jgB/tYwJtQPHPgztlrb2BlkPUkT0tslUKOokM81g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 156/227] scsi: ufs: Fix a deadlock in the error handler
Date:   Mon, 21 Feb 2022 09:49:35 +0100
Message-Id: <20220221084940.010758428@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 945c3cca05d78351bba29fa65d93834cb7934c7b upstream.

The following deadlock has been observed on a test setup:

 - All tags allocated

 - The SCSI error handler calls ufshcd_eh_host_reset_handler()

 - ufshcd_eh_host_reset_handler() queues work that calls
   ufshcd_err_handler()

 - ufshcd_err_handler() locks up as follows:

Workqueue: ufs_eh_wq_0 ufshcd_err_handler.cfi_jt
Call trace:
 __switch_to+0x298/0x5d8
 __schedule+0x6cc/0xa94
 schedule+0x12c/0x298
 blk_mq_get_tag+0x210/0x480
 __blk_mq_alloc_request+0x1c8/0x284
 blk_get_request+0x74/0x134
 ufshcd_exec_dev_cmd+0x68/0x640
 ufshcd_verify_dev_init+0x68/0x35c
 ufshcd_probe_hba+0x12c/0x1cb8
 ufshcd_host_reset_and_restore+0x88/0x254
 ufshcd_reset_and_restore+0xd0/0x354
 ufshcd_err_handler+0x408/0xc58
 process_one_work+0x24c/0x66c
 worker_thread+0x3e8/0xa4c
 kthread+0x150/0x1b4
 ret_from_fork+0x10/0x30

Fix this lockup by making ufshcd_exec_dev_cmd() allocate a reserved
request.

Link: https://lore.kernel.org/r/20211203231950.193369-10-bvanassche@acm.org
Tested-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd.c |   53 ++++++++++++----------------------------------
 drivers/scsi/ufs/ufshcd.h |    2 +
 2 files changed, 16 insertions(+), 39 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -128,8 +128,9 @@ EXPORT_SYMBOL_GPL(ufshcd_dump_regs);
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
-	UFSHCD_CMD_PER_LUN	= 32,
-	UFSHCD_CAN_QUEUE	= 32,
+	UFSHCD_NUM_RESERVED	= 1,
+	UFSHCD_CMD_PER_LUN	= 32 - UFSHCD_NUM_RESERVED,
+	UFSHCD_CAN_QUEUE	= 32 - UFSHCD_NUM_RESERVED,
 };
 
 static const char *const ufshcd_state_name[] = {
@@ -2194,6 +2195,7 @@ static inline int ufshcd_hba_capabilitie
 	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
 	hba->nutmrs =
 	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
+	hba->reserved_slot = hba->nutrs - 1;
 
 	/* Read crypto capabilities */
 	err = ufshcd_hba_init_crypto_capabilities(hba);
@@ -2941,30 +2943,15 @@ static int ufshcd_wait_for_dev_cmd(struc
 static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 		enum dev_cmd_type cmd_type, int timeout)
 {
-	struct request_queue *q = hba->cmd_queue;
 	DECLARE_COMPLETION_ONSTACK(wait);
-	struct request *req;
+	const u32 tag = hba->reserved_slot;
 	struct ufshcd_lrb *lrbp;
 	int err;
-	int tag;
 
-	down_read(&hba->clk_scaling_lock);
+	/* Protects use of hba->reserved_slot. */
+	lockdep_assert_held(&hba->dev_cmd.lock);
 
-	/*
-	 * Get free slot, sleep if slots are unavailable.
-	 * Even though we use wait_event() which sleeps indefinitely,
-	 * the maximum wait time is bounded by SCSI request timeout.
-	 */
-	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		goto out_unlock;
-	}
-	tag = req->tag;
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
-	/* Set the timeout such that the SCSI error handler is not activated. */
-	req->timeout = msecs_to_jiffies(2 * timeout);
-	blk_mq_start_request(req);
+	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
@@ -2982,8 +2969,6 @@ static int ufshcd_exec_dev_cmd(struct uf
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
 out:
-	blk_mq_free_request(req);
-out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -6716,23 +6701,16 @@ static int ufshcd_issue_devman_upiu_cmd(
 					enum dev_cmd_type cmd_type,
 					enum query_opcode desc_op)
 {
-	struct request_queue *q = hba->cmd_queue;
 	DECLARE_COMPLETION_ONSTACK(wait);
-	struct request *req;
+	const u32 tag = hba->reserved_slot;
 	struct ufshcd_lrb *lrbp;
 	int err = 0;
-	int tag;
 	u8 upiu_flags;
 
-	down_read(&hba->clk_scaling_lock);
+	/* Protects use of hba->reserved_slot. */
+	lockdep_assert_held(&hba->dev_cmd.lock);
 
-	req = blk_mq_alloc_request(q, REQ_OP_DRV_OUT, 0);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		goto out_unlock;
-	}
-	tag = req->tag;
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
+	down_read(&hba->clk_scaling_lock);
 
 	lrbp = &hba->lrb[tag];
 	WARN_ON(lrbp->cmd);
@@ -6801,9 +6779,6 @@ static int ufshcd_issue_devman_upiu_cmd(
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
 				    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
 
-	blk_mq_free_request(req);
-
-out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
 }
@@ -9538,8 +9513,8 @@ int ufshcd_init(struct ufs_hba *hba, voi
 	/* Configure LRB */
 	ufshcd_host_memory_configure(hba);
 
-	host->can_queue = hba->nutrs;
-	host->cmd_per_lun = hba->nutrs;
+	host->can_queue = hba->nutrs - UFSHCD_NUM_RESERVED;
+	host->cmd_per_lun = hba->nutrs - UFSHCD_NUM_RESERVED;
 	host->max_id = UFSHCD_MAX_ID;
 	host->max_lun = UFS_MAX_LUNS;
 	host->max_channel = UFSHCD_MAX_CHANNEL;
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -744,6 +744,7 @@ struct ufs_hba_monitor {
  * @capabilities: UFS Controller Capabilities
  * @nutrs: Transfer Request Queue depth supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
+ * @reserved_slot: Used to submit device commands. Protected by @dev_cmd.lock.
  * @ufs_version: UFS Version to which controller complies
  * @vops: pointer to variant specific operations
  * @priv: pointer to variant specific private data
@@ -836,6 +837,7 @@ struct ufs_hba {
 	u32 capabilities;
 	int nutrs;
 	int nutmrs;
+	u32 reserved_slot;
 	u32 ufs_version;
 	const struct ufs_hba_variant_ops *vops;
 	struct ufs_hba_variant_params *vps;


