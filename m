Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C1537D2CE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbhELSNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:13:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353159AbhELSHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:07:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64C9161584;
        Wed, 12 May 2021 18:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842673;
        bh=OUXgQPOul0LGXHwCGz9+Aw+A1jRye/IUFReGmuswS2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmVnjbK7ea46p+orOFslRlO+BuAvfdH0owB61XMPfMnCSvZlpkZT4bsc0ii28s24I
         RfDWus09JZoiOqwdqX3QPm/y9qtyzWTkUVhwFdL+nRlz9pZXfFxJhgdg4LNxJymYZH
         1U0T/m/NvF2Iw8PdWYD7ya81c+U1380hMLF4pTI194oOwo0ip0KxzlkWX57IM8bH9X
         nwZnESgD3JYGzlZmJjuLOOYHmX7RvkJiLYdiKyj1H/RnfcasLNWQUINFtHIkUWpYDk
         YvzawIe4EKsEajcGjWllFlpFWM8+xOuUaX1ORyARbL/cOdaABODf8vMBUV511rBJZ7
         4XVYYbn15dMww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/23] scsi: lpfc: Fix illegal memory access on Abort IOCBs
Date:   Wed, 12 May 2021 14:03:58 -0400
Message-Id: <20210512180408.665338-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180408.665338-1-sashal@kernel.org>
References: <20210512180408.665338-1-sashal@kernel.org>
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
index b9857d7b224f..d3a54178bfe1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11341,13 +11341,20 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
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

