Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91EF1BFD84
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgD3Nuz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgD3Nux (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:50:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F323217BA;
        Thu, 30 Apr 2020 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254652;
        bh=V8mornNvh3gvp/ggw/EEbCBaN2cEIA1Pmm4A05Vn8uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rf5jTpt/JwbfIHusZjmeQ0sNq4P982xMKIeWmj2i5BBfslQpGHGfZUU+0yfpcw6o4
         H+A7lXwtZop68gW+so/XsbXvsnlJ4T+wSpU3E5F+mtNtY7d00UkDWfBqHM94TEQYFH
         EjXT/PSXs4iGUw/bA2Qiqayj9emIG8K8TIMB29a4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 07/79] ASoC: topology: Add missing memory checks
Date:   Thu, 30 Apr 2020 09:49:31 -0400
Message-Id: <20200430135043.19851-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit abc3caac24501008465fdb55c5e89e16d58d5a3d ]

kstrdup is an allocation function and it can fail, so its return value
should be checked and handled appropriately.

In order to check all cases, we need to modify set_stream_info to return
a value, so check that everything went correctly when doing kstrdup().
Later add proper checks and error handlers.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200327204729.397-2-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 62 +++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 13 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index a152409e8746e..7a7c427de95d6 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1766,10 +1766,13 @@ static int soc_tplg_dapm_complete(struct soc_tplg *tplg)
 	return 0;
 }
 
-static void set_stream_info(struct snd_soc_pcm_stream *stream,
+static int set_stream_info(struct snd_soc_pcm_stream *stream,
 	struct snd_soc_tplg_stream_caps *caps)
 {
 	stream->stream_name = kstrdup(caps->name, GFP_KERNEL);
+	if (!stream->stream_name)
+		return -ENOMEM;
+
 	stream->channels_min = le32_to_cpu(caps->channels_min);
 	stream->channels_max = le32_to_cpu(caps->channels_max);
 	stream->rates = le32_to_cpu(caps->rates);
@@ -1777,6 +1780,8 @@ static void set_stream_info(struct snd_soc_pcm_stream *stream,
 	stream->rate_max = le32_to_cpu(caps->rate_max);
 	stream->formats = le64_to_cpu(caps->formats);
 	stream->sig_bits = le32_to_cpu(caps->sig_bits);
+
+	return 0;
 }
 
 static void set_dai_flags(struct snd_soc_dai_driver *dai_drv,
@@ -1812,20 +1817,29 @@ static int soc_tplg_dai_create(struct soc_tplg *tplg,
 	if (dai_drv == NULL)
 		return -ENOMEM;
 
-	if (strlen(pcm->dai_name))
+	if (strlen(pcm->dai_name)) {
 		dai_drv->name = kstrdup(pcm->dai_name, GFP_KERNEL);
+		if (!dai_drv->name) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
 	dai_drv->id = le32_to_cpu(pcm->dai_id);
 
 	if (pcm->playback) {
 		stream = &dai_drv->playback;
 		caps = &pcm->caps[SND_SOC_TPLG_STREAM_PLAYBACK];
-		set_stream_info(stream, caps);
+		ret = set_stream_info(stream, caps);
+		if (ret < 0)
+			goto err;
 	}
 
 	if (pcm->capture) {
 		stream = &dai_drv->capture;
 		caps = &pcm->caps[SND_SOC_TPLG_STREAM_CAPTURE];
-		set_stream_info(stream, caps);
+		ret = set_stream_info(stream, caps);
+		if (ret < 0)
+			goto err;
 	}
 
 	if (pcm->compress)
@@ -1835,11 +1849,7 @@ static int soc_tplg_dai_create(struct soc_tplg *tplg,
 	ret = soc_tplg_dai_load(tplg, dai_drv, pcm, NULL);
 	if (ret < 0) {
 		dev_err(tplg->comp->dev, "ASoC: DAI loading failed\n");
-		kfree(dai_drv->playback.stream_name);
-		kfree(dai_drv->capture.stream_name);
-		kfree(dai_drv->name);
-		kfree(dai_drv);
-		return ret;
+		goto err;
 	}
 
 	dai_drv->dobj.index = tplg->index;
@@ -1860,6 +1870,14 @@ static int soc_tplg_dai_create(struct soc_tplg *tplg,
 		return ret;
 	}
 
+	return 0;
+
+err:
+	kfree(dai_drv->playback.stream_name);
+	kfree(dai_drv->capture.stream_name);
+	kfree(dai_drv->name);
+	kfree(dai_drv);
+
 	return ret;
 }
 
@@ -1916,11 +1934,20 @@ static int soc_tplg_fe_link_create(struct soc_tplg *tplg,
 	if (strlen(pcm->pcm_name)) {
 		link->name = kstrdup(pcm->pcm_name, GFP_KERNEL);
 		link->stream_name = kstrdup(pcm->pcm_name, GFP_KERNEL);
+		if (!link->name || !link->stream_name) {
+			ret = -ENOMEM;
+			goto err;
+		}
 	}
 	link->id = le32_to_cpu(pcm->pcm_id);
 
-	if (strlen(pcm->dai_name))
+	if (strlen(pcm->dai_name)) {
 		link->cpus->dai_name = kstrdup(pcm->dai_name, GFP_KERNEL);
+		if (!link->cpus->dai_name) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
 
 	link->codecs->name = "snd-soc-dummy";
 	link->codecs->dai_name = "snd-soc-dummy-dai";
@@ -2436,13 +2463,17 @@ static int soc_tplg_dai_config(struct soc_tplg *tplg,
 	if (d->playback) {
 		stream = &dai_drv->playback;
 		caps = &d->caps[SND_SOC_TPLG_STREAM_PLAYBACK];
-		set_stream_info(stream, caps);
+		ret = set_stream_info(stream, caps);
+		if (ret < 0)
+			goto err;
 	}
 
 	if (d->capture) {
 		stream = &dai_drv->capture;
 		caps = &d->caps[SND_SOC_TPLG_STREAM_CAPTURE];
-		set_stream_info(stream, caps);
+		ret = set_stream_info(stream, caps);
+		if (ret < 0)
+			goto err;
 	}
 
 	if (d->flag_mask)
@@ -2454,10 +2485,15 @@ static int soc_tplg_dai_config(struct soc_tplg *tplg,
 	ret = soc_tplg_dai_load(tplg, dai_drv, NULL, dai);
 	if (ret < 0) {
 		dev_err(tplg->comp->dev, "ASoC: DAI loading failed\n");
-		return ret;
+		goto err;
 	}
 
 	return 0;
+
+err:
+	kfree(dai_drv->playback.stream_name);
+	kfree(dai_drv->capture.stream_name);
+	return ret;
 }
 
 /* load physical DAI elements */
-- 
2.20.1

