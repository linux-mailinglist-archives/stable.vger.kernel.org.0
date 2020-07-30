Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C931233241
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 14:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgG3McA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 08:32:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49416 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgG3McA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 08:32:00 -0400
Received: from [123.112.106.30] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1k17iz-0005pe-S5; Thu, 30 Jul 2020 12:31:54 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, broonie@kernel.org,
        Vijendar.Mukunda@amd.com
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] ASoC: amd: renoir: restore two more registers during resume
Date:   Thu, 30 Jul 2020 20:31:38 +0800
Message-Id: <20200730123138.5659-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recently we found an issue about the suspend and resume. If dmic is
recording the sound, and we run suspend and resume, after the resume,
the dmic can't work well anymore. we need to close the app and reopen
the app, then the dmic could record the sound again.

For example, we run "arecord -D hw:CARD=acp,DEV=0 -f S32_LE -c 2
-r 48000 test.wav", then suspend and resume, after the system resume
back, we speak to the dmic. then stop the arecord, use aplay to play
the test.wav, we could hear the sound recorded after resume is weird,
it is not what we speak to the dmic.

I found two registers are set in the dai_hw_params(), if the two
registers are set during the resume, this issue could be fixed.
Move the code of the dai_hw_params() into the pdm_dai_trigger(), then
these two registers will be set during resume since pdm_dai_trigger()
will be called during resume. And delete the empty function
dai_hw_params().

Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/soc/amd/renoir/acp3x-pdm-dma.c | 29 +++++++++-------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index 623dfd3ea705..7b14d9a81b97 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -314,40 +314,30 @@ static int acp_pdm_dma_close(struct snd_soc_component *component,
 	return 0;
 }
 
-static int acp_pdm_dai_hw_params(struct snd_pcm_substream *substream,
-				 struct snd_pcm_hw_params *params,
-				 struct snd_soc_dai *dai)
+static int acp_pdm_dai_trigger(struct snd_pcm_substream *substream,
+			       int cmd, struct snd_soc_dai *dai)
 {
 	struct pdm_stream_instance *rtd;
+	int ret;
+	bool pdm_status;
 	unsigned int ch_mask;
 
 	rtd = substream->runtime->private_data;
-	switch (params_channels(params)) {
+	ret = 0;
+	switch (substream->runtime->channels) {
 	case TWO_CH:
 		ch_mask = 0x00;
 		break;
 	default:
 		return -EINVAL;
 	}
-	rn_writel(ch_mask, rtd->acp_base + ACP_WOV_PDM_NO_OF_CHANNELS);
-	rn_writel(PDM_DECIMATION_FACTOR, rtd->acp_base +
-		  ACP_WOV_PDM_DECIMATION_FACTOR);
-	return 0;
-}
-
-static int acp_pdm_dai_trigger(struct snd_pcm_substream *substream,
-			       int cmd, struct snd_soc_dai *dai)
-{
-	struct pdm_stream_instance *rtd;
-	int ret;
-	bool pdm_status;
-
-	rtd = substream->runtime->private_data;
-	ret = 0;
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		rn_writel(ch_mask, rtd->acp_base + ACP_WOV_PDM_NO_OF_CHANNELS);
+		rn_writel(PDM_DECIMATION_FACTOR, rtd->acp_base +
+			  ACP_WOV_PDM_DECIMATION_FACTOR);
 		rtd->bytescount = acp_pdm_get_byte_count(rtd,
 							 substream->stream);
 		pdm_status = check_pdm_dma_status(rtd->acp_base);
@@ -369,7 +359,6 @@ static int acp_pdm_dai_trigger(struct snd_pcm_substream *substream,
 }
 
 static struct snd_soc_dai_ops acp_pdm_dai_ops = {
-	.hw_params = acp_pdm_dai_hw_params,
 	.trigger   = acp_pdm_dai_trigger,
 };
 
-- 
2.17.1

