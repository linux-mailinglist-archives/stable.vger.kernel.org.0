Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD7845C473
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347762AbhKXNtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349330AbhKXNrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:47:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED68963345;
        Wed, 24 Nov 2021 13:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758899;
        bh=hwgPGdSwXhDljYWA5K0JK/4tx/RK+X4twvkEiqSPDxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ja9Xmr5TVfTQi/MlLKUX3gsBwQPdC3tuZ3eM6SBmCDlel0xANkVmVPhNPyUhOwb/M
         8GFZll+C+i2nfYYPFStqa1qeeJZsHNDY6QP87LiAT+zAeH/2jGAoebST0iGCbvCBKF
         hZNWaJ0QLX1ZuQ0BSn67IBj6/yIrtZ9tquDBkkzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/279] scsi: lpfc: Fix link down processing to address NULL pointer dereference
Date:   Wed, 24 Nov 2021 12:55:55 +0100
Message-Id: <20211124115721.058135826@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8e689f06afc92..9c1f485952ef7 100644
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



