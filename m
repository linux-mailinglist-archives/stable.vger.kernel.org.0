Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0925F29BC
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiJCHYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiJCHXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:23:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D441342ACF;
        Mon,  3 Oct 2022 00:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1694B80E81;
        Mon,  3 Oct 2022 07:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A1FC433D7;
        Mon,  3 Oct 2022 07:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781461;
        bh=5dWP7lw1Qow/y37RCWa0fod+8ef29E1Bg24Jjgp5cyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJRlikeDHG/gGUhNaMVMfhHtQB5ozEXZVMnTkyJETtk7gTtQZkPkRdqPMbeJULMgf
         rky4YaylMiSkZM2KdQThmIp3hn9MC7S6IwBPoz5/Pqy5Ut2TjOro+t43gG6UbXN0ig
         F/ovOYnQSXHs5IkwnENJujFQro64AWuDkXWP0PAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Sergeyev <sergeev917@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/83] ALSA: hda/realtek: fix speakers and micmute on HP 855 G8
Date:   Mon,  3 Oct 2022 09:10:29 +0200
Message-Id: <20221003070722.090573944@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sergeyev <sergeev917@gmail.com>

[ Upstream commit 91502a9a0b0d5252cf3f32ebd898823c2f5aadab ]

There are several PCI ids associated with HP EliteBook 855 G8 Notebook
PC. Commit 0e68c4b11f1e6 ("ALSA: hda/realtek: fix mute/micmute LEDs for
HP 855 G8") covers 0x103c:0x8896, while this commit covers 0x103c:0x8895
which needs some additional work on top of the quirk from 0e68c4b11f1e6.

Note that the device can boot up with working speakers and micmute LED
without this patch, but the success rate would be quite low (order of
16 working boots across 709 boots) at least for the built-in drivers
scenario. This also means that there are some timing issues during early
boot and this patch is a workaround.

With this patch applied speakers and headphones are consistenly working,
as well as mute/micmute LEDs and the internal microphone.

Signed-off-by: Alexander Sergeyev <sergeev917@gmail.com>
Link: https://lore.kernel.org/r/20220114165050.ouw2nknuspclynro@localhost.localdomain
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 496322302bf1 ("ALSA: hda/realtek: Add a quirk for HP OMEN 16 (8902) mute LED")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c4b3f2d3c7e3..f7b6a516439d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6939,6 +6939,7 @@ enum {
 	ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME,
 	ALC285_FIXUP_LEGION_Y9000X_SPEAKERS,
 	ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE,
+	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -8753,6 +8754,16 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
+	[ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x19 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x8e11 },
+			 { }
+		},
+		.chained = true,
+		.chain_id = ALC285_FIXUP_HP_MUTE_LED,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8976,6 +8987,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8870, "HP ZBook Fury 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x888d, "HP ZBook Power 15.6 inch G8 Mobile Workstation PC", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8895, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.35.1



