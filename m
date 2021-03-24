Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E30E3479A4
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 14:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhCXNbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Mar 2021 09:31:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234593AbhCXNbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Mar 2021 09:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616592682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K8cMMgYmdL8jipU3l4yi7lmI899LgV2emaQ012yFBE0=;
        b=e7AQHZXuaoG9kg5xWhMnqbjkSUbQGPI6ks0YMy8uWMWrh3cHtBDLt3chAhIeY0JhG6Aixf
        SnWsRXuIoZOPhuChVdEKRrdQT1bIl3ndGscF4bSoH1IDKsg6+10d+C7ncjAokyuedMZ8R6
        NYy4ejblQmIMjkIF1CLv1Ujgq4zon0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-l43D1Jz-NJyLswiAaQoxIQ-1; Wed, 24 Mar 2021 09:31:17 -0400
X-MC-Unique: l43D1Jz-NJyLswiAaQoxIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B6CE1992C70;
        Wed, 24 Mar 2021 13:27:16 +0000 (UTC)
Received: from x1.localdomain (ovpn-112-209.ams2.redhat.com [10.36.112.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 063B9610F1;
        Wed, 24 Mar 2021 13:27:14 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] ASoC: intel: atom: Stop advertising non working S24LE support
Date:   Wed, 24 Mar 2021 14:27:10 +0100
Message-Id: <20210324132711.216152-2-hdegoede@redhat.com>
In-Reply-To: <20210324132711.216152-1-hdegoede@redhat.com>
References: <20210324132711.216152-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 sound/soc/intel/atom/sst-mfld-platform-pcm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/atom/sst-mfld-platform-pcm.c b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
index 9e9b05883557..aa5dd590ddd5 100644
--- a/sound/soc/intel/atom/sst-mfld-platform-pcm.c
+++ b/sound/soc/intel/atom/sst-mfld-platform-pcm.c
@@ -488,14 +488,14 @@ static struct snd_soc_dai_driver sst_platform_dai[] = {
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
@@ -506,7 +506,7 @@ static struct snd_soc_dai_driver sst_platform_dai[] = {
 		.channels_min = SST_STEREO,
 		.channels_max = SST_STEREO,
 		.rates = SNDRV_PCM_RATE_44100|SNDRV_PCM_RATE_48000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE,
 	},
 },
 {
-- 
2.30.2

