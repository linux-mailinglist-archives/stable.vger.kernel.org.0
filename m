Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0F5226AD4
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgGTPvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbgGTPv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:51:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 384B42065E;
        Mon, 20 Jul 2020 15:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260288;
        bh=WrkDv3uHZUE5yf9EmcsK+90sNgyKK/CKBuV6vr/40dw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UipbzOmFiH5XM8xsdyZ0MCu+jA0WzJUA5ToeAEWH6h1AfKL29GPSakm9bU2F0rfog
         cPP3QhNXcgyG9vYh987EDwQaQopyugTP0OTeLhEmD1KaOznu/pBs6HUoZrOCat0mqB
         bS70VJ+fd8iH+cuIpGAryvAGGAPty8iJa/eob4eQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wulff <crwulff@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/133] ALSA: usb-audio: Create a registration quirk for Kingston HyperX Amp (0951:16d8)
Date:   Mon, 20 Jul 2020 17:36:36 +0200
Message-Id: <20200720152806.077798724@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
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
index 2644a5ae2b757..6615734d29911 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -668,10 +668,14 @@ static int usb_audio_probe(struct usb_interface *intf,
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
 
 	usb_chip[chip->index] = chip;
 	chip->num_interfaces++;
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 8b5bc809efd3f..a95fbdbfbd05f 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1508,3 +1508,17 @@ void snd_usb_audioformat_attributes_quirk(struct snd_usb_audio *chip,
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
index a80e0ddd07364..dc02c9d80e991 100644
--- a/sound/usb/quirks.h
+++ b/sound/usb/quirks.h
@@ -46,4 +46,7 @@ void snd_usb_audioformat_attributes_quirk(struct snd_usb_audio *chip,
 					  struct audioformat *fp,
 					  int stream);
 
+int snd_usb_registration_quirk(struct snd_usb_audio *chip,
+			       int iface);
+
 #endif /* __USBAUDIO_QUIRKS_H */
-- 
2.25.1



