Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E01A3788C5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhEJLXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237284AbhEJLLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B12D61928;
        Mon, 10 May 2021 11:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644913;
        bh=QFW2PpfndsL4yLPOv8wibmBs/SN33oj8abfed6abK/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJ0v+6mDIxtEcLmvtF10PICbgT7DRn5RVhJGeCynxPyzMvh4/4PPdkQfqSDh7dwQ7
         fx7dGoQNBVRQ2vUSiu818GWRp5sx4CyOzmnhh1bz/MMyUBVcI7L9JW2YWvo84u7oQR
         HgxjtPm/Gk05yu9fBMO+a78vmZPcH6QBf8JKFXkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Witschel <diabonas@archlinux.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.12 276/384] ALSA: hda/realtek: fix mute/micmute LEDs for HP ProBook 445 G7
Date:   Mon, 10 May 2021 12:21:05 +0200
Message-Id: <20210510102023.929346496@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Witschel <diabonas@archlinux.org>

commit 75b62ab65d2715ce6ff0794033d61ab9dc4a2dfc upstream.

The HP ProBook 445 G7 (17T32ES) uses ALC236. Like ALC236_FIXUP_HP_GPIO_LED,
COEF index 0x34 bit 5 is used to control the playback mute LED, but the
microphone mute LED is controlled using pin VREF instead of a COEF index.

AlsaInfo: https://alsa-project.org/db/?f=0d3f4d1af39cc359f9fea9b550727ee87e5cf45a
Signed-off-by: Jonas Witschel <diabonas@archlinux.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210416105852.52588-1-diabonas@archlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4438,6 +4438,25 @@ static void alc236_fixup_hp_mute_led(str
 	alc236_fixup_hp_coef_micmute_led(codec, fix, action);
 }
 
+static void alc236_fixup_hp_micmute_led_vref(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->cap_mute_led_nid = 0x1a;
+		snd_hda_gen_add_micmute_led_cdev(codec, vref_micmute_led_set);
+		codec->power_filter = led_power_filter;
+	}
+}
+
+static void alc236_fixup_hp_mute_led_micmute_vref(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	alc236_fixup_hp_mute_led_coefbit(codec, fix, action);
+	alc236_fixup_hp_micmute_led_vref(codec, fix, action);
+}
+
 #if IS_REACHABLE(CONFIG_INPUT)
 static void gpio2_mic_hotkey_event(struct hda_codec *codec,
 				   struct hda_jack_callback *event)
@@ -6400,6 +6419,7 @@ enum {
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_GPIO_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
+	ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
 	ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
 	ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS,
@@ -7646,6 +7666,10 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc236_fixup_hp_mute_led,
 	},
+	[ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc236_fixup_hp_mute_led_micmute_vref,
+	},
 	[ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -8063,6 +8087,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8730, "HP ProBook 445 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),


