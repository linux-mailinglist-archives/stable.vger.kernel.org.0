Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C78492A3B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346483AbiARQIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:08:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40564 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346512AbiARQIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:08:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33727CE1A33;
        Tue, 18 Jan 2022 16:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F90C00446;
        Tue, 18 Jan 2022 16:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522086;
        bh=2xQza8V2XZxAnYt5ayj48DYBcenqS6d9s9mwnGd0JR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jY/37jRj54fmCsq8Xm8hl+7pEo7NLiqtWYEYiVHx6L2UTVxa5nyZ2uM9J5mXXpnjo
         cbtT+x5w905B6JrZEC9Pe4KV5UjU/DnnFt1PMyEHsZ1jIV2oaHL54Sy96N4P0XJdI8
         qsPxM+stW5g3pQVCYFfkhUghoPzSHIkUJBdZxMXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baole Fang <fbl718@163.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 20/23] ALSA: hda/realtek: Add quirk for Legion Y9000X 2020
Date:   Tue, 18 Jan 2022 17:06:00 +0100
Message-Id: <20220118160451.922970258@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.233828401@linuxfoundation.org>
References: <20220118160451.233828401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baole Fang <fbl718@163.com>

commit 8f4c90427a8f0ca0fcdd89d8966fcdab35fb2d4c upstream.

Legion Y9000X 2020 has a speaker, but the speaker doesn't work.
This can be fixed by applying alc285_fixup_ideapad_s740_coef
to fix the speaker's coefficients.
Besides, to support the transition between the speaker and the headphone,
alc287_fixup_legion_15imhg05_speakers needs to be run.

Signed-off-by: Baole Fang <fbl718@163.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220105140856.4855-1-fbl718@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6757,6 +6757,8 @@ enum {
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
 	ALC233_FIXUP_NO_AUDIO_JACK,
 	ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME,
+	ALC285_FIXUP_LEGION_Y9000X_SPEAKERS,
+	ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE,
 };
 
 static const struct hda_fixup alc269_fixups[] = {
@@ -8347,6 +8349,18 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF,
 	},
+	[ALC285_FIXUP_LEGION_Y9000X_SPEAKERS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_ideapad_s740_coef,
+		.chained = true,
+		.chain_id = ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE,
+	},
+	[ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_legion_15imhg05_speakers,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_THINKPAD_ACPI,
+	},
 	[ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS] = {
 		.type = HDA_FIXUP_VERBS,
 		//.v.verbs = legion_15imhg05_coefs,
@@ -8887,6 +8901,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
+	SND_PCI_QUIRK(0x17aa, 0x3824, "Legion Y9000X 2020", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),


