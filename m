Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940636AEF45
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbjCGSWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbjCGSV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:21:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4529A4026
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:15:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 828B561538
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB9DC433D2;
        Tue,  7 Mar 2023 18:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212957;
        bh=NhGsBGoqTdT0I8zUJPQxubvxLRtXHbikPeSRWymwZAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4FjR1UvuRclm3E47EuRIfv3Z3GoaKPwPYCpMMpRY18Hf+YtvaS0TH7i8JpwV7yJj
         xVW5HP6lPI74WbRYmgyd6+Ka7BQAKyofw++NCQNWL/zo21G8+iq+5NRu7cNRKXAc97
         64xyZ0STOQc2n/O2KZWbfFmR/3UbWHns1f38va3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 353/885] ASoC: qcom: q6apm-dai: Add SNDRV_PCM_INFO_BATCH flag
Date:   Tue,  7 Mar 2023 17:54:47 +0100
Message-Id: <20230307170017.598072911@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit aa759f3f9f4394a3af65ad1772fca6cb9dd9e4cc ]

At the moment, playing audio with PulseAudio with the qdsp6 driver
results in distorted sound. It seems like its timer-based scheduling
does not work properly with qdsp6 since setting tsched=0 in
the PulseAudio configuration avoids the issue.

Apparently this happens when the pointer() callback is not accurate
enough. There is a SNDRV_PCM_INFO_BATCH flag that can be used to stop
PulseAudio from using timer-based scheduling by default.

According to https://www.alsa-project.org/pipermail/alsa-devel/2014-March/073816.html:

The flag is being used in the sense explained in the previous audio
meeting -- the data transfer granularity isn't fine enough but aligned
to the period size (or less).

q6apm-dai reports the position as multiple of

prtd->pcm_count = snd_pcm_lib_period_bytes(substream)

so it indeed just a multiple of the period size.

Therefore adding the flag here seems appropriate and makes audio
work out of the box.

Comment log inspired by Stephan Gerhold sent for q6asm-dai.c few years back.

Fixes: 9b4fe0f1cd79 ("ASoC: qdsp6: audioreach: add q6apm-dai support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230209122806.18923-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm-dai.c b/sound/soc/qcom/qdsp6/q6apm-dai.c
index bd35067a40521..7f02f5b2c33fd 100644
--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -64,7 +64,8 @@ struct q6apm_dai_data {
 static struct snd_pcm_hardware q6apm_dai_hardware_capture = {
 	.info =                 (SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_BLOCK_TRANSFER |
 				 SNDRV_PCM_INFO_MMAP_VALID | SNDRV_PCM_INFO_INTERLEAVED |
-				 SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME),
+				 SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME |
+				 SNDRV_PCM_INFO_BATCH),
 	.formats =              (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE),
 	.rates =                SNDRV_PCM_RATE_8000_48000,
 	.rate_min =             8000,
@@ -82,7 +83,8 @@ static struct snd_pcm_hardware q6apm_dai_hardware_capture = {
 static struct snd_pcm_hardware q6apm_dai_hardware_playback = {
 	.info =                 (SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_BLOCK_TRANSFER |
 				 SNDRV_PCM_INFO_MMAP_VALID | SNDRV_PCM_INFO_INTERLEAVED |
-				 SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME),
+				 SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME |
+				 SNDRV_PCM_INFO_BATCH),
 	.formats =              (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE),
 	.rates =                SNDRV_PCM_RATE_8000_192000,
 	.rate_min =             8000,
-- 
2.39.2



