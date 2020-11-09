Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC662ABBAF
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730463AbgKIN3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730765AbgKINMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:12:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87D6E20867;
        Mon,  9 Nov 2020 13:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927545;
        bh=3KOHxWfqwNpvSqa3CAuGCSzWZgEIjpan4KRo38BIB2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vry8VNxy3PFKwSuVVM6rB6CXKW15UQqgQmQcJSpUsR2nCs447VcMw5907M/7nVJNJ
         OIZBCfbsFjPqi0XyZgi+AS8Y+Y0MVrvwz/9p6G6nvnX2lD7sflo7EmQqCSpRZ5034O
         schuZlv5HpW1e3BUVb0dkMxxSxiwwYIQNdjCneAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kailang Yang <kailang@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 24/85] ALSA: hda/realtek - Enable headphone for ASUS TM420
Date:   Mon,  9 Nov 2020 13:55:21 +0100
Message-Id: <20201109125023.736816821@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kailang Yang <kailang@realtek.com>

commit ef9ce66fab959c66d270bbee7ca79b92ee957893 upstream.

ASUS TM420 had depop circuit for headphone.
It need to turn on by COEF bit.

[ fixed the missing enum definition by tiwai ]

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/3d6177d7023b4783bf2793861c577ada@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6282,6 +6282,7 @@ enum {
 	ALC255_FIXUP_XIAOMI_HEADSET_MIC,
 	ALC274_FIXUP_HP_MIC,
 	ALC274_FIXUP_HP_HEADSET_MIC,
+	ALC256_FIXUP_ASUS_HPE,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -7675,6 +7676,17 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC274_FIXUP_HP_MIC
 	},
+	[ALC256_FIXUP_ASUS_HPE] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* Set EAPD high */
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x0f },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x7778 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC294_FIXUP_ASUS_HEADSET_MIC
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -7858,6 +7870,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1bbd, "ASUS Z550MA", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),


