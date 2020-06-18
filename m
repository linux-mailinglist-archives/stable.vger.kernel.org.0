Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91B41FDBFF
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgFRBPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728431AbgFRBPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B3FA21D79;
        Thu, 18 Jun 2020 01:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442954;
        bh=hsh8OBWkdJYDP6rXNi6v/fdteZHhnTVpUh3LbNud6rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7iQ1flQyJF5hbnCuCpopU7nMUFXrJA4W3FvD8nLrLKNMf3u3npudCymvZequaezp
         ij9R2VinBeYHjzdMuXosamEaY+nN4clB0JqKnyvmV0Pz+Sk5k0DV+KQ9p5u3s1mdaT
         ek+VwT1vRlA4QiRY7WROS8vZkXCHlA7bXR55F/+s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.7 362/388] ASoC: soc-pcm: dpcm: fix playback/capture checks
Date:   Wed, 17 Jun 2020 21:07:39 -0400
Message-Id: <20200618010805.600873-362-sashal@kernel.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit b73287f0b0745961b14e5ebcce92cc8ed24d4d52 ]

Recent changes in the ASoC core prevent multi-cpu BE dailinks from
being used. DPCM does support multi-cpu DAIs for BE Dailinks, but not
for FE.

Handle the FE checks first, and make sure all DAIs support the same
capabilities within the same dailink.

Fixes: 9b5db059366ae2 ("ASoC: soc-pcm: dpcm: Only allow playback/capture if supported")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@gmail.com>
BugLink: https://github.com/thesofproject/linux/issues/2031
Link: https://lore.kernel.org/r/20200608194415.4663-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-pcm.c | 44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 1f302de44052..39ce61c5b874 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2908,20 +2908,44 @@ int soc_new_pcm(struct snd_soc_pcm_runtime *rtd, int num)
 	struct snd_pcm *pcm;
 	char new_name[64];
 	int ret = 0, playback = 0, capture = 0;
+	int stream;
 	int i;
 
+	if (rtd->dai_link->dynamic && rtd->num_cpus > 1) {
+		dev_err(rtd->dev,
+			"DPCM doesn't support Multi CPU for Front-Ends yet\n");
+		return -EINVAL;
+	}
+
 	if (rtd->dai_link->dynamic || rtd->dai_link->no_pcm) {
-		cpu_dai = asoc_rtd_to_cpu(rtd, 0);
-		if (rtd->num_cpus > 1) {
-			dev_err(rtd->dev,
-				"DPCM doesn't support Multi CPU yet\n");
-			return -EINVAL;
+		if (rtd->dai_link->dpcm_playback) {
+			stream = SNDRV_PCM_STREAM_PLAYBACK;
+
+			for_each_rtd_cpu_dais(rtd, i, cpu_dai)
+				if (!snd_soc_dai_stream_valid(cpu_dai,
+							      stream)) {
+					dev_err(rtd->card->dev,
+						"CPU DAI %s for rtd %s does not support playback\n",
+						cpu_dai->name,
+						rtd->dai_link->stream_name);
+					return -EINVAL;
+				}
+			playback = 1;
+		}
+		if (rtd->dai_link->dpcm_capture) {
+			stream = SNDRV_PCM_STREAM_CAPTURE;
+
+			for_each_rtd_cpu_dais(rtd, i, cpu_dai)
+				if (!snd_soc_dai_stream_valid(cpu_dai,
+							      stream)) {
+					dev_err(rtd->card->dev,
+						"CPU DAI %s for rtd %s does not support capture\n",
+						cpu_dai->name,
+						rtd->dai_link->stream_name);
+					return -EINVAL;
+				}
+			capture = 1;
 		}
-
-		playback = rtd->dai_link->dpcm_playback &&
-			   snd_soc_dai_stream_valid(cpu_dai, SNDRV_PCM_STREAM_PLAYBACK);
-		capture = rtd->dai_link->dpcm_capture &&
-			  snd_soc_dai_stream_valid(cpu_dai, SNDRV_PCM_STREAM_CAPTURE);
 	} else {
 		/* Adapt stream for codec2codec links */
 		int cpu_capture = rtd->dai_link->params ?
-- 
2.25.1

