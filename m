Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D00664A0A
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbjAJS3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbjAJS2N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:28:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052194D493
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:23:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70365CE18D1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CEEC433D2;
        Tue, 10 Jan 2023 18:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375032;
        bh=/Oj5os6pdxltEpzZhXcd60ZqzwRIJlguGBGE1JHreP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ch3XEnttH6Qvu8ratlV3EJ+FrTjB1IxRav0bw9U7pd3QN4ZYu9EJkSgEliMoP+hNv
         w/0hbL3OKITbU886q7Klx/EGl1WwqASYGWWa0M+IT8Pgr/jLr9GHUvj8w4tpcvjKav
         Gi4lqv8ASzoMpFQ9SyaVQ2RVoMiJzF1WMSDqYCQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 055/290] ASoC: Intel/SOF: use set_stream() instead of set_tdm_slots() for HDAudio
Date:   Tue, 10 Jan 2023 19:02:27 +0100
Message-Id: <20230110180033.517137497@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

commit 636110411ca726f19ef8e87b0be51bb9a4cdef06 upstream.

Overloading the tx_mask with a linear value is asking for trouble and
only works because the codec_dai hw_params() is called before the
cpu_dai hw_params().

Move to the more generic set_stream() API to pass the hdac_stream
information.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211224021034.26635-6-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/hdac_hda.c       |   22 +++++++++++-----------
 sound/soc/intel/skylake/skl-pcm.c |    7 ++-----
 sound/soc/sof/intel/hda-dai.c     |    7 ++-----
 3 files changed, 15 insertions(+), 21 deletions(-)

--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -46,9 +46,8 @@ static int hdac_hda_dai_hw_params(struct
 				  struct snd_soc_dai *dai);
 static int hdac_hda_dai_hw_free(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai);
-static int hdac_hda_dai_set_tdm_slot(struct snd_soc_dai *dai,
-				     unsigned int tx_mask, unsigned int rx_mask,
-				     int slots, int slot_width);
+static int hdac_hda_dai_set_stream(struct snd_soc_dai *dai, void *stream,
+				   int direction);
 static struct hda_pcm *snd_soc_find_pcm_from_dai(struct hdac_hda_priv *hda_pvt,
 						 struct snd_soc_dai *dai);
 
@@ -58,7 +57,7 @@ static const struct snd_soc_dai_ops hdac
 	.prepare = hdac_hda_dai_prepare,
 	.hw_params = hdac_hda_dai_hw_params,
 	.hw_free = hdac_hda_dai_hw_free,
-	.set_tdm_slot = hdac_hda_dai_set_tdm_slot,
+	.set_stream = hdac_hda_dai_set_stream,
 };
 
 static struct snd_soc_dai_driver hdac_hda_dais[] = {
@@ -180,21 +179,22 @@ static struct snd_soc_dai_driver hdac_hd
 
 };
 
-static int hdac_hda_dai_set_tdm_slot(struct snd_soc_dai *dai,
-				     unsigned int tx_mask, unsigned int rx_mask,
-				     int slots, int slot_width)
+static int hdac_hda_dai_set_stream(struct snd_soc_dai *dai,
+				   void *stream, int direction)
 {
 	struct snd_soc_component *component = dai->component;
 	struct hdac_hda_priv *hda_pvt;
 	struct hdac_hda_pcm *pcm;
+	struct hdac_stream *hstream;
+
+	if (!stream)
+		return -EINVAL;
 
 	hda_pvt = snd_soc_component_get_drvdata(component);
 	pcm = &hda_pvt->pcm[dai->id];
+	hstream = (struct hdac_stream *)stream;
 
-	if (tx_mask)
-		pcm->stream_tag[SNDRV_PCM_STREAM_PLAYBACK] = tx_mask;
-	else
-		pcm->stream_tag[SNDRV_PCM_STREAM_CAPTURE] = rx_mask;
+	pcm->stream_tag[direction] = hstream->stream_tag;
 
 	return 0;
 }
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -562,11 +562,8 @@ static int skl_link_hw_params(struct snd
 
 	stream_tag = hdac_stream(link_dev)->stream_tag;
 
-	/* set the stream tag in the codec dai dma params  */
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		snd_soc_dai_set_tdm_slot(codec_dai, stream_tag, 0, 0, 0);
-	else
-		snd_soc_dai_set_tdm_slot(codec_dai, 0, stream_tag, 0, 0);
+	/* set the hdac_stream in the codec dai */
+	snd_soc_dai_set_stream(codec_dai, hdac_stream(link_dev), substream->stream);
 
 	p_params.s_fmt = snd_pcm_format_width(params_format(params));
 	p_params.ch = params_channels(params);
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -236,11 +236,8 @@ static int hda_link_hw_params(struct snd
 	if (!link)
 		return -EINVAL;
 
-	/* set the stream tag in the codec dai dma params */
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		snd_soc_dai_set_tdm_slot(codec_dai, stream_tag, 0, 0, 0);
-	else
-		snd_soc_dai_set_tdm_slot(codec_dai, 0, stream_tag, 0, 0);
+	/* set the hdac_stream in the codec dai */
+	snd_soc_dai_set_stream(codec_dai, hdac_stream(link_dev), substream->stream);
 
 	p_params.s_fmt = snd_pcm_format_width(params_format(params));
 	p_params.ch = params_channels(params);


