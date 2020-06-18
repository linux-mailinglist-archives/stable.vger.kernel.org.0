Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7F71FE30D
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbgFRBWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:22:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbgFRBWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2B2420B1F;
        Thu, 18 Jun 2020 01:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443356;
        bh=kwoPzJGEHttzAXCLgnqZEoNNVbl8s/rq9w0r8tikI1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEYeA7F+qSMDaVTxWz7DbowI6wsqIx23H8RLhr3cUipMRILBe9T0DMnnNf0QA78uu
         Jp/FZT6r8bOhbouwS4X780THDkwDf2Ymm5rSIcYVri5YuCF1AHOpnRaHBCNIE3TVyw
         hUZIpD5QrH+9lmPNsrpYykRIOvhYWOCDIaL1CXzg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 014/172] ALSA: hda/realtek - Introduce polarity for micmute LED GPIO
Date:   Wed, 17 Jun 2020 21:19:40 -0400
Message-Id: <20200618012218.607130-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
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
index b06f7d52faad..9ab82ead1825 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -94,6 +94,7 @@ struct alc_spec {
 
 	/* mute LED for HP laptops, see alc269_fixup_mic_mute_hook() */
 	int mute_led_polarity;
+	int micmute_led_polarity;
 	hda_nid_t mute_led_nid;
 	hda_nid_t cap_mute_led_nid;
 
@@ -3862,11 +3863,9 @@ static void alc269_fixup_hp_mute_led_mic3(struct hda_codec *codec,
 
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
@@ -3877,7 +3876,8 @@ static void alc_fixup_gpio_mute_hook(void *private_data, int enabled)
 	struct hda_codec *codec = private_data;
 	struct alc_spec *spec = codec->spec;
 
-	alc_update_gpio_led(codec, spec->gpio_mute_led_mask, enabled);
+	alc_update_gpio_led(codec, spec->gpio_mute_led_mask,
+			    spec->mute_led_polarity, enabled);
 }
 
 /* turn on/off mic-mute LED via GPIO per capture hook */
@@ -3886,6 +3886,7 @@ static void alc_gpio_micmute_update(struct hda_codec *codec)
 	struct alc_spec *spec = codec->spec;
 
 	alc_update_gpio_led(codec, spec->gpio_mic_led_mask,
+			    spec->micmute_led_polarity,
 			    spec->gen.micmute_led.led_value);
 }
 
@@ -5476,7 +5477,8 @@ static void alc280_hp_gpio4_automute_hook(struct hda_codec *codec,
 
 	snd_hda_gen_hp_automute(codec, jack);
 	/* mute_led_polarity is set to 0, so we pass inverted value here */
-	alc_update_gpio_led(codec, 0x10, !spec->gen.hp_jack_present);
+	alc_update_gpio_led(codec, 0x10, spec->mute_led_polarity,
+			    !spec->gen.hp_jack_present);
 }
 
 /* Manage GPIOs for HP EliteBook Folio 9480m.
-- 
2.25.1

