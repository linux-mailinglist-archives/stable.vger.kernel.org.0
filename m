Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591E424F41F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgHXIc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:32:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgHXIcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:32:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DEF0206F0;
        Mon, 24 Aug 2020 08:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598257974;
        bh=08LLs18QM0BNa51+8+DcjIOpXAZEW8oyN8p2N6kyss4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yw5YbZrV3G4exzG0OK0QLVU/DbdqfcK7dxfLJAt3ibYqMSpNuwJzUbG+3UkmFZxsn
         5VBLT6duy0QStjDGwEU3LUOCe8PNaGiX0NN/fahO6gZzjb/M4q28A4hxG+WEISWmNH
         8dlcnqCu3Kt60pnk0q8LNsNuZPdcZgdeYQl/7btU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.8 020/148] ASoC: amd: renoir: restore two more registers during resume
Date:   Mon, 24 Aug 2020 10:28:38 +0200
Message-Id: <20200824082414.938155074@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit ccff7bd468d5e0595176656a051ef67c01f01968 upstream.

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

Signed-off-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200730123138.5659-1-hui.wang@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/amd/renoir/acp3x-pdm-dma.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -314,40 +314,30 @@ static int acp_pdm_dma_close(struct snd_
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
@@ -369,7 +359,6 @@ static int acp_pdm_dai_trigger(struct sn
 }
 
 static struct snd_soc_dai_ops acp_pdm_dai_ops = {
-	.hw_params = acp_pdm_dai_hw_params,
 	.trigger   = acp_pdm_dai_trigger,
 };
 


