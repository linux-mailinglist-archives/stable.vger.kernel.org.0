Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6EF06812CD
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237391AbjA3OZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbjA3OY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:24:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721E542BE3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:23:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14F3FB810C5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D604C4339B;
        Mon, 30 Jan 2023 14:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088579;
        bh=imqSWnXRcXB3AzM/KvKq6e8DaN1sUrgSq2/l5EDBLsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTQzwAQ/5YbngkLjp1aCIkAuojEw6ktvDzlIDofjSoaxh81MTGIk844aY7sR41mII
         W6FLS9+lrtdhCHwcm3jW+ow0SiQXuCAezo5AZXYTkIshrXpsc+di2OQbPExpFYCRyv
         rPcNE+Ah5BmIvWYk+31JH+wzDWX1CiPhhrWnwgj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shengjiu Wang <shengjiu.wang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/143] ASoC: fsl_ssi: Rename AC97 streams to avoid collisions with AC97 CODEC
Date:   Mon, 30 Jan 2023 14:52:04 +0100
Message-Id: <20230130134309.614852328@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 8c6a42b5b0ed6f96624f56954e93eeae107440a6 ]

The SSI driver calls the AC'97 playback and transmit streams "AC97 Playback"
and "AC97 Capture" respectively. This is the same name used by the generic
AC'97 CODEC driver in ASoC, creating confusion for the Freescale ASoC card
when it attempts to use these widgets in routing. Add a "CPU" in the name
like the regular DAIs registered by the driver to disambiguate.

Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20230106-asoc-udoo-probe-v1-1-a5d7469d4f67@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl-asoc-card.c | 8 ++++----
 sound/soc/fsl/fsl_ssi.c       | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index 7cd14d6b9436..8c976fde44f0 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -117,11 +117,11 @@ static const struct snd_soc_dapm_route audio_map[] = {
 
 static const struct snd_soc_dapm_route audio_map_ac97[] = {
 	/* 1st half -- Normal DAPM routes */
-	{"Playback",  NULL, "AC97 Playback"},
-	{"AC97 Capture",  NULL, "Capture"},
+	{"Playback",  NULL, "CPU AC97 Playback"},
+	{"CPU AC97 Capture",  NULL, "Capture"},
 	/* 2nd half -- ASRC DAPM routes */
-	{"AC97 Playback",  NULL, "ASRC-Playback"},
-	{"ASRC-Capture",  NULL, "AC97 Capture"},
+	{"CPU AC97 Playback",  NULL, "ASRC-Playback"},
+	{"ASRC-Capture",  NULL, "CPU AC97 Capture"},
 };
 
 static const struct snd_soc_dapm_route audio_map_tx[] = {
diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index 1d774c876c52..94229ce1a30e 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1161,14 +1161,14 @@ static struct snd_soc_dai_driver fsl_ssi_ac97_dai = {
 	.symmetric_channels = 1,
 	.probe = fsl_ssi_dai_probe,
 	.playback = {
-		.stream_name = "AC97 Playback",
+		.stream_name = "CPU AC97 Playback",
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_48000,
 		.formats = SNDRV_PCM_FMTBIT_S16 | SNDRV_PCM_FMTBIT_S20,
 	},
 	.capture = {
-		.stream_name = "AC97 Capture",
+		.stream_name = "CPU AC97 Capture",
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_48000,
-- 
2.39.0



