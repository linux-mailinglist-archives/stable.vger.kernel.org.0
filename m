Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19A135AF3A
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 19:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbhDJRbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 13:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbhDJRbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 13:31:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734B1C06138A;
        Sat, 10 Apr 2021 10:30:45 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cu16so2464360pjb.4;
        Sat, 10 Apr 2021 10:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2VyxYortG0aGHUT2/EouoRYWTpky/T5nFCT2ISkObGo=;
        b=qyBShVRlicTV1itY73GtSmyrpnUzuVODeNEveDV7nmWrAWj1fYQ3crxliAR1um32YG
         6T6CdFcwDa3gJV06o9VDb3Gv1S//k3PiRvw8sPL5h0Xkz6lyAYWNPs9sqo2HLJEYYsBY
         GC8Czl6soCHOHcgFz5L+WpTcglVUh5nnV44QWRXky6Rnjc3P0q1ymoXPG+hL+mkt195Y
         PrP4idvE0C7oiH0ITZnnUUp7sO4vbiL5T5aKD4mFIgijg7oGjQX9CK73jQZ0u4nLF93a
         dw/zWeNKA09VX9di87vzuOzgtSq4AgUn9be0jn3LS93nHN9rL+nA2EdwgJjrfclrnPjM
         X8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2VyxYortG0aGHUT2/EouoRYWTpky/T5nFCT2ISkObGo=;
        b=uZdWxVa249grYxcSdNihiwY3joJAtdgW80coA/fnOkAOZ5uZFReFRfqZESXrAgQviT
         fmR4HvHAsy6tk2J6Bl/eyBHesDLHMMtVEzMQjRCwRFauB4nuiKLTdE/yrgEbD4XoHPRY
         m8LBNCzeIoK+zD2pGzz/LqeCkx5z+cZupoFd6IqkryKhCZgTlX7gU0cxJ8wJ3WNGxhW3
         FPbBQk3iolzGROOfGjNorlk+Ru44gS3+z20I54mx3uLRI+kXAuJHDVhOw8e2jAyuPyS7
         f94ow4kN08TtM4No/Wfl9jYdZvVyMtK1XGOi16m2EfJ0kJ0MtMVn44Vxpa99ZbGRXLer
         nEPw==
X-Gm-Message-State: AOAM530x/L2zNYvk771BAaAWYbvrGYq4RlLAo6f9BWVICnePtNe9yiui
        vjNRv7g54Np9bI0onnNJnA62cuwFJDg=
X-Google-Smtp-Source: ABdhPJyhNxwu0CgCIG59cGakpvST+yDG8bOaJBmZ5PQxSTdLQ1CHMUMGs6xrZhc/Vr2YRS3dufKEiw==
X-Received: by 2002:a17:90a:6282:: with SMTP id d2mr18766584pjj.168.1618075844853;
        Sat, 10 Apr 2021 10:30:44 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:44 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 01/16] lpfc: Fix rmmod crash due to bad ring pointers to abort_iotag
Date:   Sat, 10 Apr 2021 10:30:19 -0700
Message-Id: <20210410173034.67618-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
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

