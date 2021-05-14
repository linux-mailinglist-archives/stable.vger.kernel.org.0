Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02B038112E
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 21:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhENT5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 15:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbhENT5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 15:57:18 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A659C061574;
        Fri, 14 May 2021 12:56:06 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d16so477280pfn.12;
        Fri, 14 May 2021 12:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JkEOrObaMIdOUsQq0/DD4PyZzTUgjMKYcLUx7TYmwv0=;
        b=dCCaUlp4PJCMIag0+U9sWDURB01AfYLUapG4E5sAODiI+k6LKIsISy1yjtDbHOf3Kz
         mQ2Arz1rgCCo3KDJwlvvwtiGNMnUKv5QGNc8kgVl/wGDRfPNMB3BbeouW/GG/yik+DN6
         TmUpjSlEIQuu32Mx27kxWVFoNfBHieAgw3711ciQ2zuDw9oto7NjP+I7eMl1jTCMVt2b
         mJdq7wpiXyfshjAPRfX13FOFBZhzT1nqVTt4j5rTjUPydGQpqkojrukV+jelzS75b4tc
         KTyrhgQFcpGh7fQZtDsPMrXxaFp7yMewfL+ypoMtpmSPnDLJ+I8rzeq0mybV5F6UkNps
         LH8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JkEOrObaMIdOUsQq0/DD4PyZzTUgjMKYcLUx7TYmwv0=;
        b=BAPY5slc0wjwo+ry2oa9h5kmhJvpTnla/DVnzrEcMPQ2ISx2xaI5SpO2OzDiozJa4U
         YMZ7X0NOxx8eJZzVuqnmHgkPgTk4/v9RzFmcWfgI2lEiUtR8g3SkIkFA0ACpoOhvTrLG
         8FB+YZ8cLZ0txf0B3gliwkr4q/ijlwHwse5yDvp6+TXx+MhFfI+l6hp+n9Cdl5Hvi+Zm
         FM4YrDHOtWjb2Bk77FtmgUi0yLL+MSHOUaGYTu8rDeegQRwv7avtgWA5M6tSi6ukGjhg
         QuaxVoO5BqdTA59Ke6HPYFBl/Vl043i1V4y+/O8saf8j9gPoz7AbjjK+fMaziwO7C5Ro
         6Utg==
X-Gm-Message-State: AOAM532JxfIEiTT+SLDZinYRMNKURrhGI1Ik8XVHYuGeRayELnc3tRDf
        vjByDPdynpXn5LsD2DpDjetTLn98IX4=
X-Google-Smtp-Source: ABdhPJyj+4FKMx68csbu4x0rPnhAs6cL9PdzoCijjrY3efjF9S0GIem0NI8ut4iizNvP90Sv1hmHjw==
X-Received: by 2002:aa7:88c9:0:b029:2ab:aea7:e761 with SMTP id k9-20020aa788c90000b02902abaea7e761mr38241056pff.71.1621022165422;
        Fri, 14 May 2021 12:56:05 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:05 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 01/11] lpfc: Fix unreleased RPIs when NPIV ports are created
Date:   Fri, 14 May 2021 12:55:49 -0700
Message-Id: <20210514195559.119853-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While testing NPIV and watching logins and used rpi levels, it was
seen the used rpi count is much higher than the number of remote
ports discovered.

Code inspection showed that remote port removals on any NPIV instance
are releasing the RPI, but not performing an UNREG_RPI with the adapter
thus the reference counting never fully drops and the rpi is never
fully released. This was happening on NPIV nodes due to a log of
fabric ELS's to fabric addresses. This lack of UNREG_RPI was
introduced by a prior node rework patch that performed the UNREG_RPI
as part of node cleanup.

To resolve the issue, the following changes were made:

- Restored the RPI release code, but moved the location to so that it
  is line with the new node cleanup design.
- NPIV ports now release the RPI and drop the node when the caller sets
  the NLP_RELEASE_RPI flag.
- Set the NLP_RELEASE_RPI flag in node cleanup which will trigger a
  release of RPI to free pool.
- Ensure there's an UNREG_RPI at LOGO completion so that rpi release
  is completed.
- Stop offline_prep from skipping nodes that are UNUSED. The rpi may
  not have been released.
- Stop the default rpi handling in lpfc_cmpl_els_rsp for SLI4
- Fixed up debugfs rpi displays for better debug

Fixes: a70e63eee1c1 ("scsi: lpfc: Fix NPIV Fabric Node reference counting")
Cc: <stable@vger.kernel.org> # v5.11+

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c   |  7 +--
 drivers/scsi/lpfc/lpfc_els.c       | 79 ++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 27 +++++++++-
 drivers/scsi/lpfc/lpfc_init.c      |  7 ---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 25 +++++++---
 drivers/scsi/lpfc/lpfc_sli.c       | 10 +++-
 6 files changed, 115 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 658a962832b3..7bddd74658b9 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -868,11 +868,8 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 		len += scnprintf(buf+len, size-len,
 				"WWNN x%llx ",
 				wwn_to_u64(ndlp->nlp_nodename.u.wwn));
-		if (ndlp->nlp_flag & NLP_RPI_REGISTERED)
-			len += scnprintf(buf+len, size-len, "RPI:%04d ",
-					ndlp->nlp_rpi);
-		else
-			len += scnprintf(buf+len, size-len, "RPI:none ");
+		len += scnprintf(buf+len, size-len, "RPI:x%04x ",
+				 ndlp->nlp_rpi);
 		len +=  scnprintf(buf+len, size-len, "flag:x%08x ",
 			ndlp->nlp_flag);
 		if (!ndlp->nlp_type)
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 21108f322c99..a0ff15e63109 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2869,6 +2869,11 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
@@ -4371,6 +4376,7 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 	struct lpfc_vport *vport = cmdiocb->vport;
 	IOCB_t *irsp;
+	u32 xpt_flags = 0, did_mask = 0;
 
 	irsp = &rspiocb->iocb;
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
@@ -4386,9 +4392,20 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
@@ -4424,28 +4441,37 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
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
 
@@ -4503,11 +4529,11 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
@@ -4587,6 +4613,16 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
@@ -4775,10 +4811,10 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
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
 }
 
@@ -4856,6 +4892,17 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 		return 1;
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
 		lpfc_els_free_iocb(phba, elsiocb);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f5a898c2c904..3ea07034ab97 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4789,12 +4789,17 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
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
 
@@ -5129,8 +5134,10 @@ lpfc_cleanup_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	list_del_init(&ndlp->dev_loss_evt.evt_listp);
 	list_del_init(&ndlp->recovery_evt.evt_listp);
 	lpfc_cleanup_vports_rrqs(vport, ndlp);
+
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		ndlp->nlp_flag |= NLP_RELEASE_RPI;
+
 	return 0;
 }
 
@@ -6176,8 +6183,23 @@ lpfc_nlp_release(struct kref *kref)
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
@@ -6257,6 +6279,7 @@ lpfc_nlp_not_used(struct lpfc_nodelist *ndlp)
 		"node not used:   did:x%x flg:x%x refcnt:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag,
 		kref_read(&ndlp->kref));
+
 	if (kref_read(&ndlp->kref) == 1)
 		if (lpfc_nlp_put(ndlp))
 			return 1;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5f018d02bf56..f81dfa3cb0a1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3532,13 +3532,6 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
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
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index bb4e65a32ecc..3dac116c405b 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -567,15 +567,24 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
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
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a1ed6b104f2d..aefe16c6fe5c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13625,9 +13625,15 @@ lpfc_sli4_sp_handle_mbox_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
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
-- 
2.26.2

