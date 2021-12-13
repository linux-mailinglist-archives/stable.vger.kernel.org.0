Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49484729B0
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240713AbhLMKX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241878AbhLMKTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:19:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17575C07E5E7;
        Mon, 13 Dec 2021 01:57:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3AEEB80E3B;
        Mon, 13 Dec 2021 09:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB64FC34600;
        Mon, 13 Dec 2021 09:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389445;
        bh=Mpk0L2Jd0mat7Gtm73SGhfi+/e3xMCabjM032VML5dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/oI4bcrtMuzG4ZHNXyBUPue3xnZMkfkl0NIc2M39SgYMfdcx+MsK+UkUfXKqkC7r
         SOJ+VOSBVM8rs40zjnrpaerIdxntj4uV93JS4L37Cof5Nr4AM1RGOX2QOAd4/ANQfz
         Gs1QIN6IyW5oAjo0szBdGfuqrgFPXfURYvtv1olY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 065/171] ALSA: hda/realtek - Add headset Mic support for Lenovo ALC897 platform
Date:   Mon, 13 Dec 2021 10:29:40 +0100
Message-Id: <20211213092947.267136075@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -10231,6 +10231,27 @@ static void alc671_fixup_hp_headset_mic2
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
@@ -10311,6 +10332,8 @@ enum {
 	ALC668_FIXUP_ASUS_NO_HEADSET_MIC,
 	ALC668_FIXUP_HEADSET_MIC,
 	ALC668_FIXUP_MIC_DET_COEF,
+	ALC897_FIXUP_LENOVO_HEADSET_MIC,
+	ALC897_FIXUP_HEADSET_MIC_PIN,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -10717,6 +10740,19 @@ static const struct hda_fixup alc662_fix
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
@@ -10761,6 +10797,10 @@ static const struct snd_pci_quirk alc662
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


