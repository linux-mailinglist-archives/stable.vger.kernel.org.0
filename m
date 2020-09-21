Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB8F272E46
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbgIUQrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729778AbgIUQrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED8002223E;
        Mon, 21 Sep 2020 16:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706857;
        bh=Gl6HRAeYXbzlR5aeTV0fHqv5iPvkS0jNguHbFcQ33xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9YtAG9uVxaXT4bz/y7uNonYiY10/k6yTjjDunikSn4zkFNrsPfirH9ApaiXo5Tq0
         nhWczrB9UtlTvWxarOJXPSpjAU48jKP3/NI0AhxLaIh9cjlXtJC+IuSdBLKucUfs6t
         Wn6++OwSoOgMOvaNT/r55JT0JOJScr0haeyiS/cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luke D Jones <luke@ljones.dev>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 093/118] ALSA: hda: fixup headset for ASUS GX502 laptop
Date:   Mon, 21 Sep 2020 18:28:25 +0200
Message-Id: <20200921162040.676622691@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke D Jones <luke@ljones.dev>

commit c3cdf189276c2a63da62ee250615bd55e3fb680d upstream.

The GX502 requires a few steps to enable the headset i/o: pincfg,
verbs to enable and unmute the amp used for headpone out, and
a jacksense callback to toggle output via internal or jack using
a verb.

Signed-off-by: Luke D Jones <luke@ljones.dev>
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=208005
Link: https://lore.kernel.org/r/20200907081959.56186-1-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   65 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6004,6 +6004,40 @@ static void alc_fixup_disable_mic_vref(s
 		snd_hda_codec_set_pin_target(codec, 0x19, PIN_VREFHIZ);
 }
 
+
+static void alc294_gx502_toggle_output(struct hda_codec *codec,
+					struct hda_jack_callback *cb)
+{
+	/* The Windows driver sets the codec up in a very different way where
+	 * it appears to leave 0x10 = 0x8a20 set. For Linux we need to toggle it
+	 */
+	if (snd_hda_jack_detect_state(codec, 0x21) == HDA_JACK_PRESENT)
+		alc_write_coef_idx(codec, 0x10, 0x8a20);
+	else
+		alc_write_coef_idx(codec, 0x10, 0x0a20);
+}
+
+static void alc294_fixup_gx502_hp(struct hda_codec *codec,
+					const struct hda_fixup *fix, int action)
+{
+	/* Pin 0x21: headphones/headset mic */
+	if (!is_jack_detectable(codec, 0x21))
+		return;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_jack_detect_enable_callback(codec, 0x21,
+				alc294_gx502_toggle_output);
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		/* Make sure to start in a correct state, i.e. if
+		 * headphones have been plugged in before powering up the system
+		 */
+		alc294_gx502_toggle_output(codec, NULL);
+		break;
+	}
+}
+
 static void  alc285_fixup_hp_gpio_amp_init(struct hda_codec *codec,
 			      const struct hda_fixup *fix, int action)
 {
@@ -6184,6 +6218,9 @@ enum {
 	ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	ALC294_FIXUP_ASUS_HPE,
 	ALC294_FIXUP_ASUS_COEF_1B,
+	ALC294_FIXUP_ASUS_GX502_HP,
+	ALC294_FIXUP_ASUS_GX502_PINS,
+	ALC294_FIXUP_ASUS_GX502_VERBS,
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
@@ -7349,6 +7386,33 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC294_FIXUP_ASUS_HEADSET_MIC
 	},
+	[ALC294_FIXUP_ASUS_GX502_PINS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x03a11050 }, /* front HP mic */
+			{ 0x1a, 0x01a11830 }, /* rear external mic */
+			{ 0x21, 0x03211020 }, /* front HP out */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_GX502_VERBS
+	},
+	[ALC294_FIXUP_ASUS_GX502_VERBS] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* set 0x15 to HP-OUT ctrl */
+			{ 0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, 0xc0 },
+			/* unmute the 0x15 amp */
+			{ 0x15, AC_VERB_SET_AMP_GAIN_MUTE, 0xb000 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_GX502_HP
+	},
+	[ALC294_FIXUP_ASUS_GX502_HP] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc294_fixup_gx502_hp,
+	},
 	[ALC294_FIXUP_ASUS_COEF_1B] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -7722,6 +7786,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x834a, "ASUS S101", ALC269_FIXUP_STEREO_DMIC),


