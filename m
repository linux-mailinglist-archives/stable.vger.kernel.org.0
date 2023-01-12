Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EF3667769
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239839AbjALOmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239678AbjALOmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:42:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713D03D5D4
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:31:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06EF861FCB
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA853C433EF;
        Thu, 12 Jan 2023 14:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533911;
        bh=dJnO6TWGrkh2+jENoK2Mfces80UdYMEmW4lpotDsSrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zxQSuS8AM/OkubINZfY2HSr2U1SLCihNFuQUPPplnIMDqBFn+Xh06e1AuOpi3jOvz
         g9pUy/Sw2GxpbXgLZrBQhUW+Q2jC4r3XrlJanZXDIV7njvDdEeM9ZtBIB48SWAcHaC
         PTFw+3R1xIDGVcTzBSxQ7ckZNZJUKV3MzPh3kL4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 602/783] ASoC/SoundWire: dai: expand stream concept beyond SoundWire
Date:   Thu, 12 Jan 2023 14:55:18 +0100
Message-Id: <20230112135552.176880563@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit e8444560b4d9302a511f0996f4cfdf85b628f4ca upstream.

The HDAudio ASoC support relies on the set_tdm_slots() helper to store
the HDaudio stream tag in the tx_mask. This only works because of the
pre-existing order in soc-pcm.c, where the hw_params() is handled for
codec_dais *before* cpu_dais. When the order is reversed, the
stream_tag is used as a mask in the codec fixup functions:

	/* fixup params based on TDM slot masks */
	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
	    codec_dai->tx_mask)
		soc_pcm_codec_params_fixup(&codec_params,
					   codec_dai->tx_mask);

As a result of this confusion, the codec_params_fixup() ends-up
generating bad channel masks, depending on what stream_tag was
allocated.

We could add a flag to state that the tx_mask is really not a mask,
but it would be quite ugly to persist in overloading concepts.

Instead, this patch suggests a more generic get/set 'stream' API based
on the existing model for SoundWire. We can expand the concept to
store 'stream' opaque information that is specific to different DAI
types. In the case of HDAudio DAIs, we only need to store a stream tag
as an unsigned char pointer. The TDM rx_ and tx_masks should really
only be used to store masks.

Rename get_sdw_stream/set_sdw_stream callbacks and helpers as
get_stream/set_stream. No functionality change beyond the rename.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Acked-By: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20211224021034.26635-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/intel.c        |    8 ++++----
 drivers/soundwire/qcom.c         |    8 ++++----
 drivers/soundwire/stream.c       |    4 ++--
 include/sound/soc-dai.h          |   32 ++++++++++++++++----------------
 sound/soc/codecs/max98373-sdw.c  |    2 +-
 sound/soc/codecs/rt1308-sdw.c    |    2 +-
 sound/soc/codecs/rt5682-sdw.c    |    2 +-
 sound/soc/codecs/rt700.c         |    2 +-
 sound/soc/codecs/rt711.c         |    2 +-
 sound/soc/codecs/rt715.c         |    2 +-
 sound/soc/codecs/wsa881x.c       |    2 +-
 sound/soc/intel/boards/sof_sdw.c |    6 +++---
 sound/soc/qcom/sdm845.c          |    4 ++--
 13 files changed, 38 insertions(+), 38 deletions(-)

--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1140,8 +1140,8 @@ static const struct snd_soc_dai_ops inte
 	.prepare = intel_prepare,
 	.hw_free = intel_hw_free,
 	.shutdown = intel_shutdown,
-	.set_sdw_stream = intel_pcm_set_sdw_stream,
-	.get_sdw_stream = intel_get_sdw_stream,
+	.set_stream = intel_pcm_set_sdw_stream,
+	.get_stream = intel_get_sdw_stream,
 };
 
 static const struct snd_soc_dai_ops intel_pdm_dai_ops = {
@@ -1150,8 +1150,8 @@ static const struct snd_soc_dai_ops inte
 	.prepare = intel_prepare,
 	.hw_free = intel_hw_free,
 	.shutdown = intel_shutdown,
-	.set_sdw_stream = intel_pdm_set_sdw_stream,
-	.get_sdw_stream = intel_get_sdw_stream,
+	.set_stream = intel_pdm_set_sdw_stream,
+	.get_stream = intel_get_sdw_stream,
 };
 
 static const struct snd_soc_component_driver dai_component = {
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -649,8 +649,8 @@ static int qcom_swrm_startup(struct snd_
 	ctrl->sruntime[dai->id] = sruntime;
 
 	for_each_rtd_codec_dais(rtd, i, codec_dai) {
-		ret = snd_soc_dai_set_sdw_stream(codec_dai, sruntime,
-						 substream->stream);
+		ret = snd_soc_dai_set_stream(codec_dai, sruntime,
+					     substream->stream);
 		if (ret < 0 && ret != -ENOTSUPP) {
 			dev_err(dai->dev, "Failed to set sdw stream on %s",
 				codec_dai->name);
@@ -676,8 +676,8 @@ static const struct snd_soc_dai_ops qcom
 	.hw_free = qcom_swrm_hw_free,
 	.startup = qcom_swrm_startup,
 	.shutdown = qcom_swrm_shutdown,
-	.set_sdw_stream = qcom_swrm_set_sdw_stream,
-	.get_sdw_stream = qcom_swrm_get_sdw_stream,
+	.set_stream = qcom_swrm_set_sdw_stream,
+	.get_stream = qcom_swrm_get_sdw_stream,
 };
 
 static const struct snd_soc_component_driver qcom_swrm_dai_component = {
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1860,7 +1860,7 @@ static int set_stream(struct snd_pcm_sub
 
 	/* Set stream pointer on all DAIs */
 	for_each_rtd_dais(rtd, i, dai) {
-		ret = snd_soc_dai_set_sdw_stream(dai, sdw_stream, substream->stream);
+		ret = snd_soc_dai_set_stream(dai, sdw_stream, substream->stream);
 		if (ret < 0) {
 			dev_err(rtd->dev, "failed to set stream pointer on dai %s", dai->name);
 			break;
@@ -1931,7 +1931,7 @@ void sdw_shutdown_stream(void *sdw_subst
 	/* Find stream from first CPU DAI */
 	dai = asoc_rtd_to_cpu(rtd, 0);
 
-	sdw_stream = snd_soc_dai_get_sdw_stream(dai, substream->stream);
+	sdw_stream = snd_soc_dai_get_stream(dai, substream->stream);
 
 	if (IS_ERR(sdw_stream)) {
 		dev_err(rtd->dev, "no stream found for DAI %s", dai->name);
--- a/include/sound/soc-dai.h
+++ b/include/sound/soc-dai.h
@@ -239,9 +239,9 @@ struct snd_soc_dai_ops {
 			unsigned int *rx_num, unsigned int *rx_slot);
 	int (*set_tristate)(struct snd_soc_dai *dai, int tristate);
 
-	int (*set_sdw_stream)(struct snd_soc_dai *dai,
-			void *stream, int direction);
-	void *(*get_sdw_stream)(struct snd_soc_dai *dai, int direction);
+	int (*set_stream)(struct snd_soc_dai *dai,
+			  void *stream, int direction);
+	void *(*get_stream)(struct snd_soc_dai *dai, int direction);
 
 	/*
 	 * DAI digital mute - optional.
@@ -446,42 +446,42 @@ static inline void *snd_soc_dai_get_drvd
 }
 
 /**
- * snd_soc_dai_set_sdw_stream() - Configures a DAI for SDW stream operation
+ * snd_soc_dai_set_stream() - Configures a DAI for stream operation
  * @dai: DAI
- * @stream: STREAM
+ * @stream: STREAM (opaque structure depending on DAI type)
  * @direction: Stream direction(Playback/Capture)
- * SoundWire subsystem doesn't have a notion of direction and we reuse
+ * Some subsystems, such as SoundWire, don't have a notion of direction and we reuse
  * the ASoC stream direction to configure sink/source ports.
  * Playback maps to source ports and Capture for sink ports.
  *
  * This should be invoked with NULL to clear the stream set previously.
  * Returns 0 on success, a negative error code otherwise.
  */
-static inline int snd_soc_dai_set_sdw_stream(struct snd_soc_dai *dai,
-				void *stream, int direction)
+static inline int snd_soc_dai_set_stream(struct snd_soc_dai *dai,
+					 void *stream, int direction)
 {
-	if (dai->driver->ops->set_sdw_stream)
-		return dai->driver->ops->set_sdw_stream(dai, stream, direction);
+	if (dai->driver->ops->set_stream)
+		return dai->driver->ops->set_stream(dai, stream, direction);
 	else
 		return -ENOTSUPP;
 }
 
 /**
- * snd_soc_dai_get_sdw_stream() - Retrieves SDW stream from DAI
+ * snd_soc_dai_get_stream() - Retrieves stream from DAI
  * @dai: DAI
  * @direction: Stream direction(Playback/Capture)
  *
  * This routine only retrieves that was previously configured
- * with snd_soc_dai_get_sdw_stream()
+ * with snd_soc_dai_get_stream()
  *
  * Returns pointer to stream or an ERR_PTR value, e.g.
  * ERR_PTR(-ENOTSUPP) if callback is not supported;
  */
-static inline void *snd_soc_dai_get_sdw_stream(struct snd_soc_dai *dai,
-					       int direction)
+static inline void *snd_soc_dai_get_stream(struct snd_soc_dai *dai,
+					   int direction)
 {
-	if (dai->driver->ops->get_sdw_stream)
-		return dai->driver->ops->get_sdw_stream(dai, direction);
+	if (dai->driver->ops->get_stream)
+		return dai->driver->ops->get_stream(dai, direction);
 	else
 		return ERR_PTR(-ENOTSUPP);
 }
--- a/sound/soc/codecs/max98373-sdw.c
+++ b/sound/soc/codecs/max98373-sdw.c
@@ -728,7 +728,7 @@ static int max98373_sdw_set_tdm_slot(str
 static const struct snd_soc_dai_ops max98373_dai_sdw_ops = {
 	.hw_params = max98373_sdw_dai_hw_params,
 	.hw_free = max98373_pcm_hw_free,
-	.set_sdw_stream = max98373_set_sdw_stream,
+	.set_stream = max98373_set_sdw_stream,
 	.shutdown = max98373_shutdown,
 	.set_tdm_slot = max98373_sdw_set_tdm_slot,
 };
--- a/sound/soc/codecs/rt1308-sdw.c
+++ b/sound/soc/codecs/rt1308-sdw.c
@@ -613,7 +613,7 @@ static const struct snd_soc_component_dr
 static const struct snd_soc_dai_ops rt1308_aif_dai_ops = {
 	.hw_params = rt1308_sdw_hw_params,
 	.hw_free	= rt1308_sdw_pcm_hw_free,
-	.set_sdw_stream	= rt1308_set_sdw_stream,
+	.set_stream	= rt1308_set_sdw_stream,
 	.shutdown	= rt1308_sdw_shutdown,
 	.set_tdm_slot	= rt1308_sdw_set_tdm_slot,
 };
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -272,7 +272,7 @@ static int rt5682_sdw_hw_free(struct snd
 static struct snd_soc_dai_ops rt5682_sdw_ops = {
 	.hw_params	= rt5682_sdw_hw_params,
 	.hw_free	= rt5682_sdw_hw_free,
-	.set_sdw_stream	= rt5682_set_sdw_stream,
+	.set_stream	= rt5682_set_sdw_stream,
 	.shutdown	= rt5682_sdw_shutdown,
 };
 
--- a/sound/soc/codecs/rt700.c
+++ b/sound/soc/codecs/rt700.c
@@ -1005,7 +1005,7 @@ static int rt700_pcm_hw_free(struct snd_
 static struct snd_soc_dai_ops rt700_ops = {
 	.hw_params	= rt700_pcm_hw_params,
 	.hw_free	= rt700_pcm_hw_free,
-	.set_sdw_stream	= rt700_set_sdw_stream,
+	.set_stream	= rt700_set_sdw_stream,
 	.shutdown	= rt700_shutdown,
 };
 
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -1059,7 +1059,7 @@ static int rt711_pcm_hw_free(struct snd_
 static struct snd_soc_dai_ops rt711_ops = {
 	.hw_params	= rt711_pcm_hw_params,
 	.hw_free	= rt711_pcm_hw_free,
-	.set_sdw_stream	= rt711_set_sdw_stream,
+	.set_stream	= rt711_set_sdw_stream,
 	.shutdown	= rt711_shutdown,
 };
 
--- a/sound/soc/codecs/rt715.c
+++ b/sound/soc/codecs/rt715.c
@@ -686,7 +686,7 @@ static int rt715_pcm_hw_free(struct snd_
 static struct snd_soc_dai_ops rt715_ops = {
 	.hw_params	= rt715_pcm_hw_params,
 	.hw_free	= rt715_pcm_hw_free,
-	.set_sdw_stream	= rt715_set_sdw_stream,
+	.set_stream	= rt715_set_sdw_stream,
 	.shutdown	= rt715_shutdown,
 };
 
--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -1026,7 +1026,7 @@ static struct snd_soc_dai_ops wsa881x_da
 	.hw_params = wsa881x_hw_params,
 	.hw_free = wsa881x_hw_free,
 	.mute_stream = wsa881x_digital_mute,
-	.set_sdw_stream = wsa881x_set_sdw_stream,
+	.set_stream = wsa881x_set_sdw_stream,
 };
 
 static struct snd_soc_dai_driver wsa881x_dais[] = {
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -231,7 +231,7 @@ int sdw_prepare(struct snd_pcm_substream
 	/* Find stream from first CPU DAI */
 	dai = asoc_rtd_to_cpu(rtd, 0);
 
-	sdw_stream = snd_soc_dai_get_sdw_stream(dai, substream->stream);
+	sdw_stream = snd_soc_dai_get_stream(dai, substream->stream);
 
 	if (IS_ERR(sdw_stream)) {
 		dev_err(rtd->dev, "no stream found for DAI %s", dai->name);
@@ -251,7 +251,7 @@ int sdw_trigger(struct snd_pcm_substream
 	/* Find stream from first CPU DAI */
 	dai = asoc_rtd_to_cpu(rtd, 0);
 
-	sdw_stream = snd_soc_dai_get_sdw_stream(dai, substream->stream);
+	sdw_stream = snd_soc_dai_get_stream(dai, substream->stream);
 
 	if (IS_ERR(sdw_stream)) {
 		dev_err(rtd->dev, "no stream found for DAI %s", dai->name);
@@ -290,7 +290,7 @@ int sdw_hw_free(struct snd_pcm_substream
 	/* Find stream from first CPU DAI */
 	dai = asoc_rtd_to_cpu(rtd, 0);
 
-	sdw_stream = snd_soc_dai_get_sdw_stream(dai, substream->stream);
+	sdw_stream = snd_soc_dai_get_stream(dai, substream->stream);
 
 	if (IS_ERR(sdw_stream)) {
 		dev_err(rtd->dev, "no stream found for DAI %s", dai->name);
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -56,8 +56,8 @@ static int sdm845_slim_snd_hw_params(str
 	int ret = 0, i;
 
 	for_each_rtd_codec_dais(rtd, i, codec_dai) {
-		sruntime = snd_soc_dai_get_sdw_stream(codec_dai,
-						      substream->stream);
+		sruntime = snd_soc_dai_get_stream(codec_dai,
+						  substream->stream);
 		if (sruntime != ERR_PTR(-ENOTSUPP))
 			pdata->sruntime[cpu_dai->id] = sruntime;
 


