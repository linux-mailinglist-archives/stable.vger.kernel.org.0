Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0B42E3A32
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390434AbgL1NdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387873AbgL1NdQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:33:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A2AF22B37;
        Mon, 28 Dec 2020 13:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162355;
        bh=pP6rfZ2cRS7erT09Cn5WdaZPaA+bjtQ2YiwKJe5hmwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjYPDuqx//97okoaMrQsCVmgd23Rz9I5MGb0laJDeZdZCG/BN0gIWN2kWcOmSds/m
         5TcZFShKs9wD/OSve/HVGjrLCGKkgjMWdMey2M4O+eHkUaLqoPgENv8VXXnHsVlfkJ
         xWQ/aC9GrLHIRYOrNjKwwOZSSGA2Xy8VJbZGgyYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Chiu <chiu@endlessos.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 276/346] ALSA: hda/realtek: Apply jack fixup for Quanta NL3
Date:   Mon, 28 Dec 2020 13:49:55 +0100
Message-Id: <20201228124933.119265591@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Chiu <chiu@endlessos.org>

commit 6ca653e3f73a1af0f30dbf9c2c79d2897074989f upstream.

The Quanta NL3 laptop has both a headphone output jack and a headset
jack, on the right edge of the chassis.

The pin information suggests that both of these are at the Front.
The PulseAudio is confused to differentiate them so one of the jack
can neither get the jack sense working nor the audio output.

The ALC269_FIXUP_LIFEBOOK chained with ALC269_FIXUP_QUANTA_MUTE can
help to differentiate 2 jacks and get the 'Auto-Mute Mode' working
correctly.

Signed-off-by: Chris Chiu <chiu@endlessos.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201222150459.9545-1-chiu@endlessos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7129,6 +7129,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x152d, 0x1082, "Quanta NL3", ALC269_FIXUP_LIFEBOOK),
 	SND_PCI_QUIRK(0x1558, 0x1323, "Clevo N130ZU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x1325, "System76 Darter Pro (darp5)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x1401, "Clevo L140[CZ]U", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


