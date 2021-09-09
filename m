Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC44B404D24
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243678AbhIIMA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241197AbhIIL5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F914613D5;
        Thu,  9 Sep 2021 11:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187933;
        bh=GyzdwaVBYgbHcqMA7R1zjpnhIwLbLBmHuMHm8yOKEqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URWPdIkVm5RPCVtt9wdiAro7GrlCGU5vvkJnaUz9rW/U6DkPARUZKBm0kktYG4ILy
         F4AOHSO66CPPfLLSHE+kPqNWpRiI5bu8xXUIbXI7sGpJ1/LWqSj4/xjhLDNfWPjcX9
         swZN0Hq0185ZqIBgpoRmeyZGL+aPkGRqFuD5m3SGhQpGvukzqlbBYCRF1WmfwXySJ0
         igpLE3Id3c9klQuRy7erntcrRblo0bUM3JqZCnrkbF4qiAhoA6f4Aag5g0l6sEKKo5
         hU0tYACccszkKKvixRflgq9145/lZ4SWWlFPjrkIf8ZEyRJWZBQ2YkuoR1ddaQ1z6D
         pdDUN/ZvQ6gFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 205/252] mmc: core: Avoid hogging the CPU while polling for busy in the I/O err path
Date:   Thu,  9 Sep 2021 07:40:19 -0400
Message-Id: <20210909114106.141462-205-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 972d5084831dc9ae30f1a4b66cb4a19fb7ba6f09 ]

When mmc_blk_fix_state() sends a CMD12 to try to move the card into the
transfer state, it calls card_busy_detect() to poll for the card's state
with CMD13. This is done without any delays in between the commands being
sent.

Rather than fixing card_busy_detect() in this regards, let's instead
convert into using the common mmc_poll_for_busy(), which also helps us to
avoid open-coding.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/r/20210702134229.357717-2-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c   | 2 +-
 drivers/mmc/core/mmc_ops.c | 4 +++-
 drivers/mmc/core/mmc_ops.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index ce8aed562929..170343411f53 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1636,7 +1636,7 @@ static int mmc_blk_fix_state(struct mmc_card *card, struct request *req)
 
 	mmc_blk_send_stop(card, timeout);
 
-	err = card_busy_detect(card, timeout, NULL);
+	err = mmc_poll_for_busy(card, timeout, false, MMC_BUSY_IO);
 
 	mmc_retune_release(card->host);
 
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 973756ed4016..e2c431c0ce5d 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -435,7 +435,7 @@ static int mmc_busy_cb(void *cb_data, bool *busy)
 	u32 status = 0;
 	int err;
 
-	if (host->ops->card_busy) {
+	if (data->busy_cmd != MMC_BUSY_IO && host->ops->card_busy) {
 		*busy = host->ops->card_busy(host);
 		return 0;
 	}
@@ -457,6 +457,7 @@ static int mmc_busy_cb(void *cb_data, bool *busy)
 		break;
 	case MMC_BUSY_HPI:
 	case MMC_BUSY_EXTR_SINGLE:
+	case MMC_BUSY_IO:
 		break;
 	default:
 		err = -EINVAL;
@@ -521,6 +522,7 @@ int mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
 
 	return __mmc_poll_for_busy(card, timeout_ms, &mmc_busy_cb, &cb_data);
 }
+EXPORT_SYMBOL_GPL(mmc_poll_for_busy);
 
 bool mmc_prepare_busy_cmd(struct mmc_host *host, struct mmc_command *cmd,
 			  unsigned int timeout_ms)
diff --git a/drivers/mmc/core/mmc_ops.h b/drivers/mmc/core/mmc_ops.h
index 41ab4f573a31..ae25ffc2e870 100644
--- a/drivers/mmc/core/mmc_ops.h
+++ b/drivers/mmc/core/mmc_ops.h
@@ -15,6 +15,7 @@ enum mmc_busy_cmd {
 	MMC_BUSY_ERASE,
 	MMC_BUSY_HPI,
 	MMC_BUSY_EXTR_SINGLE,
+	MMC_BUSY_IO,
 };
 
 struct mmc_host;
-- 
2.30.2

