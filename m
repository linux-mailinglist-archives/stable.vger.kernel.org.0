Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCB049468
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbfFQVSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:18:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbfFQVSk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:18:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C65E2208E4;
        Mon, 17 Jun 2019 21:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806320;
        bh=Git62G+Dc/gHVtT35dLHYmibJOb6VJd1X3v/wcuiWBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0I91ywLGQwFEmPeZf62gU01YEyT4Rwr6trYmRb/z/4Onij32FROSr8aNJuK3B9CJ
         QiRIae+kq3QuORWLqGsSJYYKmgtaL3eTr01HbbrWIOteGyiPHo9+RGcFPXUtS0ITmU
         JEofo3OmdbvDuMZ7aGhlYdHbKvk/pXnCS8x3kAkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 012/115] Revert "ALSA: hda/realtek - Improve the headset mic for Acer Aspire laptops"
Date:   Mon, 17 Jun 2019 23:08:32 +0200
Message-Id: <20190617210800.542566101@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 17d304604a88cf20c8dfd2c95d3decb9c4f8bca4 upstream.

This reverts commit 9cb40eb184c4220d244a532bd940c6345ad9dbd9.

This patch introduces noise and headphone playback issue after
rebooting or suspending/resuming. Let us revert it.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=203831
Fixes: 9cb40eb184c4 ("ALSA: hda/realtek - Improve the headset mic for Acer Aspire laptops")
Cc: <stable@vger.kernel.org>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6166,15 +6166,13 @@ static const struct hda_fixup alc269_fix
 		.chain_id = ALC269_FIXUP_THINKPAD_ACPI,
 	},
 	[ALC255_FIXUP_ACER_MIC_NO_PRESENCE] = {
-		.type = HDA_FIXUP_VERBS,
-		.v.verbs = (const struct hda_verb[]) {
-			/* Enable the Mic */
-			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x45 },
-			{ 0x20, AC_VERB_SET_PROC_COEF, 0x5089 },
-			{}
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
 		},
 		.chained = true,
-		.chain_id = ALC269_FIXUP_LIFEBOOK_EXTMIC
+		.chain_id = ALC255_FIXUP_HEADSET_MODE
 	},
 	[ALC255_FIXUP_ASUS_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
@@ -7220,10 +7218,6 @@ static const struct snd_hda_pin_quirk al
 		{0x19, 0x0181303F},
 		{0x21, 0x0221102f}),
 	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1025, "Acer", ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
-		{0x12, 0x90a60140},
-		{0x14, 0x90170120},
-		{0x21, 0x02211030}),
-	SND_HDA_PIN_QUIRK(0x10ec0255, 0x1025, "Acer", ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
 		{0x12, 0x90a601c0},
 		{0x14, 0x90171120},
 		{0x21, 0x02211030}),


