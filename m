Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85EB406418
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhIJAmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhIJARm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1B22610E9;
        Fri, 10 Sep 2021 00:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232992;
        bh=TGw4njp5IaZc78R/uUB/LijXLUHq5fkfuYINOfxXf0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwRD27Oe3vInMWnMAGDEn9zFdli1V2UEPsYcxD2Sj7YBRoKsk/SUxHgJXtcOz1s/5
         lN9D6lGt0hRXQ4dSDeiCEoU8hLbOGXbWeFi/Tt0PQfbX3zLOXul3NCZ8tAfy+ooFEh
         d05PaQrv8Z7yj0Sk0TTb9f/8nTZmI8bqyKdjWo787ZOz23hOh6RVXLOihw0wMz4w3R
         xVlxcHdlGQFUOjk9YvOkru7NlKDvHmDn+b9bbjeDrUMQvYBsclJdCN31IIqTmLxMhd
         /BPtxfVQ2ToMHonWgskuxpxCKJsh+3lGmhwCeKano2ONbb8jB8rgNDVXPnYs77IwVM
         Iu2jUs6ssWyTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 25/99] scsi: lpfc: Fix possible ABBA deadlock in nvmet_xri_aborted()
Date:   Thu,  9 Sep 2021 20:14:44 -0400
Message-Id: <20210910001558.173296-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
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

