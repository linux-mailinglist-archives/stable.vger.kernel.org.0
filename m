Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E0338A15D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhETJaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232246AbhETJ2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:28:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D17DC613AC;
        Thu, 20 May 2021 09:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502815;
        bh=1mr0cXhJPFdaFsqLosOsaDj+RY4gl869txn+y8di1nU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B54K2gLia+ihqL/nRusPtuRDhrXXxU1eTHZqy4U3mMZWVZ4Vgi2yRfDWO5mgASoSA
         BsS96EPvUSLAJfFdJIm5Mj6toeyhcGLuD+nkqFzK/PN6+M6+HjigTh+glANPjdPWHt
         rdxFyIgUxUYVV8pCgSPLahSV3tjiYaXLuVeB5Rs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/47] scsi: lpfc: Fix illegal memory access on Abort IOCBs
Date:   Thu, 20 May 2021 11:22:24 +0200
Message-Id: <20210520092054.394672939@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit e1364711359f3ced054bda9920477c8bf93b74c5 ]

In devloss timer handler and in backend calls to terminate remote port I/O,
there is logic to walk through all active IOCBs and validate them to
potentially trigger an abort request. This logic is causing illegal memory
accesses which leads to a crash. Abort IOCBs, which may be on the list, do
not have an associated lpfc_io_buf struct. The driver is trying to map an
lpfc_io_buf struct on the IOCB and which results in a bogus address thus
the issue.

Fix by skipping over ABORT IOCBs (CLOSE IOCBs are ABORTS that don't send
ABTS) in the IOCB scan logic.

Link: https://lore.kernel.org/r/20210421234433.102079-1-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3e5c0718555a..bf171ef61abd 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11590,13 +11590,20 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
 			   lpfc_ctx_cmd ctx_cmd)
 {
 	struct lpfc_io_buf *lpfc_cmd;
+	IOCB_t *icmd = NULL;
 	int rc = 1;
 
 	if (iocbq->vport != vport)
 		return rc;
 
-	if (!(iocbq->iocb_flag &  LPFC_IO_FCP) ||
-	    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ))
+	if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+	    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ) ||
+	      iocbq->iocb_flag & LPFC_DRIVER_ABORTED)
+		return rc;
+
+	icmd = &iocbq->iocb;
+	if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
+	    icmd->ulpCommand == CMD_CLOSE_XRI_CN)
 		return rc;
 
 	lpfc_cmd = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
-- 
2.30.2



