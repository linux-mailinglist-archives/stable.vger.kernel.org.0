Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6122C094A
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733165AbgKWNF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:05:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:34574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730200AbgKWMtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:49:51 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37C6A21534;
        Mon, 23 Nov 2020 12:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135783;
        bh=hkFKf7DxF4TKPgatwFguJ9miJHM3hl9ioO6idFOAQZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HY42p/X0MahAgONCc7d+lwYd9Hp3dys0tQH5v7YhM69WIU/SIbc7ns47gzTWg6HzA
         f3F4Ik6xJ2xI4pFX06TihHh/W+pquENpopU97iBd5SYN2KMT7vZ5jQQcXus1mVDaLw
         gQwQ+bVNDbQdTKmuoNw17ZUhf6fMM98n8dgRo0wA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 195/252] ALSA: hda/realtek - Add supported mute Led for HP
Date:   Mon, 23 Nov 2020 13:22:25 +0100
Message-Id: <20201123121845.010473462@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit a0ccbc5319d57b9efdc55c943a3fde30a0776502 upstream.

HP Pavilion x360 Convertible machine, it supported mute led.
GPIO4 high will turn on led.
The patch will enable control led via GPIO4 pin.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1ae4d98e92c147b780ace3911c4e1d73@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4216,6 +4216,12 @@ static void alc286_fixup_hp_gpio_led(str
 	alc_fixup_hp_gpio_led(codec, action, 0x02, 0x20);
 }
 
+static void alc287_fixup_hp_gpio_led(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	alc_fixup_hp_gpio_led(codec, action, 0x10, 0);
+}
+
 /* turn on/off mic-mute LED per capture hook via VREF change */
 static int vref_micmute_led_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
@@ -6302,6 +6308,7 @@ enum {
 	ALC274_FIXUP_HP_HEADSET_MIC,
 	ALC256_FIXUP_ASUS_HPE,
 	ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
+	ALC287_FIXUP_HP_GPIO_LED,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7712,6 +7719,10 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_THINKPAD_ACPI
 	},
+	[ALC287_FIXUP_HP_GPIO_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_hp_gpio_led,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7866,6 +7877,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87f4, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


