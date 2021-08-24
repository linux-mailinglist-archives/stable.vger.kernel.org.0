Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1EE3F563C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhHXDAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 23:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234699AbhHXC7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:59:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6AC9613B1;
        Tue, 24 Aug 2021 02:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773942;
        bh=m0Xr7vMPh0ChPHsiGDYYYoi71AkqV6C7lAZgkG0HVV0=;
        h=From:To:Cc:Subject:Date:From;
        b=lAFNuBmhLNzj4Gkf0YDteiaCwWi8Sbd0tBXCUGADrRO62wAW4FIQcuuYxJKcA291x
         HfP/JoSV+KaltFnZ37v/t6onbf/BQiUXk/R1PkLgXYDRwM66V6XqGc4iaXfqmyaQuv
         hS5zwlrN2bN06SlBmrbIJ1DXTTihfx+3Hy2dTvsCbG/Cd49Jb44z8nPyAxdzUPjmQg
         vVYznMoDp4iiQbXWYJJBoj8nAv9dR9fgPX+ys8Ly+Bofqz6X5hQHzrQf80GiocINWU
         Bq39pGl/UqAOnAhspplEY3GCGCdaqDqrRMEZQfMKAIp/H2T/HtaVCJ5hEvOXkZ+fiw
         nen1/I8xy0CuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, kai.heng.feng@canonical.com
Cc:     Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: FAILED: Patch "ALSA: hda/realtek: Limit mic boost on HP ProBook 445 G8" failed to apply to 4.4-stable tree
Date:   Mon, 23 Aug 2021 22:59:00 -0400
Message-Id: <20210824025900.660304-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 8903376dc69949199301b290cc22dc64ae5d8a6d Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Wed, 18 Aug 2021 22:41:18 +0800
Subject: [PATCH] ALSA: hda/realtek: Limit mic boost on HP ProBook 445 G8

The mic has lots of noises if mic boost is enabled. So disable mic boost
to get crystal clear audio capture.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210818144119.121738-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 sound/pci/hda/patch_realtek.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 96f32eaa24df..7ad689f991e7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6658,6 +6658,7 @@ enum {
 	ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP,
 	ALC623_FIXUP_LENOVO_THINKSTATION_P340,
 	ALC255_FIXUP_ACER_HEADPHONE_AND_MIC,
+	ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8242,6 +8243,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC255_FIXUP_XIAOMI_HEADSET_MIC
 	},
+	[ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost,
+		.chained = true,
+		.chain_id = ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8438,8 +8445,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8847, "HP EliteBook x360 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884b, "HP EliteBook 840 Aero G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884c, "HP EliteBook 840 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
-	SND_PCI_QUIRK(0x103c, 0x8862, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
-	SND_PCI_QUIRK(0x103c, 0x8863, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8862, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x103c, 0x8863, "HP ProBook 445 G8 Notebook PC", ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x886d, "HP ZBook Fury 17.3 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8870, "HP ZBook Fury 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
-- 
2.30.2




