Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D5760D772
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 00:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiJYW6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 18:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJYW6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 18:58:13 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE77C96E9
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:12 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id s17so9297798qkj.12
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 15:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ozE4/tdV07k5b+r7RsUIngLHGmWxqhNxlUYXU2fmSp8=;
        b=JWTZTqwuMqN83C1tCk2feDpzwM35UJU12Yb8QbkjoHWgSKKs2emVqpLvQ45AK/ZYTu
         fiXLrdqIr7CfuHevKKcx6ShzHgrRYfYy/tWdmA6ZJXzV/aaq2fAoQJAUuMSudOvy2Ivu
         +XrQ0sr6Vr25qLDsJs51wpckjpPYMWDJc6CQL6IK++boyOXdZXQM7Te6naFRC7/d7Oyc
         u9g0zFrpeWPo87NpxtI9raPJ7co/0QSp1nM8l4SuOGh1gM3kPXZ/IOMEdv+yh1+GrL1N
         AIy4f8aWjiAJQTaiJ9cs72MOtK1J5A+mGKTe3yYJYJUnyUB1A6xmaVqW7/cabre+3GZl
         nYsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ozE4/tdV07k5b+r7RsUIngLHGmWxqhNxlUYXU2fmSp8=;
        b=WmNy1qmQ9pd3lWA5eTm1jQBnFlWy+QbS6g6OeUbFs0w1lmZGUZQVmvXhCacy5DUIZx
         cZM0JsP4bB3q6qDSRo3h5DYWMO0chehFdxdKCFyKY++E+bB0U6QrZBrQhVZYyNSS72NP
         hB3TIV6139A5GF3a9QLEgW/VQbEcwMV7ZIo28Kg29UYtq30I6zDuWrothm6pWsFbq/gL
         q5wBmOfaJHiVEK5BTq5YmPuU9REfoCsJU+vmBZaxWxgWM2iz3rss9VADoK3T/2X9Wb/M
         3zWSlGzdzrsmQ8gatnW+ZJkb/n8fzW3WbypAqXYHQSBTKH8FiN/bicMXqGpde4zHSZbK
         xRuQ==
X-Gm-Message-State: ACrzQf2cHmWFNAUduPBfqsG/WyGIhs/h3CfRK5f0k43IV6mSrMJC34yc
        kf6DeH3XGE6qVymvcIoRmynrXpLOn3Q=
X-Google-Smtp-Source: AMsMyM4eXTfbX0Gcc1Z1RIZU8dm5YYLuDUQlEMvmmd5Yx5dFZ9nRFfF7dCaqxeZgjdwMg2nGqIcpoQ==
X-Received: by 2002:a05:620a:4054:b0:6ec:56e0:bb87 with SMTP id i20-20020a05620a405400b006ec56e0bb87mr29133782qko.782.1666738691259;
        Tue, 25 Oct 2022 15:58:11 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12-20020ae9d60c000000b006ecdfcf9d81sm2823766qkk.84.2022.10.25.15.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:58:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     stable@vger.kernel.org
Cc:     jsmart2021@gmail.com, justintee8345@gmail.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org
Subject: [PATCH 01/33] Revert "scsi: lpfc: Resolve some cleanup issues following SLI path refactoring"
Date:   Tue, 25 Oct 2022 15:57:07 -0700
Message-Id: <20221025225739.85182-2-jsmart2021@gmail.com>
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

This reverts commit 17bf429b913b9e7f8d2353782e24ed3a491bb2d8.
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

