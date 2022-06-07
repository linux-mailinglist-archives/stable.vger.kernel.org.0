Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF574537BF1
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiE3N2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbiE3N10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:27:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBAF84A02;
        Mon, 30 May 2022 06:25:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1B0360EA5;
        Mon, 30 May 2022 13:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 161F8C36AE7;
        Mon, 30 May 2022 13:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917147;
        bh=2KToFwkNvNzfdHZcKKJhemrDipNoBJWJHSrlZBAWX2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYMsTlRuxe7knRvbc1mGE/bxyE7UaxMYNaJ05MkxqVFJ5oEnznWHn02vT4Dsu9EpK
         6d1vmt0WH3P4QHvXhZUZdFc5s8Xs5exY7msNKNfxM69oF4CKB1gojDWDiSo6klSEGv
         jtex8VZDjmM5YwRI3nWKcLj8iLIObR3ING/RZAlh2pWNvB6gKvlJ3qhpyg6uZt+RUv
         9btudViPTMfrBNmglINbE81GfdiQNMpJLg6ygPr6CNaubK8zlEjSO+VH85J5p89zCB
         DxIQqW+oa3cXpPh+kJKwgxtGuIxa5fvRa+njXZZkBzgLkzFsi1FZpJh3jymiWjWSB+
         pOYZMt4obRiKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 036/159] scsi: lpfc: Fix SCSI I/O completion and abort handler deadlock
Date:   Mon, 30 May 2022 09:22:21 -0400
Message-Id: <20220530132425.1929512-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 03cbbd7c2f5ee288f648f4aeedc765a181188553 ]

During stress I/O tests with 500+ vports, hard LOCKUP call traces are
observed.

CPU A:
 native_queued_spin_lock_slowpath+0x192
 _raw_spin_lock_irqsave+0x32
 lpfc_handle_fcp_err+0x4c6
 lpfc_fcp_io_cmd_wqe_cmpl+0x964
 lpfc_sli4_fp_handle_cqe+0x266
 __lpfc_sli4_process_cq+0x105
 __lpfc_sli4_hba_process_cq+0x3c
 lpfc_cq_poll_hdler+0x16
 irq_poll_softirq+0x76
 __softirqentry_text_start+0xe4
 irq_exit+0xf7
 do_IRQ+0x7f

CPU B:
 native_queued_spin_lock_slowpath+0x5b
 _raw_spin_lock+0x1c
 lpfc_abort_handler+0x13e
 scmd_eh_abort_handler+0x85
 process_one_work+0x1a7
 worker_thread+0x30
 kthread+0x112
 ret_from_fork+0x1f

Diagram of lockup:

CPUA                            CPUB
----                            ----
lpfc_cmd->buf_lock
                            phba->hbalock
                            lpfc_cmd->buf_lock
phba->hbalock

Fix by reordering the taking of the lpfc_cmd->buf_lock and phba->hbalock in
lpfc_abort_handler routine so that it tries to take the lpfc_cmd->buf_lock
first before phba->hbalock.

Link: https://lore.kernel.org/r/20220412222008.126521-7-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ba9dbb51b75f..c4fa7d68fe03 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5864,25 +5864,25 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	if (!lpfc_cmd)
 		return ret;
 
-	spin_lock_irqsave(&phba->hbalock, flags);
+	/* Guard against IO completion being called at same time */
+	spin_lock_irqsave(&lpfc_cmd->buf_lock, flags);
+
+	spin_lock(&phba->hbalock);
 	/* driver queued commands are in process of being flushed */
 	if (phba->hba_flag & HBA_IOQ_FLUSH) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			"3168 SCSI Layer abort requested I/O has been "
 			"flushed by LLD.\n");
 		ret = FAILED;
-		goto out_unlock;
+		goto out_unlock_hba;
 	}
 
-	/* Guard against IO completion being called at same time */
-	spin_lock(&lpfc_cmd->buf_lock);
-
 	if (!lpfc_cmd->pCmd) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
 			 "x%x ID %d LUN %llu\n",
 			 SUCCESS, cmnd->device->id, cmnd->device->lun);
-		goto out_unlock_buf;
+		goto out_unlock_hba;
 	}
 
 	iocb = &lpfc_cmd->cur_iocbq;
@@ -5890,7 +5890,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		pring_s4 = phba->sli4_hba.hdwq[iocb->hba_wqidx].io_wq->pring;
 		if (!pring_s4) {
 			ret = FAILED;
-			goto out_unlock_buf;
+			goto out_unlock_hba;
 		}
 		spin_lock(&pring_s4->ring_lock);
 	}
@@ -5923,8 +5923,8 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 			 "3389 SCSI Layer I/O Abort Request is pending\n");
 		if (phba->sli_rev == LPFC_SLI_REV4)
 			spin_unlock(&pring_s4->ring_lock);
-		spin_unlock(&lpfc_cmd->buf_lock);
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock(&phba->hbalock);
+		spin_unlock_irqrestore(&lpfc_cmd->buf_lock, flags);
 		goto wait_for_cmpl;
 	}
 
@@ -5945,15 +5945,13 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	if (ret_val != IOCB_SUCCESS) {
 		/* Indicate the IO is not being aborted by the driver. */
 		lpfc_cmd->waitq = NULL;
-		spin_unlock(&lpfc_cmd->buf_lock);
-		spin_unlock_irqrestore(&phba->hbalock, flags);
 		ret = FAILED;
-		goto out;
+		goto out_unlock_hba;
 	}
 
 	/* no longer need the lock after this point */
-	spin_unlock(&lpfc_cmd->buf_lock);
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock(&phba->hbalock);
+	spin_unlock_irqrestore(&lpfc_cmd->buf_lock, flags);
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 		lpfc_sli_handle_fast_ring_event(phba,
@@ -5988,10 +5986,9 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 out_unlock_ring:
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_unlock(&pring_s4->ring_lock);
-out_unlock_buf:
-	spin_unlock(&lpfc_cmd->buf_lock);
-out_unlock:
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+out_unlock_hba:
+	spin_unlock(&phba->hbalock);
+	spin_unlock_irqrestore(&lpfc_cmd->buf_lock, flags);
 out:
 	lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "0749 SCSI Layer I/O Abort Request Status x%x ID %d "
-- 
2.35.1

