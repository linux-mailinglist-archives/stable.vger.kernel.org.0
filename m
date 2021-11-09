Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E6544B6E1
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344704AbhKIWaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:30:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344796AbhKIW2d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:28:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 664EF611BF;
        Tue,  9 Nov 2021 22:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496425;
        bh=roLpUceVLm+Ma7x4DEjbGf9lFn2CGqSf1/yDwimyfrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOeoo8o4RODpcSs8knpxJvTNq944g3FiIOUZhCnDOY4DDRdPq8uX/YxV8JD4YjUCa
         Zs/zYNM0SCmMM/LAORpFa1fHIRokLEXxiWK9ZrMhNtFtUgFJtBJwFSuLDK8cCVK+ks
         n2KmB/ToQeJauyUb5nWIaUQYlevgr3bl8Cpb7bQbXWEgGSXh9ccuL6NOfO5XDNi99u
         ea7XDUP+4TPswsc362JSDIyql1vvTPII5Y0WXCyxw/CGBrvU/SHJpqjPTkycoHS6oo
         AEwZAlvYyJfTBYbM7ecWUF4GdnND6NzZQD/0BcxJk/mixQftKXy3F8IApKPo78OwIA
         mojvJYgm7oOaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     William Overton <willovertonuk@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, gregkh@linuxfoundation.org,
        brendan@grieve.com.au, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.14 49/75] ALSA: usb-audio: Add support for the Pioneer DJM 750MK2 Mixer/Soundcard
Date:   Tue,  9 Nov 2021 17:18:39 -0500
Message-Id: <20211109221905.1234094-49-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Overton <willovertonuk@gmail.com>

[ Upstream commit 6d27788160362a7ee6c0d317636fe4b1ddbe59a7 ]

The kernel already has support for very similar Pioneer djm products
and this work is based on that.

Added device to quirks-table.h and added control info to
mixer_quirks.c.

Tested on my hardware and all working.

Signed-off-by: William Overton <willovertonuk@gmail.com>
Link: https://lore.kernel.org/r/20211010145841.11907-1-willovertonuk@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 34 +++++++++++++++++++++++
 sound/usb/quirks-table.h | 58 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 4a4d3361ac047..ef92ac37cf1a9 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2654,6 +2654,7 @@ static int snd_bbfpro_controls_create(struct usb_mixer_interface *mixer)
 #define SND_DJM_750_IDX		0x1
 #define SND_DJM_850_IDX		0x2
 #define SND_DJM_900NXS2_IDX	0x3
+#define SND_DJM_750MK2_IDX	0x4
 
 
 #define SND_DJM_CTL(_name, suffix, _default_value, _windex) { \
@@ -2843,10 +2844,40 @@ static const struct snd_djm_ctl snd_djm_ctls_900nxs2[] = {
 	SND_DJM_CTL("Ch5 Input",   900nxs2_cap5, 3, SND_DJM_WINDEX_CAP)
 };
 
+// DJM-750MK2
+static const u16 snd_djm_opts_750mk2_cap1[] = {
+	0x0100, 0x0102, 0x0103, 0x0106, 0x0107, 0x0108, 0x0109, 0x010a };
+static const u16 snd_djm_opts_750mk2_cap2[] = {
+	0x0200, 0x0202, 0x0203, 0x0206, 0x0207, 0x0208, 0x0209, 0x020a };
+static const u16 snd_djm_opts_750mk2_cap3[] = {
+	0x0300, 0x0302, 0x0303, 0x0306, 0x0307, 0x0308, 0x0309, 0x030a };
+static const u16 snd_djm_opts_750mk2_cap4[] = {
+	0x0400, 0x0402, 0x0403, 0x0406, 0x0407, 0x0408, 0x0409, 0x040a };
+static const u16 snd_djm_opts_750mk2_cap5[] = {
+	0x0507, 0x0508, 0x0509, 0x050a, 0x0511, 0x0512, 0x0513, 0x0514 };
+
+static const u16 snd_djm_opts_750mk2_pb1[] = { 0x0100, 0x0101, 0x0104 };
+static const u16 snd_djm_opts_750mk2_pb2[] = { 0x0200, 0x0201, 0x0204 };
+static const u16 snd_djm_opts_750mk2_pb3[] = { 0x0300, 0x0301, 0x0304 };
+
+
+static const struct snd_djm_ctl snd_djm_ctls_750mk2[] = {
+	SND_DJM_CTL("Capture Level", cap_level, 0, SND_DJM_WINDEX_CAPLVL),
+	SND_DJM_CTL("Ch1 Input",   750mk2_cap1, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch2 Input",   750mk2_cap2, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch3 Input",   750mk2_cap3, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch4 Input",   750mk2_cap4, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch5 Input",   750mk2_cap5, 3, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch1 Output",   750mk2_pb1, 0, SND_DJM_WINDEX_PB),
+	SND_DJM_CTL("Ch2 Output",   750mk2_pb2, 1, SND_DJM_WINDEX_PB),
+	SND_DJM_CTL("Ch3 Output",   750mk2_pb3, 2, SND_DJM_WINDEX_PB)
+};
+
 
 static const struct snd_djm_device snd_djm_devices[] = {
 	SND_DJM_DEVICE(250mk2),
 	SND_DJM_DEVICE(750),
+	SND_DJM_DEVICE(750mk2),
 	SND_DJM_DEVICE(850),
 	SND_DJM_DEVICE(900nxs2)
 };
@@ -3094,6 +3125,9 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 	case USB_ID(0x08e4, 0x017f): /* Pioneer DJ DJM-750 */
 		err = snd_djm_controls_create(mixer, SND_DJM_750_IDX);
 		break;
+	case USB_ID(0x2b73, 0x001b): /* Pioneer DJ DJM-750MK2 */
+		err = snd_djm_controls_create(mixer, SND_DJM_750MK2_IDX);
+		break;
 	case USB_ID(0x08e4, 0x0163): /* Pioneer DJ DJM-850 */
 		err = snd_djm_controls_create(mixer, SND_DJM_850_IDX);
 		break;
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 91d40b4c851c1..ac55c7dad950f 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3960,6 +3960,64 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 		}
 	}
 },
+{
+	/*
+	 * Pioneer DJ DJM-750MK2
+	 * 10 channels playback & 12 channels capture @ 48kHz S24LE
+	 */
+	USB_DEVICE_VENDOR_SPEC(0x2b73, 0x001b),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = (const struct snd_usb_audio_quirk[]) {
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 10,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+					    USB_ENDPOINT_SYNC_ASYNC,
+					.rates = SNDRV_PCM_RATE_48000,
+					.rate_min = 48000,
+					.rate_max = 48000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) {
+						48000
+					}
+				}
+			},
+			{
+				.ifnum = 0,
+				.type = QUIRK_AUDIO_FIXED_ENDPOINT,
+				.data = &(const struct audioformat) {
+					.formats = SNDRV_PCM_FMTBIT_S24_3LE,
+					.channels = 12,
+					.iface = 0,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x82,
+					.ep_idx = 1,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						USB_ENDPOINT_SYNC_ASYNC|
+						USB_ENDPOINT_USAGE_IMPLICIT_FB,
+					.rates = SNDRV_PCM_RATE_48000,
+					.rate_min = 48000,
+					.rate_max = 48000,
+					.nr_rates = 1,
+					.rate_table = (unsigned int[]) { 48000 }
+				}
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
 {
 	/*
 	 * Pioneer DJ DJM-850
-- 
2.33.0

