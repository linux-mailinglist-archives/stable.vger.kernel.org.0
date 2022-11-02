Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D76C615921
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiKBDFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiKBDEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:04:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105DA23E8F
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:04:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4C99B82062
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9446FC433D6;
        Wed,  2 Nov 2022 03:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358285;
        bh=bwik8flVS7Jkmnh5XLJwUDKzJZJ3Uud5Y9XufVx8awg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLL6SyFjVXniK5kcknpZC4bUiyU5yUX1r7acNyg7mw/pIjUHmXZfuE9V+aSjGf5Wd
         KoOuJfONDHUA68snSYcsSx5eM7cgbYP3mibl8Qsa4dIp5wAGePgR5/Bd9iUQzleyIO
         508mO6/2zKp9oLwrmPWsgzY4uuA8xRflRSPjd4gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Smart <jsmart2021@gmail.com>
Subject: [PATCH 5.15 047/132] Revert "scsi: lpfc: Resolve some cleanup issues following SLI path refactoring"
Date:   Wed,  2 Nov 2022 03:32:33 +0100
Message-Id: <20221102022100.859738002@linuxfoundation.org>
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

This reverts commit 17bf429b913b9e7f8d2353782e24ed3a491bb2d8.

LTS 5.15 pulled in several lpfc "SLI Path split" patches.  The Path
Split mods were a 14-patch set, which refactors the driver from
to split the sli-3 hw (now eol) from the sli-4 hw and use sli4
structures natively. The patches are highly inter-related.

Given only some of the patches were included, it created a situation
where FLOGI's fail, thus SLI Ports can't start communication.

Reverting this patch as its a fix specific to the Path Split patches,
which were partially included and now being pulled from 5.15.

Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c  |   25 +++++++++++++------------
 2 files changed, 14 insertions(+), 13 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11968,7 +11968,7 @@ lpfc_sli_enable_msi(struct lpfc_hba *phb
 	rc = pci_enable_msi(phba->pcidev);
 	if (!rc)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0012 PCI enable MSI mode success.\n");
+				"0462 PCI enable MSI mode success.\n");
 	else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0471 PCI enable MSI mode failed (%d)\n", rc);
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1939,7 +1939,7 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba
 	sync_buf = __lpfc_sli_get_iocbq(phba);
 	if (!sync_buf) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT,
-				"6244 No available WQEs for CMF_SYNC_WQE\n");
+				"6213 No available WQEs for CMF_SYNC_WQE\n");
 		ret_val = ENOMEM;
 		goto out_unlock;
 	}
@@ -3739,7 +3739,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 						set_job_ulpword4(cmdiocbp,
 								 IOERR_ABORT_REQUESTED);
 						/*
-						 * For SLI4, irspiocb contains
+						 * For SLI4, irsiocb contains
 						 * NO_XRI in sli_xritag, it
 						 * shall not affect releasing
 						 * sgl (xri) process.
@@ -3757,7 +3757,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 					}
 				}
 			}
-			cmdiocbp->cmd_cmpl(phba, cmdiocbp, saveq);
+			(cmdiocbp->cmd_cmpl) (phba, cmdiocbp, saveq);
 		} else
 			lpfc_sli_release_iocbq(phba, cmdiocbp);
 	} else {
@@ -3997,7 +3997,8 @@ lpfc_sli_handle_fast_ring_event(struct l
 				cmdiocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
 			if (cmdiocbq->cmd_cmpl) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				cmdiocbq->cmd_cmpl(phba, cmdiocbq, &rspiocbq);
+				(cmdiocbq->cmd_cmpl)(phba, cmdiocbq,
+						      &rspiocbq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			}
 			break;
@@ -10937,7 +10938,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
  * @flag: Flag indicating if this command can be put into txq.
  *
  * __lpfc_sli_issue_fcp_io_s3 is wrapper function to invoke lockless func to
- * send  an iocb command to an HBA with SLI-3 interface spec.
+ * send  an iocb command to an HBA with SLI-4 interface spec.
  *
  * This function takes the hbalock before invoking the lockless version.
  * The function will return success after it successfully submit the wqe to
@@ -12990,7 +12991,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba
 		cmdiocbq->cmd_cmpl = cmdiocbq->wait_cmd_cmpl;
 		cmdiocbq->wait_cmd_cmpl = NULL;
 		if (cmdiocbq->cmd_cmpl)
-			cmdiocbq->cmd_cmpl(phba, cmdiocbq, NULL);
+			(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, NULL);
 		else
 			lpfc_sli_release_iocbq(phba, cmdiocbq);
 		return;
@@ -13004,9 +13005,9 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba
 
 	/* Set the exchange busy flag for task management commands */
 	if ((cmdiocbq->cmd_flag & LPFC_IO_FCP) &&
-	    !(cmdiocbq->cmd_flag & LPFC_IO_LIBDFC)) {
+		!(cmdiocbq->cmd_flag & LPFC_IO_LIBDFC)) {
 		lpfc_cmd = container_of(cmdiocbq, struct lpfc_io_buf,
-					cur_iocbq);
+			cur_iocbq);
 		if (rspiocbq && (rspiocbq->cmd_flag & LPFC_EXCHANGE_BUSY))
 			lpfc_cmd->flags |= LPFC_SBUF_XBUSY;
 		else
@@ -14144,7 +14145,7 @@ void lpfc_sli4_els_xri_abort_event_proc(
  * @irspiocbq: Pointer to work-queue completion queue entry.
  *
  * This routine handles an ELS work-queue completion event and construct
- * a pseudo response ELS IOCBQ from the SLI4 ELS WCQE for the common
+ * a pseudo response ELS IODBQ from the SLI4 ELS WCQE for the common
  * discovery engine to handle.
  *
  * Return: Pointer to the receive IOCBQ, NULL otherwise.
@@ -14188,7 +14189,7 @@ lpfc_sli4_els_preprocess_rspiocbq(struct
 
 	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
 		spin_lock_irqsave(&phba->hbalock, iflags);
-		irspiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
+		cmdiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 
@@ -15047,7 +15048,7 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc
 		/* Pass the cmd_iocb and the wcqe to the upper layer */
 		memcpy(&cmdiocbq->wcqe_cmpl, wcqe,
 		       sizeof(struct lpfc_wcqe_complete));
-		cmdiocbq->cmd_cmpl(phba, cmdiocbq, cmdiocbq);
+		(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, cmdiocbq);
 	} else {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0375 FCP cmdiocb not callback function "
@@ -19211,7 +19212,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vp
 
 	/* Free iocb created in lpfc_prep_seq */
 	list_for_each_entry_safe(curr_iocb, next_iocb,
-				 &iocbq->list, list) {
+		&iocbq->list, list) {
 		list_del_init(&curr_iocb->list);
 		lpfc_sli_release_iocbq(phba, curr_iocb);
 	}


