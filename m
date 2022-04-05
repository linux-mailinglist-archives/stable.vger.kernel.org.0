Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810CB4F3528
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbiDEImK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238693AbiDEIax (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:30:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5A5340DB;
        Tue,  5 Apr 2022 01:22:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FB7AB81BC0;
        Tue,  5 Apr 2022 08:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB8CC385A0;
        Tue,  5 Apr 2022 08:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146957;
        bh=XBhe4vqBgXyB671ZuqpkXp89YqTRRxpxJDnJqlGK3kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmDR8AUDML6Gt+LqqsrfMTxnV3TNV904R1h23DxJQs9YB8QGgtwAu0J0hOkH7xEpA
         zd+W8sc6f0S2EA5ERNt0ucIV6sbLmslsirTs/Ovdp8rzgjvd6HjJcXRbB2zPbhCZcA
         41RXVFk/c0M3mIyewgQoCWi0hvRrNu6I30/8Ta1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Kramer <mccleetus@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0949/1126] ALSA: hda/realtek: Add alc256-samsung-headphone fixup
Date:   Tue,  5 Apr 2022 09:28:16 +0200
Message-Id: <20220405070435.360633407@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Matt Kramer <mccleetus@gmail.com>

[ Upstream commit ef248d9bd616b04df8be25539a4dc5db4b6c56f4 ]

This fixes the near-silence of the headphone jack on the ALC256-based
Samsung Galaxy Book Flex Alpha (NP730QCJ). The magic verbs were found
through trial and error, using known ALC298 hacks as inspiration. The
fixup is auto-enabled only when the NP730QCJ is detected. It can be
manually enabled using model=alc256-samsung-headphone.

Signed-off-by: Matt Kramer <mccleetus@gmail.com>
Link: https://lore.kernel.org/r/3168355.aeNJFYEL58@linus
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/sound/hd-audio/models.rst |  4 ++++
 sound/pci/hda/patch_realtek.c           | 11 +++++++++++
 2 files changed, 15 insertions(+)

diff --git a/Documentation/sound/hd-audio/models.rst b/Documentation/sound/hd-audio/models.rst
index d25335993e55..9b52f50a6854 100644
--- a/Documentation/sound/hd-audio/models.rst
+++ b/Documentation/sound/hd-audio/models.rst
@@ -261,6 +261,10 @@ alc-sense-combo
 huawei-mbx-stereo
     Enable initialization verbs for Huawei MBX stereo speakers;
     might be risky, try this at your own risk
+alc298-samsung-headphone
+    Samsung laptops with ALC298
+alc256-samsung-headphone
+    Samsung laptops with ALC256
 
 ALC66x/67x/892
 ==============
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6ff41d9b5bc9..16e90524a497 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6948,6 +6948,7 @@ enum {
 	ALC236_FIXUP_HP_MUTE_LED,
 	ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
 	ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
+	ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
 	ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS,
 	ALC269VC_FIXUP_ACER_HEADSET_MIC,
@@ -8273,6 +8274,14 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		},
 	},
+	[ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x08},
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x2fcf},
+			{ }
+		},
+	},
 	[ALC295_FIXUP_ASUS_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -9054,6 +9063,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
@@ -9400,6 +9410,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC298_FIXUP_HUAWEI_MBX_STEREO, .name = "huawei-mbx-stereo"},
 	{.id = ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE, .name = "alc256-medion-headset"},
 	{.id = ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET, .name = "alc298-samsung-headphone"},
+	{.id = ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET, .name = "alc256-samsung-headphone"},
 	{.id = ALC255_FIXUP_XIAOMI_HEADSET_MIC, .name = "alc255-xiaomi-headset"},
 	{.id = ALC274_FIXUP_HP_MIC, .name = "alc274-hp-mic-detect"},
 	{.id = ALC245_FIXUP_HP_X360_AMP, .name = "alc245-hp-x360-amp"},
-- 
2.34.1



