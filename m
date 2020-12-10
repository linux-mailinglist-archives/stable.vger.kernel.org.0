Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBA72D6273
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 17:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391120AbgLJQs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 11:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391089AbgLJOhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:37:37 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 15/75] ALSA: hda/realtek - Fixed Dell AIO wrong sound tone
Date:   Thu, 10 Dec 2020 15:26:40 +0100
Message-Id: <20201210142606.822538755@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 92666d45adcfd4a4a70580ff9f732309e16131f9 upstream.

This platform only had one audio jack.
If it plugged speaker then replug with speaker or headset, the sound
tone will change to abnormal.
Headset Mic also can't record when this issue was happen.

[ Added a short comment about the COEF by tiwai ]

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/593c777dcfef4546aa050e105b8e53b5@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -119,6 +119,7 @@ struct alc_spec {
 	unsigned int no_shutup_pins:1;
 	unsigned int ultra_low_power:1;
 	unsigned int has_hs_key:1;
+	unsigned int no_internal_mic_pin:1;
 
 	/* for PLL fix */
 	hda_nid_t pll_nid;
@@ -4524,6 +4525,7 @@ static const struct coef_fw alc225_pre_h
 
 static void alc_headset_mode_unplugged(struct hda_codec *codec)
 {
+	struct alc_spec *spec = codec->spec;
 	static const struct coef_fw coef0255[] = {
 		WRITE_COEF(0x1b, 0x0c0b), /* LDO and MISC control */
 		WRITE_COEF(0x45, 0xd089), /* UAJ function set to menual mode */
@@ -4598,6 +4600,11 @@ static void alc_headset_mode_unplugged(s
 		{}
 	};
 
+	if (spec->no_internal_mic_pin) {
+		alc_update_coef_idx(codec, 0x45, 0xf<<12 | 1<<10, 5<<12);
+		return;
+	}
+
 	switch (codec->core.vendor_id) {
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
@@ -5164,6 +5171,11 @@ static void alc_determine_headset_type(s
 		{}
 	};
 
+	if (spec->no_internal_mic_pin) {
+		alc_update_coef_idx(codec, 0x45, 0xf<<12 | 1<<10, 5<<12);
+		return;
+	}
+
 	switch (codec->core.vendor_id) {
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
@@ -6137,6 +6149,23 @@ static void alc274_fixup_hp_headset_mic(
 	}
 }
 
+static void alc_fixup_no_int_mic(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		/* Mic RING SLEEVE swap for combo jack */
+		alc_update_coef_idx(codec, 0x45, 0xf<<12 | 1<<10, 5<<12);
+		spec->no_internal_mic_pin = true;
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		alc_combo_jack_hp_jd_restart(codec);
+		break;
+	}
+}
+
 /* for hda_fixup_thinkpad_acpi() */
 #include "thinkpad_helper.c"
 
@@ -6336,6 +6365,7 @@ enum {
 	ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
 	ALC287_FIXUP_HP_GPIO_LED,
 	ALC256_FIXUP_HP_HEADSET_MIC,
+	ALC236_FIXUP_DELL_AIO_HEADSET_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7753,6 +7783,12 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc274_fixup_hp_headset_mic,
 	},
+	[ALC236_FIXUP_DELL_AIO_HEADSET_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_no_int_mic,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7830,6 +7866,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x097d, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x098d, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
@@ -8369,6 +8407,8 @@ static const struct snd_hda_pin_quirk al
 		{0x19, 0x02a11020},
 		{0x1a, 0x02a11030},
 		{0x21, 0x0221101f}),
+	SND_HDA_PIN_QUIRK(0x10ec0236, 0x1028, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC,
+		{0x21, 0x02211010}),
 	SND_HDA_PIN_QUIRK(0x10ec0236, 0x103c, "HP", ALC256_FIXUP_HP_HEADSET_MIC,
 		{0x14, 0x90170110},
 		{0x19, 0x02a11020},


