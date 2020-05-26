Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B553D1CB012
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgEHMiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728324AbgEHMiH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D11521473;
        Fri,  8 May 2020 12:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941486;
        bh=DnJXK4M1+lsiv3qsk+K5UqpQ39hqEl794wN5A0h2n4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2JRz2WeaIiLxRy0of/aT8NKMgbWiJcPzwChzsX7CPbAayOxCnopCSBbhAuIjqPLZ
         wGvl5GOoCDwMyR/0rVPMNb4AVE0i3yqBjuHuv8cfM47wNq/UxXy9+/sRwO0sRJTAWE
         yQ/34hK1OhSYNE1jPbb5R9lLkcVWMA1Zy0mDbc+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 050/312] ALSA: fm801: detect FM-only card earlier
Date:   Fri,  8 May 2020 14:30:41 +0200
Message-Id: <20200508123128.071772251@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit b56fa687e02b27f8bd9d282950a88c2ed23d766b upstream.

If user does not supply tea575x_tuner parameter the driver tries to detect the
tuner type. The failed codec initialization is considered as FM-only card
present, however the driver still registers an IRQ handler for it.

Move codec detection earlier to set tea575x_tuner parameter before check.

Here the following functions are introduced
 reset_coded()                       resets AC97 codec
 snd_fm801_chip_multichannel_init()  initializes cards with multichannel support

Fixes: 5618955c4269 (ALSA: fm801: move to pcim_* and devm_* functions)
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/fm801.c |   69 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 30 deletions(-)

--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1088,26 +1088,20 @@ static int wait_for_codec(struct fm801 *
 	return -EIO;
 }
 
-static int snd_fm801_chip_init(struct fm801 *chip, int resume)
+static int reset_codec(struct fm801 *chip)
 {
-	unsigned short cmdw;
-
-	if (chip->tea575x_tuner & TUNER_ONLY)
-		goto __ac97_ok;
-
 	/* codec cold reset + AC'97 warm reset */
 	fm801_writew(chip, CODEC_CTRL, (1 << 5) | (1 << 6));
 	fm801_readw(chip, CODEC_CTRL); /* flush posting data */
 	udelay(100);
 	fm801_writew(chip, CODEC_CTRL, 0);
 
-	if (wait_for_codec(chip, 0, AC97_RESET, msecs_to_jiffies(750)) < 0)
-		if (!resume) {
-			dev_info(chip->card->dev,
-				 "Primary AC'97 codec not found, assume SF64-PCR (tuner-only)\n");
-			chip->tea575x_tuner = 3 | TUNER_ONLY;
-			goto __ac97_ok;
-		}
+	return wait_for_codec(chip, 0, AC97_RESET, msecs_to_jiffies(750));
+}
+
+static void snd_fm801_chip_multichannel_init(struct fm801 *chip)
+{
+	unsigned short cmdw;
 
 	if (chip->multichannel) {
 		if (chip->secondary_addr) {
@@ -1134,8 +1128,11 @@ static int snd_fm801_chip_init(struct fm
 		/* cause timeout problems */
 		wait_for_codec(chip, 0, AC97_VENDOR_ID1, msecs_to_jiffies(750));
 	}
+}
 
-      __ac97_ok:
+static void snd_fm801_chip_init(struct fm801 *chip)
+{
+	unsigned short cmdw;
 
 	/* init volume */
 	fm801_writew(chip, PCM_VOL, 0x0808);
@@ -1156,11 +1153,8 @@ static int snd_fm801_chip_init(struct fm
 	/* interrupt clear */
 	fm801_writew(chip, IRQ_STATUS,
 		     FM801_IRQ_PLAYBACK | FM801_IRQ_CAPTURE | FM801_IRQ_MPU);
-
-	return 0;
 }
 
-
 static int snd_fm801_free(struct fm801 *chip)
 {
 	unsigned short cmdw;
@@ -1217,7 +1211,23 @@ static int snd_fm801_create(struct snd_c
 	if ((err = pci_request_regions(pci, "FM801")) < 0)
 		return err;
 	chip->port = pci_resource_start(pci, 0);
-	if ((tea575x_tuner & TUNER_ONLY) == 0) {
+
+	if (pci->revision >= 0xb1)	/* FM801-AU */
+		chip->multichannel = 1;
+
+	if (!(chip->tea575x_tuner & TUNER_ONLY)) {
+		if (reset_codec(chip) < 0) {
+			dev_info(chip->card->dev,
+				 "Primary AC'97 codec not found, assume SF64-PCR (tuner-only)\n");
+			chip->tea575x_tuner = 3 | TUNER_ONLY;
+		} else {
+			snd_fm801_chip_multichannel_init(chip);
+		}
+	}
+
+	snd_fm801_chip_init(chip);
+
+	if ((chip->tea575x_tuner & TUNER_ONLY) == 0) {
 		if (devm_request_irq(&pci->dev, pci->irq, snd_fm801_interrupt,
 				IRQF_SHARED, KBUILD_MODNAME, chip)) {
 			dev_err(card->dev, "unable to grab IRQ %d\n", pci->irq);
@@ -1228,13 +1238,6 @@ static int snd_fm801_create(struct snd_c
 		pci_set_master(pci);
 	}
 
-	if (pci->revision >= 0xb1)	/* FM801-AU */
-		chip->multichannel = 1;
-
-	snd_fm801_chip_init(chip, 0);
-	/* init might set tuner access method */
-	tea575x_tuner = chip->tea575x_tuner;
-
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
 		snd_fm801_free(chip);
 		return err;
@@ -1251,15 +1254,15 @@ static int snd_fm801_create(struct snd_c
 	chip->tea.private_data = chip;
 	chip->tea.ops = &snd_fm801_tea_ops;
 	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));
-	if ((tea575x_tuner & TUNER_TYPE_MASK) > 0 &&
-	    (tea575x_tuner & TUNER_TYPE_MASK) < 4) {
+	if ((chip->tea575x_tuner & TUNER_TYPE_MASK) > 0 &&
+	    (chip->tea575x_tuner & TUNER_TYPE_MASK) < 4) {
 		if (snd_tea575x_init(&chip->tea, THIS_MODULE)) {
 			dev_err(card->dev, "TEA575x radio not found\n");
 			snd_fm801_free(chip);
 			return -ENODEV;
 		}
-	} else if ((tea575x_tuner & TUNER_TYPE_MASK) == 0) {
-		unsigned int tuner_only = tea575x_tuner & TUNER_ONLY;
+	} else if ((chip->tea575x_tuner & TUNER_TYPE_MASK) == 0) {
+		unsigned int tuner_only = chip->tea575x_tuner & TUNER_ONLY;
 
 		/* autodetect tuner connection */
 		for (tea575x_tuner = 1; tea575x_tuner <= 3; tea575x_tuner++) {
@@ -1395,7 +1398,13 @@ static int snd_fm801_resume(struct devic
 	struct fm801 *chip = card->private_data;
 	int i;
 
-	snd_fm801_chip_init(chip, 1);
+	if (chip->tea575x_tuner & TUNER_ONLY) {
+		snd_fm801_chip_init(chip);
+	} else {
+		reset_codec(chip);
+		snd_fm801_chip_multichannel_init(chip);
+		snd_fm801_chip_init(chip);
+	}
 	snd_ac97_resume(chip->ac97);
 	snd_ac97_resume(chip->ac97_sec);
 	for (i = 0; i < ARRAY_SIZE(saved_regs); i++)


