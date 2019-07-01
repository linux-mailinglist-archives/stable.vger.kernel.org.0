Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F71C4927F
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfFQVUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726568AbfFQVUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:20:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF1A208E4;
        Mon, 17 Jun 2019 21:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806444;
        bh=jNiPFrtMDUXWnK/eXeGWnm/3CbfWzGb2CTAPSnCH850=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mpz6MZROor3bRyZmDh8NDCR56BcyGi5xqXSZq6lMlvM4119lEViEVybl/aAIfvkPF
         0PNAg+wbqVewK+QTrv5RS9qzzIQCxwawlhFELAPdAtoyRUuOgUqm88uhod9JNBO0BN
         nzb5HbLvaJNnT9eoeH2HldGgN7jFlXcNNmL4X06Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 055/115] scsi: lpfc: resolve lockdep warnings
Date:   Mon, 17 Jun 2019 23:09:15 +0200
Message-Id: <20190617210803.190822608@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e2a8be5696e706a2fce6edd11e5c74ce14cffec0 ]

There were a number of erroneous comments and incorrect older lockdep
checks that were causing a number of warnings.

Resolve the following:

 - Inconsistent lock state warnings in lpfc_nvme_info_show().

 - Fixed comments and code on sequences where ring lock is now held instead
   of hbalock.

 - Reworked calling sequences around lpfc_sli_iocbq_lookup(). Rather than
   locking prior to the routine and have routine guess on what lock, take
   the lock within the routine. The lockdep check becomes unnecessary.

 - Fixed comments and removed erroneous hbalock checks.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
CC: Bart Van Assche <bvanassche@acm.org>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_attr.c |  5 ++-
 drivers/scsi/lpfc/lpfc_sli.c  | 84 ++++++++++++++++++++++-------------
 2 files changed, 56 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index a09a742d7ec1..f30cb0fb9a82 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -159,6 +159,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	int i;
 	int len = 0;
 	char tmp[LPFC_MAX_NVME_INFO_TMP_LEN] = {0};
+	unsigned long iflags = 0;
 
 	if (!(vport->cfg_enable_fc4_type & LPFC_ENABLE_NVME)) {
 		len = scnprintf(buf, PAGE_SIZE, "NVME Disabled\n");
@@ -357,11 +358,11 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		nrport = NULL;
-		spin_lock(&vport->phba->hbalock);
+		spin_lock_irqsave(&vport->phba->hbalock, iflags);
 		rport = lpfc_ndlp_get_nrport(ndlp);
 		if (rport)
 			nrport = rport->remoteport;
-		spin_unlock(&vport->phba->hbalock);
+		spin_unlock_irqrestore(&vport->phba->hbalock, iflags);
 		if (!nrport)
 			continue;
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index dc933b6d7800..363b21c4255e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -994,15 +994,14 @@ lpfc_cleanup_vports_rrqs(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
  * @ndlp: Targets nodelist pointer for this exchange.
  * @xritag the xri in the bitmap to test.
  *
- * This function is called with hbalock held. This function
- * returns 0 = rrq not active for this xri
- *         1 = rrq is valid for this xri.
+ * This function returns:
+ * 0 = rrq not active for this xri
+ * 1 = rrq is valid for this xri.
  **/
 int
 lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 			uint16_t  xritag)
 {
-	lockdep_assert_held(&phba->hbalock);
 	if (!ndlp)
 		return 0;
 	if (!ndlp->active_rrqs_xri_bitmap)
@@ -1105,10 +1104,11 @@ out:
  * @phba: Pointer to HBA context object.
  * @piocb: Pointer to the iocbq.
  *
- * This function is called with the ring lock held. This function
- * gets a new driver sglq object from the sglq list. If the
- * list is not empty then it is successful, it returns pointer to the newly
- * allocated sglq object else it returns NULL.
+ * The driver calls this function with either the nvme ls ring lock
+ * or the fc els ring lock held depending on the iocb usage.  This function
+ * gets a new driver sglq object from the sglq list. If the list is not empty
+ * then it is successful, it returns pointer to the newly allocated sglq
+ * object else it returns NULL.
  **/
 static struct lpfc_sglq *
 __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
@@ -1118,9 +1118,15 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 	struct lpfc_sglq *start_sglq = NULL;
 	struct lpfc_io_buf *lpfc_cmd;
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_sli_ring *pring = NULL;
 	int found = 0;
 
-	lockdep_assert_held(&phba->hbalock);
+	if (piocbq->iocb_flag & LPFC_IO_NVME_LS)
+		pring =  phba->sli4_hba.nvmels_wq->pring;
+	else
+		pring = lpfc_phba_elsring(phba);
+
+	lockdep_assert_held(&pring->ring_lock);
 
 	if (piocbq->iocb_flag &  LPFC_IO_FCP) {
 		lpfc_cmd = (struct lpfc_io_buf *) piocbq->context1;
@@ -1563,7 +1569,8 @@ lpfc_sli_ring_map(struct lpfc_hba *phba)
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to the driver iocb object.
  *
- * This function is called with hbalock held. The function adds the
+ * The driver calls this function with the hbalock held for SLI3 ports or
+ * the ring lock held for SLI4 ports. The function adds the
  * new iocb to txcmplq of the given ring. This function always returns
  * 0. If this function is called for ELS ring, this function checks if
  * there is a vport associated with the ELS command. This function also
@@ -1573,7 +1580,10 @@ static int
 lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			struct lpfc_iocbq *piocb)
 {
-	lockdep_assert_held(&phba->hbalock);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		lockdep_assert_held(&pring->ring_lock);
+	else
+		lockdep_assert_held(&phba->hbalock);
 
 	BUG_ON(!piocb);
 
@@ -2970,8 +2980,8 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
  *
  * This function looks up the iocb_lookup table to get the command iocb
  * corresponding to the given response iocb using the iotag of the
- * response iocb. This function is called with the hbalock held
- * for sli3 devices or the ring_lock for sli4 devices.
+ * response iocb. The driver calls this function with the hbalock held
+ * for SLI3 ports or the ring lock held for SLI4 ports.
  * This function returns the command iocb object if it finds the command
  * iocb else returns NULL.
  **/
@@ -2982,8 +2992,15 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 {
 	struct lpfc_iocbq *cmd_iocb = NULL;
 	uint16_t iotag;
-	lockdep_assert_held(&phba->hbalock);
+	spinlock_t *temp_lock = NULL;
+	unsigned long iflag = 0;
 
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		temp_lock = &pring->ring_lock;
+	else
+		temp_lock = &phba->hbalock;
+
+	spin_lock_irqsave(temp_lock, iflag);
 	iotag = prspiocb->iocb.ulpIoTag;
 
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
@@ -2993,10 +3010,12 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 			list_del_init(&cmd_iocb->list);
 			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
+			spin_unlock_irqrestore(temp_lock, iflag);
 			return cmd_iocb;
 		}
 	}
 
+	spin_unlock_irqrestore(temp_lock, iflag);
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0317 iotag x%x is out of "
 			"range: max iotag x%x wd0 x%x\n",
@@ -3012,8 +3031,8 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
  * @iotag: IOCB tag.
  *
  * This function looks up the iocb_lookup table to get the command iocb
- * corresponding to the given iotag. This function is called with the
- * hbalock held.
+ * corresponding to the given iotag. The driver calls this function with
+ * the ring lock held because this function is an SLI4 port only helper.
  * This function returns the command iocb object if it finds the command
  * iocb else returns NULL.
  **/
@@ -3022,8 +3041,15 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 			     struct lpfc_sli_ring *pring, uint16_t iotag)
 {
 	struct lpfc_iocbq *cmd_iocb = NULL;
+	spinlock_t *temp_lock = NULL;
+	unsigned long iflag = 0;
 
-	lockdep_assert_held(&phba->hbalock);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		temp_lock = &pring->ring_lock;
+	else
+		temp_lock = &phba->hbalock;
+
+	spin_lock_irqsave(temp_lock, iflag);
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
 		if (cmd_iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ) {
@@ -3031,10 +3057,12 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 			list_del_init(&cmd_iocb->list);
 			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
+			spin_unlock_irqrestore(temp_lock, iflag);
 			return cmd_iocb;
 		}
 	}
 
+	spin_unlock_irqrestore(temp_lock, iflag);
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0372 iotag x%x lookup error: max iotag (x%x) "
 			"iocb_flag x%x\n",
@@ -3068,17 +3096,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	int rc = 1;
 	unsigned long iflag;
 
-	/* Based on the iotag field, get the cmd IOCB from the txcmplq */
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		spin_lock_irqsave(&pring->ring_lock, iflag);
-	else
-		spin_lock_irqsave(&phba->hbalock, iflag);
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		spin_unlock_irqrestore(&pring->ring_lock, iflag);
-	else
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-
 	if (cmdiocbp) {
 		if (cmdiocbp->iocb_cmpl) {
 			/*
@@ -3409,8 +3427,10 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				break;
 			}
 
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
 			if (unlikely(!cmdiocbq))
 				break;
 			if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED)
@@ -3604,9 +3624,12 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 		case LPFC_ABORT_IOCB:
 			cmdiocbp = NULL;
-			if (irsp->ulpCommand != CMD_XRI_ABORTED_CX)
+			if (irsp->ulpCommand != CMD_XRI_ABORTED_CX) {
+				spin_unlock_irqrestore(&phba->hbalock, iflag);
 				cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring,
 								 saveq);
+				spin_lock_irqsave(&phba->hbalock, iflag);
+			}
 			if (cmdiocbp) {
 				/* Call the specified completion routine */
 				if (cmdiocbp->iocb_cmpl) {
@@ -13070,13 +13093,11 @@ lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
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
@@ -13086,6 +13107,7 @@ lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
 		return NULL;
 	}
 
+	spin_lock_irqsave(&pring->ring_lock, iflags);
 	/* Put the iocb back on the txcmplq */
 	lpfc_sli_ringtxcmpl_put(phba, pring, cmdiocbq);
 	spin_unlock_irqrestore(&pring->ring_lock, iflags);
@@ -13856,9 +13878,9 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
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
-- 
2.20.1



