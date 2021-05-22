Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B75538D34D
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 05:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhEVDtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 23:49:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34687 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbhEVDtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 23:49:23 -0400
Received: from [123.112.69.138] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <hui.wang@canonical.com>)
        id 1lkIcF-0003Vp-UV; Sat, 22 May 2021 03:47:57 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: Headphone volume is controlled by Front mixer
Date:   Sat, 22 May 2021 11:47:41 +0800
Message-Id: <20210522034741.13415-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On some ASUS and MSI machines, the audio codec is alc1220 and the
Headphone is connected to audio mixer 0xf and DAC 0x5, in theory
the Headphone volume is controlled by DAC 0x5 (Heapdhone Playback
Volume), but somehow it is controlled by DAC 0x2 (Front Playback
Volume), maybe this is a defect on the codec alc1220.

Because of this issue, the PA couldn't switch the headphone and
Lineout correctly, If we apply the quirk CLEVO_P950 to those machines,
the Lineout and Headphone will share the audio mixer 0xc and DAC 0x2,
and generate Headphone+LO mixer, then PA could handle them when
switching between them.

BugLink: https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/1206
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c6b5db831ed0..3d40d32ef3ba 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2603,6 +2603,28 @@ static const struct hda_model_fixup alc882_fixup_models[] = {
 	{}
 };
 
+static const struct snd_hda_pin_quirk alc882_pin_fixup_tbl[] = {
+	SND_HDA_PIN_QUIRK(0x10ec1220, 0x1043, "ASUS", ALC1220_FIXUP_CLEVO_P950,
+		{0x14, 0x01014010},
+		{0x15, 0x01011012},
+		{0x16, 0x01016011},
+		{0x18, 0x01a19040},
+		{0x19, 0x02a19050},
+		{0x1a, 0x0181304f},
+		{0x1b, 0x0221401f},
+		{0x1e, 0x01456130}),
+	SND_HDA_PIN_QUIRK(0x10ec1220, 0x1462, "MS-7C35", ALC1220_FIXUP_CLEVO_P950,
+		{0x14, 0x01015010},
+		{0x15, 0x01011012},
+		{0x16, 0x01011011},
+		{0x18, 0x01a11040},
+		{0x19, 0x02a19050},
+		{0x1a, 0x0181104f},
+		{0x1b, 0x0221401f},
+		{0x1e, 0x01451130}),
+	{}
+};
+
 /*
  * BIOS auto configuration
  */
@@ -2644,6 +2666,7 @@ static int patch_alc882(struct hda_codec *codec)
 
 	snd_hda_pick_fixup(codec, alc882_fixup_models, alc882_fixup_tbl,
 		       alc882_fixups);
+	snd_hda_pick_pin_fixup(codec, alc882_pin_fixup_tbl, alc882_fixups, true);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);
 
 	alc_auto_parse_customize_define(codec);
-- 
2.25.1

