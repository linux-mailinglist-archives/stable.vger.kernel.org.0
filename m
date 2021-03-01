Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE3132876B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhCARXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:23:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237734AbhCARQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:16:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56F0F65041;
        Mon,  1 Mar 2021 16:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617160;
        bh=Q6MKNMoNasPyBgqi9r5mPcPs7EgxvEFvueDoTVIccI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgrQT3SwJOStsds9PWXI72Xk5M3p9HwyzTIkqjzTqzry6FWCdf7gmi2gfSz/kpoMA
         7wU7rrETvX/II7cNnBzwifgW0DboMD7+vdIJDUpP1TXKp1sqrIOrISJAOkw8GNTGR5
         2FNiKrNG9vU2lwcAP4sYOmZT7xJSLOJ94yg9weXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, PeiSen Hou <pshou@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 193/247] ALSA: hda/realtek: modify EAPD in the ALC886
Date:   Mon,  1 Mar 2021 17:13:33 +0100
Message-Id: <20210301161041.106146086@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: PeiSen Hou <pshou@realtek.com>

commit 4841b8e6318a7f0ae57c4e5ec09032ea057c97a8 upstream.

Modify 0x20 index 7 bit 5 to 1, make the 0x15 EAPD the same as 0x14.

Signed-off-by: PeiSen Hou <pshou@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/e62c5058957f48d8b8953e97135ff108@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -1880,6 +1880,7 @@ enum {
 	ALC889_FIXUP_FRONT_HP_NO_PRESENCE,
 	ALC889_FIXUP_VAIO_TT,
 	ALC888_FIXUP_EEE1601,
+	ALC886_FIXUP_EAPD,
 	ALC882_FIXUP_EAPD,
 	ALC883_FIXUP_EAPD,
 	ALC883_FIXUP_ACER_EAPD,
@@ -2213,6 +2214,15 @@ static const struct hda_fixup alc882_fix
 			{ }
 		}
 	},
+	[ALC886_FIXUP_EAPD] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* change to EAPD mode */
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x07 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x0068 },
+			{ }
+		}
+	},
 	[ALC882_FIXUP_EAPD] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -2485,6 +2495,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x106b, 0x4a00, "Macbook 5,2", ALC889_FIXUP_MBA11_VREF),
 
 	SND_PCI_QUIRK(0x1071, 0x8258, "Evesham Voyaeger", ALC882_FIXUP_EAPD),
+	SND_PCI_QUIRK(0x13fe, 0x1009, "Advantech MIT-W101", ALC886_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte EP45-DS3/Z87X-UD3H", ALC889_FIXUP_FRONT_HP_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1458, 0xa0b8, "Gigabyte AZ370-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1458, 0xa0cd, "Gigabyte X570 Aorus Master", ALC1220_FIXUP_CLEVO_P950),


