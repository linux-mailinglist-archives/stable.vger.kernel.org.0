Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C647E4EC0A3
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344145AbiC3LwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344202AbiC3Lvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E26D27683C;
        Wed, 30 Mar 2022 04:48:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D396615B7;
        Wed, 30 Mar 2022 11:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF22C34113;
        Wed, 30 Mar 2022 11:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640888;
        bh=RMc2It4dGYVyP7I6bfOhhGG9ID4xvoJkIC5CZ+LRjz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIWbPZqtp4IAirDVGefxJc0Ea4JceUtg0yz/j+PkkjYVX7j0p8thEPiwPtTPUd35S
         QwXkUUBGajtWw9AlrZ2QEk+WtLxH3mCJIzZL17lxTVNhdBlGWA/isV4vtVWAfgIOok
         fBO5TImuaunlxaKCQLAXnN1NwSYFX9Qiw/+zcPryfQxx69fy1MHBKi1T+8iC82C16i
         NUGC1uIIPDiMnyHwAVU1cojlkL7LjpENIItJZFKL/jU1R8fLNdxsQkaTgHa9j76MYf
         38nxhbu7SutfeI3XcY25tHCRnd3TtsgEYOfi+MnTVDRe1Co3U5EV/IeLnraFg7ZZ/S
         m16Spproudssw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 53/66] ASoC: SOF: Intel: hda: retrieve DMIC number for I2S boards
Date:   Wed, 30 Mar 2022 07:46:32 -0400
Message-Id: <20220330114646.1669334-53-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 92c1b7c0f780f0084f7b114be316ae4e182676e5 ]

We currently extract the DMIC number only for HDaudio or SoundWire
platforms. For I2S/TDM platforms, this wasn't necessary until now, but
with devices with ES8336 we need to find a solution to detect dmics
more reliably than with a DMI quirk.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220308192610.392950-4-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 46 +++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 848d1d563170..028751549f6d 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -432,11 +432,9 @@ static char *hda_model;
 module_param(hda_model, charp, 0444);
 MODULE_PARM_DESC(hda_model, "Use the given HDA board model.");
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA) || IS_ENABLED(CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE)
-static int hda_dmic_num = -1;
-module_param_named(dmic_num, hda_dmic_num, int, 0444);
+static int dmic_num_override = -1;
+module_param_named(dmic_num, dmic_num_override, int, 0444);
 MODULE_PARM_DESC(dmic_num, "SOF HDA DMIC number");
-#endif
 
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA)
 static bool hda_codec_use_common_hdmi = IS_ENABLED(CONFIG_SND_HDA_CODEC_HDMI);
@@ -644,24 +642,35 @@ static int hda_init(struct snd_sof_dev *sdev)
 	return ret;
 }
 
-#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA) || IS_ENABLED(CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE)
-
-static int check_nhlt_dmic(struct snd_sof_dev *sdev)
+static int check_dmic_num(struct snd_sof_dev *sdev)
 {
 	struct nhlt_acpi_table *nhlt;
-	int dmic_num;
+	int dmic_num = 0;
 
 	nhlt = intel_nhlt_init(sdev->dev);
 	if (nhlt) {
 		dmic_num = intel_nhlt_get_dmic_geo(sdev->dev, nhlt);
 		intel_nhlt_free(nhlt);
-		if (dmic_num >= 1 && dmic_num <= 4)
-			return dmic_num;
 	}
 
-	return 0;
+	/* allow for module parameter override */
+	if (dmic_num_override != -1) {
+		dev_dbg(sdev->dev,
+			"overriding DMICs detected in NHLT tables %d by kernel param %d\n",
+			dmic_num, dmic_num_override);
+		dmic_num = dmic_num_override;
+	}
+
+	if (dmic_num < 0 || dmic_num > 4) {
+		dev_dbg(sdev->dev, "invalid dmic_number %d\n", dmic_num);
+		dmic_num = 0;
+	}
+
+	return dmic_num;
 }
 
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA) || IS_ENABLED(CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE)
+
 static const char *fixup_tplg_name(struct snd_sof_dev *sdev,
 				   const char *sof_tplg_filename,
 				   const char *idisp_str,
@@ -697,16 +706,8 @@ static int dmic_topology_fixup(struct snd_sof_dev *sdev,
 	const char *dmic_str;
 	int dmic_num;
 
-	/* first check NHLT for DMICs */
-	dmic_num = check_nhlt_dmic(sdev);
-
-	/* allow for module parameter override */
-	if (hda_dmic_num != -1) {
-		dev_dbg(sdev->dev,
-			"overriding DMICs detected in NHLT tables %d by kernel param %d\n",
-			dmic_num, hda_dmic_num);
-		dmic_num = hda_dmic_num;
-	}
+	/* first check for DMICs (using NHLT or module parameter) */
+	dmic_num = check_dmic_num(sdev);
 
 	switch (dmic_num) {
 	case 1:
@@ -1392,6 +1393,9 @@ struct snd_soc_acpi_mach *hda_machine_select(struct snd_sof_dev *sdev)
 		if (!sof_pdata->tplg_filename)
 			sof_pdata->tplg_filename = mach->sof_tplg_filename;
 
+		/* report to machine driver if any DMICs are found */
+		mach->mach_params.dmic_num = check_dmic_num(sdev);
+
 		if (mach->link_mask) {
 			mach->mach_params.links = mach->links;
 			mach->mach_params.link_mask = mach->link_mask;
-- 
2.34.1

