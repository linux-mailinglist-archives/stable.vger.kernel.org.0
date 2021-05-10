Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763B037889F
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbhEJLW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:22:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234856AbhEJLJr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B97611F1;
        Mon, 10 May 2021 11:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644710;
        bh=Ayktig4YWZFlY/e3z1KCB6HoBKQ2ROFAifm3akDuuVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kex4dsEmmrfy4K1pQvAKeCjy06KQvpaQQnqDDoWehbb2KjbRflTpXzio1iCaVMPlc
         LJ3+iz0KhhXKKtoJKb7QeMp2pcMI11YsYyr4Ip5x1t3QQOKf669EytlM3aVdBMBZW/
         co8QamSEG+Y6H6lFLBnCb7nAmHxW2rdTOyoVuchY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 157/384] scsi: lpfc: Fix PLOGI ACC to be transmit after REG_LOGIN
Date:   Mon, 10 May 2021 12:19:06 +0200
Message-Id: <20210510102020.059448046@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 143753059b8b957f1cf4355338a3e3a32f3a85bf ]

The driver is seeing a scenario where PLOGI response was issued and traffic
is arriving while the adapter is still setting up the login context. This
is resulting in errors handling the traffic.

Change the driver so that PLOGI response is sent after the login context
has been setup to avoid the situation.

Link: https://lore.kernel.org/r/20210301171821.3427-14-jsmart2021@gmail.com
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 239 +++++++++--------------------
 1 file changed, 70 insertions(+), 169 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index ef8feb933cd8..7fc796905a7a 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -279,106 +279,43 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	lpfc_cancel_retry_delay_tmo(phba->pport, ndlp);
 }
 
-/* lpfc_defer_pt2pt_acc - Complete SLI3 pt2pt processing on link up
+/* lpfc_defer_plogi_acc - Issue PLOGI ACC after reg_login completes
  * @phba: pointer to lpfc hba data structure.
- * @link_mbox: pointer to CONFIG_LINK mailbox object
+ * @login_mbox: pointer to REG_RPI mailbox object
  *
- * This routine is only called if we are SLI3, direct connect pt2pt
- * mode and the remote NPort issues the PLOGI after link up.
+ * The ACC for a rcv'ed PLOGI is deferred until AFTER the REG_RPI completes
  */
 static void
-lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
+lpfc_defer_plogi_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *login_mbox)
 {
-	LPFC_MBOXQ_t *login_mbox;
-	MAILBOX_t *mb = &link_mbox->u.mb;
 	struct lpfc_iocbq *save_iocb;
 	struct lpfc_nodelist *ndlp;
+	MAILBOX_t *mb = &login_mbox->u.mb;
+
 	int rc;
 
-	ndlp = link_mbox->ctx_ndlp;
-	login_mbox = link_mbox->context3;
+	ndlp = login_mbox->ctx_ndlp;
 	save_iocb = login_mbox->context3;
-	link_mbox->context3 = NULL;
-	login_mbox->context3 = NULL;
-
-	/* Check for CONFIG_LINK error */
-	if (mb->mbxStatus) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"4575 CONFIG_LINK fails pt2pt discovery: %x\n",
-				mb->mbxStatus);
-		mempool_free(login_mbox, phba->mbox_mem_pool);
-		mempool_free(link_mbox, phba->mbox_mem_pool);
-		kfree(save_iocb);
-		return;
-	}
 
-	/* Now that CONFIG_LINK completed, and our SID is configured,
-	 * we can now proceed with sending the PLOGI ACC.
-	 */
-	rc = lpfc_els_rsp_acc(link_mbox->vport, ELS_CMD_PLOGI,
-			      save_iocb, ndlp, login_mbox);
-	if (rc) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"4576 PLOGI ACC fails pt2pt discovery: %x\n",
-				rc);
-		mempool_free(login_mbox, phba->mbox_mem_pool);
+	if (mb->mbxStatus == MBX_SUCCESS) {
+		/* Now that REG_RPI completed successfully,
+		 * we can now proceed with sending the PLOGI ACC.
+		 */
+		rc = lpfc_els_rsp_acc(login_mbox->vport, ELS_CMD_PLOGI,
+				      save_iocb, ndlp, NULL);
+		if (rc) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+					"4576 PLOGI ACC fails pt2pt discovery: "
+					"DID %x Data: %x\n", ndlp->nlp_DID, rc);
+		}
 	}
 
-	mempool_free(link_mbox, phba->mbox_mem_pool);
+	/* Now process the REG_RPI cmpl */
+	lpfc_mbx_cmpl_reg_login(phba, login_mbox);
+	ndlp->nlp_flag &= ~NLP_ACC_REGLOGIN;
 	kfree(save_iocb);
 }
 
-/**
- * lpfc_defer_tgt_acc - Progress SLI4 target rcv PLOGI handler
- * @phba: Pointer to HBA context object.
- * @pmb: Pointer to mailbox object.
- *
- * This function provides the unreg rpi mailbox completion handler for a tgt.
- * The routine frees the memory resources associated with the completed
- * mailbox command and transmits the ELS ACC.
- *
- * This routine is only called if we are SLI4, acting in target
- * mode and the remote NPort issues the PLOGI after link up.
- **/
-static void
-lpfc_defer_acc_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
-{
-	struct lpfc_vport *vport = pmb->vport;
-	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
-	LPFC_MBOXQ_t *mbox = pmb->context3;
-	struct lpfc_iocbq *piocb = NULL;
-	int rc;
-
-	if (mbox) {
-		pmb->context3 = NULL;
-		piocb = mbox->context3;
-		mbox->context3 = NULL;
-	}
-
-	/*
-	 * Complete the unreg rpi mbx request, and update flags.
-	 * This will also restart any deferred events.
-	 */
-	lpfc_sli4_unreg_rpi_cmpl_clr(phba, pmb);
-
-	if (!piocb) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "4578 PLOGI ACC fail\n");
-		if (mbox)
-			mempool_free(mbox, phba->mbox_mem_pool);
-		return;
-	}
-
-	rc = lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, piocb, ndlp, mbox);
-	if (rc) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "4579 PLOGI ACC fail %x\n", rc);
-		if (mbox)
-			mempool_free(mbox, phba->mbox_mem_pool);
-	}
-	kfree(piocb);
-}
-
 static int
 lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	       struct lpfc_iocbq *cmdiocb)
@@ -395,8 +332,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct lpfc_iocbq *save_iocb;
 	struct ls_rjt stat;
 	uint32_t vid, flag;
-	u16 rpi;
-	int rc, defer_acc;
+	int rc;
 
 	memset(&stat, 0, sizeof (struct ls_rjt));
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
@@ -445,7 +381,6 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	else
 		ndlp->nlp_fcp_info |= CLASS3;
 
-	defer_acc = 0;
 	ndlp->nlp_class_sup = 0;
 	if (sp->cls1.classValid)
 		ndlp->nlp_class_sup |= FC_COS_CLASS1;
@@ -539,27 +474,26 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 		memcpy(&phba->fc_fabparam, sp, sizeof(struct serv_parm));
 
-		/* Issue config_link / reg_vfi to account for updated TOV's */
-
+		/* Issue CONFIG_LINK for SLI3 or REG_VFI for SLI4,
+		 * to account for updated TOV's / parameters
+		 */
 		if (phba->sli_rev == LPFC_SLI_REV4)
 			lpfc_issue_reg_vfi(vport);
 		else {
-			defer_acc = 1;
 			link_mbox = mempool_alloc(phba->mbox_mem_pool,
 						  GFP_KERNEL);
 			if (!link_mbox)
 				goto out;
 			lpfc_config_link(phba, link_mbox);
-			link_mbox->mbox_cmpl = lpfc_defer_pt2pt_acc;
+			link_mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 			link_mbox->vport = vport;
 			link_mbox->ctx_ndlp = ndlp;
 
-			save_iocb = kzalloc(sizeof(*save_iocb), GFP_KERNEL);
-			if (!save_iocb)
+			rc = lpfc_sli_issue_mbox(phba, link_mbox, MBX_NOWAIT);
+			if (rc == MBX_NOT_FINISHED) {
+				mempool_free(link_mbox, phba->mbox_mem_pool);
 				goto out;
-			/* Save info from cmd IOCB used in rsp */
-			memcpy((uint8_t *)save_iocb, (uint8_t *)cmdiocb,
-			       sizeof(struct lpfc_iocbq));
+			}
 		}
 
 		lpfc_can_disctmo(vport);
@@ -578,59 +512,28 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if (!login_mbox)
 		goto out;
 
-	/* Registering an existing RPI behaves differently for SLI3 vs SLI4 */
-	if (phba->nvmet_support && !defer_acc) {
-		link_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
-		if (!link_mbox)
-			goto out;
-
-		/* As unique identifiers such as iotag would be overwritten
-		 * with those from the cmdiocb, allocate separate temporary
-		 * storage for the copy.
-		 */
-		save_iocb = kzalloc(sizeof(*save_iocb), GFP_KERNEL);
-		if (!save_iocb)
-			goto out;
-
-		/* Unreg RPI is required for SLI4. */
-		rpi = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
-		lpfc_unreg_login(phba, vport->vpi, rpi, link_mbox);
-		link_mbox->vport = vport;
-		link_mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
-		if (!link_mbox->ctx_ndlp)
-			goto out;
-
-		link_mbox->mbox_cmpl = lpfc_defer_acc_rsp;
-
-		if (((ndlp->nlp_DID & Fabric_DID_MASK) != Fabric_DID_MASK) &&
-		    (!(vport->fc_flag & FC_OFFLINE_MODE)))
-			ndlp->nlp_flag |= NLP_UNREG_INP;
+	save_iocb = kzalloc(sizeof(*save_iocb), GFP_KERNEL);
+	if (!save_iocb)
+		goto out;
 
-		/* Save info from cmd IOCB used in rsp */
-		memcpy(save_iocb, cmdiocb, sizeof(*save_iocb));
+	/* Save info from cmd IOCB to be used in rsp after all mbox completes */
+	memcpy((uint8_t *)save_iocb, (uint8_t *)cmdiocb,
+	       sizeof(struct lpfc_iocbq));
 
-		/* Delay sending ACC till unreg RPI completes. */
-		defer_acc = 1;
-	} else if (phba->sli_rev == LPFC_SLI_REV4)
+	/* Registering an existing RPI behaves differently for SLI3 vs SLI4 */
+	if (phba->sli_rev == LPFC_SLI_REV4)
 		lpfc_unreg_rpi(vport, ndlp);
 
+	/* Issue REG_LOGIN first, before ACCing the PLOGI, thus we will
+	 * always be deferring the ACC.
+	 */
 	rc = lpfc_reg_rpi(phba, vport->vpi, icmd->un.rcvels.remoteID,
 			    (uint8_t *)sp, login_mbox, ndlp->nlp_rpi);
 	if (rc)
 		goto out;
 
-	/* ACC PLOGI rsp command needs to execute first,
-	 * queue this login_mbox command to be processed later.
-	 */
 	login_mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
-	/*
-	 * login_mbox->ctx_ndlp = lpfc_nlp_get(ndlp) deferred until mailbox
-	 * command issued in lpfc_cmpl_els_acc().
-	 */
 	login_mbox->vport = vport;
-	spin_lock_irq(&ndlp->lock);
-	ndlp->nlp_flag |= (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI);
-	spin_unlock_irq(&ndlp->lock);
 
 	/*
 	 * If there is an outstanding PLOGI issued, abort it before
@@ -660,7 +563,8 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 * to register, then unregister the RPI.
 		 */
 		spin_lock_irq(&ndlp->lock);
-		ndlp->nlp_flag |= NLP_RM_DFLT_RPI;
+		ndlp->nlp_flag |= (NLP_RM_DFLT_RPI | NLP_ACC_REGLOGIN |
+				   NLP_RCV_PLOGI);
 		spin_unlock_irq(&ndlp->lock);
 		stat.un.b.lsRjtRsnCode = LSRJT_INVALID_CMD;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
@@ -670,42 +574,39 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			mempool_free(login_mbox, phba->mbox_mem_pool);
 		return 1;
 	}
-	if (defer_acc) {
-		/* So the order here should be:
-		 * SLI3 pt2pt
-		 *   Issue CONFIG_LINK mbox
-		 *   CONFIG_LINK cmpl
-		 * SLI4 tgt
-		 *   Issue UNREG RPI mbx
-		 *   UNREG RPI cmpl
-		 * Issue PLOGI ACC
-		 * PLOGI ACC cmpl
-		 * Issue REG_LOGIN mbox
-		 */
 
-		/* Save the REG_LOGIN mbox for and rcv IOCB copy later */
-		link_mbox->context3 = login_mbox;
-		login_mbox->context3 = save_iocb;
+	/* So the order here should be:
+	 * SLI3 pt2pt
+	 *   Issue CONFIG_LINK mbox
+	 *   CONFIG_LINK cmpl
+	 * SLI4 pt2pt
+	 *   Issue REG_VFI mbox
+	 *   REG_VFI cmpl
+	 * SLI4
+	 *   Issue UNREG RPI mbx
+	 *   UNREG RPI cmpl
+	 * Issue REG_RPI mbox
+	 * REG RPI cmpl
+	 * Issue PLOGI ACC
+	 * PLOGI ACC cmpl
+	 */
+	login_mbox->mbox_cmpl = lpfc_defer_plogi_acc;
+	login_mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
+	login_mbox->context3 = save_iocb; /* For PLOGI ACC */
 
-		/* Start the ball rolling by issuing CONFIG_LINK here */
-		rc = lpfc_sli_issue_mbox(phba, link_mbox, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED)
-			goto out;
-		return 1;
-	}
+	spin_lock_irq(&ndlp->lock);
+	ndlp->nlp_flag |= (NLP_ACC_REGLOGIN | NLP_RCV_PLOGI);
+	spin_unlock_irq(&ndlp->lock);
+
+	/* Start the ball rolling by issuing REG_LOGIN here */
+	rc = lpfc_sli_issue_mbox(phba, login_mbox, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED)
+		goto out;
+	lpfc_nlp_set_state(vport, ndlp, NLP_STE_REG_LOGIN_ISSUE);
 
-	rc = lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, login_mbox);
-	if (rc)
-		mempool_free(login_mbox, phba->mbox_mem_pool);
 	return 1;
 out:
-	if (defer_acc)
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"4577 discovery failure: %p %p %p\n",
-				save_iocb, link_mbox, login_mbox);
 	kfree(save_iocb);
-	if (link_mbox)
-		mempool_free(link_mbox, phba->mbox_mem_pool);
 	if (login_mbox)
 		mempool_free(login_mbox, phba->mbox_mem_pool);
 
-- 
2.30.2



