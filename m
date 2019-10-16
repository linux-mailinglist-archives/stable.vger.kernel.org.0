Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DBED9FE5
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390662AbfJPWFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438249AbfJPV6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:45 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CD8621D7E;
        Wed, 16 Oct 2019 21:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263124;
        bh=wzFs60iEHjAxYpEBrR45TW6y/358C6knRacv3we9/ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaEz9R4kWQioy7XaLLMPqRFgJDDAymIkqCeaIq/RkzdJ3r/d1VtI38GXvSQTEZ/xY
         SvlOxzbMVRBpQcv+ZaL+/pPqHEGAvJa1sJ9+gbBFeQM2veC4CqC01iNqTTB+qZjtW+
         JH4iwNjxT19bQ/0okNMWlYfvJ5wXDql1/lp8eDeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Stefan Wahren <wahrenst@gmx.net>
Subject: [PATCH 5.3 048/112] staging: bcm2835-audio: Fix draining behavior regression
Date:   Wed, 16 Oct 2019 14:50:40 -0700
Message-Id: <20191016214855.198886589@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2eed19b99c8e95ff87afe6c140ed895c3fac5937 upstream.

The PCM draining behavior got broken since the recent refactoring, and
this turned out to be the incorrect expectation of the firmware
behavior regarding "draining".  While I expected the "drain" flag at
the stop operation would do processing the queued samples, it seems
rather dropping the samples.

As a quick fix, just drop the SNDRV_PCM_INFO_DRAIN_TRIGGER flag, so
that the driver uses the normal PCM draining procedure.  Also, put
some caution comment to the function for future readers not to fall
into the same pitfall.

Fixes: d7ca3a71545b ("staging: bcm2835-audio: Operate non-atomic PCM ops")
BugLink: https://github.com/raspberrypi/linux/issues/2983
Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20190914152405.7416-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c   |    4 ++--
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c
+++ b/drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c
@@ -12,7 +12,7 @@
 static const struct snd_pcm_hardware snd_bcm2835_playback_hw = {
 	.info = (SNDRV_PCM_INFO_INTERLEAVED | SNDRV_PCM_INFO_BLOCK_TRANSFER |
 		 SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_MMAP_VALID |
-		 SNDRV_PCM_INFO_DRAIN_TRIGGER | SNDRV_PCM_INFO_SYNC_APPLPTR),
+		 SNDRV_PCM_INFO_SYNC_APPLPTR),
 	.formats = SNDRV_PCM_FMTBIT_U8 | SNDRV_PCM_FMTBIT_S16_LE,
 	.rates = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_8000_48000,
 	.rate_min = 8000,
@@ -29,7 +29,7 @@ static const struct snd_pcm_hardware snd
 static const struct snd_pcm_hardware snd_bcm2835_playback_spdif_hw = {
 	.info = (SNDRV_PCM_INFO_INTERLEAVED | SNDRV_PCM_INFO_BLOCK_TRANSFER |
 		 SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_MMAP_VALID |
-		 SNDRV_PCM_INFO_DRAIN_TRIGGER | SNDRV_PCM_INFO_SYNC_APPLPTR),
+		 SNDRV_PCM_INFO_SYNC_APPLPTR),
 	.formats = SNDRV_PCM_FMTBIT_S16_LE,
 	.rates = SNDRV_PCM_RATE_CONTINUOUS | SNDRV_PCM_RATE_44100 |
 	SNDRV_PCM_RATE_48000,
--- a/drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-audio/bcm2835-vchiq.c
@@ -289,6 +289,7 @@ int bcm2835_audio_stop(struct bcm2835_al
 					 VC_AUDIO_MSG_TYPE_STOP, false);
 }
 
+/* FIXME: this doesn't seem working as expected for "draining" */
 int bcm2835_audio_drain(struct bcm2835_alsa_stream *alsa_stream)
 {
 	struct vc_audio_msg m = {


