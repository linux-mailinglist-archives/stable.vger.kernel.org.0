Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FA21D8521
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731221AbgERSQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731839AbgERR56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:57:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDC19207D3;
        Mon, 18 May 2020 17:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824677;
        bh=cvbtxXlXqYT9A0rzrZXO1xQptHHKJaTUxuVCqN0281E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXcZeMK1HWjK7VgoW1X75HTWqrVDXHerLlNCBniGgOaGC7I75Vx/3r0feoxfkbuvx
         Isk3C2ixCI2aCSCOaCHIB0c96eAKjDCRKo/b1RRmYofNwrQ+5XjHqe2m6+erjy+wd0
         XQtm0Ro1win2bATuAKMBgUscim2cgEwb+8eoMvpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 106/147] ALSA: hda/realtek - Add COEF workaround for ASUS ZenBook UX431DA
Date:   Mon, 18 May 2020 19:37:09 +0200
Message-Id: <20200518173526.470192086@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 1b94e59d30afecf18254ad413e953e7587645a20 upstream.

ASUS ZenBook UX431DA requires an additional COEF setup when booted
from the recent Windows 10, otherwise it produces the noisy output.
The quirk turns on COEF 0x1b bit 10 that has been cleared supposedly
due to the pop noise reduction.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=207553
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20200512073203.14091-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5978,6 +5978,7 @@ enum {
 	ALC294_FIXUP_ASUS_DUAL_SPK,
 	ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	ALC294_FIXUP_ASUS_HPE,
+	ALC294_FIXUP_ASUS_COEF_1B,
 	ALC285_FIXUP_HP_GPIO_LED,
 };
 
@@ -7112,6 +7113,17 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC294_FIXUP_ASUS_HEADSET_MIC
 	},
+	[ALC294_FIXUP_ASUS_COEF_1B] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* Set bit 10 to correct noisy output after reboot from
+			 * Windows 10 (due to pop noise reduction?)
+			 */
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x1b },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x4e4b },
+			{ }
+		},
+	},
 	[ALC285_FIXUP_HP_GPIO_LED] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_gpio_led,
@@ -7283,6 +7295,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x1a30, "ASUS X705UD", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1b11, "ASUS UX431DA", ALC294_FIXUP_ASUS_COEF_1B),
 	SND_PCI_QUIRK(0x1043, 0x1b13, "Asus U41SV", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1bbd, "ASUS Z550MA", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


