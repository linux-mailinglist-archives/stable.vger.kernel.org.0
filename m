Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31397615924
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiKBDFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiKBDFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:05:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B357523BDD
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:05:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF31616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FDAC433D6;
        Wed,  2 Nov 2022 03:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358303;
        bh=/7nkk5Vr+7rULjZ1kJYD9ZOO+s6cG5+AKByG4Avkjl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pKAr+4x7vLPVff0pLQ8MZfKB0g3/qgTSRsRcCl4MkiwQXAV7kgDHoFNPxjoKytqbh
         UnHWaEIsql5ZYE/RJHXJGJCroKFp/Oh8NesPXFt3v+rsJTlhzeZXvjItMix/J3zegC
         mtOBWEdpzh15I/wyFvWBLOhuviSSlUBm3Z7JBMxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Smart <jsmart2021@gmail.com>
Subject: [PATCH 5.15 050/132] Revert "scsi: lpfc: SLI path split: Refactor SCSI paths"
Date:   Wed,  2 Nov 2022 03:32:36 +0100
Message-Id: <20221102022100.931833212@linuxfoundation.org>
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

This reverts commit b4543dbea84c8b64566dd0d626d63f8cbe977f61.

LTS 5.15 pulled in several lpfc "SLI Path split" patches.  The Path
Split mods were a 14-patch set, which refactors the driver from
to split the sli-3 hw (now eol) from the sli-4 hw and use sli4
structures natively. The patches are highly inter-related.

Given only some of the patches were included, it created a situation
where FLOGI's fail, thus SLI Ports can't start communication.

Reverting this patch as its one of the partial Path Split patches
that was included.

NOTE: fixed a git revert error which caused a new line to be inserted:
  line 5755 of lpfc_scsi.c in lpfc_queuecommand
      +	     atomic_inc(&ndlp->cmd_pending);
  Removed the line

Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc.h      |    4 
 drivers/scsi/lpfc/lpfc_scsi.c |  376 +++++++++++++++++++++++-------------------
 drivers/scsi/lpfc/lpfc_sli.c  |    6 
 3 files changed, 211 insertions(+), 175 deletions(-)

--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -920,10 +920,6 @@ struct lpfc_hba {
 		(struct lpfc_vport *vport,
 		 struct lpfc_io_buf *lpfc_cmd,
 		 uint8_t tmo);
-	int (*lpfc_scsi_prep_task_mgmt_cmd)
-		(struct lpfc_vport *vport,
-		 struct lpfc_io_buf *lpfc_cmd,
-		 u64 lun, u8 task_mgmt_cmd);
 
 	/* IOCB interface function jump table entries */
 	int (*__lpfc_sli_issue_iocb)
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2942,58 +2942,154 @@ out:
  * -1 - Internal error (bad profile, ...etc)
  */
 static int
-lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
-		  struct lpfc_iocbq *pIocbOut)
+lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
+		       struct lpfc_wcqe_complete *wcqe)
 {
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
-	struct sli3_bg_fields *bgf;
 	int ret = 0;
-	struct lpfc_wcqe_complete *wcqe;
-	u32 status;
+	u32 status = bf_get(lpfc_wcqe_c_status, wcqe);
 	u32 bghm = 0;
 	u32 bgstat = 0;
 	u64 failing_sector = 0;
 
-	if (phba->sli_rev == LPFC_SLI_REV4) {
-		wcqe = &pIocbOut->wcqe_cmpl;
-		status = bf_get(lpfc_wcqe_c_status, wcqe);
+	if (status == CQE_STATUS_DI_ERROR) {
+		if (bf_get(lpfc_wcqe_c_bg_ge, wcqe)) /* Guard Check failed */
+			bgstat |= BGS_GUARD_ERR_MASK;
+		if (bf_get(lpfc_wcqe_c_bg_ae, wcqe)) /* AppTag Check failed */
+			bgstat |= BGS_APPTAG_ERR_MASK;
+		if (bf_get(lpfc_wcqe_c_bg_re, wcqe)) /* RefTag Check failed */
+			bgstat |= BGS_REFTAG_ERR_MASK;
+
+		/* Check to see if there was any good data before the error */
+		if (bf_get(lpfc_wcqe_c_bg_tdpv, wcqe)) {
+			bgstat |= BGS_HI_WATER_MARK_PRESENT_MASK;
+			bghm = wcqe->total_data_placed;
+		}
 
-		if (status == CQE_STATUS_DI_ERROR) {
-			/* Guard Check failed */
-			if (bf_get(lpfc_wcqe_c_bg_ge, wcqe))
-				bgstat |= BGS_GUARD_ERR_MASK;
-
-			/* AppTag Check failed */
-			if (bf_get(lpfc_wcqe_c_bg_ae, wcqe))
-				bgstat |= BGS_APPTAG_ERR_MASK;
-
-			/* RefTag Check failed */
-			if (bf_get(lpfc_wcqe_c_bg_re, wcqe))
-				bgstat |= BGS_REFTAG_ERR_MASK;
+		/*
+		 * Set ALL the error bits to indicate we don't know what
+		 * type of error it is.
+		 */
+		if (!bgstat)
+			bgstat |= (BGS_REFTAG_ERR_MASK | BGS_APPTAG_ERR_MASK |
+				BGS_GUARD_ERR_MASK);
+	}
 
-			/* Check to see if there was any good data before the
-			 * error
-			 */
-			if (bf_get(lpfc_wcqe_c_bg_tdpv, wcqe)) {
-				bgstat |= BGS_HI_WATER_MARK_PRESENT_MASK;
-				bghm = wcqe->total_data_placed;
-			}
+	if (lpfc_bgs_get_guard_err(bgstat)) {
+		ret = 1;
 
-			/*
-			 * Set ALL the error bits to indicate we don't know what
-			 * type of error it is.
-			 */
-			if (!bgstat)
-				bgstat |= (BGS_REFTAG_ERR_MASK |
-					   BGS_APPTAG_ERR_MASK |
-					   BGS_GUARD_ERR_MASK);
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
+		set_host_byte(cmd, DID_ABORT);
+		phba->bg_guard_err_cnt++;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9059 BLKGRD: Guard Tag error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
+	}
+
+	if (lpfc_bgs_get_reftag_err(bgstat)) {
+		ret = 1;
+
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
+		set_host_byte(cmd, DID_ABORT);
+
+		phba->bg_reftag_err_cnt++;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9060 BLKGRD: Ref Tag error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
+	}
+
+	if (lpfc_bgs_get_apptag_err(bgstat)) {
+		ret = 1;
+
+		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
+		set_host_byte(cmd, DID_ABORT);
+
+		phba->bg_apptag_err_cnt++;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9062 BLKGRD: App Tag error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
+	}
+
+	if (lpfc_bgs_get_hi_water_mark_present(bgstat)) {
+		/*
+		 * setup sense data descriptor 0 per SPC-4 as an information
+		 * field, and put the failing LBA in it.
+		 * This code assumes there was also a guard/app/ref tag error
+		 * indication.
+		 */
+		cmd->sense_buffer[7] = 0xc;   /* Additional sense length */
+		cmd->sense_buffer[8] = 0;     /* Information descriptor type */
+		cmd->sense_buffer[9] = 0xa;   /* Additional descriptor length */
+		cmd->sense_buffer[10] = 0x80; /* Validity bit */
+
+		/* bghm is a "on the wire" FC frame based count */
+		switch (scsi_get_prot_op(cmd)) {
+		case SCSI_PROT_READ_INSERT:
+		case SCSI_PROT_WRITE_STRIP:
+			bghm /= cmd->device->sector_size;
+			break;
+		case SCSI_PROT_READ_STRIP:
+		case SCSI_PROT_WRITE_INSERT:
+		case SCSI_PROT_READ_PASS:
+		case SCSI_PROT_WRITE_PASS:
+			bghm /= (cmd->device->sector_size +
+				sizeof(struct scsi_dif_tuple));
+			break;
 		}
 
-	} else {
-		bgf = &pIocbOut->iocb.unsli3.sli3_bg;
-		bghm = bgf->bghm;
-		bgstat = bgf->bgstat;
+		failing_sector = scsi_get_lba(cmd);
+		failing_sector += bghm;
+
+		/* Descriptor Information */
+		put_unaligned_be64(failing_sector, &cmd->sense_buffer[12]);
+	}
+
+	if (!ret) {
+		/* No error was reported - problem in FW? */
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
+				"9068 BLKGRD: Unknown error in cmd"
+				" 0x%x lba 0x%llx blk cnt 0x%x "
+				"bgstat=x%x bghm=x%x\n", cmd->cmnd[0],
+				(unsigned long long)scsi_get_lba(cmd),
+				scsi_logical_block_count(cmd), bgstat, bghm);
+
+		/* Calculate what type of error it was */
+		lpfc_calc_bg_err(phba, lpfc_cmd);
 	}
+	return ret;
+}
+
+/*
+ * This function checks for BlockGuard errors detected by
+ * the HBA.  In case of errors, the ASC/ASCQ fields in the
+ * sense buffer will be set accordingly, paired with
+ * ILLEGAL_REQUEST to signal to the kernel that the HBA
+ * detected corruption.
+ *
+ * Returns:
+ *  0 - No error found
+ *  1 - BlockGuard error found
+ * -1 - Internal error (bad profile, ...etc)
+ */
+static int
+lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
+		  struct lpfc_iocbq *pIocbOut)
+{
+	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
+	struct sli3_bg_fields *bgf = &pIocbOut->iocb.unsli3.sli3_bg;
+	int ret = 0;
+	uint32_t bghm = bgf->bghm;
+	uint32_t bgstat = bgf->bgstat;
+	uint64_t failing_sector = 0;
 
 	if (lpfc_bgs_get_invalid_prof(bgstat)) {
 		cmd->result = DID_ERROR << 16;
@@ -3021,6 +3117,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 
 	if (lpfc_bgs_get_guard_err(bgstat)) {
 		ret = 1;
+
 		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
 		set_host_byte(cmd, DID_ABORT);
 		phba->bg_guard_err_cnt++;
@@ -3034,8 +3131,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
 		ret = 1;
+
 		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
 		set_host_byte(cmd, DID_ABORT);
+
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9056 BLKGRD: Ref Tag error in cmd "
@@ -3047,8 +3146,10 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
 		ret = 1;
+
 		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
 		set_host_byte(cmd, DID_ABORT);
+
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
 				"9061 BLKGRD: App Tag error in cmd "
@@ -4093,6 +4194,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba
 	struct Scsi_Host *shost;
 	u32 logit = LOG_FCP;
 	u32 status, idx;
+	unsigned long iflags = 0;
 	u32 lat;
 	u8 wait_xb_clr = 0;
 
@@ -4107,16 +4209,30 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba
 	rdata = lpfc_cmd->rdata;
 	ndlp = rdata->pnode;
 
+	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
+		/* TOREMOVE - currently this flag is checked during
+		 * the release of lpfc_iocbq. Remove once we move
+		 * to lpfc_wqe_job construct.
+		 *
+		 * This needs to be done outside buf_lock
+		 */
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		lpfc_cmd->cur_iocbq.cmd_flag |= LPFC_EXCHANGE_BUSY;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+	}
+
+	/* Guard against abort handler being called at same time */
+	spin_lock(&lpfc_cmd->buf_lock);
+
 	/* Sanity check on return of outstanding command */
 	cmd = lpfc_cmd->pCmd;
 	if (!cmd) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "9042 I/O completion: Not an active IO\n");
+		spin_unlock(&lpfc_cmd->buf_lock);
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return;
 	}
-	/* Guard against abort handler being called at same time */
-	spin_lock(&lpfc_cmd->buf_lock);
 	idx = lpfc_cmd->cur_iocbq.hba_wqidx;
 	if (phba->sli4_hba.hdwq)
 		phba->sli4_hba.hdwq[idx].scsi_cstat.io_cmpls++;
@@ -4290,14 +4406,12 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba
 				 * This is a response for a BG enabled
 				 * cmd. Parse BG error
 				 */
-				lpfc_parse_bg_err(phba, lpfc_cmd, pwqeOut);
+				lpfc_sli4_parse_bg_err(phba, lpfc_cmd,
+						       wcqe);
 				break;
-			} else {
-				lpfc_printf_vlog(vport, KERN_WARNING,
-						 LOG_BG,
-						 "9040 non-zero BGSTAT "
-						 "on unprotected cmd\n");
 			}
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
+				 "9040 non-zero BGSTAT on unprotected cmd\n");
 		}
 		lpfc_printf_vlog(vport, KERN_WARNING, logit,
 				 "9036 Local Reject FCP cmd x%x failed"
@@ -4902,7 +5016,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 }
 
 /**
- * lpfc_scsi_prep_task_mgmt_cmd_s3 - Convert SLI3 scsi TM cmd to FCP info unit
+ * lpfc_scsi_prep_task_mgmt_cmd - Convert SLI3 scsi TM cmd to FCP info unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_io_buf data structure.
  * @lun: Logical unit number.
@@ -4916,9 +5030,10 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
  *   1 - Success
  **/
 static int
-lpfc_scsi_prep_task_mgmt_cmd_s3(struct lpfc_vport *vport,
-				struct lpfc_io_buf *lpfc_cmd,
-				u64 lun, u8 task_mgmt_cmd)
+lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
+			     struct lpfc_io_buf *lpfc_cmd,
+			     uint64_t lun,
+			     uint8_t task_mgmt_cmd)
 {
 	struct lpfc_iocbq *piocbq;
 	IOCB_t *piocb;
@@ -4939,10 +5054,15 @@ lpfc_scsi_prep_task_mgmt_cmd_s3(struct l
 	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
 	int_to_scsilun(lun, &fcp_cmnd->fcp_lun);
 	fcp_cmnd->fcpCntl2 = task_mgmt_cmd;
-	if (!(vport->phba->sli3_options & LPFC_SLI3_BG_ENABLED))
+	if (vport->phba->sli_rev == 3 &&
+	    !(vport->phba->sli3_options & LPFC_SLI3_BG_ENABLED))
 		lpfc_fcpcmd_to_iocb(piocb->unsli3.fcp_ext.icd, fcp_cmnd);
 	piocb->ulpCommand = CMD_FCP_ICMND64_CR;
 	piocb->ulpContext = ndlp->nlp_rpi;
+	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
+		piocb->ulpContext =
+		  vport->phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
+	}
 	piocb->ulpFCP2Rcvy = (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) ? 1 : 0;
 	piocb->ulpClass = (ndlp->nlp_fcp_info & 0x0f);
 	piocb->ulpPU = 0;
@@ -4958,79 +5078,8 @@ lpfc_scsi_prep_task_mgmt_cmd_s3(struct l
 	} else
 		piocb->ulpTimeout = lpfc_cmd->timeout;
 
-	return 1;
-}
-
-/**
- * lpfc_scsi_prep_task_mgmt_cmd_s4 - Convert SLI4 scsi TM cmd to FCP info unit
- * @vport: The virtual port for which this call is being executed.
- * @lpfc_cmd: Pointer to lpfc_io_buf data structure.
- * @lun: Logical unit number.
- * @task_mgmt_cmd: SCSI task management command.
- *
- * This routine creates FCP information unit corresponding to @task_mgmt_cmd
- * for device with SLI-4 interface spec.
- *
- * Return codes:
- *   0 - Error
- *   1 - Success
- **/
-static int
-lpfc_scsi_prep_task_mgmt_cmd_s4(struct lpfc_vport *vport,
-				struct lpfc_io_buf *lpfc_cmd,
-				u64 lun, u8 task_mgmt_cmd)
-{
-	struct lpfc_iocbq *pwqeq = &lpfc_cmd->cur_iocbq;
-	union lpfc_wqe128 *wqe = &pwqeq->wqe;
-	struct fcp_cmnd *fcp_cmnd;
-	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
-	struct lpfc_nodelist *ndlp = rdata->pnode;
-
-	if (!ndlp || ndlp->nlp_state != NLP_STE_MAPPED_NODE)
-		return 0;
-
-	pwqeq->vport = vport;
-	/* Initialize 64 bytes only */
-	memset(wqe, 0, sizeof(union lpfc_wqe128));
-
-	/* From the icmnd template, initialize words 4 - 11 */
-	memcpy(&wqe->words[4], &lpfc_icmnd_cmd_template.words[4],
-	       sizeof(uint32_t) * 8);
-
-	fcp_cmnd = lpfc_cmd->fcp_cmnd;
-	/* Clear out any old data in the FCP command area */
-	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
-	int_to_scsilun(lun, &fcp_cmnd->fcp_lun);
-	fcp_cmnd->fcpCntl3 = 0;
-	fcp_cmnd->fcpCntl2 = task_mgmt_cmd;
-
-	bf_set(payload_offset_len, &wqe->fcp_icmd,
-	       sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp));
-	bf_set(cmd_buff_len, &wqe->fcp_icmd, 0);
-	bf_set(wqe_ctxt_tag, &wqe->generic.wqe_com,  /* ulpContext */
-	       vport->phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
-	bf_set(wqe_erp, &wqe->fcp_icmd.wqe_com,
-	       ((ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) ? 1 : 0));
-	bf_set(wqe_class, &wqe->fcp_icmd.wqe_com,
-	       (ndlp->nlp_fcp_info & 0x0f));
-
-	/* ulpTimeout is only one byte */
-	if (lpfc_cmd->timeout > 0xff) {
-		/*
-		 * Do not timeout the command at the firmware level.
-		 * The driver will provide the timeout mechanism.
-		 */
-		bf_set(wqe_tmo, &wqe->fcp_icmd.wqe_com, 0);
-	} else {
-		bf_set(wqe_tmo, &wqe->fcp_icmd.wqe_com, lpfc_cmd->timeout);
-	}
-
-	lpfc_prep_embed_io(vport->phba, lpfc_cmd);
-	bf_set(wqe_xri_tag, &wqe->generic.wqe_com, pwqeq->sli4_xritag);
-	wqe->generic.wqe_com.abort_tag = pwqeq->iotag;
-	bf_set(wqe_reqtag, &wqe->generic.wqe_com, pwqeq->iotag);
-
-	lpfc_sli4_set_rsp_sgl_last(vport->phba, lpfc_cmd);
+	if (vport->phba->sli_rev == LPFC_SLI_REV4)
+		lpfc_sli4_set_rsp_sgl_last(vport->phba, lpfc_cmd);
 
 	return 1;
 }
@@ -5057,8 +5106,6 @@ lpfc_scsi_api_table_setup(struct lpfc_hb
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s3;
 		phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf_s3;
 		phba->lpfc_scsi_prep_cmnd_buf = lpfc_scsi_prep_cmnd_buf_s3;
-		phba->lpfc_scsi_prep_task_mgmt_cmd =
-					lpfc_scsi_prep_task_mgmt_cmd_s3;
 		break;
 	case LPFC_PCI_DEV_OC:
 		phba->lpfc_scsi_prep_dma_buf = lpfc_scsi_prep_dma_buf_s4;
@@ -5066,8 +5113,6 @@ lpfc_scsi_api_table_setup(struct lpfc_hb
 		phba->lpfc_release_scsi_buf = lpfc_release_scsi_buf_s4;
 		phba->lpfc_get_scsi_buf = lpfc_get_scsi_buf_s4;
 		phba->lpfc_scsi_prep_cmnd_buf = lpfc_scsi_prep_cmnd_buf_s4;
-		phba->lpfc_scsi_prep_task_mgmt_cmd =
-					lpfc_scsi_prep_task_mgmt_cmd_s4;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
@@ -5546,7 +5591,6 @@ lpfc_queuecommand(struct Scsi_Host *shos
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_iocbq *cur_iocbq = NULL;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_io_buf *lpfc_cmd;
@@ -5640,7 +5684,6 @@ lpfc_queuecommand(struct Scsi_Host *shos
 	}
 	lpfc_cmd->rx_cmd_start = start;
 
-	cur_iocbq = &lpfc_cmd->cur_iocbq;
 	/*
 	 * Store the midlayer's command structure for the completion phase
 	 * and complete the command initialization.
@@ -5648,7 +5691,7 @@ lpfc_queuecommand(struct Scsi_Host *shos
 	lpfc_cmd->pCmd  = cmnd;
 	lpfc_cmd->rdata = rdata;
 	lpfc_cmd->ndlp = ndlp;
-	cur_iocbq->cmd_cmpl = NULL;
+	lpfc_cmd->cur_iocbq.cmd_cmpl = NULL;
 	cmnd->host_scribble = (unsigned char *)lpfc_cmd;
 
 	err = lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
@@ -5690,6 +5733,7 @@ lpfc_queuecommand(struct Scsi_Host *shos
 		goto out_host_busy_free_buf;
 	}
 
+
 	/* check the necessary and sufficient condition to support VMID */
 	if (lpfc_is_vmid_enabled(phba) &&
 	    (ndlp->vmid_support ||
@@ -5702,9 +5746,9 @@ lpfc_queuecommand(struct Scsi_Host *shos
 		if (uuid) {
 			err = lpfc_vmid_get_appid(vport, uuid, cmnd,
 				(union lpfc_vmid_io_tag *)
-					&cur_iocbq->vmid_tag);
+					&lpfc_cmd->cur_iocbq.vmid_tag);
 			if (!err)
-				cur_iocbq->cmd_flag |= LPFC_IO_VMID;
+				lpfc_cmd->cur_iocbq.cmd_flag |= LPFC_IO_VMID;
 		}
 	}
 
@@ -5713,7 +5757,8 @@ lpfc_queuecommand(struct Scsi_Host *shos
 		this_cpu_inc(phba->sli4_hba.c_stat->xmt_io);
 #endif
 	/* Issue I/O to adapter */
-	err = lpfc_sli_issue_fcp_io(phba, LPFC_FCP_RING, cur_iocbq,
+	err = lpfc_sli_issue_fcp_io(phba, LPFC_FCP_RING,
+				    &lpfc_cmd->cur_iocbq,
 				    SLI_IOCB_RET_IOCB);
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (start) {
@@ -5726,25 +5771,25 @@ lpfc_queuecommand(struct Scsi_Host *shos
 #endif
 	if (err) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
-				 "3376 FCP could not issue iocb err %x "
-				 "FCP cmd x%x <%d/%llu> "
-				 "sid: x%x did: x%x oxid: x%x "
-				 "Data: x%x x%x x%x x%x\n",
-				 err, cmnd->cmnd[0],
-				 cmnd->device ? cmnd->device->id : 0xffff,
-				 cmnd->device ? cmnd->device->lun : (u64)-1,
-				 vport->fc_myDID, ndlp->nlp_DID,
-				 phba->sli_rev == LPFC_SLI_REV4 ?
-				 cur_iocbq->sli4_xritag : 0xffff,
-				 phba->sli_rev == LPFC_SLI_REV4 ?
-				 phba->sli4_hba.rpi_ids[ndlp->nlp_rpi] :
-				 cur_iocbq->iocb.ulpContext,
-				 cur_iocbq->iotag,
-				 phba->sli_rev == LPFC_SLI_REV4 ?
-				 bf_get(wqe_tmo,
-					&cur_iocbq->wqe.generic.wqe_com) :
-				 cur_iocbq->iocb.ulpTimeout,
-				 (uint32_t)(scsi_cmd_to_rq(cmnd)->timeout / 1000));
+				   "3376 FCP could not issue IOCB err %x "
+				   "FCP cmd x%x <%d/%llu> "
+				   "sid: x%x did: x%x oxid: x%x "
+				   "Data: x%x x%x x%x x%x\n",
+				   err, cmnd->cmnd[0],
+				   cmnd->device ? cmnd->device->id : 0xffff,
+				   cmnd->device ? cmnd->device->lun : (u64)-1,
+				   vport->fc_myDID, ndlp->nlp_DID,
+				   phba->sli_rev == LPFC_SLI_REV4 ?
+				   lpfc_cmd->cur_iocbq.sli4_xritag : 0xffff,
+				   phba->sli_rev == LPFC_SLI_REV4 ?
+				   phba->sli4_hba.rpi_ids[ndlp->nlp_rpi] :
+				   lpfc_cmd->cur_iocbq.iocb.ulpContext,
+				   lpfc_cmd->cur_iocbq.iotag,
+				   phba->sli_rev == LPFC_SLI_REV4 ?
+				   bf_get(wqe_tmo,
+				   &lpfc_cmd->cur_iocbq.wqe.generic.wqe_com) :
+				   lpfc_cmd->cur_iocbq.iocb.ulpTimeout,
+				   (uint32_t)(scsi_cmd_to_rq(cmnd)->timeout / 1000));
 
 		goto out_host_busy_free_buf;
 	}
@@ -6121,7 +6166,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 		return FAILED;
 	pnode = rdata->pnode;
 
-	lpfc_cmd = lpfc_get_scsi_buf(phba, rdata->pnode, NULL);
+	lpfc_cmd = lpfc_get_scsi_buf(phba, pnode, NULL);
 	if (lpfc_cmd == NULL)
 		return FAILED;
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
@@ -6129,8 +6174,8 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 	lpfc_cmd->pCmd = cmnd;
 	lpfc_cmd->ndlp = pnode;
 
-	status = phba->lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
-						    task_mgmt_cmd);
+	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
+					   task_mgmt_cmd);
 	if (!status) {
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return FAILED;
@@ -6143,7 +6188,6 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 		return FAILED;
 	}
 	iocbq->cmd_cmpl = lpfc_tskmgmt_def_cmpl;
-	iocbq->vport = vport;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 			 "0702 Issue %s to TGT %d LUN %llu "
@@ -6155,28 +6199,26 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);
 	if ((status != IOCB_SUCCESS) ||
-	    (get_job_ulpstatus(phba, iocbqrsp) != IOSTAT_SUCCESS)) {
+	    (iocbqrsp->iocb.ulpStatus != IOSTAT_SUCCESS)) {
 		if (status != IOCB_SUCCESS ||
-		    get_job_ulpstatus(phba, iocbqrsp) != IOSTAT_FCP_RSP_ERROR)
+		    iocbqrsp->iocb.ulpStatus != IOSTAT_FCP_RSP_ERROR)
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 					 "0727 TMF %s to TGT %d LUN %llu "
 					 "failed (%d, %d) cmd_flag x%x\n",
 					 lpfc_taskmgmt_name(task_mgmt_cmd),
 					 tgt_id, lun_id,
-					 get_job_ulpstatus(phba, iocbqrsp),
-					 get_job_word4(phba, iocbqrsp),
+					 iocbqrsp->iocb.ulpStatus,
+					 iocbqrsp->iocb.un.ulpWord[4],
 					 iocbq->cmd_flag);
 		/* if ulpStatus != IOCB_SUCCESS, then status == IOCB_SUCCESS */
 		if (status == IOCB_SUCCESS) {
-			if (get_job_ulpstatus(phba, iocbqrsp) ==
-			    IOSTAT_FCP_RSP_ERROR)
+			if (iocbqrsp->iocb.ulpStatus == IOSTAT_FCP_RSP_ERROR)
 				/* Something in the FCP_RSP was invalid.
 				 * Check conditions */
 				ret = lpfc_check_fcp_rsp(vport, lpfc_cmd);
 			else
 				ret = FAILED;
-		} else if ((status == IOCB_TIMEDOUT) ||
-			   (status == IOCB_ABORTED)) {
+		} else if (status == IOCB_TIMEDOUT) {
 			ret = TIMEOUT_ERROR;
 		} else {
 			ret = FAILED;
@@ -6186,7 +6228,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 
 	lpfc_sli_release_iocbq(phba, iocbqrsp);
 
-	if (status != IOCB_TIMEDOUT)
+	if (ret != TIMEOUT_ERROR)
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 
 	return ret;
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12970,7 +12970,6 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba
 	wait_queue_head_t *pdone_q;
 	unsigned long iflags;
 	struct lpfc_io_buf *lpfc_cmd;
-	size_t offset = offsetof(struct lpfc_iocbq, wqe);
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	if (cmdiocbq->cmd_flag & LPFC_IO_WAKE_TMO) {
@@ -12991,11 +12990,10 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba
 		return;
 	}
 
-	/* Copy the contents of the local rspiocb into the caller's buffer. */
 	cmdiocbq->cmd_flag |= LPFC_IO_WAKE;
 	if (cmdiocbq->context2 && rspiocbq)
-		memcpy((char *)cmdiocbq->context2 + offset,
-		       (char *)rspiocbq + offset, sizeof(*rspiocbq) - offset);
+		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
+		       &rspiocbq->iocb, sizeof(IOCB_t));
 
 	/* Set the exchange busy flag for task management commands */
 	if ((cmdiocbq->cmd_flag & LPFC_IO_FCP) &&


