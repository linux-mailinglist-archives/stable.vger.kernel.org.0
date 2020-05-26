Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E67661E2DC4
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391833AbgEZTYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391379AbgEZTIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:08:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EED4A208A7;
        Tue, 26 May 2020 19:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520081;
        bh=tEjzEMiEZEFeoK8EtcG/4j8pP2AresuUknmzaa2p67U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNadqIzJXJL/Cu7PR7h1PWys34Su8PDMjvnRUm8vFmyTe12qUyLSfH9zvcmVNqe69
         xa2aaL4xPreS4t5a6hFPTC9Qd7+v8dE3IQ2NY4hie/vJ3XHjd+Nu9LtFXTpVMcQA/e
         2ahcm/gzBNagnvKmHeMvBgMfvjDXoXkpjzkzjGkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/111] ALSA: hda/realtek - Add supported new mute Led for HP
Date:   Tue, 26 May 2020 20:53:09 +0200
Message-Id: <20200526183937.705149344@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 431e76c3edd76d84a0ed1eb81a286b2ddecc5ee4 ]

HP Note Book supported new mute Led.
Hardware PIN was not enough to meet old LED rule.
JD2 to control playback mute led.
GPO3 to control capture mute led.
(ALC285 didn't control GPO3 via verb command)
This two PIN just could control by COEF registers.

[ corrected typos by tiwai ]

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/6741211598ba499687362ff2aa30626b@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 81 +++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 499c8150ebb8..16f548cdf290 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -86,6 +86,14 @@ struct alc_spec {
 
 	unsigned int gpio_mute_led_mask;
 	unsigned int gpio_mic_led_mask;
+	unsigned int mute_led_coef_idx;
+	unsigned int mute_led_coefbit_mask;
+	unsigned int mute_led_coefbit_on;
+	unsigned int mute_led_coefbit_off;
+	unsigned int mic_led_coef_idx;
+	unsigned int mic_led_coefbit_mask;
+	unsigned int mic_led_coefbit_on;
+	unsigned int mic_led_coefbit_off;
 
 	hda_nid_t headset_mic_pin;
 	hda_nid_t headphone_mic_pin;
@@ -4182,6 +4190,73 @@ static void alc280_fixup_hp_gpio4(struct hda_codec *codec,
 	}
 }
 
+/* update mute-LED according to the speaker mute state via COEF bit */
+static void alc_fixup_mute_led_coefbit_hook(void *private_data, int enabled)
+{
+	struct hda_codec *codec = private_data;
+	struct alc_spec *spec = codec->spec;
+
+	if (spec->mute_led_polarity)
+		enabled = !enabled;
+
+	/* temporarily power up/down for setting COEF bit */
+	enabled ? alc_update_coef_idx(codec, spec->mute_led_coef_idx,
+		spec->mute_led_coefbit_mask, spec->mute_led_coefbit_off) :
+		  alc_update_coef_idx(codec, spec->mute_led_coef_idx,
+		spec->mute_led_coefbit_mask, spec->mute_led_coefbit_on);
+}
+
+static void alc285_fixup_hp_mute_led_coefbit(struct hda_codec *codec,
+					  const struct hda_fixup *fix,
+					  int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mute_led_polarity = 0;
+		spec->mute_led_coef_idx = 0x0b;
+		spec->mute_led_coefbit_mask = 1<<3;
+		spec->mute_led_coefbit_on = 1<<3;
+		spec->mute_led_coefbit_off = 0;
+		spec->gen.vmaster_mute.hook = alc_fixup_mute_led_coefbit_hook;
+		spec->gen.vmaster_mute_enum = 1;
+	}
+}
+
+/* turn on/off mic-mute LED per capture hook by coef bit */
+static void alc_hp_cap_micmute_update(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (spec->gen.micmute_led.led_value)
+		alc_update_coef_idx(codec, spec->mic_led_coef_idx,
+			spec->mic_led_coefbit_mask, spec->mic_led_coefbit_on);
+	else
+		alc_update_coef_idx(codec, spec->mic_led_coef_idx,
+			spec->mic_led_coefbit_mask, spec->mic_led_coefbit_off);
+}
+
+static void alc285_fixup_hp_coef_micmute_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mic_led_coef_idx = 0x19;
+		spec->mic_led_coefbit_mask = 1<<13;
+		spec->mic_led_coefbit_on = 1<<13;
+		spec->mic_led_coefbit_off = 0;
+		snd_hda_gen_add_micmute_led(codec, alc_hp_cap_micmute_update);
+	}
+}
+
+static void alc285_fixup_hp_mute_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	alc285_fixup_hp_mute_led_coefbit(codec, fix, action);
+	alc285_fixup_hp_coef_micmute_led(codec, fix, action);
+}
+
 #if IS_REACHABLE(CONFIG_INPUT)
 static void gpio2_mic_hotkey_event(struct hda_codec *codec,
 				   struct hda_jack_callback *event)
@@ -5980,6 +6055,7 @@ enum {
 	ALC294_FIXUP_ASUS_HPE,
 	ALC294_FIXUP_ASUS_COEF_1B,
 	ALC285_FIXUP_HP_GPIO_LED,
+	ALC285_FIXUP_HP_MUTE_LED,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7128,6 +7204,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_gpio_led,
 	},
+	[ALC285_FIXUP_HP_MUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_hp_mute_led,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7273,6 +7353,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.25.1



