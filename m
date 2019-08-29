Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32CDAA231C
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbfH2SNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728255AbfH2SNc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AF8A233FF;
        Thu, 29 Aug 2019 18:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102410;
        bh=LA1osv1knb85aMWMeg3UWllHAUwn23d4BkvyaIAIuAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I4+Ub0Pj88T4FASK4QKFaddBOBeguHsxqHkddktEAW34lIi0oVxN4XJAJdU4OBt7g
         3h9jlHiioLXRgFU+pjlEWI8PtKU05OacgimRaIL0OjJfSFzOAgZsvuVLfFVnwt2Nv0
         +5p1gMMNFPCoj+9K+IVuVawbIGETaZgu+6Y/pRTc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jaafar Ali <jaafarkhalaf@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 07/76] clk: samsung: exynos5800: Move MAU subsystem clocks to MAU sub-CMU
Date:   Thu, 29 Aug 2019 14:12:02 -0400
Message-Id: <20190829181311.7562-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

[ Upstream commit b6adeb6bc61c2567b9efd815d61a61b34a2e51a6 ]

This patch fixes broken sound on Exynos5422/5800 platforms after
system/suspend resume cycle in cases where the audio root clock
is derived from MAU_EPLL_CLK.

In order to preserve state of the USER_MUX_MAU_EPLL_CLK clock mux
during system suspend/resume cycle for Exynos5800 we group the MAU
block input clocks in "MAU" sub-CMU and add the clock mux control
bit to .suspend_regs.  This ensures that user configuration of the mux
is not lost after the PMU block changes the mux setting to OSC_DIV
when switching off the MAU power domain.

Adding the SRC_TOP9 register to exynos5800_clk_regs[] array is not
sufficient as at the time of the syscore_ops suspend call MAU power
domain is already turned off and we already save and subsequently
restore an incorrect register's value.

Fixes: b06a532bf1fa ("clk: samsung: Add Exynos5 sub-CMU clock driver")
Reported-by: Jaafar Ali <jaafarkhalaf@gmail.com>
Suggested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Jaafar Ali <jaafarkhalaf@gmail.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Link: https://lkml.kernel.org/r/20190808144929.18685-2-s.nawrocki@samsung.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos5420.c | 54 ++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index a6ea5d7e63d02..5eb0ce4b2648b 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -524,8 +524,6 @@ static const struct samsung_gate_clock exynos5800_gate_clks[] __initconst = {
 				GATE_BUS_TOP, 24, 0, 0),
 	GATE(CLK_ACLK432_SCALER, "aclk432_scaler", "mout_user_aclk432_scaler",
 				GATE_BUS_TOP, 27, CLK_IS_CRITICAL, 0),
-	GATE(CLK_MAU_EPLL, "mau_epll", "mout_user_mau_epll",
-			SRC_MASK_TOP7, 20, CLK_SET_RATE_PARENT, 0),
 };
 
 static const struct samsung_mux_clock exynos5420_mux_clks[] __initconst = {
@@ -567,8 +565,13 @@ static const struct samsung_div_clock exynos5420_div_clks[] __initconst = {
 
 static const struct samsung_gate_clock exynos5420_gate_clks[] __initconst = {
 	GATE(CLK_SECKEY, "seckey", "aclk66_psgen", GATE_BUS_PERIS1, 1, 0, 0),
+	/* Maudio Block */
 	GATE(CLK_MAU_EPLL, "mau_epll", "mout_mau_epll_clk",
 			SRC_MASK_TOP7, 20, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MAUDIO0, "sclk_maudio0", "dout_maudio0",
+		GATE_TOP_SCLK_MAU, 0, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MAUPCM0, "sclk_maupcm0", "dout_maupcm0",
+		GATE_TOP_SCLK_MAU, 1, CLK_SET_RATE_PARENT, 0),
 };
 
 static const struct samsung_mux_clock exynos5x_mux_clks[] __initconst = {
@@ -994,12 +997,6 @@ static const struct samsung_gate_clock exynos5x_gate_clks[] __initconst = {
 	GATE(CLK_SCLK_DP1, "sclk_dp1", "dout_dp1",
 			GATE_TOP_SCLK_DISP1, 20, CLK_SET_RATE_PARENT, 0),
 
-	/* Maudio Block */
-	GATE(CLK_SCLK_MAUDIO0, "sclk_maudio0", "dout_maudio0",
-		GATE_TOP_SCLK_MAU, 0, CLK_SET_RATE_PARENT, 0),
-	GATE(CLK_SCLK_MAUPCM0, "sclk_maupcm0", "dout_maupcm0",
-		GATE_TOP_SCLK_MAU, 1, CLK_SET_RATE_PARENT, 0),
-
 	/* FSYS Block */
 	GATE(CLK_TSI, "tsi", "aclk200_fsys", GATE_BUS_FSYS0, 0, 0, 0),
 	GATE(CLK_PDMA0, "pdma0", "aclk200_fsys", GATE_BUS_FSYS0, 1, 0, 0),
@@ -1232,6 +1229,20 @@ static struct exynos5_subcmu_reg_dump exynos5x_mfc_suspend_regs[] = {
 	{ DIV4_RATIO, 0, 0x3 },			/* DIV dout_mfc_blk */
 };
 
+
+static const struct samsung_gate_clock exynos5800_mau_gate_clks[] __initconst = {
+	GATE(CLK_MAU_EPLL, "mau_epll", "mout_user_mau_epll",
+			SRC_MASK_TOP7, 20, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MAUDIO0, "sclk_maudio0", "dout_maudio0",
+		GATE_TOP_SCLK_MAU, 0, CLK_SET_RATE_PARENT, 0),
+	GATE(CLK_SCLK_MAUPCM0, "sclk_maupcm0", "dout_maupcm0",
+		GATE_TOP_SCLK_MAU, 1, CLK_SET_RATE_PARENT, 0),
+};
+
+static struct exynos5_subcmu_reg_dump exynos5800_mau_suspend_regs[] = {
+	{ SRC_TOP9, 0, BIT(8) },	/* MUX mout_user_mau_epll */
+};
+
 static const struct exynos5_subcmu_info exynos5x_disp_subcmu = {
 	.div_clks	= exynos5x_disp_div_clks,
 	.nr_div_clks	= ARRAY_SIZE(exynos5x_disp_div_clks),
@@ -1262,12 +1273,27 @@ static const struct exynos5_subcmu_info exynos5x_mfc_subcmu = {
 	.pd_name	= "MFC",
 };
 
+static const struct exynos5_subcmu_info exynos5800_mau_subcmu = {
+	.gate_clks	= exynos5800_mau_gate_clks,
+	.nr_gate_clks	= ARRAY_SIZE(exynos5800_mau_gate_clks),
+	.suspend_regs	= exynos5800_mau_suspend_regs,
+	.nr_suspend_regs = ARRAY_SIZE(exynos5800_mau_suspend_regs),
+	.pd_name	= "MAU",
+};
+
 static const struct exynos5_subcmu_info *exynos5x_subcmus[] = {
 	&exynos5x_disp_subcmu,
 	&exynos5x_gsc_subcmu,
 	&exynos5x_mfc_subcmu,
 };
 
+static const struct exynos5_subcmu_info *exynos5800_subcmus[] = {
+	&exynos5x_disp_subcmu,
+	&exynos5x_gsc_subcmu,
+	&exynos5x_mfc_subcmu,
+	&exynos5800_mau_subcmu,
+};
+
 static const struct samsung_pll_rate_table exynos5420_pll2550x_24mhz_tbl[] __initconst = {
 	PLL_35XX_RATE(24 * MHZ, 2000000000, 250, 3, 0),
 	PLL_35XX_RATE(24 * MHZ, 1900000000, 475, 6, 0),
@@ -1483,11 +1509,17 @@ static void __init exynos5x_clk_init(struct device_node *np,
 	samsung_clk_extended_sleep_init(reg_base,
 		exynos5x_clk_regs, ARRAY_SIZE(exynos5x_clk_regs),
 		exynos5420_set_clksrc, ARRAY_SIZE(exynos5420_set_clksrc));
-	if (soc == EXYNOS5800)
+
+	if (soc == EXYNOS5800) {
 		samsung_clk_sleep_init(reg_base, exynos5800_clk_regs,
 				       ARRAY_SIZE(exynos5800_clk_regs));
-	exynos5_subcmus_init(ctx, ARRAY_SIZE(exynos5x_subcmus),
-			     exynos5x_subcmus);
+
+		exynos5_subcmus_init(ctx, ARRAY_SIZE(exynos5800_subcmus),
+				     exynos5800_subcmus);
+	} else {
+		exynos5_subcmus_init(ctx, ARRAY_SIZE(exynos5x_subcmus),
+				     exynos5x_subcmus);
+	}
 
 	samsung_clk_of_add_provider(np, ctx);
 }
-- 
2.20.1

