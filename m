Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BA135BF12
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239311AbhDLJCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239661AbhDLJBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 857F06109E;
        Mon, 12 Apr 2021 08:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217939;
        bh=KlUO86UgRtw8RETjslRUA5iYnhGZInMrMPV00Q1wacc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYe/MSKj1ipWtyNPgYhRUshLKN0itFQj3PKjYC5k5O2WN36Fy/1vP2V3BzT+CsY9p
         OT07KtDZOI2segx8ufXD/TcE9n5xfqsmWeQQHbJMx02fLd20FD47hNpI1PQkpbalZW
         5TP3cArou1jDJLgKH83wYddtaKqcLTqCsDTzz2M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 003/210] ALSA: hda/realtek: Fix speaker amp setup on Acer Aspire E1
Date:   Mon, 12 Apr 2021 10:38:28 +0200
Message-Id: <20210412084016.120512158@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit c8426b2700b57d2760ff335840a02f66a64b6044 upstream.

We've got a report about Acer Aspire E1 (PCI SSID 1025:0840) that
loses the speaker output after resume.  With the comparison of COEF
dumps, it was identified that the COEF 0x0d bits 0x6000 corresponds to
the speaker amp.

This patch adds the specific quirk for the device to restore the COEF
bits at the codec (re-)initialization.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1183869
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210407095730.12560-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3927,6 +3927,15 @@ static void alc271_fixup_dmic(struct hda
 		snd_hda_sequence_write(codec, verbs);
 }
 
+/* Fix the speaker amp after resume, etc */
+static void alc269vb_fixup_aspire_e1_coef(struct hda_codec *codec,
+					  const struct hda_fixup *fix,
+					  int action)
+{
+	if (action == HDA_FIXUP_ACT_INIT)
+		alc_update_coef_idx(codec, 0x0d, 0x6000, 0x6000);
+}
+
 static void alc269_fixup_pcm_44k(struct hda_codec *codec,
 				 const struct hda_fixup *fix, int action)
 {
@@ -6301,6 +6310,7 @@ enum {
 	ALC283_FIXUP_HEADSET_MIC,
 	ALC255_FIXUP_MIC_MUTE_LED,
 	ALC282_FIXUP_ASPIRE_V5_PINS,
+	ALC269VB_FIXUP_ASPIRE_E1_COEF,
 	ALC280_FIXUP_HP_GPIO4,
 	ALC286_FIXUP_HP_GPIO_LED,
 	ALC280_FIXUP_HP_GPIO2_MIC_HOTKEY,
@@ -6979,6 +6989,10 @@ static const struct hda_fixup alc269_fix
 			{ },
 		},
 	},
+	[ALC269VB_FIXUP_ASPIRE_E1_COEF] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269vb_fixup_aspire_e1_coef,
+	},
 	[ALC280_FIXUP_HP_GPIO4] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc280_fixup_hp_gpio4,
@@ -7901,6 +7915,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x0762, "Acer Aspire E1-472", ALC271_FIXUP_HP_GATE_MIC_JACK_E1_572),
 	SND_PCI_QUIRK(0x1025, 0x0775, "Acer Aspire E1-572", ALC271_FIXUP_HP_GATE_MIC_JACK_E1_572),
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
+	SND_PCI_QUIRK(0x1025, 0x0840, "Acer Aspire E1", ALC269VB_FIXUP_ASPIRE_E1_COEF),
 	SND_PCI_QUIRK(0x1025, 0x101c, "Acer Veriton N2510G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1065, "Acer Aspire C20-820", ALC269VC_FIXUP_ACER_HEADSET_MIC),
@@ -8395,6 +8410,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC283_FIXUP_HEADSET_MIC, .name = "alc283-headset"},
 	{.id = ALC255_FIXUP_MIC_MUTE_LED, .name = "alc255-dell-mute"},
 	{.id = ALC282_FIXUP_ASPIRE_V5_PINS, .name = "aspire-v5"},
+	{.id = ALC269VB_FIXUP_ASPIRE_E1_COEF, .name = "aspire-e1-coef"},
 	{.id = ALC280_FIXUP_HP_GPIO4, .name = "hp-gpio4"},
 	{.id = ALC286_FIXUP_HP_GPIO_LED, .name = "hp-gpio-led"},
 	{.id = ALC280_FIXUP_HP_GPIO2_MIC_HOTKEY, .name = "hp-gpio2-hotkey"},


