Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E07637C732
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbhELP7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:59:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237233AbhELPzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:55:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4766C61459;
        Wed, 12 May 2021 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833284;
        bh=Nr3bsYbK1iTpA2f80c0E2GF84LXeMnRzNTqh14JG+ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xlOV7BK7ceq4A6AbMs7ajOYlkhK8cEx4YqyTdceSk/V/blzMQG1mWPkTVIVMlKWXs
         uA+1JbOjIV571JH4ABCWx78Z4G97q5HgzkfMBGrXd/2pwx+g7cu33TovjvDE5of8nD
         FvPSqq7Dv/H6y6COk2d5PrzGP/H5ngFqXkp5J4cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.11 088/601] ALSA: hda/realtek: Fix speaker amp on HP Envy AiO 32
Date:   Wed, 12 May 2021 16:42:45 +0200
Message-Id: <20210512144830.729393385@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 622464c893142f7beac89f5ba8c9773bca5e5004 upstream.

HP Envy AiO 32-a12xxx has an external amp that is controlled via GPIO
bit 0x04.  However, unlike other devices, this amp seems to shut down
itself after the certain period, hence the OS needs to up/down the bit
dynamically only during the actual playback.

This patch adds the control of the GPIO bit via the existing pcm_hook
mechanism.  Ideally it should be triggered at the actual stream start,
but we have only the state change at prepare/cleanup, so use those for
switching the GPIO bit on/off.  This should be good enough for the
purpose, and was actually confirmed to work fine.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212873
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210504091802.13200-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4331,6 +4331,35 @@ static void alc245_fixup_hp_x360_amp(str
 	}
 }
 
+/* toggle GPIO2 at each time stream is started; we use PREPARE state instead */
+static void alc274_hp_envy_pcm_hook(struct hda_pcm_stream *hinfo,
+				    struct hda_codec *codec,
+				    struct snd_pcm_substream *substream,
+				    int action)
+{
+	switch (action) {
+	case HDA_GEN_PCM_ACT_PREPARE:
+		alc_update_gpio_data(codec, 0x04, true);
+		break;
+	case HDA_GEN_PCM_ACT_CLEANUP:
+		alc_update_gpio_data(codec, 0x04, false);
+		break;
+	}
+}
+
+static void alc274_fixup_hp_envy_gpio(struct hda_codec *codec,
+				      const struct hda_fixup *fix,
+				      int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PROBE) {
+		spec->gpio_mask |= 0x04;
+		spec->gpio_dir |= 0x04;
+		spec->gen.pcm_playback_hook = alc274_hp_envy_pcm_hook;
+	}
+}
+
 static void alc_update_coef_led(struct hda_codec *codec,
 				struct alc_coef_led *led,
 				bool polarity, bool on)
@@ -6443,6 +6472,7 @@ enum {
 	ALC255_FIXUP_XIAOMI_HEADSET_MIC,
 	ALC274_FIXUP_HP_MIC,
 	ALC274_FIXUP_HP_HEADSET_MIC,
+	ALC274_FIXUP_HP_ENVY_GPIO,
 	ALC256_FIXUP_ASUS_HPE,
 	ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
 	ALC287_FIXUP_HP_GPIO_LED,
@@ -7882,6 +7912,10 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC274_FIXUP_HP_MIC
 	},
+	[ALC274_FIXUP_HP_ENVY_GPIO] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc274_fixup_hp_envy_gpio,
+	},
 	[ALC256_FIXUP_ASUS_HPE] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -8099,6 +8133,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8724, "HP EliteBook 850 G7", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8730, "HP ProBook 445 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),


