Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97E8360CA8
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbhDOOxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233625AbhDOOvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B43CE6113B;
        Thu, 15 Apr 2021 14:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498282;
        bh=0G2t/u4UGpcS50sYNbUfPHmfD+IG25lvJtbd9qHARL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tOci1fLZM4kZL7E5bJP+y9uuAAfeMB/NbxfkUs74MXpBxjDYPQ1Mx3jtmumF96PFn
         s+qjs3e9Afz6y5aLuug/bTP/siQNZVLZUUEevcIu6ok5T31QR5ZvdoI2LwVg1fyWDW
         Ba/9awh58YLFCjGntK8BvnDb5X2T4MUDAUuo4lqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 04/47] ASoC: intel: atom: Stop advertising non working S24LE support
Date:   Thu, 15 Apr 2021 16:46:56 +0200
Message-Id: <20210415144413.623616016@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
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
@@ -508,14 +508,14 @@ static struct snd_soc_dai_driver sst_pla
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
@@ -526,7 +526,7 @@ static struct snd_soc_dai_driver sst_pla
 		.channels_min = SST_STEREO,
 		.channels_max = SST_STEREO,
 		.rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
 	},
 },
 {


