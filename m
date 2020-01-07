Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2531331A5
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgAGVCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbgAGVCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:02:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7568620880;
        Tue,  7 Jan 2020 21:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430954;
        bh=2c6xTMe5hfYLYttq5dLYr2N3NmtZtKOH449yayFHZ/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkrzrM/QPp/OnHnduuGG/L4CkhOOmFDeEAWIBsLoSt3oXbPCD0qinxr7DEguW1ia5
         sKDutZtbpK4bNwKN2H0JZM7XYQYIJ4OsHFPULYEw6GzWj2poKNaSt2Ci+RwpIOyNc3
         186eGbLzmFoHOHgYQAU44Wo2KEiqFiy6UmyK+TrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 128/191] scsi: lpfc: Fix rpi release when deleting vport
Date:   Tue,  7 Jan 2020 21:54:08 +0100
Message-Id: <20200107205339.824696476@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 97acd0019d5dadd9c0e111c2083c889bfe548f25 upstream.

A prior use-after-free mailbox fix solved it's problem by null'ing a ndlp
pointer.  However, further testing has shown that this change causes a
later state change to occasionally be skipped, which results in a reference
count never being decremented thus the rpi is never released, which causes
a vport delete to never succeed.

Revise the fix in the prior patch to no longer null the ndlp. Instead the
RELEASE_RPI flag is set which will drive the release of the rpi.

Given the new code was added at a deep indentation level, refactor the code
block using a new routine that avoids the indentation issues.

Fixes: 	9b1640686470 ("scsi: lpfc: Fix use-after-free mailbox cmd completion")
Link: https://lore.kernel.org/r/20190922035906.10977-6-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/lpfc/lpfc_hbadisc.c |   88 ++++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_sli.c     |    2 
 2 files changed, 61 insertions(+), 29 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4844,6 +4844,44 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phb
 }
 
 /*
+ * Sets the mailbox completion handler to be used for the
+ * unreg_rpi command. The handler varies based on the state of
+ * the port and what will be happening to the rpi next.
+ */
+static void
+lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
+	struct lpfc_nodelist *ndlp, LPFC_MBOXQ_t *mbox)
+{
+	unsigned long iflags;
+
+	if (ndlp->nlp_flag & NLP_ISSUE_LOGO) {
+		mbox->ctx_ndlp = ndlp;
+		mbox->mbox_cmpl = lpfc_nlp_logo_unreg;
+
+	} else if (phba->sli_rev == LPFC_SLI_REV4 &&
+		   (!(vport->load_flag & FC_UNLOADING)) &&
+		    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
+				      LPFC_SLI_INTF_IF_TYPE_2) &&
+		    (kref_read(&ndlp->kref) > 0)) {
+		mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
+		mbox->mbox_cmpl = lpfc_sli4_unreg_rpi_cmpl_clr;
+	} else {
+		if (vport->load_flag & FC_UNLOADING) {
+			if (phba->sli_rev == LPFC_SLI_REV4) {
+				spin_lock_irqsave(&vport->phba->ndlp_lock,
+						  iflags);
+				ndlp->nlp_flag |= NLP_RELEASE_RPI;
+				spin_unlock_irqrestore(&vport->phba->ndlp_lock,
+						       iflags);
+			}
+			lpfc_nlp_get(ndlp);
+		}
+		mbox->ctx_ndlp = ndlp;
+		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+	}
+}
+
+/*
  * Free rpi associated with LPFC_NODELIST entry.
  * This routine is called from lpfc_freenode(), when we are removing
  * a LPFC_NODELIST entry. It is also called if the driver initiates a
@@ -4893,33 +4931,12 @@ lpfc_unreg_rpi(struct lpfc_vport *vport,
 
 			lpfc_unreg_login(phba, vport->vpi, rpi, mbox);
 			mbox->vport = vport;
-			if (ndlp->nlp_flag & NLP_ISSUE_LOGO) {
-				mbox->ctx_ndlp = ndlp;
-				mbox->mbox_cmpl = lpfc_nlp_logo_unreg;
-			} else {
-				if (phba->sli_rev == LPFC_SLI_REV4 &&
-				    (!(vport->load_flag & FC_UNLOADING)) &&
-				    (bf_get(lpfc_sli_intf_if_type,
-				     &phba->sli4_hba.sli_intf) >=
-				      LPFC_SLI_INTF_IF_TYPE_2) &&
-				    (kref_read(&ndlp->kref) > 0)) {
-					mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
-					mbox->mbox_cmpl =
-						lpfc_sli4_unreg_rpi_cmpl_clr;
-					/*
-					 * accept PLOGIs after unreg_rpi_cmpl
-					 */
-					acc_plogi = 0;
-				} else if (vport->load_flag & FC_UNLOADING) {
-					mbox->ctx_ndlp = NULL;
-					mbox->mbox_cmpl =
-						lpfc_sli_def_mbox_cmpl;
-				} else {
-					mbox->ctx_ndlp = ndlp;
-					mbox->mbox_cmpl =
-						lpfc_sli_def_mbox_cmpl;
-				}
-			}
+			lpfc_set_unreg_login_mbx_cmpl(phba, vport, ndlp, mbox);
+			if (mbox->mbox_cmpl == lpfc_sli4_unreg_rpi_cmpl_clr)
+				/*
+				 * accept PLOGIs after unreg_rpi_cmpl
+				 */
+				acc_plogi = 0;
 			if (((ndlp->nlp_DID & Fabric_DID_MASK) !=
 			    Fabric_DID_MASK) &&
 			    (!(vport->fc_flag & FC_OFFLINE_MODE)))
@@ -5060,6 +5077,7 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 	struct lpfc_hba  *phba = vport->phba;
 	LPFC_MBOXQ_t *mb, *nextmb;
 	struct lpfc_dmabuf *mp;
+	unsigned long iflags;
 
 	/* Cleanup node for NPort <nlp_DID> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
@@ -5141,8 +5159,20 @@ lpfc_cleanup_node(struct lpfc_vport *vpo
 	lpfc_cleanup_vports_rrqs(vport, ndlp);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		ndlp->nlp_flag |= NLP_RELEASE_RPI;
-	lpfc_unreg_rpi(vport, ndlp);
-
+	if (!lpfc_unreg_rpi(vport, ndlp)) {
+		/* Clean up unregistered and non freed rpis */
+		if ((ndlp->nlp_flag & NLP_RELEASE_RPI) &&
+		    !(ndlp->nlp_rpi == LPFC_RPI_ALLOC_ERROR)) {
+			lpfc_sli4_free_rpi(vport->phba,
+					   ndlp->nlp_rpi);
+			spin_lock_irqsave(&vport->phba->ndlp_lock,
+					  iflags);
+			ndlp->nlp_flag &= ~NLP_RELEASE_RPI;
+			ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
+			spin_unlock_irqrestore(&vport->phba->ndlp_lock,
+					       iflags);
+		}
+	}
 	return 0;
 }
 
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2526,6 +2526,8 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 			} else {
 				__lpfc_sli_rpi_release(vport, ndlp);
 			}
+			if (vport->load_flag & FC_UNLOADING)
+				lpfc_nlp_put(ndlp);
 			pmb->ctx_ndlp = NULL;
 		}
 	}


