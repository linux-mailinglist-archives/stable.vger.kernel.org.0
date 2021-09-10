Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D04D4061FD
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhIJAoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233493AbhIJAUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF23610E9;
        Fri, 10 Sep 2021 00:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233130;
        bh=TGw4njp5IaZc78R/uUB/LijXLUHq5fkfuYINOfxXf0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=je9ABs+d34/+nTU+2qmEXsRDwpNyB2fBpZ7d/drnUFMeBWHvmCBzOlGQ20m7OoOko
         PtwuuodxCzT4hgUIumgrjehaM1+FVPkrNT5e6ZqjErMRfvKDwkvZ51cqfPwPNKfoL0
         xDBb8+f0gHUKIM1y1bFAwuhNbPo41MyLTQ0I/fypUGDWxWcYKiVlflAnJExs/RRGE0
         o3NVPfvWWdFW2wxGWxC/9WNTtuEd94HUEXG1SSSE2q/A0HXykRW4ujh/HpGUBRq+mi
         TcC9PIfz1X09ES1uiVX41roCKL3lBKTxOFhWRhXDiqzay0da0xUqhbDiVe1jUFPm5O
         s3oC8kvaJxRHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 21/88] scsi: lpfc: Fix possible ABBA deadlock in nvmet_xri_aborted()
Date:   Thu,  9 Sep 2021 20:17:13 -0400
Message-Id: <20210910001820.174272-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 7740b615b6665e47f162e261d805f1bbbac15876 ]

The lpfc_sli4_nvmet_xri_aborted() routine takes out the abts_buf_list_lock
and traverses the buffer contexts to match the xri. Upon match, it then
takes the context lock before potentially removing the context from the
associated buffer list. This violates the lock hierarchy used elsewhere in
the driver of locking context, then the abts_buf_list_lock - thus a
possible deadlock.

Resolve by: after matching, release the abts_buf_list_lock, then take the
context lock, and if to be deleted from the list, retake the
abts_buf_list_lock, maintaining lock hierarchy. This matches same list lock
hierarchy as elsewhere in the driver

Link: https://lore.kernel.org/r/20210730163309.25809-1-jsmart2021@gmail.com
Reported-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index f2d9a3580887..6e3dd0b9bcfa 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1797,19 +1797,22 @@ lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 		if (ctxp->ctxbuf->sglq->sli4_xritag != xri)
 			continue;
 
-		spin_lock(&ctxp->ctxlock);
+		spin_unlock_irqrestore(&phba->sli4_hba.abts_nvmet_buf_list_lock,
+				       iflag);
+
+		spin_lock_irqsave(&ctxp->ctxlock, iflag);
 		/* Check if we already received a free context call
 		 * and we have completed processing an abort situation.
 		 */
 		if (ctxp->flag & LPFC_NVME_CTX_RLS &&
 		    !(ctxp->flag & LPFC_NVME_ABORT_OP)) {
+			spin_lock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
 			list_del_init(&ctxp->list);
+			spin_unlock(&phba->sli4_hba.abts_nvmet_buf_list_lock);
 			released = true;
 		}
 		ctxp->flag &= ~LPFC_NVME_XBUSY;
-		spin_unlock(&ctxp->ctxlock);
-		spin_unlock_irqrestore(&phba->sli4_hba.abts_nvmet_buf_list_lock,
-				       iflag);
+		spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
 
 		rrq_empty = list_empty(&phba->active_rrq_list);
 		ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
-- 
2.30.2

