Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C9A10BCB6
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732193AbfK0VEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:04:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732204AbfK0VEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:04:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01632216F4;
        Wed, 27 Nov 2019 21:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888691;
        bh=zam80xa7DwLhg+qzZvb77CPveO0sEY6Me+K6qqv/7KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tt7a1bMMRuY3NQsDGIGmO2J/1jBrW91Lp58MeYVE+sSgszZ54tSc7H9SBm2lQ+Rm
         bOQW6YEBrVik2Zwu5kNE++s8BFxb/nn3lpOweCOP9XOZNhoB6axe+DHqUfDkUUDt+Y
         qK1oXeQvdQ92MZxupzysKjMhMpEHQz0iiEuf+SKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 230/306] scsi: lpfc: Fix odd recovery in duplicate FLOGIs in point-to-point
Date:   Wed, 27 Nov 2019 21:31:20 +0100
Message-Id: <20191127203131.820889859@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit d496b9a7246cb9813da1fe49e14edbbbf8e232d5 ]

Testing a point-to-point topology and a case of re-FLOGI without
intervening link bouncing, showed an odd interaction with firmware and
a resulting scenario where the driver no longer probed after accepting
the new FLOGI.

Work around the firmware issue by issuing a link bounce if a FLOGI is
received after the link is already up and FLOGI's accepted.

While debugging the issue, realized that some debug traces should be
clarified to help in the future.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_els.c     | 66 ++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c |  9 +++++
 3 files changed, 64 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 43732e8d13473..ebcfcbb8b4ccc 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -490,6 +490,7 @@ struct lpfc_vport {
 	struct nvme_fc_local_port *localport;
 	uint8_t  nvmei_support; /* driver supports NVME Initiator */
 	uint32_t last_fcp_wqidx;
+	uint32_t rcv_flogi_cnt; /* How many unsol FLOGIs ACK'd. */
 };
 
 struct hbq_s {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 8bf916b9a987d..e263a486b1c6c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1057,9 +1057,9 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			goto flogifail;
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
-				 "0150 FLOGI failure Status:x%x/x%x TMO:x%x\n",
+				 "0150 FLOGI failure Status:x%x/x%x xri x%x TMO:x%x\n",
 				 irsp->ulpStatus, irsp->un.ulpWord[4],
-				 irsp->ulpTimeout);
+				 cmdiocb->sli4_xritag, irsp->ulpTimeout);
 
 		/* FLOGI failed, so there is no fabric */
 		spin_lock_irq(shost->host_lock);
@@ -1113,7 +1113,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* FLOGI completes successfully */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0101 FLOGI completes successfully, I/O tag:x%x, "
-			 "Data: x%x x%x x%x x%x x%x x%x\n", cmdiocb->iotag,
+			 "xri x%x Data: x%x x%x x%x x%x x%x %x\n",
+			 cmdiocb->iotag, cmdiocb->sli4_xritag,
 			 irsp->un.ulpWord[4], sp->cmn.e_d_tov,
 			 sp->cmn.w2.r_a_tov, sp->cmn.edtovResolution,
 			 vport->port_state, vport->fc_flag);
@@ -4266,14 +4267,6 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	default:
 		return 1;
 	}
-	/* Xmit ELS ACC response tag <ulpIoTag> */
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0128 Xmit ELS ACC response tag x%x, XRI: x%x, "
-			 "DID: x%x, nlp_flag: x%x nlp_state: x%x RPI: x%x "
-			 "fc_flag x%x\n",
-			 elsiocb->iotag, elsiocb->iocb.ulpContext,
-			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
-			 ndlp->nlp_rpi, vport->fc_flag);
 	if (ndlp->nlp_flag & NLP_LOGO_ACC) {
 		spin_lock_irq(shost->host_lock);
 		if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED ||
@@ -4442,6 +4435,15 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
+
+	/* Xmit ELS ACC response tag <ulpIoTag> */
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "0128 Xmit ELS ACC response Status: x%x, IoTag: x%x, "
+			 "XRI: x%x, DID: x%x, nlp_flag: x%x nlp_state: x%x "
+			 "RPI: x%x, fc_flag x%x\n",
+			 rc, elsiocb->iotag, elsiocb->sli4_xritag,
+			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
+			 ndlp->nlp_rpi, vport->fc_flag);
 	return 0;
 }
 
@@ -6452,6 +6454,11 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	port_state = vport->port_state;
 	vport->fc_flag |= FC_PT2PT;
 	vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
+
+	/* Acking an unsol FLOGI.  Count 1 for link bounce
+	 * work-around.
+	 */
+	vport->rcv_flogi_cnt++;
 	spin_unlock_irq(shost->host_lock);
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "3311 Rcv Flogi PS x%x new PS x%x "
@@ -7849,8 +7856,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	struct ls_rjt stat;
 	uint32_t *payload;
 	uint32_t cmd, did, newnode;
-	uint8_t rjt_exp, rjt_err = 0;
+	uint8_t rjt_exp, rjt_err = 0, init_link = 0;
 	IOCB_t *icmd = &elsiocb->iocb;
+	LPFC_MBOXQ_t *mbox;
 
 	if (!vport || !(elsiocb->context2))
 		goto dropit;
@@ -7999,6 +8007,19 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			did, vport->port_state, ndlp->nlp_flag);
 
 		phba->fc_stat.elsRcvFLOGI++;
+
+		/* If the driver believes fabric discovery is done and is ready,
+		 * bounce the link.  There is some descrepancy.
+		 */
+		if (vport->port_state >= LPFC_LOCAL_CFG_LINK &&
+		    vport->fc_flag & FC_PT2PT &&
+		    vport->rcv_flogi_cnt >= 1) {
+			rjt_err = LSRJT_LOGICAL_BSY;
+			rjt_exp = LSEXP_NOTHING_MORE;
+			init_link++;
+			goto lsrjt;
+		}
+
 		lpfc_els_rcv_flogi(vport, elsiocb, ndlp);
 		if (newnode)
 			lpfc_nlp_put(ndlp);
@@ -8227,6 +8248,27 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	lpfc_nlp_put(elsiocb->context1);
 	elsiocb->context1 = NULL;
+
+	/* Special case.  Driver received an unsolicited command that
+	 * unsupportable given the driver's current state.  Reset the
+	 * link and start over.
+	 */
+	if (init_link) {
+		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!mbox)
+			return;
+		lpfc_linkdown(phba);
+		lpfc_init_link(phba, mbox,
+			       phba->cfg_topology,
+			       phba->cfg_link_speed);
+		mbox->u.mb.un.varInitLnk.lipsr_AL_PA = 0;
+		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		mbox->vport = vport;
+		if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) ==
+		    MBX_NOT_FINISHED)
+			mempool_free(mbox, phba->mbox_mem_pool);
+	}
+
 	return;
 
 dropit:
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 0d19e5f6b3bcc..68f223882d96b 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -952,6 +952,7 @@ lpfc_linkdown(struct lpfc_hba *phba)
 		}
 		spin_lock_irq(shost->host_lock);
 		phba->pport->fc_flag &= ~(FC_PT2PT | FC_PT2PT_PLOGI);
+		phba->pport->rcv_flogi_cnt = 0;
 		spin_unlock_irq(shost->host_lock);
 	}
 	return 0;
@@ -1023,6 +1024,7 @@ lpfc_linkup(struct lpfc_hba *phba)
 {
 	struct lpfc_vport **vports;
 	int i;
+	struct Scsi_Host  *shost = lpfc_shost_from_vport(phba->pport);
 
 	phba->link_state = LPFC_LINK_UP;
 
@@ -1036,6 +1038,13 @@ lpfc_linkup(struct lpfc_hba *phba)
 			lpfc_linkup_port(vports[i]);
 	lpfc_destroy_vport_work_array(phba, vports);
 
+	/* Clear the pport flogi counter in case the link down was
+	 * absorbed without an ACQE. No lock here - in worker thread
+	 * and discovery is synchronized.
+	 */
+	spin_lock_irq(shost->host_lock);
+	phba->pport->rcv_flogi_cnt = 0;
+	spin_unlock_irq(shost->host_lock);
 	return 0;
 }
 
-- 
2.20.1



