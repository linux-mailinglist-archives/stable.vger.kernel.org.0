Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978E037CE16
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbhELRDJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244076AbhELQmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8113561D0D;
        Wed, 12 May 2021 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835817;
        bh=LvY8oVw6UTSKzPyJe3KSHRUBnU/eYvGDudoqxJfORpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InRflTM702mvzQ5uhab87G6xZBTGBgs+lFTPC+VOpG77/YJ4DdMaVDKc3udT/eUwS
         bWjrKxbtgjlsBR62yBpADPCrU2pgvsVHjUJJdyG+9xPP/5Iw5uFwrDNO7DgqLKbzSE
         Xu+XNZg78dq/2NaNMatcMtfe21npa2z3lqU6KyZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 497/677] ALSA: usb-audio: Add error checks for usb_driver_claim_interface() calls
Date:   Wed, 12 May 2021 16:49:03 +0200
Message-Id: <20210512144853.895313114@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 5fb45414ae03421255593fd5556aa2d1d82303aa ]

There are a few calls of usb_driver_claim_interface() but all of those
miss the proper error checks, as reported by Coverity.  This patch
adds those missing checks.

Along with it, replace the magic pointer with -1 with a constant
USB_AUDIO_IFACE_UNUSED for better readability.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1475943 ("Error handling issues")
Addresses-Coverity-ID: 1475944 ("Error handling issues")
Addresses-Coverity-ID: 1475945 ("Error handling issues")
Fixes: b1ce7ba619d9 ("ALSA: usb-audio: claim autodetected PCM interfaces all at once")
Fixes: e5779998bf8b ("ALSA: usb-audio: refactor code")
Link: https://lore.kernel.org/r/202104051059.FB7F3016@keescook
Link: https://lore.kernel.org/r/20210406113534.30455-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c     | 14 +++++++-------
 sound/usb/quirks.c   | 16 ++++++++++++----
 sound/usb/usbaudio.h |  2 ++
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 0826a437f8fc..7b7526d3a56e 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -181,9 +181,8 @@ static int snd_usb_create_stream(struct snd_usb_audio *chip, int ctrlif, int int
 				ctrlif, interface);
 			return -EINVAL;
 		}
-		usb_driver_claim_interface(&usb_audio_driver, iface, (void *)-1L);
-
-		return 0;
+		return usb_driver_claim_interface(&usb_audio_driver, iface,
+						  USB_AUDIO_IFACE_UNUSED);
 	}
 
 	if ((altsd->bInterfaceClass != USB_CLASS_AUDIO &&
@@ -203,7 +202,8 @@ static int snd_usb_create_stream(struct snd_usb_audio *chip, int ctrlif, int int
 
 	if (! snd_usb_parse_audio_interface(chip, interface)) {
 		usb_set_interface(dev, interface, 0); /* reset the current interface */
-		usb_driver_claim_interface(&usb_audio_driver, iface, (void *)-1L);
+		return usb_driver_claim_interface(&usb_audio_driver, iface,
+						  USB_AUDIO_IFACE_UNUSED);
 	}
 
 	return 0;
@@ -862,7 +862,7 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 	struct snd_card *card;
 	struct list_head *p;
 
-	if (chip == (void *)-1L)
+	if (chip == USB_AUDIO_IFACE_UNUSED)
 		return;
 
 	card = chip->card;
@@ -992,7 +992,7 @@ static int usb_audio_suspend(struct usb_interface *intf, pm_message_t message)
 	struct usb_mixer_interface *mixer;
 	struct list_head *p;
 
-	if (chip == (void *)-1L)
+	if (chip == USB_AUDIO_IFACE_UNUSED)
 		return 0;
 
 	if (!chip->num_suspended_intf++) {
@@ -1022,7 +1022,7 @@ static int __usb_audio_resume(struct usb_interface *intf, bool reset_resume)
 	struct list_head *p;
 	int err = 0;
 
-	if (chip == (void *)-1L)
+	if (chip == USB_AUDIO_IFACE_UNUSED)
 		return 0;
 
 	atomic_inc(&chip->active); /* avoid autopm */
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 176437a441e6..7c6e83eee71d 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -55,8 +55,12 @@ static int create_composite_quirk(struct snd_usb_audio *chip,
 		if (!iface)
 			continue;
 		if (quirk->ifnum != probed_ifnum &&
-		    !usb_interface_claimed(iface))
-			usb_driver_claim_interface(driver, iface, (void *)-1L);
+		    !usb_interface_claimed(iface)) {
+			err = usb_driver_claim_interface(driver, iface,
+							 USB_AUDIO_IFACE_UNUSED);
+			if (err < 0)
+				return err;
+		}
 	}
 
 	return 0;
@@ -426,8 +430,12 @@ static int create_autodetect_quirks(struct snd_usb_audio *chip,
 			continue;
 
 		err = create_autodetect_quirk(chip, iface, driver);
-		if (err >= 0)
-			usb_driver_claim_interface(driver, iface, (void *)-1L);
+		if (err >= 0) {
+			err = usb_driver_claim_interface(driver, iface,
+							 USB_AUDIO_IFACE_UNUSED);
+			if (err < 0)
+				return err;
+		}
 	}
 
 	return 0;
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 60b9dd7df6bb..8794c8658ab9 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -61,6 +61,8 @@ struct snd_usb_audio {
 	struct media_intf_devnode *ctl_intf_media_devnode;
 };
 
+#define USB_AUDIO_IFACE_UNUSED	((void *)-1L)
+
 #define usb_audio_err(chip, fmt, args...) \
 	dev_err(&(chip)->dev->dev, fmt, ##args)
 #define usb_audio_warn(chip, fmt, args...) \
-- 
2.30.2



