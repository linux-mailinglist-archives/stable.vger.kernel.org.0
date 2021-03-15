Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FAA33B995
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhCOOGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233475AbhCOOBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D1BA64E83;
        Mon, 15 Mar 2021 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816904;
        bh=qd4RVn8m+ChlXskRSdPiSrsQ+jsr33LI2BaFDhAq+rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wmk0614wpSGtU8hhXSKK7yFL2sKFlFuR6uKxnUGFXIqIJoDEZ7v724nj4NV6qg/7L
         V6mVHJtqppyKVA+iRi7DG+WJ7YF0IFPoq4DRqIgkXGN6mzPDcPBJOYpho2QIq29kkz
         LUJykmH+DIBrcg5oWqWnoC6rnpaQqt/hqr/k//DM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 180/290] ALSA: usb-audio: Disable USB autosuspend properly in setup_disable_autosuspend()
Date:   Mon, 15 Mar 2021 14:54:33 +0100
Message-Id: <20210315135547.996747141@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 9799110825dba087c2bdce886977cf84dada2005 upstream.

Rear audio on Lenovo ThinkStation P620 stops working after commit
1965c4364bdd ("ALSA: usb-audio: Disable autosuspend for Lenovo
ThinkStation P620"):
[    6.013526] usbcore: registered new interface driver snd-usb-audio
[    6.023064] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x100, wIndex = 0x0, type = 1
[    6.023083] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x202, wIndex = 0x0, type = 4
[    6.023090] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x100, wIndex = 0x0, type = 1
[    6.023098] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x202, wIndex = 0x0, type = 4
[    6.023103] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x100, wIndex = 0x0, type = 1
[    6.023110] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x202, wIndex = 0x0, type = 4
[    6.045846] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x100, wIndex = 0x0, type = 1
[    6.045866] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x202, wIndex = 0x0, type = 4
[    6.045877] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x100, wIndex = 0x0, type = 1
[    6.045886] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x202, wIndex = 0x0, type = 4
[    6.045894] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x100, wIndex = 0x0, type = 1
[    6.045908] usb 3-6: cannot get ctl value: req = 0x81, wValue = 0x202, wIndex = 0x0, type = 4

I overlooked the issue because when I was working on the said commit,
only the front audio is tested. Apology for that.

Changing supports_autosuspend in driver is too late for disabling
autosuspend, because it was already used by USB probe routine, so it can
break the balance on the following code that depends on
supports_autosuspend.

Fix it by using usb_disable_autosuspend() helper, and balance the
suspend count in disconnect callback.

Fixes: 1965c4364bdd ("ALSA: usb-audio: Disable autosuspend for Lenovo ThinkStation P620")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210304043419.287191-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.c     |    5 +++++
 sound/usb/quirks.c   |    2 +-
 sound/usb/usbaudio.h |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -830,6 +830,8 @@ static int usb_audio_probe(struct usb_in
 		snd_media_device_create(chip, intf);
 	}
 
+	chip->quirk_type = quirk->type;
+
 	usb_chip[chip->index] = chip;
 	chip->intf[chip->num_interfaces] = intf;
 	chip->num_interfaces++;
@@ -912,6 +914,9 @@ static void usb_audio_disconnect(struct
 	} else {
 		mutex_unlock(&register_mutex);
 	}
+
+	if (chip->quirk_type & QUIRK_SETUP_DISABLE_AUTOSUSPEND)
+		usb_enable_autosuspend(interface_to_usbdev(intf));
 }
 
 /* lock the shutdown (disconnect) task and autoresume */
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -523,7 +523,7 @@ static int setup_disable_autosuspend(str
 				       struct usb_driver *driver,
 				       const struct snd_usb_audio_quirk *quirk)
 {
-	driver->supports_autosuspend = 0;
+	usb_disable_autosuspend(interface_to_usbdev(iface));
 	return 1;	/* Continue with creating streams and mixer */
 }
 
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -27,6 +27,7 @@ struct snd_usb_audio {
 	struct snd_card *card;
 	struct usb_interface *intf[MAX_CARD_INTERFACES];
 	u32 usb_id;
+	uint16_t quirk_type;
 	struct mutex mutex;
 	unsigned int system_suspend;
 	atomic_t active;


