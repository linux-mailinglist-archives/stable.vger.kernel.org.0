Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49EC611C34
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 23:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJ1VJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 17:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiJ1VJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 17:09:00 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70B324A566
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 14:08:59 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id x15so4898681qvp.1
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 14:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3FzWIWMzu2w/42xHKuYOCzXhXcVw3a5G3WrBSWRpbg=;
        b=InRjLOCvofUdnFfFpeW38vMavaNVanYD6ywvA0D6np+LXmKxa8GEhbeHYRZSzOwTAk
         WbJ3eV6YMbBXPc6MkPvikaM2aAP/4nslEm+TRqcCagGq3Lx9RGI364+/12tJeFnzx4PE
         8xAYxz0Msju7gS4hqu4TU4s4dsrGKpgWz0izWs0hOMpSBVeEOXxaXn18xOZPzuoObLQF
         gVCXk6ClZOL8/mb7/PhujzctDtdSd3bC7au+A9PoZZdk5jsrRKFVOGYF+ucIBQmCRBs/
         pi0lBhSZwdjlJWbyZ0zcDosgJFQvHLSD338nYhkBgJdEnGqByy9lj4W5UNGXdrk5olGo
         6/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3FzWIWMzu2w/42xHKuYOCzXhXcVw3a5G3WrBSWRpbg=;
        b=O7+1kDWz7arAj++7/NmqKye98WNbnHMJZM1V4t0IMuaIOxu3SRbRGUQjrEg2W1HYFR
         MFMLVj25Rbae+j+BWqL2IupPOBqEBnu2oa3Jk75QNQ8EmP4Boy54Y7c3mgppkStT8Oqp
         PrVHqOKmQRlkKHAPrdxEPSkzuD2PcYV3AxMBxSlZho9h9iWLryEoRREZ1H5usfwc1NhE
         H+UwIhryxk85NxTttqqGIIbs5VdfVorYpDvNuaWqDo/AZFr+DPnl6vh416SNlHgZLXAb
         6FGjoA7fte2O6+fDxnY3sn0r1a28Tmz8pBs0tnIoW++cz6uCIl48C7zoOtwuBG+7B8NS
         tzQA==
X-Gm-Message-State: ACrzQf3NOxf9b/vPx0Kf789xOI3CfUlaOOhaFQhJB3BuWN1mVOvAfR3e
        pNlSYHwN3k6YAgai6j/tzdARRiAkuAY=
X-Google-Smtp-Source: AMsMyM463YSTffI03lFzRG2kjC8WiwUAgu8klLpQCfXlixd/KRDOLlxV07OspJIXZcL8DMVmbHisoQ==
X-Received: by 2002:a0c:df09:0:b0:4bb:675c:8e82 with SMTP id g9-20020a0cdf09000000b004bb675c8e82mr1447396qvl.94.1666991338875;
        Fri, 28 Oct 2022 14:08:58 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id fu36-20020a05622a5da400b0035cf31005e2sm2906808qtb.73.2022.10.28.14.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:08:58 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH v2 1/6] Revert "scsi: lpfc: Resolve some cleanup issues following SLI path refactoring"
Date:   Fri, 28 Oct 2022 14:08:22 -0700
Message-Id: <20221028210827.23149-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221028210827.23149-1-jsmart2021@gmail.com>
References: <20221028210827.23149-1-jsmart2021@gmail.com>
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
---
 drivers/scsi/lpfc/lpfc_init.c |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 25 +++++++++++++------------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 33e33fff8986..4be734b0da0f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11967,7 +11967,7 @@ lpfc_sli_enable_msi(struct lpfc_hba *phba)
 	rc = pci_enable_msi(phba->pcidev);
 	if (!rc)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0012 PCI enable MSI mode success.\n");
+				"0462 PCI enable MSI mode success.\n");
 	else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0471 PCI enable MSI mode failed (%d)\n", rc);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f594a006d04c..85de54ba444b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1939,7 +1939,7 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	sync_buf = __lpfc_sli_get_iocbq(phba);
 	if (!sync_buf) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_CGN_MGMT,
-				"6244 No available WQEs for CMF_SYNC_WQE\n");
+				"6213 No available WQEs for CMF_SYNC_WQE\n");
 		ret_val = ENOMEM;
 		goto out_unlock;
 	}
@@ -3739,7 +3739,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 						set_job_ulpword4(cmdiocbp,
 								 IOERR_ABORT_REQUESTED);
 						/*
-						 * For SLI4, irspiocb contains
+						 * For SLI4, irsiocb contains
 						 * NO_XRI in sli_xritag, it
 						 * shall not affect releasing
 						 * sgl (xri) process.
@@ -3757,7 +3757,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 					}
 				}
 			}
-			cmdiocbp->cmd_cmpl(phba, cmdiocbp, saveq);
+			(cmdiocbp->cmd_cmpl) (phba, cmdiocbp, saveq);
 		} else
 			lpfc_sli_release_iocbq(phba, cmdiocbp);
 	} else {
@@ -3997,7 +3997,8 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				cmdiocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
 			if (cmdiocbq->cmd_cmpl) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				cmdiocbq->cmd_cmpl(phba, cmdiocbq, &rspiocbq);
+				(cmdiocbq->cmd_cmpl)(phba, cmdiocbq,
+						      &rspiocbq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			}
 			break;
@@ -10937,7 +10938,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
  * @flag: Flag indicating if this command can be put into txq.
  *
  * __lpfc_sli_issue_fcp_io_s3 is wrapper function to invoke lockless func to
- * send  an iocb command to an HBA with SLI-3 interface spec.
+ * send  an iocb command to an HBA with SLI-4 interface spec.
  *
  * This function takes the hbalock before invoking the lockless version.
  * The function will return success after it successfully submit the wqe to
@@ -12990,7 +12991,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 		cmdiocbq->cmd_cmpl = cmdiocbq->wait_cmd_cmpl;
 		cmdiocbq->wait_cmd_cmpl = NULL;
 		if (cmdiocbq->cmd_cmpl)
-			cmdiocbq->cmd_cmpl(phba, cmdiocbq, NULL);
+			(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, NULL);
 		else
 			lpfc_sli_release_iocbq(phba, cmdiocbq);
 		return;
@@ -13004,9 +13005,9 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 
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
@@ -14144,7 +14145,7 @@ void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba)
  * @irspiocbq: Pointer to work-queue completion queue entry.
  *
  * This routine handles an ELS work-queue completion event and construct
- * a pseudo response ELS IOCBQ from the SLI4 ELS WCQE for the common
+ * a pseudo response ELS IODBQ from the SLI4 ELS WCQE for the common
  * discovery engine to handle.
  *
  * Return: Pointer to the receive IOCBQ, NULL otherwise.
@@ -14188,7 +14189,7 @@ lpfc_sli4_els_preprocess_rspiocbq(struct lpfc_hba *phba,
 
 	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
 		spin_lock_irqsave(&phba->hbalock, iflags);
-		irspiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
+		cmdiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 
@@ -15047,7 +15048,7 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		/* Pass the cmd_iocb and the wcqe to the upper layer */
 		memcpy(&cmdiocbq->wcqe_cmpl, wcqe,
 		       sizeof(struct lpfc_wcqe_complete));
-		cmdiocbq->cmd_cmpl(phba, cmdiocbq, cmdiocbq);
+		(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, cmdiocbq);
 	} else {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0375 FCP cmdiocb not callback function "
@@ -19211,7 +19212,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
 
 	/* Free iocb created in lpfc_prep_seq */
 	list_for_each_entry_safe(curr_iocb, next_iocb,
-				 &iocbq->list, list) {
+		&iocbq->list, list) {
 		list_del_init(&curr_iocb->list);
 		lpfc_sli_release_iocbq(phba, curr_iocb);
 	}
-- 
2.35.3

