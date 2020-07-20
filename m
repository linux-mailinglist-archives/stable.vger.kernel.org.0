Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B0E226AD6
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgGTPvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:51:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731264AbgGTPvk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:51:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F34322CE3;
        Mon, 20 Jul 2020 15:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260299;
        bh=PxcjmdLAieDHzQe830IT3vOxzVri0M4S4qCgYzYFp9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkZIpsyVwP7oiuE5+D0X988sh9yiKuAIB7HNQk4WLT0iyZ37Oy94pFSq7KMFGaNxx
         AzqP+Rr4SpS0CvKiKdZmkBNZb1pTxok/ki2Ex4+7hYDzQ68wufmQ28bd7cV97ZsTGs
         139kPGmrZXkEhxPKqJ/MSzuVO50j3ldZcEdVPRPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/133] ALSA: usb-audio: Rewrite registration quirk handling
Date:   Mon, 20 Jul 2020 17:36:39 +0200
Message-Id: <20200720152806.227067518@linuxfoundation.org>
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
index 6615734d29911..ba096cb4a53e4 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -671,7 +671,7 @@ static int usb_audio_probe(struct usb_interface *intf,
 	/* we are allowed to call snd_card_register() many times, but first
 	 * check to see if a device needs to skip it or do anything special
 	 */
-	if (snd_usb_registration_quirk(chip, ifnum) == 0) {
+	if (!snd_usb_registration_quirk(chip, ifnum)) {
 		err = snd_card_register(chip->card);
 		if (err < 0)
 			goto __error;
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index a95fbdbfbd05f..79c3787ad8fd8 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1509,16 +1509,36 @@ void snd_usb_audioformat_attributes_quirk(struct snd_usb_audio *chip,
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
index dc02c9d80e991..1efa6c968532f 100644
--- a/sound/usb/quirks.h
+++ b/sound/usb/quirks.h
@@ -46,7 +46,6 @@ void snd_usb_audioformat_attributes_quirk(struct snd_usb_audio *chip,
 					  struct audioformat *fp,
 					  int stream);
 
-int snd_usb_registration_quirk(struct snd_usb_audio *chip,
-			       int iface);
+bool snd_usb_registration_quirk(struct snd_usb_audio *chip, int iface);
 
 #endif /* __USBAUDIO_QUIRKS_H */
-- 
2.25.1



