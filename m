Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBBE24768A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgHQP0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729823AbgHQP0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:26:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDF4C23A7A;
        Mon, 17 Aug 2020 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677994;
        bh=KB6RWjnFeFkfNFvLKMXDtmoeCYysjKEicBd8gBtYYyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/q6UX1l/5euss/aou4Xdiu7fBU89WVoEWO8Upaf1gi1FnS4HP289pRLVA/1VxaD0
         tVHyeJpgDr12GLgLRqTrPWdbOiJv6qwwNgOgmCfPZoE+21m6TkijgnE81+I4y7CC0L
         V1+D+XGHaYPbE4jQGEstgnOWY5st7aBeRNHN57Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 181/464] ASoC: Intel: Boards: cml_rt1011_rt5682: use statically define codec config
Date:   Mon, 17 Aug 2020 17:12:14 +0200
Message-Id: <20200817143842.487653050@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fred Oh <fred.oh@linux.intel.com>

[ Upstream commit 8a473c39ae54c27e694a131c34a739d0f8aa5300 ]

When the cml_rt1011_rt5682_dailink[].codecs pointer is overridden by
a quirk with a devm allocated structure and the probe is deferred,
in the next probe we will see an use-after-free condition
(verified with KASAN). This can be avoided by using statically allocated
configurations - which simplifies the code quite a bit as well.

KASAN issue fixed.
[   23.301373] cml_rt1011_rt5682 cml_rt1011_rt5682: sof_rt1011_quirk = f
[   23.301875] ==================================================================
[   23.302018] BUG: KASAN: use-after-free in snd_cml_rt1011_probe+0x23a/0x3d0 [snd_soc_cml_rt1011_rt5682]
[   23.302178] Read of size 8 at addr ffff8881ec6acae0 by task kworker/0:2/105
[   23.302320] CPU: 0 PID: 105 Comm: kworker/0:2 Not tainted 5.7.0-rc7-test+ #3
[   23.302322] Hardware name: Google Helios/Helios, BIOS  01/21/2020
[   23.302329] Workqueue: events deferred_probe_work_func
[   23.302331] Call Trace:
[   23.302339]  dump_stack+0x76/0xa0
[   23.302345]  print_address_description.constprop.0.cold+0xd3/0x43e
[   23.302351]  ? _raw_spin_lock_irqsave+0x7b/0xd0
[   23.302355]  ? _raw_spin_trylock_bh+0xf0/0xf0
[   23.302362]  ? snd_cml_rt1011_probe+0x23a/0x3d0 [snd_soc_cml_rt1011_rt5682]
[   23.302365]  __kasan_report.cold+0x37/0x86
[   23.302371]  ? snd_cml_rt1011_probe+0x23a/0x3d0 [snd_soc_cml_rt1011_rt5682]
[   23.302375]  kasan_report+0x38/0x50
[   23.302382]  snd_cml_rt1011_probe+0x23a/0x3d0 [snd_soc_cml_rt1011_rt5682]
[   23.302389]  platform_drv_probe+0x66/0xc0

Fixes: 629ba12e9998 ("ASoC: Intel: boards: split woofer and tweeter support")
Suggested-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20200625191308.3322-12-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/cml_rt1011_rt5682.c | 83 ++++++----------------
 1 file changed, 23 insertions(+), 60 deletions(-)

diff --git a/sound/soc/intel/boards/cml_rt1011_rt5682.c b/sound/soc/intel/boards/cml_rt1011_rt5682.c
index 6f89b50a8c8ff..23dd8c5fc1e74 100644
--- a/sound/soc/intel/boards/cml_rt1011_rt5682.c
+++ b/sound/soc/intel/boards/cml_rt1011_rt5682.c
@@ -34,7 +34,6 @@
 #define SOF_RT1011_SPEAKER_WR		BIT(1)
 #define SOF_RT1011_SPEAKER_TL		BIT(2)
 #define SOF_RT1011_SPEAKER_TR		BIT(3)
-#define SPK_CH 4
 
 /* Default: Woofer speakers  */
 static unsigned long sof_rt1011_quirk = SOF_RT1011_SPEAKER_WL |
@@ -376,10 +375,17 @@ SND_SOC_DAILINK_DEF(ssp0_codec,
 
 SND_SOC_DAILINK_DEF(ssp1_pin,
 	DAILINK_COMP_ARRAY(COMP_CPU("SSP1 Pin")));
-SND_SOC_DAILINK_DEF(ssp1_codec,
+SND_SOC_DAILINK_DEF(ssp1_codec_2spk,
 	DAILINK_COMP_ARRAY(
 	/* WL */ COMP_CODEC("i2c-10EC1011:00", CML_RT1011_CODEC_DAI),
 	/* WR */ COMP_CODEC("i2c-10EC1011:01", CML_RT1011_CODEC_DAI)));
+SND_SOC_DAILINK_DEF(ssp1_codec_4spk,
+	DAILINK_COMP_ARRAY(
+	/* WL */ COMP_CODEC("i2c-10EC1011:00", CML_RT1011_CODEC_DAI),
+	/* WR */ COMP_CODEC("i2c-10EC1011:01", CML_RT1011_CODEC_DAI),
+	/* TL */ COMP_CODEC("i2c-10EC1011:02", CML_RT1011_CODEC_DAI),
+	/* TR */ COMP_CODEC("i2c-10EC1011:03", CML_RT1011_CODEC_DAI)));
+
 
 SND_SOC_DAILINK_DEF(dmic_pin,
 	DAILINK_COMP_ARRAY(COMP_CPU("DMIC01 Pin")));
@@ -475,7 +481,7 @@ static struct snd_soc_dai_link cml_rt1011_rt5682_dailink[] = {
 		.no_pcm = 1,
 		.init = cml_rt1011_spk_init,
 		.ops = &cml_rt1011_ops,
-		SND_SOC_DAILINK_REG(ssp1_pin, ssp1_codec, platform),
+		SND_SOC_DAILINK_REG(ssp1_pin, ssp1_codec_2spk, platform),
 	},
 };
 
@@ -488,6 +494,15 @@ static struct snd_soc_codec_conf rt1011_conf[] = {
 		.dlc = COMP_CODEC_CONF("i2c-10EC1011:01"),
 		.name_prefix = "WR",
 	},
+	/* single configuration structure for 2 and 4 channels */
+	{
+		.dlc = COMP_CODEC_CONF("i2c-10EC1011:02"),
+		.name_prefix = "TL",
+	},
+	{
+		.dlc = COMP_CODEC_CONF("i2c-10EC1011:03"),
+		.name_prefix = "TR",
+	},
 };
 
 /* Cometlake audio machine driver for RT1011 and RT5682 */
@@ -510,8 +525,6 @@ static struct snd_soc_card snd_soc_card_cml = {
 
 static int snd_cml_rt1011_probe(struct platform_device *pdev)
 {
-	struct snd_soc_dai_link_component *rt1011_dais_components;
-	struct snd_soc_codec_conf *rt1011_dais_confs;
 	struct card_private *ctx;
 	struct snd_soc_acpi_mach *mach;
 	const char *platform_name;
@@ -530,65 +543,15 @@ static int snd_cml_rt1011_probe(struct platform_device *pdev)
 
 	dev_info(&pdev->dev, "sof_rt1011_quirk = %lx\n", sof_rt1011_quirk);
 
+	/* when 4 speaker is available, update codec config */
 	if (sof_rt1011_quirk & (SOF_RT1011_SPEAKER_TL |
 				SOF_RT1011_SPEAKER_TR)) {
-		rt1011_dais_confs = devm_kzalloc(&pdev->dev,
-					sizeof(struct snd_soc_codec_conf) *
-					SPK_CH, GFP_KERNEL);
-
-		if (!rt1011_dais_confs)
-			return -ENOMEM;
-
-		rt1011_dais_components = devm_kzalloc(&pdev->dev,
-					sizeof(struct snd_soc_dai_link_component) *
-					SPK_CH, GFP_KERNEL);
-
-		if (!rt1011_dais_components)
-			return -ENOMEM;
-
-		for (i = 0; i < SPK_CH; i++) {
-			rt1011_dais_confs[i].dlc.name = devm_kasprintf(&pdev->dev,
-								GFP_KERNEL,
-								"i2c-10EC1011:0%d",
-								i);
-
-			if (!rt1011_dais_confs[i].dlc.name)
-				return -ENOMEM;
-
-			switch (i) {
-			case 0:
-				rt1011_dais_confs[i].name_prefix = "WL";
-				break;
-			case 1:
-				rt1011_dais_confs[i].name_prefix = "WR";
-				break;
-			case 2:
-				rt1011_dais_confs[i].name_prefix = "TL";
-				break;
-			case 3:
-				rt1011_dais_confs[i].name_prefix = "TR";
-				break;
-			default:
-				return -EINVAL;
-			}
-			rt1011_dais_components[i].name = devm_kasprintf(&pdev->dev,
-								GFP_KERNEL,
-								"i2c-10EC1011:0%d",
-								i);
-			if (!rt1011_dais_components[i].name)
-				return -ENOMEM;
-
-			rt1011_dais_components[i].dai_name = CML_RT1011_CODEC_DAI;
-		}
-
-		snd_soc_card_cml.codec_conf = rt1011_dais_confs;
-		snd_soc_card_cml.num_configs = SPK_CH;
-
 		for (i = 0; i < ARRAY_SIZE(cml_rt1011_rt5682_dailink); i++) {
 			if (!strcmp(cml_rt1011_rt5682_dailink[i].codecs->dai_name,
-					CML_RT1011_CODEC_DAI)) {
-				cml_rt1011_rt5682_dailink[i].codecs = rt1011_dais_components;
-				cml_rt1011_rt5682_dailink[i].num_codecs = SPK_CH;
+				    CML_RT1011_CODEC_DAI)) {
+				cml_rt1011_rt5682_dailink[i].codecs = ssp1_codec_4spk;
+				cml_rt1011_rt5682_dailink[i].num_codecs =
+						ARRAY_SIZE(ssp1_codec_4spk);
 			}
 		}
 	}
-- 
2.25.1



