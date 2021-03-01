Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5FD328946
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbhCARxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:53:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238204AbhCARrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:47:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3B4A64F29;
        Mon,  1 Mar 2021 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617948;
        bh=542EY6wG5otzldyltefMfCOpgdz76crUlfgWAC704zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mqw0i3YJIzV6zLRjtyKKfem3YUVkdfJm++j3l4Q29aBuQoboydodSatGu5ZD4TzKM
         NyAdNCzvYhwMdCOK9Gu7YQQfz5/U32+qhFShTWxu140n6hIr12MjGQnEBdhIQiY2Me
         93B9oK1vG4rxeUKO0X1KCoiOeHYK7L/83S8MvJ6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, PeiSen Hou <pshou@realtek.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 253/340] ALSA: hda/realtek: modify EAPD in the ALC886
Date:   Mon,  1 Mar 2021 17:13:17 +0100
Message-Id: <20210301161100.748010914@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
@@ -1895,6 +1895,7 @@ enum {
 	ALC889_FIXUP_FRONT_HP_NO_PRESENCE,
 	ALC889_FIXUP_VAIO_TT,
 	ALC888_FIXUP_EEE1601,
+	ALC886_FIXUP_EAPD,
 	ALC882_FIXUP_EAPD,
 	ALC883_FIXUP_EAPD,
 	ALC883_FIXUP_ACER_EAPD,
@@ -2228,6 +2229,15 @@ static const struct hda_fixup alc882_fix
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
@@ -2500,6 +2510,7 @@ static const struct snd_pci_quirk alc882
 	SND_PCI_QUIRK(0x106b, 0x4a00, "Macbook 5,2", ALC889_FIXUP_MBA11_VREF),
 
 	SND_PCI_QUIRK(0x1071, 0x8258, "Evesham Voyaeger", ALC882_FIXUP_EAPD),
+	SND_PCI_QUIRK(0x13fe, 0x1009, "Advantech MIT-W101", ALC886_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte EP45-DS3/Z87X-UD3H", ALC889_FIXUP_FRONT_HP_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1458, 0xa0b8, "Gigabyte AZ370-Gaming", ALC1220_FIXUP_GB_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1458, 0xa0cd, "Gigabyte X570 Aorus Master", ALC1220_FIXUP_CLEVO_P950),


