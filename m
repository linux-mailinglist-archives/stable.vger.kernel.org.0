Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABDF53900D
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbfFGPsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731787AbfFGPs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:48:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 457A820657;
        Fri,  7 Jun 2019 15:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922508;
        bh=Bw0g5FLiG92QgvG8Pgr5tS+MqI1u4cPdgbtJLo51+TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUGX3E5z6gw1i+LOTKLFzJ4PAIRsDAIHh6V6ANxfFP1M5Ip+VtyYCsNYI30aztxbg
         juUh274SjHq20apQsHxEOz3SByy2aKJsnhHXm5UHmMj92cci7y49pqm0gYJEAQkVx0
         8AAwxvoZIzhffRCx7LBtE39kzIEWAdBbAC8N6wbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5255458d5e0a2b10bbb9@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.1 39/85] ALSA: line6: Assure canceling delayed work at disconnection
Date:   Fri,  7 Jun 2019 17:39:24 +0200
Message-Id: <20190607153854.054308547@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 0b074ab7fc0d575247b9cc9f93bb7e007ca38840 upstream.

The current code performs the cancel of a delayed work at the late
stage of disconnection procedure, which may lead to the access to the
already cleared state.

This patch assures to call cancel_delayed_work_sync() at the beginning
of the disconnection procedure for avoiding that race.  The delayed
work object is now assigned in the common line6 object instead of its
derivative, so that we can call cancel_delayed_work_sync().

Along with the change, the startup function is called via the new
callback instead.  This will make it easier to port other LINE6
drivers to use the delayed work for startup in later patches.

Reported-by: syzbot+5255458d5e0a2b10bbb9@syzkaller.appspotmail.com
Fixes: 7f84ff68be05 ("ALSA: line6: toneport: Fix broken usage of timer for delayed execution")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/line6/driver.c   |   12 ++++++++++++
 sound/usb/line6/driver.h   |    4 ++++
 sound/usb/line6/toneport.c |   15 +++------------
 3 files changed, 19 insertions(+), 12 deletions(-)

--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -720,6 +720,15 @@ static int line6_init_cap_control(struct
 	return 0;
 }
 
+static void line6_startup_work(struct work_struct *work)
+{
+	struct usb_line6 *line6 =
+		container_of(work, struct usb_line6, startup_work.work);
+
+	if (line6->startup)
+		line6->startup(line6);
+}
+
 /*
 	Probe USB device.
 */
@@ -755,6 +764,7 @@ int line6_probe(struct usb_interface *in
 	line6->properties = properties;
 	line6->usbdev = usbdev;
 	line6->ifcdev = &interface->dev;
+	INIT_DELAYED_WORK(&line6->startup_work, line6_startup_work);
 
 	strcpy(card->id, properties->id);
 	strcpy(card->driver, driver_name);
@@ -825,6 +835,8 @@ void line6_disconnect(struct usb_interfa
 	if (WARN_ON(usbdev != line6->usbdev))
 		return;
 
+	cancel_delayed_work(&line6->startup_work);
+
 	if (line6->urb_listen != NULL)
 		line6_stop_listen(line6);
 
--- a/sound/usb/line6/driver.h
+++ b/sound/usb/line6/driver.h
@@ -178,11 +178,15 @@ struct usb_line6 {
 			fifo;
 	} messages;
 
+	/* Work for delayed PCM startup */
+	struct delayed_work startup_work;
+
 	/* If MIDI is supported, buffer_message contains the pre-processed data;
 	 * otherwise the data is only in urb_listen (buffer_incoming).
 	 */
 	void (*process_message)(struct usb_line6 *);
 	void (*disconnect)(struct usb_line6 *line6);
+	void (*startup)(struct usb_line6 *line6);
 };
 
 extern char *line6_alloc_sysex_buffer(struct usb_line6 *line6, int code1,
--- a/sound/usb/line6/toneport.c
+++ b/sound/usb/line6/toneport.c
@@ -54,9 +54,6 @@ struct usb_line6_toneport {
 	/* Firmware version (x 100) */
 	u8 firmware_version;
 
-	/* Work for delayed PCM startup */
-	struct delayed_work pcm_work;
-
 	/* Device type */
 	enum line6_device_type type;
 
@@ -241,12 +238,8 @@ static int snd_toneport_source_put(struc
 	return 1;
 }
 
-static void toneport_start_pcm(struct work_struct *work)
+static void toneport_startup(struct usb_line6 *line6)
 {
-	struct usb_line6_toneport *toneport =
-		container_of(work, struct usb_line6_toneport, pcm_work.work);
-	struct usb_line6 *line6 = &toneport->line6;
-
 	line6_pcm_acquire(line6->line6pcm, LINE6_STREAM_MONITOR, true);
 }
 
@@ -394,7 +387,7 @@ static int toneport_setup(struct usb_lin
 	if (toneport_has_led(toneport))
 		toneport_update_led(toneport);
 
-	schedule_delayed_work(&toneport->pcm_work,
+	schedule_delayed_work(&toneport->line6.startup_work,
 			      msecs_to_jiffies(TONEPORT_PCM_DELAY * 1000));
 	return 0;
 }
@@ -407,8 +400,6 @@ static void line6_toneport_disconnect(st
 	struct usb_line6_toneport *toneport =
 		(struct usb_line6_toneport *)line6;
 
-	cancel_delayed_work_sync(&toneport->pcm_work);
-
 	if (toneport_has_led(toneport))
 		toneport_remove_leds(toneport);
 }
@@ -424,9 +415,9 @@ static int toneport_init(struct usb_line
 	struct usb_line6_toneport *toneport =  (struct usb_line6_toneport *) line6;
 
 	toneport->type = id->driver_info;
-	INIT_DELAYED_WORK(&toneport->pcm_work, toneport_start_pcm);
 
 	line6->disconnect = line6_toneport_disconnect;
+	line6->startup = toneport_startup;
 
 	/* initialize PCM subsystem: */
 	err = line6_init_pcm(line6, &toneport_pcm_properties);


