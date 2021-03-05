Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E666232E872
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhCEM0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:26:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231605AbhCEM0i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:26:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 159776502E;
        Fri,  5 Mar 2021 12:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947197;
        bh=A71U61VDEDrL7rhrS6AMNUmu77oehTJt3wHB+LL/EuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4KgYj1daTo2BFAhmDcClejdXqS6xdD1MGe5uEq2Dq1pSy6AudgqYKW2R8CQPE05c
         jg6HTIpKlofi1rgZ0fngpRtg0m3JIj++vB0EX0YesrFDtJzE+nJfyIZb5i/HWx2Szd
         oMC68yjpafP0GEKNPvaOX2kTnTqazVZrrJDnit1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivia Mackintosh <livvy@base.nu>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 066/104] ALSA: usb-audio: Add support for Pioneer DJM-750
Date:   Fri,  5 Mar 2021 13:21:11 +0100
Message-Id: <20210305120906.409658361@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivia Mackintosh <livvy@base.nu>

[ Upstream commit b952ac76a20bc0b23cd7e22de19fb407713238a3 ]

This adds the Pioneer DJ DJM-750 to the quirks table and ensures
skip_pioneer_sync_ep() is (also) called: this device uses the vendor
ID of 0x08e4 (I'm not sure why they use multiple vendor IDs but many
just like to be awkward it seems).

Playback on all 8 channels works. I'll likely keep this working in the
future and submit futher patches and improvements as necessary.

Signed-off-by: Olivia Mackintosh <livvy@base.nu>
Link: https://lore.kernel.org/r/20210118130621.77miiie47wp7mump@base.nu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/implicit.c     |  3 +-
 sound/usb/quirks-table.h | 60 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/sound/usb/implicit.c b/sound/usb/implicit.c
index bba54430e6d0..11a85e66aa96 100644
--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -304,7 +304,8 @@ static int audioformat_implicit_fb_quirk(struct snd_usb_audio *chip,
 	/* Pioneer devices with vendor spec class */
 	if (attr == USB_ENDPOINT_SYNC_ASYNC &&
 	    alts->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC &&
-	    USB_ID_VENDOR(chip->usb_id) == 0x2b73 /* Pioneer */) {
+	    (USB_ID_VENDOR(chip->usb_id) == 0x2b73 || /* Pioneer */
+	     USB_ID_VENDOR(chip->usb_id) == 0x08e4    /* Pioneer */)) {
 		if (skip_pioneer_sync_ep(chip, fmt, alts))
 			return 1;
 	}
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index c8a4bdf18207..93d55cd1a5a4 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3757,6 +3757,66 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 		}
 	}
 },
+{
+	/*
+	 * Pioneer DJ DJM-750
+	 * 8 channels playback & 8 channels capture @ 44.1/48/96kHz S24LE
+	 */
+	USB_DEVICE_VENDOR_SPEC(0x08e4, 0x017f),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 8,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x05,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+					    USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_44100|
+						SNDRV_PCM_RATE_48000|
+						SNDRV_PCM_RATE_96000,
+					.rate_min = 44100,
+					.rate_max = 96000,
+					.nr_rates = 3,
+					.rate_table = (unsigned int[]) { 44100, 48000, 96000 }
+				}
+			},
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 8,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x86,
+					.ep_idx = 1,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						USB_ENDPOINT_SYNC_ASYNC|
+						USB_ENDPOINT_USAGE_IMPLICIT_FB,
+					.rates = SNDRV_PCM_RATE_44100|
+						SNDRV_PCM_RATE_48000|
+						SNDRV_PCM_RATE_96000,
+					.rate_min = 44100,
+					.rate_max = 96000,
+					.nr_rates = 3,
+					.rate_table = (unsigned int[]) { 44100, 48000, 96000 }
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 
 #undef USB_DEVICE_VENDOR_SPEC
 #undef USB_AUDIO_DEVICE
-- 
2.30.1



