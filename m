Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CED59BAE2
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiHVIFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233683AbiHVIEq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:04:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12B82C124
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ADD7B80E69
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A37AC433C1;
        Mon, 22 Aug 2022 08:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661155435;
        bh=yMDbE2biZRjsvZZV/t2uufhz4tLBZMJaLS9Q3pr+ZGs=;
        h=Subject:To:Cc:From:Date:From;
        b=heC0dyovI+2gtPdpAscNVVxdCbXcKPky2V/4v+y8ykPlZNO9EmYobP+znYwiGPBMJ
         pfJdXnJwMEnV5nJ69D9zsPuclaqTyWDKI8fjAe0TtqXmY6gTWwNoleAmMEbF5eJVQI
         y1WSycQwnOBIj1ZPgqjctfsaBkoeLKxJ5Usws940=
Subject: FAILED: patch "[PATCH] ALSA: usb-audio: Turn off 'manual mode' on Dell dock" failed to apply to 5.19-stable tree
To:     jan@jschaer.ch, tiwai@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:03:53 +0200
Message-ID: <16611554332027@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e57a3358dda20128593fff9b39b522f1bdd26c6 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>
Date: Mon, 27 Jun 2022 19:18:55 +0200
Subject: [PATCH] ALSA: usb-audio: Turn off 'manual mode' on Dell dock
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This removes the need to power cycle the Dell WD15 dock if it has been
attached to a Windows machine.

The Windows driver puts the ALC4020 USB audio controller into
'manual mode', and then does all the power management and other
configuration itself, by sending HD audio commands directly to the
ALC3263 audio codec via vendor-type USB messages. If manual mode is off,
this is all handled by the firmware, and works well enough.

If manual mode is turned on, the latency of the SET INTERFACE command
goes from several hundred ms to less than 1 ms
(see https://bugzilla.suse.com/show_bug.cgi?id=1089467), but I'm not
sure if the additional code that would be required is worth it.

Funnily enough, the Windows driver tries to turn off manual mode when
the dock is disconnected, which doesn't work for obvious reasons.

Additionally, fix a bug in dell_dock_init_vol, which didn't work because
the Control Selector was missing.
Now, it properly resets the volume to 0dB.

Fixes: 964af639ad69 ("ALSA: usb-audio: Initialize Dell Dock playback volumes")
Signed-off-by: Jan Schär <jan@jschaer.ch>
Link: https://lore.kernel.org/r/20220627171855.42338-2-jan@jschaer.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 66b6476994eb..5a45822e60e7 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -1949,9 +1949,11 @@ static int snd_soundblaster_e1_switch_create(struct usb_mixer_interface *mixer)
 #define REALTEK_HDA_VALUE 0x0038
 
 #define REALTEK_HDA_SET		62
+#define REALTEK_MANUAL_MODE	72
 #define REALTEK_HDA_GET_OUT	88
 #define REALTEK_HDA_GET_IN	89
 
+#define REALTEK_AUDIO_FUNCTION_GROUP	0x01
 #define REALTEK_LINE1			0x1a
 #define REALTEK_VENDOR_REGISTERS	0x20
 #define REALTEK_HP_OUT			0x21
@@ -2084,6 +2086,21 @@ static int realtek_add_jack(struct usb_mixer_interface *mixer,
 static int dell_dock_mixer_create(struct usb_mixer_interface *mixer)
 {
 	int err;
+	struct usb_device *dev = mixer->chip->dev;
+
+	/* Power down the audio codec to avoid loud pops in the next step. */
+	realtek_hda_set(mixer->chip,
+			HDA_VERB_CMD(AC_VERB_SET_POWER_STATE,
+				     REALTEK_AUDIO_FUNCTION_GROUP,
+				     AC_PWRST_D3));
+
+	/*
+	 * Turn off 'manual mode' in case it was enabled. This removes the need
+	 * to power cycle the dock after it was attached to a Windows machine.
+	 */
+	snd_usb_ctl_msg(dev, usb_sndctrlpipe(dev, 0), REALTEK_MANUAL_MODE,
+			USB_RECIP_DEVICE | USB_TYPE_VENDOR | USB_DIR_OUT,
+			0, 0, NULL, 0);
 
 	err = realtek_add_jack(mixer, "Line Out Jack", REALTEK_LINE1);
 	if (err < 0)
@@ -2104,7 +2121,8 @@ static void dell_dock_init_vol(struct snd_usb_audio *chip, int ch, int id)
 
 	snd_usb_ctl_msg(chip->dev, usb_sndctrlpipe(chip->dev, 0), UAC_SET_CUR,
 			USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_OUT,
-			ch, snd_usb_ctrl_intf(chip) | (id << 8),
+			(UAC_FU_VOLUME << 8) | ch,
+			snd_usb_ctrl_intf(chip) | (id << 8),
 			&buf, 2);
 }
 

