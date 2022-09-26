Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F795EA090
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236133AbiIZKkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236417AbiIZKjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:39:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B96A4D148;
        Mon, 26 Sep 2022 03:23:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7D6360BAF;
        Mon, 26 Sep 2022 10:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7424C433C1;
        Mon, 26 Sep 2022 10:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187792;
        bh=X04OHgw+DxFh+oL/0lcLqlkZcBZ0P4XflcwcsMPbMzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FD6cGMiMdymPe18QksTx3ACSwSQNmQVM3Uk44I+X/nmLA1yborAOZuSjlMGBeKZz6
         muEznz9MEfXGl4m7+ARMME6+HJI8KlEiZWXBdMetRg/7uhDUbzJVBY7MyHdP3lEWo4
         T2VUgvHETCYeq1nWUWZJr26RxuCD+JbkoJAM8+Ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Luke D. Jones" <luke@ljones.dev>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 061/120] ALSA: hda/realtek: Add pincfg for ASUS G533Z HP jack
Date:   Mon, 26 Sep 2022 12:11:34 +0200
Message-Id: <20220926100753.184087346@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke D. Jones <luke@ljones.dev>

commit bc2c23549ccd7105eb6ff0d4f0ac519285628673 upstream.

Fixes up the pincfg for ASUS ROG Strix G15 (G533Z) headphone combo jack

[ Fixed the position in the quirk table by tiwai ]

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220915080921.35563-3-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6485,6 +6485,7 @@ enum {
 	ALC294_FIXUP_ASUS_GU502_PINS,
 	ALC294_FIXUP_ASUS_GU502_VERBS,
 	ALC294_FIXUP_ASUS_G513_PINS,
+	ALC285_FIXUP_ASUS_G533Z_PINS,
 	ALC285_FIXUP_HP_GPIO_LED,
 	ALC285_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_GPIO_LED,
@@ -7771,6 +7772,15 @@ static const struct hda_fixup alc269_fix
 				{ }
 		},
 	},
+	[ALC285_FIXUP_ASUS_G533Z_PINS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x90170120 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_G513_PINS,
+	},
 	[ALC294_FIXUP_ASUS_COEF_1B] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -8258,6 +8268,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1b13, "Asus U41SV", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1bbd, "ASUS Z550MA", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x1c92, "ASUS ROG Strix G15", ALC285_FIXUP_ASUS_G533Z_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),


