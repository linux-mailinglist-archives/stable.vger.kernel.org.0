Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6A821063A6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbfKVF4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:56:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbfKVF4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:56:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4D022071B;
        Fri, 22 Nov 2019 05:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402177;
        bh=tvhl9kyVKBPUjlXSbo4Uzz5kMf+FA/S+X+C4Y9Z0N8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElvO9VLvLu27oAFx8Iv60IA7t1gPLWbp9zWD3RJBBiR3FltXUFvdjkzstPnnzKs5k
         t4l/JnRYEdJiLQi1kcD72059JVCoMdGNfCDw6nWt5cTMbOPZyJV1yOiMrknLN+wIYd
         fO7MOCMdwU2XDxk6RspogVbkkB+9kNJEtiJMCyh0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 029/127] mmc: meson-gx: make sure the descriptor is stopped on errors
Date:   Fri, 22 Nov 2019 00:54:07 -0500
Message-Id: <20191122055544.3299-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 18f92bc02f1739b5c4d5b70009fbb7eada45bca3 ]

On errors, if we don't stop the descriptor chain, it may continue to
run and raise IRQ after we have called mmc_request_done(). This is bad
because we won't be able to get cmd anymore and properly deal with the
IRQ.

This patch makes sure the descriptor chain is stopped before
calling mmc_request_done()

Fixes: 79ed05e329c3 ("mmc: meson-gx: add support for descriptor chain mode")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/meson-gx-mmc.c | 73 ++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index 08a55c2e96e1b..53ce1bb83d2c5 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -74,9 +75,11 @@
 #define   CFG_CLK_ALWAYS_ON BIT(18)
 #define   CFG_CHK_DS BIT(20)
 #define   CFG_AUTO_CLK BIT(23)
+#define   CFG_ERR_ABORT BIT(27)
 
 #define SD_EMMC_STATUS 0x48
 #define   STATUS_BUSY BIT(31)
+#define   STATUS_DESC_BUSY BIT(30)
 #define   STATUS_DATI GENMASK(23, 16)
 
 #define SD_EMMC_IRQ_EN 0x4c
@@ -905,6 +908,7 @@ static void meson_mmc_start_cmd(struct mmc_host *mmc, struct mmc_command *cmd)
 
 	cmd_cfg |= FIELD_PREP(CMD_CFG_CMD_INDEX_MASK, cmd->opcode);
 	cmd_cfg |= CMD_CFG_OWNER;  /* owned by CPU */
+	cmd_cfg |= CMD_CFG_ERROR; /* stop in case of error */
 
 	meson_mmc_set_response_bits(cmd, &cmd_cfg);
 
@@ -999,6 +1003,17 @@ static irqreturn_t meson_mmc_irq(int irq, void *dev_id)
 	u32 irq_en, status, raw_status;
 	irqreturn_t ret = IRQ_NONE;
 
+	irq_en = readl(host->regs + SD_EMMC_IRQ_EN);
+	raw_status = readl(host->regs + SD_EMMC_STATUS);
+	status = raw_status & irq_en;
+
+	if (!status) {
+		dev_dbg(host->dev,
+			"Unexpected IRQ! irq_en 0x%08x - status 0x%08x\n",
+			 irq_en, raw_status);
+		return IRQ_NONE;
+	}
+
 	if (WARN_ON(!host) || WARN_ON(!host->cmd))
 		return IRQ_NONE;
 
@@ -1006,22 +1021,18 @@ static irqreturn_t meson_mmc_irq(int irq, void *dev_id)
 
 	cmd = host->cmd;
 	data = cmd->data;
-	irq_en = readl(host->regs + SD_EMMC_IRQ_EN);
-	raw_status = readl(host->regs + SD_EMMC_STATUS);
-	status = raw_status & irq_en;
-
 	cmd->error = 0;
 	if (status & IRQ_CRC_ERR) {
 		dev_dbg(host->dev, "CRC Error - status 0x%08x\n", status);
 		cmd->error = -EILSEQ;
-		ret = IRQ_HANDLED;
+		ret = IRQ_WAKE_THREAD;
 		goto out;
 	}
 
 	if (status & IRQ_TIMEOUTS) {
 		dev_dbg(host->dev, "Timeout - status 0x%08x\n", status);
 		cmd->error = -ETIMEDOUT;
-		ret = IRQ_HANDLED;
+		ret = IRQ_WAKE_THREAD;
 		goto out;
 	}
 
@@ -1046,17 +1057,49 @@ static irqreturn_t meson_mmc_irq(int irq, void *dev_id)
 	/* ack all enabled interrupts */
 	writel(irq_en, host->regs + SD_EMMC_STATUS);
 
+	if (cmd->error) {
+		/* Stop desc in case of errors */
+		u32 start = readl(host->regs + SD_EMMC_START);
+
+		start &= ~START_DESC_BUSY;
+		writel(start, host->regs + SD_EMMC_START);
+	}
+
 	if (ret == IRQ_HANDLED)
 		meson_mmc_request_done(host->mmc, cmd->mrq);
-	else if (ret == IRQ_NONE)
-		dev_warn(host->dev,
-			 "Unexpected IRQ! status=0x%08x, irq_en=0x%08x\n",
-			 raw_status, irq_en);
 
 	spin_unlock(&host->lock);
 	return ret;
 }
 
+static int meson_mmc_wait_desc_stop(struct meson_host *host)
+{
+	int loop;
+	u32 status;
+
+	/*
+	 * It may sometimes take a while for it to actually halt. Here, we
+	 * are giving it 5ms to comply
+	 *
+	 * If we don't confirm the descriptor is stopped, it might raise new
+	 * IRQs after we have called mmc_request_done() which is bad.
+	 */
+	for (loop = 50; loop; loop--) {
+		status = readl(host->regs + SD_EMMC_STATUS);
+		if (status & (STATUS_BUSY | STATUS_DESC_BUSY))
+			udelay(100);
+		else
+			break;
+	}
+
+	if (status & (STATUS_BUSY | STATUS_DESC_BUSY)) {
+		dev_err(host->dev, "Timed out waiting for host to stop\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
 static irqreturn_t meson_mmc_irq_thread(int irq, void *dev_id)
 {
 	struct meson_host *host = dev_id;
@@ -1067,6 +1110,13 @@ static irqreturn_t meson_mmc_irq_thread(int irq, void *dev_id)
 	if (WARN_ON(!cmd))
 		return IRQ_NONE;
 
+	if (cmd->error) {
+		meson_mmc_wait_desc_stop(host);
+		meson_mmc_request_done(host->mmc, cmd->mrq);
+
+		return IRQ_HANDLED;
+	}
+
 	data = cmd->data;
 	if (meson_mmc_bounce_buf_read(data)) {
 		xfer_bytes = data->blksz * data->blocks;
@@ -1107,6 +1157,9 @@ static void meson_mmc_cfg_init(struct meson_host *host)
 	cfg |= FIELD_PREP(CFG_RC_CC_MASK, ilog2(SD_EMMC_CFG_CMD_GAP));
 	cfg |= FIELD_PREP(CFG_BLK_LEN_MASK, ilog2(SD_EMMC_CFG_BLK_SIZE));
 
+	/* abort chain on R/W errors */
+	cfg |= CFG_ERR_ABORT;
+
 	writel(cfg, host->regs + SD_EMMC_CFG);
 }
 
-- 
2.20.1

