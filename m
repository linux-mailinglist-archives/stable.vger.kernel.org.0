Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707842408ED
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgHJP1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:32794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728701AbgHJP07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:26:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6C0822B47;
        Mon, 10 Aug 2020 15:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073218;
        bh=/Bn6PmnlKqz6fZ++BKTLEodC16sbAxC+FRVA/URJ4H8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKGB4TYrGCvFXdNQZDqyvVVFr2gilFrLcY+PzO2hDMVb6rFn+MzSiLX5A2fVM3uDj
         LHsrQpqk/jZaka3h1+HSVjH/PjhY1nxSGJKq8Yt8LlSyDkszwP6ONjI4IreKTU4FcP
         iOwEzoYI8pF7dndw6MZJYhrqhkRzyT0t7qrSavDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 09/67] ALSA: hda/realtek: Add alc269/alc662 pin-tables for Loongson-3 laptops
Date:   Mon, 10 Aug 2020 17:20:56 +0200
Message-Id: <20200810151809.887748087@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit f1ec5be17b9aafbc5f573da023850566b43d8e5e upstream.

There are several Loongson-3 based laptops produced by CZC or Lemote,
they use alc269/alc662 codecs and need specific pin-tables, this patch
add their pin-tables.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1596360400-32425-1-git-send-email-chenhc@lemote.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |  114 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6131,6 +6131,11 @@ enum {
 	ALC289_FIXUP_ASUS_GA502,
 	ALC256_FIXUP_ACER_MIC_NO_PRESENCE,
 	ALC285_FIXUP_HP_GPIO_AMP_INIT,
+	ALC269_FIXUP_CZC_B20,
+	ALC269_FIXUP_CZC_TMI,
+	ALC269_FIXUP_CZC_L101,
+	ALC269_FIXUP_LEMOTE_A1802,
+	ALC269_FIXUP_LEMOTE_A190X,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7369,6 +7374,89 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_GPIO_LED
 	},
+	[ALC269_FIXUP_CZC_B20] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x12, 0x411111f0 },
+			{ 0x14, 0x90170110 }, /* speaker */
+			{ 0x15, 0x032f1020 }, /* HP out */
+			{ 0x17, 0x411111f0 },
+			{ 0x18, 0x03ab1040 }, /* mic */
+			{ 0x19, 0xb7a7013f },
+			{ 0x1a, 0x0181305f },
+			{ 0x1b, 0x411111f0 },
+			{ 0x1d, 0x411111f0 },
+			{ 0x1e, 0x411111f0 },
+			{ }
+		},
+		.chain_id = ALC269_FIXUP_DMIC,
+	},
+	[ALC269_FIXUP_CZC_TMI] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x12, 0x4000c000 },
+			{ 0x14, 0x90170110 }, /* speaker */
+			{ 0x15, 0x0421401f }, /* HP out */
+			{ 0x17, 0x411111f0 },
+			{ 0x18, 0x04a19020 }, /* mic */
+			{ 0x19, 0x411111f0 },
+			{ 0x1a, 0x411111f0 },
+			{ 0x1b, 0x411111f0 },
+			{ 0x1d, 0x40448505 },
+			{ 0x1e, 0x411111f0 },
+			{ 0x20, 0x8000ffff },
+			{ }
+		},
+		.chain_id = ALC269_FIXUP_DMIC,
+	},
+	[ALC269_FIXUP_CZC_L101] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x12, 0x40000000 },
+			{ 0x14, 0x01014010 }, /* speaker */
+			{ 0x15, 0x411111f0 }, /* HP out */
+			{ 0x16, 0x411111f0 },
+			{ 0x18, 0x01a19020 }, /* mic */
+			{ 0x19, 0x02a19021 },
+			{ 0x1a, 0x0181302f },
+			{ 0x1b, 0x0221401f },
+			{ 0x1c, 0x411111f0 },
+			{ 0x1d, 0x4044c601 },
+			{ 0x1e, 0x411111f0 },
+			{ }
+		},
+		.chain_id = ALC269_FIXUP_DMIC,
+	},
+	[ALC269_FIXUP_LEMOTE_A1802] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x12, 0x40000000 },
+			{ 0x14, 0x90170110 }, /* speaker */
+			{ 0x17, 0x411111f0 },
+			{ 0x18, 0x03a19040 }, /* mic1 */
+			{ 0x19, 0x90a70130 }, /* mic2 */
+			{ 0x1a, 0x411111f0 },
+			{ 0x1b, 0x411111f0 },
+			{ 0x1d, 0x40489d2d },
+			{ 0x1e, 0x411111f0 },
+			{ 0x20, 0x0003ffff },
+			{ 0x21, 0x03214020 },
+			{ }
+		},
+		.chain_id = ALC269_FIXUP_DMIC,
+	},
+	[ALC269_FIXUP_LEMOTE_A190X] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x99130110 }, /* speaker */
+			{ 0x15, 0x0121401f }, /* HP out */
+			{ 0x18, 0x01a19c20 }, /* rear  mic */
+			{ 0x19, 0x99a3092f }, /* front mic */
+			{ 0x1b, 0x0201401f }, /* front lineout */
+			{ }
+		},
+		.chain_id = ALC269_FIXUP_DMIC,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7658,9 +7746,14 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3bf8, "Quanta FL1", ALC269_FIXUP_PCM_44K),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
+	SND_PCI_QUIRK(0x1b35, 0x1235, "CZC B20", ALC269_FIXUP_CZC_B20),
+	SND_PCI_QUIRK(0x1b35, 0x1236, "CZC TMI", ALC269_FIXUP_CZC_TMI),
+	SND_PCI_QUIRK(0x1b35, 0x1237, "CZC L101", ALC269_FIXUP_CZC_L101),
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
+	SND_PCI_QUIRK(0x1c06, 0x2015, "Lemote A190X", ALC269_FIXUP_LEMOTE_A190X),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
@@ -8945,6 +9038,7 @@ enum {
 	ALC662_FIXUP_LED_GPIO1,
 	ALC662_FIXUP_IDEAPAD,
 	ALC272_FIXUP_MARIO,
+	ALC662_FIXUP_CZC_ET26,
 	ALC662_FIXUP_CZC_P10T,
 	ALC662_FIXUP_SKU_IGNORE,
 	ALC662_FIXUP_HP_RP5800,
@@ -9014,6 +9108,25 @@ static const struct hda_fixup alc662_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc272_fixup_mario,
 	},
+	[ALC662_FIXUP_CZC_ET26] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{0x12, 0x403cc000},
+			{0x14, 0x90170110}, /* speaker */
+			{0x15, 0x411111f0},
+			{0x16, 0x411111f0},
+			{0x18, 0x01a19030}, /* mic */
+			{0x19, 0x90a7013f}, /* int-mic */
+			{0x1a, 0x01014020},
+			{0x1b, 0x0121401f},
+			{0x1c, 0x411111f0},
+			{0x1d, 0x411111f0},
+			{0x1e, 0x40478e35},
+			{}
+		},
+		.chained = true,
+		.chain_id = ALC662_FIXUP_SKU_IGNORE
+	},
 	[ALC662_FIXUP_CZC_P10T] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -9397,6 +9510,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x1849, 0x5892, "ASRock B150M", ALC892_FIXUP_ASROCK_MOBO),
 	SND_PCI_QUIRK(0x19da, 0xa130, "Zotac Z68", ALC662_FIXUP_ZOTAC_Z68),
 	SND_PCI_QUIRK(0x1b0a, 0x01b8, "ACER Veriton", ALC662_FIXUP_ACER_VERITON),
+	SND_PCI_QUIRK(0x1b35, 0x1234, "CZC ET26", ALC662_FIXUP_CZC_ET26),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
 	SND_PCI_QUIRK(0x1025, 0x0566, "Acer Aspire Ethos 8951G", ALC669_FIXUP_ACER_ASPIRE_ETHOS),
 


