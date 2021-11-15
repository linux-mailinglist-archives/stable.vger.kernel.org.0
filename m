Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCB945224E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377452AbhKPBKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245154AbhKOTTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4021261B5E;
        Mon, 15 Nov 2021 18:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000969;
        bh=F7LINv2eyiNE3fcRSuHGPIqi9f0gi4BrDOtdpa8fpNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gXNaKc7x7s/25sBHeX2VjG6pYHDpuprz8ex5nPSh7wp/vUgoMUF/RcyW/AYKmXm85
         uCNbF1vzJ2frmWUnFl6KkMzuD8oIeR2zxp8xua3tvl019EUNqciH+VW6Y4mcBQz06h
         zyL2ENoQtR9DRtDPL+dQlKWffsMKcBgcfMaK4gpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 012/917] scsi: lpfc: Fix FCP I/O flush functionality for TMF routines
Date:   Mon, 15 Nov 2021 17:51:47 +0100
Message-Id: <20211115165429.154386432@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit cd8a36a90babf958082b87bc6b4df5dd70901eba upstream.

A prior patch inadvertently caused lpfc_sli_sum_iocb() to exclude counting
of outstanding aborted I/Os and ABORT IOCBs.  Thus,
lpfc_reset_flush_io_context() called from any TMF routine does not properly
wait to flush all outstanding FCP IOCBs leading to a block layer crash on
an invalid scsi_cmnd->request pointer.

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
LPFC_DRIVER_ABORTED, and CMD_ABORT_XRI_CN || CMD_CLOSE_XRI_CN checks into a
new lpfc_sli_validate_fcp_iocb_for_abort() routine when determining to
build an ABORT iocb.

Restore lpfc_reset_flush_io_context() functionality by including counting
of outstanding aborted IOCBs and ABORT IOCBs in lpfc_sli_sum_iocb().

Link: https://lore.kernel.org/r/20210910233159.115896-9-jsmart2021@gmail.com
Fixes: e1364711359f ("scsi: lpfc: Fix illegal memory access on Abort IOCBs")
Cc: <stable@vger.kernel.org> # v5.12+
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_sli.c |  101 +++++++++++++++++++++++++++++++++----------
 1 file changed, 78 insertions(+), 23 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12488,15 +12488,54 @@ lpfc_sli_hba_iocb_abort(struct lpfc_hba
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
@@ -12515,22 +12554,8 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_i
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
@@ -12585,17 +12610,33 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vpo
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
@@ -12662,7 +12703,11 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba
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
@@ -12694,6 +12739,9 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
 	for (i = 1; i <= phba->sli.last_iotag; i++) {
 		iocbq = phba->sli.iocbq_lookup[i];
 
+		if (lpfc_sli_validate_fcp_iocb_for_abort(iocbq, vport))
+			continue;
+
 		if (lpfc_sli_validate_fcp_iocb(iocbq, vport, tgt_id, lun_id,
 					       abort_cmd) != 0)
 			continue;
@@ -12726,7 +12774,11 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
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
@@ -12764,6 +12816,9 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vpor
 	for (i = 1; i <= phba->sli.last_iotag; i++) {
 		iocbq = phba->sli.iocbq_lookup[i];
 
+		if (lpfc_sli_validate_fcp_iocb_for_abort(iocbq, vport))
+			continue;
+
 		if (lpfc_sli_validate_fcp_iocb(iocbq, vport, tgt_id, lun_id,
 					       cmd) != 0)
 			continue;


