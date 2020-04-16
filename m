Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4E21ACB1B
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635624AbgDPPnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896204AbgDPNf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:35:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B712221F9;
        Thu, 16 Apr 2020 13:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044128;
        bh=UqFZh/1eEoluZP1qvKMPPJGO87tS/2gzODxY+9ZVkYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nnb+oW0PyzvZatmM1g+2/KGi+39K3OJCjNXtAzeH8gm55Xe9jhgepr+6DpFCttaiN
         cWkCR2SB07aWFvBCXB+Po9FG/ByrvkK+WSxPuqW6Z/an7bubQs0HChVJKi/pAmTdEw
         Kr9jVEsz0T3P0tBkjIyNeLG1RN3OUvOXWti22670=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.5 092/257] ALSA: hda/realtek: Enable mute LED on an HP system
Date:   Thu, 16 Apr 2020 15:22:23 +0200
Message-Id: <20200416131337.512556901@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit f5a88b0accc24c4a9021247d7a3124f90aa4c586 upstream.

The system in question uses ALC285, and it uses GPIO 0x04 to control its
mute LED.

The mic mute LED can be controlled by GPIO 0x01, however the system uses
DMIC so we should use that to control mic mute LED.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200327044626.29582-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4008,6 +4008,12 @@ static void alc269_fixup_hp_gpio_led(str
 	alc_fixup_hp_gpio_led(codec, action, 0x08, 0x10);
 }
 
+static void alc285_fixup_hp_gpio_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	alc_fixup_hp_gpio_led(codec, action, 0x04, 0x00);
+}
+
 static void alc286_fixup_hp_gpio_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -5923,6 +5929,7 @@ enum {
 	ALC294_FIXUP_ASUS_DUAL_SPK,
 	ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	ALC294_FIXUP_ASUS_HPE,
+	ALC285_FIXUP_HP_GPIO_LED,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7061,6 +7068,10 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC294_FIXUP_ASUS_HEADSET_MIC
 	},
+	[ALC285_FIXUP_HP_GPIO_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_hp_gpio_led,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7208,6 +7219,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


