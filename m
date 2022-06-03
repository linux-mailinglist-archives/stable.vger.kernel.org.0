Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 325A353CECD
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237507AbiFCRrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345193AbiFCRqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:46:37 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB9E546BF;
        Fri,  3 Jun 2022 10:43:38 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 129so7751304pgc.2;
        Fri, 03 Jun 2022 10:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K+OvXl8F3WzCqNf70UpmJS6odKLeTjrU7uwEIJKRwK0=;
        b=frX5HQa6TXSTqO34GUZuEz30tI4uNyWkXHnrxaZC3hh2uswcYnaHz9agEfCuDggXsR
         iDbfxgkWN1pGOEdYFcAV8bvJ3vZLjB06OBFxGXijQkDGjhyoKVaYGZEz0/102HL7AxzO
         raf6D6bvuWj/Xlq+LMZoki3pOjXUlxnTtBPL+Q8k5N+AHaDi4whLw55ovSwimld2Dwdc
         XIKSQvAXcEZLk2qeKh9mCoVG8CiOR0SxXwRRJVTxc+wnKG/yAFndWp5QqivyBJW9GBAV
         O/78WK304DmljtS+5IkTw4NlJIQtDe0ycDwhDQa1R2sa7bBeszDwWoPUFgWlc3PzRnQP
         SOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K+OvXl8F3WzCqNf70UpmJS6odKLeTjrU7uwEIJKRwK0=;
        b=RMZfz03oUjCXGQVsG9m+rsz1l2HmwQLReMV9XpK5P1afTysyfsTdv/9RtzfNQbpkAz
         XsFB5O5vINrbefKaU7CoB5YPU0S5IxCvolCo/82/Krryh/NV+Xu62OzENHzYHDDP85tA
         Br6+wT/EewgHZIJA4qs5V+g7OZDj5uESAscelD/3s+8zU375HoJdCQWSQuTGrPyYRsjV
         6u+jPIXqHUdSPnL1W/loYf9FM+LSu+3XVNIGcjIUNGHHUkX+RwD+Fcmjd6y+NA/3YP7F
         nwhXU6ePjl4jtAi2Fi86ndOpk0MoVjKcJRS2QyQb+VwB7vot3JQRo8bb1mERiuNO6Q6g
         c7PA==
X-Gm-Message-State: AOAM532n+zBh4IEoBz8An3Q1OfdZANJfAyM4fOgxEFWER+ZdJBJIJqtM
        WYvd8HS7yhyyJzmwXT89lp1OYh4MIWo=
X-Google-Smtp-Source: ABdhPJxF3sLPkMdM96wtx7S4Geocn/u6mIKTbkb/TK8amcDOpiy432kP+l6u/u6rKV+5JKIwmutKDA==
X-Received: by 2002:a63:8642:0:b0:3fc:a5ee:678 with SMTP id x63-20020a638642000000b003fca5ee0678mr9832639pgd.178.1654278217584;
        Fri, 03 Jun 2022 10:43:37 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0015e8d4eb1d2sm5705047pll.28.2022.06.03.10.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:43:37 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 3/9] lpfc: Resolve some cleanup issues following SLI path refactoring
Date:   Fri,  3 Jun 2022 10:43:23 -0700
Message-Id: <20220603174329.63777-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220603174329.63777-1-jsmart2021@gmail.com>
References: <20220603174329.63777-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following refactoring and consolidation in SLI processing, fixup some
minor issues related to SLI path.

- Correct the setting of LPFC_EXCHANGE_BUSY flag in response iocb.
- Fix some typographical errors.
- Fix duplicate log messages.

Fixes: 1b64aa9eae28 ("scsi: lpfc: SLI path split: Refactor fast and slow paths to native SLI4")
Cc: <stable@vger.kernel.org> # v5.18
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 25 ++++++++++++-------------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 93b94c64518d..750dd1e9f2cc 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12188,7 +12188,7 @@ lpfc_sli_enable_msi(struct lpfc_hba *phba)
 	rc = pci_enable_msi(phba->pcidev);
 	if (!rc)
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"0462 PCI enable MSI mode success.\n");
+				"0012 PCI enable MSI mode success.\n");
 	else {
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 				"0471 PCI enable MSI mode failed (%d)\n", rc);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 79d2ef5f0f05..dd96fc09105d 100644
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
@@ -3805,7 +3805,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 						set_job_ulpword4(cmdiocbp,
 								 IOERR_ABORT_REQUESTED);
 						/*
-						 * For SLI4, irsiocb contains
+						 * For SLI4, irspiocb contains
 						 * NO_XRI in sli_xritag, it
 						 * shall not affect releasing
 						 * sgl (xri) process.
@@ -3823,7 +3823,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 					}
 				}
 			}
-			(cmdiocbp->cmd_cmpl) (phba, cmdiocbp, saveq);
+			cmdiocbp->cmd_cmpl(phba, cmdiocbp, saveq);
 		} else
 			lpfc_sli_release_iocbq(phba, cmdiocbp);
 	} else {
@@ -4063,8 +4063,7 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				cmdiocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
 			if (cmdiocbq->cmd_cmpl) {
 				spin_unlock_irqrestore(&phba->hbalock, iflag);
-				(cmdiocbq->cmd_cmpl)(phba, cmdiocbq,
-						      &rspiocbq);
+				cmdiocbq->cmd_cmpl(phba, cmdiocbq, &rspiocbq);
 				spin_lock_irqsave(&phba->hbalock, iflag);
 			}
 			break;
@@ -10288,7 +10287,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
  * @flag: Flag indicating if this command can be put into txq.
  *
  * __lpfc_sli_issue_fcp_io_s3 is wrapper function to invoke lockless func to
- * send  an iocb command to an HBA with SLI-4 interface spec.
+ * send  an iocb command to an HBA with SLI-3 interface spec.
  *
  * This function takes the hbalock before invoking the lockless version.
  * The function will return success after it successfully submit the wqe to
@@ -12740,7 +12739,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 		cmdiocbq->cmd_cmpl = cmdiocbq->wait_cmd_cmpl;
 		cmdiocbq->wait_cmd_cmpl = NULL;
 		if (cmdiocbq->cmd_cmpl)
-			(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, NULL);
+			cmdiocbq->cmd_cmpl(phba, cmdiocbq, NULL);
 		else
 			lpfc_sli_release_iocbq(phba, cmdiocbq);
 		return;
@@ -12754,9 +12753,9 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
 
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
@@ -13896,7 +13895,7 @@ void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba)
  * @irspiocbq: Pointer to work-queue completion queue entry.
  *
  * This routine handles an ELS work-queue completion event and construct
- * a pseudo response ELS IODBQ from the SLI4 ELS WCQE for the common
+ * a pseudo response ELS IOCBQ from the SLI4 ELS WCQE for the common
  * discovery engine to handle.
  *
  * Return: Pointer to the receive IOCBQ, NULL otherwise.
@@ -13940,7 +13939,7 @@ lpfc_sli4_els_preprocess_rspiocbq(struct lpfc_hba *phba,
 
 	if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
 		spin_lock_irqsave(&phba->hbalock, iflags);
-		cmdiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
+		irspiocbq->cmd_flag |= LPFC_EXCHANGE_BUSY;
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 
@@ -14799,7 +14798,7 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 		/* Pass the cmd_iocb and the wcqe to the upper layer */
 		memcpy(&cmdiocbq->wcqe_cmpl, wcqe,
 		       sizeof(struct lpfc_wcqe_complete));
-		(cmdiocbq->cmd_cmpl)(phba, cmdiocbq, cmdiocbq);
+		cmdiocbq->cmd_cmpl(phba, cmdiocbq, cmdiocbq);
 	} else {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0375 FCP cmdiocb not callback function "
@@ -18956,7 +18955,7 @@ lpfc_sli4_send_seq_to_ulp(struct lpfc_vport *vport,
 
 	/* Free iocb created in lpfc_prep_seq */
 	list_for_each_entry_safe(curr_iocb, next_iocb,
-		&iocbq->list, list) {
+				 &iocbq->list, list) {
 		list_del_init(&curr_iocb->list);
 		lpfc_sli_release_iocbq(phba, curr_iocb);
 	}
-- 
2.26.2

