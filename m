Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C2038AB4F
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240481AbhETLW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238470AbhETLU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA53C61D89;
        Thu, 20 May 2021 10:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505472;
        bh=h7JgU1b6vdqjAAdb1MDysc/E7EuCxti64u1idx67Fkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rk4Mgr//s8+R34JQi59lLYW+gg4NAd/Zuo5tAkWNtyoVsfnaXSnRoRxvayBeyX4Nr
         MU9ttuhYyGpOkc3IxXv7tCpFoveHAVd3+UGLk6HNRjVyine4Wkq27eC7WgpHG2aZ23
         9q1e8EK3F9tGnJOFW6Xdb0Le0dFQOatbhh1PjUjQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 116/190] ALSA: usb-audio: Add error checks for usb_driver_claim_interface() calls
Date:   Thu, 20 May 2021 11:23:00 +0200
Message-Id: <20210520092106.037579813@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index 61d303f4283d..3ded5fe94cea 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -179,9 +179,8 @@ static int snd_usb_create_stream(struct snd_usb_audio *chip, int ctrlif, int int
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
@@ -201,7 +200,8 @@ static int snd_usb_create_stream(struct snd_usb_audio *chip, int ctrlif, int int
 
 	if (! snd_usb_parse_audio_interface(chip, interface)) {
 		usb_set_interface(dev, interface, 0); /* reset the current interface */
-		usb_driver_claim_interface(&usb_audio_driver, iface, (void *)-1L);
+		return usb_driver_claim_interface(&usb_audio_driver, iface,
+						  USB_AUDIO_IFACE_UNUSED);
 	}
 
 	return 0;
@@ -610,7 +610,7 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 	struct snd_card *card;
 	struct list_head *p;
 
-	if (chip == (void *)-1L)
+	if (chip == USB_AUDIO_IFACE_UNUSED)
 		return;
 
 	card = chip->card;
@@ -710,7 +710,7 @@ static int usb_audio_suspend(struct usb_interface *intf, pm_message_t message)
 	struct usb_mixer_interface *mixer;
 	struct list_head *p;
 
-	if (chip == (void *)-1L)
+	if (chip == USB_AUDIO_IFACE_UNUSED)
 		return 0;
 
 	if (!chip->num_suspended_intf++) {
@@ -740,7 +740,7 @@ static int __usb_audio_resume(struct usb_interface *intf, bool reset_resume)
 	struct list_head *p;
 	int err = 0;
 
-	if (chip == (void *)-1L)
+	if (chip == USB_AUDIO_IFACE_UNUSED)
 		return 0;
 
 	atomic_inc(&chip->active); /* avoid autopm */
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index cd615514a5ff..7979a9e19c53 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -66,8 +66,12 @@ static int create_composite_quirk(struct snd_usb_audio *chip,
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
@@ -399,8 +403,12 @@ static int create_autodetect_quirks(struct snd_usb_audio *chip,
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
index c5338be3aa37..09ecc7afdc4f 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -62,6 +62,8 @@ struct snd_usb_audio {
 	struct usb_host_interface *ctrl_intf;	/* the audio control interface */
 };
 
+#define USB_AUDIO_IFACE_UNUSED	((void *)-1L)
+
 #define usb_audio_err(chip, fmt, args...) \
 	dev_err(&(chip)->dev->dev, fmt, ##args)
 #define usb_audio_warn(chip, fmt, args...) \
-- 
2.30.2



