Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A24395FB7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhEaOPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233272AbhEaOMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 891C96135B;
        Mon, 31 May 2021 13:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468495;
        bh=wNJyw0FCT7Y4inlBDgPX/MjrZeL/hdFpG2Lu13ra0QE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lm3z72+UIpx8U7sIsA0tLgZzhhewMIK08hzgJQSGMI+SIzYNYizzd8VBPOJCEiVWm
         czzgi6NpELoMcvdhszVYs2Jp4bjVhmtsjNLu0k5lL9M/6+ws14wxkQ2/5gZWzEgZoh
         IWjCtEZledISmFlpyFWqdPdq3075tnwiHDrpkCuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Geoffrey D. Bennett" <g@b4.vu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 003/177] ALSA: usb-audio: scarlett2: Improve driver startup messages
Date:   Mon, 31 May 2021 15:12:40 +0200
Message-Id: <20210531130648.008684585@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoffrey D. Bennett <g@b4.vu>

commit 265d1a90e4fb6d3264d8122fbd10760e5e733be6 upstream.

Add separate init function to call the existing controls_create
function so a custom error can be displayed if initialisation fails.

Use info level instead of error for notifications.

Display the VID/PID so device_setup is targeted to the right device.

Display "enabled" message to easily confirm that the driver is loaded.

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/b5d140c65f640faf2427e085fbbc0297b32e5fce.1621584566.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c        |    2 -
 sound/usb/mixer_scarlett_gen2.c |   79 +++++++++++++++++++++++++---------------
 sound/usb/mixer_scarlett_gen2.h |    2 -
 3 files changed, 52 insertions(+), 31 deletions(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2268,7 +2268,7 @@ int snd_usb_mixer_apply_create_quirk(str
 	case USB_ID(0x1235, 0x8203): /* Focusrite Scarlett 6i6 2nd Gen */
 	case USB_ID(0x1235, 0x8204): /* Focusrite Scarlett 18i8 2nd Gen */
 	case USB_ID(0x1235, 0x8201): /* Focusrite Scarlett 18i20 2nd Gen */
-		err = snd_scarlett_gen2_controls_create(mixer);
+		err = snd_scarlett_gen2_init(mixer);
 		break;
 
 	case USB_ID(0x041e, 0x323b): /* Creative Sound Blaster E1 */
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -1997,38 +1997,11 @@ static int scarlett2_mixer_status_create
 	return usb_submit_urb(mixer->urb, GFP_KERNEL);
 }
 
-/* Entry point */
-int snd_scarlett_gen2_controls_create(struct usb_mixer_interface *mixer)
+int snd_scarlett_gen2_controls_create(struct usb_mixer_interface *mixer,
+				      const struct scarlett2_device_info *info)
 {
-	const struct scarlett2_device_info *info;
 	int err;
 
-	/* only use UAC_VERSION_2 */
-	if (!mixer->protocol)
-		return 0;
-
-	switch (mixer->chip->usb_id) {
-	case USB_ID(0x1235, 0x8203):
-		info = &s6i6_gen2_info;
-		break;
-	case USB_ID(0x1235, 0x8204):
-		info = &s18i8_gen2_info;
-		break;
-	case USB_ID(0x1235, 0x8201):
-		info = &s18i20_gen2_info;
-		break;
-	default: /* device not (yet) supported */
-		return -EINVAL;
-	}
-
-	if (!(mixer->chip->setup & SCARLETT2_ENABLE)) {
-		usb_audio_err(mixer->chip,
-			"Focusrite Scarlett Gen 2 Mixer Driver disabled; "
-			"use options snd_usb_audio device_setup=1 "
-			"to enable and report any issues to g@b4.vu");
-		return 0;
-	}
-
 	/* Initialise private data, routing, sequence number */
 	err = scarlett2_init_private(mixer, info);
 	if (err < 0)
@@ -2073,3 +2046,51 @@ int snd_scarlett_gen2_controls_create(st
 
 	return 0;
 }
+
+int snd_scarlett_gen2_init(struct usb_mixer_interface *mixer)
+{
+	struct snd_usb_audio *chip = mixer->chip;
+	const struct scarlett2_device_info *info;
+	int err;
+
+	/* only use UAC_VERSION_2 */
+	if (!mixer->protocol)
+		return 0;
+
+	switch (chip->usb_id) {
+	case USB_ID(0x1235, 0x8203):
+		info = &s6i6_gen2_info;
+		break;
+	case USB_ID(0x1235, 0x8204):
+		info = &s18i8_gen2_info;
+		break;
+	case USB_ID(0x1235, 0x8201):
+		info = &s18i20_gen2_info;
+		break;
+	default: /* device not (yet) supported */
+		return -EINVAL;
+	}
+
+	if (!(chip->setup & SCARLETT2_ENABLE)) {
+		usb_audio_info(chip,
+			"Focusrite Scarlett Gen 2 Mixer Driver disabled; "
+			"use options snd_usb_audio vid=0x%04x pid=0x%04x "
+			"device_setup=1 to enable and report any issues "
+			"to g@b4.vu",
+			USB_ID_VENDOR(chip->usb_id),
+			USB_ID_PRODUCT(chip->usb_id));
+		return 0;
+	}
+
+	usb_audio_info(chip,
+		"Focusrite Scarlett Gen 2 Mixer Driver enabled pid=0x%04x",
+		USB_ID_PRODUCT(chip->usb_id));
+
+	err = snd_scarlett_gen2_controls_create(mixer, info);
+	if (err < 0)
+		usb_audio_err(mixer->chip,
+			      "Error initialising Scarlett Mixer Driver: %d",
+			      err);
+
+	return err;
+}
--- a/sound/usb/mixer_scarlett_gen2.h
+++ b/sound/usb/mixer_scarlett_gen2.h
@@ -2,6 +2,6 @@
 #ifndef __USB_MIXER_SCARLETT_GEN2_H
 #define __USB_MIXER_SCARLETT_GEN2_H
 
-int snd_scarlett_gen2_controls_create(struct usb_mixer_interface *mixer);
+int snd_scarlett_gen2_init(struct usb_mixer_interface *mixer);
 
 #endif /* __USB_MIXER_SCARLETT_GEN2_H */


