Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34FC032E921
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbhCEMan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:30:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231229AbhCEMa2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:30:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 594886501A;
        Fri,  5 Mar 2021 12:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947427;
        bh=m47c8CyMAJsxicRFIgL66Wpta6RrjK/b0KyBOsiQs1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5eWdLx5fpo7Tl+Xnn4wo+8VO1FHDvq6l+pF/fns9ZAnwI+j1MWxUDYwybClf/RXG
         5/kaCDWH4vxRQaemmgZxep5wfe4b3Ugw09lJnZmGhl3Q1J7GZEqOMuh3AXoUFcWvGP
         oOfAgHnQZGydpDVWHSR3od0mBnZ8mQizHx+cJnb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rasmus Porsager <rasmus@beat.dk>,
        Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/102] ASoC: Intel: bytcr_rt5640: Add new BYT_RT5640_NO_SPEAKERS quirk-flag
Date:   Fri,  5 Mar 2021 13:21:21 +0100
Message-Id: <20210305120906.333140056@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1851ccf9e155b2a6f6cca1a7bd49325f5efbd5d2 ]

Some devices, like mini PCs/media/top-set boxes do not have any speakers
at all, an example of the is the Mele PCG03 Mini PC.

Add a new BYT_RT5640_NO_SPEAKERS quirk-flag which when sets does not add
speaker routes and modifies the components and the (optional) long_name
strings to reflect that there are no speakers.

Cc: Rasmus Porsager <rasmus@beat.dk>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210109210119.159032-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index f790514a147d..db3633de9122 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -71,6 +71,7 @@ enum {
 #define BYT_RT5640_SSP0_AIF2		BIT(21)
 #define BYT_RT5640_MCLK_EN		BIT(22)
 #define BYT_RT5640_MCLK_25MHZ		BIT(23)
+#define BYT_RT5640_NO_SPEAKERS		BIT(24)
 
 #define BYTCR_INPUT_DEFAULTS				\
 	(BYT_RT5640_IN3_MAP |				\
@@ -132,6 +133,8 @@ static void log_quirks(struct device *dev)
 		dev_info(dev, "quirk JD_NOT_INV enabled\n");
 	if (byt_rt5640_quirk & BYT_RT5640_MONO_SPEAKER)
 		dev_info(dev, "quirk MONO_SPEAKER enabled\n");
+	if (byt_rt5640_quirk & BYT_RT5640_NO_SPEAKERS)
+		dev_info(dev, "quirk NO_SPEAKERS enabled\n");
 	if (byt_rt5640_quirk & BYT_RT5640_DIFF_MIC)
 		dev_info(dev, "quirk DIFF_MIC enabled\n");
 	if (byt_rt5640_quirk & BYT_RT5640_SSP0_AIF1) {
@@ -934,7 +937,7 @@ static int byt_rt5640_init(struct snd_soc_pcm_runtime *runtime)
 		ret = snd_soc_dapm_add_routes(&card->dapm,
 					byt_rt5640_mono_spk_map,
 					ARRAY_SIZE(byt_rt5640_mono_spk_map));
-	} else {
+	} else if (!(byt_rt5640_quirk & BYT_RT5640_NO_SPEAKERS)) {
 		ret = snd_soc_dapm_add_routes(&card->dapm,
 					byt_rt5640_stereo_spk_map,
 					ARRAY_SIZE(byt_rt5640_stereo_spk_map));
@@ -1179,6 +1182,7 @@ struct acpi_chan_package {   /* ACPICA seems to require 64 bit integers */
 static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 {
 	static const char * const map_name[] = { "dmic1", "dmic2", "in1", "in3" };
+	__maybe_unused const char *spk_type;
 	const struct dmi_system_id *dmi_id;
 	struct byt_rt5640_private *priv;
 	struct snd_soc_acpi_mach *mach;
@@ -1186,7 +1190,7 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 	struct acpi_device *adev;
 	int ret_val = 0;
 	int dai_index = 0;
-	int i;
+	int i, cfg_spk;
 
 	is_bytcr = false;
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
@@ -1325,16 +1329,24 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 		}
 	}
 
+	if (byt_rt5640_quirk & BYT_RT5640_NO_SPEAKERS) {
+		cfg_spk = 0;
+		spk_type = "none";
+	} else if (byt_rt5640_quirk & BYT_RT5640_MONO_SPEAKER) {
+		cfg_spk = 1;
+		spk_type = "mono";
+	} else {
+		cfg_spk = 2;
+		spk_type = "stereo";
+	}
+
 	snprintf(byt_rt5640_components, sizeof(byt_rt5640_components),
-		 "cfg-spk:%s cfg-mic:%s",
-		 (byt_rt5640_quirk & BYT_RT5640_MONO_SPEAKER) ? "1" : "2",
+		 "cfg-spk:%d cfg-mic:%s", cfg_spk,
 		 map_name[BYT_RT5640_MAP(byt_rt5640_quirk)]);
 	byt_rt5640_card.components = byt_rt5640_components;
 #if !IS_ENABLED(CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES)
 	snprintf(byt_rt5640_long_name, sizeof(byt_rt5640_long_name),
-		 "bytcr-rt5640-%s-spk-%s-mic",
-		 (byt_rt5640_quirk & BYT_RT5640_MONO_SPEAKER) ?
-			"mono" : "stereo",
+		 "bytcr-rt5640-%s-spk-%s-mic", spk_type,
 		 map_name[BYT_RT5640_MAP(byt_rt5640_quirk)]);
 	byt_rt5640_card.long_name = byt_rt5640_long_name;
 #endif
-- 
2.30.1



