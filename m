Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57921323CC5
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbhBXMzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 07:55:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235220AbhBXMwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:52:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7043D64F1C;
        Wed, 24 Feb 2021 12:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171073;
        bh=eC+l+dX1UHZJiw7ZvDmYGP8yI4S3LXklR7aJIz4whVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOxzZ1u3jEl5Djhr7ixFPyqOXyF2vKOvKTiFHU3w0hGeDnVKxtBMCg3hwHj8QWPeZ
         8QYSxbDOjSngmaAe9xr3HVNui5yo4iiM1WSASPwrcyFCjJRN+95kzvCCWQAomsmHjr
         KBdnXj2iztSdMoe+Nw2yvGeW1F1v6YvHzhe6FdZpdvq6tNtnrtV8z8sgocQc9exVjm
         daDlBtzqR8w0eMnSYAQgVkfB2Y8XqOngKYrIVz1H6otIWCBhdJ1xRMV3MbnLU+lR4u
         VOAvg5SgK2b5CemOMrL4kVxVlk44AocfA9vZrqUOhXMWldOUGTAXzQQoULEUsvCNp2
         JW6DQ06WPatxA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olivia Mackintosh <livvy@base.nu>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 34/67] ALSA: usb-audio: Add support for Pioneer DJM-750
Date:   Wed, 24 Feb 2021 07:49:52 -0500
Message-Id: <20210224125026.481804-34-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 521cc846d9d9f..e7216d0b860d8 100644
--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -302,7 +302,8 @@ static int audioformat_implicit_fb_quirk(struct snd_usb_audio *chip,
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
index c8a4bdf18207c..93d55cd1a5a4c 100644
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
2.27.0

