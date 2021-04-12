Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D4D35B81A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 03:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhDLBcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 21:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236551AbhDLBcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 21:32:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30828C061574;
        Sun, 11 Apr 2021 18:32:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id cu16so3774657pjb.4;
        Sun, 11 Apr 2021 18:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2VyxYortG0aGHUT2/EouoRYWTpky/T5nFCT2ISkObGo=;
        b=EZbzjZqAkSgoT0TTOmOUYyzJuFPSZ24Ad70jcFezNmupDXFiL7NmUChJrPHyV2nxrP
         fVdB9T9zHPGva6PHnb0w3jsEho52TOGa7Hd92HJ7hnOcKafiGIwCtZXodWt9eEMY9ZnE
         GO9Uy/rUPKYbmlzpQ1zTDKvaHffTlHQA4qNZ+ckSlVkgLlqtkdZ95IH/fE2FYcflm1fO
         gDTW+/GxKcrNahulTeebVqc15VMqxqjrgahLJ6bAVxWHyZZmHYLM7iQ8V4sSvIZrzo1s
         DE2cy7W9zrffLN7Ss4MvnXT5x8EWzoAkglxg6/vnyC2GiJicTXQYzAFT81geqN0TzGqf
         l3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2VyxYortG0aGHUT2/EouoRYWTpky/T5nFCT2ISkObGo=;
        b=ESODJ1xzbFhPoBoTwAwxAR1aXHpejxVgCNEyZ7+KPEeYSbMpKyfPr2q55FtyBbxOvr
         ejvmEuk9maCoQ0+doMnCQvz2Qp96rEFBUnzkztWIMcX0lD3foavKrJM/k6I3/R/K+KQB
         xllRuvyeNl9Vdghqcso6MuvsyTUmJgdbpCQqrsZ5v9SZ0bwFAMuM3cj18UFXvuLDadgR
         d4Fbxgqo2J4kRYxmIp4fDMR3cN2eByaTAJiiCmrX3QmbEk701XWkJ1kNED+YwC/UOA5n
         tsMcoVoJxWYft+j/0799vxGG4JjO8LgUlPNSH6QsKE++w8Qh9cKIKXfN57ke0vcerE/E
         JzFA==
X-Gm-Message-State: AOAM530sorW0PR7axTcsxWa40BjjKUqI7hlVEgeiQAv4FiRw3esCqon3
        HJLK3ijmshL5MkWPfIF+WeU35JfiXN0=
X-Google-Smtp-Source: ABdhPJyYrjGxfBmY6zMfMCr7Xr+ok+xRJLVViUMJDnE1v9DhpZFWIdznhqSjarRukkRR+uOfWORRgQ==
X-Received: by 2002:a17:90a:b398:: with SMTP id e24mr14401615pjr.141.1618191120534;
        Sun, 11 Apr 2021 18:32:00 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:00 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 01/16] lpfc: Fix rmmod crash due to bad ring pointers to abort_iotag
Date:   Sun, 11 Apr 2021 18:31:12 -0700
Message-Id: <20210412013127.2387-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Rmmod on sli4 adapters is sometimes hitting a bad ptr dereference
in lpfc_els_free_iocb

A prior patch refactored the lpfc_sli_abort_iocb routine. One of the
changes was to convert from building/sending an abort within the
routine to using a common routine. The reworked routine passes,
without modification, the pring ptr to the new common routine. The
older routine had logic to check sli3 vs sli4 and adapt the pring ptr
if necessary as callers were passing sli3 pointers even when not on an
sli4 adapter. The new routine is missing this check and adapt, so the
sli-3 ring pointers are being used in sli-4 paths.

Fix by cleaning up the calling routines. In review, there is no need to
pass the ring ptr argument to abort_iocb at all. The routine can look at
the adapter type itself and reference the proper ring.

Fixes: db7531d2b377 ("scsi: lpfc: Convert abort handling to SLI-3 and SLI-4 handlers")
Cc: <stable@vger.kernel.org> # v5.11+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h      |  4 ++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 10 +++-------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  4 +---
 drivers/scsi/lpfc/lpfc_sli.c       | 20 +++++++++++++++-----
 4 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index eb4cf36229d5..e7db4496e8a9 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -353,8 +353,8 @@ int lpfc_sli_hbq_size(void);
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
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 3b5cd23dd172..85633eb7524f 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -140,11 +140,8 @@ lpfc_terminate_rport_io(struct fc_rport *rport)
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
@@ -299,8 +296,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		warn_on = 1;
-		lpfc_sli_abort_iocb(vport, &phba->sli.sli3_ring[LPFC_FCP_RING],
-				    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
+		lpfc_sli_abort_iocb(vport, ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
 
 	if (warn_on) {
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 9aa907ce4c63..8472c5e716db 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2559,12 +2559,10 @@ static uint32_t
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
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f6e1e36eabdc..7832f8470667 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11644,7 +11644,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	icmd = &cmdiocb->iocb;
 	if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
 	    icmd->ulpCommand == CMD_CLOSE_XRI_CN ||
-	    (cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED) != 0)
+	    cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED)
 		return IOCB_ABORTING;
 
 	if (!pring) {
@@ -11942,7 +11942,6 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 /**
  * lpfc_sli_abort_iocb - issue abort for all commands on a host/target/LUN
  * @vport: Pointer to virtual port.
- * @pring: Pointer to driver SLI ring object.
  * @tgt_id: SCSI ID of the target.
  * @lun_id: LUN ID of the scsi device.
  * @abort_cmd: LPFC_CTX_LUN/LPFC_CTX_TGT/LPFC_CTX_HOST.
@@ -11957,18 +11956,22 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
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
@@ -11982,8 +11985,15 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
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
-- 
2.26.2

