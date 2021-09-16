Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8369340E830
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350478AbhIPRoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354590AbhIPRkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:40:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263B960F92;
        Thu, 16 Sep 2021 16:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631811081;
        bh=GyzdwaVBYgbHcqMA7R1zjpnhIwLbLBmHuMHm8yOKEqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jka2sRcIsEwn9j6K3PpXUUV54paXUYT5ygObSiiW2wW6Hj1HgptCK8qa2g169eoh9
         1IrSb0hDdGz4kV6j0mppIKcxggEBIBMXHLLyBsnpIsR7DS/ICMi8kufSRUY+tAu8Qf
         5MirorMeI/H23LFAnS0cn4i1mkiCIHXknL4jdpTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 344/432] mmc: core: Avoid hogging the CPU while polling for busy in the I/O err path
Date:   Thu, 16 Sep 2021 18:01:33 +0200
Message-Id: <20210916155822.488371154@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



