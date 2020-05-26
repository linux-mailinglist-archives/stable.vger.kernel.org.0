Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4881BCAE1
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbgD1Sw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729767AbgD1Sfi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:35:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0AE021707;
        Tue, 28 Apr 2020 18:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098937;
        bh=wQT0NZEs+27u1LF8elCTQvvAaHB5bW7Z7i0FVy5aQ4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikrQaYeUB1begBEy8N/euMSsP8KQaJlQuOcy3A3GZNWpAn1f98sx5Xi6hT3oHO9If
         5cCZoVIEbRQwNoRCJEH6o7yl0Z+62urtc5v9XfCaHwLjY2WZ0CYlGcokbK1V883MAm
         7d3DF2TQrZivgy7mH+aNTPbMf+tiNQTHzvoY3BTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/131] ALSA: usb-audio: Add static mapping table for ALC1220-VB-based mobos
Date:   Tue, 28 Apr 2020 20:24:47 +0200
Message-Id: <20200428182234.365733149@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a43c1c41bc5145971d06edc42a6b1e8faa0e2bc3 ]

TRX40 mobos from MSI and others with ALC1220-VB USB-audio device need
yet more quirks for the proper control names.

This patch provides the mapping table for those boards, correcting the
FU names for volume and mute controls as well as the terminal names
for jack controls.  It also improves build_connector_control() not to
add the directional suffix blindly if the string is given from the
mapping table.

With this patch applied, the new UCM profiles will be effective.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206873
Link: https://lore.kernel.org/r/20200420062036.28567-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c        | 12 +++++++++---
 sound/usb/mixer_maps.c   | 24 +++++++++++++++++++++---
 sound/usb/quirks-table.h | 14 ++++++++++++++
 3 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 257da95a4ea6a..2638bd2e41f31 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1770,8 +1770,10 @@ static void build_connector_control(struct usb_mixer_interface *mixer,
 {
 	struct snd_kcontrol *kctl;
 	struct usb_mixer_elem_info *cval;
+	const struct usbmix_name_map *map;
 
-	if (check_ignored_ctl(find_map(imap, term->id, 0)))
+	map = find_map(imap, term->id, 0);
+	if (check_ignored_ctl(map))
 		return;
 
 	cval = kzalloc(sizeof(*cval), GFP_KERNEL);
@@ -1803,8 +1805,12 @@ static void build_connector_control(struct usb_mixer_interface *mixer,
 		usb_mixer_elem_info_free(cval);
 		return;
 	}
-	get_connector_control_name(mixer, term, is_input, kctl->id.name,
-				   sizeof(kctl->id.name));
+
+	if (check_mapped_name(map, kctl->id.name, sizeof(kctl->id.name)))
+		strlcat(kctl->id.name, " Jack", sizeof(kctl->id.name));
+	else
+		get_connector_control_name(mixer, term, is_input, kctl->id.name,
+					   sizeof(kctl->id.name));
 	kctl->private_free = snd_usb_mixer_elem_free;
 	snd_usb_mixer_add_control(&cval->head, kctl);
 }
diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index bf000e54461b1..3c14ef8fd5a2b 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -373,6 +373,24 @@ static const struct usbmix_name_map asus_rog_map[] = {
 	{}
 };
 
+/* TRX40 mobos with Realtek ALC1220-VB */
+static const struct usbmix_name_map trx40_mobo_map[] = {
+	{ 18, NULL }, /* OT, IEC958 - broken response, disabled */
+	{ 19, NULL, 12 }, /* FU, Input Gain Pad - broken response, disabled */
+	{ 16, "Speaker" },		/* OT */
+	{ 22, "Speaker Playback" },	/* FU */
+	{ 7, "Line" },			/* IT */
+	{ 19, "Line Capture" },		/* FU */
+	{ 17, "Front Headphone" },	/* OT */
+	{ 23, "Front Headphone Playback" },	/* FU */
+	{ 8, "Mic" },			/* IT */
+	{ 20, "Mic Capture" },		/* FU */
+	{ 9, "Front Mic" },		/* IT */
+	{ 21, "Front Mic Capture" },	/* FU */
+	{ 24, "IEC958 Playback" },	/* FU */
+	{}
+};
+
 /*
  * Control map entries
  */
@@ -494,7 +512,7 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
 	},
 	{	/* Gigabyte TRX40 Aorus Pro WiFi */
 		.id = USB_ID(0x0414, 0xa002),
-		.map = asus_rog_map,
+		.map = trx40_mobo_map,
 	},
 	{	/* ASUS ROG Zenith II */
 		.id = USB_ID(0x0b05, 0x1916),
@@ -506,11 +524,11 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
 	},
 	{	/* MSI TRX40 Creator */
 		.id = USB_ID(0x0db0, 0x0d64),
-		.map = asus_rog_map,
+		.map = trx40_mobo_map,
 	},
 	{	/* MSI TRX40 */
 		.id = USB_ID(0x0db0, 0x543d),
-		.map = asus_rog_map,
+		.map = trx40_mobo_map,
 	},
 	{ 0 } /* terminator */
 };
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 90d4f61cc2308..774aeedde0717 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3400,4 +3400,18 @@ AU0828_DEVICE(0x2040, 0x7270, "Hauppauge", "HVR-950Q"),
 	}
 },
 
+#define ALC1220_VB_DESKTOP(vend, prod) { \
+	USB_DEVICE(vend, prod),	\
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) { \
+		.vendor_name = "Realtek", \
+		.product_name = "ALC1220-VB-DT", \
+		.profile_name = "Realtek-ALC1220-VB-Desktop", \
+		.ifnum = QUIRK_NO_INTERFACE \
+	} \
+}
+ALC1220_VB_DESKTOP(0x0414, 0xa002), /* Gigabyte TRX40 Aorus Pro WiFi */
+ALC1220_VB_DESKTOP(0x0db0, 0x0d64), /* MSI TRX40 Creator */
+ALC1220_VB_DESKTOP(0x0db0, 0x543d), /* MSI TRX40 */
+#undef ALC1220_VB_DESKTOP
+
 #undef USB_DEVICE_VENDOR_SPEC
-- 
2.20.1



