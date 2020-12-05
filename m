Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB902CF974
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 06:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgLEFMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Dec 2020 00:12:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33373 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgLEFMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Dec 2020 00:12:30 -0500
Received: from [111.196.65.193] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1klPrG-0007tw-5d; Sat, 05 Dec 2020 05:11:47 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Subject: [PATCH v2] ALSA: hda/realtek: make bass spk volume adjustable on a yoga laptop
Date:   Sat,  5 Dec 2020 13:11:30 +0800
Message-Id: <20201205051130.8122-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This change could fix 2 issues on this machine:
 - the bass speaker's output volume can't be adjusted, that is because
   the bass speaker is routed to the DAC (Nid 0x6) which has no volume
   control.
 - after plugging a headset with vol+, vol- and pause buttons on it,
   press those buttons, nothing happens, this means those buttons
   don't work at all. This machine has alc287 codec, need to add the
   codec id to the disable/enable_headset_jack_key(), then the headset
   button could work.

The quirk of ALC285_FIXUP_THINKPAD_HEADSET_JACK could fix both of these
2 issues.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8616c5624870..5a905fa1b33a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3104,6 +3104,7 @@ static void alc_disable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0215:
 	case 0x10ec0225:
 	case 0x10ec0285:
+	case 0x10ec0287:
 	case 0x10ec0295:
 	case 0x10ec0289:
 	case 0x10ec0299:
@@ -3130,6 +3131,7 @@ static void alc_enable_headset_jack_key(struct hda_codec *codec)
 	case 0x10ec0215:
 	case 0x10ec0225:
 	case 0x10ec0285:
+	case 0x10ec0287:
 	case 0x10ec0295:
 	case 0x10ec0289:
 	case 0x10ec0299:
@@ -8578,6 +8580,11 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x14, 0x90170110},
 		{0x19, 0x04a11040},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0287, 0x17aa, "Lenovo", ALC285_FIXUP_THINKPAD_HEADSET_JACK,
+		{0x14, 0x90170110},
+		{0x17, 0x90170111},
+		{0x19, 0x03a11030},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0286, 0x1025, "Acer", ALC286_FIXUP_ACER_AIO_MIC_NO_PRESENCE,
 		{0x12, 0x90a60130},
 		{0x17, 0x90170110},
-- 
2.25.1

