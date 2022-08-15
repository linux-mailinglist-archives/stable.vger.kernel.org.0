Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3BC593D7D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiHOUGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346165AbiHOUBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:01:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70325FC;
        Mon, 15 Aug 2022 11:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE754B81057;
        Mon, 15 Aug 2022 18:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3F8C433D6;
        Mon, 15 Aug 2022 18:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589629;
        bh=831V3Yq52zNLvCLhnmdB7nVvxEFk2hDomNDpBbMwZIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DG2va3syTcOWbNXosh7UlnmIXtSIqfA/AxR0WeW1BjND/B0R4LsquAkdel1Wd/jkX
         4h7e5sAFlw4WcG3Bax+YIJhHS85LHk3/hKj6cFhR+uffy/xJVwoH/PqLXgX9ZeIkWt
         0qc7ZYHeLalA44CTLlKLB9Gx9bK+XZ3ii/+YR52Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 779/779] scsi: lpfc: Resolve some cleanup issues following SLI path refactoring
Date:   Mon, 15 Aug 2022 20:07:03 +0200
Message-Id: <20220815180410.658725498@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit e27f05147bff21408c1b8410ad8e90cd286e7952 upstream.

Following refactoring and consolidation in SLI processing, fix up some
minor issues related to SLI path:

 - Correct the setting of LPFC_EXCHANGE_BUSY flag in response IOCB.

 - Fix some typographical errors.

 - Fix duplicate log messages.

Link: https://lore.kernel.org/r/20220603174329.63777-4-jsmart2021@gmail.com
Fixes: 1b64aa9eae28 ("scsi: lpfc: SLI path split: Refactor fast and slow paths to native SLI4")
Cc: <stable@vger.kernel.org> # v5.18
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c  |   25 ++++++++++++-------------
 2 files changed, 13 insertions(+), 14 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11964,7 +11964,7 @@ lpfc_sli_enable_msi(struct lpfc_hba *phb
 	rc = pci_enable_msi(phba->pcidev);
 	if (!rc)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0462 PCI enable MSI mode success.\n");
+				"0012 PCI enable MSI mode success.\n");
 	else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0471 PCI enable MSI mode failed (%d)\n", rc);
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1939,7 +1939,7 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba
 	sync_buf = __lpfc_sli_get_iocbq(phba);
 	if (!sync_buf) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT,
-				"6213 No available WQEs for CMF_SYNC_WQE\n");
+				"6244 No available WQEs for CMF_SYNC_WQE\n");
 		ret_val = ENOMEM;
 		goto out_unlock;
 	}
@@ -3737,7 +3737,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 						set_job_ulpword4(cmdiocbp,
 								 IOERR_ABORT_REQUESTED);
 						/*
-						 * For SLI4, irsiocb contains
+						 * For SLI4, irspiocb contains
 						 * NO_XRI in sli_xritag, it
 						 * shall not affect releasing
 						 * sgl (xri) process.
@@ -3755,7 +3755,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 					}
 				}
 			}
-			(cmdiocbp->cmd_cmpl) (phba, cmdiocbp, saveq);
+			cmdiocbp->cmd_cmpl(phba, cmdiocbp, saveq);
 		} else
 			lpfc_sli_release_iocbq(phba, cmdiocbp);
 	} else {
@@ -3995,8 +3995,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 				cmdiocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
 			if (cmdiocbq->cmd_cmpl) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				(cmdiocbq->cmd_cmpl)(phba, cmdiocbq,
-						      &rspiocbq);
+				cmdiocbq->cmd_cmpl(phba, cmdiocbq, &rspiocbq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			}
 			break;
@@ -10936,7 +10935,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
  * @flag: Flag indicating if this command can be put into txq.
  *
  * __lpfc_sli_issue_fcp_io_s3 is wrapper function to invoke lockless func to
- * send  an iocb command to an HBA with SLI-4 interface spec.
+ * send  an iocb command to an HBA with SLI-3 interface spec.
  *
  * This function takes the hbalock before invoking the lockless version.
  * The function will return success after it successfully submit the wqe to
@@ -12989,7 +12988,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba
 		cmdiocbq->cmd_cmpl = cmdiocbq->wait_cmd_cmpl;
 		cmdiocbq->wait_cmd_cmpl = NULL;
 		if (cmdiocbq->cmd_cmpl)
-			(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, NULL);
+			cmdiocbq->cmd_cmpl(phba, cmdiocbq, NULL);
 		else
 			lpfc_sli_release_iocbq(phba, cmdiocbq);
 		return;
@@ -13003,9 +13002,9 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba
 
 	/* Set the exchange busy flag for task management commands */
 	if ((cmdiocbq->cmd_flag & LPFC_IO_FCP) &&
-		!(cmdiocbq->cmd_flag & LPFC_IO_LIBDFC)) {
+	    !(cmdiocbq->cmd_flag & LPFC_IO_LIBDFC)) {
 		lpfc_cmd = container_of(cmdiocbq, struct lpfc_io_buf,
-			cur_iocbq);
+					cur_iocbq);
 		if (rspiocbq && (rspiocbq->cmd_flag & LPFC_EXCHANGE_BUSY))
 			lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
 		else
@@ -14143,7 +14142,7 @@ void lpfc_sli4_els_xri_abort_event_proc(
  * @irspiocbq: Pointer to work-queue completion queue entry.
  *
  * This routine handles an ELS work-queue completion event and construct
- * a pseudo response ELS IODBQ from the SLI4 ELS WCQE for the common
+ * a pseudo response ELS IOCBQ from the SLI4 ELS WCQE for the common
  * discovery engine to handle.
  *
  * Return: Pointer to the receive IOCBQ, NULL otherwise.
@@ -14187,7 +14186,7 @@ lpfc_sli4_els_preprocess_rspiocbq(struct
 
 	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
 		spin_lock_irqsave(&phba->hbalock, iflags);
-		cmdiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
+		irspiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 
@@ -15046,7 +15045,7 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc
 		/* Pass the cmd_iocb and the wcqe to the upper layer */
 		memcpy(&cmdiocbq->wcqe_cmpl, wcqe,
 		       sizeof(struct lpfc_wcqe_complete));
-		(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, cmdiocbq);
+		cmdiocbq->cmd_cmpl(phba, cmdiocbq, cmdiocbq);
 	} else {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0375 FCP cmdiocb not callback function "
@@ -19210,7 +19209,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vp
 
 	/* Free iocb created in lpfc_prep_seq */
 	list_for_each_entry_safe(curr_iocb, next_iocb,
-		&iocbq->list, list) {
+				 &iocbq->list, list) {
 		list_del_init(&curr_iocb->list);
 		lpfc_sli_release_iocbq(phba, curr_iocb);
 	}


