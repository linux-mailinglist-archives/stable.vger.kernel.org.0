Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9B837D24F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241544AbhELSI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352180AbhELSCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B09C61419;
        Wed, 12 May 2021 18:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842497;
        bh=nZ3xs04dmmmhOapml98ay2ckOl1UtqKduBUT1KkBBwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Icu80mYEZ9aRZVSO2bIqSWRpX8f1DTXHWNw7WG2DAdHOZb3/DzWANufgPSGMLjTjh
         +0ytMkelw6YKt2CaxozPUf9jeXVrOWS8PXr/2FG9CS+/bygR7Rkm4foVl+pufeDgUN
         X6b7KjFA+ajBSeShoWNf1m2wCylk3p3OkYD4R+137+5bTa6YnXOnoAQOZ5dKuEVszU
         w8KhSsbFdjZ7kupctKLoqjMkxqT1nYoJGU/eC/bmhUxEfJSTvEQivwoJyNe7KoYAk+
         e1ZsoC/RZuxrs8ti4hWtRn/OjRIAEGBOuNiyiQroRSQEjwpsjU3S+sEmSVeDkzcyBn
         5/uV5zlufmBMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 22/37] scsi: lpfc: Fix illegal memory access on Abort IOCBs
Date:   Wed, 12 May 2021 14:00:49 -0400
Message-Id: <20210512180104.664121-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index fa1a714a78f0..cefaf0ec69ca 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11811,13 +11811,20 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
 			   lpfc_ctx_cmd ctx_cmd)
 {
 	struct lpfc_io_buf *lpfc_cmd;
+	IOCB_t *icmd = NULL;
 	int rc = 1;
 
 	if (!iocbq || iocbq->vport != vport)
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

