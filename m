Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B95E599FF2
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350252AbiHSPse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350007AbiHSPrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:47:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE03032ECB;
        Fri, 19 Aug 2022 08:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FB7E6155B;
        Fri, 19 Aug 2022 15:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C98CC433C1;
        Fri, 19 Aug 2022 15:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924021;
        bh=bVdV2IaOJZiYym9Utx4P+nilV1ARj7FTyml6N7fr7h8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfW401Ldwl8LpuD4+DKRfN+8oNHdL5bqjk7D05v6CwXNUe3+QHRZRSIkHu+DWuMqp
         MB4jW1buqCUH0YguYUpGILFAwVhygeet+F2CJoT1ntYgQQPmQiqen3Ux3JAcZjZflO
         CXXVitZi63jUaBWaIIhWv+NPr0BD+/+ZrvQ6ZJaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 029/545] ALSA: hda/realtek: Add quirk for another Asus K42JZ model
Date:   Fri, 19 Aug 2022 17:36:39 +0200
Message-Id: <20220819153830.498879773@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meng Tang <tangmeng@uniontech.com>

commit f882c4bef9cb914d9f7be171afb10ed26536bfa7 upstream.

There is another Asus K42JZ model with the PCI SSID 1043:1313
that requires the quirk ALC269VB_FIXUP_ASUS_MIC_NO_PRESENCE.
Add the corresponding entry to the quirk table.

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220805074534.20003-1-tangmeng@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6666,6 +6666,7 @@ enum {
 	ALC269_FIXUP_LIMIT_INT_MIC_BOOST,
 	ALC269VB_FIXUP_ASUS_ZENBOOK,
 	ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A,
+	ALC269VB_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED,
 	ALC269VB_FIXUP_ORDISSIMO_EVE2,
 	ALC283_FIXUP_CHROME_BOOK,
@@ -7241,6 +7242,15 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269VB_FIXUP_ASUS_ZENBOOK,
 	},
+	[ALC269VB_FIXUP_ASUS_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x18, 0x01a110f0 },  /* use as headset mic */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_HEADSET_MIC
+	},
 	[ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc269_fixup_limit_int_mic_boost,
@@ -8848,6 +8858,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x12a0, "ASUS X441UV", ALC233_FIXUP_EAPD_COEF_AND_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x12e0, "ASUS X541SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x12f0, "ASUS X541UV", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1313, "Asus K42JZ", ALC269VB_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x13b0, "ASUS Z550SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),


