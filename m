Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC211C150C
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbgEANpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731881AbgEANp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:45:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7F2120836;
        Fri,  1 May 2020 13:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340728;
        bh=SrFW6PsYUnBBUbuKnPpW4WJLdY11KpMBLrLY3B248qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JedXHGyPeUay/87ChKJft+L5keIeMH372t3FdDNLMQ0fUQyRRhX6CdSZpBkOl78OW
         STgkSSWXnGk78iMAwhMO4M01DohqoGBzyk6bfxLWDxswguQ2piyiZnKPXfWYzkGoCF
         NtGe8aTOuLwhO58PK914lULHgX9SMuklMZSrkHUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Sameer Pujar <spujar@nvidia.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.6 104/106] ASoC: soc-pcm: fix regression in soc_new_pcm()
Date:   Fri,  1 May 2020 15:24:17 +0200
Message-Id: <20200501131555.894730725@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

commit a4877a6fb2bd2e356a5eaacd86d6b6d69ff84e69 upstream.

Commit af4bac11531f ("ASoC: soc-pcm: crash in snd_soc_dapm_new_dai")
swapped the SNDRV_PCM_STREAM_* parameter in the
snd_soc_dai_stream_valid(cpu_dai, ...) checks. But that works only
for codec2codec links. For normal links it breaks registration of
playback/capture-only PCM devices.

E.g. on qcom/apq8016_sbc there is usually one playback-only and one
capture-only PCM device, but they disappeared after the commit.

The codec2codec case was added in commit a342031cdd08
("ASoC: create pcm for codec2codec links as well") as an extra check
(e.g. `playback = playback && cpu_playback->channels_min`).

We should be able to simplify the code by checking directly for
the correct stream type in the loop.
This also fixes the regression because we check for PLAYBACK for
both codec and cpu dai again when codec2codec is not used.

Fixes: af4bac11531f ("ASoC: soc-pcm: crash in snd_soc_dapm_new_dai")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/20200218103824.26708-1-stephan@gerhold.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-pcm.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -2890,22 +2890,19 @@ int soc_new_pcm(struct snd_soc_pcm_runti
 		capture = rtd->dai_link->dpcm_capture;
 	} else {
 		/* Adapt stream for codec2codec links */
-		struct snd_soc_pcm_stream *cpu_capture = rtd->dai_link->params ?
-			&cpu_dai->driver->playback : &cpu_dai->driver->capture;
-		struct snd_soc_pcm_stream *cpu_playback = rtd->dai_link->params ?
-			&cpu_dai->driver->capture : &cpu_dai->driver->playback;
+		int cpu_capture = rtd->dai_link->params ?
+			SNDRV_PCM_STREAM_PLAYBACK : SNDRV_PCM_STREAM_CAPTURE;
+		int cpu_playback = rtd->dai_link->params ?
+			SNDRV_PCM_STREAM_CAPTURE : SNDRV_PCM_STREAM_PLAYBACK;
 
 		for_each_rtd_codec_dai(rtd, i, codec_dai) {
 			if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_PLAYBACK) &&
-			    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_CAPTURE))
+			    snd_soc_dai_stream_valid(cpu_dai,   cpu_playback))
 				playback = 1;
 			if (snd_soc_dai_stream_valid(codec_dai, SNDRV_PCM_STREAM_CAPTURE) &&
-			    snd_soc_dai_stream_valid(cpu_dai,   SNDRV_PCM_STREAM_PLAYBACK))
+			    snd_soc_dai_stream_valid(cpu_dai,   cpu_capture))
 				capture = 1;
 		}
-
-		capture = capture && cpu_capture->channels_min;
-		playback = playback && cpu_playback->channels_min;
 	}
 
 	if (rtd->dai_link->playback_only) {


