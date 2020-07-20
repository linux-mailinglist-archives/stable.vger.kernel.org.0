Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AF0226868
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbgGTQTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387937AbgGTQMT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:12:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B62BB20684;
        Mon, 20 Jul 2020 16:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261539;
        bh=qK77h3fwBf9BYnbF8S0ae2S5oBVr7gjLkM9sGOG0uL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfhU0MoSMdR8GgQT8VwBJzineSjAlH3YTNJrMwFoCGWQ8s0Y2rnpUJHDeAt70ImcL
         Ngu98fWD0emIgXLDeILkx6H3R6GayRAf9Bv0Gjl8nF3vvNC+3NzywtvmasZsV+fwXS
         2mBCVclqTdFalTuRBpGPKvBZTWNUDFRBdQH7FDlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0f4ecfe6a2c322c81728@syzkaller.appspotmail.com,
        syzbot+5f1d24c49c1d2c427497@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.7 153/244] ALSA: usb-audio: Fix race against the error recovery URB submission
Date:   Mon, 20 Jul 2020 17:37:04 +0200
Message-Id: <20200720152833.129085983@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 9b7e5208a941e2e491a83eb5fa83d889e888fa2f upstream.

USB MIDI driver has an error recovery mechanism to resubmit the URB in
the delayed timer handler, and this may race with the standard start /
stop operations.  Although both start and stop operations themselves
don't race with each other due to the umidi->mutex protection, but
this isn't applied to the timer handler.

For fixing this potential race, the following changes are applied:

- Since the timer handler can't use the mutex, we apply the
  umidi->disc_lock protection at each input stream URB submission;
  this also needs to change the GFP flag to GFP_ATOMIC
- Add a check of the URB refcount and skip if already submitted
- Move the timer cancel call at disconnection to the beginning of the
  procedure; this assures the in-flight timer handler is gone properly
  before killing all pending URBs

Reported-by: syzbot+0f4ecfe6a2c322c81728@syzkaller.appspotmail.com
Reported-by: syzbot+5f1d24c49c1d2c427497@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200710160656.16819-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/midi.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1499,6 +1499,8 @@ void snd_usbmidi_disconnect(struct list_
 	spin_unlock_irq(&umidi->disc_lock);
 	up_write(&umidi->disc_rwsem);
 
+	del_timer_sync(&umidi->error_timer);
+
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i) {
 		struct snd_usb_midi_endpoint *ep = &umidi->endpoints[i];
 		if (ep->out)
@@ -1525,7 +1527,6 @@ void snd_usbmidi_disconnect(struct list_
 			ep->in = NULL;
 		}
 	}
-	del_timer_sync(&umidi->error_timer);
 }
 EXPORT_SYMBOL(snd_usbmidi_disconnect);
 
@@ -2301,16 +2302,22 @@ void snd_usbmidi_input_stop(struct list_
 }
 EXPORT_SYMBOL(snd_usbmidi_input_stop);
 
-static void snd_usbmidi_input_start_ep(struct snd_usb_midi_in_endpoint *ep)
+static void snd_usbmidi_input_start_ep(struct snd_usb_midi *umidi,
+				       struct snd_usb_midi_in_endpoint *ep)
 {
 	unsigned int i;
+	unsigned long flags;
 
 	if (!ep)
 		return;
 	for (i = 0; i < INPUT_URBS; ++i) {
 		struct urb *urb = ep->urbs[i];
-		urb->dev = ep->umidi->dev;
-		snd_usbmidi_submit_urb(urb, GFP_KERNEL);
+		spin_lock_irqsave(&umidi->disc_lock, flags);
+		if (!atomic_read(&urb->use_count)) {
+			urb->dev = ep->umidi->dev;
+			snd_usbmidi_submit_urb(urb, GFP_ATOMIC);
+		}
+		spin_unlock_irqrestore(&umidi->disc_lock, flags);
 	}
 }
 
@@ -2326,7 +2333,7 @@ void snd_usbmidi_input_start(struct list
 	if (umidi->input_running || !umidi->opened[1])
 		return;
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i)
-		snd_usbmidi_input_start_ep(umidi->endpoints[i].in);
+		snd_usbmidi_input_start_ep(umidi, umidi->endpoints[i].in);
 	umidi->input_running = 1;
 }
 EXPORT_SYMBOL(snd_usbmidi_input_start);


