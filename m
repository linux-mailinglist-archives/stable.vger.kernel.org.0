Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75D5532DFE
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 18:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbiEXP7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 11:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239182AbiEXP7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 11:59:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1841A9968A;
        Tue, 24 May 2022 08:59:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD258B81A3A;
        Tue, 24 May 2022 15:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B21DC34113;
        Tue, 24 May 2022 15:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653407981;
        bh=jN+1HIsiA3bRhuPvFKVuv5fZquiqYbHfsKIPAUjrDbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ManMZzIA6Ikh7C3injz4DLATRPTGi8MAIMz0K+5JW+lnlbOXf5QnY3wHnJTZjkLBX
         8mmsJnX1RV1jjaWAkx0ACmFOg3WPIZH1I5MiD01ELbjgamt7yOQBelHFH62IN2iB9y
         sYwF93E3V+kGR3Ayyc3XXW5iPAXZoQy+h1s557iifPx6YQ7fZOYWW9F4mx2CU60vXs
         dQ2DhO9XkhOsfVlKxOFil1mx7qas7o2x6tRePGOxe/t4nGMy+MtyJ68gkdsBWLYpxJ
         bH9/6wSWeNq3nP0M8qqS3efLCaKKLoMwOtCcVzZi1HBp7S2Q8KoqOoMPNX/TsN27UY
         e+5hmydhDVvZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Dustin L. Howett" <dustin@howett.net>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        perex@perex.cz, tiwai@suse.com, jeremy.szu@canonical.com,
        wse@tuxedocomputers.com, kai.heng.feng@canonical.com,
        andy.chi@canonical.com, tanureal@opensource.cirrus.com,
        cam@neo-zeon.de, kailang@realtek.com, yong.wu@mediatek.com,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.17 03/12] ALSA: hda/realtek: Add quirk for the Framework Laptop
Date:   Tue, 24 May 2022 11:59:17 -0400
Message-Id: <20220524155929.826793-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524155929.826793-1-sashal@kernel.org>
References: <20220524155929.826793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Dustin L. Howett" <dustin@howett.net>

[ Upstream commit 309d7363ca3d9fcdb92ff2d958be14d7e8707f68 ]

Some board revisions of the Framework Laptop have an ALC295 with a
disconnected or faulty headset mic presence detect.

The "dell-headset-multi" fixup addresses this issue, but also enables an
inoperative "Headphone Mic" input device whenever a headset is
connected.

Adding a new quirk chain specific to the Framework Laptop resolves this
issue. The one introduced here is based on the System76 "no headphone
mic" quirk chain.

The VID:PID f111:0001 have been allocated to Framework Computer for this
board revision.

Revision history:
- v2: Moved to a custom quirk chain to suppress the "Headphone Mic"
  pincfg.

Signed-off-by: Dustin L. Howett <dustin@howett.net>
Link: https://lore.kernel.org/r/20220511010759.3554-1-dustin@howett.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8425eadf6873..18af98d18b6e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7038,6 +7038,7 @@ enum {
 	ALC287_FIXUP_LEGION_16ACHG6,
 	ALC287_FIXUP_CS35L41_I2C_2,
 	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
+	ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8814,6 +8815,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 	},
+	[ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x02a1112c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -9286,6 +9296,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
+	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
-- 
2.35.1

