Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685C666C1BF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbjAPOO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbjAPONa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:13:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F269523856;
        Mon, 16 Jan 2023 06:05:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCD5060FD9;
        Mon, 16 Jan 2023 14:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F20C433EF;
        Mon, 16 Jan 2023 14:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877907;
        bh=DCSrrGAse90G6h94EX2MDyzi+FCDSLXmwn6dRsG2W1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGzgMjuFn1ynAeLSXDm6KhaSC19ujhE9DUJdvSPKTbubFMt3IWfIi+grVsnJL2aaF
         k0yYQtum/wI2dlV4dPSFNT18nbiWHGN7O+ViemfwQIx5GXjZmQnuRLpHo+9O9F6Zgq
         LxaliByl5JlTynS41plP1eJyiMOVReYB2PsFZ7Y0wdpYmWgIQ1Nc4mSOClnADj0bIP
         zl8SlxHARfCvsTLGUtVC8KgkMY7TcyYto/ywVmEDfA5d1YOcenF8VywG9CgJxsVhoH
         jd64KVWQ4PRo2bIAgtpvysjDzKW95siv13rIF+pqSnzp5mGoi/rVUQA3jn6FKMbeUA
         blUfhWm1QjRPg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Shengjiu Wang <shengjiu.wang@gmail.com>,
        Sasha Levin <sashal@kernel.org>, Xiubo.Lee@gmail.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 09/17] ASoC: fsl_ssi: Rename AC'97 streams to avoid collisions with AC'97 CODEC
Date:   Mon, 16 Jan 2023 09:04:40 -0500
Message-Id: <20230116140448.116034-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140448.116034-1-sashal@kernel.org>
References: <20230116140448.116034-1-sashal@kernel.org>
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
2.35.1

