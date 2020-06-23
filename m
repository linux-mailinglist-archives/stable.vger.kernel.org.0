Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A77205E5D
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390079AbgFWUVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389502AbgFWUVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:21:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE4A2064B;
        Tue, 23 Jun 2020 20:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943704;
        bh=spLxBT1P/nZFPUL5HLrkIjBn39VeY4XAYioM6f5XhL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9rkLEtE4+QgCG0oRlMZ31PMJ+E8EziVjvxTVI2btQYQ3NLSoAitvtnfU/U/FhC2D
         56i4C3d/K5RZHOscUCYrtXPAHfxpP2+gDZmTwEX6MmAdq4e36GN+I1idPGuwrmV9QP
         gRzDK2ZVS2UM43Rco8hlPaWT+M2QT8TiQInYRPPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/314] ALSA: hda/realtek - Introduce polarity for micmute LED GPIO
Date:   Tue, 23 Jun 2020 21:53:33 +0200
Message-Id: <20200623195339.657221811@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index df5afac0b600c..459a7d61326ec 100644
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



