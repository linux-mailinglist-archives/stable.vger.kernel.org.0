Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02088450C7A
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbhKORjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:39:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238266AbhKORhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:37:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CAA7632D2;
        Mon, 15 Nov 2021 17:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997106;
        bh=V420ClroFcZoi3zfmuL4BMuZfNT5jENYf46hJiVHZq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDQkIKuhzobqU+ru80y0t3i+en/2X/EcWWHBMMvaoIddaHK5/oF4XkA4e+zpnjaxo
         PlFim84vkAR4LY12zi9D6SEMdSmYasv000l9HqVQE7FBMc4ASz4dgXzIarQ0ogLYNK
         loU/uY7wCpDt8QEbhaLhNExYb+rP4EkdAoOa5m0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johnathon Clark <john.clark@cantab.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 027/575] ALSA: hda/realtek: Fix mic mute LED for the HP Spectre x360 14
Date:   Mon, 15 Nov 2021 17:55:52 +0100
Message-Id: <20211115165344.554817655@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johnathon Clark <john.clark@cantab.net>

commit 5fc462c3aaad601d5089fd5588a5799896a6937d upstream.

On the 'HP Spectre x360 Convertible 14-ea0xx' the microphone mute led is
controlled by GPIO 0x04. The speaker mute LED does not seem to be
exposed by GPIO and is there not set.

[ a slight coding-style fix by tiwai ]

Fixes: c3bb2b521944 ("ALSA: hda/realtek: Quirk for HP Spectre x360 14 amp setup")
Signed-off-by: Johnathon Clark <john.clark@cantab.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211020131253.35894-1-john.clark@cantab.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4300,6 +4300,16 @@ static void alc287_fixup_hp_gpio_led(str
 	alc_fixup_hp_gpio_led(codec, action, 0x10, 0);
 }
 
+static void alc245_fixup_hp_gpio_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		spec->micmute_led_polarity = 1;
+	alc_fixup_hp_gpio_led(codec, action, 0, 0x04);
+}
+
 /* turn on/off mic-mute LED per capture hook via VREF change */
 static int vref_micmute_led_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
@@ -6616,6 +6626,7 @@ enum {
 	ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
 	ALC287_FIXUP_HP_GPIO_LED,
 	ALC256_FIXUP_HP_HEADSET_MIC,
+	ALC245_FIXUP_HP_GPIO_LED,
 	ALC236_FIXUP_DELL_AIO_HEADSET_MIC,
 	ALC282_FIXUP_ACER_DISABLE_LINEOUT,
 	ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST,
@@ -7239,6 +7250,8 @@ static const struct hda_fixup alc269_fix
 	[ALC245_FIXUP_HP_X360_AMP] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_x360_amp,
+		.chained = true,
+		.chain_id = ALC245_FIXUP_HP_GPIO_LED
 	},
 	[ALC288_FIXUP_DELL_HEADSET_MODE] = {
 		.type = HDA_FIXUP_FUNC,
@@ -8328,6 +8341,10 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc256_fixup_tongfang_reset_persistent_settings,
 	},
+	[ALC245_FIXUP_HP_GPIO_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_gpio_led,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {


