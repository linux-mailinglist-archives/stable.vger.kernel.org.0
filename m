Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143851217A6
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbfLPSFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729867AbfLPSFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:05:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D39482082E;
        Mon, 16 Dec 2019 18:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519543;
        bh=QdyoteWgD7kF0jwwZP6g5VAPMOLvoEu3eqsQsbUZqFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjzq6clJxJiirzcFUJki/E1+vsbqHzTxyIpKtmngxvdHYGNSzOzbGRvOD8paVctf7
         owbjiuYeWEQUpfYRe6D5sd8ZMhbqr3oO+97eLXpzt8czIiopwL6C2CcT1FUNuEFmk9
         9rUZjaPj9Lyr7Fb1tMf/9vwP499pOE2XzpLwWFN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 110/140] scsi: lpfc: Correct code setting non existent bits in sli4 ABORT WQE
Date:   Mon, 16 Dec 2019 18:49:38 +0100
Message-Id: <20191216174816.759103426@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 1c36833d82ff24d0d54215fd956e7cc30fffce54 ]

Driver is setting bits in word 10 of the SLI4 ABORT WQE (the wqid).  The
field was a carry over from a prior SLI revision. The field does not exist
in SLI4, and the action may result in an overlap with future definition of
the WQE.

Remove the setting of WQID in the ABORT WQE.

Also cleaned up WQE field settings - initialize to zero, don't bother to
set fields to zero.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvme.c |  2 --
 drivers/scsi/lpfc/lpfc_sli.c  | 14 +++-----------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 8ee585e453dcf..f73726e55e44d 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1856,7 +1856,6 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	bf_set(abort_cmd_criteria, &abts_wqe->abort_cmd, T_XRI_TAG);
 
 	/* word 7 */
-	bf_set(wqe_ct, &abts_wqe->abort_cmd.wqe_com, 0);
 	bf_set(wqe_cmnd, &abts_wqe->abort_cmd.wqe_com, CMD_ABORT_XRI_CX);
 	bf_set(wqe_class, &abts_wqe->abort_cmd.wqe_com,
 	       nvmereq_wqe->iocb.ulpClass);
@@ -1871,7 +1870,6 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	       abts_buf->iotag);
 
 	/* word 10 */
-	bf_set(wqe_wqid, &abts_wqe->abort_cmd.wqe_com, nvmereq_wqe->hba_wqidx);
 	bf_set(wqe_qosd, &abts_wqe->abort_cmd.wqe_com, 1);
 	bf_set(wqe_lenloc, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_LENLOC_NONE);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 755803ff6cfef..f459fd62e493c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10989,19 +10989,12 @@ lpfc_sli4_abort_nvme_io(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	/* Complete prepping the abort wqe and issue to the FW. */
 	abts_wqe = &abtsiocbp->wqe;
-	bf_set(abort_cmd_ia, &abts_wqe->abort_cmd, 0);
-	bf_set(abort_cmd_criteria, &abts_wqe->abort_cmd, T_XRI_TAG);
-
-	/* Explicitly set reserved fields to zero.*/
-	abts_wqe->abort_cmd.rsrvd4 = 0;
-	abts_wqe->abort_cmd.rsrvd5 = 0;
 
-	/* WQE Common - word 6.  Context is XRI tag.  Set 0. */
-	bf_set(wqe_xri_tag, &abts_wqe->abort_cmd.wqe_com, 0);
-	bf_set(wqe_ctxt_tag, &abts_wqe->abort_cmd.wqe_com, 0);
+	/* Clear any stale WQE contents */
+	memset(abts_wqe, 0, sizeof(union lpfc_wqe));
+	bf_set(abort_cmd_criteria, &abts_wqe->abort_cmd, T_XRI_TAG);
 
 	/* word 7 */
-	bf_set(wqe_ct, &abts_wqe->abort_cmd.wqe_com, 0);
 	bf_set(wqe_cmnd, &abts_wqe->abort_cmd.wqe_com, CMD_ABORT_XRI_CX);
 	bf_set(wqe_class, &abts_wqe->abort_cmd.wqe_com,
 	       cmdiocb->iocb.ulpClass);
@@ -11016,7 +11009,6 @@ lpfc_sli4_abort_nvme_io(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	       abtsiocbp->iotag);
 
 	/* word 10 */
-	bf_set(wqe_wqid, &abts_wqe->abort_cmd.wqe_com, cmdiocb->hba_wqidx);
 	bf_set(wqe_qosd, &abts_wqe->abort_cmd.wqe_com, 1);
 	bf_set(wqe_lenloc, &abts_wqe->abort_cmd.wqe_com, LPFC_WQE_LENLOC_NONE);
 
-- 
2.20.1



