Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACD3404D27
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243931AbhIIMA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237100AbhIIL5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 727FC613A5;
        Thu,  9 Sep 2021 11:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187936;
        bh=WDaXINiMYnSPoVIWWMbXLKEYHtBosDCawATmgnV4R7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sd3uahxjC5SkdUojU1h4M3cjjPDFrdhaf+A85dsEkrmwP5KhplLf0wMtdvlW34M29
         cA7Hp5pNFJaY/ET2bSMXE6cCHhSIOHBu19i80FnfDWmuhoTslEbYpf/DEt/BZbIBoc
         estddQZeuvW0gB3TP1AD/m/1qfr9XUYy0ZTrOsSLob5/JCV+LnyneoiZOix/r9Xz2c
         CklNlXTHaLQNgoi4Rz4Xxf/IYYAzuHZ+p3vmBcXaqYPwX+McIcfi8g0MUbnrqJMJtP
         8IcijlsZeQEBaPWxZPKlDr4Ky4lNe9n1CB/9ggT7/6jmTH01BXYaJ4qUEa2gY5//VC
         QazRz7d4DUSPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 207/252] mmc: core: Avoid hogging the CPU while polling for busy after I/O writes
Date:   Thu,  9 Sep 2021 07:40:21 -0400
Message-Id: <20210909114106.141462-207-sashal@kernel.org>
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

[ Upstream commit 6966e6094c6d594044ef1b740dd827e05881331c ]

When mmc_blk_card_busy() calls card_busy_detect() to poll for the card's
state with CMD13, this is done without any delays in between the commands
being sent.

Rather than fixing card_busy_detect() in this regards, let's instead
convert into using the common __mmc_poll_for_busy(), which also helps us to
avoid open-coding.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/r/20210702134229.357717-4-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c   | 69 ++++++++++++++++----------------------
 drivers/mmc/core/mmc_ops.c |  1 +
 2 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index c30d0ab15539..a9ad9f5fa949 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -98,6 +98,11 @@ static int max_devices;
 static DEFINE_IDA(mmc_blk_ida);
 static DEFINE_IDA(mmc_rpmb_ida);
 
+struct mmc_blk_busy_data {
+	struct mmc_card *card;
+	u32 status;
+};
+
 /*
  * There is one mmc_blk_data per slot.
  */
@@ -417,42 +422,6 @@ static int mmc_blk_ioctl_copy_to_user(struct mmc_ioc_cmd __user *ic_ptr,
 	return 0;
 }
 
-static int card_busy_detect(struct mmc_card *card, unsigned int timeout_ms,
-			    u32 *resp_errs)
-{
-	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
-	int err = 0;
-	u32 status;
-
-	do {
-		bool done = time_after(jiffies, timeout);
-
-		err = __mmc_send_status(card, &status, 5);
-		if (err) {
-			dev_err(mmc_dev(card->host),
-				"error %d requesting status\n", err);
-			return err;
-		}
-
-		/* Accumulate any response error bits seen */
-		if (resp_errs)
-			*resp_errs |= status;
-
-		/*
-		 * Timeout if the device never becomes ready for data and never
-		 * leaves the program state.
-		 */
-		if (done) {
-			dev_err(mmc_dev(card->host),
-				"Card stuck in wrong state! %s status: %#x\n",
-				 __func__, status);
-			return -ETIMEDOUT;
-		}
-	} while (!mmc_ready_for_data(status));
-
-	return err;
-}
-
 static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 			       struct mmc_blk_ioc_data *idata)
 {
@@ -1852,28 +1821,48 @@ static inline bool mmc_blk_rq_error(struct mmc_blk_request *brq)
 	       brq->data.error || brq->cmd.resp[0] & CMD_ERRORS;
 }
 
+static int mmc_blk_busy_cb(void *cb_data, bool *busy)
+{
+	struct mmc_blk_busy_data *data = cb_data;
+	u32 status = 0;
+	int err;
+
+	err = mmc_send_status(data->card, &status);
+	if (err)
+		return err;
+
+	/* Accumulate response error bits. */
+	data->status |= status;
+
+	*busy = !mmc_ready_for_data(status);
+	return 0;
+}
+
 static int mmc_blk_card_busy(struct mmc_card *card, struct request *req)
 {
 	struct mmc_queue_req *mqrq = req_to_mmc_queue_req(req);
-	u32 status = 0;
+	struct mmc_blk_busy_data cb_data;
 	int err;
 
 	if (mmc_host_is_spi(card->host) || rq_data_dir(req) == READ)
 		return 0;
 
-	err = card_busy_detect(card, MMC_BLK_TIMEOUT_MS, &status);
+	cb_data.card = card;
+	cb_data.status = 0;
+	err = __mmc_poll_for_busy(card, MMC_BLK_TIMEOUT_MS, &mmc_blk_busy_cb,
+				  &cb_data);
 
 	/*
 	 * Do not assume data transferred correctly if there are any error bits
 	 * set.
 	 */
-	if (status & mmc_blk_stop_err_bits(&mqrq->brq)) {
+	if (cb_data.status & mmc_blk_stop_err_bits(&mqrq->brq)) {
 		mqrq->brq.data.bytes_xfered = 0;
 		err = err ? err : -EIO;
 	}
 
 	/* Copy the exception bit so it will be seen later on */
-	if (mmc_card_mmc(card) && status & R1_EXCEPTION_EVENT)
+	if (mmc_card_mmc(card) && cb_data.status & R1_EXCEPTION_EVENT)
 		mqrq->brq.cmd.resp[0] |= R1_EXCEPTION_EVENT;
 
 	return err;
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index e2c431c0ce5d..90d213a2203f 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -510,6 +510,7 @@ int __mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__mmc_poll_for_busy);
 
 int mmc_poll_for_busy(struct mmc_card *card, unsigned int timeout_ms,
 		      bool retry_crc_err, enum mmc_busy_cmd busy_cmd)
-- 
2.30.2

