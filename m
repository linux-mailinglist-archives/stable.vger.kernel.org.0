Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D967D330E2E
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhCHMfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232008AbhCHMfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D25D4651D3;
        Mon,  8 Mar 2021 12:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206932;
        bh=xwD53EU9WKvdWPTlU1HSiNr7+f9UMDOjNuoAS74l13Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lizBTHtqb0ti0XJda5FMkmB8OXqVITbvi2XdS0KIVqVisOO6taQumc+xjS1xyuhb4
         LSV1nzj/8de71Kns6p1S1cTgFlHN4kc0QFg1p0xNzhBd0CPHYMg3OyncbX3Ucpv5Xt
         oUrrz1B8uA4M/20TBtmz/iWl5LsSAeGzrupCK1kI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>,
        Jian-Hong Pan <jhp@endlessos.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 01/44] ALSA: hda/realtek: Enable headset mic of Acer SWIFT with ALC256
Date:   Mon,  8 Mar 2021 13:34:39 +0100
Message-Id: <20210308122718.656538810@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Chris Chiu <chris.chiu@canonical.com>

commit d0e185616a0331c87ce3aa1d7dfde8df39d6d002 upstream.

The Acer SWIFT Swift SF314-54/55 laptops with ALC256 cannot detect
both the headset mic and the internal mic. Introduce new fixup
to enable the jack sense and the headset mic. However, the internal
mic actually connects to Intel SST audio. It still needs Intel SST
support to make internal mic capture work.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Acked-by: Jian-Hong Pan <jhp@endlessos.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210226010440.8474-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6408,6 +6408,7 @@ enum {
 	ALC236_FIXUP_DELL_AIO_HEADSET_MIC,
 	ALC282_FIXUP_ACER_DISABLE_LINEOUT,
 	ALC255_FIXUP_ACER_LIMIT_INT_MIC_BOOST,
+	ALC256_FIXUP_ACER_HEADSET_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7864,6 +7865,16 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
 	},
+	[ALC256_FIXUP_ACER_HEADSET_MIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x02a1113c }, /* use as headset mic, without its own jack detect */
+			{ 0x1a, 0x90a1092f }, /* use as internal mic */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7890,9 +7901,11 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1246, "Acer Predator Helios 500", ALC299_FIXUP_PREDATOR_SPK),
 	SND_PCI_QUIRK(0x1025, 0x1247, "Acer vCopperbox", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1025, 0x1248, "Acer Veriton N4660G", ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1025, 0x1269, "Acer SWIFT SF314-54", ALC256_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x128f, "Acer Veriton Z6860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1290, "Acer Veriton Z4860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1291, "Acer Veriton Z4660G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x129c, "Acer SWIFT SF314-55", ALC256_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),


