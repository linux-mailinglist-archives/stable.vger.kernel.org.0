Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF4137C125
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhELO46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232195AbhELOzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:55:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80A93613C7;
        Wed, 12 May 2021 14:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831276;
        bh=s9PhOgwY/7G94s+VyZ8r1O0tsIpwRiT46UY9AoN7Iv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lp6nadyax2HqKhuqlBjP4uhVmvLKPb9Wr7sBWJQPgrgKJ4r7Z6oM4zlh/zeBnu8X
         kFEIhfiwgx88DjMEAAzRKnvNEkyKSt1s5V6I5lLBNz6d9ZBumV9fnCqRjziHsZ1qnS
         XFABtwRFYZr3n/ikoKejGsFFvIWPjO0hioZMlRoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sami Loone <sami@loone.fi>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 055/244] ALSA: hda/realtek: ALC285 Thinkpad jack pin quirk is unreachable
Date:   Wed, 12 May 2021 16:47:06 +0200
Message-Id: <20210512144744.807327070@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Loone <sami@loone.fi>

commit 266fd994b2b0ab7ba3e5541868838ce30775964b upstream.

In 9bbb94e57df1 ("ALSA: hda/realtek: fix static noise on ALC285 Lenovo
laptops") an existing Lenovo quirk was made more generic by removing a
0x12 pin requirement from the entry. This made the second chance table
Thinkpad jack entry unreachable as the pin configurations became
identical.

Revert the 0x12 pin requirement removal and move Thinkpad jack pin quirk
back to the primary pin table as they can co-exist when more specific
configurations come first.

Add a more targeted pin quirk for Lenovo devices that have 0x12 as
0x40000000.

Tested on Yoga 6 (AMD) laptop.

[ Corrected the commit ID -- tiwai ]

Fixes: 9bbb94e57df1 ("ALSA: hda/realtek: fix static noise on ALC285 Lenovo laptops")
Signed-off-by: Sami Loone <sami@loone.fi>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YI0oefvTYn8URYDb@yoga
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8598,6 +8598,16 @@ static const struct snd_hda_pin_quirk al
 		{0x19, 0x03a11020},
 		{0x21, 0x0321101f}),
 	SND_HDA_PIN_QUIRK(0x10ec0285, 0x17aa, "Lenovo", ALC285_FIXUP_LENOVO_PC_BEEP_IN_NOISE,
+		{0x12, 0x90a60130},
+		{0x14, 0x90170110},
+		{0x19, 0x04a11040},
+		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0285, 0x17aa, "Lenovo", ALC285_FIXUP_LENOVO_PC_BEEP_IN_NOISE,
+		{0x14, 0x90170110},
+		{0x19, 0x04a11040},
+		{0x1d, 0x40600001},
+		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0285, 0x17aa, "Lenovo", ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
 		{0x14, 0x90170110},
 		{0x19, 0x04a11040},
 		{0x21, 0x04211020}),
@@ -8765,10 +8775,6 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0236, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
 		{0x19, 0x40000000},
 		{0x1a, 0x40000000}),
-	SND_HDA_PIN_QUIRK(0x10ec0285, 0x17aa, "Lenovo", ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
-		{0x14, 0x90170110},
-		{0x19, 0x04a11040},
-		{0x21, 0x04211020}),
 	{}
 };
 


