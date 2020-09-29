Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463FB27C929
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731697AbgI2MII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730219AbgI2Lhg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB922376E;
        Tue, 29 Sep 2020 11:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379357;
        bh=GMw+bqGp8BdX5MfT9KbAYC9/xiPMzuV4Uj7wldM2kjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRL/xDpaB052FU7gVCwKEst8Cclip+pkf2gK7qecH3wl0ulg2eHmDX3FUc+JCg8o9
         k5MrJjwbf53Oatb75fYVpkDI9RQuoqPyB+N+GSjjEF3VIF8CPjCaL/NqKor8yYM2bi
         XGLL/fzGl/rcIp2+IjZtq9qPQKxnvTNiH2/Oa8KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/388] scsi: lpfc: Fix incomplete NVME discovery when target
Date:   Tue, 29 Sep 2020 12:56:57 +0200
Message-Id: <20200929110014.646279948@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit be0709e449ac9d9753a5c17e5b770d6e5e930e4a ]

NVMe device re-discovery does not complete. Dev_loss_tmo messages seen on
initiator after recovery from a link disturbance.

The failing case is the following:

When the driver (as a NVME target) receives a PLOGI, the driver initiates
an "unreg rpi" mailbox command. While the mailbox command is in progress,
the driver requests that an ACC be sent to the initiator. The target's ACC
is received by the initiator and the initiator then transmits a PLOGI. The
driver receives the PLOGI prior to receiving the completion for the PLOGI
response WQE that sent the ACC. (Different delivery sources from the hw so
the race is very possible). Given the PLOGI is prior to the ACC completion
(signifying PLOGI exchange complete), the driver LS_RJT's the PRLI. The
"unreg rpi" mailbox then completes. Since PRLI has been received, the
driver transmits a PLOGI to restart discovery, which the initiator then
ACC's.  If the driver processes the (re)PLOGI ACC prior to the completing
the handling for the earlier ACC it sent the intiators original PLOGI,
there is no state change for completion of the (re)PLOGI. The ndlp remains
in "PLOGI Sent" and the initiator continues sending PRLI's which are
rejected by the target until timeout or retry is reached.

Fix by: When in target mode, defer sending an ACC for the received PLOGI
until unreg RPI completes.

Link: https://lore.kernel.org/r/20191218235808.31922-2-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 108 ++++++++++++++++++++++++++---
 1 file changed, 99 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 2a340624bfc99..590a49e847626 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -308,7 +308,7 @@ lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
 				mb->mbxStatus);
 		mempool_free(login_mbox, phba->mbox_mem_pool);
 		mempool_free(link_mbox, phba->mbox_mem_pool);
-		lpfc_sli_release_iocbq(phba, save_iocb);
+		kfree(save_iocb);
 		return;
 	}
 
@@ -325,7 +325,61 @@ lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
 	}
 
 	mempool_free(link_mbox, phba->mbox_mem_pool);
-	lpfc_sli_release_iocbq(phba, save_iocb);
+	kfree(save_iocb);
+}
+
+/**
+ * lpfc_defer_tgt_acc - Progress SLI4 target rcv PLOGI handler
+ * @phba: Pointer to HBA context object.
+ * @pmb: Pointer to mailbox object.
+ *
+ * This function provides the unreg rpi mailbox completion handler for a tgt.
+ * The routine frees the memory resources associated with the completed
+ * mailbox command and transmits the ELS ACC.
+ *
+ * This routine is only called if we are SLI4, acting in target
+ * mode and the remote NPort issues the PLOGI after link up.
+ **/
+void
+lpfc_defer_acc_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+{
+	struct lpfc_vport *vport = pmb->vport;
+	struct lpfc_nodelist *ndlp = pmb->ctx_ndlp;
+	LPFC_MBOXQ_t *mbox = pmb->context3;
+	struct lpfc_iocbq *piocb = NULL;
+	int rc;
+
+	if (mbox) {
+		pmb->context3 = NULL;
+		piocb = mbox->context3;
+		mbox->context3 = NULL;
+	}
+
+	/*
+	 * Complete the unreg rpi mbx request, and update flags.
+	 * This will also restart any deferred events.
+	 */
+	lpfc_nlp_get(ndlp);
+	lpfc_sli4_unreg_rpi_cmpl_clr(phba, pmb);
+
+	if (!piocb) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY | LOG_ELS,
+				 "4578 PLOGI ACC fail\n");
+		if (mbox)
+			mempool_free(mbox, phba->mbox_mem_pool);
+		goto out;
+	}
+
+	rc = lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, piocb, ndlp, mbox);
+	if (rc) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY | LOG_ELS,
+				 "4579 PLOGI ACC fail %x\n", rc);
+		if (mbox)
+			mempool_free(mbox, phba->mbox_mem_pool);
+	}
+	kfree(piocb);
+out:
+	lpfc_nlp_put(ndlp);
 }
 
 static int
@@ -345,6 +399,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct lpfc_iocbq *save_iocb;
 	struct ls_rjt stat;
 	uint32_t vid, flag;
+	u16 rpi;
 	int rc, defer_acc;
 
 	memset(&stat, 0, sizeof (struct ls_rjt));
@@ -488,7 +543,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			link_mbox->vport = vport;
 			link_mbox->ctx_ndlp = ndlp;
 
-			save_iocb = lpfc_sli_get_iocbq(phba);
+			save_iocb = kzalloc(sizeof(*save_iocb), GFP_KERNEL);
 			if (!save_iocb)
 				goto out;
 			/* Save info from cmd IOCB used in rsp */
@@ -513,7 +568,36 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		goto out;
 
 	/* Registering an existing RPI behaves differently for SLI3 vs SLI4 */
-	if (phba->sli_rev == LPFC_SLI_REV4)
+	if (phba->nvmet_support && !defer_acc) {
+		link_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!link_mbox)
+			goto out;
+
+		/* As unique identifiers such as iotag would be overwritten
+		 * with those from the cmdiocb, allocate separate temporary
+		 * storage for the copy.
+		 */
+		save_iocb = kzalloc(sizeof(*save_iocb), GFP_KERNEL);
+		if (!save_iocb)
+			goto out;
+
+		/* Unreg RPI is required for SLI4. */
+		rpi = phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
+		lpfc_unreg_login(phba, vport->vpi, rpi, link_mbox);
+		link_mbox->vport = vport;
+		link_mbox->ctx_ndlp = ndlp;
+		link_mbox->mbox_cmpl = lpfc_defer_acc_rsp;
+
+		if (((ndlp->nlp_DID & Fabric_DID_MASK) != Fabric_DID_MASK) &&
+		    (!(vport->fc_flag & FC_OFFLINE_MODE)))
+			ndlp->nlp_flag |= NLP_UNREG_INP;
+
+		/* Save info from cmd IOCB used in rsp */
+		memcpy(save_iocb, cmdiocb, sizeof(*save_iocb));
+
+		/* Delay sending ACC till unreg RPI completes. */
+		defer_acc = 1;
+	} else if (phba->sli_rev == LPFC_SLI_REV4)
 		lpfc_unreg_rpi(vport, ndlp);
 
 	rc = lpfc_reg_rpi(phba, vport->vpi, icmd->un.rcvels.remoteID,
@@ -553,6 +637,9 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	if ((vport->port_type == LPFC_NPIV_PORT &&
 	     vport->cfg_restrict_login)) {
 
+		/* no deferred ACC */
+		kfree(save_iocb);
+
 		/* In order to preserve RPIs, we want to cleanup
 		 * the default RPI the firmware created to rcv
 		 * this ELS request. The only way to do this is
@@ -571,8 +658,12 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	}
 	if (defer_acc) {
 		/* So the order here should be:
-		 * Issue CONFIG_LINK mbox
-		 * CONFIG_LINK cmpl
+		 * SLI3 pt2pt
+		 *   Issue CONFIG_LINK mbox
+		 *   CONFIG_LINK cmpl
+		 * SLI4 tgt
+		 *   Issue UNREG RPI mbx
+		 *   UNREG RPI cmpl
 		 * Issue PLOGI ACC
 		 * PLOGI ACC cmpl
 		 * Issue REG_LOGIN mbox
@@ -596,10 +687,9 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 out:
 	if (defer_acc)
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-				"4577 pt2pt discovery failure: %p %p %p\n",
+				"4577 discovery failure: %p %p %p\n",
 				save_iocb, link_mbox, login_mbox);
-	if (save_iocb)
-		lpfc_sli_release_iocbq(phba, save_iocb);
+	kfree(save_iocb);
 	if (link_mbox)
 		mempool_free(link_mbox, phba->mbox_mem_pool);
 	if (login_mbox)
-- 
2.25.1



