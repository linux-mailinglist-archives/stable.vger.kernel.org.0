Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC061EAD73
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgFASp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729956AbgFASJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:09:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AC62206E2;
        Mon,  1 Jun 2020 18:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034968;
        bh=6XmarllXwyPHY9soT+MmJh7I5LdAbhyu86ak/5Kzbic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygWKwS05wMnA8OqQOZH3v5gPH4L2x0Q94o3yhakCy+rF7pF7DDjcpXeZgde799DOD
         5HHTaf2GcRpQ1u9fbxjZGa5At9k3lk7QduEZYjlO5m2TSAhQOpqGQXSSzoKAp2xUpN
         KscqBNhzX8LxosUaRafQHlJ9z0BbcVcTjO5Ub2mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/142] ALSA: usb-audio: Quirks for Gigabyte TRX40 Aorus Master onboard audio
Date:   Mon,  1 Jun 2020 19:54:10 +0200
Message-Id: <20200601174047.487958844@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7f5ad9c9003425175f46c94df380e8c9e558cfb5 ]

Gigabyte TRX40 Aorus Master is equipped with two USB-audio devices,
a Realtek ALC1220-VB codec (USB ID 0414:a001) and an ESS SABRE9218 DAC
(USB ID 0414:a000).  The latter serves solely for the headphone output
on the front panel while the former serves for the rest I/Os (mostly
for the I/Os in the rear panel but also including the front mic).

Both chips do work more or less with the unmodified USB-audio driver,
but there are a few glitches.  The ALC1220-VB returns an error for an
inquiry to some jacks, as already seen on other TRX40-based mobos.
However this machine has a slightly incompatible configuration, hence
the existing mapping cannot be used as is.

Meanwhile the ESS chip seems working without any quirk.  But since
both audio devices don't provide any specific names, both cards appear
as "USB-Audio", and it's quite confusing for users.

This patch is an attempt to overcome those issues:

- The specific mapping table for ALC1220-VB is provided, reducing the
  non-working nodes and renaming the badly chosen controls.
  The connector map isn't needed here unlike other TRX40 quirks.

- For both USB IDs (0414:a000 and 0414:a001), provide specific card
  name strings, so that user-space can identify more easily; and more
  importantly, UCM profile can be applied to each.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200526082810.29506-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_maps.c   | 19 +++++++++++++++++++
 sound/usb/quirks-table.h | 25 +++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 2255f9abd7a5..ac84f0b2b0bc 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -387,6 +387,21 @@ static const struct usbmix_connector_map trx40_mobo_connector_map[] = {
 	{}
 };
 
+/* Rear panel + front mic on Gigabyte TRX40 Aorus Master with ALC1220-VB */
+static const struct usbmix_name_map aorus_master_alc1220vb_map[] = {
+	{ 17, NULL },			/* OT, IEC958?, disabled */
+	{ 19, NULL, 12 }, /* FU, Input Gain Pad - broken response, disabled */
+	{ 16, "Line Out" },		/* OT */
+	{ 22, "Line Out Playback" },	/* FU */
+	{ 7, "Line" },			/* IT */
+	{ 19, "Line Capture" },		/* FU */
+	{ 8, "Mic" },			/* IT */
+	{ 20, "Mic Capture" },		/* FU */
+	{ 9, "Front Mic" },		/* IT */
+	{ 21, "Front Mic Capture" },	/* FU */
+	{}
+};
+
 /*
  * Control map entries
  */
@@ -506,6 +521,10 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x05a7, 0x1020),
 		.map = bose_companion5_map,
 	},
+	{	/* Gigabyte TRX40 Aorus Master (rear panel + front mic) */
+		.id = USB_ID(0x0414, 0xa001),
+		.map = aorus_master_alc1220vb_map,
+	},
 	{	/* Gigabyte TRX40 Aorus Pro WiFi */
 		.id = USB_ID(0x0414, 0xa002),
 		.map = trx40_mobo_map,
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index aa4c16ce0e57..bbae11605a4c 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3650,4 +3650,29 @@ ALC1220_VB_DESKTOP(0x0db0, 0x543d), /* MSI TRX40 */
 ALC1220_VB_DESKTOP(0x26ce, 0x0a01), /* Asrock TRX40 Creator */
 #undef ALC1220_VB_DESKTOP
 
+/* Two entries for Gigabyte TRX40 Aorus Master:
+ * TRX40 Aorus Master has two USB-audio devices, one for the front headphone
+ * with ESS SABRE9218 DAC chip, while another for the rest I/O (the rear
+ * panel and the front mic) with Realtek ALC1220-VB.
+ * Here we provide two distinct names for making UCM profiles easier.
+ */
+{
+	USB_DEVICE(0x0414, 0xa000),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		.vendor_name = "Gigabyte",
+		.product_name = "Aorus Master Front Headphone",
+		.profile_name = "Gigabyte-Aorus-Master-Front-Headphone",
+		.ifnum = QUIRK_NO_INTERFACE
+	}
+},
+{
+	USB_DEVICE(0x0414, 0xa001),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		.vendor_name = "Gigabyte",
+		.product_name = "Aorus Master Main Audio",
+		.profile_name = "Gigabyte-Aorus-Master-Main-Audio",
+		.ifnum = QUIRK_NO_INTERFACE
+	}
+},
+
 #undef USB_DEVICE_VENDOR_SPEC
-- 
2.25.1



