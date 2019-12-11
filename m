Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B3F11B339
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388046AbfLKPfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733014AbfLKPfN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C94222B48;
        Wed, 11 Dec 2019 15:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078513;
        bh=gHhxdOEPsDgrAoYzAJyWljRQuBQlifYqUWUHEAQZoCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6v4ILfeYfMDv42A0s2ZWC/qHVxVcbLd1s4n97JdxnBPJJHDSbhxyS9rKxdJWkAe6
         gAWB7drvuO8edTSsJP0Dt4lNwTpZPFvBiYh1P9Rf/2A2l2YD/syJOxXNeKwcMD7kEP
         DUzzIQx5Z8I0QPyJE0iAlH2QETMpEZiP5k/B7z40=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/42] scsi: lpfc: Fix locking on mailbox command completion
Date:   Wed, 11 Dec 2019 10:34:30 -0500
Message-Id: <20191211153510.23861-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153510.23861-1-sashal@kernel.org>
References: <20191211153510.23861-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e1e0feb250031..1eb9d5f6cea05 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11962,13 +11962,19 @@ send_current_mbox:
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

