Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6DC23A6F0
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgHCM4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbgHCMWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:22:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 915EF204EC;
        Mon,  3 Aug 2020 12:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457336;
        bh=xttePjRSo/HvUvQlP8Rh7kntoyB1U0ZEsi/FLPpeVlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CrKUnjwCdj50QUqKZmzF7WIFXUp5RZ5G/Xc+LGA/CL/xqCR7LO90PstHslHyMX8R
         4eypEIK4NRL+M3gAxDokyhwoc5aJDyGc6GELZJsOqdTRzrKh+qs10z0ISUO2xFZ062
         AwZf7GMMQBbSBt94akjOYiLJXqJpX+Hx/BfzvGeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 007/120] ALSA: hda/realtek - Fixed HP right speaker no sound
Date:   Mon,  3 Aug 2020 14:17:45 +0200
Message-Id: <20200803121903.216058784@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit 5649625344fe1f4695eace7c37d011e317bf66d5 upstream.

HP NB right speaker had no sound output.
This platform was connected to I2S Amp for speaker out.(None Realtek I2S Amp IC)
EC need to check codec GPIO1 pin to initial I2S Amp.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/01285f623ac7447187482fb4a8ecaa7c@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5940,6 +5940,16 @@ static void alc_fixup_disable_mic_vref(s
 		snd_hda_codec_set_pin_target(codec, 0x19, PIN_VREFHIZ);
 }
 
+static void  alc285_fixup_hp_gpio_amp_init(struct hda_codec *codec,
+			      const struct hda_fixup *fix, int action)
+{
+	if (action != HDA_FIXUP_ACT_INIT)
+		return;
+
+	msleep(100);
+	alc_write_coef_idx(codec, 0x65, 0x0);
+}
+
 /* for hda_fixup_thinkpad_acpi() */
 #include "thinkpad_helper.c"
 
@@ -6120,6 +6130,7 @@ enum {
 	ALC289_FIXUP_ASUS_GA401,
 	ALC289_FIXUP_ASUS_GA502,
 	ALC256_FIXUP_ACER_MIC_NO_PRESENCE,
+	ALC285_FIXUP_HP_GPIO_AMP_INIT,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7352,6 +7363,12 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC256_FIXUP_ASUS_HEADSET_MODE
 	},
+	[ALC285_FIXUP_HP_GPIO_AMP_INIT] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_hp_gpio_amp_init,
+		.chained = true,
+		.chain_id = ALC285_FIXUP_HP_GPIO_LED
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7502,7 +7519,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
-	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),


