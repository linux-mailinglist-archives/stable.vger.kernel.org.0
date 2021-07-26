Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A4B3D57DF
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 12:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhGZKQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 06:16:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231792AbhGZKQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 06:16:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6772160E09;
        Mon, 26 Jul 2021 10:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627297047;
        bh=qkMcYP+W56dACE0st0j2m5etUr4yd2jkaTar8dd7Afs=;
        h=Subject:To:Cc:From:Date:From;
        b=zbztEr29SiECZaD2ZN/Lvsh0EoB8QvmpeAo6bBI27QeuHIYrvpIT/bYrFQ2jIoieP
         NDEW7qPNykrxxC5s2CSDkucPIp3d7hHInulQZu64uI4/n0JB6tu//Mq8gwS5bSWp9d
         DV3We05aOLbXCZSAEqy08ORqgNJ3ajU7GuR6pxss=
Subject: FAILED: patch "[PATCH] ASoC: Intel: boards: fix xrun issue on platform with max98373" failed to apply to 5.4-stable tree
To:     rander.wang@intel.com, bard.liao@intel.com, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com,
        pierre-louis.bossart@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 12:57:24 +0200
Message-ID: <1627297044134199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 33c8516841ea4fa12fdb8961711bf95095c607ee Mon Sep 17 00:00:00 2001
From: Rander Wang <rander.wang@intel.com>
Date: Fri, 25 Jun 2021 15:50:39 -0500
Subject: [PATCH] ASoC: Intel: boards: fix xrun issue on platform with max98373
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On TGL platform with max98373 codec the trigger start sequence is
fe first, then codec component and sdw link is the last. Recently
a delay was introduced in max98373 codec driver and this resulted
to the start of sdw stream transmission was delayed and the data
transmitted by fw can't be consumed by sdw controller, so xrun happened.

Adding delay in trigger function is a bad idea. This patch enable spk
pin in prepare function and disable it in hw_free to avoid xrun issue
caused by delay in trigger.

Fixes: 3a27875e91fb ("ASoC: max98373: Added 30ms turn on/off time delay")
BugLink: https://github.com/thesofproject/sof/issues/4066
Reviewed-by: Bard Liao <bard.liao@intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210625205042.65181-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/intel/boards/sof_sdw_max98373.c b/sound/soc/intel/boards/sof_sdw_max98373.c
index 0e7ed906b341..25daef910aee 100644
--- a/sound/soc/intel/boards/sof_sdw_max98373.c
+++ b/sound/soc/intel/boards/sof_sdw_max98373.c
@@ -55,43 +55,68 @@ static int spk_init(struct snd_soc_pcm_runtime *rtd)
 	return ret;
 }
 
-static int max98373_sdw_trigger(struct snd_pcm_substream *substream, int cmd)
+static int mx8373_enable_spk_pin(struct snd_pcm_substream *substream, bool enable)
 {
+	struct snd_soc_pcm_runtime *rtd = asoc_substream_to_rtd(substream);
+	struct snd_soc_dai *codec_dai;
+	struct snd_soc_dai *cpu_dai;
 	int ret;
+	int j;
 
-	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_START:
-	case SNDRV_PCM_TRIGGER_RESUME:
-	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		/* enable max98373 first */
-		ret = max_98373_trigger(substream, cmd);
-		if (ret < 0)
-			break;
-
-		ret = sdw_trigger(substream, cmd);
-		break;
-	case SNDRV_PCM_TRIGGER_STOP:
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		ret = sdw_trigger(substream, cmd);
-		if (ret < 0)
-			break;
-
-		ret = max_98373_trigger(substream, cmd);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
+	/* set spk pin by playback only */
+	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE)
+		return 0;
+
+	cpu_dai = asoc_rtd_to_cpu(rtd, 0);
+	for_each_rtd_codec_dais(rtd, j, codec_dai) {
+		struct snd_soc_dapm_context *dapm =
+				snd_soc_component_get_dapm(cpu_dai->component);
+		char pin_name[16];
+
+		snprintf(pin_name, ARRAY_SIZE(pin_name), "%s Spk",
+			 codec_dai->component->name_prefix);
+
+		if (enable)
+			ret = snd_soc_dapm_enable_pin(dapm, pin_name);
+		else
+			ret = snd_soc_dapm_disable_pin(dapm, pin_name);
+
+		if (!ret)
+			snd_soc_dapm_sync(dapm);
 	}
 
-	return ret;
+	return 0;
+}
+
+static int mx8373_sdw_prepare(struct snd_pcm_substream *substream)
+{
+	int ret = 0;
+
+	/* according to soc_pcm_prepare dai link prepare is called first */
+	ret = sdw_prepare(substream);
+	if (ret < 0)
+		return ret;
+
+	return mx8373_enable_spk_pin(substream, true);
+}
+
+static int mx8373_sdw_hw_free(struct snd_pcm_substream *substream)
+{
+	int ret = 0;
+
+	/* according to soc_pcm_hw_free dai link free is called first */
+	ret = sdw_hw_free(substream);
+	if (ret < 0)
+		return ret;
+
+	return mx8373_enable_spk_pin(substream, false);
 }
 
 static const struct snd_soc_ops max_98373_sdw_ops = {
 	.startup = sdw_startup,
-	.prepare = sdw_prepare,
-	.trigger = max98373_sdw_trigger,
-	.hw_free = sdw_hw_free,
+	.prepare = mx8373_sdw_prepare,
+	.trigger = sdw_trigger,
+	.hw_free = mx8373_sdw_hw_free,
 	.shutdown = sdw_shutdown,
 };
 

