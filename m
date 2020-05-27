Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46EF1E41E9
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 14:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgE0MU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 08:20:26 -0400
Received: from alexa-out-blr-01.qualcomm.com ([103.229.18.197]:52008 "EHLO
        alexa-out-blr-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726785AbgE0MU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 08:20:26 -0400
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by alexa-out-blr-01.qualcomm.com with ESMTP/TLS/AES256-SHA; 27 May 2020 17:49:42 +0530
Received: from sartgarg-linux.qualcomm.com ([10.206.24.245])
  by ironmsg01-blr.qualcomm.com with ESMTP; 27 May 2020 17:49:29 +0530
Received: by sartgarg-linux.qualcomm.com (Postfix, from userid 2339771)
        id 215AC17B2; Wed, 27 May 2020 17:49:28 +0530 (IST)
From:   Sarthak Garg <sartgarg@codeaurora.org>
To:     stable@vger.kernel.org
Cc:     adrian.hunter@intel.com, ulf.hansson@linaro.org,
        vbadigan@codeaurora.org, stummala@codeaurora.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [4.19.124 V1] mmc: core: Fix recursive locking issue in CQE recovery path
Date:   Wed, 27 May 2020 17:49:02 +0530
Message-Id: <1590581942-24283-1-git-send-email-sartgarg@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 39a22f73744d5baee30b5f134ae2e30b668b66ed ]

Consider the following stack trace

-001|raw_spin_lock_irqsave
-002|mmc_blk_cqe_complete_rq
-003|__blk_mq_complete_request(inline)
-003|blk_mq_complete_request(rq)
-004|mmc_cqe_timed_out(inline)
-004|mmc_mq_timed_out

mmc_mq_timed_out acquires the queue_lock for the first
time. The mmc_blk_cqe_complete_rq function also tries to acquire
the same queue lock resulting in recursive locking where the task
is spinning for the same lock which it has already acquired leading
to watchdog bark.

Fix this issue with the lock only for the required critical section.

Cc: <stable@vger.kernel.org>
Fixes: 1e8e55b67030 ("mmc: block: Add CQE support")
Suggested-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Sarthak Garg <sartgarg@codeaurora.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/1588868135-31783-1-git-send-email-vbadigan@codeaurora.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/queue.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 03f3d9c..2a78816 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -108,7 +108,7 @@ static enum blk_eh_timer_return mmc_cqe_timed_out(struct request *req)
 	case MMC_ISSUE_DCMD:
 		if (host->cqe_ops->cqe_timeout(host, mrq, &recovery_needed)) {
 			if (recovery_needed)
-				__mmc_cqe_recovery_notifier(mq);
+				mmc_cqe_recovery_notifier(mrq);
 			return BLK_EH_RESET_TIMER;
 		}
 		/* The request has gone already */
@@ -125,18 +125,13 @@ static enum blk_eh_timer_return mmc_mq_timed_out(struct request *req,
 	struct request_queue *q = req->q;
 	struct mmc_queue *mq = q->queuedata;
 	unsigned long flags;
-	int ret;
+	bool ignore_tout;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-
-	if (mq->recovery_needed || !mq->use_cqe)
-		ret = BLK_EH_RESET_TIMER;
-	else
-		ret = mmc_cqe_timed_out(req);
-
+	ignore_tout = mq->recovery_needed || !mq->use_cqe;
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	return ret;
+	return ignore_tout ? BLK_EH_RESET_TIMER : mmc_cqe_timed_out(req);
 }
 
 static void mmc_mq_recovery_handler(struct work_struct *work)
-- 
2.7.4

