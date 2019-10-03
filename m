Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D214CA448
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389206AbfJCQXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390481AbfJCQXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:23:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43E9E21783;
        Thu,  3 Oct 2019 16:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119796;
        bh=6suo+Z3aj7Sg2Uc8YUHx3Plm8CYvVpCgbhvLq0ryHg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTRy9EfBPK7r3tSd9lyh0F9OeWZEu3hIy7BAF//tB7jttqgvlwDjQxPYp1NI3u3T5
         xWtu3xq/cRsGR0AUE3gsYw+5rGeVgi07YgN7kjIDpYFEJL6J3MnmxrRaz2IPbBA1nN
         W9MDnZnLduXt0br5oKxhP3izzmsfDRzrAZ8rtr/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan-Marek Glogowski <glogow@fbihome.de>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/211] ALSA: hda/realtek - PCI quirk for Medion E4254
Date:   Thu,  3 Oct 2019 17:53:45 +0200
Message-Id: <20191003154524.336232247@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
index e791379439be0..e1b08d6f2a519 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5679,6 +5679,7 @@ enum {
 	ALC256_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC299_FIXUP_PREDATOR_SPK,
 	ALC294_FIXUP_ASUS_INTSPK_HEADSET_MIC,
+	ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -6717,6 +6718,16 @@ static const struct hda_fixup alc269_fixups[] = {
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
@@ -6980,6 +6991,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MBXP", ALC256_FIXUP_HUAWEI_MBXP_PINS),
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
+	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
@@ -7144,6 +7156,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC255_FIXUP_DELL_HEADSET_MIC, .name = "alc255-dell-headset"},
 	{.id = ALC295_FIXUP_HP_X360, .name = "alc295-hp-x360"},
 	{.id = ALC299_FIXUP_PREDATOR_SPK, .name = "predator-spk"},
+	{.id = ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE, .name = "alc256-medion-headset"},
 	{}
 };
 #define ALC225_STANDARD_PINS \
-- 
2.20.1



