Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807D02E4310
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405241AbgL1Nz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:55:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405229AbgL1Nz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:55:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D7ED20791;
        Mon, 28 Dec 2020 13:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163685;
        bh=b26b9+XM/YdxvNYhEZCvE5EegnlbHq63blemXd999LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvyzCvbHdRsGtlC4IfkhOoxif/tMvbmw4ouwRdZwxjc1gtTVk5SK/PCCQBeLJTjLA
         QIWaMBICw3WW/GalMAIEbIkG51XUn9TaYm8sTl9QbIxd0cI9/mVuOdD7sXJ0XLDqjI
         eFRETA+xaZxhbmLDcBC4qC3w9y1RIP0TGg9tQsLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chiu@endlessos.org>,
        Jian-Hong Pan <jhp@endlessos.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 341/453] ALSA/hda: apply jack fixup for the Acer Veriton N4640G/N6640G/N2510G
Date:   Mon, 28 Dec 2020 13:49:37 +0100
Message-Id: <20201228124953.628690860@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessos.org>

commit 13be30f156fda725b168ac89fc91f78651575307 upstream.

This Acer Veriton N4640G/N6640G/N2510G desktops have 2 headphone
jacks(front and rear), and a separate Mic In jack.

The rear headphone jack is actually a line out jack but always silent
while playing audio. The front 'Mic In' also fails the jack sensing.
Apply the ALC269_FIXUP_LIFEBOOK to have all audio jacks to work as
expected.

Signed-off-by: Chris Chiu <chiu@endlessos.org>
Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201222150459.9545-2-chiu@endlessos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7735,11 +7735,14 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x0762, "Acer Aspire E1-472", ALC271_FIXUP_HP_GATE_MIC_JACK_E1_572),
 	SND_PCI_QUIRK(0x1025, 0x0775, "Acer Aspire E1-572", ALC271_FIXUP_HP_GATE_MIC_JACK_E1_572),
 	SND_PCI_QUIRK(0x1025, 0x079b, "Acer Aspire V5-573G", ALC282_FIXUP_ASPIRE_V5_PINS),
+	SND_PCI_QUIRK(0x1025, 0x101c, "Acer Veriton N2510G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x102b, "Acer Aspire C24-860", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1065, "Acer Aspire C20-820", ALC269VC_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x106d, "Acer Cloudbook 14", ALC283_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x1025, 0x1099, "Acer Aspire E5-523G", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x110e, "Acer Aspire ES1-432", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1025, 0x1166, "Acer Veriton N4640G", ALC269_FIXUP_LIFEBOOK),
+	SND_PCI_QUIRK(0x1025, 0x1167, "Acer Veriton N6640G", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1025, 0x1246, "Acer Predator Helios 500", ALC299_FIXUP_PREDATOR_SPK),
 	SND_PCI_QUIRK(0x1025, 0x1247, "Acer vCopperbox", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1025, 0x1248, "Acer Veriton N4660G", ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE),


