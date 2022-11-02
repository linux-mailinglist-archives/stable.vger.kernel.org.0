Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A35615904
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiKBDDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiKBDCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:02:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4DD23384
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:02:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EEAC601C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96ABC433C1;
        Wed,  2 Nov 2022 03:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358156;
        bh=48lgUE98TmCnB0s3Y6dZfTDh6b39yAqC3ydW+1GsukY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oq7Qcsxz5b5zZm8TORoOqRFz83nlduZCh9JSQAyYERGElg6/xLjvs6fzJxxhn/4j0
         fMBMzLO00oziZ1a/3BQF04z0kr8TN64V2SN2exUbbS+BCI2Mtw9DTvDqmttzrJH1Ja
         Kawoz5fs5IwTUhSx61GQ2QUzsjkKtrt3090jqFuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Smart <jsmart2021@gmail.com>
Subject: [PATCH 5.15 051/132] Revert "scsi: lpfc: SLI path split: Refactor fast and slow paths to native SLI4"
Date:   Wed,  2 Nov 2022 03:32:37 +0100
Message-Id: <20221102022100.956812265@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

This reverts commit c56cc7fefc3159049f94fb1318e48aa60cabf703.

LTS 5.15 pulled in several lpfc "SLI Path split" patches.  The Path
Split mods were a 14-patch set, which refactors the driver from
to split the sli-3 hw (now eol) from the sli-4 hw and use sli4
structures natively. The patches are highly inter-related.

Given only some of the patches were included, it created a situation
where FLOGI's fail, thus SLI Ports can't start communication.

Reverting this patch as its one of the partial Path Split patches
that was included.

Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc.h      |   36 --
 drivers/scsi/lpfc/lpfc_crtn.h |    1 
 drivers/scsi/lpfc/lpfc_hw4.h  |    7 
 drivers/scsi/lpfc/lpfc_sli.c  |  513 ++++++++++++++++++++++++------------------
 drivers/scsi/lpfc/lpfc_sli.h  |    2 
 5 files changed, 302 insertions(+), 257 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1803,39 +1803,3 @@ static inline int lpfc_is_vmid_enabled(s
 {
 	return phba->cfg_vmid_app_header || phba->cfg_vmid_priority_tagging;
 }
-
-static inline
-u8 get_job_ulpstatus(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
-{
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		return bf_get(lpfc_wcqe_c_status, &iocbq->wcqe_cmpl);
-	else
-		return iocbq->iocb.ulpStatus;
-}
-
-static inline
-u32 get_job_word4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
-{
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		return iocbq->wcqe_cmpl.parameter;
-	else
-		return iocbq->iocb.un.ulpWord[4];
-}
-
-static inline
-u8 get_job_cmnd(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
-{
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		return bf_get(wqe_cmnd, &iocbq->wqe.generic.wqe_com);
-	else
-		return iocbq->iocb.ulpCommand;
-}
-
-static inline
-u16 get_job_ulpcontext(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
-{
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		return bf_get(wqe_ctxt_tag, &iocbq->wqe.generic.wqe_com);
-	else
-		return iocbq->iocb.ulpContext;
-}
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -129,7 +129,6 @@ void lpfc_disc_list_loopmap(struct lpfc_
 void lpfc_disc_start(struct lpfc_vport *);
 void lpfc_cleanup_discovery_resources(struct lpfc_vport *);
 void lpfc_cleanup(struct lpfc_vport *);
-void lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd);
 void lpfc_disc_timeout(struct timer_list *);
 
 int lpfc_unregister_fcf_prep(struct lpfc_hba *);
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -60,13 +60,6 @@
 	((ptr)->name##_WORD = ((((value) & name##_MASK) << name##_SHIFT) | \
 		 ((ptr)->name##_WORD & ~(name##_MASK << name##_SHIFT))))
 
-#define get_wqe_reqtag(x)	(((x)->wqe.words[9] >>  0) & 0xFFFF)
-
-#define get_job_ulpword(x, y)	((x)->iocb.un.ulpWord[y])
-
-#define set_job_ulpstatus(x, y)	bf_set(lpfc_wcqe_c_status, &(x)->wcqe_cmpl, y)
-#define set_job_ulpword4(x, y)	((&(x)->wcqe_cmpl)->parameter = y)
-
 struct dma_address {
 	uint32_t addr_lo;
 	uint32_t addr_hi;
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -70,9 +70,8 @@ static int lpfc_sli_issue_mbox_s4(struct
 				  uint32_t);
 static int lpfc_sli4_read_rev(struct lpfc_hba *, LPFC_MBOXQ_t *,
 			      uint8_t *, uint32_t *);
-static struct lpfc_iocbq *
-lpfc_sli4_els_preprocess_rspiocbq(struct lpfc_hba *phba,
-				  struct lpfc_iocbq *rspiocbq);
+static struct lpfc_iocbq *lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *,
+							 struct lpfc_iocbq *);
 static void lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *,
 				      struct hbq_dmabuf *);
 static void lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
@@ -90,9 +89,6 @@ static struct lpfc_cqe *lpfc_sli4_cq_get
 static void __lpfc_sli4_consume_cqe(struct lpfc_hba *phba,
 				    struct lpfc_queue *cq,
 				    struct lpfc_cqe *cqe);
-static uint16_t lpfc_wqe_bpl2sgl(struct lpfc_hba *phba,
-				 struct lpfc_iocbq *pwqeq,
-				 struct lpfc_sglq *sglq);
 
 union lpfc_wqe128 lpfc_iread_cmd_template;
 union lpfc_wqe128 lpfc_iwrite_cmd_template;
@@ -3556,12 +3552,17 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *p
 		      struct lpfc_iocbq *prspiocb)
 {
 	struct lpfc_iocbq *cmd_iocb = NULL;
-	u16 iotag;
+	uint16_t iotag;
+	spinlock_t *temp_lock = NULL;
+	unsigned long iflag = 0;
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
-		iotag = get_wqe_reqtag(prspiocb);
+		temp_lock = &pring->ring_lock;
 	else
-		iotag = prspiocb->iocb.ulpIoTag;
+		temp_lock = &phba->hbalock;
+
+	spin_lock_irqsave(temp_lock, iflag);
+	iotag = prspiocb->iocb.ulpIoTag;
 
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
@@ -3570,14 +3571,17 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *p
 			list_del_init(&cmd_iocb->list);
 			cmd_iocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
+			spin_unlock_irqrestore(temp_lock, iflag);
 			return cmd_iocb;
 		}
 	}
 
+	spin_unlock_irqrestore(temp_lock, iflag);
 	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 			"0317 iotag x%x is out of "
-			"range: max iotag x%x\n",
-			iotag, phba->sli.last_iotag);
+			"range: max iotag x%x wd0 x%x\n",
+			iotag, phba->sli.last_iotag,
+			*(((uint32_t *) &prspiocb->iocb) + 7));
 	return NULL;
 }
 
@@ -3598,7 +3602,15 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc
 			     struct lpfc_sli_ring *pring, uint16_t iotag)
 {
 	struct lpfc_iocbq *cmd_iocb = NULL;
+	spinlock_t *temp_lock = NULL;
+	unsigned long iflag = 0;
 
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		temp_lock = &pring->ring_lock;
+	else
+		temp_lock = &phba->hbalock;
+
+	spin_lock_irqsave(temp_lock, iflag);
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
 		if (cmd_iocb->cmd_flag & LPFC_IO_ON_TXCMPLQ) {
@@ -3606,10 +3618,12 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc
 			list_del_init(&cmd_iocb->list);
 			cmd_iocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
+			spin_unlock_irqrestore(temp_lock, iflag);
 			return cmd_iocb;
 		}
 	}
 
+	spin_unlock_irqrestore(temp_lock, iflag);
 	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 			"0372 iotag x%x lookup error: max iotag (x%x) "
 			"cmd_flag x%x\n",
@@ -3642,29 +3656,18 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 	struct lpfc_iocbq *cmdiocbp;
 	int rc = 1;
 	unsigned long iflag;
-	u32 ulp_command, ulp_status, ulp_word4, ulp_context, iotag;
 
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
-
-	ulp_command = get_job_cmnd(phba, saveq);
-	ulp_status = get_job_ulpstatus(phba, saveq);
-	ulp_word4 = get_job_word4(phba, saveq);
-	ulp_context = get_job_ulpcontext(phba, saveq);
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		iotag = get_wqe_reqtag(saveq);
-	else
-		iotag = saveq->iocb.ulpIoTag;
-
 	if (cmdiocbp) {
-		ulp_command = get_job_cmnd(phba, cmdiocbp);
 		if (cmdiocbp->cmd_cmpl) {
 			/*
 			 * If an ELS command failed send an event to mgmt
 			 * application.
 			 */
-			if (ulp_status &&
+			if (saveq->iocb.ulpStatus &&
 			     (pring->ringno == LPFC_ELS_RING) &&
-			     (ulp_command == CMD_ELS_REQUEST64_CR))
+			     (cmdiocbp->iocb.ulpCommand ==
+				CMD_ELS_REQUEST64_CR))
 				lpfc_send_els_failure_event(phba,
 					cmdiocbp, saveq);
 
@@ -3726,20 +3729,20 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 							~LPFC_DRIVER_ABORTED;
 						spin_unlock_irqrestore(
 							&phba->hbalock, iflag);
-						set_job_ulpstatus(cmdiocbp,
-								  IOSTAT_LOCAL_REJECT);
-						set_job_ulpword4(cmdiocbp,
-								 IOERR_ABORT_REQUESTED);
+						cmdiocbp->iocb.ulpStatus =
+							IOSTAT_LOCAL_REJECT;
+						cmdiocbp->iocb.un.ulpWord[4] =
+							IOERR_ABORT_REQUESTED;
 						/*
 						 * For SLI4, irsiocb contains
 						 * NO_XRI in sli_xritag, it
 						 * shall not affect releasing
 						 * sgl (xri) process.
 						 */
-						set_job_ulpstatus(saveq,
-								  IOSTAT_LOCAL_REJECT);
-						set_job_ulpword4(saveq,
-								 IOERR_SLI_ABORTED);
+						saveq->iocb.ulpStatus =
+							IOSTAT_LOCAL_REJECT;
+						saveq->iocb.un.ulpWord[4] =
+							IOERR_SLI_ABORTED;
 						spin_lock_irqsave(
 							&phba->hbalock, iflag);
 						saveq->cmd_flag |=
@@ -3767,8 +3770,12 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 					 "0322 Ring %d handler: "
 					 "unexpected completion IoTag x%x "
 					 "Data: x%x x%x x%x x%x\n",
-					 pring->ringno, iotag, ulp_status,
-					 ulp_word4, ulp_command, ulp_context);
+					 pring->ringno,
+					 saveq->iocb.ulpIoTag,
+					 saveq->iocb.ulpStatus,
+					 saveq->iocb.un.ulpWord[4],
+					 saveq->iocb.ulpCommand,
+					 saveq->iocb.ulpContext);
 		}
 	}
 
@@ -4083,159 +4090,155 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_h
 			struct lpfc_iocbq *rspiocbp)
 {
 	struct lpfc_iocbq *saveq;
-	struct lpfc_iocbq *cmdiocb;
+	struct lpfc_iocbq *cmdiocbp;
 	struct lpfc_iocbq *next_iocb;
-	IOCB_t *irsp;
+	IOCB_t *irsp = NULL;
 	uint32_t free_saveq;
-	u8 cmd_type;
+	uint8_t iocb_cmd_type;
 	lpfc_iocb_type type;
 	unsigned long iflag;
-	u32 ulp_status = get_job_ulpstatus(phba, rspiocbp);
-	u32 ulp_word4 = get_job_word4(phba, rspiocbp);
-	u32 ulp_command = get_job_cmnd(phba, rspiocbp);
 	int rc;
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	/* First add the response iocb to the countinueq list */
-	list_add_tail(&rspiocbp->list, &pring->iocb_continueq);
+	list_add_tail(&rspiocbp->list, &(pring->iocb_continueq));
 	pring->iocb_continueq_cnt++;
 
-	/*
-	 * By default, the driver expects to free all resources
-	 * associated with this iocb completion.
-	 */
-	free_saveq = 1;
-	saveq = list_get_first(&pring->iocb_continueq,
-			       struct lpfc_iocbq, list);
-	list_del_init(&pring->iocb_continueq);
-	pring->iocb_continueq_cnt = 0;
+	/* Now, determine whether the list is completed for processing */
+	irsp = &rspiocbp->iocb;
+	if (irsp->ulpLe) {
+		/*
+		 * By default, the driver expects to free all resources
+		 * associated with this iocb completion.
+		 */
+		free_saveq = 1;
+		saveq = list_get_first(&pring->iocb_continueq,
+				       struct lpfc_iocbq, list);
+		irsp = &(saveq->iocb);
+		list_del_init(&pring->iocb_continueq);
+		pring->iocb_continueq_cnt = 0;
 
-	pring->stats.iocb_rsp++;
+		pring->stats.iocb_rsp++;
 
-	/*
-	 * If resource errors reported from HBA, reduce
-	 * queuedepths of the SCSI device.
-	 */
-	if (ulp_status == IOSTAT_LOCAL_REJECT &&
-	    ((ulp_word4 & IOERR_PARAM_MASK) ==
-	     IOERR_NO_RESOURCES)) {
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-		phba->lpfc_rampdown_queue_depth(phba);
-		spin_lock_irqsave(&phba->hbalock, iflag);
-	}
+		/*
+		 * If resource errors reported from HBA, reduce
+		 * queuedepths of the SCSI device.
+		 */
+		if ((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
+		    ((irsp->un.ulpWord[4] & IOERR_PARAM_MASK) ==
+		     IOERR_NO_RESOURCES)) {
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			phba->lpfc_rampdown_queue_depth(phba);
+			spin_lock_irqsave(&phba->hbalock, iflag);
+		}
 
-	if (ulp_status) {
-		/* Rsp ring <ringno> error: IOCB */
-		if (phba->sli_rev < LPFC_SLI_REV4) {
-			irsp = &rspiocbp->iocb;
-			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-					"0328 Rsp Ring %d error: ulp_status x%x "
-					"IOCB Data: "
-					"x%08x x%08x x%08x x%08x "
-					"x%08x x%08x x%08x x%08x "
-					"x%08x x%08x x%08x x%08x "
-					"x%08x x%08x x%08x x%08x\n",
-					pring->ringno, ulp_status,
-					get_job_ulpword(rspiocbp, 0),
-					get_job_ulpword(rspiocbp, 1),
-					get_job_ulpword(rspiocbp, 2),
-					get_job_ulpword(rspiocbp, 3),
-					get_job_ulpword(rspiocbp, 4),
-					get_job_ulpword(rspiocbp, 5),
-					*(((uint32_t *)irsp) + 6),
-					*(((uint32_t *)irsp) + 7),
-					*(((uint32_t *)irsp) + 8),
-					*(((uint32_t *)irsp) + 9),
-					*(((uint32_t *)irsp) + 10),
-					*(((uint32_t *)irsp) + 11),
-					*(((uint32_t *)irsp) + 12),
-					*(((uint32_t *)irsp) + 13),
-					*(((uint32_t *)irsp) + 14),
-					*(((uint32_t *)irsp) + 15));
-		} else {
+		if (irsp->ulpStatus) {
+			/* Rsp ring <ringno> error: IOCB */
 			lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
-					"0321 Rsp Ring %d error: "
+					"0328 Rsp Ring %d error: "
 					"IOCB Data: "
+					"x%x x%x x%x x%x "
+					"x%x x%x x%x x%x "
+					"x%x x%x x%x x%x "
 					"x%x x%x x%x x%x\n",
 					pring->ringno,
-					rspiocbp->wcqe_cmpl.word0,
-					rspiocbp->wcqe_cmpl.total_data_placed,
-					rspiocbp->wcqe_cmpl.parameter,
-					rspiocbp->wcqe_cmpl.word3);
+					irsp->un.ulpWord[0],
+					irsp->un.ulpWord[1],
+					irsp->un.ulpWord[2],
+					irsp->un.ulpWord[3],
+					irsp->un.ulpWord[4],
+					irsp->un.ulpWord[5],
+					*(((uint32_t *) irsp) + 6),
+					*(((uint32_t *) irsp) + 7),
+					*(((uint32_t *) irsp) + 8),
+					*(((uint32_t *) irsp) + 9),
+					*(((uint32_t *) irsp) + 10),
+					*(((uint32_t *) irsp) + 11),
+					*(((uint32_t *) irsp) + 12),
+					*(((uint32_t *) irsp) + 13),
+					*(((uint32_t *) irsp) + 14),
+					*(((uint32_t *) irsp) + 15));
 		}
-	}
 
+		/*
+		 * Fetch the IOCB command type and call the correct completion
+		 * routine. Solicited and Unsolicited IOCBs on the ELS ring
+		 * get freed back to the lpfc_iocb_list by the discovery
+		 * kernel thread.
+		 */
+		iocb_cmd_type = irsp->ulpCommand & CMD_IOCB_MASK;
+		type = lpfc_sli_iocb_cmd_type(iocb_cmd_type);
+		switch (type) {
+		case LPFC_SOL_IOCB:
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			rc = lpfc_sli_process_sol_iocb(phba, pring, saveq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
+			break;
 
-	/*
-	 * Fetch the iocb command type and call the correct completion
-	 * routine. Solicited and Unsolicited IOCBs on the ELS ring
-	 * get freed back to the lpfc_iocb_list by the discovery
-	 * kernel thread.
-	 */
-	cmd_type = ulp_command & CMD_IOCB_MASK;
-	type = lpfc_sli_iocb_cmd_type(cmd_type);
-	switch (type) {
-	case LPFC_SOL_IOCB:
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-		rc = lpfc_sli_process_sol_iocb(phba, pring, saveq);
-		spin_lock_irqsave(&phba->hbalock, iflag);
-		break;
-	case LPFC_UNSOL_IOCB:
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-		rc = lpfc_sli_process_unsol_iocb(phba, pring, saveq);
-		spin_lock_irqsave(&phba->hbalock, iflag);
-		if (!rc)
-			free_saveq = 0;
-		break;
-	case LPFC_ABORT_IOCB:
-		cmdiocb = NULL;
-		if (ulp_command != CMD_XRI_ABORTED_CX)
-			cmdiocb = lpfc_sli_iocbq_lookup(phba, pring,
-							saveq);
-		if (cmdiocb) {
-			/* Call the specified completion routine */
-			if (cmdiocb->cmd_cmpl) {
+		case LPFC_UNSOL_IOCB:
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			rc = lpfc_sli_process_unsol_iocb(phba, pring, saveq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
+			if (!rc)
+				free_saveq = 0;
+			break;
+
+		case LPFC_ABORT_IOCB:
+			cmdiocbp = NULL;
+			if (irsp->ulpCommand != CMD_XRI_ABORTED_CX) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				cmdiocb->cmd_cmpl(phba, cmdiocb, saveq);
+				cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring,
+								 saveq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
+			}
+			if (cmdiocbp) {
+				/* Call the specified completion routine */
+				if (cmdiocbp->cmd_cmpl) {
+					spin_unlock_irqrestore(&phba->hbalock,
+							       iflag);
+					(cmdiocbp->cmd_cmpl)(phba, cmdiocbp,
+							      saveq);
+					spin_lock_irqsave(&phba->hbalock,
+							  iflag);
+				} else
+					__lpfc_sli_release_iocbq(phba,
+								 cmdiocbp);
+			}
+			break;
+
+		case LPFC_UNKNOWN_IOCB:
+			if (irsp->ulpCommand == CMD_ADAPTER_MSG) {
+				char adaptermsg[LPFC_MAX_ADPTMSG];
+				memset(adaptermsg, 0, LPFC_MAX_ADPTMSG);
+				memcpy(&adaptermsg[0], (uint8_t *)irsp,
+				       MAX_MSG_DATA);
+				dev_warn(&((phba->pcidev)->dev),
+					 "lpfc%d: %s\n",
+					 phba->brd_no, adaptermsg);
 			} else {
-				__lpfc_sli_release_iocbq(phba, cmdiocb);
+				/* Unknown IOCB command */
+				lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+						"0335 Unknown IOCB "
+						"command Data: x%x "
+						"x%x x%x x%x\n",
+						irsp->ulpCommand,
+						irsp->ulpStatus,
+						irsp->ulpIoTag,
+						irsp->ulpContext);
 			}
+			break;
 		}
-		break;
-	case LPFC_UNKNOWN_IOCB:
-		if (ulp_command == CMD_ADAPTER_MSG) {
-			char adaptermsg[LPFC_MAX_ADPTMSG];
-
-			memset(adaptermsg, 0, LPFC_MAX_ADPTMSG);
-			memcpy(&adaptermsg[0], (uint8_t *)&rspiocbp->wqe,
-			       MAX_MSG_DATA);
-			dev_warn(&((phba->pcidev)->dev),
-				 "lpfc%d: %s\n",
-				 phba->brd_no, adaptermsg);
-		} else {
-			/* Unknown command */
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-					"0335 Unknown IOCB "
-					"command Data: x%x "
-					"x%x x%x x%x\n",
-					ulp_command,
-					ulp_status,
-					get_wqe_reqtag(rspiocbp),
-					get_job_ulpcontext(phba, rspiocbp));
-		}
-		break;
-	}
 
-	if (free_saveq) {
-		list_for_each_entry_safe(rspiocbp, next_iocb,
-					 &saveq->list, list) {
-			list_del_init(&rspiocbp->list);
-			__lpfc_sli_release_iocbq(phba, rspiocbp);
+		if (free_saveq) {
+			list_for_each_entry_safe(rspiocbp, next_iocb,
+						 &saveq->list, list) {
+				list_del_init(&rspiocbp->list);
+				__lpfc_sli_release_iocbq(phba, rspiocbp);
+			}
+			__lpfc_sli_release_iocbq(phba, saveq);
 		}
-		__lpfc_sli_release_iocbq(phba, saveq);
+		rspiocbp = NULL;
 	}
-	rspiocbp = NULL;
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
 	return rspiocbp;
 }
@@ -4428,8 +4431,8 @@ lpfc_sli_handle_slow_ring_event_s4(struc
 			irspiocbq = container_of(cq_event, struct lpfc_iocbq,
 						 cq_event);
 			/* Translate ELS WCQE to response IOCBQ */
-			irspiocbq = lpfc_sli4_els_preprocess_rspiocbq(phba,
-								      irspiocbq);
+			irspiocbq = lpfc_sli4_els_wcqe_to_rspiocbq(phba,
+								   irspiocbq);
 			if (irspiocbq)
 				lpfc_sli_sp_handle_rspiocb(phba, pring,
 							   irspiocbq);
@@ -10973,17 +10976,7 @@ __lpfc_sli_issue_fcp_io_s4(struct lpfc_h
 	int rc;
 	struct lpfc_io_buf *lpfc_cmd =
 		(struct lpfc_io_buf *)piocb->context1;
-
-	lpfc_prep_embed_io(phba, lpfc_cmd);
-	rc = lpfc_sli4_issue_wqe(phba, lpfc_cmd->hdwq, piocb);
-	return rc;
-}
-
-void
-lpfc_prep_embed_io(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
-{
-	struct lpfc_iocbq *piocb = &lpfc_cmd->cur_iocbq;
-	union lpfc_wqe128 *wqe = &lpfc_cmd->cur_iocbq.wqe;
+	union lpfc_wqe128 *wqe = &piocb->wqe;
 	struct sli4_sge *sgl;
 
 	/* 128 byte wqe support here */
@@ -11032,6 +11025,8 @@ lpfc_prep_embed_io(struct lpfc_hba *phba
 			wqe->words[31] = piocb->vmid_tag.app_id;
 		}
 	}
+	rc = lpfc_sli4_issue_wqe(phba, lpfc_cmd->hdwq, piocb);
+	return rc;
 }
 
 /**
@@ -11053,10 +11048,9 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 			 struct lpfc_iocbq *piocb, uint32_t flag)
 {
 	struct lpfc_sglq *sglq;
-	union lpfc_wqe128 *wqe;
+	union lpfc_wqe128 wqe;
 	struct lpfc_queue *wq;
 	struct lpfc_sli_ring *pring;
-	u32 ulp_command = get_job_cmnd(phba, piocb);
 
 	/* Get the WQ */
 	if ((piocb->cmd_flag & LPFC_IO_FCP) ||
@@ -11074,9 +11068,10 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 	 */
 
 	lockdep_assert_held(&pring->ring_lock);
-	wqe = &piocb->wqe;
+
 	if (piocb->sli4_xritag == NO_XRI) {
-		if (ulp_command == CMD_ABORT_XRI_WQE)
+		if (piocb->iocb.ulpCommand == CMD_ABORT_XRI_CN ||
+		    piocb->iocb.ulpCommand == CMD_CLOSE_XRI_CN)
 			sglq = NULL;
 		else {
 			if (!list_empty(&pring->txq)) {
@@ -11117,24 +11112,14 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 	if (sglq) {
 		piocb->sli4_lxritag = sglq->sli4_lxritag;
 		piocb->sli4_xritag = sglq->sli4_xritag;
-
-		/* ABTS sent by initiator to CT exchange, the
-		 * RX_ID field will be filled with the newly
-		 * allocated responder XRI.
-		 */
-		if (ulp_command == CMD_XMIT_BLS_RSP64_CX &&
-		    piocb->abort_bls == LPFC_ABTS_UNSOL_INT)
-			bf_set(xmit_bls_rsp64_rxid, &wqe->xmit_bls_rsp,
-			       piocb->sli4_xritag);
-
-		bf_set(wqe_xri_tag, &wqe->generic.wqe_com,
-		       piocb->sli4_xritag);
-
-		if (lpfc_wqe_bpl2sgl(phba, piocb, sglq) == NO_XRI)
+		if (NO_XRI == lpfc_sli4_bpl2sgl(phba, piocb, sglq))
 			return IOCB_ERROR;
 	}
 
-	if (lpfc_sli4_wq_put(wq, wqe))
+	if (lpfc_sli4_iocb2wqe(phba, piocb, &wqe))
+		return IOCB_ERROR;
+
+	if (lpfc_sli4_wq_put(wq, &wqe))
 		return IOCB_ERROR;
 	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
 
@@ -14132,7 +14117,123 @@ void lpfc_sli4_els_xri_abort_event_proc(
 }
 
 /**
- * lpfc_sli4_els_preprocess_rspiocbq - Get response iocbq from els wcqe
+ * lpfc_sli4_iocb_param_transfer - Transfer pIocbOut and cmpl status to pIocbIn
+ * @phba: pointer to lpfc hba data structure
+ * @pIocbIn: pointer to the rspiocbq
+ * @pIocbOut: pointer to the cmdiocbq
+ * @wcqe: pointer to the complete wcqe
+ *
+ * This routine transfers the fields of a command iocbq to a response iocbq
+ * by copying all the IOCB fields from command iocbq and transferring the
+ * completion status information from the complete wcqe.
+ **/
+static void
+lpfc_sli4_iocb_param_transfer(struct lpfc_hba *phba,
+			      struct lpfc_iocbq *pIocbIn,
+			      struct lpfc_iocbq *pIocbOut,
+			      struct lpfc_wcqe_complete *wcqe)
+{
+	int numBdes, i;
+	unsigned long iflags;
+	uint32_t status, max_response;
+	struct lpfc_dmabuf *dmabuf;
+	struct ulp_bde64 *bpl, bde;
+	size_t offset = offsetof(struct lpfc_iocbq, iocb);
+
+	memcpy((char *)pIocbIn + offset, (char *)pIocbOut + offset,
+	       sizeof(struct lpfc_iocbq) - offset);
+	/* Map WCQE parameters into irspiocb parameters */
+	status = bf_get(lpfc_wcqe_c_status, wcqe);
+	pIocbIn->iocb.ulpStatus = (status & LPFC_IOCB_STATUS_MASK);
+	if (pIocbOut->cmd_flag & LPFC_IO_FCP)
+		if (pIocbIn->iocb.ulpStatus == IOSTAT_FCP_RSP_ERROR)
+			pIocbIn->iocb.un.fcpi.fcpi_parm =
+					pIocbOut->iocb.un.fcpi.fcpi_parm -
+					wcqe->total_data_placed;
+		else
+			pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
+	else {
+		pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
+		switch (pIocbOut->iocb.ulpCommand) {
+		case CMD_ELS_REQUEST64_CR:
+			dmabuf = (struct lpfc_dmabuf *)pIocbOut->context3;
+			bpl  = (struct ulp_bde64 *)dmabuf->virt;
+			bde.tus.w = le32_to_cpu(bpl[1].tus.w);
+			max_response = bde.tus.f.bdeSize;
+			break;
+		case CMD_GEN_REQUEST64_CR:
+			max_response = 0;
+			if (!pIocbOut->context3)
+				break;
+			numBdes = pIocbOut->iocb.un.genreq64.bdl.bdeSize/
+					sizeof(struct ulp_bde64);
+			dmabuf = (struct lpfc_dmabuf *)pIocbOut->context3;
+			bpl = (struct ulp_bde64 *)dmabuf->virt;
+			for (i = 0; i < numBdes; i++) {
+				bde.tus.w = le32_to_cpu(bpl[i].tus.w);
+				if (bde.tus.f.bdeFlags != BUFF_TYPE_BDE_64)
+					max_response += bde.tus.f.bdeSize;
+			}
+			break;
+		default:
+			max_response = wcqe->total_data_placed;
+			break;
+		}
+		if (max_response < wcqe->total_data_placed)
+			pIocbIn->iocb.un.genreq64.bdl.bdeSize = max_response;
+		else
+			pIocbIn->iocb.un.genreq64.bdl.bdeSize =
+				wcqe->total_data_placed;
+	}
+
+	/* Convert BG errors for completion status */
+	if (status == CQE_STATUS_DI_ERROR) {
+		pIocbIn->iocb.ulpStatus = IOSTAT_LOCAL_REJECT;
+
+		if (bf_get(lpfc_wcqe_c_bg_edir, wcqe))
+			pIocbIn->iocb.un.ulpWord[4] = IOERR_RX_DMA_FAILED;
+		else
+			pIocbIn->iocb.un.ulpWord[4] = IOERR_TX_DMA_FAILED;
+
+		pIocbIn->iocb.unsli3.sli3_bg.bgstat = 0;
+		if (bf_get(lpfc_wcqe_c_bg_ge, wcqe)) /* Guard Check failed */
+			pIocbIn->iocb.unsli3.sli3_bg.bgstat |=
+				BGS_GUARD_ERR_MASK;
+		if (bf_get(lpfc_wcqe_c_bg_ae, wcqe)) /* App Tag Check failed */
+			pIocbIn->iocb.unsli3.sli3_bg.bgstat |=
+				BGS_APPTAG_ERR_MASK;
+		if (bf_get(lpfc_wcqe_c_bg_re, wcqe)) /* Ref Tag Check failed */
+			pIocbIn->iocb.unsli3.sli3_bg.bgstat |=
+				BGS_REFTAG_ERR_MASK;
+
+		/* Check to see if there was any good data before the error */
+		if (bf_get(lpfc_wcqe_c_bg_tdpv, wcqe)) {
+			pIocbIn->iocb.unsli3.sli3_bg.bgstat |=
+				BGS_HI_WATER_MARK_PRESENT_MASK;
+			pIocbIn->iocb.unsli3.sli3_bg.bghm =
+				wcqe->total_data_placed;
+		}
+
+		/*
+		* Set ALL the error bits to indicate we don't know what
+		* type of error it is.
+		*/
+		if (!pIocbIn->iocb.unsli3.sli3_bg.bgstat)
+			pIocbIn->iocb.unsli3.sli3_bg.bgstat |=
+				(BGS_REFTAG_ERR_MASK | BGS_APPTAG_ERR_MASK |
+				BGS_GUARD_ERR_MASK);
+	}
+
+	/* Pick up HBA exchange busy condition */
+	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		pIocbIn->cmd_flag |= LPFC_EXCHANGE_BUSY;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+	}
+}
+
+/**
+ * lpfc_sli4_els_wcqe_to_rspiocbq - Get response iocbq from els wcqe
  * @phba: Pointer to HBA context object.
  * @irspiocbq: Pointer to work-queue completion queue entry.
  *
@@ -14143,8 +14244,8 @@ void lpfc_sli4_els_xri_abort_event_proc(
  * Return: Pointer to the receive IOCBQ, NULL otherwise.
  **/
 static struct lpfc_iocbq *
-lpfc_sli4_els_preprocess_rspiocbq(struct lpfc_hba *phba,
-				  struct lpfc_iocbq *irspiocbq)
+lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
+			       struct lpfc_iocbq *irspiocbq)
 {
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *cmdiocbq;
@@ -14156,13 +14257,11 @@ lpfc_sli4_els_preprocess_rspiocbq(struct
 		return NULL;
 
 	wcqe = &irspiocbq->cq_event.cqe.wcqe_cmpl;
-	spin_lock_irqsave(&pring->ring_lock, iflags);
 	pring->stats.iocb_event++;
 	/* Look up the ELS command IOCB and create pseudo response IOCB */
 	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
 	if (unlikely(!cmdiocbq)) {
-		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0386 ELS complete with no corresponding "
 				"cmdiocb: 0x%x 0x%x 0x%x 0x%x\n",
@@ -14172,18 +14271,13 @@ lpfc_sli4_els_preprocess_rspiocbq(struct
 		return NULL;
 	}
 
-	memcpy(&irspiocbq->wqe, &cmdiocbq->wqe, sizeof(union lpfc_wqe128));
-	memcpy(&irspiocbq->wcqe_cmpl, wcqe, sizeof(*wcqe));
-
+	spin_lock_irqsave(&pring->ring_lock, iflags);
 	/* Put the iocb back on the txcmplq */
 	lpfc_sli_ringtxcmpl_put(phba, pring, cmdiocbq);
 	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 
-	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
-		spin_lock_irqsave(&phba->hbalock, iflags);
-		cmdiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-	}
+	/* Fake the irspiocbq and copy necessary response information */
+	lpfc_sli4_iocb_param_transfer(phba, irspiocbq, cmdiocbq, wcqe);
 
 	return irspiocbq;
 }
@@ -15009,9 +15103,9 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc
 	/* Look up the FCP command IOCB and create pseudo response IOCB */
 	spin_lock_irqsave(&pring->ring_lock, iflags);
 	pring->stats.iocb_event++;
+	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
-	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	if (unlikely(!cmdiocbq)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0374 FCP complete with no corresponding "
@@ -18872,16 +18966,13 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vpor
 	ctiocb->sli4_lxritag = NO_XRI;
 	ctiocb->sli4_xritag = NO_XRI;
 
-	if (fctl & FC_FC_EX_CTX) {
+	if (fctl & FC_FC_EX_CTX)
 		/* Exchange responder sent the abort so we
 		 * own the oxid.
 		 */
-		ctiocb->abort_bls = LPFC_ABTS_UNSOL_RSP;
 		xri = oxid;
-	} else {
-		ctiocb->abort_bls = LPFC_ABTS_UNSOL_INT;
+	else
 		xri = rxid;
-	}
 	lxri = lpfc_sli4_xri_inrange(phba, xri);
 	if (lxri != NO_XRI)
 		lpfc_set_rrq_active(phba, ndlp, lxri,
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -76,8 +76,6 @@ struct lpfc_iocbq {
 	struct lpfc_wcqe_complete wcqe_cmpl;	/* WQE cmpl */
 
 	uint8_t num_bdes;
-	uint8_t abort_bls;	/* ABTS by initiator or responder */
-
 	uint8_t priority;	/* OAS priority */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
 	u32 cmd_flag;


