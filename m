Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20FF0148260
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391634AbgAXL13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:27:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403970AbgAXL12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:27:28 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33C4A20704;
        Fri, 24 Jan 2020 11:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865247;
        bh=HFJ7BZem848oSa/jykeAVRQgQXt05YXCrmrc91jDKzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pn7iEfnFZVcuh/nlas2t8Vit5XtCIbj+QrAg2vosDgi0IOviMRcAGlZsQya+FNeyH
         lACAzCOZ4XdMhDQJZirwKxYJZ88k42t3mwiKu2v2+J8yqxXB1pO5IBZvmQLf1iqKRb
         UtaaoQPKF4KlyJMychPheXiwdJD08/xz0QD96B1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 481/639] clk: sunxi-ng: v3s: add the missing PLL_DDR1
Date:   Fri, 24 Jan 2020 10:30:51 +0100
Message-Id: <20200124093148.700600217@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

[ Upstream commit c5ed9475c22c89d5409402055142372e35d26a3f ]

The user manual of V3/V3s/S3 declares a PLL_DDR1, however it's forgot
when developing the V3s CCU driver.

Add back the missing PLL_DDR1.

Fixes: d0f11d14b0bc ("clk: sunxi-ng: add support for V3s CCU")
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c | 19 +++++++++++++++----
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.h |  6 ++++--
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
index 9e3f4088724b4..c7f9d974b10d5 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
@@ -84,7 +84,7 @@ static SUNXI_CCU_NM_WITH_FRAC_GATE_LOCK(pll_ve_clk, "pll-ve",
 					BIT(28),	/* lock */
 					0);
 
-static SUNXI_CCU_NKM_WITH_GATE_LOCK(pll_ddr_clk, "pll-ddr",
+static SUNXI_CCU_NKM_WITH_GATE_LOCK(pll_ddr0_clk, "pll-ddr0",
 				    "osc24M", 0x020,
 				    8, 5,	/* N */
 				    4, 2,	/* K */
@@ -123,6 +123,14 @@ static SUNXI_CCU_NK_WITH_GATE_LOCK_POSTDIV(pll_periph1_clk, "pll-periph1",
 					   2,		/* post-div */
 					   0);
 
+static SUNXI_CCU_NM_WITH_GATE_LOCK(pll_ddr1_clk, "pll-ddr1",
+				   "osc24M", 0x04c,
+				   8, 7,	/* N */
+				   0, 2,	/* M */
+				   BIT(31),	/* gate */
+				   BIT(28),	/* lock */
+				   0);
+
 static const char * const cpu_parents[] = { "osc32k", "osc24M",
 					     "pll-cpu", "pll-cpu" };
 static SUNXI_CCU_MUX(cpu_clk, "cpu", cpu_parents,
@@ -310,7 +318,8 @@ static SUNXI_CCU_GATE(usb_phy0_clk,	"usb-phy0",	"osc24M",
 static SUNXI_CCU_GATE(usb_ohci0_clk,	"usb-ohci0",	"osc24M",
 		      0x0cc, BIT(16), 0);
 
-static const char * const dram_parents[] = { "pll-ddr", "pll-periph0-2x" };
+static const char * const dram_parents[] = { "pll-ddr0", "pll-ddr1",
+					     "pll-periph0-2x" };
 static SUNXI_CCU_M_WITH_MUX(dram_clk, "dram", dram_parents,
 			    0x0f4, 0, 4, 20, 2, CLK_IS_CRITICAL);
 
@@ -369,10 +378,11 @@ static struct ccu_common *sun8i_v3s_ccu_clks[] = {
 	&pll_audio_base_clk.common,
 	&pll_video_clk.common,
 	&pll_ve_clk.common,
-	&pll_ddr_clk.common,
+	&pll_ddr0_clk.common,
 	&pll_periph0_clk.common,
 	&pll_isp_clk.common,
 	&pll_periph1_clk.common,
+	&pll_ddr1_clk.common,
 	&cpu_clk.common,
 	&axi_clk.common,
 	&ahb1_clk.common,
@@ -457,11 +467,12 @@ static struct clk_hw_onecell_data sun8i_v3s_hw_clks = {
 		[CLK_PLL_AUDIO_8X]	= &pll_audio_8x_clk.hw,
 		[CLK_PLL_VIDEO]		= &pll_video_clk.common.hw,
 		[CLK_PLL_VE]		= &pll_ve_clk.common.hw,
-		[CLK_PLL_DDR]		= &pll_ddr_clk.common.hw,
+		[CLK_PLL_DDR0]		= &pll_ddr0_clk.common.hw,
 		[CLK_PLL_PERIPH0]	= &pll_periph0_clk.common.hw,
 		[CLK_PLL_PERIPH0_2X]	= &pll_periph0_2x_clk.hw,
 		[CLK_PLL_ISP]		= &pll_isp_clk.common.hw,
 		[CLK_PLL_PERIPH1]	= &pll_periph1_clk.common.hw,
+		[CLK_PLL_DDR1]		= &pll_ddr1_clk.common.hw,
 		[CLK_CPU]		= &cpu_clk.common.hw,
 		[CLK_AXI]		= &axi_clk.common.hw,
 		[CLK_AHB1]		= &ahb1_clk.common.hw,
diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.h b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.h
index 4a4d36fdad960..a091b7217dfd5 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.h
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.h
@@ -29,7 +29,7 @@
 #define CLK_PLL_AUDIO_8X	5
 #define CLK_PLL_VIDEO		6
 #define CLK_PLL_VE		7
-#define CLK_PLL_DDR		8
+#define CLK_PLL_DDR0		8
 #define CLK_PLL_PERIPH0		9
 #define CLK_PLL_PERIPH0_2X	10
 #define CLK_PLL_ISP		11
@@ -58,6 +58,8 @@
 
 /* And the GPU module clock is exported */
 
-#define CLK_NUMBER		(CLK_MIPI_CSI + 1)
+#define CLK_PLL_DDR1		74
+
+#define CLK_NUMBER		(CLK_PLL_DDR1 + 1)
 
 #endif /* _CCU_SUN8I_H3_H_ */
-- 
2.20.1



