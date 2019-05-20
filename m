Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 455072351B
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390646AbfETMdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390636AbfETMdC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:33:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B242204FD;
        Mon, 20 May 2019 12:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355581;
        bh=4mJ0ODamTguxNDF0yhcDtRfQZ1QX4p0KtjNL4DmrW2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MyRti2ybkDGeM5Z5DTHrJNBI91nHO3GF4SgwmCcl1TcoJJ8hyKPMCtw8giPblvWML
         9CPHEI7sYKkVpY24rJHXhJM4FjhOkfLQ2AzTBP8o7+PtTeLr+Zmcb77WRRIST4eImk
         LzR9P7w33aCc9wjPgOK50ucUNNw/+RRVogjK73Rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+a07d0142e74fdd595cfb@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 048/128] ALSA: line6: toneport: Fix broken usage of timer for delayed execution
Date:   Mon, 20 May 2019 14:13:55 +0200
Message-Id: <20190520115253.014079061@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 7f84ff68be05ec7a5d2acf8fdc734fe5897af48f upstream.

The line6 toneport driver has code for some delayed initialization,
and this hits the kernel Oops because mutex and other sleepable
functions are used in the timer callback.  Fix the abuse by a delayed
work instead so that everything works gracefully.

Reported-by: syzbot+a07d0142e74fdd595cfb@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/line6/toneport.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/sound/usb/line6/toneport.c
+++ b/sound/usb/line6/toneport.c
@@ -54,8 +54,8 @@ struct usb_line6_toneport {
 	/* Firmware version (x 100) */
 	u8 firmware_version;
 
-	/* Timer for delayed PCM startup */
-	struct timer_list timer;
+	/* Work for delayed PCM startup */
+	struct delayed_work pcm_work;
 
 	/* Device type */
 	enum line6_device_type type;
@@ -241,9 +241,10 @@ static int snd_toneport_source_put(struc
 	return 1;
 }
 
-static void toneport_start_pcm(struct timer_list *t)
+static void toneport_start_pcm(struct work_struct *work)
 {
-	struct usb_line6_toneport *toneport = from_timer(toneport, t, timer);
+	struct usb_line6_toneport *toneport =
+		container_of(work, struct usb_line6_toneport, pcm_work.work);
 	struct usb_line6 *line6 = &toneport->line6;
 
 	line6_pcm_acquire(line6->line6pcm, LINE6_STREAM_MONITOR, true);
@@ -393,7 +394,8 @@ static int toneport_setup(struct usb_lin
 	if (toneport_has_led(toneport))
 		toneport_update_led(toneport);
 
-	mod_timer(&toneport->timer, jiffies + TONEPORT_PCM_DELAY * HZ);
+	schedule_delayed_work(&toneport->pcm_work,
+			      msecs_to_jiffies(TONEPORT_PCM_DELAY * 1000));
 	return 0;
 }
 
@@ -405,7 +407,7 @@ static void line6_toneport_disconnect(st
 	struct usb_line6_toneport *toneport =
 		(struct usb_line6_toneport *)line6;
 
-	del_timer_sync(&toneport->timer);
+	cancel_delayed_work_sync(&toneport->pcm_work);
 
 	if (toneport_has_led(toneport))
 		toneport_remove_leds(toneport);
@@ -422,7 +424,7 @@ static int toneport_init(struct usb_line
 	struct usb_line6_toneport *toneport =  (struct usb_line6_toneport *) line6;
 
 	toneport->type = id->driver_info;
-	timer_setup(&toneport->timer, toneport_start_pcm, 0);
+	INIT_DELAYED_WORK(&toneport->pcm_work, toneport_start_pcm);
 
 	line6->disconnect = line6_toneport_disconnect;
 


