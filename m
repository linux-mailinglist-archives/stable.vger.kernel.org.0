Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D16812EBC7
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbgABWMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:12:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727374AbgABWME (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:12:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA90521835;
        Thu,  2 Jan 2020 22:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003124;
        bh=OiT+WmO8Wve8OpONx14Vr1EhdbL7GD6nrzUZul1vrqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNs+1GK2nRusvrsf8pjcC1VFBMmQb3mY0Ms5dlXdQJFXBViTu9FUIJQxugKYatmah
         qiSiacvGUa8mizNkzgazgLgVKu7MetK+8zpKpeuBrVYwbB8JIwwFr81tsO9Xyno8XN
         LxNRDmnTUyYISxWyzkJ089955vhlrUhhkFe5oaiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 003/191] scsi: lpfc: Fix spinlock_irq issues in lpfc_els_flush_cmd()
Date:   Thu,  2 Jan 2020 23:04:45 +0100
Message-Id: <20200102215830.223956798@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit d38b4a527fe898f859f74a3a43d4308f48ac7855 ]

While reviewing the CT behavior, issues with spinlock_irq were seen. The
driver should be using spinlock_irqsave/irqrestore in the els flush
routine.

Changed to spinlock_irqsave/irqrestore.

Link: https://lore.kernel.org/r/20190922035906.10977-15-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index d5303994bfd6..0052b341587d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7986,20 +7986,22 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 	struct lpfc_sli_ring *pring;
 	struct lpfc_iocbq *tmp_iocb, *piocb;
 	IOCB_t *cmd = NULL;
+	unsigned long iflags = 0;
 
 	lpfc_fabric_abort_vport(vport);
+
 	/*
 	 * For SLI3, only the hbalock is required.  But SLI4 needs to coordinate
 	 * with the ring insert operation.  Because lpfc_sli_issue_abort_iotag
 	 * ultimately grabs the ring_lock, the driver must splice the list into
 	 * a working list and release the locks before calling the abort.
 	 */
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	pring = lpfc_phba_elsring(phba);
 
 	/* Bail out if we've no ELS wq, like in PCI error recovery case. */
 	if (unlikely(!pring)) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		return;
 	}
 
@@ -8037,21 +8039,21 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_unlock(&pring->ring_lock);
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	/* Abort each txcmpl iocb on aborted list and remove the dlist links. */
 	list_for_each_entry_safe(piocb, tmp_iocb, &abort_list, dlist) {
-		spin_lock_irq(&phba->hbalock);
+		spin_lock_irqsave(&phba->hbalock, iflags);
 		list_del_init(&piocb->dlist);
 		lpfc_sli_issue_abort_iotag(phba, pring, piocb);
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 	if (!list_empty(&abort_list))
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "3387 abort list for txq not empty\n");
 	INIT_LIST_HEAD(&abort_list);
 
-	spin_lock_irq(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
@@ -8091,7 +8093,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_unlock(&pring->ring_lock);
-	spin_unlock_irq(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 
 	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &abort_list,
-- 
2.20.1



