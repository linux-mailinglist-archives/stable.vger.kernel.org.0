Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAFA1BCABB
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbgD1Sfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729495AbgD1Sfp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:35:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45257208E0;
        Tue, 28 Apr 2020 18:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098944;
        bh=12G/m6yxrjQ9c/3lBIXrpXeyzDyRT9nuUq13X32P9fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsAlPEj5vkPPVOVNxJLpLX04WuPb5u2LHRlmZ7ytwvxfNjWWWBIY2MxWmFQLpUwY1
         CzJXrkYuGa6D4BHbLUQ/jjDUt9K6F2mkF+xUdZJBrLiMX6OKOc3sxNpJfSLGvDWVUx
         VlQGGFQINGcArQxVzCRMNaUbyIblxWZhC0h1p0cg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 076/131] ALSA: usb-audio: Add connector notifier delegation
Date:   Tue, 28 Apr 2020 20:24:48 +0200
Message-Id: <20200428182234.489665142@linuxfoundation.org>
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

[ Upstream commit fef66ae73a611e84c8b4b74ff6f805ec5f113477 ]

It turned out that ALC1220-VB USB-audio device gives the interrupt
event to some PCM terminals while those don't allow the connector
state request but only the actual I/O terminals return the request.
The recent commit 7dc3c5a0172e ("ALSA: usb-audio: Don't create jack
controls for PCM terminals") excluded those phantom terminals, so
those events are ignored, too.

My first thought was that this could be easily deduced from the
associated terminals, but some of them have even no associate terminal
ID, hence it's not too trivial to figure out.

Since the number of such terminals are small and limited, this patch
implements another quirk table for the simple mapping of the
connectors.  It's not really scalable, but let's hope that there will
be not many such funky devices in future.

Fixes: 7dc3c5a0172e ("ALSA: usb-audio: Don't create jack controls for PCM terminals")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206873
Link: https://lore.kernel.org/r/20200422113320.26664-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c      | 25 +++++++++++++++++++++++++
 sound/usb/mixer.h      | 10 ++++++++++
 sound/usb/mixer_maps.c | 13 +++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 2638bd2e41f31..7a5c665cf4e44 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3115,6 +3115,7 @@ static int snd_usb_mixer_controls(struct usb_mixer_interface *mixer)
 		if (map->id == state.chip->usb_id) {
 			state.map = map->map;
 			state.selector_map = map->selector_map;
+			mixer->connector_map = map->connector_map;
 			mixer->ignore_ctl_error |= map->ignore_ctl_error;
 			break;
 		}
@@ -3196,10 +3197,32 @@ static int snd_usb_mixer_controls(struct usb_mixer_interface *mixer)
 	return 0;
 }
 
+static int delegate_notify(struct usb_mixer_interface *mixer, int unitid,
+			   u8 *control, u8 *channel)
+{
+	const struct usbmix_connector_map *map = mixer->connector_map;
+
+	if (!map)
+		return unitid;
+
+	for (; map->id; map++) {
+		if (map->id == unitid) {
+			if (control && map->control)
+				*control = map->control;
+			if (channel && map->channel)
+				*channel = map->channel;
+			return map->delegated_id;
+		}
+	}
+	return unitid;
+}
+
 void snd_usb_mixer_notify_id(struct usb_mixer_interface *mixer, int unitid)
 {
 	struct usb_mixer_elem_list *list;
 
+	unitid = delegate_notify(mixer, unitid, NULL, NULL);
+
 	for_each_mixer_elem(list, mixer, unitid) {
 		struct usb_mixer_elem_info *info =
 			mixer_elem_list_to_info(list);
@@ -3269,6 +3292,8 @@ static void snd_usb_mixer_interrupt_v2(struct usb_mixer_interface *mixer,
 		return;
 	}
 
+	unitid = delegate_notify(mixer, unitid, &control, &channel);
+
 	for_each_mixer_elem(list, mixer, unitid)
 		count++;
 
diff --git a/sound/usb/mixer.h b/sound/usb/mixer.h
index 3d12af8bf1917..15ec90e96d4d9 100644
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -4,6 +4,13 @@
 
 #include <sound/info.h>
 
+struct usbmix_connector_map {
+	u8 id;
+	u8 delegated_id;
+	u8 control;
+	u8 channel;
+};
+
 struct usb_mixer_interface {
 	struct snd_usb_audio *chip;
 	struct usb_host_interface *hostif;
@@ -16,6 +23,9 @@ struct usb_mixer_interface {
 	/* the usb audio specification version this interface complies to */
 	int protocol;
 
+	/* optional connector delegation map */
+	const struct usbmix_connector_map *connector_map;
+
 	/* Sound Blaster remote control stuff */
 	const struct rc_config *rc_cfg;
 	u32 rc_code;
diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 3c14ef8fd5a2b..1689e4f242dfd 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -41,6 +41,7 @@ struct usbmix_ctl_map {
 	u32 id;
 	const struct usbmix_name_map *map;
 	const struct usbmix_selector_map *selector_map;
+	const struct usbmix_connector_map *connector_map;
 	int ignore_ctl_error;
 };
 
@@ -391,6 +392,15 @@ static const struct usbmix_name_map trx40_mobo_map[] = {
 	{}
 };
 
+static const struct usbmix_connector_map trx40_mobo_connector_map[] = {
+	{ 10, 16 },	/* (Back) Speaker */
+	{ 11, 17 },	/* Front Headphone */
+	{ 13, 7 },	/* Line */
+	{ 14, 8 },	/* Mic */
+	{ 15, 9 },	/* Front Mic */
+	{}
+};
+
 /*
  * Control map entries
  */
@@ -513,6 +523,7 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
 	{	/* Gigabyte TRX40 Aorus Pro WiFi */
 		.id = USB_ID(0x0414, 0xa002),
 		.map = trx40_mobo_map,
+		.connector_map = trx40_mobo_connector_map,
 	},
 	{	/* ASUS ROG Zenith II */
 		.id = USB_ID(0x0b05, 0x1916),
@@ -525,10 +536,12 @@ static struct usbmix_ctl_map usbmix_ctl_maps[] = {
 	{	/* MSI TRX40 Creator */
 		.id = USB_ID(0x0db0, 0x0d64),
 		.map = trx40_mobo_map,
+		.connector_map = trx40_mobo_connector_map,
 	},
 	{	/* MSI TRX40 */
 		.id = USB_ID(0x0db0, 0x543d),
 		.map = trx40_mobo_map,
+		.connector_map = trx40_mobo_connector_map,
 	},
 	{ 0 } /* terminator */
 };
-- 
2.20.1



