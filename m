Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4F611B79C
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbfLKQJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:09:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731059AbfLKPML (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0072B2465B;
        Wed, 11 Dec 2019 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077130;
        bh=fkFoiEdrVja6Mpq5ViDVq4zEJINrqbJJda2zWCpOQtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzXyuSA3fF57Ux2Kgr+t67ckR934BLErqdPhMh+bVB1Oegr3i1SiREXE/Zr+OMnB7
         tH93302kiSbGfDQ5hIW2e9XK7y0kdU7gi/KQWNSUqN+1sZNCT4EjCroktHWAOYuGKY
         lnB6JsBtQdGCqMd6WnOqqP194Obu1g+k/hIIqQT4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Zhangguanghui <zhang.guanghui@h3c.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 018/134] scsi: lpfc: Fix hardlockup in lpfc_abort_handler
Date:   Wed, 11 Dec 2019 10:09:54 -0500
Message-Id: <20191211151150.19073-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 91a52b617cdb8bf6d298892101c061d438b84a19 ]

In lpfc_abort_handler, the lock acquire order is hbalock (irqsave),
buf_lock (irq) and ring_lock (irq).  The issue is that in two places the
locks are released out of order - the buf_lock and the hbalock - resulting
in the cpu preemption/lock flags getting restored out of order and
deadlocking the cpu.

Fix the unlock order by fully releasing the hbalocks as well.

CC: Zhangguanghui <zhang.guanghui@h3c.com>
Link: https://lore.kernel.org/r/20191018211832.7917-7-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 6822cd9ff8f1e..68b31b27fa057 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4843,20 +4843,21 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 		ret_val = __lpfc_sli_issue_iocb(phba, LPFC_FCP_RING,
 						abtsiocb, 0);
 	}
-	/* no longer need the lock after this point */
-	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	if (ret_val == IOCB_ERROR) {
 		/* Indicate the IO is not being aborted by the driver. */
 		iocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
 		lpfc_cmd->waitq = NULL;
 		spin_unlock(&lpfc_cmd->buf_lock);
+		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_sli_release_iocbq(phba, abtsiocb);
 		ret = FAILED;
 		goto out;
 	}
 
+	/* no longer need the lock after this point */
 	spin_unlock(&lpfc_cmd->buf_lock);
+	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 		lpfc_sli_handle_fast_ring_event(phba,
-- 
2.20.1

