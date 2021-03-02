Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5634632B23B
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343507AbhCCAxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352135AbhCBSL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 13:11:28 -0500
X-Greylist: delayed 350 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 02 Mar 2021 10:10:17 PST
Received: from srv6.fidu.org (srv6.fidu.org [IPv6:2a01:4f8:231:de0::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA652C06178B
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 10:10:17 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by srv6.fidu.org (Postfix) with ESMTP id 5CD15C800CF;
        Tue,  2 Mar 2021 19:00:50 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at srv6.fidu.org
Received: from srv6.fidu.org ([127.0.0.1])
        by localhost (srv6.fidu.org [127.0.0.1]) (amavisd-new, port 10026)
        with LMTP id m2s5eHXleoix; Tue,  2 Mar 2021 19:00:50 +0100 (CET)
Received: from wsembach-tuxedo.fritz.box (p200300E37f234700CC4188A7f2f8d6b8.dip0.t-ipconnect.de [IPv6:2003:e3:7f23:4700:cc41:88a7:f2f8:d6b8])
        (Authenticated sender: wse@tuxedocomputers.com)
        by srv6.fidu.org (Postfix) with ESMTPA id 0E306C800CE;
        Tue,  2 Mar 2021 19:00:50 +0100 (CET)
From:   Werner Sembach <wse@tuxedocomputers.com>
To:     wse@tuxedocomputers.com, perex@perex.cz, tiwai@suse.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        alsa-devel@vger.kernel.org
Cc:     Eckhart Mohr <e.mohr@tuxedocomputers.com>, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: Add quirk for Clevo NH55RZQ
Date:   Tue,  2 Mar 2021 19:00:43 +0100
Message-Id: <20210302180043.23021-1-wse@tuxedocomputers.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

ALSA: hda/realtek: Add quirk for Clevo NH55RZQ

This applies a SND_PCI_QUIRK(...) to the Clevo NH55RZQ barebone. This
fixes the issue of the device not recognizing a pluged in microphone.

The device has both, a microphone only jack, and a speaker + microphone
combo jack. The combo jack already works. The microphone-only jack does
not recognize when a device is pluged in without this patch.

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Co-developed-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
---
Third time's the charm, now using git send-email, I'm really sorry for the spam.

From 2835edd753fd19c72a644dccb7e941cfc0ecdf8e Mon Sep 17 00:00:00 2001
From: Werner Sembach <wse@tuxedocomputers.com>
Date: Fri, 26 Feb 2021 13:50:15 +0100
Subject: [PATCH] Fix device detection on microphone jack of Clevo NH55RZQ

---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 290645516313..8014e80d72c3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8089,6 +8089,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x8551, "System76 Gazelle (gaze14)", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8560, "System76 Gazelle (gaze14)", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1558, 0x8561, "System76 Gazelle (gaze14)", ALC269_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1558, 0x8562, "Clevo NH[5|7][0-9]RZ[Q]", ALC269_FIXUP_DMIC),
 	SND_PCI_QUIRK(0x1558, 0x8668, "Clevo NP50B[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8680, "Clevo NJ50LU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x8686, "Clevo NH50[CZ]U", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
-- 
2.25.1

