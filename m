Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37E84061D9
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241322AbhIJAoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233271AbhIJATm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 112F56023D;
        Fri, 10 Sep 2021 00:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233112;
        bh=j0Z5THm8pNFhpR/ckQ5ChNfIiMBr2JS9Wi7D0kQ9Vuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0hDNZYf9eOJSNDl900s4Nbt94uZhZYGflTWv2qxyR87fj7NTKkqJIGJJDcGwFyvu
         OyOwGknL6+9qdoXX/YXiguC8CmiAd6tJu/ebFINzpp1jiCv6exKeApe5MVzoKP+nQR
         fSKg8uxv2D5XIZFpr85i3V+Vn20vDvq04Op7Wo6zFO2uO7UDTexdKrwmMQ4jjURCOk
         ZRgKS6F/cdwnSOsnfXS0VjHAa/9xFySp/dQneKTRncD1Q5KQm4XJovVskxecVYsj4y
         yI6oec/XSd+GAl27jEzn7KLv45lZurwB2NkqJQMH88zz4Zj3IW9xL2kQfzOBd3eFKV
         D2sab0/gqPa8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 08/88] scsi: lpfc: Fix target reset handler from falsely returning FAILURE
Date:   Thu,  9 Sep 2021 20:17:00 -0400
Message-Id: <20210910001820.174272-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index eefbb9b22798..0fdf62487b06 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5941,6 +5941,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 	u32 logit = LOG_FCP;
+	u32 dev_loss_tmo = vport->cfg_devloss_tmo;
 	unsigned long flags;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
@@ -5982,39 +5983,44 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 
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

