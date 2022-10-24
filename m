Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7AE060B817
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiJXTls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbiJXTky (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:40:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE14725F8F1;
        Mon, 24 Oct 2022 11:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD0B5B818B7;
        Mon, 24 Oct 2022 12:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D8CC433C1;
        Mon, 24 Oct 2022 12:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615968;
        bh=BOiNwzGEdxVcIXMHCL7bT3MXZ0L2ItRvXx52AATbP1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVNkJYK5PB4EYUmZ6fbw9q+22f0qjSdKZHliT6qn9xQknqILSYUmRgHD+X8hk2vwA
         v4aazMMWmChMeZ2xd+ObNz73IiOTJE8zh9vXuD8+8VPpvhzpJIRyn5xnMsw86r3/ll
         EDbhe1JdD2Xl62Nb3zk69rUUot9fKb58phBPqXg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 451/530] ALSA: usb-audio: Register card at the last interface
Date:   Mon, 24 Oct 2022 13:33:15 +0200
Message-Id: <20221024113105.471639512@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 6392dcd1d0c7034ccf630ec55fc9e5810ecadf3b ]

The USB-audio driver matches per interface, and as default, it
registers the card instance at the very first instance.  This can be a
problem for the devices that have multiple interfaces to be probed, as
the udev rule isn't applied properly for the later appearing
interfaces.  Although we introduced the delayed_register option and
the quirks for covering those shortcomings, it's nothing but a
workaround for specific devices.

This patch is an another attempt to fix the problem in a more generic
way.  Now the driver checks the whole USB device descriptor at the
very first time when an interface is attached to a sound card.  It
looks at each matching interface in the descriptor and remembers the
last matching one.  The snd_card_register() is invoked only when this
last interface is probed.

After this change, the quirks for the delayed registration become
superfluous, hence they are removed along with the patch.  OTOH, the
delayed_register option is still kept, as it might be useful for some
corner cases (e.g. a special driver overtakes the interface probe from
the standard driver, and the last interface probe may miss).

Link: https://lore.kernel.org/r/20220904161247.16461-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c     |   32 +++++++++++++++++++++++++-------
 sound/usb/quirks.c   |   42 ------------------------------------------
 sound/usb/quirks.h   |    2 --
 sound/usb/usbaudio.h |    1 +
 4 files changed, 26 insertions(+), 51 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -689,7 +689,7 @@ static bool get_alias_id(struct usb_devi
 	return false;
 }
 
-static bool check_delayed_register_option(struct snd_usb_audio *chip, int iface)
+static int check_delayed_register_option(struct snd_usb_audio *chip)
 {
 	int i;
 	unsigned int id, inum;
@@ -698,14 +698,31 @@ static bool check_delayed_register_optio
 		if (delayed_register[i] &&
 		    sscanf(delayed_register[i], "%x:%x", &id, &inum) == 2 &&
 		    id == chip->usb_id)
-			return iface < inum;
+			return inum;
 	}
 
-	return false;
+	return -1;
 }
 
 static const struct usb_device_id usb_audio_ids[]; /* defined below */
 
+/* look for the last interface that matches with our ids and remember it */
+static void find_last_interface(struct snd_usb_audio *chip)
+{
+	struct usb_host_config *config = chip->dev->actconfig;
+	struct usb_interface *intf;
+	int i;
+
+	if (!config)
+		return;
+	for (i = 0; i < config->desc.bNumInterfaces; i++) {
+		intf = config->interface[i];
+		if (usb_match_id(intf, usb_audio_ids))
+			chip->last_iface = intf->altsetting[0].desc.bInterfaceNumber;
+	}
+	usb_audio_dbg(chip, "Found last interface = %d\n", chip->last_iface);
+}
+
 /* look for the corresponding quirk */
 static const struct snd_usb_audio_quirk *
 get_alias_quirk(struct usb_device *dev, unsigned int id)
@@ -812,6 +829,7 @@ static int usb_audio_probe(struct usb_in
 			err = -ENODEV;
 			goto __error;
 		}
+		find_last_interface(chip);
 	}
 
 	if (chip->num_interfaces >= MAX_CARD_INTERFACES) {
@@ -861,11 +879,11 @@ static int usb_audio_probe(struct usb_in
 		chip->need_delayed_register = false; /* clear again */
 	}
 
-	/* we are allowed to call snd_card_register() many times, but first
-	 * check to see if a device needs to skip it or do anything special
+	/* register card if we reach to the last interface or to the specified
+	 * one given via option
 	 */
-	if (!snd_usb_registration_quirk(chip, ifnum) &&
-	    !check_delayed_register_option(chip, ifnum)) {
+	if (check_delayed_register_option(chip) == ifnum ||
+	    chip->last_iface == ifnum) {
 		err = snd_card_register(chip->card);
 		if (err < 0)
 			goto __error;
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1729,48 +1729,6 @@ void snd_usb_audioformat_attributes_quir
 }
 
 /*
- * registration quirk:
- * the registration is skipped if a device matches with the given ID,
- * unless the interface reaches to the defined one.  This is for delaying
- * the registration until the last known interface, so that the card and
- * devices appear at the same time.
- */
-
-struct registration_quirk {
-	unsigned int usb_id;	/* composed via USB_ID() */
-	unsigned int interface;	/* the interface to trigger register */
-};
-
-#define REG_QUIRK_ENTRY(vendor, product, iface) \
-	{ .usb_id = USB_ID(vendor, product), .interface = (iface) }
-
-static const struct registration_quirk registration_quirks[] = {
-	REG_QUIRK_ENTRY(0x0951, 0x16d8, 2),	/* Kingston HyperX AMP */
-	REG_QUIRK_ENTRY(0x0951, 0x16ed, 2),	/* Kingston HyperX Cloud Alpha S */
-	REG_QUIRK_ENTRY(0x0951, 0x16ea, 2),	/* Kingston HyperX Cloud Flight S */
-	REG_QUIRK_ENTRY(0x0ecb, 0x1f46, 2),	/* JBL Quantum 600 */
-	REG_QUIRK_ENTRY(0x0ecb, 0x1f47, 2),	/* JBL Quantum 800 */
-	REG_QUIRK_ENTRY(0x0ecb, 0x1f4c, 2),	/* JBL Quantum 400 */
-	REG_QUIRK_ENTRY(0x0ecb, 0x2039, 2),	/* JBL Quantum 400 */
-	REG_QUIRK_ENTRY(0x0ecb, 0x203c, 2),	/* JBL Quantum 600 */
-	REG_QUIRK_ENTRY(0x0ecb, 0x203e, 2),	/* JBL Quantum 800 */
-	{ 0 }					/* terminator */
-};
-
-/* return true if skipping registration */
-bool snd_usb_registration_quirk(struct snd_usb_audio *chip, int iface)
-{
-	const struct registration_quirk *q;
-
-	for (q = registration_quirks; q->usb_id; q++)
-		if (chip->usb_id == q->usb_id)
-			return iface < q->interface;
-
-	/* Register as normal */
-	return false;
-}
-
-/*
  * driver behavior quirk flags
  */
 struct usb_audio_quirk_flags_table {
--- a/sound/usb/quirks.h
+++ b/sound/usb/quirks.h
@@ -48,8 +48,6 @@ void snd_usb_audioformat_attributes_quir
 					  struct audioformat *fp,
 					  int stream);
 
-bool snd_usb_registration_quirk(struct snd_usb_audio *chip, int iface);
-
 void snd_usb_init_quirk_flags(struct snd_usb_audio *chip);
 
 #endif /* __USBAUDIO_QUIRKS_H */
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -37,6 +37,7 @@ struct snd_usb_audio {
 	unsigned int quirk_flags;
 	unsigned int need_delayed_register:1; /* warn for delayed registration */
 	int num_interfaces;
+	int last_iface;
 	int num_suspended_intf;
 	int sample_rate_read_error;
 


