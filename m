Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DE66C55C3
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjCVUAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 16:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjCVT7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:59:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD985C9D1;
        Wed, 22 Mar 2023 12:58:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8719622B3;
        Wed, 22 Mar 2023 19:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D680FC433A4;
        Wed, 22 Mar 2023 19:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515102;
        bh=S7xw1KZi9wgWBe4cQ7BxQezBNrU2pPn0w8A9pR4J7cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=plJmx5Aiq+9nx+iTeESo0tAUoRiB+fnpwOj3zbvTbeowMtYNhmX9AvqQKp3Oiu9GM
         ArvgCzh7IoGfWmhXhND0aBxNb87ZKBBbAluq3oeIIU6RSD4ppf/Xd5YCN6+nuymstP
         lGU24l9yzllUSREWpudHR4lQz3pdLBDWfD++wiqXYiKvFo+frCJCjZCvPAZ0fB7QOj
         Po0FBm5wmVhHyHg5ynLoQvdjgpGkXJeFg/N3jmtv1fowtAlZALryyK8eTKQ2Lintt0
         Qg2cywCIdoVtOQU+9u+DdPDCqyIuGyKLtQ1rtJyhJA9mYpIOuddRSTOZU2aSJO2VFz
         q35Ns6N81AAVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emil Abildgaard Svendsen <EMAS@bang-olufsen.dk>,
        Emil Svendsen <emas@bang-olufsen.dk>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, ckeepax@opensource.cirrus.com,
        pierre-louis.bossart@linux.intel.com,
        kuninori.morimoto.gx@renesas.com, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 6.2 20/45] ASoC: hdmi-codec: only startup/shutdown on supported streams
Date:   Wed, 22 Mar 2023 15:56:14 -0400
Message-Id: <20230322195639.1995821-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emil Abildgaard Svendsen <EMAS@bang-olufsen.dk>

[ Upstream commit e041a2a550582106cba6a7c862c90dfc2ad14492 ]

Currently only one stream is supported. This isn't usally a problem
until you have a multi codec audio card. Because the audio card will run
startup and shutdown on both capture and playback streams. So if your
hdmi-codec only support either playback or capture. Then ALSA can't open
for playback and capture.

This patch will ignore if startup and shutdown are called with a non
supported stream. Thus, allowing an audio card like this:

           +-+
 cpu1 <--@-| |-> codec1 (HDMI-CODEC)
           | |<- codec2 (NOT HDMI-CODEC)
           +-+

Signed-off-by: Emil Svendsen <emas@bang-olufsen.dk>
Link: https://lore.kernel.org/r/20230309065432.4150700-2-emas@bang-olufsen.dk
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdmi-codec.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/hdmi-codec.c b/sound/soc/codecs/hdmi-codec.c
index 74cbbe16f9aec..a22f2ec95901f 100644
--- a/sound/soc/codecs/hdmi-codec.c
+++ b/sound/soc/codecs/hdmi-codec.c
@@ -428,8 +428,13 @@ static int hdmi_codec_startup(struct snd_pcm_substream *substream,
 {
 	struct hdmi_codec_priv *hcp = snd_soc_dai_get_drvdata(dai);
 	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
+	bool has_capture = !hcp->hcd.no_i2s_capture;
+	bool has_playback = !hcp->hcd.no_i2s_playback;
 	int ret = 0;
 
+	if (!((has_playback && tx) || (has_capture && !tx)))
+		return 0;
+
 	mutex_lock(&hcp->lock);
 	if (hcp->busy) {
 		dev_err(dai->dev, "Only one simultaneous stream supported!\n");
@@ -468,6 +473,12 @@ static void hdmi_codec_shutdown(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai)
 {
 	struct hdmi_codec_priv *hcp = snd_soc_dai_get_drvdata(dai);
+	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
+	bool has_capture = !hcp->hcd.no_i2s_capture;
+	bool has_playback = !hcp->hcd.no_i2s_playback;
+
+	if (!((has_playback && tx) || (has_capture && !tx)))
+		return;
 
 	hcp->chmap_idx = HDMI_CODEC_CHMAP_IDX_UNKNOWN;
 	hcp->hcd.ops->audio_shutdown(dai->dev->parent, hcp->hcd.data);
-- 
2.39.2

