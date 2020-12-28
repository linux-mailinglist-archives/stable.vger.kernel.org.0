Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AE22E3F99
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503819AbgL1O0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:26:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503869AbgL1O0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:26:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AAC6207B2;
        Mon, 28 Dec 2020 14:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165562;
        bh=DieRUxCgiy8BL/gIK1JwZmNJdIR2pQqOk5P2wFx3Of4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0XB+wvPlPAcKb08HPFJElzI9Af0k1OLjQ6vm9xLmV+Z/ADGv6XoUj3s4dDZVqpxhA
         hfEJyrC9nCKq8QehI6KjfSgJMxtlc5awo84UmfTb66SWZCMyeyV2xqDvu8ECWq2MWa
         vcziY4y0z0HuuongCxZaQnDIvPxKkfzoMkzf6ARo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chiu@endlessos.org>,
        Jian-Hong Pan <jhp@endlessos.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 545/717] ALSA: hda/realtek: Remove dummy lineout on Acer TravelMate P648/P658
Date:   Mon, 28 Dec 2020 13:49:03 +0100
Message-Id: <20201228125047.051904184@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessos.org>

commit 34cdf405aa5de827b8bef79a6c82c39120b3729b upstream.

Acer TravelMate laptops P648/P658 series with codec ALC282 only have
one physical jack for headset but there's a confusing lineout pin on
NID 0x1b reported. Audio applications hence misunderstand that there
are a speaker and a lineout, and take the lineout as the default audio
output.

Add a new quirk to remove the useless lineout and enable the pin 0x18
for jack sensing and headset microphone.

Signed-off-by: Chris Chiu <chiu@endlessos.org>
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201216125200.27053-1-chiu@endlessos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6369,6 +6369,7 @@ enum {
 	ALC287_FIXUP_HP_GPIO_LED,
 	ALC256_FIXUP_HP_HEADSET_MIC,
 	ALC236_FIXUP_DELL_AIO_HEADSET_MIC,
+	ALC282_FIXUP_ACER_DISABLE_LINEOUT,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7792,6 +7793,16 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE
 	},
+	[ALC282_FIXUP_ACER_DISABLE_LINEOUT] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1b, 0x411111f0 },
+			{ 0x18, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ },
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8569,6 +8580,22 @@ static const struct snd_hda_pin_quirk al
 		{0x12, 0x90a60140},
 		{0x19, 0x04a11030},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0282, 0x1025, "Acer", ALC282_FIXUP_ACER_DISABLE_LINEOUT,
+		ALC282_STANDARD_PINS,
+		{0x12, 0x90a609c0},
+		{0x18, 0x03a11830},
+		{0x19, 0x04a19831},
+		{0x1a, 0x0481303f},
+		{0x1b, 0x04211020},
+		{0x21, 0x0321101f}),
+	SND_HDA_PIN_QUIRK(0x10ec0282, 0x1025, "Acer", ALC282_FIXUP_ACER_DISABLE_LINEOUT,
+		ALC282_STANDARD_PINS,
+		{0x12, 0x90a60940},
+		{0x18, 0x03a11830},
+		{0x19, 0x04a19831},
+		{0x1a, 0x0481303f},
+		{0x1b, 0x04211020},
+		{0x21, 0x0321101f}),
 	SND_HDA_PIN_QUIRK(0x10ec0283, 0x1028, "Dell", ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
 		ALC282_STANDARD_PINS,
 		{0x12, 0x90a60130},


