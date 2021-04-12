Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903FA35C0B6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241326AbhDLJPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:34722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240464AbhDLJKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2F4761352;
        Mon, 12 Apr 2021 09:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218339;
        bh=6BLVn1Wa0+euop0rdSqxIbUARTug8N8n3LuFwV4962o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rut3b2cKVZ9VC9/IyY5ymRAX6wbrsPVIIKIUGKPzPVgLTgP9xKYBSk0pGh35RSkpT
         bSV2dZLD3+8AgRsL+yYa8llMmFPzIv2N8VJjWGnyTmDGNc8dAYfpQ5kHtQgLD5U7CE
         4cLdD/kwAvHSDlNLRGDbRtfmuEoNcVVLSCuhFIdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 159/210] scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs
Date:   Mon, 12 Apr 2021 10:41:04 +0200
Message-Id: <20210412084021.308339234@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 4b42d557a8add52b9a9924fb31e40a218aab7801 ]

In __ufshcd_issue_tm_cmd(), it is not correct to use hba->nutrs + req->tag
as the Task Tag in a TMR UPIU. Directly use req->tag as the Task Tag.

Fixes: e293313262d3 ("scsi: ufs: Fix broken task management command implementation")
Link: https://lore.kernel.org/r/1617262750-4864-3-git-send-email-cang@codeaurora.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c801f88007dd..e53a3f89e863 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6363,38 +6363,34 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request *req;
 	unsigned long flags;
-	int free_slot, task_tag, err;
+	int task_tag, err;
 
 	/*
-	 * Get free slot, sleep if slots are unavailable.
-	 * Even though we use wait_event() which sleeps indefinitely,
-	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
+	 * blk_get_request() is used here only to get a free tag.
 	 */
 	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
 	req->end_io_data = &wait;
-	free_slot = req->tag;
-	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
 	ufshcd_hold(hba, false);
 
 	spin_lock_irqsave(host->host_lock, flags);
-	task_tag = hba->nutrs + free_slot;
 	blk_mq_start_request(req);
 
+	task_tag = req->tag;
 	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
 
-	memcpy(hba->utmrdl_base_addr + free_slot, treq, sizeof(*treq));
-	ufshcd_vops_setup_task_mgmt(hba, free_slot, tm_function);
+	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
+	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
 
 	/* send command to the controller */
-	__set_bit(free_slot, &hba->outstanding_tasks);
+	__set_bit(task_tag, &hba->outstanding_tasks);
 
 	/* Make sure descriptors are ready before ringing the task doorbell */
 	wmb();
 
-	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
 
@@ -6414,24 +6410,24 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete_err");
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-		if (ufshcd_clear_tm_cmd(hba, free_slot))
-			dev_WARN(hba->dev, "%s: unable clear tm cmd (slot %d) after timeout\n",
-					__func__, free_slot);
+		if (ufshcd_clear_tm_cmd(hba, task_tag))
+			dev_WARN(hba->dev, "%s: unable to clear tm cmd (slot %d) after timeout\n",
+					__func__, task_tag);
 		err = -ETIMEDOUT;
 	} else {
 		err = 0;
-		memcpy(treq, hba->utmrdl_base_addr + free_slot, sizeof(*treq));
+		memcpy(treq, hba->utmrdl_base_addr + task_tag, sizeof(*treq));
 
 		ufshcd_add_tm_upiu_trace(hba, task_tag, "tm_complete");
 	}
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	__clear_bit(free_slot, &hba->outstanding_tasks);
+	__clear_bit(task_tag, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	ufshcd_release(hba);
 	blk_put_request(req);
 
-	ufshcd_release(hba);
 	return err;
 }
 
-- 
2.30.2



