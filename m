Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284E838EEE8
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhEXPzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235023AbhEXPy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ACB96190A;
        Mon, 24 May 2021 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870816;
        bh=F7XUj1y4l9p5/0wd86vLqQkW+WxSuS0B1E5vnQik50Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HzE60Vuj4uA7cUunGVyXI6PZqXxPhLKMfuBAc/xqYbg+oIhazR5vU4C/pvVNYgRXM
         6js6Jc+ypmb+OdG4CCjPnTe0hAjKv8dKI8LYc+EbetBsmTibgvgwyejIpQ3EaOyjLA
         oBdJo3k0RKQh80SARgFkPCrlwxyEbnF6KhjT1KVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 048/104] ALSA: hda/realtek: Add fixup for HP OMEN laptop
Date:   Mon, 24 May 2021 17:25:43 +0200
Message-Id: <20210524152334.425522193@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 5d84b5318d860c9d80ca5dfae0e971ede53b4921 upstream.

HP OMEN dc0019-ur with codec SSID 103c:84da requires the pin config
overrides and the existing mic/mute LED setup.  This patch implements
those in the fixup table.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212733
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210504121832.4558-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6533,6 +6533,7 @@ enum {
 	ALC256_FIXUP_ACER_HEADSET_MIC,
 	ALC285_FIXUP_IDEAPAD_S740_COEF,
 	ALC295_FIXUP_ASUS_DACS,
+	ALC295_FIXUP_HP_OMEN,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8064,6 +8065,26 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc295_fixup_asus_dacs,
 	},
+	[ALC295_FIXUP_HP_OMEN] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x12, 0xb7a60130 },
+			{ 0x13, 0x40000000 },
+			{ 0x14, 0x411111f0 },
+			{ 0x16, 0x411111f0 },
+			{ 0x17, 0x90170110 },
+			{ 0x18, 0x411111f0 },
+			{ 0x19, 0x02a11030 },
+			{ 0x1a, 0x411111f0 },
+			{ 0x1b, 0x04a19030 },
+			{ 0x1d, 0x40600001 },
+			{ 0x1e, 0x411111f0 },
+			{ 0x21, 0x03211020 },
+			{}
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HP_LINE1_MIC1_LED,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8222,6 +8243,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x82c0, "HP G3 mini premium", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
@@ -8642,6 +8664,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC255_FIXUP_XIAOMI_HEADSET_MIC, .name = "alc255-xiaomi-headset"},
 	{.id = ALC274_FIXUP_HP_MIC, .name = "alc274-hp-mic-detect"},
 	{.id = ALC245_FIXUP_HP_X360_AMP, .name = "alc245-hp-x360-amp"},
+	{.id = ALC295_FIXUP_HP_OMEN, .name = "alc295-hp-omen"},
 	{}
 };
 #define ALC225_STANDARD_PINS \


