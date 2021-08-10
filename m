Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBD33E801A
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbhHJRqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234310AbhHJRnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:43:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAB9F60EB9;
        Tue, 10 Aug 2021 17:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617137;
        bh=r678fCgxrvg5vrjDjvcLVDrR2VkdAXF+/ces5oBP8Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2o8r6mgIxvQfNJNi0p75zOO/aHQyLeNEfsW1FaE2StpQIy6ia4P3/swKzrGVY3BZa
         CJqO2itBY9eGSP0SKkCfHPQAhakoFHl74v1r4v4Z0jehUWOf5KojUrEPvkMNrA5F6s
         3Sx6UwYiE9ulfeY03GL7vFBepzqV1aw70o+H027c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Liolios <liolios.nk@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 061/135] ALSA: hda/realtek: Fix headset mic for Acer SWIFT SF314-56 (ALC256)
Date:   Tue, 10 Aug 2021 19:29:55 +0200
Message-Id: <20210810172957.759728266@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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
@@ -8200,6 +8200,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1290, "Acer Veriton Z4860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1291, "Acer Veriton Z4660G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x129c, "Acer SWIFT SF314-55", ALC256_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1300, "Acer SWIFT SF314-56", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1308, "Acer Aspire Z24-890", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),


