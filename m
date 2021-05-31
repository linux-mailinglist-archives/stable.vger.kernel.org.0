Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C6B3960F5
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbhEaOdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232102AbhEaObe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C09696142D;
        Mon, 31 May 2021 13:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468967;
        bh=xQZQnayoY0QkyBHof+0CyFve+QrPtd1aqLzGswQfiK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eStCKHqVaMvfRM+icrFy6qdw9wNBg+fZBn5dDUh0g7Wa/3i38rhDbKxV4nLqKggLI
         Ujq90kqxj3Su1MO3TbdQjaiT1YoDet+OBW21xC/N+C+HGJDEIE5hCJQ1PGQ9t6vF2n
         AWBXcZy7XU4XP5JmKENtvppOwvJrwESEXbqJ3hl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Subject: [PATCH 5.12 003/296] ALSA: hda/realtek: Chain in pop reduction fixup for ThinkStation P340
Date:   Mon, 31 May 2021 15:10:58 +0200
Message-Id: <20210531130703.880449612@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 29c8f40b54a45dd23971e2bc395697731bcffbe1 upstream.

Lenovo ThinkStation P340 uses ALC623 codec (SSID 17aa:1048) and it produces
bug plock/pop noise over line out (green jack on the back) which can be
fixed by applying ALC269_FIXUP_NO_SHUTUP tot he machine.

Convert the existing entry for the same SSID to chain to apply this fixup
as well.

Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210524203726.2278-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6559,6 +6559,7 @@ enum {
 	ALC295_FIXUP_HP_OMEN,
 	ALC285_FIXUP_HP_SPECTRE_X360,
 	ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP,
+	ALC623_FIXUP_LENOVO_THINKSTATION_P340,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8125,6 +8126,12 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	},
+	[ALC623_FIXUP_LENOVO_THINKSTATION_P340] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_no_shutup,
+		.chained = true,
+		.chain_id = ALC283_FIXUP_HEADSET_MIC,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8442,7 +8449,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0xc019, "Clevo NH77D[BE]Q", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xc022, "Clevo NH77[DC][QW]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC233_FIXUP_LENOVO_MULTI_CODECS),
-	SND_PCI_QUIRK(0x17aa, 0x1048, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x17aa, 0x1048, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Thinkpad SL410/510", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Thinkpad L512", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x21b8, "Thinkpad Edge 14", ALC269_FIXUP_SKU_IGNORE),
@@ -8709,6 +8716,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC295_FIXUP_HP_OMEN, .name = "alc295-hp-omen"},
 	{.id = ALC285_FIXUP_HP_SPECTRE_X360, .name = "alc285-hp-spectre-x360"},
 	{.id = ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP, .name = "alc287-ideapad-bass-spk-amp"},
+	{.id = ALC623_FIXUP_LENOVO_THINKSTATION_P340, .name = "alc623-lenovo-thinkstation-p340"},
 	{}
 };
 #define ALC225_STANDARD_PINS \


