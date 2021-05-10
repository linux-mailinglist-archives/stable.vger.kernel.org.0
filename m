Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17429378571
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbhEJLA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234219AbhEJK4E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D16316146E;
        Mon, 10 May 2021 10:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643484;
        bh=EjTHARZUOvtQqgDKUnAcNNGV5PbgFHJBUkMh9j2gy9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReRMRuxb2Pzo8iRzGglpT0cyEi6/JA2h5Szfx17hP7769u1IOk1e4Hq3KWO1ivgf3
         hgNjWsyR5bAXpcyn05uGPjkqCbdcvAcmGc80A3nrI0Ccmp/0VStKzNlDOLuBW/c0pz
         ubHtiLvq9ng2TcCTGGxwzpqXv0QIsPKWB5qCfkJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.11 034/342] scsi: lpfc: Fix rmmod crash due to bad ring pointers to abort_iotag
Date:   Mon, 10 May 2021 12:17:04 +0200
Message-Id: <20210510102011.227174361@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit 078c68b87a717b9fcd8e0f2109f73456fbc55490 upstream.

Rmmod on SLI-4 adapters is sometimes hitting a bad ptr dereference in
lpfc_els_free_iocb().

A prior patch refactored the lpfc_sli_abort_iocb() routine. One of the
changes was to convert from building/sending an abort within the routine to
using a common routine. The reworked routine passes, without modification,
the pring ptr to the new common routine. The older routine had logic to
check SLI-3 vs SLI-4 and adapt the pring ptr if necessary as callers were
passing SLI-3 pointers even when not on an SLI-4 adapter. The new routine
is missing this check and adapt, so the SLI-3 ring pointers are being used
in SLI-4 paths.

Fix by cleaning up the calling routines. In review, there is no need to
pass the ring ptr argument to abort_iocb at all. The routine can look at
the adapter type itself and reference the proper ring.

Link: https://lore.kernel.org/r/20210412013127.2387-2-jsmart2021@gmail.com
Fixes: db7531d2b377 ("scsi: lpfc: Convert abort handling to SLI-3 and SLI-4 handlers")
Cc: <stable@vger.kernel.org> # v5.11+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_crtn.h      |    4 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   10 +++-------
 drivers/scsi/lpfc/lpfc_nportdisc.c |    4 +---
 drivers/scsi/lpfc/lpfc_sli.c       |   20 +++++++++++++++-----
 4 files changed, 21 insertions(+), 17 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -352,8 +352,8 @@ int lpfc_sli_hbq_size(void);
 int lpfc_sli_issue_abort_iotag(struct lpfc_hba *, struct lpfc_sli_ring *,
 			       struct lpfc_iocbq *, void *);
 int lpfc_sli_sum_iocb(struct lpfc_vport *, uint16_t, uint64_t, lpfc_ctx_cmd);
-int lpfc_sli_abort_iocb(struct lpfc_vport *, struct lpfc_sli_ring *, uint16_t,
-			uint64_t, lpfc_ctx_cmd);
+int lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16 tgt_id, u64 lun_id,
+			lpfc_ctx_cmd abort_cmd);
 int
 lpfc_sli_abort_taskmgmt(struct lpfc_vport *, struct lpfc_sli_ring *,
 			uint16_t, uint64_t, lpfc_ctx_cmd);
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -130,11 +130,8 @@ lpfc_terminate_rport_io(struct fc_rport
 			      "rport terminate: sid:x%x did:x%x flg:x%x",
 			      ndlp->nlp_sid, ndlp->nlp_DID, ndlp->nlp_flag);
 
-	if (ndlp->nlp_sid != NLP_NO_SID) {
-		lpfc_sli_abort_iocb(vport,
-				    &vport->phba->sli.sli3_ring[LPFC_FCP_RING],
-				    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
-	}
+	if (ndlp->nlp_sid != NLP_NO_SID)
+		lpfc_sli_abort_iocb(vport, ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 }
 
 /*
@@ -289,8 +286,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		warn_on = 1;
-		lpfc_sli_abort_iocb(vport, &phba->sli.sli3_ring[LPFC_FCP_RING],
-				    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
+		lpfc_sli_abort_iocb(vport, ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
 
 	if (warn_on) {
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2614,12 +2614,10 @@ static uint32_t
 lpfc_rcv_prlo_mapped_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			  void *arg, uint32_t evt)
 {
-	struct lpfc_hba  *phba = vport->phba;
 	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *) arg;
 
 	/* flush the target */
-	lpfc_sli_abort_iocb(vport, &phba->sli.sli3_ring[LPFC_FCP_RING],
-			    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
+	lpfc_sli_abort_iocb(vport, ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 
 	/* Treat like rcv logo */
 	lpfc_rcv_logo(vport, ndlp, cmdiocb, ELS_CMD_PRLO);
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11639,7 +11639,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
 	icmd = &cmdiocb->iocb;
 	if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
 	    icmd->ulpCommand == CMD_CLOSE_XRI_CN ||
-	    (cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED) != 0)
+	    cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED)
 		return IOCB_ABORTING;
 
 	if (!pring) {
@@ -11937,7 +11937,6 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba
 /**
  * lpfc_sli_abort_iocb - issue abort for all commands on a host/target/LUN
  * @vport: Pointer to virtual port.
- * @pring: Pointer to driver SLI ring object.
  * @tgt_id: SCSI ID of the target.
  * @lun_id: LUN ID of the scsi device.
  * @abort_cmd: LPFC_CTX_LUN/LPFC_CTX_TGT/LPFC_CTX_HOST.
@@ -11952,18 +11951,22 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba
  * FCP iocbs associated with SCSI target specified by tgt_id parameter.
  * When abort_cmd == LPFC_CTX_HOST, the function sends abort to all
  * FCP iocbs associated with virtual port.
+ * The pring used for SLI3 is sli3_ring[LPFC_FCP_RING], for SLI4
+ * lpfc_sli4_calc_ring is used.
  * This function returns number of iocbs it failed to abort.
  * This function is called with no locks held.
  **/
 int
-lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
-		    uint16_t tgt_id, uint64_t lun_id, lpfc_ctx_cmd abort_cmd)
+lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16 tgt_id, u64 lun_id,
+		    lpfc_ctx_cmd abort_cmd)
 {
 	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_sli_ring *pring = NULL;
 	struct lpfc_iocbq *iocbq;
 	int errcnt = 0, ret_val = 0;
 	unsigned long iflags;
 	int i;
+	void *fcp_cmpl = NULL;
 
 	/* all I/Os are in process of being flushed */
 	if (phba->hba_flag & HBA_IOQ_FLUSH)
@@ -11977,8 +11980,15 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
 			continue;
 
 		spin_lock_irqsave(&phba->hbalock, iflags);
+		if (phba->sli_rev == LPFC_SLI_REV3) {
+			pring = &phba->sli.sli3_ring[LPFC_FCP_RING];
+			fcp_cmpl = lpfc_sli_abort_fcp_cmpl;
+		} else if (phba->sli_rev == LPFC_SLI_REV4) {
+			pring = lpfc_sli4_calc_ring(phba, iocbq);
+			fcp_cmpl = lpfc_sli4_abort_fcp_cmpl;
+		}
 		ret_val = lpfc_sli_issue_abort_iotag(phba, pring, iocbq,
-						     lpfc_sli_abort_fcp_cmpl);
+						     fcp_cmpl);
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		if (ret_val != IOCB_SUCCESS)
 			errcnt++;


