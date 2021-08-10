Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F653E5D04
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242654AbhHJOQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:16:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242268AbhHJOQP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24C20610A7;
        Tue, 10 Aug 2021 14:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604948;
        bh=X32CSpRw5m3YxVpFqf32TgeBgt7/BOBOoWhxI/BFt7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKN3U20vDGOhrNIMRTl/0oFa3Q3zxmqnlQelQyY/Rujf7GeXUyfy+m2iwmWOQT1BV
         hVWHXae7kVApaA/ZHHVPqF5gvl43laOVE3ErBQjAJrIOr5lS5fYtOgCYwAX0INiAVN
         7+FSOmK4IJlvWNFvHdQy5IV+sVp2HG3EYl9kbJywCLhLANX7wlNFHZBOIC+6lqZ4vL
         ijtrHHU3ERVFqxNEyrpY7NrdQHro5K6ndXBsu9+607QkZ9ZgyFVztTKa2T2NEtXEyR
         FO5vLwZXQct4c5QF5ILJCyQbZpcEvKRXZ1HFmAIZDEVwsewfzhg+rVNMWDHxsCY9qX
         5HmrxlXcXuV0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Pylypiv <ipylypiv@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/20] scsi: pm80xx: Fix TMF task completion race condition
Date:   Tue, 10 Aug 2021 10:15:25 -0400
Message-Id: <20210810141538.3117707-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141538.3117707-1-sashal@kernel.org>
References: <20210810141538.3117707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit d712d3fb484b7fa8d1d57e9ca6f134bb9d8c18b1 ]

The TMF timeout timer may trigger at the same time when the response from a
controller is being handled. When this happens the SAS task may get freed
before the response processing is finished.

Fix this by calling complete() only when SAS_TASK_STATE_DONE is not set.

A similar race condition was fixed in commit b90cd6f2b905 ("scsi: libsas:
fix a race condition when smp task timeout")

Link: https://lore.kernel.org/r/20210707185945.35559-1-ipylypiv@google.com
Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 39de9a9360d3..c3bb58885033 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -684,8 +684,7 @@ int pm8001_dev_found(struct domain_device *dev)
 
 void pm8001_task_done(struct sas_task *task)
 {
-	if (!del_timer(&task->slow_task->timer))
-		return;
+	del_timer(&task->slow_task->timer);
 	complete(&task->slow_task->completion);
 }
 
@@ -693,9 +692,14 @@ static void pm8001_tmf_timedout(struct timer_list *t)
 {
 	struct sas_task_slow *slow = from_timer(slow, t, timer);
 	struct sas_task *task = slow->task;
+	unsigned long flags;
 
-	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
-	complete(&task->slow_task->completion);
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+		complete(&task->slow_task->completion);
+	}
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 }
 
 #define PM8001_TASK_TIMEOUT 20
@@ -748,13 +752,10 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		}
 		res = -TMF_RESP_FUNC_FAILED;
 		/* Even TMF timed out, return direct. */
-		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				pm8001_dbg(pm8001_ha, FAIL,
-					   "TMF task[%x]timeout.\n",
-					   tmf->tmf);
-				goto ex_err;
-			}
+		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			pm8001_dbg(pm8001_ha, FAIL, "TMF task[%x]timeout.\n",
+				   tmf->tmf);
+			goto ex_err;
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
@@ -834,12 +835,9 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 		wait_for_completion(&task->slow_task->completion);
 		res = TMF_RESP_FUNC_FAILED;
 		/* Even TMF timed out, return direct. */
-		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				pm8001_dbg(pm8001_ha, FAIL,
-					   "TMF task timeout.\n");
-				goto ex_err;
-			}
+		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			pm8001_dbg(pm8001_ha, FAIL, "TMF task timeout.\n");
+			goto ex_err;
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
-- 
2.30.2

