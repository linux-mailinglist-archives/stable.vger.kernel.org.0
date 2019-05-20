Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6945723683
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389035AbfETMZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389059AbfETMZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3513F20645;
        Mon, 20 May 2019 12:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355122;
        bh=jPac1uf8ILePb+86JbGZlaeKROdFkuYq50LyNHILdGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rg7O/Fg0rho0ox6Go3w5QyG0xMyXU1iFY5+8DN5cA7xVfKuXmsDDeH0BGkt2Hjlx8
         N8vfghjz5ZqJRLh81wJoHZ/pliKtpc1+w9c23+Rzos4QClxQswjfBRvzyTH5z9rfel
         1WpiGCNXOp+6zygNeFOC+x/DwCQ+FW2fpLVIofeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Soller <jeremy@system76.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 089/105] ALSA: hda/realtek - Corrected fixup for System76 Gazelle (gaze14)
Date:   Mon, 20 May 2019 14:14:35 +0200
Message-Id: <20190520115253.428519912@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Soller <jeremy@system76.com>

commit 891afcf2462d2cc4ef7caf94215358ca61fa32cb upstream.

A mistake was made in the identification of the four variants of the
System76 Gazelle (gaze14). This patch corrects the PCI ID of the
17-inch, GTX 1660 Ti variant from 0x8560 to 0x8551. This patch also
adds the correct fixups for the 15-inch and 17-inch GTX 1650 variants
with PCI IDs 0x8560 and 0x8561.

Tests were done on all four variants ensuring full audio capability.

Fixes: 80a5052db751 ("ALSA: hdea/realtek - Headset fixup for System76 Gazelle (gaze14)")
Signed-off-by: Jeremy Soller <jeremy@system76.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6841,7 +6841,9 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x1325, "System76 Darter Pro (darp5)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8550, "System76 Gazelle (gaze14)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1558, 0x8560, "System76 Gazelle (gaze14)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x8551, "System76 Gazelle (gaze14)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x8560, "System76 Gazelle (gaze14)", ALC269_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1558, 0x8561, "System76 Gazelle (gaze14)", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC233_FIXUP_LENOVO_MULTI_CODECS),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Thinkpad SL410/510", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Thinkpad L512", ALC269_FIXUP_SKU_IGNORE),


