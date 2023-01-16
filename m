Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB7766C0FC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjAPOGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjAPOFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:05:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C2323641;
        Mon, 16 Jan 2023 06:03:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB72B80F96;
        Mon, 16 Jan 2023 14:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB47C433F0;
        Mon, 16 Jan 2023 14:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877799;
        bh=gYauz4pRUgjIc7OoeJiZKBW3AAood0eUvu4T5yoGcQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iw6951COkt0DPuG+9jzUgZLXQsJVmHUGxJns+vKJxLDVY/vpVENU8n/8XCrGYNy4M
         00ar0J1EGIipMg7eE6MBkYpxqlyI6Lc3KDFpd1SFrjTp8666wyh+8or7OIXMw7MNQU
         MqQxOK2Zy3trDdc028Rk2RNiTuzI7+Gku2kue3UrgVdg6Vh9mtjlurm9zxttG2ii3z
         Kr1TMA2xCBlHTtcQbGdBzUoDsACbnEDD2ePk/d2vdtJ/UuLwkmIQInD54PVARxn0bm
         In7uwP8MohsKghvqbnCvku9MjVvagfW8dlJG+AEEPMh5V/ZKXcoux7+iVIRq3Oc8g6
         xPII25bfNDDYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Sasha Levin <sashal@kernel.org>, Xiubo.Lee@gmail.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 6.1 32/53] ASoC: fsl_ssi: Rename AC'97 streams to avoid collisions with AC'97 CODEC
Date:   Mon, 16 Jan 2023 09:01:32 -0500
Message-Id: <20230116140154.114951-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index c836848ef0a6..1dfd0341e487 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -121,11 +121,11 @@ static const struct snd_soc_dapm_route audio_map[] = {
 
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
index c9e0e31d5b34..46a53551b955 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1189,14 +1189,14 @@ static struct snd_soc_dai_driver fsl_ssi_ac97_dai = {
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
2.35.1

