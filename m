Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC591E2CFF
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392132AbgEZTNI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404202AbgEZTNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:13:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99C19208E4;
        Tue, 26 May 2020 19:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520387;
        bh=hH8VdHMcoSdW4iq/P16jtsTULNtxfV93v0SaSsDH9LE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHeI8+mvXSQZExErAIENdH7ASEPaaxm2vhizyZay6eohQNrQywlxv6ymzxsMFz0Pj
         4vPA/TTBiVCvTW8euh2rcCV913jbveJsyRoaudMamWIABzNHw5wqT2BWZ3NKevCt2z
         loACtYOnyg0xtghEOI4f4G6tlh0k+3Bq65PKq2Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Pozulp <pozulp.kernel@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 058/126] ALSA: hda/realtek: Add quirk for Samsung Notebook
Date:   Tue, 26 May 2020 20:53:15 +0200
Message-Id: <20200526183942.983034908@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Pozulp <pozulp.kernel@gmail.com>

[ Upstream commit 14425f1f521fdfe274a7bb390637c786432e08b4 ]

Some models of the Samsung Notebook 9 have very quiet and distorted
headphone output. This quirk changes the VREF value of the ALC298
codec NID 0x1a from default HIZ to new 100.

[ adjusted to 5.7-base and rearranged in SSID order -- tiwai ]

Signed-off-by: Mike Pozulp <pozulp.kernel@gmail.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207423
Link: https://lore.kernel.org/r/20200510032838.1989130-1-pozulp.kernel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 368ed3678fc2..b377aca71cbf 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6095,6 +6095,7 @@ enum {
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED,
+	ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7251,6 +7252,13 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc236_fixup_hp_mute_led,
 	},
+	[ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, 0xc5 },
+			{ }
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7446,6 +7454,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
 	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
+	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
-- 
2.25.1



