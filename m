Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F2542A399
	for <lists+stable@lfdr.de>; Tue, 12 Oct 2021 13:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbhJLLuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 07:50:02 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:48372
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232665AbhJLLuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Oct 2021 07:50:02 -0400
Received: from localhost.localdomain (unknown [123.112.69.44])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id C958E40049;
        Tue, 12 Oct 2021 11:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634039279;
        bh=2lpVt2XYiPkKaR75Uw0kkw/Xv64RqcoglShtc0fgqYs=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=gY8lUY9uqGBLzXvHIxFi6J88GBgWs1Odma3VBuOTuv6b7qGPBXPnhu/yiKKQqGFeV
         okYhQISjzNzgbcV6lCye7SbZE8lZI/pgdcHlmwa+gcgNToQUM1bx5HVGnFF2tgdGDb
         gg/NjakwtFjOIAZFrE4PTQ7zaKKdVZ02hiodATJCWDncEQ+SDVhuVy2y4u28Tik/ai
         n/ZC38FozqJ2R/B9sBmzgpfgJY2kkRn0ZQxm/Htpp/PNmXXtLtgHs2mUcz1bqD32f0
         bx1kWsjgFOGPq10c/AkHoYLMNPzMO/OX1E8bivn/2JvHehhqKC/eM5YROFbUx++fqk
         KEdo2p77/7z4w==
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Cc:     msd.mmq@gmail.com
Subject: [PATCH] ALSA: hda/realtek: Fix the mic type detection issue for ASUS G551JW
Date:   Tue, 12 Oct 2021 19:47:48 +0800
Message-Id: <20211012114748.5238-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We need to define the codec pin 0x1b to be the mic, but somehow
the mic doesn't support hot plugging detection, and Windows also has
this issue, so we set it to phantom headset-mic.

Also the determine_headset_type() often returns the omtp type by a
mistake when we plug a ctia headset, this makes the mic can't record
sound at all. Because most of the headset are ctia type nowadays and
some machines have the fixed ctia type audio jack, it is possible this
machine has the fixed ctia jack too. Here we set this mic jack to
fixed ctia type, this could avoid the mic type detection mistake and
make the ctia headset work stable.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214537
Reported-and-tested-by: msd <msd.mmq@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index bca5830ff706..22d27b12c4e7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10197,6 +10197,9 @@ enum {
 	ALC671_FIXUP_HP_HEADSET_MIC2,
 	ALC662_FIXUP_ACER_X2660G_HEADSET_MODE,
 	ALC662_FIXUP_ACER_NITRO_HEADSET_MODE,
+	ALC668_FIXUP_ASUS_NO_HEADSET_MIC,
+	ALC668_FIXUP_HEADSET_MIC,
+	ALC668_FIXUP_MIC_DET_COEF,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -10580,6 +10583,29 @@ static const struct hda_fixup alc662_fixups[] = {
 		.chained = true,
 		.chain_id = ALC662_FIXUP_USI_FUNC
 	},
+	[ALC668_FIXUP_ASUS_NO_HEADSET_MIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1b, 0x04a1112c },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC668_FIXUP_HEADSET_MIC
+	},
+	[ALC668_FIXUP_HEADSET_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_headset_mic,
+		.chained = true,
+		.chain_id = ALC668_FIXUP_MIC_DET_COEF
+	},
+	[ALC668_FIXUP_MIC_DET_COEF] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x15 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0d60 },
+			{}
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -10615,6 +10641,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x15a7, "ASUS UX51VZH", ALC662_FIXUP_BASS_16),
 	SND_PCI_QUIRK(0x1043, 0x177d, "ASUS N551", ALC668_FIXUP_ASUS_Nx51),
 	SND_PCI_QUIRK(0x1043, 0x17bd, "ASUS N751", ALC668_FIXUP_ASUS_Nx51),
+	SND_PCI_QUIRK(0x1043, 0x185d, "ASUS G551JW", ALC668_FIXUP_ASUS_NO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1963, "ASUS X71SL", ALC662_FIXUP_ASUS_MODE8),
 	SND_PCI_QUIRK(0x1043, 0x1b73, "ASUS N55SF", ALC662_FIXUP_BASS_16),
 	SND_PCI_QUIRK(0x1043, 0x1bf3, "ASUS N76VZ", ALC662_FIXUP_BASS_MODE4_CHMAP),
-- 
2.25.1

