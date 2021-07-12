Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190843C5045
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344512AbhGLHby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344712AbhGLH3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE4BD60C40;
        Mon, 12 Jul 2021 07:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074749;
        bh=3WgmIrUpTP5JHlApqxBZH75Asssa5W5WSsugZHXAKl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3ve8W11nj65E1mfkMOT1OLDuc8bLnwm3duy+5EgltjijwfxO+Lc0+wuVWEQUnTRF
         CTF6P3u50TWNJSWgvf6kpkmJpnetoYjo9FX6Zkk8G8uIXeaB6q4hCOBo/NjUau4qyX
         tT7vHF3ZFIn41KUiwuyS9pkyHM/UDJiH3wjJF3TI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.12 685/700] scsi: lpfc: Fix unreleased RPIs when NPIV ports are created
Date:   Mon, 12 Jul 2021 08:12:48 +0200
Message-Id: <20210712061048.806615293@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 01131e7aae5d30e23e3cdd1eebe51bbc5489ae8f upstream.

While testing NPIV and watching logins and used RPI levels, it was seen the
used RPI count was much higher than the number of remote ports discovered.

Code inspection showed that remote port removals on any NPIV instance are
releasing the RPI, but not performing an UNREG_RPI with the adapter thus
the reference counting never fully drops and the RPI is never fully
released. This was happening on NPIV nodes due to a log of fabric ELS's to
fabric addresses. This lack of UNREG_RPI was introduced by a prior node
rework patch that performed the UNREG_RPI as part of node cleanup.

To resolve the issue, do the following:

 - Restore the RPI release code, but move the location to so that it is in
   line with the new node cleanup design.

 - NPIV ports now release the RPI and drop the node when the caller sets
   the NLP_RELEASE_RPI flag.

 - Set the NLP_RELEASE_RPI flag in node cleanup which will trigger a
   release of RPI to free pool.

 - Ensure there's an UNREG_RPI at LOGO completion so that RPI release is
   completed.

 - Stop offline_prep from skipping nodes that are UNUSED. The RPI may
   not have been released.

 - Stop the default RPI handling in lpfc_cmpl_els_rsp() for SLI4.

 - Fixed up debugfs RPI displays for better debugging.

Fixes: a70e63eee1c1 ("scsi: lpfc: Fix NPIV Fabric Node reference counting")
Link: https://lore.kernel.org/r/20210514195559.119853-2-jsmart2021@gmail.com
Cc: <stable@vger.kernel.org> # v5.11+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_debugfs.c   |    7 ---
 drivers/scsi/lpfc/lpfc_els.c       |   79 +++++++++++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   27 +++++++++++-
 drivers/scsi/lpfc/lpfc_init.c      |    7 ---
 drivers/scsi/lpfc/lpfc_nportdisc.c |   25 +++++++----
 drivers/scsi/lpfc/lpfc_sli.c       |   10 +++-
 6 files changed, 115 insertions(+), 40 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -868,11 +868,8 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 		len += scnprintf(buf+len, size-len,
 				"WWNN x%llx ",
 				wwn_to_u64(ndlp->nlp_nodename.u.wwn));
-		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
-			len += scnprintf(buf+len, size-len, "RPI:%03d ",
-					ndlp->nlp_rpi);
-		else
-			len += scnprintf(buf+len, size-len, "RPI:none ");
+		len += scnprintf(buf+len, size-len, "RPI:x%04x ",
+				 ndlp->nlp_rpi);
 		len +=  scnprintf(buf+len, size-len, "flag:x%08x ",
 			ndlp->nlp_flag);
 		if (!ndlp->nlp_type)
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2856,6 +2856,11 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba
 	 * log into the remote port.
 	 */
 	if (ndlp->nlp_flag & NLP_TARGET_REMOVE) {
+		spin_lock_irq(&ndlp->lock);
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			ndlp->nlp_flag |= NLP_RELEASE_RPI;
+		ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+		spin_unlock_irq(&ndlp->lock);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_DEVICE_RM);
 		lpfc_els_free_iocb(phba, cmdiocb);
@@ -4363,6 +4368,7 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	struct lpfc_vport *vport = cmdiocb->vport;
 	IOCB_t *irsp;
+	u32 xpt_flags = 0, did_mask = 0;
 
 	irsp = &rspiocb->iocb;
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
@@ -4378,9 +4384,20 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 	if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
 		/* NPort Recovery mode or node is just allocated */
 		if (!lpfc_nlp_not_used(ndlp)) {
-			/* If the ndlp is being used by another discovery
-			 * thread, just unregister the RPI.
+			/* A LOGO is completing and the node is in NPR state.
+			 * If this a fabric node that cleared its transport
+			 * registration, release the rpi.
 			 */
+			xpt_flags = SCSI_XPT_REGD | NVME_XPT_REGD;
+			did_mask = ndlp->nlp_DID & Fabric_DID_MASK;
+			if (did_mask == Fabric_DID_MASK &&
+			    !(ndlp->fc4_xpt_flags & xpt_flags)) {
+				spin_lock_irq(&ndlp->lock);
+				ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+				if (phba->sli_rev == LPFC_SLI_REV4)
+					ndlp->nlp_flag |= NLP_RELEASE_RPI;
+				spin_unlock_irq(&ndlp->lock);
+			}
 			lpfc_unreg_rpi(vport, ndlp);
 		} else {
 			/* Indicate the node has already released, should
@@ -4416,28 +4433,37 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 {
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *)(pmb->ctx_buf);
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
+	u32 mbx_flag = pmb->mbox_flag;
+	u32 mbx_cmd = pmb->u.mb.mbxCommand;
 
 	pmb->ctx_buf = NULL;
 	pmb->ctx_ndlp = NULL;
 
-	lpfc_mbuf_free(phba, mp->virt, mp->phys);
-	kfree(mp);
-	mempool_free(pmb, phba->mbox_mem_pool);
 	if (ndlp) {
 		lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
-				 "0006 rpi x%x DID:%x flg:%x %d x%px\n",
+				 "0006 rpi x%x DID:%x flg:%x %d x%px "
+				 "mbx_cmd x%x mbx_flag x%x x%px\n",
 				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
-				 kref_read(&ndlp->kref),
-				 ndlp);
-		/* This is the end of the default RPI cleanup logic for
-		 * this ndlp and it could get released.  Clear the nlp_flags to
-		 * prevent any further processing.
+				 kref_read(&ndlp->kref), ndlp, mbx_cmd,
+				 mbx_flag, pmb);
+
+		/* This ends the default/temporary RPI cleanup logic for this
+		 * ndlp and the node and rpi needs to be released. Free the rpi
+		 * first on an UNREG_LOGIN and then release the final
+		 * references.
 		 */
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
+		if (mbx_cmd == MBX_UNREG_LOGIN)
+			ndlp->nlp_flag &= ~NLP_UNREG_INP;
+		spin_unlock_irq(&ndlp->lock);
 		lpfc_nlp_put(ndlp);
-		lpfc_nlp_not_used(ndlp);
+		lpfc_drop_node(ndlp->vport, ndlp);
 	}
 
+	lpfc_mbuf_free(phba, mp->virt, mp->phys);
+	kfree(mp);
+	mempool_free(pmb, phba->mbox_mem_pool);
 	return;
 }
 
@@ -4495,11 +4521,11 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba,
 	/* ELS response tag <ulpIoTag> completes */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0110 ELS response tag x%x completes "
-			 "Data: x%x x%x x%x x%x x%x x%x x%x\n",
+			 "Data: x%x x%x x%x x%x x%x x%x x%x x%x x%px\n",
 			 cmdiocb->iocb.ulpIoTag, rspiocb->iocb.ulpStatus,
 			 rspiocb->iocb.un.ulpWord[4], rspiocb->iocb.ulpTimeout,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
-			 ndlp->nlp_rpi);
+			 ndlp->nlp_rpi, kref_read(&ndlp->kref), mbox);
 	if (mbox) {
 		if ((rspiocb->iocb.ulpStatus == 0) &&
 		    (ndlp->nlp_flag & NLP_ACC_REGLOGIN)) {
@@ -4579,6 +4605,16 @@ out:
 		spin_unlock_irq(&ndlp->lock);
 	}
 
+	/* An SLI4 NPIV instance wants to drop the node at this point under
+	 * these conditions and release the RPI.
+	 */
+	if (phba->sli_rev == LPFC_SLI_REV4 &&
+	    (vport && vport->port_type == LPFC_NPIV_PORT) &&
+	    ndlp->nlp_flag & NLP_RELEASE_RPI) {
+		lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
+		lpfc_drop_node(vport, ndlp);
+	}
+
 	/* Release the originating I/O reference. */
 	lpfc_els_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
@@ -4762,10 +4798,10 @@ lpfc_els_rsp_acc(struct lpfc_vport *vpor
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0128 Xmit ELS ACC response Status: x%x, IoTag: x%x, "
 			 "XRI: x%x, DID: x%x, nlp_flag: x%x nlp_state: x%x "
-			 "RPI: x%x, fc_flag x%x\n",
+			 "RPI: x%x, fc_flag x%x refcnt %d\n",
 			 rc, elsiocb->iotag, elsiocb->sli4_xritag,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
-			 ndlp->nlp_rpi, vport->fc_flag);
+			 ndlp->nlp_rpi, vport->fc_flag, kref_read(&ndlp->kref));
 	return 0;
 
 io_err:
@@ -5978,6 +6014,17 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba,
 		goto free_rdp_context;
 	}
 
+	/* The NPIV instance is rejecting this unsolicited ELS. Make sure the
+	 * node's assigned RPI needs to be released as this node will get
+	 * freed.
+	 */
+	if (phba->sli_rev == LPFC_SLI_REV4 &&
+	    vport->port_type == LPFC_NPIV_PORT) {
+		spin_lock_irq(&ndlp->lock);
+		ndlp->nlp_flag |= NLP_RELEASE_RPI;
+		spin_unlock_irq(&ndlp->lock);
+	}
+
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_nlp_put(ndlp);
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4789,12 +4789,17 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phb
 		ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 		lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
 	} else {
+		/* NLP_RELEASE_RPI is only set for SLI4 ports. */
 		if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
 			lpfc_sli4_free_rpi(vport->phba, ndlp->nlp_rpi);
+			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
 			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+			spin_unlock_irq(&ndlp->lock);
 		}
+		spin_lock_irq(&ndlp->lock);
 		ndlp->nlp_flag &= ~NLP_UNREG_INP;
+		spin_unlock_irq(&ndlp->lock);
 	}
 }
 
@@ -5129,8 +5134,10 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 	list_del_init(&ndlp->dev_loss_evt.evt_listp);
 	list_del_init(&ndlp->recovery_evt.evt_listp);
 	lpfc_cleanup_vports_rrqs(vport, ndlp);
+
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		ndlp->nlp_flag |= NLP_RELEASE_RPI;
+
 	return 0;
 }
 
@@ -6174,8 +6181,23 @@ lpfc_nlp_release(struct kref *kref)
 	lpfc_cancel_retry_delay_tmo(vport, ndlp);
 	lpfc_cleanup_node(vport, ndlp);
 
-	/* Clear Node key fields to give other threads notice
-	 * that this node memory is not valid anymore.
+	/* Not all ELS transactions have registered the RPI with the port.
+	 * In these cases the rpi usage is temporary and the node is
+	 * released when the WQE is completed.  Catch this case to free the
+	 * RPI to the pool.  Because this node is in the release path, a lock
+	 * is unnecessary.  All references are gone and the node has been
+	 * dequeued.
+	 */
+	if (ndlp->nlp_flag & NLP_RELEASE_RPI) {
+		if (ndlp->nlp_rpi != LPFC_RPI_ALLOC_ERROR &&
+		    !(ndlp->nlp_flag & (NLP_RPI_REGISTERED | NLP_UNREG_INP))) {
+			lpfc_sli4_free_rpi(vport->phba, ndlp->nlp_rpi);
+			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+		}
+	}
+
+	/* The node is not freed back to memory, it is released to a pool so
+	 * the node fields need to be cleaned up.
 	 */
 	ndlp->vport = NULL;
 	ndlp->nlp_state = NLP_STE_FREED_NODE;
@@ -6255,6 +6277,7 @@ lpfc_nlp_not_used(struct lpfc_nodelist *
 		"node not used:   did:x%x flg:x%x refcnt:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag,
 		kref_read(&ndlp->kref));
+
 	if (kref_read(&ndlp->kref) == 1)
 		if (lpfc_nlp_put(ndlp))
 			return 1;
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3532,13 +3532,6 @@ lpfc_offline_prep(struct lpfc_hba *phba,
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vports[i]->fc_nodes,
 						 nlp_listp) {
-				if (ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
-					/* Driver must assume RPI is invalid for
-					 * any unused or inactive node.
-					 */
-					ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
-					continue;
-				}
 
 				spin_lock_irq(&ndlp->lock);
 				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -557,15 +557,24 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 		/* no deferred ACC */
 		kfree(save_iocb);
 
-		/* In order to preserve RPIs, we want to cleanup
-		 * the default RPI the firmware created to rcv
-		 * this ELS request. The only way to do this is
-		 * to register, then unregister the RPI.
+		/* This is an NPIV SLI4 instance that does not need to register
+		 * a default RPI.
 		 */
-		spin_lock_irq(&ndlp->lock);
-		ndlp->nlp_flag |= (NLP_RM_DFLT_RPI | NLP_ACC_REGLOGIN |
-				   NLP_RCV_PLOGI);
-		spin_unlock_irq(&ndlp->lock);
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			mempool_free(login_mbox, phba->mbox_mem_pool);
+			login_mbox = NULL;
+		} else {
+			/* In order to preserve RPIs, we want to cleanup
+			 * the default RPI the firmware created to rcv
+			 * this ELS request. The only way to do this is
+			 * to register, then unregister the RPI.
+			 */
+			spin_lock_irq(&ndlp->lock);
+			ndlp->nlp_flag |= (NLP_RM_DFLT_RPI | NLP_ACC_REGLOGIN |
+					   NLP_RCV_PLOGI);
+			spin_unlock_irq(&ndlp->lock);
+		}
+
 		stat.un.b.lsRjtRsnCode = LSRJT_INVALID_CMD;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
 		rc = lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb,
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13628,9 +13628,15 @@ lpfc_sli4_sp_handle_mbox_event(struct lp
 		if (mcqe_status == MB_CQE_STATUS_SUCCESS) {
 			mp = (struct lpfc_dmabuf *)(pmb->ctx_buf);
 			ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
-			/* Reg_LOGIN of dflt RPI was successful. Now lets get
-			 * RID of the PPI using the same mbox buffer.
+
+			/* Reg_LOGIN of dflt RPI was successful. Mark the
+			 * node as having an UNREG_LOGIN in progress to stop
+			 * an unsolicited PLOGI from the same NPortId from
+			 * starting another mailbox transaction.
 			 */
+			spin_lock_irqsave(&ndlp->lock, iflags);
+			ndlp->nlp_flag |= NLP_UNREG_INP;
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
 			lpfc_unreg_login(phba, vport->vpi,
 					 pmbox->un.varWords[0], pmb);
 			pmb->mbox_cmpl = lpfc_mbx_cmpl_dflt_rpi;


