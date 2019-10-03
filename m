Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928EBCA700
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393076AbfJCQt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393072AbfJCQt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:49:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D6DF222CB;
        Thu,  3 Oct 2019 16:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121364;
        bh=hg7cnCXjeGWahhxiH2BWq0tRZool+GN4nN36HueKydU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtRZWXe27FEfzLVVl7IaVOvzAweAoQkdnE9taBgjrmGmuS6MIviPFPmUVLhzfCKcf
         X/8avUXF33V6VV9/G4K16xhdYduh9fSRgSLs5ORV6QL9Uwk7NQYs3LbkHUIj78ULVC
         LKQwOYkxLb652plU6g9zpAdAKe9sXqvvCaTB34i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan-Marek Glogowski <glogow@fbihome.de>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 250/344] ALSA: hda/realtek - PCI quirk for Medion E4254
Date:   Thu,  3 Oct 2019 17:53:35 +0200
Message-Id: <20191003154605.125287747@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan-Marek Glogowski <glogow@fbihome.de>

[ Upstream commit bd9c10bc663dd2eaac8fe39dad0f18cd21527446 ]

The laptop has a combined jack to attach headsets on the right.
The BIOS encodes them as two different colored jacks at the front,
but otherwise it seems to be configured ok. But any adaption of
the pins config on its own doesn't fix the jack detection to work
in Linux. Still Windows works correct.

This is somehow fixed by chaining ALC256_FIXUP_ASUS_HEADSET_MODE,
which seems to register the microphone jack as a headset part and
also results in fixing jack sensing, visible in dmesg as:

-snd_hda_codec_realtek hdaudioC0D0:      Mic=0x19
+snd_hda_codec_realtek hdaudioC0D0:      Headset Mic=0x19

[ Actually the essential change is the location of the jack; the
  driver created "Front Mic Jack" without the matching volume / mute
  control element due to its jack location, which confused PA.
  -- tiwai ]

Signed-off-by: Jan-Marek Glogowski <glogow@fbihome.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/8f4f9b20-0aeb-f8f1-c02f-fd53c09679f1@fbihome.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d223a79ac934f..36aee8ad20547 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5870,6 +5870,7 @@ enum {
 	ALC256_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC299_FIXUP_PREDATOR_SPK,
 	ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC,
+	ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -6926,6 +6927,16 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
+	[ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x04a11040 },
+			{ 0x21, 0x04211020 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC256_FIXUP_ASUS_HEADSET_MODE
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7189,6 +7200,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
+	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
@@ -7357,6 +7369,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC295_FIXUP_CHROME_BOOK, .name = "alc-chrome-book"},
 	{.id = ALC299_FIXUP_PREDATOR_SPK, .name = "predator-spk"},
 	{.id = ALC298_FIXUP_HUAWEI_MBX_STEREO, .name = "huawei-mbx-stereo"},
+	{.id = ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE, .name = "alc256-medion-headset"},
 	{}
 };
 #define ALC225_STANDARD_PINS \
-- 
2.20.1



