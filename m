Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6481C72EC
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 16:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgEFOfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 10:35:02 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:39780 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729075AbgEFOfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 10:35:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588775700; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=31i/QBZ+llMFh/7pc5B6BkBKk7K9R8oLXOgWY0W7TZE=; b=d3o6LrqyqPZQBKvF/gBfFRMhHvmxoh1OM+t+/uJLIFzvsp8TbtKpi1MEV7Y0d5MABYUdzkwg
 0vd0fZq9blBPc5eguxUrgcow5YL/ryprv+E9cGLJQXh+MmUUredh15rVgYkbUUc6nBby0NI4
 ou9dgQk7W1v5KC2bEqSevXCSceg=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb2cb14.7ff7e8760180-smtp-out-n05;
 Wed, 06 May 2020 14:35:00 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EF50CC432C2; Wed,  6 May 2020 14:34:58 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from vbadigan-linux.qualcomm.com (blr-c-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: vbadigan)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C6FF7C433D2;
        Wed,  6 May 2020 14:34:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C6FF7C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=vbadigan@codeaurora.org
From:   Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
To:     adrian.hunter@intel.com, ulf.hansson@linaro.org
Cc:     stummala@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Sarthak Garg <sartgarg@codeaurora.org>,
        <stable@vger.kernel.org>, Baolin Wang <baolin.wang@linaro.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andreas Koop <andreas.koop@zf.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH V1 2/2] mmc: core: Fix recursive locking issue in CQE recovery path
Date:   Wed,  6 May 2020 20:04:03 +0530
Message-Id: <1588775643-18037-3-git-send-email-vbadigan@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1588775643-18037-1-git-send-email-vbadigan@codeaurora.org>
References: <1588775643-18037-1-git-send-email-vbadigan@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sarthak Garg <sartgarg@codeaurora.org>

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

Cc: <stable@vger.kernel.org> # v4.19+
Suggested-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Sarthak Garg <sartgarg@codeaurora.org>
---
 drivers/mmc/core/queue.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 25bee3d..72bef39 100644
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
@@ -131,12 +131,13 @@ static enum blk_eh_timer_return mmc_mq_timed_out(struct request *req,
 
 	spin_lock_irqsave(&mq->lock, flags);
 
-	if (mq->recovery_needed || !mq->use_cqe || host->hsq_enabled)
+	if (mq->recovery_needed || !mq->use_cqe || host->hsq_enabled) {
 		ret = BLK_EH_RESET_TIMER;
-	else
+		spin_unlock_irqrestore(&mq->lock, flags);
+	} else {
+		spin_unlock_irqrestore(&mq->lock, flags);
 		ret = mmc_cqe_timed_out(req);
-
-	spin_unlock_irqrestore(&mq->lock, flags);
+	}
 
 	return ret;
 }
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc., is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
