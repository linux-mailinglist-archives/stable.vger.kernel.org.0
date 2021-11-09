Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B7944B61F
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343848AbhKIWZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:25:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344215AbhKIWXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:23:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26F206135E;
        Tue,  9 Nov 2021 22:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496321;
        bh=AXO3zH6C2VtGKd3F2FVXvz1l6znj8sXYEhNKBgKeo/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUSw345zy4TirZsujGIrGwp/r93mL/gUEkvGUi7xGGZ2UyLrDwhogOtadL2UE7blg
         wpx8CsfOCNGVPXQMNHA5NZn8wSsGdhNLa/1EfpkfD+PvG2gl4cTPeA9I0vaEkpBmvw
         spgcgsRGCrg8aOyC1BgfE1G+b7fcmDlKqzsJYiTrf27FgaPLiFSE3KYtz6kvUSJZ7m
         ML1PNsqQBPMNLaXmL/VsXPcoI7BxOd+uB4/sYfOLh5rtm7o0cp2p6bUeLDOOZvRBY2
         wcDT7Z5z16r4sD4BkSdx3blhY0FqexsZVQH3ez4J8A84Aw4qkYsd8Obyxuy+H5uWFB
         eay1A0BjLkeAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, james.smart@avagotech.com,
        dick.kennedy@avagotech.com, JBottomley@odin.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 69/82] scsi: lpfc: Fix link down processing to address NULL pointer dereference
Date:   Tue,  9 Nov 2021 17:16:27 -0500
Message-Id: <20211109221641.1233217-69-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 1854f53ccd88ad4e7568ddfafafffe71f1ceb0a6 ]

If an FC link down transition while PLOGIs are outstanding to fabric well
known addresses, outstanding ABTS requests may result in a NULL pointer
dereference. Driver unload requests may hang with repeated "2878" log
messages.

The Link down processing results in ABTS requests for outstanding ELS
requests. The Abort WQEs are sent for the ELSs before the driver had set
the link state to down. Thus the driver is sending the Abort with the
expectation that an ABTS will be sent on the wire. The Abort request is
stalled waiting for the link to come up. In some conditions the driver may
auto-complete the ELSs thus if the link does come up, the Abort completions
may reference an invalid structure.

Fix by ensuring that Abort set the flag to avoid link traffic if issued due
to conditions where the link failed.

Link: https://lore.kernel.org/r/20211020211417.88754-7-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d0593291b21c9..193069341e46b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12404,17 +12404,17 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abtsiocbp->hba_wqidx = cmdiocb->hba_wqidx;
-	if (cmdiocb->iocb_flag & LPFC_IO_FCP) {
-		abtsiocbp->iocb_flag |= LPFC_IO_FCP;
-		abtsiocbp->iocb_flag |= LPFC_USE_FCPWQIDX;
-	}
+	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
+		abtsiocbp->iocb_flag |= (LPFC_IO_FCP | LPFC_USE_FCPWQIDX);
 	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
 		abtsiocbp->iocb_flag |= LPFC_IO_FOF;
 
-	if (phba->link_state >= LPFC_LINK_UP)
-		iabt->ulpCommand = CMD_ABORT_XRI_CN;
-	else
+	if (phba->link_state < LPFC_LINK_UP ||
+	    (phba->sli_rev == LPFC_SLI_REV4 &&
+	     phba->sli4_hba.link_state.status == LPFC_FC_LA_TYPE_LINK_DOWN))
 		iabt->ulpCommand = CMD_CLOSE_XRI_CN;
+	else
+		iabt->ulpCommand = CMD_ABORT_XRI_CN;
 
 	if (cmpl)
 		abtsiocbp->iocb_cmpl = cmpl;
-- 
2.33.0

