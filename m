Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67845241AED
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 14:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgHKMZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 08:25:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41444 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728651AbgHKMZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 08:25:06 -0400
Received: from [114.253.245.60] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1k5TKx-00025J-Ts; Tue, 11 Aug 2020 12:25:04 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de,
        kai.heng.feng@canonical.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] ALSA: hda - reverse the setting value in the micmute_led_set
Date:   Tue, 11 Aug 2020 20:24:30 +0800
Message-Id: <20200811122430.6546-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before the micmute_led_set() is introduced, the function of
alc_gpio_micmute_update() will set the gpio value with the
!micmute_led.led_value, and the machines have the correct micmute led
status. After the micmute_led_set() is introduced, it sets the gpio
value with !!micmute_led.led_value, so the led status is not correct
anymore, we need to set micmute_led_polarity = 1 to workaround it.

Now we fix the micmute_led_set() and remove micmute_led_polarity = 1.

Fixes: 87dc36482cab ("ALSA: hda/realtek - Add LED class support for micmute LED")
Reported-and-suggested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 09d93dd88713..073029aeaf3c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4125,7 +4125,7 @@ static int micmute_led_set(struct led_classdev *led_cdev,
 	struct alc_spec *spec = codec->spec;
 
 	alc_update_gpio_led(codec, spec->gpio_mic_led_mask,
-			    spec->micmute_led_polarity, !!brightness);
+			    spec->micmute_led_polarity, !brightness);
 	return 0;
 }
 
@@ -4162,8 +4162,6 @@ static void alc285_fixup_hp_gpio_led(struct hda_codec *codec,
 {
 	struct alc_spec *spec = codec->spec;
 
-	spec->micmute_led_polarity = 1;
-
 	alc_fixup_hp_gpio_led(codec, action, 0x04, 0x01);
 }
 
@@ -4414,7 +4412,6 @@ static void alc233_fixup_lenovo_line2_mic_hotkey(struct hda_codec *codec,
 {
 	struct alc_spec *spec = codec->spec;
 
-	spec->micmute_led_polarity = 1;
 	alc_fixup_hp_gpio_led(codec, action, 0, 0x04);
 	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
 		spec->init_amp = ALC_INIT_DEFAULT;
-- 
2.17.1

