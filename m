Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6E52D4D1
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 06:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbfE2EmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 00:42:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59244 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbfE2EmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 00:42:04 -0400
Received: from [221.221.103.6] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <hui.wang@canonical.com>)
        id 1hVqPX-0003ho-EA; Wed, 29 May 2019 04:42:00 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org, kailang@realtek.com, chiu@endlessm.com,
        drake@endlessm.com
Subject: [PATCH] ALSA: hda/realtek - Improve the headset mic for Acer Aspire laptops
Date:   Wed, 29 May 2019 12:41:38 +0800
Message-Id: <20190529044138.778-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We met another Acer Aspire laptop which has the problem on the
headset-mic, the Pin 0x19 is not set the corret configuration for a
mic and the pin presence can't be detected too after plugging a
headset. Kailang suggested that we should set the coeff to enable the
mic and apply the ALC269_FIXUP_LIFEBOOK_EXTMIC. After doing that,
both headset-mic presence and headset-mic work well.

The existing ALC255_FIXUP_ACER_MIC_NO_PRESENCE set the headset-mic
jack to be a phantom jack. Now since the jack can support presence
unsol event, let us imporve it to set the jack to be a normal jack.

https://bugs.launchpad.net/bugs/1821269
Fixes: 5824ce8de7b1c ("ALSA: hda/realtek - Add support for Acer Aspire E5-475 headset mic")
Cc: Chris Chiu <chiu@endlessm.com>
CC: Daniel Drake <drake@endlessm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f1bac03e954b..f42a097f2e16 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6223,13 +6223,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chain_id = ALC269_FIXUP_THINKPAD_ACPI,
 	},
 	[ALC255_FIXUP_ACER_MIC_NO_PRESENCE] = {
-		.type = HDA_FIXUP_PINS,
-		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
-			{ }
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* Enable the Mic */
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x45 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x5089 },
+                       {}
 		},
 		.chained = true,
-		.chain_id = ALC255_FIXUP_HEADSET_MODE
+		.chain_id = ALC269_FIXUP_LIFEBOOK_EXTMIC
 	},
 	[ALC255_FIXUP_ASUS_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
@@ -7273,6 +7275,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x18, 0x02a11030},
 		{0x19, 0x0181303F},
 		{0x21, 0x0221102f}),
+	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1025, "Acer", ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
+		{0x12, 0x90a60140},
+		{0x14, 0x90170120},
+		{0x21, 0x02211030}),
 	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1025, "Acer", ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
 		{0x12, 0x90a601c0},
 		{0x14, 0x90171120},
-- 
2.17.1

