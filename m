Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747882269C2
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgGTQ30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731383AbgGTP7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:59:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC2022065E;
        Mon, 20 Jul 2020 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260758;
        bh=3KRZcieEP6v8AtuNQIAdBlVRggsZqQwLO0e1d34e/YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFD01kSieR1HOXMtld4A8nTXj+Us7H5BsKWSXRnwv8KuVRqfHh5hE3S0+n2DAEHkP
         Hdki9AbC+Ej86bOQJngwOk/W7ZKjmdKiviQAfzYb4Q668xK0Rf9xrKF5G98WKVjcEK
         sLMpsG3PzX1J3my/ShMhDDHrC0p6c3OUuDIR/Z00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/215] ALSA: usb-audio: Rewrite registration quirk handling
Date:   Mon, 20 Jul 2020 17:36:07 +0200
Message-Id: <20200720152824.246255051@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit d8695bc5b1fe88305396b1f788d3b5f218e28a30 ]

A slight refactoring of the registration quirk code.  Now it uses the
table lookup for easy additions in future.  Also the return type was
changed to bool, and got a few more comments.

Link: https://lore.kernel.org/r/20200325103322.2508-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.c   |  2 +-
 sound/usb/quirks.c | 40 ++++++++++++++++++++++++++++++----------
 sound/usb/quirks.h |  3 +--
 3 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 2284377cbb98d..230d862cfa3a8 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -662,7 +662,7 @@ static int usb_audio_probe(struct usb_interface *intf,
 	/* we are allowed to call snd_card_register() many times, but first
 	 * check to see if a device needs to skip it or do anything special
 	 */
-	if (snd_usb_registration_quirk(chip, ifnum) == 0) {
+	if (!snd_usb_registration_quirk(chip, ifnum)) {
 		err = snd_card_register(chip->card);
 		if (err < 0)
 			goto __error;
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index f3e26e65c3257..ad557ab65e043 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1783,16 +1783,36 @@ void snd_usb_audioformat_attributes_quirk(struct snd_usb_audio *chip,
 	}
 }
 
-int snd_usb_registration_quirk(struct snd_usb_audio *chip,
-			       int iface)
+/*
+ * registration quirk:
+ * the registration is skipped if a device matches with the given ID,
+ * unless the interface reaches to the defined one.  This is for delaying
+ * the registration until the last known interface, so that the card and
+ * devices appear at the same time.
+ */
+
+struct registration_quirk {
+	unsigned int usb_id;	/* composed via USB_ID() */
+	unsigned int interface;	/* the interface to trigger register */
+};
+
+#define REG_QUIRK_ENTRY(vendor, product, iface) \
+	{ .usb_id = USB_ID(vendor, product), .interface = (iface) }
+
+static const struct registration_quirk registration_quirks[] = {
+	REG_QUIRK_ENTRY(0x0951, 0x16d8, 2),	/* Kingston HyperX AMP */
+	{ 0 }					/* terminator */
+};
+
+/* return true if skipping registration */
+bool snd_usb_registration_quirk(struct snd_usb_audio *chip, int iface)
 {
-	switch (chip->usb_id) {
-	case USB_ID(0x0951, 0x16d8): /* Kingston HyperX AMP */
-		/* Register only when we reach interface 2 so that streams can
-		 * merge correctly into PCMs from interface 0
-		 */
-		return (iface != 2);
-	}
+	const struct registration_quirk *q;
+
+	for (q = registration_quirks; q->usb_id; q++)
+		if (chip->usb_id == q->usb_id)
+			return iface != q->interface;
+
 	/* Register as normal */
-	return 0;
+	return false;
 }
diff --git a/sound/usb/quirks.h b/sound/usb/quirks.h
index 3afc01eabc7e2..c76cf24a640a6 100644
--- a/sound/usb/quirks.h
+++ b/sound/usb/quirks.h
@@ -51,7 +51,6 @@ void snd_usb_audioformat_attributes_quirk(struct snd_usb_audio *chip,
 					  struct audioformat *fp,
 					  int stream);
 
-int snd_usb_registration_quirk(struct snd_usb_audio *chip,
-			       int iface);
+bool snd_usb_registration_quirk(struct snd_usb_audio *chip, int iface);
 
 #endif /* __USBAUDIO_QUIRKS_H */
-- 
2.25.1



