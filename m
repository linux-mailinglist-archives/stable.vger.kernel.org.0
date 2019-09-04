Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 311B0A7AFC
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 07:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfIDFxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 01:53:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44045 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDFxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 01:53:42 -0400
Received: from [125.35.49.90] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <hui.wang@canonical.com>)
        id 1i5OEc-00040Y-FY; Wed, 04 Sep 2019 05:53:39 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek - Fix the problem of two front mics on a ThinkCentre
Date:   Wed,  4 Sep 2019 13:53:27 +0800
Message-Id: <20190904055327.9883-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This ThinkCentre machine has a new realtek codec alc222, it is not
in the support list, we add it in the realtek.c then this machine
can apply FIXUPs for the realtek codec.

And this machine has two front mics which can't be handled
by PA so far, it uses the pin 0x18 and 0x19 as the front mics, as
a result the existing FIXUP ALC294_FIXUP_LENOVO_MIC_LOCATION doesn't
work on this machine. Fortunately another FIXUP
ALC283_FIXUP_HEADSET_MIC also can change the location for one of the
two mics on this machine.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3b9583aa63c1..74697c1dd1d5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7151,6 +7151,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x312a, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x17aa, 0x312f, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x17aa, 0x313c, "ThinkCentre Station", ALC294_FIXUP_LENOVO_MIC_LOCATION),
+	SND_PCI_QUIRK(0x17aa, 0x3151, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
@@ -9038,6 +9039,7 @@ static int patch_alc680(struct hda_codec *codec)
 static const struct hda_device_id snd_hda_id_realtek[] = {
 	HDA_CODEC_ENTRY(0x10ec0215, "ALC215", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0221, "ALC221", patch_alc269),
+	HDA_CODEC_ENTRY(0x10ec0222, "ALC222", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0225, "ALC225", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0231, "ALC231", patch_alc269),
 	HDA_CODEC_ENTRY(0x10ec0233, "ALC233", patch_alc269),
-- 
2.17.1

