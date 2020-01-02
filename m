Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6656212F18E
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgABWLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:11:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727189AbgABWLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:11:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57875222C3;
        Thu,  2 Jan 2020 22:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003097;
        bh=fTwjluxhBBmv3GW4XjlrlfB97qurdemDcrxQbQXNCUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEkb+DV+XfksJIZ0wZD8Lc5923gw62S+uHd4A+HiNpZhzp04x7RFAQ6e3QUi4+Gbf
         TnTtoh8ps4/VEem7UjurtJbco6O2dkxT9EzX7sqc8UaS+nB1Htd3+LwLHCiaZXAgzm
         3mSlxLVbcSpm5V+xee12mKbWlJxoWWrPn9o45gVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhangguanghui <zhang.guanghui@h3c.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/191] scsi: lpfc: Fix hardlockup in lpfc_abort_handler
Date:   Thu,  2 Jan 2020 23:05:01 +0100
Message-Id: <20200102215831.933817549@linuxfoundation.org>
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
index ad8ef67a1db3..aa82d538a18a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4846,20 +4846,21 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
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



