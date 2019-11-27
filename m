Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9140110B9CF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfK0U4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730167AbfK0U4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77EA02154A;
        Wed, 27 Nov 2019 20:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888211;
        bh=STG2Hmg0LoPyc4kntgruZckgQ/wfT/uWDxEsXM8w6mI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVTQk8TdnZXI0gvOCbPQChzW8tLrPbT2xHQfMrc2A5BLMIvwKS2o+xkzgihLRITLJ
         G/dIbKj6k5tULBhAOYTc51Ef7pkcZ9+1HG82M4uF42qe+DVmj3eroQCFJFeTBoymA/
         rgIliEDsfo1BGSj1EnHt9FOsD9n8wzu2yZUCPRdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chaotian Jing <chaotian.jing@mediatek.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/306] mmc: mediatek: fill the actual clock for mmc debugfs
Date:   Wed, 27 Nov 2019 21:28:15 +0100
Message-Id: <20191127203118.112603618@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaotian Jing <chaotian.jing@mediatek.com>

[ Upstream commit 56f6cbbed0463f1c78d602b17c315916cc1cd238 ]

as the mmc core layer has the mmc->actual_clock, so fill it
and drop msdc_host->sclk.

Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/mtk-sd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/mtk-sd.c b/drivers/mmc/host/mtk-sd.c
index f171cce5197de..621c914dc5c01 100644
--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -390,7 +390,6 @@ struct msdc_host {
 	struct clk *src_clk_cg; /* msdc source clock control gate */
 	u32 mclk;		/* mmc subsystem clock frequency */
 	u32 src_clk_freq;	/* source clock frequency */
-	u32 sclk;		/* SD/MS bus clock frequency */
 	unsigned char timing;
 	bool vqmmc_enabled;
 	u32 latch_ck;
@@ -635,10 +634,10 @@ static void msdc_set_timeout(struct msdc_host *host, u32 ns, u32 clks)
 
 	host->timeout_ns = ns;
 	host->timeout_clks = clks;
-	if (host->sclk == 0) {
+	if (host->mmc->actual_clock == 0) {
 		timeout = 0;
 	} else {
-		clk_ns  = 1000000000UL / host->sclk;
+		clk_ns  = 1000000000UL / host->mmc->actual_clock;
 		timeout = (ns + clk_ns - 1) / clk_ns + clks;
 		/* in 1048576 sclk cycle unit */
 		timeout = (timeout + (0x1 << 20) - 1) >> 20;
@@ -683,6 +682,7 @@ static void msdc_set_mclk(struct msdc_host *host, unsigned char timing, u32 hz)
 	if (!hz) {
 		dev_dbg(host->dev, "set mclk to 0\n");
 		host->mclk = 0;
+		host->mmc->actual_clock = 0;
 		sdr_clr_bits(host->base + MSDC_CFG, MSDC_CFG_CKPDN);
 		return;
 	}
@@ -761,7 +761,7 @@ static void msdc_set_mclk(struct msdc_host *host, unsigned char timing, u32 hz)
 	while (!(readl(host->base + MSDC_CFG) & MSDC_CFG_CKSTB))
 		cpu_relax();
 	sdr_set_bits(host->base + MSDC_CFG, MSDC_CFG_CKPDN);
-	host->sclk = sclk;
+	host->mmc->actual_clock = sclk;
 	host->mclk = hz;
 	host->timing = timing;
 	/* need because clk changed. */
@@ -772,7 +772,7 @@ static void msdc_set_mclk(struct msdc_host *host, unsigned char timing, u32 hz)
 	 * mmc_select_hs400() will drop to 50Mhz and High speed mode,
 	 * tune result of hs200/200Mhz is not suitable for 50Mhz
 	 */
-	if (host->sclk <= 52000000) {
+	if (host->mmc->actual_clock <= 52000000) {
 		writel(host->def_tune_para.iocon, host->base + MSDC_IOCON);
 		writel(host->def_tune_para.pad_tune, host->base + tune_reg);
 	} else {
@@ -787,7 +787,8 @@ static void msdc_set_mclk(struct msdc_host *host, unsigned char timing, u32 hz)
 		sdr_set_field(host->base + tune_reg,
 			      MSDC_PAD_TUNE_CMDRRDLY,
 			      host->hs400_cmd_int_delay);
-	dev_dbg(host->dev, "sclk: %d, timing: %d\n", host->sclk, timing);
+	dev_dbg(host->dev, "sclk: %d, timing: %d\n", host->mmc->actual_clock,
+		timing);
 }
 
 static inline u32 msdc_cmd_find_resp(struct msdc_host *host,
-- 
2.20.1



