Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312B929C561
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1824763AbgJ0SFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900926AbgJ0ORo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:17:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B4BA206FA;
        Tue, 27 Oct 2020 14:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808263;
        bh=rAvq0Zyk5uPLyzBFxTose0j+nEKTFbcBX230Mo0KuOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aw0ZhFQ44JHO8nuwWExLXVF3eCoodIx4/pgTKJEGr8hsMxBJYSYpVv4irMakxGs83
         22uqKEFIgOyNH+LOvchq9tOmdEES4FBwdbgOZHrUOkHd+BnOOpiA77L2Zso6EtsqZQ
         1mmwDp4Psx7YxZpPIzPgN0E4gVY8fJbAp1FGHxpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian-Hong Pan <jhp@endlessos.org>,
        Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 026/264] ALSA: hda/realtek: Enable audio jacks of ASUS D700SA with ALC887
Date:   Tue, 27 Oct 2020 14:51:24 +0100
Message-Id: <20201027135431.883991249@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian-Hong Pan <jhp@endlessos.org>

commit ca184355db8e60290fa34bf61c13308e6f4f50d3 upstream.

The ASUS D700SA desktop's audio (1043:2390) with ALC887 cannot detect
the headset microphone and another headphone jack until
ALC887_FIXUP_ASUS_HMIC and ALC887_FIXUP_ASUS_AUDIO quirks are applied.
The NID 0x15 maps as the headset microphone and NID 0x19 maps as another
headphone jack. Also need the function like alc887_fixup_asus_jack to
enable the audio jacks.

Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201007052224.22611-1-jhp@endlessos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1906,6 +1906,8 @@ enum {
 	ALC1220_FIXUP_CLEVO_P950,
 	ALC1220_FIXUP_CLEVO_PB51ED,
 	ALC1220_FIXUP_CLEVO_PB51ED_PINS,
+	ALC887_FIXUP_ASUS_AUDIO,
+	ALC887_FIXUP_ASUS_HMIC,
 };
 
 static void alc889_fixup_coef(struct hda_codec *codec,
@@ -2118,6 +2120,31 @@ static void alc1220_fixup_clevo_pb51ed(s
 	alc_fixup_headset_mode_no_hp_mic(codec, fix, action);
 }
 
+static void alc887_asus_hp_automute_hook(struct hda_codec *codec,
+					 struct hda_jack_callback *jack)
+{
+	struct alc_spec *spec = codec->spec;
+	unsigned int vref;
+
+	snd_hda_gen_hp_automute(codec, jack);
+
+	if (spec->gen.hp_jack_present)
+		vref = AC_PINCTL_VREF_80;
+	else
+		vref = AC_PINCTL_VREF_HIZ;
+	snd_hda_set_pin_ctl(codec, 0x19, PIN_HP | vref);
+}
+
+static void alc887_fixup_asus_jack(struct hda_codec *codec,
+				     const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+	if (action != HDA_FIXUP_ACT_PROBE)
+		return;
+	snd_hda_set_pin_ctl_cache(codec, 0x1b, PIN_HP);
+	spec->gen.hp_automute_hook = alc887_asus_hp_automute_hook;
+}
+
 static const struct hda_fixup alc882_fixups[] = {
 	[ALC882_FIXUP_ABIT_AW9D_MAX] = {
 		.type = HDA_FIXUP_PINS,
@@ -2375,6 +2402,20 @@ static const struct hda_fixup alc882_fix
 		.chained = true,
 		.chain_id = ALC1220_FIXUP_CLEVO_PB51ED,
 	},
+	[ALC887_FIXUP_ASUS_AUDIO] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x15, 0x02a14150 }, /* use as headset mic, without its own jack detect */
+			{ 0x19, 0x22219420 },
+			{}
+		},
+	},
+	[ALC887_FIXUP_ASUS_HMIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc887_fixup_asus_jack,
+		.chained = true,
+		.chain_id = ALC887_FIXUP_ASUS_AUDIO,
+	},
 };
 
 static const struct snd_pci_quirk alc882_fixup_tbl[] = {
@@ -2408,6 +2449,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x1043, 0x13c2, "Asus A7M", ALC882_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1043, 0x1873, "ASUS W90V", ALC882_FIXUP_ASUS_W90V),
 	SND_PCI_QUIRK(0x1043, 0x1971, "Asus W2JC", ALC882_FIXUP_ASUS_W2JC),
+	SND_PCI_QUIRK(0x1043, 0x2390, "Asus D700SA", ALC887_FIXUP_ASUS_HMIC),
 	SND_PCI_QUIRK(0x1043, 0x835f, "Asus Eee 1601", ALC888_FIXUP_EEE1601),
 	SND_PCI_QUIRK(0x1043, 0x84bc, "ASUS ET2700", ALC887_FIXUP_ASUS_BASS),
 	SND_PCI_QUIRK(0x1043, 0x8691, "ASUS ROG Ranger VIII", ALC882_FIXUP_GPIO3),


