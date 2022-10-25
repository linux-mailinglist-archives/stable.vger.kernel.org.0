Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A19760D792
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiJYW7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiJYW65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:57 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9ADCA899
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:56 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id mi9so788695qvb.8
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yfSqpifkDgyF3BORdm77AjMcPpru7LLERVPnxK3/TO8=;
        b=J8o6stIRVNcW4I57iM6kstBFdypu3Dqn5YplHysWux0aJNXI5waxXUcOOoyR6+zOG5
         4n8M5ofx9l2YorwYpt2XUxYdAnuqCcoEq/jRDM8NN5LbojluNv3Qf1aaQYcTiQ2ITcGK
         gwP0S5/eZF2hCggFPrOka+le9gMmMxTT5hzPrhk8cTmHSzczvnotDsbblTjCSlKslCxB
         mTF/YZDiMKThzPK+h5PGskV6AXpblQXCQtt0TDbP4t6G9880eFx0Q/n0Kqbtzz+CdvcV
         JkxpAuxn8uswaS1l7hIWnHJ4LbI/+XxYcovtsvr2scfunmZbmxh8o1J/kuJ2U5vcx8PA
         yWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yfSqpifkDgyF3BORdm77AjMcPpru7LLERVPnxK3/TO8=;
        b=uIwtZ6fwFuB8RVg736J7ly3Sj0Xs6bUGJAoiCXJb615wICSYah7exv/wd5LaAEV5/G
         8XyehDgkjQNjsRmzoNx6LAogUftgAssUM/7ftFUaqI1jqAFT4HpY++/HBRZ2tGZwZRjH
         HA1lj4l/Ld/V7yHvJhtQWeyX+G9tq0Jb7H2bwVyxABIVnYDEnhtGhOKv7fkq6TyZvz/v
         kF0UeWydxENbWFN3jph6QEs20K4NLYgUb1clNPgXFQQzm6dPK/+IUrzjnbeGYE3uPi3t
         0rqkTbt1exwcgjpdop/Mxt9XpZnp6c2XngnfXnFPMv/o5Xr7JbCI/GIalMcrEgU+kZA2
         dHUQ==
X-Gm-Message-State: ACrzQf1HMpTjxYDEhm/4JKu0MFuNhs0PfawjRJhSPaUhGflSWtJPuqRd
        r90NqiTNDKgHhw29dd6GZg7le2M6eCE=
X-Google-Smtp-Source: AMsMyM4RFFMPaersXGgdBMgE2WgblfZ4HB3Y2lS0rPGwWwpMQCwj+IqWzDAWjlNzT4E6WHs2hnghlg==
X-Received: by 2002:a0c:ab55:0:b0:4b9:4dd5:64ab with SMTP id i21-20020a0cab55000000b004b94dd564abmr24631923qvb.106.1666738735980;
        Tue, 25 Oct 2022 15:58:55 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:55 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 33/33] scsi: lpfc: Resolve some cleanup issues following SLI path refactoring
Date:   Tue, 25 Oct 2022 15:57:39 -0700
Message-Id: <20221025225739.85182-34-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221025225739.85182-1-jsmart2021@gmail.com>
References: <20221025225739.85182-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/scsi/lpfc/lpfc_init.c |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 25 ++++++++++++-------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4be734b0da0f..33e33fff8986 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11967,7 +11967,7 @@ lpfc_sli_enable_msi(struct lpfc_hba *phba)
 	rc = pci_enable_msi(phba->pcidev);
 	if (!rc)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0462 PCI enable MSI mode success.\n");
+				"0012 PCI enable MSI mode success.\n");
 	else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0471 PCI enable MSI mode failed (%d)\n", rc);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c68aa7d48d22..f3798aff55a9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1930,7 +1930,7 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	sync_buf = __lpfc_sli_get_iocbq(phba);
 	if (!sync_buf) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT,
-				"6213 No available WQEs for CMF_SYNC_WQE\n");
+				"6244 No available WQEs for CMF_SYNC_WQE\n");
 		ret_val = ENOMEM;
 		goto out_unlock;
 	}
@@ -3812,7 +3812,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 						set_job_ulpword4(cmdiocbp,
 								 IOERR_ABORT_REQUESTED);
 						/*
-						 * For SLI4, irsiocb contains
+						 * For SLI4, irspiocb contains
 						 * NO_XRI in sli_xritag, it
 						 * shall not affect releasing
 						 * sgl (xri) process.
@@ -3830,7 +3830,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 					}
 				}
 			}
-			(cmdiocbp->cmd_cmpl) (phba, cmdiocbp, saveq);
+			cmdiocbp->cmd_cmpl(phba, cmdiocbp, saveq);
 		} else
 			lpfc_sli_release_iocbq(phba, cmdiocbp);
 	} else {
@@ -4070,8 +4070,7 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				cmdiocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
 			if (cmdiocbq->cmd_cmpl) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				(cmdiocbq->cmd_cmpl)(phba, cmdiocbq,
-						      &rspiocbq);
+				cmdiocbq->cmd_cmpl(phba, cmdiocbq, &rspiocbq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			}
 			break;
@@ -10302,7 +10301,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
  * @flag: Flag indicating if this command can be put into txq.
  *
  * __lpfc_sli_issue_fcp_io_s3 is wrapper function to invoke lockless func to
- * send  an iocb command to an HBA with SLI-4 interface spec.
+ * send  an iocb command to an HBA with SLI-3 interface spec.
  *
  * This function takes the hbalock before invoking the lockless version.
  * The function will return success after it successfully submit the wqe to
@@ -12716,7 +12715,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 		cmdiocbq->cmd_cmpl = cmdiocbq->wait_cmd_cmpl;
 		cmdiocbq->wait_cmd_cmpl = NULL;
 		if (cmdiocbq->cmd_cmpl)
-			(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, NULL);
+			cmdiocbq->cmd_cmpl(phba, cmdiocbq, NULL);
 		else
 			lpfc_sli_release_iocbq(phba, cmdiocbq);
 		return;
@@ -12730,9 +12729,9 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 
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
@@ -13872,7 +13871,7 @@ void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba)
  * @irspiocbq: Pointer to work-queue completion queue entry.
  *
  * This routine handles an ELS work-queue completion event and construct
- * a pseudo response ELS IODBQ from the SLI4 ELS WCQE for the common
+ * a pseudo response ELS IOCBQ from the SLI4 ELS WCQE for the common
  * discovery engine to handle.
  *
  * Return: Pointer to the receive IOCBQ, NULL otherwise.
@@ -13916,7 +13915,7 @@ lpfc_sli4_els_preprocess_rspiocbq(struct lpfc_hba *phba,
 
 	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
 		spin_lock_irqsave(&phba->hbalock, iflags);
-		cmdiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
+		irspiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 
@@ -14775,7 +14774,7 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		/* Pass the cmd_iocb and the wcqe to the upper layer */
 		memcpy(&cmdiocbq->wcqe_cmpl, wcqe,
 		       sizeof(struct lpfc_wcqe_complete));
-		(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, cmdiocbq);
+		cmdiocbq->cmd_cmpl(phba, cmdiocbq, cmdiocbq);
 	} else {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0375 FCP cmdiocb not callback function "
@@ -18936,7 +18935,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
 
 	/* Free iocb created in lpfc_prep_seq */
 	list_for_each_entry_safe(curr_iocb, next_iocb,
-		&iocbq->list, list) {
+				 &iocbq->list, list) {
 		list_del_init(&curr_iocb->list);
 		lpfc_sli_release_iocbq(phba, curr_iocb);
 	}
-- 
2.35.3

