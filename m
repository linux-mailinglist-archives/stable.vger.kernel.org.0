Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC98BAACA
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbfIVTbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391962AbfIVStD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:49:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE2F121D71;
        Sun, 22 Sep 2019 18:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178142;
        bh=+hscBSSiceQUDY9+VOYTuW47bvxKdbmKQzrUpDh6YtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/it5WjnLOwm+MJZIRh0D/h67FS36mVvEgxmn4f4C47bk3ojwWqykZbMm2Y/IvzwM
         2EZlatYg3w/s4M7vq5nC0hnWqNcn6WX42/L1QtcjwO8Rgzf/ESKV7LndsUtoo30dce
         vm60yRn73eECxGvatNdSouqhpMaNJkPyqw80haXY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Espeleta <tomas.espeleta@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 191/203] ALSA: hda - Add a quirk model for fixing Huawei Matebook X right speaker
Date:   Sun, 22 Sep 2019 14:43:37 -0400
Message-Id: <20190922184350.30563-191-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Espeleta <tomas.espeleta@gmail.com>

[ Upstream commit a2ef03fe617a8365fb7794531b11ba587509a9b9 ]

[ This is rather a revival of the patch Tomas sent in months ago, but
  applying only with the quirk model option -- tiwai ]

Hard coded coefficients to make Huawuei Matebook X right speaker
work. The Matebook X has a ALC298, please refer to bug 197801 on
how these numbers were reverse engineered from the Windows driver

The reversed engineered sequence represents a repeating pattern
of verbs, and the only values that are changing periodically are
written on indexes 0x23 and 0x25:

0x500, 0x23
0x400, VALUE1
0x500, 0x25
0x400, VALUE2

* skipped reading sequences (0x500 - 0xc00 sequences are ignored)
* static values from reverse engineering are used

NOTE: since a significant risk is still considered, this is provided
as an experimental fix that isn't applied as default for now.  For
enabling the fix, you'll have to choose huawei-mbx-stereo via model
option of snd-hda-intel module.

If we get feedback from users that this works stably, we may apply it
per default.

[ Some coding style fixes and replacement with AC_VERB_* by tiwai ]

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=197801
Signed-off-by: Tomas Espeleta <tomas.espeleta@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/sound/hd-audio/models.rst |  3 +
 sound/pci/hda/patch_realtek.c           | 74 +++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

diff --git a/Documentation/sound/hd-audio/models.rst b/Documentation/sound/hd-audio/models.rst
index 7d7c191102a73..11298f0ce44db 100644
--- a/Documentation/sound/hd-audio/models.rst
+++ b/Documentation/sound/hd-audio/models.rst
@@ -260,6 +260,9 @@ alc295-hp-x360
     HP Spectre X360 fixups
 alc-sense-combo
     Headset button support for Chrome platform
+huawei-mbx-stereo
+    Enable initialization verbs for Huawei MBX stereo speakers;
+    might be risky, try this at your own risk
 
 ALC66x/67x/892
 ==============
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c1ddfd2fac522..1bec62720374d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3755,6 +3755,72 @@ static void alc269_x101_hp_automute_hook(struct hda_codec *codec,
 			    vref);
 }
 
+/*
+ * Magic sequence to make Huawei Matebook X right speaker working (bko#197801)
+ */
+struct hda_alc298_mbxinit {
+	unsigned char value_0x23;
+	unsigned char value_0x25;
+};
+
+static void alc298_huawei_mbx_stereo_seq(struct hda_codec *codec,
+					 const struct hda_alc298_mbxinit *initval,
+					 bool first)
+{
+	snd_hda_codec_write(codec, 0x06, 0, AC_VERB_SET_DIGI_CONVERT_3, 0x0);
+	alc_write_coef_idx(codec, 0x26, 0xb000);
+
+	if (first)
+		snd_hda_codec_write(codec, 0x21, 0, AC_VERB_GET_PIN_SENSE, 0x0);
+
+	snd_hda_codec_write(codec, 0x6, 0, AC_VERB_SET_DIGI_CONVERT_3, 0x80);
+	alc_write_coef_idx(codec, 0x26, 0xf000);
+	alc_write_coef_idx(codec, 0x23, initval->value_0x23);
+
+	if (initval->value_0x23 != 0x1e)
+		alc_write_coef_idx(codec, 0x25, initval->value_0x25);
+
+	snd_hda_codec_write(codec, 0x20, 0, AC_VERB_SET_COEF_INDEX, 0x26);
+	snd_hda_codec_write(codec, 0x20, 0, AC_VERB_SET_PROC_COEF, 0xb010);
+}
+
+static void alc298_fixup_huawei_mbx_stereo(struct hda_codec *codec,
+					   const struct hda_fixup *fix,
+					   int action)
+{
+	/* Initialization magic */
+	static const struct hda_alc298_mbxinit dac_init[] = {
+		{0x0c, 0x00}, {0x0d, 0x00}, {0x0e, 0x00}, {0x0f, 0x00},
+		{0x10, 0x00}, {0x1a, 0x40}, {0x1b, 0x82}, {0x1c, 0x00},
+		{0x1d, 0x00}, {0x1e, 0x00}, {0x1f, 0x00},
+		{0x20, 0xc2}, {0x21, 0xc8}, {0x22, 0x26}, {0x23, 0x24},
+		{0x27, 0xff}, {0x28, 0xff}, {0x29, 0xff}, {0x2a, 0x8f},
+		{0x2b, 0x02}, {0x2c, 0x48}, {0x2d, 0x34}, {0x2e, 0x00},
+		{0x2f, 0x00},
+		{0x30, 0x00}, {0x31, 0x00}, {0x32, 0x00}, {0x33, 0x00},
+		{0x34, 0x00}, {0x35, 0x01}, {0x36, 0x93}, {0x37, 0x0c},
+		{0x38, 0x00}, {0x39, 0x00}, {0x3a, 0xf8}, {0x38, 0x80},
+		{}
+	};
+	const struct hda_alc298_mbxinit *seq;
+
+	if (action != HDA_FIXUP_ACT_INIT)
+		return;
+
+	/* Start */
+	snd_hda_codec_write(codec, 0x06, 0, AC_VERB_SET_DIGI_CONVERT_3, 0x00);
+	snd_hda_codec_write(codec, 0x06, 0, AC_VERB_SET_DIGI_CONVERT_3, 0x80);
+	alc_write_coef_idx(codec, 0x26, 0xf000);
+	alc_write_coef_idx(codec, 0x22, 0x31);
+	alc_write_coef_idx(codec, 0x23, 0x0b);
+	alc_write_coef_idx(codec, 0x25, 0x00);
+	snd_hda_codec_write(codec, 0x20, 0, AC_VERB_SET_COEF_INDEX, 0x26);
+	snd_hda_codec_write(codec, 0x20, 0, AC_VERB_SET_PROC_COEF, 0xb010);
+
+	for (seq = dac_init; seq->value_0x23; seq++)
+		alc298_huawei_mbx_stereo_seq(codec, seq, seq == dac_init);
+}
+
 static void alc269_fixup_x101_headset_mic(struct hda_codec *codec,
 				     const struct hda_fixup *fix, int action)
 {
@@ -5780,6 +5846,7 @@ enum {
 	ALC255_FIXUP_DUMMY_LINEOUT_VERB,
 	ALC255_FIXUP_DELL_HEADSET_MIC,
 	ALC256_FIXUP_HUAWEI_MACH_WX9_PINS,
+	ALC298_FIXUP_HUAWEI_MBX_STEREO,
 	ALC295_FIXUP_HP_X360,
 	ALC221_FIXUP_HP_HEADSET_MIC,
 	ALC285_FIXUP_LENOVO_HEADPHONE_NOISE,
@@ -6089,6 +6156,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC255_FIXUP_MIC_MUTE_LED
 	},
+	[ALC298_FIXUP_HUAWEI_MBX_STEREO] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc298_fixup_huawei_mbx_stereo,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_MIC_MUTE_LED
+	},
 	[ALC269_FIXUP_ASUS_X101_FUNC] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc269_fixup_x101_headset_mic,
@@ -7280,6 +7353,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC225_FIXUP_HEADSET_JACK, .name = "alc-headset-jack"},
 	{.id = ALC295_FIXUP_CHROME_BOOK, .name = "alc-chrome-book"},
 	{.id = ALC299_FIXUP_PREDATOR_SPK, .name = "predator-spk"},
+	{.id = ALC298_FIXUP_HUAWEI_MBX_STEREO, .name = "huawei-mbx-stereo"},
 	{}
 };
 #define ALC225_STANDARD_PINS \
-- 
2.20.1

