Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28D435BDBA
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbhDLIxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238112AbhDLIvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 593EF61019;
        Mon, 12 Apr 2021 08:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217457;
        bh=8MOg+CiZWgf1lJRxF4AZCfOm0hl+jK/wpwBVcxWa+jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbtJg7bqgEVppIJInMGls2o/FGGkW+qbQ/ikUp98CBktyoOHxYjNhgImz4qwGElRZ
         Y9NQ2VTBvB7rN6E56BqHxoHzz7G9eD/M3chper6gGtF+cWZoxmeeaApGj83UwGd1rG
         ngzxJ3mKxbeWIMHFwo8ucNIAa7wVyI5fHDiQ8JAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 005/188] ASoC: intel: atom: Stop advertising non working S24LE support
Date:   Mon, 12 Apr 2021 10:38:39 +0200
Message-Id: <20210412084013.826623758@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit aa65bacdb70e549a81de03ec72338e1047842883 upstream.

The SST firmware's media and deep-buffer inputs are hardcoded to
S16LE, the corresponding DAIs don't have a hw_params callback and
their prepare callback also does not take the format into account.

So far the advertising of non working S24LE support has not caused
issues because pulseaudio defaults to S16LE, but changing pulse-audio's
config to use S24LE will result in broken sound.

Pipewire is replacing pulse now and pipewire prefers S24LE over S16LE
when available, causing the problem of the broken S24LE support to
come to the surface now.

Cc: stable@vger.kernel.org
BugLink: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/866
Fixes: 098c2cd281409 ("ASoC: Intel: Atom: add 24-bit support for media playback and capture")
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210324132711.216152-2-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -488,14 +488,14 @@ static struct snd_soc_dai_driver sst_pla
 		.channels_min = SST_STEREO,
 		.channels_max = SST_STEREO,
 		.rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
 	},
 	.capture = {
 		.stream_name = "Headset Capture",
 		.channels_min = 1,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
 	},
 },
 {
@@ -506,7 +506,7 @@ static struct snd_soc_dai_driver sst_pla
 		.channels_min = SST_STEREO,
 		.channels_max = SST_STEREO,
 		.rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
 	},
 },
 {


