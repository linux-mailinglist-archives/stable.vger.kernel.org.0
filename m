Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46370205DB2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389322AbgFWUPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389341AbgFWUPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:15:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3789D20702;
        Tue, 23 Jun 2020 20:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943341;
        bh=eykvCUc7eGhbQsH29W9p55trxpsTU+5LRYkRvP2hjJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ya9I/WqVCMEniAPvkR5jN/ZenMbX/KU6KPYX/gnZgsbgUJGXn5wtdyjLEmdTFd5pv
         7+6YGv7p4DveKJfvLxviH1l1RG0k9i9g1TtK5Il6kbPnmDq4LA+DXgG3nukHt7+eYP
         sM36ewcT5CS9jXlZ6CNpCS6/ZtXX48kCYP4kc8Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 354/477] ASoC: soc-pcm: dpcm: fix playback/capture checks
Date:   Tue, 23 Jun 2020 21:55:51 +0200
Message-Id: <20200623195424.275641478@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1f302de440525..39ce61c5b8744 100644
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



