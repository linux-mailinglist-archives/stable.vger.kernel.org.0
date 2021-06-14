Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4705D3A62E1
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhFNLGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234404AbhFNLDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:03:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31643617C9;
        Mon, 14 Jun 2021 10:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667460;
        bh=TV+TxsLCTq4YVM8Ca2NcWvrrpZeNG75TMCp4WcD7JfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJ1/9CuTjkgw9jJ92Pb7M76y4d/3o2XGbAUA7mnz2w4fRHdFGU0utKeMmLSG9gL26
         wfmEUcjNqAu4ELHCmsjBjBSL6djws/C559r5N41hZ4yoobvWQ10+Zsu9S5DEiQUkIA
         IIjGNWswsVDGVxBQkVzhbDYByn27le9tjGOzkBAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 047/131] ALSA: hda/realtek: headphone and mic dont work on an Acer laptop
Date:   Mon, 14 Jun 2021 12:26:48 +0200
Message-Id: <20210614102654.620537566@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 57c9e21a49b1c196cda28f54de9a5d556ac93f20 upstream.

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
Link: https://lore.kernel.org/r/20210608024600.6198-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6560,6 +6560,7 @@ enum {
 	ALC285_FIXUP_HP_SPECTRE_X360,
 	ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP,
 	ALC623_FIXUP_LENOVO_THINKSTATION_P340,
+	ALC255_FIXUP_ACER_HEADPHONE_AND_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8132,6 +8133,15 @@ static const struct hda_fixup alc269_fix
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
@@ -8168,6 +8178,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x132a, "Acer TravelMate B114-21", ALC233_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1330, "Acer TravelMate X514-51T", ALC255_FIXUP_ACER_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),
 	SND_PCI_QUIRK(0x1028, 0x05bd, "Dell Latitude E6440", ALC292_FIXUP_DELL_E7X),
@@ -8722,6 +8733,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC285_FIXUP_HP_SPECTRE_X360, .name = "alc285-hp-spectre-x360"},
 	{.id = ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP, .name = "alc287-ideapad-bass-spk-amp"},
 	{.id = ALC623_FIXUP_LENOVO_THINKSTATION_P340, .name = "alc623-lenovo-thinkstation-p340"},
+	{.id = ALC255_FIXUP_ACER_HEADPHONE_AND_MIC, .name = "alc255-acer-headphone-and-mic"},
 	{}
 };
 #define ALC225_STANDARD_PINS \


