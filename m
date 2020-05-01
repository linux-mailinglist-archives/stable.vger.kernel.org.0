Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7938F1C15ED
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgEANgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730820AbgEANgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 012E724956;
        Fri,  1 May 2020 13:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340168;
        bh=tdI0d0/4oVV4hXlMe+1/M/sPbJqkn1L7HZacozriQSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8kd3hH4GNM87GUeHVqxaqj3b6rRbPck9A/dalw8uThqd8/qIVOqxGenCZ3ep9zPD
         wP5TX9d96ypYAW0tWQvO+JDgOIpEJvGhCG0OwWcAXbA2XGbPPL9uU+nFhxe6oNl5fs
         1jlE26igbcwOamVhK2ncEj2g5bytWxkNvbraab+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 08/46] ASoC: q6dsp6: q6afe-dai: add missing channels to MI2S DAIs
Date:   Fri,  1 May 2020 15:22:33 +0200
Message-Id: <20200501131502.060759871@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

commit 0c824ec094b5cda766c80d88c2036e28c24a4cb1 upstream.

For some reason, the MI2S DAIs do not have channels_min/max defined.
This means that snd_soc_dai_stream_valid() returns false,
i.e. the DAIs have neither valid playback nor capture stream.

It's quite surprising that this ever worked correctly,
but in 5.7-rc1 this is now failing badly: :)

Commit 0e9cf4c452ad ("ASoC: pcm: check if cpu-dai supports a given stream")
introduced a check for snd_soc_dai_stream_valid() before calling
hw_params(), which means that the q6i2s_hw_params() function
was never called, eventually resulting in:

    qcom-q6afe aprsvc:q6afe:4:4: no line is assigned

... even though "qcom,sd-lines" is set in the device tree.

Commit 9b5db059366a ("ASoC: soc-pcm: dpcm: Only allow playback/capture if supported")
now even avoids creating PCM devices if the stream is not supported,
which means that it is failing even earlier with e.g.:

    Primary MI2S: ASoC: no backend playback stream

Avoid all that trouble by adding channels_min/max for the MI2S DAIs.

Fixes: 24c4cbcfac09 ("ASoC: qdsp6: q6afe: Add q6afe dai driver")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200415150050.616392-1-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/qcom/qdsp6/q6afe-dai.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/sound/soc/qcom/qdsp6/q6afe-dai.c
+++ b/sound/soc/qcom/qdsp6/q6afe-dai.c
@@ -899,6 +899,8 @@ static struct snd_soc_dai_driver q6afe_d
 				 SNDRV_PCM_RATE_16000,
 			.formats = SNDRV_PCM_FMTBIT_S16_LE |
 				   SNDRV_PCM_FMTBIT_S24_LE,
+			.channels_min = 1,
+			.channels_max = 8,
 			.rate_min =     8000,
 			.rate_max =     48000,
 		},
@@ -914,6 +916,8 @@ static struct snd_soc_dai_driver q6afe_d
 				 SNDRV_PCM_RATE_16000,
 			.formats = SNDRV_PCM_FMTBIT_S16_LE |
 				   SNDRV_PCM_FMTBIT_S24_LE,
+			.channels_min = 1,
+			.channels_max = 8,
 			.rate_min =     8000,
 			.rate_max =     48000,
 		},
@@ -928,6 +932,8 @@ static struct snd_soc_dai_driver q6afe_d
 			.rates = SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_8000 |
 				 SNDRV_PCM_RATE_16000,
 			.formats = SNDRV_PCM_FMTBIT_S16_LE,
+			.channels_min = 1,
+			.channels_max = 8,
 			.rate_min =     8000,
 			.rate_max =     48000,
 		},
@@ -943,6 +949,8 @@ static struct snd_soc_dai_driver q6afe_d
 				 SNDRV_PCM_RATE_16000,
 			.formats = SNDRV_PCM_FMTBIT_S16_LE |
 				   SNDRV_PCM_FMTBIT_S24_LE,
+			.channels_min = 1,
+			.channels_max = 8,
 			.rate_min =     8000,
 			.rate_max =     48000,
 		},
@@ -957,6 +965,8 @@ static struct snd_soc_dai_driver q6afe_d
 			.rates = SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_8000 |
 				 SNDRV_PCM_RATE_16000,
 			.formats = SNDRV_PCM_FMTBIT_S16_LE,
+			.channels_min = 1,
+			.channels_max = 8,
 			.rate_min =     8000,
 			.rate_max =     48000,
 		},
@@ -972,6 +982,8 @@ static struct snd_soc_dai_driver q6afe_d
 				 SNDRV_PCM_RATE_16000,
 			.formats = SNDRV_PCM_FMTBIT_S16_LE |
 				   SNDRV_PCM_FMTBIT_S24_LE,
+			.channels_min = 1,
+			.channels_max = 8,
 			.rate_min =     8000,
 			.rate_max =     48000,
 		},
@@ -986,6 +998,8 @@ static struct snd_soc_dai_driver q6afe_d
 			.rates = SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_8000 |
 				 SNDRV_PCM_RATE_16000,
 			.formats = SNDRV_PCM_FMTBIT_S16_LE,
+			.channels_min = 1,
+			.channels_max = 8,
 			.rate_min =     8000,
 			.rate_max =     48000,
 		},
@@ -1001,6 +1015,8 @@ static struct snd_soc_dai_driver q6afe_d
 				 SNDRV_PCM_RATE_16000,
 			.formats = SNDRV_PCM_FMTBIT_S16_LE |
 				   SNDRV_PCM_FMTBIT_S24_LE,
+			.channels_min = 1,
+			.channels_max = 8,
 			.rate_min =     8000,
 			.rate_max =     48000,
 		},


