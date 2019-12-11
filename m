Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B02B11A3AD
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 06:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfLKFNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 00:13:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58448 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfLKFNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 00:13:43 -0500
Received: from [125.35.49.90] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1ieuJf-0008C7-PR; Wed, 11 Dec 2019 05:13:40 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de
Cc:     stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek - Line-out jack doesn't work on a Dell AIO
Date:   Wed, 11 Dec 2019 13:13:21 +0800
Message-Id: <20191211051321.5883-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After applying the fixup ALC274_FIXUP_DELL_AIO_LINEOUT_VERB, the
Line-out jack works well. And instead of adding a new set of pin
definition in the pin_fixup_tbl, we put a more generic matching entry
in the fallback_pin_fixup_tbl.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6d6e34b3b3aa..dbfafee97931 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7643,11 +7643,6 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x1a, 0x90a70130},
 		{0x1b, 0x90170110},
 		{0x21, 0x03211020}),
-	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1028, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
-		{0x12, 0xb7a60130},
-		{0x13, 0xb8a61140},
-		{0x16, 0x90170110},
-		{0x21, 0x04211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0280, 0x103c, "HP", ALC280_FIXUP_HP_GPIO4,
 		{0x12, 0x90a60130},
 		{0x14, 0x90170110},
@@ -7841,6 +7836,9 @@ static const struct snd_hda_pin_quirk alc269_fallback_pin_fixup_tbl[] = {
 	SND_HDA_PIN_QUIRK(0x10ec0236, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
 		{0x19, 0x40000000},
 		{0x1a, 0x40000000}),
+	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1028, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
+		{0x19, 0x40000000},
+		{0x1a, 0x40000000}),
 	{}
 };
 
-- 
2.17.1

