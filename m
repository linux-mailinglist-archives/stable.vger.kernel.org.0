Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A0914E247
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbgA3So7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730926AbgA3So6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:44:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 913312082E;
        Thu, 30 Jan 2020 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409898;
        bh=i+98cbl9FjfX50LGd+5BHlXUspumzNbAKtB6PD24HZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWwRbR6Cj5zLTXUErKI3YGg0DSv04hTuWA7U9na5hVPWesPTt2GPG3YHvyHbNhTyX
         3YrB8GGIq562heRt/OMCZim5MLPUK/AqqcG9B1YazIeQIRw4oy2Y3Wz5mB8bSSdNuE
         MNa+1nsjbp/S1BX4Fp7R7BO+oNN8sxt/tdKjYWlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam McNally <sammc@chromium.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/110] ASoC: Intel: cht_bsw_rt5645: Add quirk for boards using pmc_plt_clk_0
Date:   Thu, 30 Jan 2020 19:38:52 +0100
Message-Id: <20200130183623.338398446@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam McNally <sammc@chromium.org>

[ Upstream commit adebb11139029ddf1fba6f796c4a476f17eacddc ]

As of commit 648e921888ad ("clk: x86: Stop marking clocks as
CLK_IS_CRITICAL"), the cht_bsw_rt5645 driver needs to enable the clock
it's using for the codec's mclk. It does this from commit 7735bce05a9c
("ASoC: Intel: boards: use devm_clk_get() unconditionally"), enabling
pmc_plt_clk_3. However, Strago family Chromebooks use pmc_plt_clk_0 for
the codec mclk, resulting in white noise with some digital microphones.
Add a DMI-based quirk for Strago family Chromebooks to use pmc_plt_clk_0
instead - mirroring the changes made to cht_bsw_max98090_ti in
commit a182ecd3809c ("ASoC: intel: cht_bsw_max98090_ti: Add quirk for
boards using pmc_plt_clk_0") and making use of the existing
dmi_check_system() call and related infrastructure added in
commit 22af29114eb4 ("ASoC: Intel: cht-bsw-rt5645: add quirks for
SSP0/AIF1/AIF2 routing").

Signed-off-by: Sam McNally <sammc@chromium.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190917054933.209335-1-sammc@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/cht_bsw_rt5645.c | 26 +++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/boards/cht_bsw_rt5645.c b/sound/soc/intel/boards/cht_bsw_rt5645.c
index 8879c3be29d5a..c68a5b85a4a03 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5645.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5645.c
@@ -48,6 +48,7 @@ struct cht_mc_private {
 #define CHT_RT5645_SSP2_AIF2     BIT(16) /* default is using AIF1  */
 #define CHT_RT5645_SSP0_AIF1     BIT(17)
 #define CHT_RT5645_SSP0_AIF2     BIT(18)
+#define CHT_RT5645_PMC_PLT_CLK_0 BIT(19)
 
 static unsigned long cht_rt5645_quirk = 0;
 
@@ -59,6 +60,8 @@ static void log_quirks(struct device *dev)
 		dev_info(dev, "quirk SSP0_AIF1 enabled");
 	if (cht_rt5645_quirk & CHT_RT5645_SSP0_AIF2)
 		dev_info(dev, "quirk SSP0_AIF2 enabled");
+	if (cht_rt5645_quirk & CHT_RT5645_PMC_PLT_CLK_0)
+		dev_info(dev, "quirk PMC_PLT_CLK_0 enabled");
 }
 
 static int platform_clock_control(struct snd_soc_dapm_widget *w,
@@ -226,15 +229,21 @@ static int cht_aif1_hw_params(struct snd_pcm_substream *substream,
 	return 0;
 }
 
-/* uncomment when we have a real quirk
 static int cht_rt5645_quirk_cb(const struct dmi_system_id *id)
 {
 	cht_rt5645_quirk = (unsigned long)id->driver_data;
 	return 1;
 }
-*/
 
 static const struct dmi_system_id cht_rt5645_quirk_table[] = {
+	{
+		/* Strago family Chromebooks */
+		.callback = cht_rt5645_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Intel_Strago"),
+		},
+		.driver_data = (void *)CHT_RT5645_PMC_PLT_CLK_0,
+	},
 	{
 	},
 };
@@ -526,6 +535,7 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 	int dai_index = 0;
 	int ret_val = 0;
 	int i;
+	const char *mclk_name;
 
 	drv = devm_kzalloc(&pdev->dev, sizeof(*drv), GFP_KERNEL);
 	if (!drv)
@@ -662,11 +672,15 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 	if (ret_val)
 		return ret_val;
 
-	drv->mclk = devm_clk_get(&pdev->dev, "pmc_plt_clk_3");
+	if (cht_rt5645_quirk & CHT_RT5645_PMC_PLT_CLK_0)
+		mclk_name = "pmc_plt_clk_0";
+	else
+		mclk_name = "pmc_plt_clk_3";
+
+	drv->mclk = devm_clk_get(&pdev->dev, mclk_name);
 	if (IS_ERR(drv->mclk)) {
-		dev_err(&pdev->dev,
-			"Failed to get MCLK from pmc_plt_clk_3: %ld\n",
-			PTR_ERR(drv->mclk));
+		dev_err(&pdev->dev, "Failed to get MCLK from %s: %ld\n",
+			mclk_name, PTR_ERR(drv->mclk));
 		return PTR_ERR(drv->mclk);
 	}
 
-- 
2.20.1



