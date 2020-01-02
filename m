Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F7712EBC9
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgABWMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:51138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbgABWML (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:12:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DBE121835;
        Thu,  2 Jan 2020 22:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003131;
        bh=UaSWdl5NAmEagx4muM7QupwMugM/lWzMusOjB/JUZQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhvXkF6/V9ODR927GySem0KDc7jEYdnIPzyCPFMtiWPTefHLUulOBc/NMWAN29zYB
         sKHJ8vy3hsSp/JCF/bHiMsROYCOrPyNtMttW/gg0god4jMk2sEvLYHQe6Jrx2nkNsF
         lGBE3rCvuS7rEe2AOvF7JfBrjCBabnzYNZIMn5/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/191] scsi: lpfc: Fix locking on mailbox command completion
Date:   Thu,  2 Jan 2020 23:04:48 +0100
Message-Id: <20200102215830.496052424@linuxfoundation.org>
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

[ Upstream commit 07b8582430370097238b589f4e24da7613ca6dd3 ]

Symptoms were seen of the driver not having valid data for mailbox
commands. After debugging, the following sequence was found:

The driver maintains a port-wide pointer of the mailbox command that is
currently in execution. Once finished, the port-wide pointer is cleared
(done in lpfc_sli4_mq_release()). The next mailbox command issued will set
the next pointer and so on.

The mailbox response data is only copied if there is a valid port-wide
pointer.

In the failing case, it was seen that a new mailbox command was being
attempted in parallel with the completion.  The parallel path was seeing
the mailbox no long in use (flag check under lock) and thus set the port
pointer.  The completion path had cleared the active flag under lock, but
had not touched the port pointer.  The port pointer is cleared after the
lock is released. In this case, the completion path cleared the just-set
value by the parallel path.

Fix by making the calls that clear mbox state/port pointer while under
lock.  Also slightly cleaned up the error path.

Link: https://lore.kernel.org/r/20190922035906.10977-8-jsmart2021@gmail.com
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5ed4219675eb..e847244dfde3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13161,13 +13161,19 @@ send_current_mbox:
 	phba->sli.sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 	/* Setting active mailbox pointer need to be in sync to flag clear */
 	phba->sli.mbox_active = NULL;
+	if (bf_get(lpfc_trailer_consumed, mcqe))
+		lpfc_sli4_mq_release(phba->sli4_hba.mbx_wq);
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	/* Wake up worker thread to post the next pending mailbox command */
 	lpfc_worker_wake_up(phba);
+	return workposted;
+
 out_no_mqe_complete:
+	spin_lock_irqsave(&phba->hbalock, iflags);
 	if (bf_get(lpfc_trailer_consumed, mcqe))
 		lpfc_sli4_mq_release(phba->sli4_hba.mbx_wq);
-	return workposted;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+	return false;
 }
 
 /**
-- 
2.20.1



