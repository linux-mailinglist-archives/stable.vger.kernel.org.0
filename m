Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB907457CD
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 10:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfFNIob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 04:44:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42111 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfFNIob (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jun 2019 04:44:31 -0400
Received: from [222.130.132.197] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <hui.wang@canonical.com>)
        id 1hbhoy-0008JJ-6D; Fri, 14 Jun 2019 08:44:28 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH] Revert "ALSA: hda/realtek - Improve the headset mic for Acer Aspire laptops"
Date:   Fri, 14 Jun 2019 16:44:12 +0800
Message-Id: <20190614084412.9834-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 9cb40eb184c4220d244a532bd940c6345ad9dbd9.

This patch introduces noise and headphone playback issue after
rebooting or suspending/resuming. Let us revert it.

https://bugzilla.kernel.org/show_bug.cgi?id=203831
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1afb268f3da0..179e4be1f747 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6268,15 +6268,13 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chain_id = ALC269_FIXUP_THINKPAD_ACPI,
 	},
 	[ALC255_FIXUP_ACER_MIC_NO_PRESENCE] = {
-		.type = HDA_FIXUP_VERBS,
-		.v.verbs = (const struct hda_verb[]) {
-			/* Enable the Mic */
-			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x45 },
-			{ 0x20, AC_VERB_SET_PROC_COEF, 0x5089 },
-			{}
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
 		},
 		.chained = true,
-		.chain_id = ALC269_FIXUP_LIFEBOOK_EXTMIC
+		.chain_id = ALC255_FIXUP_HEADSET_MODE
 	},
 	[ALC255_FIXUP_ASUS_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
@@ -7320,10 +7318,6 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x18, 0x02a11030},
 		{0x19, 0x0181303F},
 		{0x21, 0x0221102f}),
-	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1025, "Acer", ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
-		{0x12, 0x90a60140},
-		{0x14, 0x90170120},
-		{0x21, 0x02211030}),
 	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1025, "Acer", ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
 		{0x12, 0x90a601c0},
 		{0x14, 0x90171120},
-- 
2.17.1

