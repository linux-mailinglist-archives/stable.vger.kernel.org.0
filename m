Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A7926F49B
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgIRCBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbgIRCBQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7062E2311D;
        Fri, 18 Sep 2020 02:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394475;
        bh=EaE8uzh+V7InOu/IPtCdPhnQwn7PbKle9qLJQ30Qsfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSxW4PVzvl91ru15cAW4hq4MQmoovAlrBYlf4CC5CrZoC3DWqqnbB8XL7NTt99dF/
         x6j88yTUJmql8B/EFb48fQZgu4DvXIFWbwvlq08pJUIrih7UW6Oi83VSbtv0AUHBrt
         P9NMn+SJkHtKtUAk5+xUfw2AvLWNtLE+YgfNDkOc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 003/330] scsi: lpfc: Fix pt2pt discovery on SLI3 HBAs
Date:   Thu, 17 Sep 2020 21:55:43 -0400
Message-Id: <20200918020110.2063155-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 359e10f087dbb7b9c9f3035a8cc4391af45bd651 ]

After exchanging PLOGI on an SLI-3 adapter, the PRLI exchange failed.  Link
trace showed the port was assigned a non-zero n_port_id, but didn't use the
address on the PRLI. The assigned address is set on the port by the
CONFIG_LINK mailbox command. The driver responded to the PRLI before the
mailbox command completed. Thus the PRLI response used the old n_port_id.

Defer the PRLI response until CONFIG_LINK completes.

Link: https://lore.kernel.org/r/20190922035906.10977-2-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 141 +++++++++++++++++++++++------
 1 file changed, 115 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 6961713825585..2a340624bfc99 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -279,6 +279,55 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	lpfc_cancel_retry_delay_tmo(phba->pport, ndlp);
 }
 
+/* lpfc_defer_pt2pt_acc - Complete SLI3 pt2pt processing on link up
+ * @phba: pointer to lpfc hba data structure.
+ * @link_mbox: pointer to CONFIG_LINK mailbox object
+ *
+ * This routine is only called if we are SLI3, direct connect pt2pt
+ * mode and the remote NPort issues the PLOGI after link up.
+ */
+void
+lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
+{
+	LPFC_MBOXQ_t *login_mbox;
+	MAILBOX_t *mb = &link_mbox->u.mb;
+	struct lpfc_iocbq *save_iocb;
+	struct lpfc_nodelist *ndlp;
+	int rc;
+
+	ndlp = link_mbox->ctx_ndlp;
+	login_mbox = link_mbox->context3;
+	save_iocb = login_mbox->context3;
+	link_mbox->context3 = NULL;
+	login_mbox->context3 = NULL;
+
+	/* Check for CONFIG_LINK error */
+	if (mb->mbxStatus) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"4575 CONFIG_LINK fails pt2pt discovery: %x\n",
+				mb->mbxStatus);
+		mempool_free(login_mbox, phba->mbox_mem_pool);
+		mempool_free(link_mbox, phba->mbox_mem_pool);
+		lpfc_sli_release_iocbq(phba, save_iocb);
+		return;
+	}
+
+	/* Now that CONFIG_LINK completed, and our SID is configured,
+	 * we can now proceed with sending the PLOGI ACC.
+	 */
+	rc = lpfc_els_rsp_acc(link_mbox->vport, ELS_CMD_PLOGI,
+			      save_iocb, ndlp, login_mbox);
+	if (rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"4576 PLOGI ACC fails pt2pt discovery: %x\n",
+				rc);
+		mempool_free(login_mbox, phba->mbox_mem_pool);
+	}
+
+	mempool_free(link_mbox, phba->mbox_mem_pool);
+	lpfc_sli_release_iocbq(phba, save_iocb);
+}
+
 static int
 lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	       struct lpfc_iocbq *cmdiocb)
@@ -291,10 +340,12 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	IOCB_t *icmd;
 	struct serv_parm *sp;
 	uint32_t ed_tov;
-	LPFC_MBOXQ_t *mbox;
+	LPFC_MBOXQ_t *link_mbox;
+	LPFC_MBOXQ_t *login_mbox;
+	struct lpfc_iocbq *save_iocb;
 	struct ls_rjt stat;
 	uint32_t vid, flag;
-	int rc;
+	int rc, defer_acc;
 
 	memset(&stat, 0, sizeof (struct ls_rjt));
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
@@ -343,6 +394,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	else
 		ndlp->nlp_fcp_info |= CLASS3;
 
+	defer_acc = 0;
 	ndlp->nlp_class_sup = 0;
 	if (sp->cls1.classValid)
 		ndlp->nlp_class_sup |= FC_COS_CLASS1;
@@ -354,7 +406,6 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		ndlp->nlp_class_sup |= FC_COS_CLASS4;
 	ndlp->nlp_maxframe =
 		((sp->cmn.bbRcvSizeMsb & 0x0F) << 8) | sp->cmn.bbRcvSizeLsb;
-
 	/* if already logged in, do implicit logout */
 	switch (ndlp->nlp_state) {
 	case  NLP_STE_NPR_NODE:
@@ -396,6 +447,10 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 	ndlp->nlp_flag &= ~NLP_FIRSTBURST;
 
+	login_mbox = NULL;
+	link_mbox = NULL;
+	save_iocb = NULL;
+
 	/* Check for Nport to NPort pt2pt protocol */
 	if ((vport->fc_flag & FC_PT2PT) &&
 	    !(vport->fc_flag & FC_PT2PT_PLOGI)) {
@@ -423,17 +478,22 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (phba->sli_rev == LPFC_SLI_REV4)
 			lpfc_issue_reg_vfi(vport);
 		else {
-			mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-			if (mbox == NULL)
+			defer_acc = 1;
+			link_mbox = mempool_alloc(phba->mbox_mem_pool,
+						  GFP_KERNEL);
+			if (!link_mbox)
 				goto out;
-			lpfc_config_link(phba, mbox);
-			mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-			mbox->vport = vport;
-			rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
-			if (rc == MBX_NOT_FINISHED) {
-				mempool_free(mbox, phba->mbox_mem_pool);
+			lpfc_config_link(phba, link_mbox);
+			link_mbox->mbox_cmpl = lpfc_defer_pt2pt_acc;
+			link_mbox->vport = vport;
+			link_mbox->ctx_ndlp = ndlp;
+
+			save_iocb = lpfc_sli_get_iocbq(phba);
+			if (!save_iocb)
 				goto out;
-			}
+			/* Save info from cmd IOCB used in rsp */
+			memcpy((uint8_t *)save_iocb, (uint8_t *)cmdiocb,
+			       sizeof(struct lpfc_iocbq));
 		}
 
 		lpfc_can_disctmo(vport);
@@ -448,8 +508,8 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			ndlp->nlp_flag |= NLP_SUPPRESS_RSP;
 	}
 
-	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-	if (!mbox)
+	login_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!login_mbox)
 		goto out;
 
 	/* Registering an existing RPI behaves differently for SLI3 vs SLI4 */
@@ -457,21 +517,19 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		lpfc_unreg_rpi(vport, ndlp);
 
 	rc = lpfc_reg_rpi(phba, vport->vpi, icmd->un.rcvels.remoteID,
-			    (uint8_t *) sp, mbox, ndlp->nlp_rpi);
-	if (rc) {
-		mempool_free(mbox, phba->mbox_mem_pool);
+			    (uint8_t *)sp, login_mbox, ndlp->nlp_rpi);
+	if (rc)
 		goto out;
-	}
 
 	/* ACC PLOGI rsp command needs to execute first,
-	 * queue this mbox command to be processed later.
+	 * queue this login_mbox command to be processed later.
 	 */
-	mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
+	login_mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
 	/*
-	 * mbox->ctx_ndlp = lpfc_nlp_get(ndlp) deferred until mailbox
+	 * login_mbox->ctx_ndlp = lpfc_nlp_get(ndlp) deferred until mailbox
 	 * command issued in lpfc_cmpl_els_acc().
 	 */
-	mbox->vport = vport;
+	login_mbox->vport = vport;
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI);
 	spin_unlock_irq(shost->host_lock);
@@ -506,16 +564,47 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		stat.un.b.lsRjtRsnCode = LSRJT_INVALID_CMD;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
 		rc = lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb,
-			ndlp, mbox);
+			ndlp, login_mbox);
 		if (rc)
-			mempool_free(mbox, phba->mbox_mem_pool);
+			mempool_free(login_mbox, phba->mbox_mem_pool);
 		return 1;
 	}
-	rc = lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, mbox);
+	if (defer_acc) {
+		/* So the order here should be:
+		 * Issue CONFIG_LINK mbox
+		 * CONFIG_LINK cmpl
+		 * Issue PLOGI ACC
+		 * PLOGI ACC cmpl
+		 * Issue REG_LOGIN mbox
+		 */
+
+		/* Save the REG_LOGIN mbox for and rcv IOCB copy later */
+		link_mbox->context3 = login_mbox;
+		login_mbox->context3 = save_iocb;
+
+		/* Start the ball rolling by issuing CONFIG_LINK here */
+		rc = lpfc_sli_issue_mbox(phba, link_mbox, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED)
+			goto out;
+		return 1;
+	}
+
+	rc = lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, login_mbox);
 	if (rc)
-		mempool_free(mbox, phba->mbox_mem_pool);
+		mempool_free(login_mbox, phba->mbox_mem_pool);
 	return 1;
 out:
+	if (defer_acc)
+		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
+				"4577 pt2pt discovery failure: %p %p %p\n",
+				save_iocb, link_mbox, login_mbox);
+	if (save_iocb)
+		lpfc_sli_release_iocbq(phba, save_iocb);
+	if (link_mbox)
+		mempool_free(link_mbox, phba->mbox_mem_pool);
+	if (login_mbox)
+		mempool_free(login_mbox, phba->mbox_mem_pool);
+
 	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 	stat.un.b.lsRjtRsnCodeExp = LSEXP_OUT_OF_RESOURCE;
 	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
-- 
2.25.1

