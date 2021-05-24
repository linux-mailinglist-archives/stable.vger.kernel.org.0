Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078AB38EEF8
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhEXPzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235062AbhEXPy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED3D361920;
        Mon, 24 May 2021 15:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870825;
        bh=/ZMCnfVgzjPi3wZ+cuTJLw8G9D5HUinA54l12UnUAtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khJs4c227m/zv9ecAp4IQnwxxbzk244iDPlIFJgLuxR4N3jzXiIpt6p+2by87oQ7X
         JwQa53th3AmGcEumbm+T56v8+1yQ4vpTJF7wezlw4idA0Q2PSVgBpWeV0DVNGWzRo1
         rhQkDP+6GoYRK5GEEZwXyPz+EMITEWfYNDQ7YVHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Cordova A <danesc87@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 042/104] ALSA: hda: fixup headset for ASUS GU502 laptop
Date:   Mon, 24 May 2021 17:25:37 +0200
Message-Id: <20210524152334.221335949@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Cordova A <danesc87@gmail.com>

commit c1b55029493879f5bd585ff79f326e71f0bc05e3 upstream.

The GU502 requires a few steps to make headset i/o works properly:
pincfg, verbs to unmute headphone out and callback to toggle output
between speakers and headphone using jack.

Signed-off-by: Daniel Cordova A <danesc87@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210507173116.12043-1-danesc87@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   62 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6232,6 +6232,35 @@ static void alc294_fixup_gx502_hp(struct
 	}
 }
 
+static void alc294_gu502_toggle_output(struct hda_codec *codec,
+				       struct hda_jack_callback *cb)
+{
+	/* Windows sets 0x10 to 0x8420 for Node 0x20 which is
+	 * responsible from changes between speakers and headphones
+	 */
+	if (snd_hda_jack_detect_state(codec, 0x21) == HDA_JACK_PRESENT)
+		alc_write_coef_idx(codec, 0x10, 0x8420);
+	else
+		alc_write_coef_idx(codec, 0x10, 0x0a20);
+}
+
+static void alc294_fixup_gu502_hp(struct hda_codec *codec,
+				  const struct hda_fixup *fix, int action)
+{
+	if (!is_jack_detectable(codec, 0x21))
+		return;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_jack_detect_enable_callback(codec, 0x21,
+				alc294_gu502_toggle_output);
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		alc294_gu502_toggle_output(codec, NULL);
+		break;
+	}
+}
+
 static void  alc285_fixup_hp_gpio_amp_init(struct hda_codec *codec,
 			      const struct hda_fixup *fix, int action)
 {
@@ -6449,6 +6478,9 @@ enum {
 	ALC294_FIXUP_ASUS_GX502_HP,
 	ALC294_FIXUP_ASUS_GX502_PINS,
 	ALC294_FIXUP_ASUS_GX502_VERBS,
+	ALC294_FIXUP_ASUS_GU502_HP,
+	ALC294_FIXUP_ASUS_GU502_PINS,
+	ALC294_FIXUP_ASUS_GU502_VERBS,
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_GPIO_LED,
@@ -7687,6 +7719,35 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc294_fixup_gx502_hp,
 	},
+	[ALC294_FIXUP_ASUS_GU502_PINS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a11050 }, /* rear HP mic */
+			{ 0x1a, 0x01a11830 }, /* rear external mic */
+			{ 0x21, 0x012110f0 }, /* rear HP out */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_GU502_VERBS
+	},
+	[ALC294_FIXUP_ASUS_GU502_VERBS] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* set 0x15 to HP-OUT ctrl */
+			{ 0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, 0xc0 },
+			/* unmute the 0x15 amp */
+			{ 0x15, AC_VERB_SET_AMP_GAIN_MUTE, 0xb000 },
+			/* set 0x1b to HP-OUT */
+			{ 0x1b, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_GU502_HP
+	},
+	[ALC294_FIXUP_ASUS_GU502_HP] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc294_fixup_gu502_hp,
+	},
 	[ALC294_FIXUP_ASUS_COEF_1B] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -8198,6 +8259,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
+	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),


