Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36C16D4A2A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbjDCOoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbjDCOoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:44:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9A018266
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:44:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4096CE12DE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEA7C433D2;
        Mon,  3 Apr 2023 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533046;
        bh=S7xw1KZi9wgWBe4cQ7BxQezBNrU2pPn0w8A9pR4J7cI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lELqzylBC8pnfJIboEMhnboK8zRr//RQE7XBt2BJA7yviI9Xg10E8cLxsBl4WcXZy
         muxQdIZosMGfXPCVqSt8CEz6X73IezgHyNpPcnnd6wslV2Gmp7zOkTk78QRJYWcLLO
         0zFkxcJpiqemx+Ccz4iRNMC07OYQp5do6+oHZc7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Emil Svendsen <emas@bang-olufsen.dk>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 034/187] ASoC: hdmi-codec: only startup/shutdown on supported streams
Date:   Mon,  3 Apr 2023 16:07:59 +0200
Message-Id: <20230403140417.118816781@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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



