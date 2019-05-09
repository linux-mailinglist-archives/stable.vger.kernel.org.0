Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57AB191F2
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbfEITCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727329AbfEISuO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:50:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15CA120578;
        Thu,  9 May 2019 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427813;
        bh=PDS8eu55y24Wnc6VtwE4FiX7zogrEQ5zgpSyw6c8EgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DGmRcxMdWMq+hyK/PrtjRsIlAIxTfUBAAu8jp3LgVMp7USn1qqft+cW+C9xfWHJxA
         wX8NobyUmdA5csfgjGO/ZZ/WTIMere4inW4vJTLrzKKlbuN1cSfFreOTnvjAXFstpu
         +ZQxfnqRZE0wRJm7RzJ/81FkR1w0/w66h+RuVh1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rander Wang <rander.wang@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 14/95] ASoC:hdac_hda:use correct format to setup hda codec
Date:   Thu,  9 May 2019 20:41:31 +0200
Message-Id: <20190509181310.355842749@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 03d0aa4d4fddce4a5d865d819a4d98bfc3d451e6 ]

The current implementation of the hdac_hda codec results in zero-valued
samples on capture and noise with headset playback when SOF is used on
platforms with an on-board HDaudio codec. This is root-caused to SOF
using be_hw_params_fixup, and the prepare() call using invalid runtime
fields to determine the format.

This patch moves the format handling to the hw_params() callback, as
done already for hdac_hdmi, to make sure the fixed-up information is
taken into account but keeps the codec initialization in prepare() as
the stream_tag is only available at that time. Moving everything in the
prepare() callback is possible but the code is less elegant so this
two-step solution was chosen.

The solution was tested with the SST driver with no regressions, and all
the issues with SOF playback and capture are solved.

Signed-off-by: Rander Wang <rander.wang@linux.intel.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 53 +++++++++++++++++++++++++++----------
 sound/soc/codecs/hdac_hda.h |  1 +
 2 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index ffecdaaa8cf2b..f889d94c8e3cf 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -38,6 +38,9 @@ static void hdac_hda_dai_close(struct snd_pcm_substream *substream,
 			       struct snd_soc_dai *dai);
 static int hdac_hda_dai_prepare(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai);
+static int hdac_hda_dai_hw_params(struct snd_pcm_substream *substream,
+				  struct snd_pcm_hw_params *params,
+				  struct snd_soc_dai *dai);
 static int hdac_hda_dai_hw_free(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai);
 static int hdac_hda_dai_set_tdm_slot(struct snd_soc_dai *dai,
@@ -50,6 +53,7 @@ static const struct snd_soc_dai_ops hdac_hda_dai_ops = {
 	.startup = hdac_hda_dai_open,
 	.shutdown = hdac_hda_dai_close,
 	.prepare = hdac_hda_dai_prepare,
+	.hw_params = hdac_hda_dai_hw_params,
 	.hw_free = hdac_hda_dai_hw_free,
 	.set_tdm_slot = hdac_hda_dai_set_tdm_slot,
 };
@@ -139,6 +143,39 @@ static int hdac_hda_dai_set_tdm_slot(struct snd_soc_dai *dai,
 	return 0;
 }
 
+static int hdac_hda_dai_hw_params(struct snd_pcm_substream *substream,
+				  struct snd_pcm_hw_params *params,
+				  struct snd_soc_dai *dai)
+{
+	struct snd_soc_component *component = dai->component;
+	struct hdac_hda_priv *hda_pvt;
+	unsigned int format_val;
+	unsigned int maxbps;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		maxbps = dai->driver->playback.sig_bits;
+	else
+		maxbps = dai->driver->capture.sig_bits;
+
+	hda_pvt = snd_soc_component_get_drvdata(component);
+	format_val = snd_hdac_calc_stream_format(params_rate(params),
+						 params_channels(params),
+						 params_format(params),
+						 maxbps,
+						 0);
+	if (!format_val) {
+		dev_err(dai->dev,
+			"invalid format_val, rate=%d, ch=%d, format=%d, maxbps=%d\n",
+			params_rate(params), params_channels(params),
+			params_format(params), maxbps);
+
+		return -EINVAL;
+	}
+
+	hda_pvt->pcm[dai->id].format_val[substream->stream] = format_val;
+	return 0;
+}
+
 static int hdac_hda_dai_hw_free(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai)
 {
@@ -162,10 +199,9 @@ static int hdac_hda_dai_prepare(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai)
 {
 	struct snd_soc_component *component = dai->component;
+	struct hda_pcm_stream *hda_stream;
 	struct hdac_hda_priv *hda_pvt;
-	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct hdac_device *hdev;
-	struct hda_pcm_stream *hda_stream;
 	unsigned int format_val;
 	struct hda_pcm *pcm;
 	unsigned int stream;
@@ -179,19 +215,8 @@ static int hdac_hda_dai_prepare(struct snd_pcm_substream *substream,
 
 	hda_stream = &pcm->stream[substream->stream];
 
-	format_val = snd_hdac_calc_stream_format(runtime->rate,
-						 runtime->channels,
-						 runtime->format,
-						 hda_stream->maxbps,
-						 0);
-	if (!format_val) {
-		dev_err(&hdev->dev,
-			"invalid format_val, rate=%d, ch=%d, format=%d\n",
-			runtime->rate, runtime->channels, runtime->format);
-		return -EINVAL;
-	}
-
 	stream = hda_pvt->pcm[dai->id].stream_tag[substream->stream];
+	format_val = hda_pvt->pcm[dai->id].format_val[substream->stream];
 
 	ret = snd_hda_codec_prepare(&hda_pvt->codec, hda_stream,
 				    stream, format_val, substream);
diff --git a/sound/soc/codecs/hdac_hda.h b/sound/soc/codecs/hdac_hda.h
index e444ef5933606..6b1bd4f428e70 100644
--- a/sound/soc/codecs/hdac_hda.h
+++ b/sound/soc/codecs/hdac_hda.h
@@ -8,6 +8,7 @@
 
 struct hdac_hda_pcm {
 	int stream_tag[2];
+	unsigned int format_val[2];
 };
 
 struct hdac_hda_priv {
-- 
2.20.1



