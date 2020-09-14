Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F9A268524
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 08:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgINGvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 02:51:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51136 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgINGvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 02:51:36 -0400
Received: from [125.35.49.90] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1kHiKn-0001o9-28; Mon, 14 Sep 2020 06:51:29 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, kailang@realtek.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek - Couldn't detect Mic if booting with headset plugged
Date:   Mon, 14 Sep 2020 14:51:18 +0800
Message-Id: <20200914065118.19238-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We found a Mic detection issue on many Lenovo laptops, those laptops
belong to differnt models and they have different audio design like
internal mic connects to the codec or PCH, they all have this problem,
the problem is if plugging a headset before powerup/reboot the
machine, after booting up, the headphone could be detected but Mic
couldn't. If we plug out and plug in the headset, both headphone and
Mic could be detected then.

Through debugging we found the codec on those laptops are same, it is
alc257, and if we don't disable the 3k pulldown in alc256_shutup(),
the issue will be fixed. So far there is no pop noise or power
consumption regression on those laptops after this change.

Cc: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 85e207173f5d..b6dc47da1d7b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3428,7 +3428,11 @@ static void alc256_shutup(struct hda_codec *codec)
 
 	/* 3k pull low control for Headset jack. */
 	/* NOTE: call this before clearing the pin, otherwise codec stalls */
-	alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
+	/* If disable 3k pulldown control for alc257, the Mic detection will not work correctly
+	 * when booting with headset plugged. So skip setting it for the codec alc257
+	 */
+	if (codec->core.vendor_id != 0x10ec0257)
+		alc_update_coef_idx(codec, 0x46, 0, 3 << 12);
 
 	if (!spec->no_shutup_pins)
 		snd_hda_codec_write(codec, hp_pin, 0,
-- 
2.17.1

