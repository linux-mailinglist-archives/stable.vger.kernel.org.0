Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A683E8145
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbhHJR6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232140AbhHJR4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:56:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77DAC6137A;
        Tue, 10 Aug 2021 17:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617498;
        bh=XTJoP33YmVo4DPeVzOd/ZC+w7CEEVH7t89vyXtPjRhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LgpHcLP02AkfIM6nWWRSZTR0njEhhC5nLE1m/xOFb46gbTihIwCcL3tk3krcUy59/
         FbHvPmPYWHU7ERnKiCS3ei2auPtS05ugDu46JDc7vJGn6uXEel3zRRskU1OLQqVVE9
         tThLP1vCFxnBtgspvpgfn8e0dCryshLucoAAh5i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Liolios <liolios.nk@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.13 085/175] ALSA: hda/realtek: Fix headset mic for Acer SWIFT SF314-56 (ALC256)
Date:   Tue, 10 Aug 2021 19:29:53 +0200
Message-Id: <20210810173003.743768634@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Liolios <liolios.nk@gmail.com>

commit 35171fbfc0d94aa31b009bb475d156ad1941ab50 upstream.

The issue on Acer SWIFT SF314-56 is that headset microphone doesn't work.
The following quirk fixed headset microphone issue. The fixup was found by trial and error.
Note that the fixup of SF314-54/55 (ALC256_FIXUP_ACER_HEADSET_MIC) was not successful on my SF314-56.

Signed-off-by: Nikos Liolios <liolios.nk@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210727030510.36292-1-liolios.nk@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8214,6 +8214,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1290, "Acer Veriton Z4860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1291, "Acer Veriton Z4660G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x129c, "Acer SWIFT SF314-55", ALC256_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1300, "Acer SWIFT SF314-56", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),


