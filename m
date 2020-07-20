Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068A82269D2
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgGTQ3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731645AbgGTP7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3B3D2065E;
        Mon, 20 Jul 2020 15:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260750;
        bh=cS5sXh8R8EECFabwRlhfigWsqZ9n88SnscShNI+HJNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfX1H6Ajt43TalJdDMGbt7k1x/j/j/bIpLVcBL7SkED6SX77/VJ+juDCISvUfzwwY
         +XLyR90SZv6LQfP9+SjldfjTVoJRMwnaV4m3tSJ+qxV6OS5TQvw6BcYFCVpHfLjcQA
         h1+ZaRs3hrFP0URg0e3tCebAe/67ytkaR+bL8gBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wulff <crwulff@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 082/215] ALSA: usb-audio: Create a registration quirk for Kingston HyperX Amp (0951:16d8)
Date:   Mon, 20 Jul 2020 17:36:04 +0200
Message-Id: <20200720152824.113641618@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wulff <crwulff@gmail.com>

[ Upstream commit 55f7326170d9e83e2d828591938e1101982a679c ]

Create a quirk that allows special processing and/or
skipping the call to snd_card_register.

For HyperX AMP, which uses two interfaces, but only has
a capture stream in the second, this allows the capture
stream to merge with the first PCM.

Signed-off-by: Chris Wulff <crwulff@gmail.com>
Link: https://lore.kernel.org/r/20200314165449.4086-3-crwulff@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c   | 12 ++++++++----
 sound/usb/quirks.c | 14 ++++++++++++++
 sound/usb/quirks.h |  3 +++
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index f9a64e9526f54..2284377cbb98d 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -659,10 +659,14 @@ static int usb_audio_probe(struct usb_interface *intf,
 			goto __error;
 	}
 
-	/* we are allowed to call snd_card_register() many times */
-	err = snd_card_register(chip->card);
-	if (err < 0)
-		goto __error;
+	/* we are allowed to call snd_card_register() many times, but first
+	 * check to see if a device needs to skip it or do anything special
+	 */
+	if (snd_usb_registration_quirk(chip, ifnum) == 0) {
+		err = snd_card_register(chip->card);
+		if (err < 0)
+			goto __error;
+	}
 
 	if (quirk && quirk->shares_media_device) {
 		/* don't want to fail when snd_media_device_create() fails */
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 9d11ff742e5f5..f3e26e65c3257 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1782,3 +1782,17 @@ void snd_usb_audioformat_attributes_quirk(struct snd_usb_audio *chip,
 		break;
 	}
 }
+
+int snd_usb_registration_quirk(struct snd_usb_audio *chip,
+			       int iface)
+{
+	switch (chip->usb_id) {
+	case USB_ID(0x0951, 0x16d8): /* Kingston HyperX AMP */
+		/* Register only when we reach interface 2 so that streams can
+		 * merge correctly into PCMs from interface 0
+		 */
+		return (iface != 2);
+	}
+	/* Register as normal */
+	return 0;
+}
diff --git a/sound/usb/quirks.h b/sound/usb/quirks.h
index df0355843a4c1..3afc01eabc7e2 100644
--- a/sound/usb/quirks.h
+++ b/sound/usb/quirks.h
@@ -51,4 +51,7 @@ void snd_usb_audioformat_attributes_quirk(struct snd_usb_audio *chip,
 					  struct audioformat *fp,
 					  int stream);
 
+int snd_usb_registration_quirk(struct snd_usb_audio *chip,
+			       int iface);
+
 #endif /* __USBAUDIO_QUIRKS_H */
-- 
2.25.1



