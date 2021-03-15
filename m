Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779F433B958
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhCOOF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233281AbhCOOBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 204E764F70;
        Mon, 15 Mar 2021 14:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816859;
        bh=Y7KqdrFoVQtcaYQsWHhBptJOg9bSZb1WGzExBGJQKww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r86S33IAsTdz2m8TPXV/XiNKMnUKMcWWkGPJDEfqVM08VO+Ibl9+lebXoSUPkbMVv
         4M/v5A6lGgGlLLb8ftmxhJMUBf3MCfqN1iXbQMMrJixIkcfdeuOwsqrKxa79CnYWek
         tkAwZbRWNG5g+vMRtace06rDdTmdhXvNb/ED69s4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 166/306] ALSA: hda/conexant: Add quirk for mute LED control on HP ZBook G5
Date:   Mon, 15 Mar 2021 14:53:49 +0100
Message-Id: <20210315135513.243791764@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Takashi Iwai <tiwai@suse.de>

commit 56b26497bb4b7ff970612dc25a8a008c34463f7b upstream.

The mute and mic-mute LEDs on HP ZBook Studio G5 are controlled via
GPIO bits 0x10 and 0x20, respectively, and we need the extra setup for
those.

As the similar code is already present for other HP models but with
different GPIO pins, this patch factors out the common helper code and
applies those GPIO values for each model.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211893
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210306095018.11746-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |   62 +++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 17 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -149,6 +149,21 @@ static int cx_auto_vmaster_mute_led(stru
 	return 0;
 }
 
+static void cxt_init_gpio_led(struct hda_codec *codec)
+{
+	struct conexant_spec *spec = codec->spec;
+	unsigned int mask = spec->gpio_mute_led_mask | spec->gpio_mic_led_mask;
+
+	if (mask) {
+		snd_hda_codec_write(codec, 0x01, 0, AC_VERB_SET_GPIO_MASK,
+				    mask);
+		snd_hda_codec_write(codec, 0x01, 0, AC_VERB_SET_GPIO_DIRECTION,
+				    mask);
+		snd_hda_codec_write(codec, 0x01, 0, AC_VERB_SET_GPIO_DATA,
+				    spec->gpio_led);
+	}
+}
+
 static int cx_auto_init(struct hda_codec *codec)
 {
 	struct conexant_spec *spec = codec->spec;
@@ -156,6 +171,7 @@ static int cx_auto_init(struct hda_codec
 	if (!spec->dynamic_eapd)
 		cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, true);
 
+	cxt_init_gpio_led(codec);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_INIT);
 
 	return 0;
@@ -215,6 +231,7 @@ enum {
 	CXT_FIXUP_HP_SPECTRE,
 	CXT_FIXUP_HP_GATE_MIC,
 	CXT_FIXUP_MUTE_LED_GPIO,
+	CXT_FIXUP_HP_ZBOOK_MUTE_LED,
 	CXT_FIXUP_HEADSET_MIC,
 	CXT_FIXUP_HP_MIC_NO_PRESENCE,
 };
@@ -654,31 +671,36 @@ static int cxt_gpio_micmute_update(struc
 	return 0;
 }
 
-
-static void cxt_fixup_mute_led_gpio(struct hda_codec *codec,
-				const struct hda_fixup *fix, int action)
+static void cxt_setup_mute_led(struct hda_codec *codec,
+			       unsigned int mute, unsigned int mic_mute)
 {
 	struct conexant_spec *spec = codec->spec;
-	static const struct hda_verb gpio_init[] = {
-		{ 0x01, AC_VERB_SET_GPIO_MASK, 0x03 },
-		{ 0x01, AC_VERB_SET_GPIO_DIRECTION, 0x03 },
-		{}
-	};
 
-	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+	spec->gpio_led = 0;
+	spec->mute_led_polarity = 0;
+	if (mute) {
 		snd_hda_gen_add_mute_led_cdev(codec, cxt_gpio_mute_update);
-		spec->gpio_led = 0;
-		spec->mute_led_polarity = 0;
-		spec->gpio_mute_led_mask = 0x01;
-		spec->gpio_mic_led_mask = 0x02;
+		spec->gpio_mute_led_mask = mute;
+	}
+	if (mic_mute) {
 		snd_hda_gen_add_micmute_led_cdev(codec, cxt_gpio_micmute_update);
+		spec->gpio_mic_led_mask = mic_mute;
 	}
-	snd_hda_add_verbs(codec, gpio_init);
-	if (spec->gpio_led)
-		snd_hda_codec_write(codec, 0x01, 0, AC_VERB_SET_GPIO_DATA,
-				    spec->gpio_led);
 }
 
+static void cxt_fixup_mute_led_gpio(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		cxt_setup_mute_led(codec, 0x01, 0x02);
+}
+
+static void cxt_fixup_hp_zbook_mute_led(struct hda_codec *codec,
+					const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		cxt_setup_mute_led(codec, 0x10, 0x20);
+}
 
 /* ThinkPad X200 & co with cxt5051 */
 static const struct hda_pintbl cxt_pincfg_lenovo_x200[] = {
@@ -839,6 +861,10 @@ static const struct hda_fixup cxt_fixups
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_mute_led_gpio,
 	},
+	[CXT_FIXUP_HP_ZBOOK_MUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cxt_fixup_hp_zbook_mute_led,
+	},
 	[CXT_FIXUP_HEADSET_MIC] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_headset_mic,
@@ -917,6 +943,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8402, "HP ProBook 645 G4", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x8427, "HP ZBook Studio G5", CXT_FIXUP_HP_ZBOOK_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8455, "HP Z2 G4", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8456, "HP Z2 G4 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8457, "HP Z2 G4 mini", CXT_FIXUP_HP_MIC_NO_PRESENCE),
@@ -956,6 +983,7 @@ static const struct hda_model_fixup cxt5
 	{ .id = CXT_FIXUP_MUTE_LED_EAPD, .name = "mute-led-eapd" },
 	{ .id = CXT_FIXUP_HP_DOCK, .name = "hp-dock" },
 	{ .id = CXT_FIXUP_MUTE_LED_GPIO, .name = "mute-led-gpio" },
+	{ .id = CXT_FIXUP_HP_ZBOOK_MUTE_LED, .name = "hp-zbook-mute-led" },
 	{ .id = CXT_FIXUP_HP_MIC_NO_PRESENCE, .name = "hp-mic-fix" },
 	{}
 };


