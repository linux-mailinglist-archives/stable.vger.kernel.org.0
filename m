Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62B01D8348
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732649AbgERSD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732646AbgERSD0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:03:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 236C5207F5;
        Mon, 18 May 2020 18:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825005;
        bh=U8uXab8S/0VqSIOvJlQ4HEIViMdPlfMG23RGCtqDmaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wDTelpptrBtq5gnlNHoijWTmFrb+ndZPw09Ppd7dvBlcArHLNBukBPMbQKH43ifee
         5SnhqxrtrA8LIaPJzsoRfq/oavWYCiTwkmZngrUckpHat3pFIA/CotCaTvQi8olN0l
         QGY7hXAvTRLskOwM9JiAomn2NKLXAG2JIA2jE/oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sahitya Tummala <stummala@codeaurora.org>,
        Sarthak Garg <sartgarg@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 092/194] mmc: core: Fix recursive locking issue in CQE recovery path
Date:   Mon, 18 May 2020 19:36:22 +0200
Message-Id: <20200518173539.460481216@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sarthak Garg <sartgarg@codeaurora.org>

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/queue.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 9edc08685e86d..4d1e468d39823 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -107,7 +107,7 @@ static enum blk_eh_timer_return mmc_cqe_timed_out(struct request *req)
 	case MMC_ISSUE_DCMD:
 		if (host->cqe_ops->cqe_timeout(host, mrq, &recovery_needed)) {
 			if (recovery_needed)
-				__mmc_cqe_recovery_notifier(mq);
+				mmc_cqe_recovery_notifier(mrq);
 			return BLK_EH_RESET_TIMER;
 		}
 		/* No timeout (XXX: huh? comment doesn't make much sense) */
@@ -125,18 +125,13 @@ static enum blk_eh_timer_return mmc_mq_timed_out(struct request *req,
 	struct request_queue *q = req->q;
 	struct mmc_queue *mq = q->queuedata;
 	unsigned long flags;
-	int ret;
+	bool ignore_tout;
 
 	spin_lock_irqsave(&mq->lock, flags);
-
-	if (mq->recovery_needed || !mq->use_cqe)
-		ret = BLK_EH_RESET_TIMER;
-	else
-		ret = mmc_cqe_timed_out(req);
-
+	ignore_tout = mq->recovery_needed || !mq->use_cqe;
 	spin_unlock_irqrestore(&mq->lock, flags);
 
-	return ret;
+	return ignore_tout ? BLK_EH_RESET_TIMER : mmc_cqe_timed_out(req);
 }
 
 static void mmc_mq_recovery_handler(struct work_struct *work)
-- 
2.20.1



