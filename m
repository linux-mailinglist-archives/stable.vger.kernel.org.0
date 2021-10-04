Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53A5420E2A
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbhJDNWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236514AbhJDNUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEF4461B4B;
        Mon,  4 Oct 2021 13:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352926;
        bh=nuWzNCjTEYpgx713GZuskKpLchZj/GwMe7OGQuAlFiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ei3upfOnHYqdrnWX+BtalrNPohy02MkbLoVHKXX5WwdIyrlb2hKXY+27RBK6skbuq
         cCAt0OV72QwLi/PFapnd/RdNrpQyAgut2zaF/3ezy1QcmDAvqIq48n0nstlMSQm2Z9
         E+aPHj/I90CymH9YzKSgijBxvX1u5X795ljzzZRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cameron Berkenpas <cam@neo-zeon.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 06/93] ALSA: hda/realtek: Quirks to enable speaker output for Lenovo Legion 7i 15IMHG05, Yoga 7i 14ITL5/15ITL5, and 13s Gen2 laptops.
Date:   Mon,  4 Oct 2021 14:52:04 +0200
Message-Id: <20211004125034.793792354@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cameron Berkenpas <cam@neo-zeon.de>

commit ad7cc2d41b7a8d0c5c5ecff37c3de7a4e137b3a6 upstream.

This patch initializes and enables speaker output on the Lenovo Legion 7i
15IMHG05, Yoga 7i 14ITL5/15ITL5, and 13s Gen2 series of laptops using the
HDA verb sequence specific to each model.

Speaker automute is suppressed for the Lenovo Legion 7i 15IMHG05 to avoid
breaking speaker output on resume and when devices are unplugged from its
headphone jack.

Thanks to: Andreas Holzer, Vincent Morel, sycxyc, Max Christian Pohle and
all others that helped.

[ minor coding style fixes by tiwai ]

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208555
Signed-off-by: Cameron Berkenpas <cam@neo-zeon.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210913212627.339362-1-cam@neo-zeon.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |  129 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6375,6 +6375,20 @@ static void alc_fixup_thinkpad_acpi(stru
 	hda_fixup_thinkpad_acpi(codec, fix, action);
 }
 
+/* Fixup for Lenovo Legion 15IMHg05 speaker output on headset removal. */
+static void alc287_fixup_legion_15imhg05_speakers(struct hda_codec *codec,
+						  const struct hda_fixup *fix,
+						  int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		spec->gen.suppress_auto_mute = 1;
+		break;
+	}
+}
+
 /* for alc295_fixup_hp_top_speakers */
 #include "hp_x360_helper.c"
 
@@ -6591,6 +6605,10 @@ enum {
 	ALC623_FIXUP_LENOVO_THINKSTATION_P340,
 	ALC255_FIXUP_ACER_HEADPHONE_AND_MIC,
 	ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST,
+	ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS,
+	ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
+	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
+	ALC287_FIXUP_13S_GEN2_SPEAKERS
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8175,6 +8193,113 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
 	},
+	[ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS] = {
+		.type = HDA_FIXUP_VERBS,
+		//.v.verbs = legion_15imhg05_coefs,
+		.v.verbs = (const struct hda_verb[]) {
+			 // set left speaker Legion 7i.
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x1a },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 // set right speaker Legion 7i.
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x42 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2a },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			 {}
+		},
+		.chained = true,
+		.chain_id = ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
+	},
+	[ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_legion_15imhg05_speakers,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE,
+	},
+	[ALC287_FIXUP_YOGA7_14ITL_SPEAKERS] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			 // set left speaker Yoga 7i.
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x1a },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 // set right speaker Yoga 7i.
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x46 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2a },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			 {}
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE,
+	},
+	[ALC287_FIXUP_13S_GEN2_SPEAKERS] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x42 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+			{}
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8567,6 +8692,10 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
+	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),


