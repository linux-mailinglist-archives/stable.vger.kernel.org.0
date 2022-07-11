Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D6156FE1E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiGKKEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbiGKKDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:03:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED8F64E1E;
        Mon, 11 Jul 2022 02:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C854AB80E88;
        Mon, 11 Jul 2022 09:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00603C34115;
        Mon, 11 Jul 2022 09:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531762;
        bh=/CQDIX6MgHw6BSW5F+R2dK1axL90w7kDbL15plXrA1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhuEcKL0HrCMXGc0LDdSr212Nygoo1pi1TQmrSB+QHz/jvDqSmcsdGknmz6r0mLMK
         +xf2XaMcNBUX2mDJIusiFky2kT6B8z8pkZ613xW5pFc+GgMWdaYwiees/OUz0pOA0o
         W5nUCIYanTWPYjJ9J4FzcKfBQqdYvu0n4iPt8lv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/230] ASoC: codecs: rt700/rt711/rt711-sdca: resume bus/codec in .set_jack_detect
Date:   Mon, 11 Jul 2022 11:07:17 +0200
Message-Id: <20220711090609.246360825@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 40737057b48f1b4db67b0d766b95c87ba8fc5e03 ]

The .set_jack_detect() codec component callback is invoked during card
registration, which happens when the machine driver is probed.

The issue is that this callback can race with the bus suspend/resume,
and IO timeouts can happen. This can be reproduced very easily if the
machine driver is 'blacklisted' and manually probed after the bus
suspends. The bus and codec need to be re-initialized using pm_runtime
helpers.

Previous contributions tried to make sure accesses to the bus during
the .set_jack_detect() component callback only happen when the bus is
active. This was done by changing the regcache status on a component
remove. This is however a layering violation, the regcache status
should only be modified on device probe, suspend and resume. The
component probe/remove should not modify how the device regcache is
handled. This solution also didn't handle all the possible race
conditions, and the RT700 headset codec was not handled.

This patch tries to resume the codec device before handling the jack
initializations. In case the codec has not yet been initialized,
pm_runtime may not be enabled yet, so we don't squelch the -EACCES
error code and only stop the jack information. When the codec reports
as attached, the jack initialization will proceed as usual.

BugLink: https://github.com/thesofproject/linux/issues/3643
Fixes: 7ad4d237e7c4a ('ASoC: rt711-sdca: Add RT711 SDCA vendor-specific driver')
Fixes: 899b12542b089 ('ASoC: rt711: add snd_soc_component remove callback')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220606203752.144159-8-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt700.c      | 16 +++++++++++++---
 sound/soc/codecs/rt711-sdca.c | 26 ++++++++++++++------------
 sound/soc/codecs/rt711.c      | 24 +++++++++++++-----------
 3 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/sound/soc/codecs/rt700.c b/sound/soc/codecs/rt700.c
index 921382724f9c..614a40247679 100644
--- a/sound/soc/codecs/rt700.c
+++ b/sound/soc/codecs/rt700.c
@@ -315,17 +315,27 @@ static int rt700_set_jack_detect(struct snd_soc_component *component,
 	struct snd_soc_jack *hs_jack, void *data)
 {
 	struct rt700_priv *rt700 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	rt700->hs_jack = hs_jack;
 
-	if (!rt700->hw_init) {
-		dev_dbg(&rt700->slave->dev,
-			"%s hw_init not ready yet\n", __func__);
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret < 0) {
+		if (ret != -EACCES) {
+			dev_err(component->dev, "%s: failed to resume %d\n", __func__, ret);
+			return ret;
+		}
+
+		/* pm_runtime not enabled yet */
+		dev_dbg(component->dev,	"%s: skipping jack init for now\n", __func__);
 		return 0;
 	}
 
 	rt700_jack_init(rt700);
 
+	pm_runtime_mark_last_busy(component->dev);
+	pm_runtime_put_autosuspend(component->dev);
+
 	return 0;
 }
 
diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index b168e9303ea9..c15fb98eac86 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -487,16 +487,27 @@ static int rt711_sdca_set_jack_detect(struct snd_soc_component *component,
 	struct snd_soc_jack *hs_jack, void *data)
 {
 	struct rt711_sdca_priv *rt711 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	rt711->hs_jack = hs_jack;
 
-	if (!rt711->hw_init) {
-		dev_dbg(&rt711->slave->dev,
-			"%s hw_init not ready yet\n", __func__);
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret < 0) {
+		if (ret != -EACCES) {
+			dev_err(component->dev, "%s: failed to resume %d\n", __func__, ret);
+			return ret;
+		}
+
+		/* pm_runtime not enabled yet */
+		dev_dbg(component->dev,	"%s: skipping jack init for now\n", __func__);
 		return 0;
 	}
 
 	rt711_sdca_jack_init(rt711);
+
+	pm_runtime_mark_last_busy(component->dev);
+	pm_runtime_put_autosuspend(component->dev);
+
 	return 0;
 }
 
@@ -1190,14 +1201,6 @@ static int rt711_sdca_probe(struct snd_soc_component *component)
 	return 0;
 }
 
-static void rt711_sdca_remove(struct snd_soc_component *component)
-{
-	struct rt711_sdca_priv *rt711 = snd_soc_component_get_drvdata(component);
-
-	regcache_cache_only(rt711->regmap, true);
-	regcache_cache_only(rt711->mbq_regmap, true);
-}
-
 static const struct snd_soc_component_driver soc_sdca_dev_rt711 = {
 	.probe = rt711_sdca_probe,
 	.controls = rt711_sdca_snd_controls,
@@ -1207,7 +1210,6 @@ static const struct snd_soc_component_driver soc_sdca_dev_rt711 = {
 	.dapm_routes = rt711_sdca_audio_map,
 	.num_dapm_routes = ARRAY_SIZE(rt711_sdca_audio_map),
 	.set_jack = rt711_sdca_set_jack_detect,
-	.remove = rt711_sdca_remove,
 	.endianness = 1,
 };
 
diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index 9cc7283a19c2..fafb0ba8349f 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -450,17 +450,27 @@ static int rt711_set_jack_detect(struct snd_soc_component *component,
 	struct snd_soc_jack *hs_jack, void *data)
 {
 	struct rt711_priv *rt711 = snd_soc_component_get_drvdata(component);
+	int ret;
 
 	rt711->hs_jack = hs_jack;
 
-	if (!rt711->hw_init) {
-		dev_dbg(&rt711->slave->dev,
-			"%s hw_init not ready yet\n", __func__);
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret < 0) {
+		if (ret != -EACCES) {
+			dev_err(component->dev, "%s: failed to resume %d\n", __func__, ret);
+			return ret;
+		}
+
+		/* pm_runtime not enabled yet */
+		dev_dbg(component->dev,	"%s: skipping jack init for now\n", __func__);
 		return 0;
 	}
 
 	rt711_jack_init(rt711);
 
+	pm_runtime_mark_last_busy(component->dev);
+	pm_runtime_put_autosuspend(component->dev);
+
 	return 0;
 }
 
@@ -925,13 +935,6 @@ static int rt711_probe(struct snd_soc_component *component)
 	return 0;
 }
 
-static void rt711_remove(struct snd_soc_component *component)
-{
-	struct rt711_priv *rt711 = snd_soc_component_get_drvdata(component);
-
-	regcache_cache_only(rt711->regmap, true);
-}
-
 static const struct snd_soc_component_driver soc_codec_dev_rt711 = {
 	.probe = rt711_probe,
 	.set_bias_level = rt711_set_bias_level,
@@ -942,7 +945,6 @@ static const struct snd_soc_component_driver soc_codec_dev_rt711 = {
 	.dapm_routes = rt711_audio_map,
 	.num_dapm_routes = ARRAY_SIZE(rt711_audio_map),
 	.set_jack = rt711_set_jack_detect,
-	.remove = rt711_remove,
 	.endianness = 1,
 };
 
-- 
2.35.1



