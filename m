Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D689A272E47
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgIUQrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:47:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbgIUQrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28F412388B;
        Mon, 21 Sep 2020 16:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706859;
        bh=S9Rltckgd2kCsmJjdKHLsa9YQCbfkNnbJQ2DlHDG8/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rf2yDP9LfiHcIFydCYzVF6OkOWNwg8YhBPYDjysIkkJNYaDS9CydbIG+2+pW1xOA7
         HeQAa4Rt5KCm70YhLK+V54pfIZRE0i8ks2GpDzQMUemHVks3u0Yt2DONgRf7mVFgOz
         OmYdLwh91KVV1P+3cfVFEqlJBG8bkeJwYhCFkwyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 094/118] ALSA: hda/realtek - The Mic on a RedmiBook doesnt work
Date:   Mon, 21 Sep 2020 18:28:26 +0200
Message-Id: <20200921162040.726198426@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit fc19d559b0d31b5b831fd468b10d7dadafc0d0ec upstream.

The Mic connects to the Nid 0x19, but the configuration of Nid 0x19
is not defined to Mic, and also need to set the coeff to enable the
auto detection on the Nid 0x19. After this change, the Mic plugging
in or plugging out could be detected and could record the sound from
the Mic.

And the coeff value is suggested by Kailang of Realtek.

Cc: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Link: https://lore.kernel.org/r/20200909020041.8967-1-hui.wang@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6239,6 +6239,7 @@ enum {
 	ALC269_FIXUP_LEMOTE_A1802,
 	ALC269_FIXUP_LEMOTE_A190X,
 	ALC256_FIXUP_INTEL_NUC8_RUGGED,
+	ALC255_FIXUP_XIAOMI_HEADSET_MIC,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7602,6 +7603,16 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE
 	},
+	[ALC255_FIXUP_XIAOMI_HEADSET_MIC] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x45 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x5089 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC289_FIXUP_ASUS_GA401
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7899,6 +7910,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1b35, 0x1236, "CZC TMI", ALC269_FIXUP_CZC_TMI),
 	SND_PCI_QUIRK(0x1b35, 0x1237, "CZC L101", ALC269_FIXUP_CZC_L101),
 	SND_PCI_QUIRK(0x1b7d, 0xa831, "Ordissimo EVE2 ", ALC269VB_FIXUP_ORDISSIMO_EVE2), /* Also known as Malata PC-B1303 */
+	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1c06, 0x2013, "Lemote A1802", ALC269_FIXUP_LEMOTE_A1802),
@@ -8076,6 +8088,7 @@ static const struct hda_model_fixup alc2
 	{.id = ALC298_FIXUP_HUAWEI_MBX_STEREO, .name = "huawei-mbx-stereo"},
 	{.id = ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE, .name = "alc256-medion-headset"},
 	{.id = ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET, .name = "alc298-samsung-headphone"},
+	{.id = ALC255_FIXUP_XIAOMI_HEADSET_MIC, .name = "alc255-xiaomi-headset"},
 	{}
 };
 #define ALC225_STANDARD_PINS \


