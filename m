Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE1429B186
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902146AbgJ0ObB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759455AbgJ0OaK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:30:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDB3222202;
        Tue, 27 Oct 2020 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809010;
        bh=tCHkSlU2u/KOa8dHQ7vlo3kgVJEImYGOFcc+o9pRyKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yoof7dCwql+T2CLa4kg7NP6Sj8pRfxDHp8xNqR10qpoMdZjF0cPNC2xfv8XHyaatK
         rgbP0unvata2wvwGd891G7nU70W2mZJDTic4Fdc2vwDsEx13/8gR7jO05tsRoNUbsT
         +oMIbz8U8dIAlcwUrgMnRmfCLT9+tAIQrhbEJbc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 042/408] ALSA: hda/realtek - set mic to auto detect on a HP AIO machine
Date:   Tue, 27 Oct 2020 14:49:40 +0100
Message-Id: <20201027135457.030710677@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 13468bfa8c58731dc9ecda1cd9b22a191114f944 upstream.

Recently we enabled a HP AIO machine, we found the mic on the machine
couldn't record any sound and it couldn't detect plugging and
unplugging as well.

Through debugging we found the mic is set to manual detect mode, after
setting it to auto detect mode, it could detect plugging and
unplugging and could record sound.

Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200928080117.12435-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6216,6 +6216,7 @@ enum {
 	ALC269_FIXUP_LEMOTE_A190X,
 	ALC256_FIXUP_INTEL_NUC8_RUGGED,
 	ALC255_FIXUP_XIAOMI_HEADSET_MIC,
+	ALC274_FIXUP_HP_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7595,6 +7596,14 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC289_FIXUP_ASUS_GA401
 	},
+	[ALC274_FIXUP_HP_MIC] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x45 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x5089 },
+			{ }
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7746,6 +7755,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8729, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x874e, "HP", ALC274_FIXUP_HP_MIC),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
@@ -8071,6 +8081,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE, .name = "alc256-medion-headset"},
 	{.id = ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET, .name = "alc298-samsung-headphone"},
 	{.id = ALC255_FIXUP_XIAOMI_HEADSET_MIC, .name = "alc255-xiaomi-headset"},
+	{.id = ALC274_FIXUP_HP_MIC, .name = "alc274-hp-mic-detect"},
 	{}
 };
 #define ALC225_STANDARD_PINS \


