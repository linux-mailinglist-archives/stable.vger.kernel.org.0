Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC482ACE11
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731953AbfIHMuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731978AbfIHMuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:50:10 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D011218AF;
        Sun,  8 Sep 2019 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947008;
        bh=Z65TTZP8JdkdJ8c4x4micoWJaTPq5wg7e2WzO5QAU1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktZ+cqHoWP5/g4VzYnErYsw2PD28At/9L6p7LFmX4rsBQjRHwEmCKcOa4mNrbFbAH
         JmBLIlUy1xi/G+6o0uV29AZReVq+wRLlBqtNW7nmyzzryC5XMjIwyror0JcOmVFUPB
         E3BmBWiy7LoEhJKNTyjjTz+q3ZoeQ/YwUZzPy5xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaafar Ali <jaafarkhalaf@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 26/94] clk: samsung: exynos5800: Move MAU subsystem clocks to MAU sub-CMU
Date:   Sun,  8 Sep 2019 13:41:22 +0100
Message-Id: <20190908121151.190578386@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



