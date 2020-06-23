Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C025F2062CD
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391632AbgFWUe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391101AbgFWUey (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:34:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3121D206C3;
        Tue, 23 Jun 2020 20:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944493;
        bh=0aniFq64hHgmrV65mNTMWm9UQuXhhXGOB1iwmyu8bss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dpFFWdlgD+ebjH64XdPNsmx3e1nrAUeTUWOmOVHUCNmcH4ju9jDW2sgv3Ai7ez7f4
         y7c7JKvSvfXjU5Wq1P8fQ63U8ETAeaGYvOlk7Uq3c3E0uj674iPEkm3xLs6yHzjiXc
         cKBq5fATWBSLODlvDRGoF3TQEe3a2TMclaqnDc8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/206] ALSA: hda/realtek - Introduce polarity for micmute LED GPIO
Date:   Tue, 23 Jun 2020 21:55:40 +0200
Message-Id: <20200623195317.567695457@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
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
index b4f802013f740..623ebe2e7db43 100644
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



