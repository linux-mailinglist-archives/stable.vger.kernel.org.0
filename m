Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DAF6AB01F
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 14:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjCENxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 08:53:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjCENxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 08:53:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F4817165;
        Sun,  5 Mar 2023 05:52:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2448A60B10;
        Sun,  5 Mar 2023 13:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C442C4339B;
        Sun,  5 Mar 2023 13:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678024354;
        bh=WaLyygKzcLUsP0WL87bEOYjetQ+Pi0VfdOzKWcE/IzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M01lQoIcBiZqaR5Y/1HkAIa02eUQUh+Orfk6Mobp8MinMm+eXiVcnRSyQl914xqa3
         lwe3pVZ/aBY6p+uNFXQ+gHugzuDCuJkOIQqSbkM/cfLBq4PlKAjzHLFge42YLFqVSI
         W+Coe47W74+LBAwFI1XEedsQ0hCPTuI5ec71vSWfaOlsFaf8teT5YZU2EMi64gBAzQ
         YBmDGRFsr5PmpPYFeP7oXtDWNksLj0wp/NYHTQHGjwqqRtdPNVhoNJNbBL6fIhLR4G
         Lm8hsjIXjZ5V3dOwNVcpyvffHU+H54QFUE+CMFL+uQg1he4x3jHPrBAQGbUT6NYAsh
         k+V1qs44zHrqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>, mturquette@baylibre.com,
        sboyd@kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 07/16] clk: renesas: rcar-gen3: Disable R-Car H3 ES1.*
Date:   Sun,  5 Mar 2023 08:51:58 -0500
Message-Id: <20230305135207.1793266-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305135207.1793266-1-sashal@kernel.org>
References: <20230305135207.1793266-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit b1dec4e78599a2ce5bf8557056cd6dd72e1096b0 ]

R-Car H3 ES1.* was only available to an internal development group and
needed a lot of quirks and workarounds. These become a maintenance
burden now, so our development group decided to remove upstream support
for this SoC. Public users only have ES2 onwards.

In addition to the ES1 specific removals, a check for it was added
preventing the machine to boot further. It may otherwise inherit wrong
clock settings from ES2 which could damage the hardware.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230202092332.2504-1-wsa+renesas@sang-engineering.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/Kconfig            |   2 +-
 drivers/clk/renesas/r8a7795-cpg-mssr.c | 126 ++-----------------------
 drivers/clk/renesas/rcar-gen3-cpg.c    |  17 +---
 drivers/clk/renesas/renesas-cpg-mssr.c |  27 ------
 drivers/clk/renesas/renesas-cpg-mssr.h |  14 ---
 5 files changed, 13 insertions(+), 173 deletions(-)

diff --git a/drivers/clk/renesas/Kconfig b/drivers/clk/renesas/Kconfig
index cacaf9b87d264..37632a0659d82 100644
--- a/drivers/clk/renesas/Kconfig
+++ b/drivers/clk/renesas/Kconfig
@@ -22,7 +22,7 @@ config CLK_RENESAS
 	select CLK_R8A7791 if ARCH_R8A7791 || ARCH_R8A7793
 	select CLK_R8A7792 if ARCH_R8A7792
 	select CLK_R8A7794 if ARCH_R8A7794
-	select CLK_R8A7795 if ARCH_R8A77950 || ARCH_R8A77951
+	select CLK_R8A7795 if ARCH_R8A77951
 	select CLK_R8A77960 if ARCH_R8A77960
 	select CLK_R8A77961 if ARCH_R8A77961
 	select CLK_R8A77965 if ARCH_R8A77965
diff --git a/drivers/clk/renesas/r8a7795-cpg-mssr.c b/drivers/clk/renesas/r8a7795-cpg-mssr.c
index 301475c74f500..7a585a777d387 100644
--- a/drivers/clk/renesas/r8a7795-cpg-mssr.c
+++ b/drivers/clk/renesas/r8a7795-cpg-mssr.c
@@ -128,7 +128,6 @@ static struct cpg_core_clk r8a7795_core_clks[] __initdata = {
 };
 
 static struct mssr_mod_clk r8a7795_mod_clks[] __initdata = {
-	DEF_MOD("fdp1-2",		 117,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("fdp1-1",		 118,	R8A7795_CLK_S0D1),
 	DEF_MOD("fdp1-0",		 119,	R8A7795_CLK_S0D1),
 	DEF_MOD("tmu4",			 121,	R8A7795_CLK_S0D6),
@@ -162,7 +161,6 @@ static struct mssr_mod_clk r8a7795_mod_clks[] __initdata = {
 	DEF_MOD("pcie1",		 318,	R8A7795_CLK_S3D1),
 	DEF_MOD("pcie0",		 319,	R8A7795_CLK_S3D1),
 	DEF_MOD("usb-dmac30",		 326,	R8A7795_CLK_S3D1),
-	DEF_MOD("usb3-if1",		 327,	R8A7795_CLK_S3D1), /* ES1.x */
 	DEF_MOD("usb3-if0",		 328,	R8A7795_CLK_S3D1),
 	DEF_MOD("usb-dmac31",		 329,	R8A7795_CLK_S3D1),
 	DEF_MOD("usb-dmac0",		 330,	R8A7795_CLK_S3D1),
@@ -187,28 +185,21 @@ static struct mssr_mod_clk r8a7795_mod_clks[] __initdata = {
 	DEF_MOD("hscif0",		 520,	R8A7795_CLK_S3D1),
 	DEF_MOD("thermal",		 522,	R8A7795_CLK_CP),
 	DEF_MOD("pwm",			 523,	R8A7795_CLK_S0D12),
-	DEF_MOD("fcpvd3",		 600,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("fcpvd2",		 601,	R8A7795_CLK_S0D2),
 	DEF_MOD("fcpvd1",		 602,	R8A7795_CLK_S0D2),
 	DEF_MOD("fcpvd0",		 603,	R8A7795_CLK_S0D2),
 	DEF_MOD("fcpvb1",		 606,	R8A7795_CLK_S0D1),
 	DEF_MOD("fcpvb0",		 607,	R8A7795_CLK_S0D1),
-	DEF_MOD("fcpvi2",		 609,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("fcpvi1",		 610,	R8A7795_CLK_S0D1),
 	DEF_MOD("fcpvi0",		 611,	R8A7795_CLK_S0D1),
-	DEF_MOD("fcpf2",		 613,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("fcpf1",		 614,	R8A7795_CLK_S0D1),
 	DEF_MOD("fcpf0",		 615,	R8A7795_CLK_S0D1),
-	DEF_MOD("fcpci1",		 616,	R8A7795_CLK_S2D1), /* ES1.x */
-	DEF_MOD("fcpci0",		 617,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("fcpcs",		 619,	R8A7795_CLK_S0D1),
-	DEF_MOD("vspd3",		 620,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("vspd2",		 621,	R8A7795_CLK_S0D2),
 	DEF_MOD("vspd1",		 622,	R8A7795_CLK_S0D2),
 	DEF_MOD("vspd0",		 623,	R8A7795_CLK_S0D2),
 	DEF_MOD("vspbc",		 624,	R8A7795_CLK_S0D1),
 	DEF_MOD("vspbd",		 626,	R8A7795_CLK_S0D1),
-	DEF_MOD("vspi2",		 629,	R8A7795_CLK_S2D1), /* ES1.x */
 	DEF_MOD("vspi1",		 630,	R8A7795_CLK_S0D1),
 	DEF_MOD("vspi0",		 631,	R8A7795_CLK_S0D1),
 	DEF_MOD("ehci3",		 700,	R8A7795_CLK_S3D2),
@@ -221,7 +212,6 @@ static struct mssr_mod_clk r8a7795_mod_clks[] __initdata = {
 	DEF_MOD("cmm2",			 709,	R8A7795_CLK_S2D1),
 	DEF_MOD("cmm1",			 710,	R8A7795_CLK_S2D1),
 	DEF_MOD("cmm0",			 711,	R8A7795_CLK_S2D1),
-	DEF_MOD("csi21",		 713,	R8A7795_CLK_CSI0), /* ES1.x */
 	DEF_MOD("csi20",		 714,	R8A7795_CLK_CSI0),
 	DEF_MOD("csi41",		 715,	R8A7795_CLK_CSI0),
 	DEF_MOD("csi40",		 716,	R8A7795_CLK_CSI0),
@@ -350,103 +340,26 @@ static const struct rcar_gen3_cpg_pll_config cpg_pll_configs[16] __initconst = {
 	{ 2,		192,	1,	192,	1,	32,	},
 };
 
-static const struct soc_device_attribute r8a7795es1[] __initconst = {
+static const struct soc_device_attribute r8a7795_denylist[] __initconst = {
 	{ .soc_id = "r8a7795", .revision = "ES1.*" },
 	{ /* sentinel */ }
 };
 
-
-	/*
-	 * Fixups for R-Car H3 ES1.x
-	 */
-
-static const unsigned int r8a7795es1_mod_nullify[] __initconst = {
-	MOD_CLK_ID(326),			/* USB-DMAC3-0 */
-	MOD_CLK_ID(329),			/* USB-DMAC3-1 */
-	MOD_CLK_ID(700),			/* EHCI/OHCI3 */
-	MOD_CLK_ID(705),			/* HS-USB-IF3 */
-
-};
-
-static const struct mssr_mod_reparent r8a7795es1_mod_reparent[] __initconst = {
-	{ MOD_CLK_ID(118), R8A7795_CLK_S2D1 },	/* FDP1-1 */
-	{ MOD_CLK_ID(119), R8A7795_CLK_S2D1 },	/* FDP1-0 */
-	{ MOD_CLK_ID(121), R8A7795_CLK_S3D2 },	/* TMU4 */
-	{ MOD_CLK_ID(217), R8A7795_CLK_S3D1 },	/* SYS-DMAC2 */
-	{ MOD_CLK_ID(218), R8A7795_CLK_S3D1 },	/* SYS-DMAC1 */
-	{ MOD_CLK_ID(219), R8A7795_CLK_S3D1 },	/* SYS-DMAC0 */
-	{ MOD_CLK_ID(408), R8A7795_CLK_S3D1 },	/* INTC-AP */
-	{ MOD_CLK_ID(501), R8A7795_CLK_S3D1 },	/* AUDMAC1 */
-	{ MOD_CLK_ID(502), R8A7795_CLK_S3D1 },	/* AUDMAC0 */
-	{ MOD_CLK_ID(523), R8A7795_CLK_S3D4 },	/* PWM */
-	{ MOD_CLK_ID(601), R8A7795_CLK_S2D1 },	/* FCPVD2 */
-	{ MOD_CLK_ID(602), R8A7795_CLK_S2D1 },	/* FCPVD1 */
-	{ MOD_CLK_ID(603), R8A7795_CLK_S2D1 },	/* FCPVD0 */
-	{ MOD_CLK_ID(606), R8A7795_CLK_S2D1 },	/* FCPVB1 */
-	{ MOD_CLK_ID(607), R8A7795_CLK_S2D1 },	/* FCPVB0 */
-	{ MOD_CLK_ID(610), R8A7795_CLK_S2D1 },	/* FCPVI1 */
-	{ MOD_CLK_ID(611), R8A7795_CLK_S2D1 },	/* FCPVI0 */
-	{ MOD_CLK_ID(614), R8A7795_CLK_S2D1 },	/* FCPF1 */
-	{ MOD_CLK_ID(615), R8A7795_CLK_S2D1 },	/* FCPF0 */
-	{ MOD_CLK_ID(619), R8A7795_CLK_S2D1 },	/* FCPCS */
-	{ MOD_CLK_ID(621), R8A7795_CLK_S2D1 },	/* VSPD2 */
-	{ MOD_CLK_ID(622), R8A7795_CLK_S2D1 },	/* VSPD1 */
-	{ MOD_CLK_ID(623), R8A7795_CLK_S2D1 },	/* VSPD0 */
-	{ MOD_CLK_ID(624), R8A7795_CLK_S2D1 },	/* VSPBC */
-	{ MOD_CLK_ID(626), R8A7795_CLK_S2D1 },	/* VSPBD */
-	{ MOD_CLK_ID(630), R8A7795_CLK_S2D1 },	/* VSPI1 */
-	{ MOD_CLK_ID(631), R8A7795_CLK_S2D1 },	/* VSPI0 */
-	{ MOD_CLK_ID(804), R8A7795_CLK_S2D1 },	/* VIN7 */
-	{ MOD_CLK_ID(805), R8A7795_CLK_S2D1 },	/* VIN6 */
-	{ MOD_CLK_ID(806), R8A7795_CLK_S2D1 },	/* VIN5 */
-	{ MOD_CLK_ID(807), R8A7795_CLK_S2D1 },	/* VIN4 */
-	{ MOD_CLK_ID(808), R8A7795_CLK_S2D1 },	/* VIN3 */
-	{ MOD_CLK_ID(809), R8A7795_CLK_S2D1 },	/* VIN2 */
-	{ MOD_CLK_ID(810), R8A7795_CLK_S2D1 },	/* VIN1 */
-	{ MOD_CLK_ID(811), R8A7795_CLK_S2D1 },	/* VIN0 */
-	{ MOD_CLK_ID(812), R8A7795_CLK_S3D2 },	/* EAVB-IF */
-	{ MOD_CLK_ID(820), R8A7795_CLK_S2D1 },	/* IMR3 */
-	{ MOD_CLK_ID(821), R8A7795_CLK_S2D1 },	/* IMR2 */
-	{ MOD_CLK_ID(822), R8A7795_CLK_S2D1 },	/* IMR1 */
-	{ MOD_CLK_ID(823), R8A7795_CLK_S2D1 },	/* IMR0 */
-	{ MOD_CLK_ID(905), R8A7795_CLK_CP },	/* GPIO7 */
-	{ MOD_CLK_ID(906), R8A7795_CLK_CP },	/* GPIO6 */
-	{ MOD_CLK_ID(907), R8A7795_CLK_CP },	/* GPIO5 */
-	{ MOD_CLK_ID(908), R8A7795_CLK_CP },	/* GPIO4 */
-	{ MOD_CLK_ID(909), R8A7795_CLK_CP },	/* GPIO3 */
-	{ MOD_CLK_ID(910), R8A7795_CLK_CP },	/* GPIO2 */
-	{ MOD_CLK_ID(911), R8A7795_CLK_CP },	/* GPIO1 */
-	{ MOD_CLK_ID(912), R8A7795_CLK_CP },	/* GPIO0 */
-	{ MOD_CLK_ID(918), R8A7795_CLK_S3D2 },	/* I2C6 */
-	{ MOD_CLK_ID(919), R8A7795_CLK_S3D2 },	/* I2C5 */
-	{ MOD_CLK_ID(927), R8A7795_CLK_S3D2 },	/* I2C4 */
-	{ MOD_CLK_ID(928), R8A7795_CLK_S3D2 },	/* I2C3 */
-};
-
-
-	/*
-	 * Fixups for R-Car H3 ES2.x
-	 */
-
-static const unsigned int r8a7795es2_mod_nullify[] __initconst = {
-	MOD_CLK_ID(117),			/* FDP1-2 */
-	MOD_CLK_ID(327),			/* USB3-IF1 */
-	MOD_CLK_ID(600),			/* FCPVD3 */
-	MOD_CLK_ID(609),			/* FCPVI2 */
-	MOD_CLK_ID(613),			/* FCPF2 */
-	MOD_CLK_ID(616),			/* FCPCI1 */
-	MOD_CLK_ID(617),			/* FCPCI0 */
-	MOD_CLK_ID(620),			/* VSPD3 */
-	MOD_CLK_ID(629),			/* VSPI2 */
-	MOD_CLK_ID(713),			/* CSI21 */
-};
-
 static int __init r8a7795_cpg_mssr_init(struct device *dev)
 {
 	const struct rcar_gen3_cpg_pll_config *cpg_pll_config;
 	u32 cpg_mode;
 	int error;
 
+	/*
+	 * We panic here to ensure removed SoCs and clk updates are always in
+	 * sync to avoid overclocking damages. The panic can only be seen with
+	 * commandline args 'earlycon keep_bootcon'. But these SoCs were for
+	 * developers only anyhow.
+	 */
+	if (soc_device_match(r8a7795_denylist))
+		panic("SoC not supported anymore!\n");
+
 	error = rcar_rst_read_mode_pins(&cpg_mode);
 	if (error)
 		return error;
@@ -457,25 +370,6 @@ static int __init r8a7795_cpg_mssr_init(struct device *dev)
 		return -EINVAL;
 	}
 
-	if (soc_device_match(r8a7795es1)) {
-		cpg_core_nullify_range(r8a7795_core_clks,
-				       ARRAY_SIZE(r8a7795_core_clks),
-				       R8A7795_CLK_S0D2, R8A7795_CLK_S0D12);
-		mssr_mod_nullify(r8a7795_mod_clks,
-				 ARRAY_SIZE(r8a7795_mod_clks),
-				 r8a7795es1_mod_nullify,
-				 ARRAY_SIZE(r8a7795es1_mod_nullify));
-		mssr_mod_reparent(r8a7795_mod_clks,
-				  ARRAY_SIZE(r8a7795_mod_clks),
-				  r8a7795es1_mod_reparent,
-				  ARRAY_SIZE(r8a7795es1_mod_reparent));
-	} else {
-		mssr_mod_nullify(r8a7795_mod_clks,
-				 ARRAY_SIZE(r8a7795_mod_clks),
-				 r8a7795es2_mod_nullify,
-				 ARRAY_SIZE(r8a7795es2_mod_nullify));
-	}
-
 	return rcar_gen3_cpg_init(cpg_pll_config, CLK_EXTALR, cpg_mode);
 }
 
diff --git a/drivers/clk/renesas/rcar-gen3-cpg.c b/drivers/clk/renesas/rcar-gen3-cpg.c
index e668f23c75e7d..b3ef62fa612e3 100644
--- a/drivers/clk/renesas/rcar-gen3-cpg.c
+++ b/drivers/clk/renesas/rcar-gen3-cpg.c
@@ -310,19 +310,10 @@ static unsigned int cpg_clk_extalr __initdata;
 static u32 cpg_mode __initdata;
 static u32 cpg_quirks __initdata;
 
-#define PLL_ERRATA	BIT(0)		/* Missing PLL0/2/4 post-divider */
 #define RCKCR_CKSEL	BIT(1)		/* Manual RCLK parent selection */
 
 
 static const struct soc_device_attribute cpg_quirks_match[] __initconst = {
-	{
-		.soc_id = "r8a7795", .revision = "ES1.0",
-		.data = (void *)(PLL_ERRATA | RCKCR_CKSEL),
-	},
-	{
-		.soc_id = "r8a7795", .revision = "ES1.*",
-		.data = (void *)(RCKCR_CKSEL),
-	},
 	{
 		.soc_id = "r8a7796", .revision = "ES1.0",
 		.data = (void *)(RCKCR_CKSEL),
@@ -355,9 +346,8 @@ struct clk * __init rcar_gen3_cpg_clk_register(struct device *dev,
 		 * multiplier when cpufreq changes between normal and boost
 		 * modes.
 		 */
-		mult = (cpg_quirks & PLL_ERRATA) ? 4 : 2;
 		return cpg_pll_clk_register(core->name, __clk_get_name(parent),
-					    base, mult, CPG_PLL0CR, 0);
+					    base, 2, CPG_PLL0CR, 0);
 
 	case CLK_TYPE_GEN3_PLL1:
 		mult = cpg_pll_config->pll1_mult;
@@ -370,9 +360,8 @@ struct clk * __init rcar_gen3_cpg_clk_register(struct device *dev,
 		 * multiplier when cpufreq changes between normal and boost
 		 * modes.
 		 */
-		mult = (cpg_quirks & PLL_ERRATA) ? 4 : 2;
 		return cpg_pll_clk_register(core->name, __clk_get_name(parent),
-					    base, mult, CPG_PLL2CR, 2);
+					    base, 2, CPG_PLL2CR, 2);
 
 	case CLK_TYPE_GEN3_PLL3:
 		mult = cpg_pll_config->pll3_mult;
@@ -388,8 +377,6 @@ struct clk * __init rcar_gen3_cpg_clk_register(struct device *dev,
 		 */
 		value = readl(base + CPG_PLL4CR);
 		mult = (((value >> 24) & 0x7f) + 1) * 2;
-		if (cpg_quirks & PLL_ERRATA)
-			mult *= 2;
 		break;
 
 	case CLK_TYPE_GEN3_SDH:
diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 1a0cdf001b2f2..523fd45231571 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -1113,19 +1113,6 @@ static int __init cpg_mssr_init(void)
 
 subsys_initcall(cpg_mssr_init);
 
-void __init cpg_core_nullify_range(struct cpg_core_clk *core_clks,
-				   unsigned int num_core_clks,
-				   unsigned int first_clk,
-				   unsigned int last_clk)
-{
-	unsigned int i;
-
-	for (i = 0; i < num_core_clks; i++)
-		if (core_clks[i].id >= first_clk &&
-		    core_clks[i].id <= last_clk)
-			core_clks[i].name = NULL;
-}
-
 void __init mssr_mod_nullify(struct mssr_mod_clk *mod_clks,
 			     unsigned int num_mod_clks,
 			     const unsigned int *clks, unsigned int n)
@@ -1139,19 +1126,5 @@ void __init mssr_mod_nullify(struct mssr_mod_clk *mod_clks,
 		}
 }
 
-void __init mssr_mod_reparent(struct mssr_mod_clk *mod_clks,
-			      unsigned int num_mod_clks,
-			      const struct mssr_mod_reparent *clks,
-			      unsigned int n)
-{
-	unsigned int i, j;
-
-	for (i = 0, j = 0; i < num_mod_clks && j < n; i++)
-		if (mod_clks[i].id == clks[j].clk) {
-			mod_clks[i].parent = clks[j].parent;
-			j++;
-		}
-}
-
 MODULE_DESCRIPTION("Renesas CPG/MSSR Driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/clk/renesas/renesas-cpg-mssr.h b/drivers/clk/renesas/renesas-cpg-mssr.h
index 1c3c057d17f53..80c5b462924ac 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.h
+++ b/drivers/clk/renesas/renesas-cpg-mssr.h
@@ -187,21 +187,7 @@ void __init cpg_mssr_early_init(struct device_node *np,
     /*
      * Helpers for fixing up clock tables depending on SoC revision
      */
-
-struct mssr_mod_reparent {
-	unsigned int clk, parent;
-};
-
-
-extern void cpg_core_nullify_range(struct cpg_core_clk *core_clks,
-				   unsigned int num_core_clks,
-				   unsigned int first_clk,
-				   unsigned int last_clk);
 extern void mssr_mod_nullify(struct mssr_mod_clk *mod_clks,
 			     unsigned int num_mod_clks,
 			     const unsigned int *clks, unsigned int n);
-extern void mssr_mod_reparent(struct mssr_mod_clk *mod_clks,
-			      unsigned int num_mod_clks,
-			      const struct mssr_mod_reparent *clks,
-			      unsigned int n);
 #endif
-- 
2.39.2

