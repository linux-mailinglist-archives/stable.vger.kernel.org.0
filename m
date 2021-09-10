Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AB14073EC
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 01:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhIJXdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 19:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbhIJXdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 19:33:35 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9B8C061766;
        Fri, 10 Sep 2021 16:32:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so1679151pjb.5;
        Fri, 10 Sep 2021 16:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jGFBDzZt1XuvT2/PvJsUxCaDuknPpPW8lQxF7Hh+uUw=;
        b=RpJzfrTNh4n7ZEJlgqdUkes6N0sKw2lBi8YI3Df+atU0jAkKhbx0X5ffgmS9DR40Dg
         nbg9Vv9mOHXfNKRpeRX5IDVMrVNbWs7rJPmIxMSa9L3pSkfmx7kc38/uHmBGSYzm9fUZ
         MKvn7JTVrPhdbnkpzbWJE8w2f5kggRL03jC/r6KrdZ5MswKlOP7/yGabliBzQa8p9ng6
         CCN+OXDGj/Q1TsZ3yzT26xXCGCaH8SmP5GHZAon+FREBSvLHWgo7fhV3Whd6fZm43/b/
         BdlHGtFjSwLCozI+xaPhd94PB6n18O5Pg4K+Q3SkQWLNeS/nguurtB/3B91k8xxOmD/v
         xThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jGFBDzZt1XuvT2/PvJsUxCaDuknPpPW8lQxF7Hh+uUw=;
        b=D0SRwUZcRK3OotWsHqw3gonWWoO4DWhC9p4y5G/1UHusWa1y1R9Pj7VZILmB2VuWcn
         Qc0z8X32WQVhRCpmTusQuv78MjnGFgLQj1+HpFnqjWSU/w/M1A3c3prK+I/JggbUkEZW
         ehIxfE6M8eVE1vuAaO+xAfGvMZY4R6R8buaCaJt81pbK+waLTH8hSHuyV8ESKgovkOLv
         uC/bSdESVg2onXZrko87k12gbvzzsmiTgK3V96pmXTwCTjFuJX0wNkpYsN5UpkyJlvOw
         oGT/HK/vezT2pgDRfVG5NBRIPflhtInBDf+Zu1iv5y3O0R1hZmhigJIj30IjrjCO7dgE
         NRBg==
X-Gm-Message-State: AOAM530BZK6XE5b6JtCwisCENTuL0nrHodRe1C0AaCvQFn1eEqKXl8lF
        O4HPj94LDr43kfoR46VFvZosz0BbMapf2bNu
X-Google-Smtp-Source: ABdhPJxVLxbsQRUxOWJJfi+w0XUCXlK8gBWSIa6H9llvPoBSuXjVdfxF85vTk9U4zgolO4deKoAPvQ==
X-Received: by 2002:a17:902:bcc8:b0:13a:8c8:92b8 with SMTP id o8-20020a170902bcc800b0013a08c892b8mr181703pls.88.1631316736343;
        Fri, 10 Sep 2021 16:32:16 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:16 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 08/14] lpfc: Fix FCP I/O flush functionality for TMF routines
Date:   Fri, 10 Sep 2021 16:31:53 -0700
Message-Id: <20210910233159.115896-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A prior patch inadvertently caused lpfc_sli_sum_iocb to exclude
counting of outstanding aborted I/Os and ABORT iocbs.  Thus,
lpfc_reset_flush_io_context called from any TMF routine does not
properly wait to flush all outstanding FCP iocbs leading to a
block layer crash on an invalid scsi_cmnd->request pointer.
  kernel BUG at ../block/blk-core.c:1489!
  RIP: 0010:blk_requeue_request+0xaf/0xc0
  ...
  Call Trace:
  <IRQ>
  __scsi_queue_insert+0x90/0xe0 [scsi_mod]
  blk_done_softirq+0x7e/0x90
  __do_softirq+0xd2/0x280
  irq_exit+0xd5/0xe0
  do_IRQ+0x4c/0xd0
  common_interrupt+0x87/0x87
  </IRQ>

Fix by separating out the LPFC_IO_FCP, LPFC_IO_ON_TXCMPLQ,
LPFC_DRIVER_ABORTED, and CMD_ABORT_XRI_CN || CMD_CLOSE_XRI_CN checks
into a new lpfc_sli_validate_fcp_iocb_for_abort routine when determining
to build an ABORT iocb.

Restore lpfc_reset_flush_io_context functionality by including
counting of outstanding aborted iocbs and ABORT iocbs in lpfc_sli_sum_iocb.

Fixes: e1364711359f ("scsi: lpfc: Fix illegal memory access on Abort IOCBs")
Cc: <stable@vger.kernel.org> # v5.12+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 101 +++++++++++++++++++++++++++--------
 1 file changed, 78 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 546c851938bc..e8f6ad484768 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12485,15 +12485,54 @@ lpfc_sli_hba_iocb_abort(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_validate_fcp_iocb - find commands associated with a vport or LUN
+ * lpfc_sli_validate_fcp_iocb_for_abort - filter iocbs appropriate for FCP aborts
+ * @iocbq: Pointer to iocb object.
+ * @vport: Pointer to driver virtual port object.
+ *
+ * This function acts as an iocb filter for functions which abort FCP iocbs.
+ *
+ * Return values
+ * -ENODEV, if a null iocb or vport ptr is encountered
+ * -EINVAL, if the iocb is not an FCP I/O, not on the TX cmpl queue, premarked as
+ *          driver already started the abort process, or is an abort iocb itself
+ * 0, passes criteria for aborting the FCP I/O iocb
+ **/
+static int
+lpfc_sli_validate_fcp_iocb_for_abort(struct lpfc_iocbq *iocbq,
+				     struct lpfc_vport *vport)
+{
+	IOCB_t *icmd = NULL;
+
+	/* No null ptr vports */
+	if (!iocbq || iocbq->vport != vport)
+		return -ENODEV;
+
+	/* iocb must be for FCP IO, already exists on the TX cmpl queue,
+	 * can't be premarked as driver aborted, nor be an ABORT iocb itself
+	 */
+	icmd = &iocbq->iocb;
+	if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+	    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ) ||
+	    (iocbq->iocb_flag & LPFC_DRIVER_ABORTED) ||
+	    (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
+	     icmd->ulpCommand == CMD_CLOSE_XRI_CN))
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * lpfc_sli_validate_fcp_iocb - validate commands associated with a SCSI target
  * @iocbq: Pointer to driver iocb object.
  * @vport: Pointer to driver virtual port object.
  * @tgt_id: SCSI ID of the target.
  * @lun_id: LUN ID of the scsi device.
  * @ctx_cmd: LPFC_CTX_LUN/LPFC_CTX_TGT/LPFC_CTX_HOST
  *
- * This function acts as an iocb filter for functions which abort or count
- * all FCP iocbs pending on a lun/SCSI target/SCSI host. It will return
+ * This function acts as an iocb filter for validating a lun/SCSI target/SCSI
+ * host.
+ *
+ * It will return
  * 0 if the filtering criteria is met for the given iocb and will return
  * 1 if the filtering criteria is not met.
  * If ctx_cmd == LPFC_CTX_LUN, the function returns 0 only if the
@@ -12512,22 +12551,8 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
 			   lpfc_ctx_cmd ctx_cmd)
 {
 	struct lpfc_io_buf *lpfc_cmd;
-	IOCB_t *icmd = NULL;
 	int rc = 1;
 
-	if (!iocbq || iocbq->vport != vport)
-		return rc;
-
-	if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
-	    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ) ||
-	      iocbq->iocb_flag & LPFC_DRIVER_ABORTED)
-		return rc;
-
-	icmd = &iocbq->iocb;
-	if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
-	    icmd->ulpCommand == CMD_CLOSE_XRI_CN)
-		return rc;
-
 	lpfc_cmd = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
 
 	if (lpfc_cmd->pCmd == NULL)
@@ -12582,17 +12607,33 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_iocbq *iocbq;
+	IOCB_t *icmd = NULL;
 	int sum, i;
+	unsigned long iflags;
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	for (i = 1, sum = 0; i <= phba->sli.last_iotag; i++) {
 		iocbq = phba->sli.iocbq_lookup[i];
 
-		if (lpfc_sli_validate_fcp_iocb (iocbq, vport, tgt_id, lun_id,
-						ctx_cmd) == 0)
+		if (!iocbq || iocbq->vport != vport)
+			continue;
+		if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+		    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ))
+			continue;
+
+		/* Include counting outstanding aborts */
+		icmd = &iocbq->iocb;
+		if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
+		    icmd->ulpCommand == CMD_CLOSE_XRI_CN) {
+			sum++;
+			continue;
+		}
+
+		if (lpfc_sli_validate_fcp_iocb(iocbq, vport, tgt_id, lun_id,
+					       ctx_cmd) == 0)
 			sum++;
 	}
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	return sum;
 }
@@ -12659,7 +12700,11 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  *
  * This function sends an abort command for every SCSI command
  * associated with the given virtual port pending on the ring
- * filtered by lpfc_sli_validate_fcp_iocb function.
+ * filtered by lpfc_sli_validate_fcp_iocb_for_abort and then
+ * lpfc_sli_validate_fcp_iocb function.  The ordering for validation before
+ * submitting abort iocbs must be lpfc_sli_validate_fcp_iocb_for_abort
+ * followed by lpfc_sli_validate_fcp_iocb.
+ *
  * When abort_cmd == LPFC_CTX_LUN, the function sends abort only to the
  * FCP iocbs associated with lun specified by tgt_id and lun_id
  * parameters
@@ -12691,6 +12736,9 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16 tgt_id, u64 lun_id,
 	for (i = 1; i <= phba->sli.last_iotag; i++) {
 		iocbq = phba->sli.iocbq_lookup[i];
 
+		if (lpfc_sli_validate_fcp_iocb_for_abort(iocbq, vport))
+			continue;
+
 		if (lpfc_sli_validate_fcp_iocb(iocbq, vport, tgt_id, lun_id,
 					       abort_cmd) != 0)
 			continue;
@@ -12723,7 +12771,11 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16 tgt_id, u64 lun_id,
  *
  * This function sends an abort command for every SCSI command
  * associated with the given virtual port pending on the ring
- * filtered by lpfc_sli_validate_fcp_iocb function.
+ * filtered by lpfc_sli_validate_fcp_iocb_for_abort and then
+ * lpfc_sli_validate_fcp_iocb function.  The ordering for validation before
+ * submitting abort iocbs must be lpfc_sli_validate_fcp_iocb_for_abort
+ * followed by lpfc_sli_validate_fcp_iocb.
+ *
  * When taskmgmt_cmd == LPFC_CTX_LUN, the function sends abort only to the
  * FCP iocbs associated with lun specified by tgt_id and lun_id
  * parameters
@@ -12761,6 +12813,9 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 	for (i = 1; i <= phba->sli.last_iotag; i++) {
 		iocbq = phba->sli.iocbq_lookup[i];
 
+		if (lpfc_sli_validate_fcp_iocb_for_abort(iocbq, vport))
+			continue;
+
 		if (lpfc_sli_validate_fcp_iocb(iocbq, vport, tgt_id, lun_id,
 					       cmd) != 0)
 			continue;
-- 
2.26.2

