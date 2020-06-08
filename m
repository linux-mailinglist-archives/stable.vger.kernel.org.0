Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3519B1F2D6C
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgFIAd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbgFHXOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DF0E21532;
        Mon,  8 Jun 2020 23:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658094;
        bh=zkzHQ3L6t8f+yP/wGT2EgnhMayEURSqiXPI+bmXbr6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bh0yGGoLRoIAjOrSn2SarRTwDcRrLIGQY10UHe15/4rO1eKzla1j0JLVx7rYUj+vR
         6byqBCdAv1aCrpjzAvUXaKYLuHi9k1zu5j8teRIZWR6LEAM7OrsXWLUprxIENHr5fJ
         jRmPzU7cP77qXhNiJsXwOctK/jGvcviJuAI9dRbE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 136/606] ALSA: hda/realtek - Add HP new mute led supported for ALC236
Date:   Mon,  8 Jun 2020 19:04:21 -0400
Message-Id: <20200608231211.3363633-136-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 24164f434dc9c23cd34fca1e36acea9d0581bdde ]

HP new platform has new mute led feature.
COEF index 0x34 bit 5 to control playback mute led.
COEF index 0x35 bit 2 and bit 3 to control Mic mute led.

[ corrected typos by tiwai ]

Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/6741211598ba499687362ff2aa30626b@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 44 +++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 44fbd5d2d89c..368ed3678fc2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4223,6 +4223,23 @@ static void alc285_fixup_hp_mute_led_coefbit(struct hda_codec *codec,
 	}
 }
 
+static void alc236_fixup_hp_mute_led_coefbit(struct hda_codec *codec,
+					  const struct hda_fixup *fix,
+					  int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mute_led_polarity = 0;
+		spec->mute_led_coef_idx = 0x34;
+		spec->mute_led_coefbit_mask = 1<<5;
+		spec->mute_led_coefbit_on = 0;
+		spec->mute_led_coefbit_off = 1<<5;
+		spec->gen.vmaster_mute.hook = alc_fixup_mute_led_coefbit_hook;
+		spec->gen.vmaster_mute_enum = 1;
+	}
+}
+
 /* turn on/off mic-mute LED per capture hook by coef bit */
 static void alc_hp_cap_micmute_update(struct hda_codec *codec)
 {
@@ -4250,6 +4267,20 @@ static void alc285_fixup_hp_coef_micmute_led(struct hda_codec *codec,
 	}
 }
 
+static void alc236_fixup_hp_coef_micmute_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mic_led_coef_idx = 0x35;
+		spec->mic_led_coefbit_mask = 3<<2;
+		spec->mic_led_coefbit_on = 2<<2;
+		spec->mic_led_coefbit_off = 1<<2;
+		snd_hda_gen_add_micmute_led(codec, alc_hp_cap_micmute_update);
+	}
+}
+
 static void alc285_fixup_hp_mute_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -4257,6 +4288,13 @@ static void alc285_fixup_hp_mute_led(struct hda_codec *codec,
 	alc285_fixup_hp_coef_micmute_led(codec, fix, action);
 }
 
+static void alc236_fixup_hp_mute_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	alc236_fixup_hp_mute_led_coefbit(codec, fix, action);
+	alc236_fixup_hp_coef_micmute_led(codec, fix, action);
+}
+
 #if IS_REACHABLE(CONFIG_INPUT)
 static void gpio2_mic_hotkey_event(struct hda_codec *codec,
 				   struct hda_jack_callback *event)
@@ -6056,6 +6094,7 @@ enum {
 	ALC294_FIXUP_ASUS_COEF_1B,
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
+	ALC236_FIXUP_HP_MUTE_LED,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7208,6 +7247,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_mute_led,
 	},
+	[ALC236_FIXUP_HP_MUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc236_fixup_hp_mute_led,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7354,6 +7397,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.25.1

