Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3BA47291E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbhLMKSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:18:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33986 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbhLMJsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:48:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E393FB80E33;
        Mon, 13 Dec 2021 09:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183A8C33A49;
        Mon, 13 Dec 2021 09:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388915;
        bh=GIW2MnZLH2+zALYn8mCDGo9Sh0rk+MKJ+k1AL3bTEr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrtuC4C1xbZ/vgk8Ub3tHZrZVcVPb2JZE1W6tbPshBsK0lG+/ZBbIgEVM+MIH0IoD
         f1yRLxDM2puk56RAiYkZKLxA4K1wZeXYnPTWyXhAd+Ymuk3a5mtPFrWxYcnwG9bCT5
         Kk2C6zKH9fXewY1aq1zuTt6Mxh9iAQZbPwe1yRBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 046/132] ALSA: hda/realtek - Add headset Mic support for Lenovo ALC897 platform
Date:   Mon, 13 Dec 2021 10:29:47 +0100
Message-Id: <20211213092940.704210997@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit d7f32791a9fcf0dae8b073cdea9b79e29098c5f4 upstream.

Lenovo ALC897 platform had headset Mic.
This patch enable supported headset Mic.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/baab2c2536cb4cc18677a862c6f6d840@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10163,6 +10163,27 @@ static void alc671_fixup_hp_headset_mic2
 	}
 }
 
+static void alc897_hp_automute_hook(struct hda_codec *codec,
+					 struct hda_jack_callback *jack)
+{
+	struct alc_spec *spec = codec->spec;
+	int vref;
+
+	snd_hda_gen_hp_automute(codec, jack);
+	vref = spec->gen.hp_jack_present ? (PIN_HP | AC_PINCTL_VREF_100) : PIN_HP;
+	snd_hda_codec_write(codec, 0x1b, 0, AC_VERB_SET_PIN_WIDGET_CONTROL,
+			    vref);
+}
+
+static void alc897_fixup_lenovo_headset_mic(struct hda_codec *codec,
+				     const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->gen.hp_automute_hook = alc897_hp_automute_hook;
+	}
+}
+
 static const struct coef_fw alc668_coefs[] = {
 	WRITE_COEF(0x01, 0xbebe), WRITE_COEF(0x02, 0xaaaa), WRITE_COEF(0x03,    0x0),
 	WRITE_COEF(0x04, 0x0180), WRITE_COEF(0x06,    0x0), WRITE_COEF(0x07, 0x0f80),
@@ -10243,6 +10264,8 @@ enum {
 	ALC668_FIXUP_ASUS_NO_HEADSET_MIC,
 	ALC668_FIXUP_HEADSET_MIC,
 	ALC668_FIXUP_MIC_DET_COEF,
+	ALC897_FIXUP_LENOVO_HEADSET_MIC,
+	ALC897_FIXUP_HEADSET_MIC_PIN,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -10649,6 +10672,19 @@ static const struct hda_fixup alc662_fix
 			{}
 		},
 	},
+	[ALC897_FIXUP_LENOVO_HEADSET_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc897_fixup_lenovo_headset_mic,
+	},
+	[ALC897_FIXUP_HEADSET_MIC_PIN] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1a, 0x03a11050 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC897_FIXUP_LENOVO_HEADSET_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -10693,6 +10729,10 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x144d, 0xc051, "Samsung R720", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x14cd, 0x5003, "USI", ALC662_FIXUP_USI_HEADSET_MODE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC662_FIXUP_LENOVO_MULTI_CODECS),
+	SND_PCI_QUIRK(0x17aa, 0x32ca, "Lenovo ThinkCentre M80", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x32cb, "Lenovo ThinkCentre M70", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x32cf, "Lenovo ThinkCentre M950", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x32f7, "Lenovo ThinkCentre M90", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo Ideapad Y550P", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x1849, 0x5892, "ASRock B150M", ALC892_FIXUP_ASROCK_MOBO),


