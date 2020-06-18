Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080921FDBC0
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbgFRBO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbgFRBO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B79BD20EDD;
        Thu, 18 Jun 2020 01:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442867;
        bh=xS/sOfYhQmXqBYyWzUfT3F1aKVDn9c/U3LLDYZoLQBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSqBk/p2Gpech5rbXDPzjkIRxoMPl9bf7930YnJRV7z2ak/2B+BbGz3mJydyIAw3C
         gZZKz5ugKpWL01EpY/51YLmT+v390duizNr9GeuRJiHYVuquT/x7YDHzWF3CZsuNbO
         /Uv59FhObY/tjp2SxTpciV9o9xMDRCmyBzKku3jg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 294/388] ASoC: dapm: Move dai_link widgets to runtime to fix use after free
Date:   Wed, 17 Jun 2020 21:06:31 -0400
Message-Id: <20200618010805.600873-294-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit f4aa5e214eeaf7f1c7f157526a5aa29784cb6a1f ]

The newly added CODEC to CODEC DAI link widget pointers in
snd_soc_dai_link are better placed in snd_soc_pcm_runtime.
snd_soc_dai_link is really intended for static configuration of
the DAI, and the runtime for dynamic data.  The snd_soc_dai_link
structures are not destroyed if the card is unbound. The widgets
are cleared up on unbind, however if the card is rebound as the
snd_soc_dai_link structures are reused these pointers will be left at
their old values, causing access to freed memory.

Fixes: 595571cca4de ("ASoC: dapm: Fix regression introducing multiple copies of DAI widgets")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20200526161930.30759-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h  |  6 +++---
 sound/soc/soc-dapm.c | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index e0371e70242d..8e480efeda2a 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -790,9 +790,6 @@ struct snd_soc_dai_link {
 	const struct snd_soc_pcm_stream *params;
 	unsigned int num_params;
 
-	struct snd_soc_dapm_widget *playback_widget;
-	struct snd_soc_dapm_widget *capture_widget;
-
 	unsigned int dai_fmt;           /* format to set on init */
 
 	enum snd_soc_dpcm_trigger trigger[2]; /* trigger type for DPCM */
@@ -1156,6 +1153,9 @@ struct snd_soc_pcm_runtime {
 	struct snd_soc_dai **cpu_dais;
 	unsigned int num_cpus;
 
+	struct snd_soc_dapm_widget *playback_widget;
+	struct snd_soc_dapm_widget *capture_widget;
+
 	struct delayed_work delayed_work;
 	void (*close_delayed_work_func)(struct snd_soc_pcm_runtime *rtd);
 #ifdef CONFIG_DEBUG_FS
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index e2632841b321..c0aa64ff8e32 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -4340,16 +4340,16 @@ static void dapm_connect_dai_pair(struct snd_soc_card *card,
 	codec = codec_dai->playback_widget;
 
 	if (playback_cpu && codec) {
-		if (dai_link->params && !dai_link->playback_widget) {
+		if (dai_link->params && !rtd->playback_widget) {
 			substream = streams[SNDRV_PCM_STREAM_PLAYBACK].substream;
 			dai = snd_soc_dapm_new_dai(card, substream, "playback");
 			if (IS_ERR(dai))
 				goto capture;
-			dai_link->playback_widget = dai;
+			rtd->playback_widget = dai;
 		}
 
 		dapm_connect_dai_routes(&card->dapm, cpu_dai, playback_cpu,
-					dai_link->playback_widget,
+					rtd->playback_widget,
 					codec_dai, codec);
 	}
 
@@ -4358,16 +4358,16 @@ static void dapm_connect_dai_pair(struct snd_soc_card *card,
 	codec = codec_dai->capture_widget;
 
 	if (codec && capture_cpu) {
-		if (dai_link->params && !dai_link->capture_widget) {
+		if (dai_link->params && !rtd->capture_widget) {
 			substream = streams[SNDRV_PCM_STREAM_CAPTURE].substream;
 			dai = snd_soc_dapm_new_dai(card, substream, "capture");
 			if (IS_ERR(dai))
 				return;
-			dai_link->capture_widget = dai;
+			rtd->capture_widget = dai;
 		}
 
 		dapm_connect_dai_routes(&card->dapm, codec_dai, codec,
-					dai_link->capture_widget,
+					rtd->capture_widget,
 					cpu_dai, capture_cpu);
 	}
 }
-- 
2.25.1

