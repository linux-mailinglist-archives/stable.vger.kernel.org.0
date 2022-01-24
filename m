Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18091499477
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389529AbiAXUmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:42:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40348 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357631AbiAXUjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:39:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 270ABB80CCF;
        Mon, 24 Jan 2022 20:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5807EC340E5;
        Mon, 24 Jan 2022 20:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056769;
        bh=GZb47qHmSv7cX/4Xhz3PXUcBlwC+TvbzP2UWzUtTigY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0rnTyjbzVZwNwXWA9UPmjv6C4dsyINXAac9gGhxVUMPQ7H4WDftKJvase7bIIbwJ
         K8UkAorPqs9HXyt3+JGXOvmcna7yMgpyazEZ0nW61v2oGgxk8B+H/zyQRZHsKEKiZq
         zk/TSMrBdwRoSuQ+3UupT37gqT6uF2uz3RpTgX+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 594/846] mmc: mtk-sd: Use readl_poll_timeout instead of open-coded polling
Date:   Mon, 24 Jan 2022 19:41:51 +0100
Message-Id: <20220124184121.529162563@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit ffaea6ebfe9ce06ebb3a54811a47688f2b0893cd ]

Replace all instances of open-coded while loops for polling registers
with calls to readl_poll_timeout() and, while at it, also fix some
possible infinite loop instances.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20211216125748.179602-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 64 ++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 25 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index 9e6dab7e34242..1ac92015992ed 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -628,12 +628,11 @@ static void msdc_reset_hw(struct msdc_host *host)
 	u32 val;
 
 	sdr_set_bits(host->base + MSDC_CFG, MSDC_CFG_RST);
-	while (readl(host->base + MSDC_CFG) & MSDC_CFG_RST)
-		cpu_relax();
+	readl_poll_timeout(host->base + MSDC_CFG, val, !(val & MSDC_CFG_RST), 0, 0);
 
 	sdr_set_bits(host->base + MSDC_FIFOCS, MSDC_FIFOCS_CLR);
-	while (readl(host->base + MSDC_FIFOCS) & MSDC_FIFOCS_CLR)
-		cpu_relax();
+	readl_poll_timeout(host->base + MSDC_FIFOCS, val,
+			   !(val & MSDC_FIFOCS_CLR), 0, 0);
 
 	val = readl(host->base + MSDC_INT);
 	writel(val, host->base + MSDC_INT);
@@ -806,8 +805,9 @@ static void msdc_gate_clock(struct msdc_host *host)
 	clk_disable_unprepare(host->h_clk);
 }
 
-static void msdc_ungate_clock(struct msdc_host *host)
+static int msdc_ungate_clock(struct msdc_host *host)
 {
+	u32 val;
 	int ret;
 
 	clk_prepare_enable(host->h_clk);
@@ -817,11 +817,11 @@ static void msdc_ungate_clock(struct msdc_host *host)
 	ret = clk_bulk_prepare_enable(MSDC_NR_CLOCKS, host->bulk_clks);
 	if (ret) {
 		dev_err(host->dev, "Cannot enable pclk/axi/ahb clock gates\n");
-		return;
+		return ret;
 	}
 
-	while (!(readl(host->base + MSDC_CFG) & MSDC_CFG_CKSTB))
-		cpu_relax();
+	return readl_poll_timeout(host->base + MSDC_CFG, val,
+				  (val & MSDC_CFG_CKSTB), 1, 20000);
 }
 
 static void msdc_set_mclk(struct msdc_host *host, unsigned char timing, u32 hz)
@@ -832,6 +832,7 @@ static void msdc_set_mclk(struct msdc_host *host, unsigned char timing, u32 hz)
 	u32 div;
 	u32 sclk;
 	u32 tune_reg = host->dev_comp->pad_tune_reg;
+	u32 val;
 
 	if (!hz) {
 		dev_dbg(host->dev, "set mclk to 0\n");
@@ -912,8 +913,7 @@ static void msdc_set_mclk(struct msdc_host *host, unsigned char timing, u32 hz)
 	else
 		clk_prepare_enable(clk_get_parent(host->src_clk));
 
-	while (!(readl(host->base + MSDC_CFG) & MSDC_CFG_CKSTB))
-		cpu_relax();
+	readl_poll_timeout(host->base + MSDC_CFG, val, (val & MSDC_CFG_CKSTB), 0, 0);
 	sdr_set_bits(host->base + MSDC_CFG, MSDC_CFG_CKPDN);
 	mmc->actual_clock = sclk;
 	host->mclk = hz;
@@ -1223,13 +1223,13 @@ static bool msdc_cmd_done(struct msdc_host *host, int events,
 static inline bool msdc_cmd_is_ready(struct msdc_host *host,
 		struct mmc_request *mrq, struct mmc_command *cmd)
 {
-	/* The max busy time we can endure is 20ms */
-	unsigned long tmo = jiffies + msecs_to_jiffies(20);
+	u32 val;
+	int ret;
 
-	while ((readl(host->base + SDC_STS) & SDC_STS_CMDBUSY) &&
-			time_before(jiffies, tmo))
-		cpu_relax();
-	if (readl(host->base + SDC_STS) & SDC_STS_CMDBUSY) {
+	/* The max busy time we can endure is 20ms */
+	ret = readl_poll_timeout_atomic(host->base + SDC_STS, val,
+					!(val & SDC_STS_CMDBUSY), 1, 20000);
+	if (ret) {
 		dev_err(host->dev, "CMD bus busy detected\n");
 		host->error |= REQ_CMD_BUSY;
 		msdc_cmd_done(host, MSDC_INT_CMDTMO, mrq, cmd);
@@ -1237,12 +1237,10 @@ static inline bool msdc_cmd_is_ready(struct msdc_host *host,
 	}
 
 	if (mmc_resp_type(cmd) == MMC_RSP_R1B || cmd->data) {
-		tmo = jiffies + msecs_to_jiffies(20);
 		/* R1B or with data, should check SDCBUSY */
-		while ((readl(host->base + SDC_STS) & SDC_STS_SDCBUSY) &&
-				time_before(jiffies, tmo))
-			cpu_relax();
-		if (readl(host->base + SDC_STS) & SDC_STS_SDCBUSY) {
+		ret = readl_poll_timeout_atomic(host->base + SDC_STS, val,
+						!(val & SDC_STS_SDCBUSY), 1, 20000);
+		if (ret) {
 			dev_err(host->dev, "Controller busy detected\n");
 			host->error |= REQ_CMD_BUSY;
 			msdc_cmd_done(host, MSDC_INT_CMDTMO, mrq, cmd);
@@ -1367,6 +1365,8 @@ static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 	    (MSDC_INT_XFER_COMPL | MSDC_INT_DATCRCERR | MSDC_INT_DATTMO
 	     | MSDC_INT_DMA_BDCSERR | MSDC_INT_DMA_GPDCSERR
 	     | MSDC_INT_DMA_PROTECT);
+	u32 val;
+	int ret;
 
 	spin_lock_irqsave(&host->lock, flags);
 	done = !host->data;
@@ -1383,8 +1383,14 @@ static bool msdc_data_xfer_done(struct msdc_host *host, u32 events,
 				readl(host->base + MSDC_DMA_CFG));
 		sdr_set_field(host->base + MSDC_DMA_CTRL, MSDC_DMA_CTRL_STOP,
 				1);
-		while (readl(host->base + MSDC_DMA_CFG) & MSDC_DMA_CFG_STS)
-			cpu_relax();
+
+		ret = readl_poll_timeout_atomic(host->base + MSDC_DMA_CFG, val,
+						!(val & MSDC_DMA_CFG_STS), 1, 20000);
+		if (ret) {
+			dev_dbg(host->dev, "DMA stop timed out\n");
+			return false;
+		}
+
 		sdr_clr_bits(host->base + MSDC_INTEN, data_ints_mask);
 		dev_dbg(host->dev, "DMA stop\n");
 
@@ -2598,7 +2604,11 @@ static int msdc_drv_probe(struct platform_device *pdev)
 	spin_lock_init(&host->lock);
 
 	platform_set_drvdata(pdev, mmc);
-	msdc_ungate_clock(host);
+	ret = msdc_ungate_clock(host);
+	if (ret) {
+		dev_err(&pdev->dev, "Cannot ungate clocks!\n");
+		goto release_mem;
+	}
 	msdc_init_hw(host);
 
 	if (mmc->caps2 & MMC_CAP2_CQE) {
@@ -2757,8 +2767,12 @@ static int __maybe_unused msdc_runtime_resume(struct device *dev)
 {
 	struct mmc_host *mmc = dev_get_drvdata(dev);
 	struct msdc_host *host = mmc_priv(mmc);
+	int ret;
+
+	ret = msdc_ungate_clock(host);
+	if (ret)
+		return ret;
 
-	msdc_ungate_clock(host);
 	msdc_restore_reg(host);
 	return 0;
 }
-- 
2.34.1



