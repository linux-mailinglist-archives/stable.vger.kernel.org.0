Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1BBB2041
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389771AbfIMNTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390334AbfIMNTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:19:00 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86DE320717;
        Fri, 13 Sep 2019 13:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380739;
        bh=enCaQyrnD7UyJOQmsdC0tyaSnihz+jmZ6XnKG/qB11Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxVR+4VqD0PmyV4biOfyFTvSxEPF7hJG96GMG1V7uZZUEKtemBnWw8KwnBcvro7uo
         Te9oRjOo/JplzfEEHtYeQ/iLVwsY9nlkzMOxe1q8+1FcyU+pqnSjl1L9iFTRcQujeb
         PstIXrljPHJ/ApzfrokQMdGXyTZFNZa02U8vyb0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/190] clk: tegra: Fix maximum audio sync clock for Tegra124/210
Date:   Fri, 13 Sep 2019 14:06:36 +0100
Message-Id: <20190913130611.279124709@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 845d782d91448e0fbca686bca2cc9f9c2a9ba3e7 ]

The maximum frequency supported for I2S on Tegra124 and Tegra210 is
24.576MHz (as stated in the Tegra TK1 data sheet for Tegra124 and the
Jetson TX1 module data sheet for Tegra210). However, the maximum I2S
frequency is limited to 24MHz because that is the maximum frequency of
the audio sync clock. Increase the maximum audio sync clock frequency
to 24.576MHz for Tegra124 and Tegra210 in order to support 24.576MHz
for I2S.

Update the tegra_clk_register_sync_source() function so that it does
not set the initial rate for the sync clocks and use the clock init
tables to set the initial rate instead.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/tegra/clk-audio-sync.c  | 3 +--
 drivers/clk/tegra/clk-tegra-audio.c | 7 ++-----
 drivers/clk/tegra/clk-tegra114.c    | 9 ++++++++-
 drivers/clk/tegra/clk-tegra124.c    | 9 ++++++++-
 drivers/clk/tegra/clk-tegra210.c    | 9 ++++++++-
 drivers/clk/tegra/clk-tegra30.c     | 9 ++++++++-
 drivers/clk/tegra/clk.h             | 4 ++--
 7 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/tegra/clk-audio-sync.c b/drivers/clk/tegra/clk-audio-sync.c
index 92d04ce2dee6b..53cdc0ec40f33 100644
--- a/drivers/clk/tegra/clk-audio-sync.c
+++ b/drivers/clk/tegra/clk-audio-sync.c
@@ -55,7 +55,7 @@ const struct clk_ops tegra_clk_sync_source_ops = {
 };
 
 struct clk *tegra_clk_register_sync_source(const char *name,
-		unsigned long rate, unsigned long max_rate)
+					   unsigned long max_rate)
 {
 	struct tegra_clk_sync_source *sync;
 	struct clk_init_data init;
@@ -67,7 +67,6 @@ struct clk *tegra_clk_register_sync_source(const char *name,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	sync->rate = rate;
 	sync->max_rate = max_rate;
 
 	init.ops = &tegra_clk_sync_source_ops;
diff --git a/drivers/clk/tegra/clk-tegra-audio.c b/drivers/clk/tegra/clk-tegra-audio.c
index b37cae7af26da..02dd6487d855d 100644
--- a/drivers/clk/tegra/clk-tegra-audio.c
+++ b/drivers/clk/tegra/clk-tegra-audio.c
@@ -49,8 +49,6 @@ struct tegra_sync_source_initdata {
 #define SYNC(_name) \
 	{\
 		.name		= #_name,\
-		.rate		= 24000000,\
-		.max_rate	= 24000000,\
 		.clk_id		= tegra_clk_ ## _name,\
 	}
 
@@ -176,7 +174,7 @@ static void __init tegra_audio_sync_clk_init(void __iomem *clk_base,
 void __init tegra_audio_clk_init(void __iomem *clk_base,
 			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
 			struct tegra_audio_clk_info *audio_info,
-			unsigned int num_plls)
+			unsigned int num_plls, unsigned long sync_max_rate)
 {
 	struct clk *clk;
 	struct clk **dt_clk;
@@ -221,8 +219,7 @@ void __init tegra_audio_clk_init(void __iomem *clk_base,
 		if (!dt_clk)
 			continue;
 
-		clk = tegra_clk_register_sync_source(data->name,
-					data->rate, data->max_rate);
+		clk = tegra_clk_register_sync_source(data->name, sync_max_rate);
 		*dt_clk = clk;
 	}
 
diff --git a/drivers/clk/tegra/clk-tegra114.c b/drivers/clk/tegra/clk-tegra114.c
index 1824f014202b0..625d110913308 100644
--- a/drivers/clk/tegra/clk-tegra114.c
+++ b/drivers/clk/tegra/clk-tegra114.c
@@ -1190,6 +1190,13 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{ TEGRA114_CLK_XUSB_FALCON_SRC, TEGRA114_CLK_PLL_P, 204000000, 0 },
 	{ TEGRA114_CLK_XUSB_HOST_SRC, TEGRA114_CLK_PLL_P, 102000000, 0 },
 	{ TEGRA114_CLK_VDE, TEGRA114_CLK_CLK_MAX, 600000000, 0 },
+	{ TEGRA114_CLK_SPDIF_IN_SYNC, TEGRA114_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA114_CLK_I2S0_SYNC, TEGRA114_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA114_CLK_I2S1_SYNC, TEGRA114_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA114_CLK_I2S2_SYNC, TEGRA114_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA114_CLK_I2S3_SYNC, TEGRA114_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA114_CLK_I2S4_SYNC, TEGRA114_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA114_CLK_VIMCLK_SYNC, TEGRA114_CLK_CLK_MAX, 24000000, 0 },
 	/* must be the last entry */
 	{ TEGRA114_CLK_CLK_MAX, TEGRA114_CLK_CLK_MAX, 0, 0 },
 };
@@ -1362,7 +1369,7 @@ static void __init tegra114_clock_init(struct device_node *np)
 	tegra114_periph_clk_init(clk_base, pmc_base);
 	tegra_audio_clk_init(clk_base, pmc_base, tegra114_clks,
 			     tegra114_audio_plls,
-			     ARRAY_SIZE(tegra114_audio_plls));
+			     ARRAY_SIZE(tegra114_audio_plls), 24000000);
 	tegra_pmc_clk_init(pmc_base, tegra114_clks);
 	tegra_super_clk_gen4_init(clk_base, pmc_base, tegra114_clks,
 					&pll_x_params);
diff --git a/drivers/clk/tegra/clk-tegra124.c b/drivers/clk/tegra/clk-tegra124.c
index b6cf28ca2ed29..df0018f7bf7ed 100644
--- a/drivers/clk/tegra/clk-tegra124.c
+++ b/drivers/clk/tegra/clk-tegra124.c
@@ -1291,6 +1291,13 @@ static struct tegra_clk_init_table common_init_table[] __initdata = {
 	{ TEGRA124_CLK_CSITE, TEGRA124_CLK_CLK_MAX, 0, 1 },
 	{ TEGRA124_CLK_TSENSOR, TEGRA124_CLK_CLK_M, 400000, 0 },
 	{ TEGRA124_CLK_VIC03, TEGRA124_CLK_PLL_C3, 0, 0 },
+	{ TEGRA124_CLK_SPDIF_IN_SYNC, TEGRA124_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA124_CLK_I2S0_SYNC, TEGRA124_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA124_CLK_I2S1_SYNC, TEGRA124_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA124_CLK_I2S2_SYNC, TEGRA124_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA124_CLK_I2S3_SYNC, TEGRA124_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA124_CLK_I2S4_SYNC, TEGRA124_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA124_CLK_VIMCLK_SYNC, TEGRA124_CLK_CLK_MAX, 24576000, 0 },
 	/* must be the last entry */
 	{ TEGRA124_CLK_CLK_MAX, TEGRA124_CLK_CLK_MAX, 0, 0 },
 };
@@ -1455,7 +1462,7 @@ static void __init tegra124_132_clock_init_pre(struct device_node *np)
 	tegra124_periph_clk_init(clk_base, pmc_base);
 	tegra_audio_clk_init(clk_base, pmc_base, tegra124_clks,
 			     tegra124_audio_plls,
-			     ARRAY_SIZE(tegra124_audio_plls));
+			     ARRAY_SIZE(tegra124_audio_plls), 24576000);
 	tegra_pmc_clk_init(pmc_base, tegra124_clks);
 
 	/* For Tegra124 & Tegra132, PLLD is the only source for DSIA & DSIB */
diff --git a/drivers/clk/tegra/clk-tegra210.c b/drivers/clk/tegra/clk-tegra210.c
index 4e1bc23c98655..f58480fe17674 100644
--- a/drivers/clk/tegra/clk-tegra210.c
+++ b/drivers/clk/tegra/clk-tegra210.c
@@ -3369,6 +3369,13 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{ TEGRA210_CLK_SOC_THERM, TEGRA210_CLK_PLL_P, 51000000, 0 },
 	{ TEGRA210_CLK_CCLK_G, TEGRA210_CLK_CLK_MAX, 0, 1 },
 	{ TEGRA210_CLK_PLL_U_OUT2, TEGRA210_CLK_CLK_MAX, 60000000, 1 },
+	{ TEGRA210_CLK_SPDIF_IN_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA210_CLK_I2S0_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA210_CLK_I2S1_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA210_CLK_I2S2_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA210_CLK_I2S3_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA210_CLK_I2S4_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
+	{ TEGRA210_CLK_VIMCLK_SYNC, TEGRA210_CLK_CLK_MAX, 24576000, 0 },
 	/* This MUST be the last entry. */
 	{ TEGRA210_CLK_CLK_MAX, TEGRA210_CLK_CLK_MAX, 0, 0 },
 };
@@ -3562,7 +3569,7 @@ static void __init tegra210_clock_init(struct device_node *np)
 	tegra210_periph_clk_init(clk_base, pmc_base);
 	tegra_audio_clk_init(clk_base, pmc_base, tegra210_clks,
 			     tegra210_audio_plls,
-			     ARRAY_SIZE(tegra210_audio_plls));
+			     ARRAY_SIZE(tegra210_audio_plls), 24576000);
 	tegra_pmc_clk_init(pmc_base, tegra210_clks);
 
 	/* For Tegra210, PLLD is the only source for DSIA & DSIB */
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index acfe661b2ae72..e0aaecd98fbff 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1267,6 +1267,13 @@ static struct tegra_clk_init_table init_table[] __initdata = {
 	{ TEGRA30_CLK_GR3D2, TEGRA30_CLK_PLL_C, 300000000, 0 },
 	{ TEGRA30_CLK_PLL_U, TEGRA30_CLK_CLK_MAX, 480000000, 0 },
 	{ TEGRA30_CLK_VDE, TEGRA30_CLK_CLK_MAX, 600000000, 0 },
+	{ TEGRA30_CLK_SPDIF_IN_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA30_CLK_I2S0_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA30_CLK_I2S1_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA30_CLK_I2S2_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA30_CLK_I2S3_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA30_CLK_I2S4_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
+	{ TEGRA30_CLK_VIMCLK_SYNC, TEGRA30_CLK_CLK_MAX, 24000000, 0 },
 	/* must be the last entry */
 	{ TEGRA30_CLK_CLK_MAX, TEGRA30_CLK_CLK_MAX, 0, 0 },
 };
@@ -1344,7 +1351,7 @@ static void __init tegra30_clock_init(struct device_node *np)
 	tegra30_periph_clk_init();
 	tegra_audio_clk_init(clk_base, pmc_base, tegra30_clks,
 			     tegra30_audio_plls,
-			     ARRAY_SIZE(tegra30_audio_plls));
+			     ARRAY_SIZE(tegra30_audio_plls), 24000000);
 	tegra_pmc_clk_init(pmc_base, tegra30_clks);
 
 	tegra_init_dup_clks(tegra_clk_duplicates, clks, TEGRA30_CLK_CLK_MAX);
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index d2c3a010f8e9b..09bccbb9640c4 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -41,7 +41,7 @@ extern const struct clk_ops tegra_clk_sync_source_ops;
 extern int *periph_clk_enb_refcnt;
 
 struct clk *tegra_clk_register_sync_source(const char *name,
-		unsigned long fixed_rate, unsigned long max_rate);
+					   unsigned long max_rate);
 
 /**
  * struct tegra_clk_frac_div - fractional divider clock
@@ -796,7 +796,7 @@ void tegra_register_devclks(struct tegra_devclk *dev_clks, int num);
 void tegra_audio_clk_init(void __iomem *clk_base,
 			void __iomem *pmc_base, struct tegra_clk *tegra_clks,
 			struct tegra_audio_clk_info *audio_info,
-			unsigned int num_plls);
+			unsigned int num_plls, unsigned long sync_max_rate);
 
 void tegra_periph_clk_init(void __iomem *clk_base, void __iomem *pmc_base,
 			struct tegra_clk *tegra_clks,
-- 
2.20.1



