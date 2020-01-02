Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55E712EBD6
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgABWMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:12:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgABWMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:12:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F9521D7D;
        Thu,  2 Jan 2020 22:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003163;
        bh=zbbxOC3U+xaCh2dQifsmwgKsgtAVBpm/EUuz1h7kG/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WhfVoDBcJ8QTLyRo2Pe0LFz01554CEEuPPW/DHoCx2aXB3T3nU7qlgvPOVXQLnpzC
         Nr8y/Np7QTcvGSI/q9jqI8n9qGd3Z2RDigbr7jfMg57JF0jt+jE7T11ggBhNjRsksj
         RmfP/zr82qq8YEyewISbyCbHGru6A4zpYjRQEwtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/191] scsi: lpfc: Fix unexpected error messages during RSCN handling
Date:   Thu,  2 Jan 2020 23:05:28 +0100
Message-Id: <20200102215834.851129628@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f293b48616ae..4794a58deaf3 100644
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



