Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B223E259A
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbhHFIVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243235AbhHFIUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFA7461167;
        Fri,  6 Aug 2021 08:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237998;
        bh=Ej98UEAXvU0P4SOOvMrgwutqPBjgxF3O0F2Do77hzaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYdffRasvu1EfHa15hDAZoqOFRz76VLwk+e7I3jp+8iyAXrDAjvjTMW45j/uw0tcN
         5MQ/Go9CKvavNwKoMyD0c6Iwmiex8WuY4sBNhx9u6BfqjFC2oL8Yw14BLXvbX3Ww2f
         tO6OCZt2b5M1XdVKccWc14gjYSkP9tUZ3vIXuKAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bard Liao <bard.liao@intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 13/35] ASoC: Intel: boards: fix xrun issue on platform with max98373
Date:   Fri,  6 Aug 2021 10:16:56 +0200
Message-Id: <20210806081114.153290079@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rander Wang <rander.wang@intel.com>

[ Upstream commit 33c8516841ea4fa12fdb8961711bf95095c607ee ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw_max98373.c | 81 +++++++++++++++--------
 1 file changed, 53 insertions(+), 28 deletions(-)

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
 
-- 
2.30.2



