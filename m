Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019AC1FE591
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387544AbgFRC0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728279AbgFRBQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:16:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D481821D94;
        Thu, 18 Jun 2020 01:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443017;
        bh=FumiIC4SV64ItlOjDACyymgUa5Er6vFZUmFMIWXeyP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6mpw8N0SODsKU+F/z/RO3zIz6660RU0X1J62Uxv7im9d/SaxyvlJLSAyKs7iyS12
         cB4RR7Bgm/Y4TKz2OBX2pXPnWgHi+ayH8iabhU4a6LGW61bjvxTsYGfj9Mlrb5l1Ib
         VKpJzi5Y1qOCjZedzh7KfVjrnIKeXA4QWXKQ52K0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.4 019/266] ALSA: hda/realtek - Introduce polarity for micmute LED GPIO
Date:   Wed, 17 Jun 2020 21:12:24 -0400
Message-Id: <20200618011631.604574-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit dbd13179780555ecd3c992dea1222ca31920e892 ]

Currently mute LED and micmute LED share the same GPIO polarity.

So split the polarity for mute and micmute, in case they have different
polarities.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200430083255.5093-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index df5afac0b600..459a7d61326e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -81,6 +81,7 @@ struct alc_spec {
 
 	/* mute LED for HP laptops, see alc269_fixup_mic_mute_hook() */
 	int mute_led_polarity;
+	int micmute_led_polarity;
 	hda_nid_t mute_led_nid;
 	hda_nid_t cap_mute_led_nid;
 
@@ -4080,11 +4081,9 @@ static void alc269_fixup_hp_mute_led_mic3(struct hda_codec *codec,
 
 /* update LED status via GPIO */
 static void alc_update_gpio_led(struct hda_codec *codec, unsigned int mask,
-				bool enabled)
+				int polarity, bool enabled)
 {
-	struct alc_spec *spec = codec->spec;
-
-	if (spec->mute_led_polarity)
+	if (polarity)
 		enabled = !enabled;
 	alc_update_gpio_data(codec, mask, !enabled); /* muted -> LED on */
 }
@@ -4095,7 +4094,8 @@ static void alc_fixup_gpio_mute_hook(void *private_data, int enabled)
 	struct hda_codec *codec = private_data;
 	struct alc_spec *spec = codec->spec;
 
-	alc_update_gpio_led(codec, spec->gpio_mute_led_mask, enabled);
+	alc_update_gpio_led(codec, spec->gpio_mute_led_mask,
+			    spec->mute_led_polarity, enabled);
 }
 
 /* turn on/off mic-mute LED via GPIO per capture hook */
@@ -4104,6 +4104,7 @@ static void alc_gpio_micmute_update(struct hda_codec *codec)
 	struct alc_spec *spec = codec->spec;
 
 	alc_update_gpio_led(codec, spec->gpio_mic_led_mask,
+			    spec->micmute_led_polarity,
 			    spec->gen.micmute_led.led_value);
 }
 
@@ -5808,7 +5809,8 @@ static void alc280_hp_gpio4_automute_hook(struct hda_codec *codec,
 
 	snd_hda_gen_hp_automute(codec, jack);
 	/* mute_led_polarity is set to 0, so we pass inverted value here */
-	alc_update_gpio_led(codec, 0x10, !spec->gen.hp_jack_present);
+	alc_update_gpio_led(codec, 0x10, spec->mute_led_polarity,
+			    !spec->gen.hp_jack_present);
 }
 
 /* Manage GPIOs for HP EliteBook Folio 9480m.
-- 
2.25.1

