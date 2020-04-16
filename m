Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93401AC7C3
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394861AbgDPO6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409111AbgDPNzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:55:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D99E920732;
        Thu, 16 Apr 2020 13:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045305;
        bh=nJdRoDoxFz3pSFS9qZM5LkWIVbVtBTHPKmC7MDR6Yj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k1Y9KrWinsd3awIhB42jIgK8UQcximpFk/L5YCDM/Hl6WRzFB7SkqI3AxxTf2kXcl
         Qvnar7mpT1AqVAFepvNi1nZvQ83edc0mv88gpHJ7eA33Zfx6V/B0gJm29Ib0hnfqqh
         oNJ2vRwt6yhFGtWISXZqUzjCRGBaYbv8d2XQMldk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 080/254] ALSA: hda/realtek - Set principled PC Beep configuration for ALC256
Date:   Thu, 16 Apr 2020 15:22:49 +0200
Message-Id: <20200416131335.904189603@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hebb <tommyhebb@gmail.com>

commit c44737449468a0bdc50e09ec75e530f208391561 upstream.

The Realtek PC Beep Hidden Register[1] is currently set by
patch_realtek.c in two different places:

In alc_fill_eapd_coef(), it's set to the value 0x5757, corresponding to
non-beep input on 1Ah and no 1Ah loopback to either headphones or
speakers. (Although, curiously, the loopback amp is still enabled.) This
write was added fairly recently by commit e3743f431143 ("ALSA:
hda/realtek - Dell headphone has noise on unmute for ALC236") and is a
safe default. However, it happens in the wrong place:
alc_fill_eapd_coef() runs on module load and cold boot but not on S3
resume, meaning the register loses its value after suspend.

Conversely, in alc256_init(), the register is updated to unset bit 13
(disable speaker loopback) and set bit 5 (set non-beep input on 1Ah).
Although this write does run on S3 resume, it's not quite enough to fix
up the register's default value of 0x3717. What's missing is a set of
bit 14 to disable headphone loopback. Without that, we end up with a
feedback loop where the headphone jack is being driven by amplified
samples of itself[2].

This change eliminates the update in alc256_init() and replaces it with
the 0x5757 write from alc_fill_eapd_coef(). Kailang says that 0x5757 is
supposed to be the codec's default value, so using it will make
debugging easier for Realtek.

Affects the ALC255, ALC256, ALC257, ALC235, and ALC236 codecs.

[1] Newly documented in Documentation/sound/hd-audio/realtek-pc-beep.rst

[2] Setting the "Headphone Mic Boost" control from userspace changes
this feedback loop and has been a widely-shared workaround for headphone
noise on laptops like the Dell XPS 13 9350. This commit eliminates the
feedback loop and makes the workaround unnecessary.

Fixes: e1e8c1fdce8b ("ALSA: hda/realtek - Dell headphone has noise on unmute for ALC236")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
Link: https://lore.kernel.org/r/bf22b417d1f2474b12011c2a39ed6cf8b06d3bf5.1585584498.git.tommyhebb@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -368,7 +368,9 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0215:
 	case 0x10ec0233:
 	case 0x10ec0235:
+	case 0x10ec0236:
 	case 0x10ec0255:
+	case 0x10ec0256:
 	case 0x10ec0257:
 	case 0x10ec0282:
 	case 0x10ec0283:
@@ -380,11 +382,6 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0300:
 		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
 		break;
-	case 0x10ec0236:
-	case 0x10ec0256:
-		alc_write_coef_idx(codec, 0x36, 0x5757);
-		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
-		break;
 	case 0x10ec0275:
 		alc_update_coef_idx(codec, 0xe, 0, 1<<0);
 		break;
@@ -3371,7 +3368,13 @@ static void alc256_init(struct hda_codec
 	alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
 	alc_update_coefex_idx(codec, 0x53, 0x02, 0x8000, 1 << 15); /* Clear bit */
 	alc_update_coefex_idx(codec, 0x53, 0x02, 0x8000, 0 << 15);
-	alc_update_coef_idx(codec, 0x36, 1 << 13, 1 << 5); /* Switch pcbeep path to Line in path*/
+	/*
+	 * Expose headphone mic (or possibly Line In on some machines) instead
+	 * of PC Beep on 1Ah, and disable 1Ah loopback for all outputs. See
+	 * Documentation/sound/hd-audio/realtek-pc-beep.rst for details of
+	 * this register.
+	 */
+	alc_write_coef_idx(codec, 0x36, 0x5757);
 }
 
 static void alc256_shutup(struct hda_codec *codec)


