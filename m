Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62622AB9C1
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732592AbgKINMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731430AbgKINMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:12:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEC3320789;
        Mon,  9 Nov 2020 13:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927542;
        bh=yH0Ln7klgevXYEIFK4X6benkWApUacy5d0xnSHkD6o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qnDaSk+sqDq29Ry2i8C8f5EUy0cRUmNmh7xE6alodpwumHys809MpvvIiTXqPaJ7g
         LjQkEm/+YOgO9shPrt1YzFihyh8vIGoNpAgq+6x63/qLI5ZSttsOr2NGvoJ5rLRQ6U
         AwDB7xim4boxam9DE6XRwnxo9hxPbEhgMgztYu8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 23/85] ALSA: hda/realtek - Fixed HP headset Mic cant be detected
Date:   Mon,  9 Nov 2020 13:55:20 +0100
Message-Id: <20201109125023.695245588@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 8a8de09cb2adc119104f35044d1a840dd47aa9d8 upstream.

System boot with plugged headset. It will not detect headset Mic.
It will happen on cold boot restart resume state.
Quirk by SSID change to quirk by pin verb.

Fixes: 13468bfa8c58 ("ALSA: hda/realtek - set mic to auto detect on a HP AIO machine")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/f42ae1ede1cf47029ae2bef1a42caf03@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   54 +++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 11 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5990,6 +5990,27 @@ static void alc285_fixup_invalidate_dacs
 	snd_hda_override_wcaps(codec, 0x03, 0);
 }
 
+static void alc_combo_jack_hp_jd_restart(struct hda_codec *codec)
+{
+	switch (codec->core.vendor_id) {
+	case 0x10ec0274:
+	case 0x10ec0294:
+	case 0x10ec0225:
+	case 0x10ec0295:
+	case 0x10ec0299:
+		alc_update_coef_idx(codec, 0x4a, 0x8000, 1 << 15); /* Reset HP JD */
+		alc_update_coef_idx(codec, 0x4a, 0x8000, 0 << 15);
+		break;
+	case 0x10ec0235:
+	case 0x10ec0236:
+	case 0x10ec0255:
+	case 0x10ec0256:
+		alc_update_coef_idx(codec, 0x1b, 0x8000, 1 << 15); /* Reset HP JD */
+		alc_update_coef_idx(codec, 0x1b, 0x8000, 0 << 15);
+		break;
+	}
+}
+
 static void alc295_fixup_chromebook(struct hda_codec *codec,
 				    const struct hda_fixup *fix, int action)
 {
@@ -6000,16 +6021,7 @@ static void alc295_fixup_chromebook(stru
 		spec->ultra_low_power = true;
 		break;
 	case HDA_FIXUP_ACT_INIT:
-		switch (codec->core.vendor_id) {
-		case 0x10ec0295:
-			alc_update_coef_idx(codec, 0x4a, 0x8000, 1 << 15); /* Reset HP JD */
-			alc_update_coef_idx(codec, 0x4a, 0x8000, 0 << 15);
-			break;
-		case 0x10ec0236:
-			alc_update_coef_idx(codec, 0x1b, 0x8000, 1 << 15); /* Reset HP JD */
-			alc_update_coef_idx(codec, 0x1b, 0x8000, 0 << 15);
-			break;
-		}
+		alc_combo_jack_hp_jd_restart(codec);
 		break;
 	}
 }
@@ -6065,6 +6077,16 @@ static void  alc285_fixup_hp_gpio_amp_in
 	alc_write_coef_idx(codec, 0x65, 0x0);
 }
 
+static void alc274_fixup_hp_headset_mic(struct hda_codec *codec,
+				    const struct hda_fixup *fix, int action)
+{
+	switch (action) {
+	case HDA_FIXUP_ACT_INIT:
+		alc_combo_jack_hp_jd_restart(codec);
+		break;
+	}
+}
+
 /* for hda_fixup_thinkpad_acpi() */
 #include "thinkpad_helper.c"
 
@@ -6259,6 +6281,7 @@ enum {
 	ALC256_FIXUP_INTEL_NUC8_RUGGED,
 	ALC255_FIXUP_XIAOMI_HEADSET_MIC,
 	ALC274_FIXUP_HP_MIC,
+	ALC274_FIXUP_HP_HEADSET_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7646,6 +7669,12 @@ static const struct hda_fixup alc269_fix
 			{ }
 		},
 	},
+	[ALC274_FIXUP_HP_HEADSET_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc274_fixup_hp_headset_mic,
+		.chained = true,
+		.chain_id = ALC274_FIXUP_HP_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7797,7 +7826,6 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
-	SND_PCI_QUIRK(0x103c, 0x874e, "HP", ALC274_FIXUP_HP_MIC),
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
@@ -8353,6 +8381,10 @@ static const struct snd_hda_pin_quirk al
 		{0x1a, 0x90a70130},
 		{0x1b, 0x90170110},
 		{0x21, 0x03211020}),
+       SND_HDA_PIN_QUIRK(0x10ec0274, 0x103c, "HP", ALC274_FIXUP_HP_HEADSET_MIC,
+		{0x17, 0x90170110},
+		{0x19, 0x03a11030},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0280, 0x103c, "HP", ALC280_FIXUP_HP_GPIO4,
 		{0x12, 0x90a60130},
 		{0x14, 0x90170110},


