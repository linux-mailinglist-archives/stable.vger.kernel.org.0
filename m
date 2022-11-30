Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D5463DF5C
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbiK3Sq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbiK3SqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:46:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C232BB14
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:46:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5535B61D73
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA30C433D6;
        Wed, 30 Nov 2022 18:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833968;
        bh=L67By6p/do5ynS7GAAN8Idv/C8Cm1WONIJTqSFKVJ9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keKe09GHDzbdkQ5o7gCGH4n2ALdvjwBVRFZXcSbtkCeD4u5ttx0czab67rNi8EUbj
         EGJ0mxSvuePU9QsJi7H168SgGCWLLOk7xPt85Joanqdr3iZz7kBaVb/YCNEL9/LKKL
         8ebXtVr0Vx6twoQs0MzOVdVS6iL8D6q4KOXvMOJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 053/289] ASoC: Intel: Drop hdac_ext usage for codec device creation
Date:   Wed, 30 Nov 2022 19:20:38 +0100
Message-Id: <20221130180545.331318735@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 3fd63658caed9494cca1d4789a66d3d2def2a0ab ]

To make snd_hda_codec_device_init() the only constructor for struct
hda_codec instances remaining tasks are:

1) no struct may wrap struct hda_codec as its base type
2) bus drivers (skylake and sof) which are the current hdac_ext users
   need to be adjusted to make use of newly added codec init and exit
   routines instead
3) as bus drivers (skylake and sof) are to be responsible for creating
   codec device and assigning it to hdac_hda_priv->codec,
   hdac_hda_dev_probe() has to be freed of that job

To keep git bisect happy, all of these in made in one-go.

Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220816111727.3218543-4-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 37882100cd06 ("ASoC: hdac_hda: fix hda pcm buffer overflow issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c                  | 26 +++++++-----------
 sound/soc/codecs/hdac_hda.h                  |  2 +-
 sound/soc/intel/boards/hda_dsp_common.c      |  2 +-
 sound/soc/intel/boards/skl_hda_dsp_generic.c |  2 +-
 sound/soc/intel/skylake/skl.c                | 26 ++++++++----------
 sound/soc/sof/intel/hda-codec.c              | 29 ++++++++------------
 6 files changed, 36 insertions(+), 51 deletions(-)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 8debcee59224..77df4c5b274a 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -246,7 +246,7 @@ static int hdac_hda_dai_hw_free(struct snd_pcm_substream *substream,
 		return -EINVAL;
 
 	hda_stream = &pcm->stream[substream->stream];
-	snd_hda_codec_cleanup(&hda_pvt->codec, hda_stream, substream);
+	snd_hda_codec_cleanup(hda_pvt->codec, hda_stream, substream);
 
 	return 0;
 }
@@ -264,7 +264,7 @@ static int hdac_hda_dai_prepare(struct snd_pcm_substream *substream,
 	int ret = 0;
 
 	hda_pvt = snd_soc_component_get_drvdata(component);
-	hdev = &hda_pvt->codec.core;
+	hdev = &hda_pvt->codec->core;
 	pcm = snd_soc_find_pcm_from_dai(hda_pvt, dai);
 	if (!pcm)
 		return -EINVAL;
@@ -274,7 +274,7 @@ static int hdac_hda_dai_prepare(struct snd_pcm_substream *substream,
 	stream = hda_pvt->pcm[dai->id].stream_tag[substream->stream];
 	format_val = hda_pvt->pcm[dai->id].format_val[substream->stream];
 
-	ret = snd_hda_codec_prepare(&hda_pvt->codec, hda_stream,
+	ret = snd_hda_codec_prepare(hda_pvt->codec, hda_stream,
 				    stream, format_val, substream);
 	if (ret < 0)
 		dev_err(&hdev->dev, "codec prepare failed %d\n", ret);
@@ -299,7 +299,7 @@ static int hdac_hda_dai_open(struct snd_pcm_substream *substream,
 
 	hda_stream = &pcm->stream[substream->stream];
 
-	return hda_stream->ops.open(hda_stream, &hda_pvt->codec, substream);
+	return hda_stream->ops.open(hda_stream, hda_pvt->codec, substream);
 }
 
 static void hdac_hda_dai_close(struct snd_pcm_substream *substream,
@@ -317,7 +317,7 @@ static void hdac_hda_dai_close(struct snd_pcm_substream *substream,
 
 	hda_stream = &pcm->stream[substream->stream];
 
-	hda_stream->ops.close(hda_stream, &hda_pvt->codec, substream);
+	hda_stream->ops.close(hda_stream, hda_pvt->codec, substream);
 
 	snd_hda_codec_pcm_put(pcm);
 }
@@ -325,7 +325,7 @@ static void hdac_hda_dai_close(struct snd_pcm_substream *substream,
 static struct hda_pcm *snd_soc_find_pcm_from_dai(struct hdac_hda_priv *hda_pvt,
 						 struct snd_soc_dai *dai)
 {
-	struct hda_codec *hcodec = &hda_pvt->codec;
+	struct hda_codec *hcodec = hda_pvt->codec;
 	struct hda_pcm *cpcm;
 	const char *pcm_name;
 
@@ -394,8 +394,8 @@ static int hdac_hda_codec_probe(struct snd_soc_component *component)
 			snd_soc_component_get_drvdata(component);
 	struct snd_soc_dapm_context *dapm =
 			snd_soc_component_get_dapm(component);
-	struct hdac_device *hdev = &hda_pvt->codec.core;
-	struct hda_codec *hcodec = &hda_pvt->codec;
+	struct hdac_device *hdev = &hda_pvt->codec->core;
+	struct hda_codec *hcodec = hda_pvt->codec;
 	struct hdac_ext_link *hlink;
 	hda_codec_patch_t patch;
 	int ret;
@@ -515,8 +515,8 @@ static void hdac_hda_codec_remove(struct snd_soc_component *component)
 {
 	struct hdac_hda_priv *hda_pvt =
 		      snd_soc_component_get_drvdata(component);
-	struct hdac_device *hdev = &hda_pvt->codec.core;
-	struct hda_codec *codec = &hda_pvt->codec;
+	struct hdac_device *hdev = &hda_pvt->codec->core;
+	struct hda_codec *codec = hda_pvt->codec;
 	struct hdac_ext_link *hlink = NULL;
 
 	hlink = snd_hdac_ext_bus_get_link(hdev->bus, dev_name(&hdev->dev));
@@ -584,7 +584,6 @@ static const struct snd_soc_component_driver hdac_hda_codec = {
 static int hdac_hda_dev_probe(struct hdac_device *hdev)
 {
 	struct hdac_ext_link *hlink;
-	struct hdac_hda_priv *hda_pvt;
 	int ret;
 
 	/* hold the ref while we probe */
@@ -595,10 +594,6 @@ static int hdac_hda_dev_probe(struct hdac_device *hdev)
 	}
 	snd_hdac_ext_bus_link_get(hdev->bus, hlink);
 
-	hda_pvt = hdac_to_hda_priv(hdev);
-	if (!hda_pvt)
-		return -ENOMEM;
-
 	/* ASoC specific initialization */
 	ret = devm_snd_soc_register_component(&hdev->dev,
 					 &hdac_hda_codec, hdac_hda_dais,
@@ -608,7 +603,6 @@ static int hdac_hda_dev_probe(struct hdac_device *hdev)
 		return ret;
 	}
 
-	dev_set_drvdata(&hdev->dev, hda_pvt);
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 
 	return ret;
diff --git a/sound/soc/codecs/hdac_hda.h b/sound/soc/codecs/hdac_hda.h
index d0efc5e254ae..fc19c34ca00e 100644
--- a/sound/soc/codecs/hdac_hda.h
+++ b/sound/soc/codecs/hdac_hda.h
@@ -23,7 +23,7 @@ struct hdac_hda_pcm {
 };
 
 struct hdac_hda_priv {
-	struct hda_codec codec;
+	struct hda_codec *codec;
 	struct hdac_hda_pcm pcm[HDAC_LAST_DAI_ID];
 	bool need_display_power;
 };
diff --git a/sound/soc/intel/boards/hda_dsp_common.c b/sound/soc/intel/boards/hda_dsp_common.c
index 83c7dfbccd9d..04b7d4f7f9e2 100644
--- a/sound/soc/intel/boards/hda_dsp_common.c
+++ b/sound/soc/intel/boards/hda_dsp_common.c
@@ -54,7 +54,7 @@ int hda_dsp_hdmi_build_controls(struct snd_soc_card *card,
 		return -EINVAL;
 
 	hda_pvt = snd_soc_component_get_drvdata(comp);
-	hcodec = &hda_pvt->codec;
+	hcodec = hda_pvt->codec;
 
 	list_for_each_entry(hpcm, &hcodec->pcm_list_head, list) {
 		spcm = hda_dsp_hdmi_pcm_handle(card, i);
diff --git a/sound/soc/intel/boards/skl_hda_dsp_generic.c b/sound/soc/intel/boards/skl_hda_dsp_generic.c
index 81144efb4b44..879ebba52832 100644
--- a/sound/soc/intel/boards/skl_hda_dsp_generic.c
+++ b/sound/soc/intel/boards/skl_hda_dsp_generic.c
@@ -190,7 +190,7 @@ static void skl_set_hda_codec_autosuspend_delay(struct snd_soc_card *card)
 			 * all codecs are on the same bus, so it's sufficient
 			 * to look up only the first one
 			 */
-			snd_hda_set_power_save(hda_pvt->codec.bus,
+			snd_hda_set_power_save(hda_pvt->codec->bus,
 					       HDA_CODEC_AUTOSUSPEND_DELAY_MS);
 			break;
 		}
diff --git a/sound/soc/intel/skylake/skl.c b/sound/soc/intel/skylake/skl.c
index 33b0ed6b0534..c7c1cad2a753 100644
--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -694,7 +694,7 @@ static void skl_codec_device_exit(struct device *dev)
 	snd_hdac_device_exit(dev_to_hdac_dev(dev));
 }
 
-static __maybe_unused struct hda_codec *skl_codec_device_init(struct hdac_bus *bus, int addr)
+static struct hda_codec *skl_codec_device_init(struct hdac_bus *bus, int addr)
 {
 	struct hda_codec *codec;
 	int ret;
@@ -729,9 +729,8 @@ static int probe_codec(struct hdac_bus *bus, int addr)
 	struct skl_dev *skl = bus_to_skl(bus);
 #if IS_ENABLED(CONFIG_SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC)
 	struct hdac_hda_priv *hda_codec;
-	int err;
 #endif
-	struct hdac_device *hdev;
+	struct hda_codec *codec;
 
 	mutex_lock(&bus->cmd_mutex);
 	snd_hdac_bus_send_cmd(bus, cmd);
@@ -747,25 +746,22 @@ static int probe_codec(struct hdac_bus *bus, int addr)
 	if (!hda_codec)
 		return -ENOMEM;
 
-	hda_codec->codec.bus = skl_to_hbus(skl);
-	hdev = &hda_codec->codec.core;
+	codec = skl_codec_device_init(bus, addr);
+	if (IS_ERR(codec))
+		return PTR_ERR(codec);
 
-	err = snd_hdac_ext_bus_device_init(bus, addr, hdev, HDA_DEV_ASOC);
-	if (err < 0)
-		return err;
+	hda_codec->codec = codec;
+	dev_set_drvdata(&codec->core.dev, hda_codec);
 
 	/* use legacy bus only for HDA codecs, idisp uses ext bus */
 	if ((res & 0xFFFF0000) != IDISP_INTEL_VENDOR_ID) {
-		hdev->type = HDA_DEV_LEGACY;
-		load_codec_module(&hda_codec->codec);
+		codec->core.type = HDA_DEV_LEGACY;
+		load_codec_module(hda_codec->codec);
 	}
 	return 0;
 #else
-	hdev = devm_kzalloc(&skl->pci->dev, sizeof(*hdev), GFP_KERNEL);
-	if (!hdev)
-		return -ENOMEM;
-
-	return snd_hdac_ext_bus_device_init(bus, addr, hdev, HDA_DEV_ASOC);
+	codec = skl_codec_device_init(bus, addr);
+	return PTR_ERR_OR_ZERO(codec);
 #endif /* CONFIG_SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC */
 }
 
diff --git a/sound/soc/sof/intel/hda-codec.c b/sound/soc/sof/intel/hda-codec.c
index 4c128ba02340..73336648cd25 100644
--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -114,8 +114,7 @@ static void hda_codec_device_exit(struct device *dev)
 	snd_hdac_device_exit(dev_to_hdac_dev(dev));
 }
 
-static __maybe_unused struct hda_codec *
-hda_codec_device_init(struct hdac_bus *bus, int addr, int type)
+static struct hda_codec *hda_codec_device_init(struct hdac_bus *bus, int addr, int type)
 {
 	struct hda_codec *codec;
 	int ret;
@@ -145,11 +144,10 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 {
 #if IS_ENABLED(CONFIG_SND_SOC_SOF_HDA_AUDIO_CODEC)
 	struct hdac_hda_priv *hda_priv;
-	struct hda_codec *codec;
 	int type = HDA_DEV_LEGACY;
 #endif
 	struct hda_bus *hbus = sof_to_hbus(sdev);
-	struct hdac_device *hdev;
+	struct hda_codec *codec;
 	u32 hda_cmd = (address << 28) | (AC_NODE_ROOT << 20) |
 		(AC_VERB_PARAMETERS << 8) | AC_PAR_VENDOR_ID;
 	u32 resp = -1;
@@ -172,20 +170,20 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 	if (!hda_priv)
 		return -ENOMEM;
 
-	hda_priv->codec.bus = hbus;
-	hdev = &hda_priv->codec.core;
-	codec = &hda_priv->codec;
-
 	/* only probe ASoC codec drivers for HDAC-HDMI */
 	if (!hda_codec_use_common_hdmi && (resp & 0xFFFF0000) == IDISP_VID_INTEL)
 		type = HDA_DEV_ASOC;
 
-	ret = snd_hdac_ext_bus_device_init(&hbus->core, address, hdev, type);
+	codec = hda_codec_device_init(&hbus->core, address, type);
+	ret = PTR_ERR_OR_ZERO(codec);
 	if (ret < 0)
 		return ret;
 
+	hda_priv->codec = codec;
+	dev_set_drvdata(&codec->core.dev, hda_priv);
+
 	if ((resp & 0xFFFF0000) == IDISP_VID_INTEL) {
-		if (!hdev->bus->audio_component) {
+		if (!hbus->core.audio_component) {
 			dev_dbg(sdev->dev,
 				"iDisp hw present but no driver\n");
 			ret = -ENOENT;
@@ -211,15 +209,12 @@ static int hda_codec_probe(struct snd_sof_dev *sdev, int address,
 
 out:
 	if (ret < 0) {
-		snd_hdac_device_unregister(hdev);
-		put_device(&hdev->dev);
+		snd_hdac_device_unregister(&codec->core);
+		put_device(&codec->core.dev);
 	}
 #else
-	hdev = devm_kzalloc(sdev->dev, sizeof(*hdev), GFP_KERNEL);
-	if (!hdev)
-		return -ENOMEM;
-
-	ret = snd_hdac_ext_bus_device_init(&hbus->core, address, hdev, HDA_DEV_ASOC);
+	codec = hda_codec_device_init(&hbus->core, address);
+	ret = PTR_ERR_OR_ZERO(codec);
 #endif
 
 	return ret;
-- 
2.35.1



