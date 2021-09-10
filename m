Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB02140607E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhIJARg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhIJARY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 219676023D;
        Fri, 10 Sep 2021 00:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232972;
        bh=puLy5GmnFI5fM5v84lWp0Z/htb27qwyS5L/10OPTVSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6Kr/aIoQV+gFMba9WHTsH2nyXfqTDmgwOktOn+CcG8ihdu3115dlEylhb6FpkvPI
         Mha/I0/fEEnDO1n0Yrvo4DCGhDIrlTjr8q1bPqn+f2x7ffUUPBv1DoyW8mjMu8rlMC
         Dk8b6WGvC/5Ej2HRy9yFtkT796JBtSp3eL0CKYmVB6R7Yr4vDjJ6Tg/OLKUyb2NaJc
         sQ6mPPHC1w5oDZkcf9FE0vlHK6nMvyinDfIwSw6hHSHaCS8wOBK/kmFSiAhCxcFmGG
         NITURPFtqUh5sy3WzWq8GGK//o2k6MzJ24isa2JszEkgoSXOUwLc0oyD0BN3GD4L7a
         kXnIIPKWDaOdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 10/99] scsi: lpfc: Fix target reset handler from falsely returning FAILURE
Date:   Thu,  9 Sep 2021 20:14:29 -0400
Message-Id: <20210910001558.173296-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 21990d3d1861c7aa8e3e4ed98614f0c161c29b0c ]

Previous logic accidentally overrides the status variable to FAILURE when
target reset status is SUCCESS.

Refactor the non-SUCCESS logic of lpfc_vmid_vport_cleanup(), which resolves
the false override.

Link: https://lore.kernel.org/r/20210707184351.67872-7-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 68 +++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 1b248c237be1..10002a13c5c6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6273,6 +6273,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 	u32 logit = LOG_FCP;
+	u32 dev_loss_tmo = vport->cfg_devloss_tmo;
 	unsigned long flags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
@@ -6314,39 +6315,44 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 
 	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
 					FCP_TARGET_RESET);
-	if (status != SUCCESS)
-		logit =  LOG_TRACE_EVENT;
-	spin_lock_irqsave(&pnode->lock, flags);
-	if (status != SUCCESS &&
-	    (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO)) &&
-	     !pnode->logo_waitq) {
-		pnode->logo_waitq = &waitq;
-		pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
-		pnode->nlp_flag |= NLP_ISSUE_LOGO;
-		pnode->upcall_flags |= NLP_WAIT_FOR_LOGO;
-		spin_unlock_irqrestore(&pnode->lock, flags);
-		lpfc_unreg_rpi(vport, pnode);
-		wait_event_timeout(waitq,
-				   (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO)),
-				    msecs_to_jiffies(vport->cfg_devloss_tmo *
-				    1000));
-
-		if (pnode->upcall_flags & NLP_WAIT_FOR_LOGO) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				"0725 SCSI layer TGTRST failed & LOGO TMO "
-				" (%d, %llu) return x%x\n", tgt_id,
-				 lun_id, status);
-			spin_lock_irqsave(&pnode->lock, flags);
-			pnode->upcall_flags &= ~NLP_WAIT_FOR_LOGO;
+	if (status != SUCCESS) {
+		logit = LOG_TRACE_EVENT;
+
+		/* Issue LOGO, if no LOGO is outstanding */
+		spin_lock_irqsave(&pnode->lock, flags);
+		if (!(pnode->upcall_flags & NLP_WAIT_FOR_LOGO) &&
+		    !pnode->logo_waitq) {
+			pnode->logo_waitq = &waitq;
+			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
+			pnode->nlp_flag |= NLP_ISSUE_LOGO;
+			pnode->upcall_flags |= NLP_WAIT_FOR_LOGO;
+			spin_unlock_irqrestore(&pnode->lock, flags);
+			lpfc_unreg_rpi(vport, pnode);
+			wait_event_timeout(waitq,
+					   (!(pnode->upcall_flags &
+					      NLP_WAIT_FOR_LOGO)),
+					   msecs_to_jiffies(dev_loss_tmo *
+							    1000));
+
+			if (pnode->upcall_flags & NLP_WAIT_FOR_LOGO) {
+				lpfc_printf_vlog(vport, KERN_ERR, logit,
+						 "0725 SCSI layer TGTRST "
+						 "failed & LOGO TMO (%d, %llu) "
+						 "return x%x\n",
+						 tgt_id, lun_id, status);
+				spin_lock_irqsave(&pnode->lock, flags);
+				pnode->upcall_flags &= ~NLP_WAIT_FOR_LOGO;
+			} else {
+				spin_lock_irqsave(&pnode->lock, flags);
+			}
+			pnode->logo_waitq = NULL;
+			spin_unlock_irqrestore(&pnode->lock, flags);
+			status = SUCCESS;
+
 		} else {
-			spin_lock_irqsave(&pnode->lock, flags);
+			spin_unlock_irqrestore(&pnode->lock, flags);
+			status = FAILED;
 		}
-		pnode->logo_waitq = NULL;
-		spin_unlock_irqrestore(&pnode->lock, flags);
-		status = SUCCESS;
-	} else {
-		status = FAILED;
-		spin_unlock_irqrestore(&pnode->lock, flags);
 	}
 
 	lpfc_printf_vlog(vport, KERN_ERR, logit,
-- 
2.30.2

