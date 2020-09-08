Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B73D261CAC
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732016AbgIHTYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731067AbgIHQBX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:01:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0305E2468F;
        Tue,  8 Sep 2020 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579579;
        bh=n9s/jOZbYW0Ekwty0HM8fhEeOez3EOVRoh/+8XuIRAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWJta+6dappJaDZkU5ndtUorqTmrVSsPxdSwdXu8tpLDXRdH77zKWC6Fivpzhaq/I
         M8UV4BB7AgtPcFzR6M81HuFgfEVu2sdickuI/xR9ypWnuSdgSkBLby57vfPD0KxkQC
         z2l4jiwca5kIcCKNPrMQLrARNK6vhztKDjyccJZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Franti=C5=A1ek=20Ku=C4=8Dera?= <franta-linux@frantovo.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 136/186] ALSA: usb-audio: Add basic capture support for Pioneer DJ DJM-250MK2
Date:   Tue,  8 Sep 2020 17:24:38 +0200
Message-Id: <20200908152248.241518695@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: František Kučera <franta-linux@frantovo.cz>

commit 14335d8b9e1a2bf006f9d969a103f9731cabb210 upstream.

This patch extends support for DJM-250MK2 and allows recording.
However, DVS is not possible yet (see the comment in code).

Signed-off-by: František Kučera <franta-linux@frantovo.cz>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200825153113.6352-1-konference@frantovo.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c          |    1 
 sound/usb/quirks-table.h |   60 +++++++++++++++++++++++++++++++++++++++++------
 sound/usb/quirks.c       |    1 
 3 files changed, 55 insertions(+), 7 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -374,6 +374,7 @@ static int set_sync_ep_implicit_fb_quirk
 		ifnum = 2;
 		goto add_sync_ep_from_ifnum;
 	case USB_ID(0x2b73, 0x000a): /* Pioneer DJ DJM-900NXS2 */
+	case USB_ID(0x2b73, 0x0017): /* Pioneer DJ DJM-250MK2 */
 		ep = 0x82;
 		ifnum = 0;
 		goto add_sync_ep_from_ifnum;
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3532,14 +3532,40 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge
 {
 	/*
 	 * Pioneer DJ DJM-250MK2
-	 * PCM is 8 channels out @ 48 fixed (endpoints 0x01).
-	 * The output from computer to the mixer is usable.
+	 * PCM is 8 channels out @ 48 fixed (endpoint 0x01)
+	 * and 8 channels in @ 48 fixed (endpoint 0x82).
 	 *
-	 * The input (phono or line to computer) is not working.
-	 * It should be at endpoint 0x82 and probably also 8 channels,
-	 * but it seems that it works only with Pioneer proprietary software.
-	 * Even on officially supported OS, the Audacity was unable to record
-	 * and Mixxx to recognize the control vinyls.
+	 * Both playback and recording is working, even simultaneously.
+	 *
+	 * Playback channels could be mapped to:
+	 *  - CH1
+	 *  - CH2
+	 *  - AUX
+	 *
+	 * Recording channels could be mapped to:
+	 *  - Post CH1 Fader
+	 *  - Post CH2 Fader
+	 *  - Cross Fader A
+	 *  - Cross Fader B
+	 *  - MIC
+	 *  - AUX
+	 *  - REC OUT
+	 *
+	 * There is remaining problem with recording directly from PHONO/LINE.
+	 * If we map a channel to:
+	 *  - CH1 Control Tone PHONO
+	 *  - CH1 Control Tone LINE
+	 *  - CH2 Control Tone PHONO
+	 *  - CH2 Control Tone LINE
+	 * it is silent.
+	 * There is no signal even on other operating systems with official drivers.
+	 * The signal appears only when a supported application is started.
+	 * This needs to be investigated yet...
+	 * (there is quite a lot communication on the USB in both directions)
+	 *
+	 * In current version this mixer could be used for playback
+	 * and for recording from vinyls (through Post CH* Fader)
+	 * but not for DVS (Digital Vinyl Systems) like in Mixxx.
 	 */
 	USB_DEVICE_VENDOR_SPEC(0x2b73, 0x0017),
 	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
@@ -3561,6 +3587,26 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge
 					.rates = SNDRV_PCM_RATE_48000,
 					.rate_min = 48000,
 					.rate_max = 48000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 48000 }
+					}
+			},
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 8, // inputs
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x82,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						USB_ENDPOINT_SYNC_ASYNC|
+						USB_ENDPOINT_USAGE_IMPLICIT_FB,
+					.rates = SNDRV_PCM_RATE_48000,
+					.rate_min = 48000,
+					.rate_max = 48000,
 					.nr_rates = 1,
 					.rate_table = (unsigned int[]) { 48000 }
 				}
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1493,6 +1493,7 @@ void snd_usb_set_format_quirk(struct snd
 		set_format_emu_quirk(subs, fmt);
 		break;
 	case USB_ID(0x2b73, 0x000a): /* Pioneer DJ DJM-900NXS2 */
+	case USB_ID(0x2b73, 0x0017): /* Pioneer DJ DJM-250MK2 */
 		pioneer_djm_set_format_quirk(subs);
 		break;
 	case USB_ID(0x534d, 0x2109): /* MacroSilicon MS2109 */


