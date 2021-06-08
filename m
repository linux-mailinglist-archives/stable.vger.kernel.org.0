Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700A639EC51
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 04:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhFHCsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 22:48:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43496 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhFHCsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 22:48:07 -0400
Received: from [123.112.67.167] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <hui.wang@canonical.com>)
        id 1lqRkq-0000RK-D3; Tue, 08 Jun 2021 02:46:13 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     alsa-devel@alsa-project.org, tiwai@suse.de, stable@vger.kernel.org
Subject: [PATCH] ALSA: hda/realtek: headphone and mic don't work on an Acer laptop
Date:   Tue,  8 Jun 2021 10:46:00 +0800
Message-Id: <20210608024600.6198-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are 2 issues on this machine, the 1st one is mic's plug/unplug
can't be detected, that is because the mic is set to manual detecting
mode, need to apply ALC255_FIXUP_XIAOMI_HEADSET_MIC to set it to auto
detecting mode. The other one is headphone's plug/unplug can't be
detected by pulseaudio, that is because the pulseaudio will use
ucm2/sof-hda-dsp on this machine, and the ucm2 only handle
'Headphone Jack', but on this machine the headphone's pincfg sets the
location to Front, then the alsa mixer name is "Front Headphone Jack"
instead of "Headphone Jack", so override the pincfg to change location
to Left.

BugLink: http://bugs.launchpad.net/bugs/1930188
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index dcd9bceace68..be4a26f6bb96 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6568,6 +6568,7 @@ enum {
 	ALC285_FIXUP_HP_SPECTRE_X360,
 	ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP,
 	ALC623_FIXUP_LENOVO_THINKSTATION_P340,
+	ALC255_FIXUP_ACER_HEADPHONE_AND_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8146,6 +8147,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC283_FIXUP_HEADSET_MIC,
 	},
+	[ALC255_FIXUP_ACER_HEADPHONE_AND_MIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x21, 0x03211030 }, /* Change the Headphone location to Left */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC255_FIXUP_XIAOMI_HEADSET_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8182,6 +8192,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),
 	SND_PCI_QUIRK(0x1028, 0x05bd, "Dell Latitude E6440", ALC292_FIXUP_DELL_E7X),
@@ -8740,6 +8751,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC285_FIXUP_HP_SPECTRE_X360, .name = "alc285-hp-spectre-x360"},
 	{.id = ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP, .name = "alc287-ideapad-bass-spk-amp"},
 	{.id = ALC623_FIXUP_LENOVO_THINKSTATION_P340, .name = "alc623-lenovo-thinkstation-p340"},
+	{.id = ALC255_FIXUP_ACER_HEADPHONE_AND_MIC, .name = "alc255-acer-headphone-and-mic"},
 	{}
 };
 #define ALC225_STANDARD_PINS \
-- 
2.25.1

