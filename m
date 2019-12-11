Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8827E11B735
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731204AbfLKPMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:34742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730815AbfLKPMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6E262465E;
        Wed, 11 Dec 2019 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077159;
        bh=KhsJlt8mJmKhtd62rZZlnvygPNnMkacTIfjNnVH+Zqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/eth3NzEXp8Jn9p5ESnx1AYIKTLibV02Y4/2RkzRIyX8OJ19Y/wAzq9q04z7p6Ak
         kEytisqzA3/5MUgNxiOUZqQgE25mZx5yRlK05NF7D/aGm7KRgFVPMwaQiSPrQ0PGFE
         bmfZDM3cpIFBMIKuZQUVJR/RbUl2qJT+mWjYyu1c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 045/134] scsi: lpfc: Fix unexpected error messages during RSCN handling
Date:   Wed, 11 Dec 2019 10:10:21 -0500
Message-Id: <20191211151150.19073-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 2332e6e475b016e2026763f51333f84e2e6c57a3 ]

During heavy RCN activity and log_verbose = 0 we see these messages:

  2754 PRLI failure DID:521245 Status:x9/xb2c00, data: x0
  0231 RSCN timeout Data: x0 x3
  0230 Unexpected timeout, hba link state x5

This is due to delayed RSCN activity.

Correct by avoiding the timeout thus the messages by restarting the
discovery timeout whenever an rscn is received.

Filter PRLI responses such that severity depends on whether expected for
the configuration or not. For example, PRLI errors on a fabric will be
informational (they are expected), but Point-to-Point errors are not
necessarily expected so they are raised to an error level.

Link: https://lore.kernel.org/r/20191105005708.7399-5-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f293b48616ae9..4794a58deaf3c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2236,6 +2236,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
+	char *mode;
 
 	/* we pass cmdiocb to state machine which needs rspiocb as well */
 	cmdiocb->context_un.rsp_iocb = rspiocb;
@@ -2273,8 +2274,17 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		}
 
+		/* If we don't send GFT_ID to Fabric, a PRLI error
+		 * could be expected.
+		 */
+		if ((vport->fc_flag & FC_FABRIC) ||
+		    (vport->cfg_enable_fc4_type != LPFC_ENABLE_BOTH))
+			mode = KERN_ERR;
+		else
+			mode = KERN_INFO;
+
 		/* PRLI failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+		lpfc_printf_vlog(vport, mode, LOG_ELS,
 				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
 				 "data: x%x\n",
 				 ndlp->nlp_DID, irsp->ulpStatus,
@@ -6455,7 +6465,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t payload_len, length, nportid, *cmd;
 	int rscn_cnt;
 	int rscn_id = 0, hba_id = 0;
-	int i;
+	int i, tmo;
 
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	lp = (uint32_t *) pcmd->virt;
@@ -6561,6 +6571,13 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_RSCN_DEFERRED;
+
+		/* Restart disctmo if its already running */
+		if (vport->fc_flag & FC_DISC_TMO) {
+			tmo = ((phba->fc_ratov * 3) + 3);
+			mod_timer(&vport->fc_disctmo,
+				  jiffies + msecs_to_jiffies(1000 * tmo));
+		}
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !(vport->fc_flag & FC_RSCN_DISCOVERY)) {
 			vport->fc_flag |= FC_RSCN_MODE;
-- 
2.20.1

