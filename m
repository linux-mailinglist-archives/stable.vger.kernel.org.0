Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFADD38EE6A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhEXPuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234461AbhEXPrP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:47:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C2DA61415;
        Mon, 24 May 2021 15:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870625;
        bh=il5dChJjhFtRvXPyUfOQ5OG42G5UnANpeqwOXJFXj4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5v+U6LT51cyMe1FoBgqWlhA1UuVyLnz5floJKYQpJbur3JA2EXb575Tyd38yePDq
         PfOHzc4y7jS1Y8yHSUZJl3UsKNGw6D4aEAedWvlH2oDBhAycs12DbNq1ENmNpZpjs6
         5dvYUG2xSehQ14xXXBBoF+nQgwhpvsxTXRfp5tBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Elia Devito <eliadevito@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 32/71] ALSA: hda/realtek: Add fixup for HP Spectre x360 15-df0xxx
Date:   Mon, 24 May 2021 17:25:38 +0200
Message-Id: <20210524152327.506934903@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elia Devito <eliadevito@gmail.com>

commit f2be77fee648ddd6d0d259d3527344ba0120e314 upstream.

Fixup to enable all 4 speaker on HP Spectre x360 15-df0xxx and probably
on similar models.

0x14 pin config override is required to enable all speakers and
alc285-speaker2-to-dac1 fixup to enable volume adjustment.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=189331
Signed-off-by: Elia Devito <eliadevito@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210511124651.4802-1-eliadevito@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6391,6 +6391,7 @@ enum {
 	ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
 	ALC295_FIXUP_ASUS_DACS,
 	ALC295_FIXUP_HP_OMEN,
+	ALC285_FIXUP_HP_SPECTRE_X360,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7880,6 +7881,15 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HP_LINE1_MIC1_LED,
 	},
+	[ALC285_FIXUP_HP_SPECTRE_X360] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x90170110 }, /* enable top speaker */
+			{}
+		},
+		.chained = true,
+		.chain_id = ALC285_FIXUP_SPEAKER2_TO_DAC1,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8032,6 +8042,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
@@ -8436,6 +8447,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC255_FIXUP_XIAOMI_HEADSET_MIC, .name = "alc255-xiaomi-headset"},
 	{.id = ALC274_FIXUP_HP_MIC, .name = "alc274-hp-mic-detect"},
 	{.id = ALC295_FIXUP_HP_OMEN, .name = "alc295-hp-omen"},
+	{.id = ALC285_FIXUP_HP_SPECTRE_X360, .name = "alc285-hp-spectre-x360"},
 	{}
 };
 #define ALC225_STANDARD_PINS \


