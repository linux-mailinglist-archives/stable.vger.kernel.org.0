Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE49FED10
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfKPPlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:41:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:45186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728028AbfKPPlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:53 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6018720803;
        Sat, 16 Nov 2019 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918911;
        bh=a+0kLyKi13XHKQWKFP5sMWjOl+MRNzFHvGBwZi2Kk5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FiFMmquWhpIGZdht5fJMMntcfD1F2y9WrpmJfOA1LIUyuxWa6TlGCX8zsCyzQ7hZ0
         4G8/HgJjg7vid9uXvSYeabE6EIevVRt2T5Vdqlv/UZisMxX3jbCh0n3RJVNpSbR3qX
         mEqthgxKmdavxcL64vcliMcABjLIxAXcHbaLac+U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 035/237] scsi: hisi_sas: Fix the race between IO completion and timeout for SMP/internal IO
Date:   Sat, 16 Nov 2019 10:37:50 -0500
Message-Id: <20191116154113.7417-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 584f53fe5f529d877968c711a095923c1ed12307 ]

If SMP/internal IO times out, we will possibly free the task immediately.

However if the IO actually completes at the same time, the IO completion
may refer to task which has been freed.

So to solve the issue, flush the tasklet to finish IO completion before
free'ing slot/task.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 55 ++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e9747379384b2..d4a2625a44232 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -955,8 +955,7 @@ static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 
 static void hisi_sas_task_done(struct sas_task *task)
 {
-	if (!del_timer(&task->slow_task->timer))
-		return;
+	del_timer(&task->slow_task->timer);
 	complete(&task->slow_task->completion);
 }
 
@@ -965,13 +964,17 @@ static void hisi_sas_tmf_timedout(struct timer_list *t)
 	struct sas_task_slow *slow = from_timer(slow, t, timer);
 	struct sas_task *task = slow->task;
 	unsigned long flags;
+	bool is_completed = true;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
-	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+		is_completed = false;
+	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	complete(&task->slow_task->completion);
+	if (!is_completed)
+		complete(&task->slow_task->completion);
 }
 
 #define TASK_TIMEOUT 20
@@ -1022,10 +1025,18 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 				struct hisi_sas_slot *slot = task->lldd_task;
+				struct hisi_sas_cq *cq =
+					&hisi_hba->cq[slot->dlvry_queue];
 
 				dev_err(dev, "abort tmf: TMF task timeout and not done\n");
-				if (slot)
+				if (slot) {
+					/*
+					 * flush tasklet to avoid free'ing task
+					 * before using task in IO completion
+					 */
+					tasklet_kill(&cq->tasklet);
 					slot->task = NULL;
+				}
 
 				goto ex_err;
 			} else
@@ -1401,6 +1412,17 @@ static int hisi_sas_abort_task(struct sas_task *task)
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
+		struct hisi_sas_slot *slot = task->lldd_task;
+		struct hisi_sas_cq *cq;
+
+		if (slot) {
+			/*
+			 * flush tasklet to avoid free'ing task
+			 * before using task in IO completion
+			 */
+			cq = &hisi_hba->cq[slot->dlvry_queue];
+			tasklet_kill(&cq->tasklet);
+		}
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		rc = TMF_RESP_FUNC_COMPLETE;
 		goto out;
@@ -1456,12 +1478,19 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		/* SMP */
 		struct hisi_sas_slot *slot = task->lldd_task;
 		u32 tag = slot->idx;
+		struct hisi_sas_cq *cq = &hisi_hba->cq[slot->dlvry_queue];
 
 		rc = hisi_sas_internal_task_abort(hisi_hba, device,
 			     HISI_SAS_INT_ABT_CMD, tag);
 		if (((rc < 0) || (rc == TMF_RESP_FUNC_FAILED)) &&
-					task->lldd_task)
-			hisi_sas_do_release_task(hisi_hba, task, slot);
+					task->lldd_task) {
+			/*
+			 * flush tasklet to avoid free'ing task
+			 * before using task in IO completion
+			 */
+			tasklet_kill(&cq->tasklet);
+			slot->task = NULL;
+		}
 	}
 
 out:
@@ -1827,9 +1856,17 @@ hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 			struct hisi_sas_slot *slot = task->lldd_task;
-
-			if (slot)
+			struct hisi_sas_cq *cq =
+				&hisi_hba->cq[slot->dlvry_queue];
+
+			if (slot) {
+				/*
+				 * flush tasklet to avoid free'ing task
+				 * before using task in IO completion
+				 */
+				tasklet_kill(&cq->tasklet);
 				slot->task = NULL;
+			}
 			dev_err(dev, "internal task abort: timeout and not done.\n");
 			res = -EIO;
 			goto exit;
-- 
2.20.1

