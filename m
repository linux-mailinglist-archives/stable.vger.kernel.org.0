Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8A313A51A
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbgANKEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:60514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729913AbgANKEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:04:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60AF82465B;
        Tue, 14 Jan 2020 10:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996281;
        bh=/9BlWLeSYpZfRll16yytSYS145pvVoN7Z4UYrmzcAQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRKAurVIHCo98rsWwHexjrDxgC47cgYLtCT7YXQ7Djy9bJW//CicdhLDndQFPIziD
         rXy9QK6CyX8pSLXV+u9KKV6INFsSkDAo8pEUtGiKR4M8OVNMywN3KH9IY6jfZr70GZ
         w/fLybn8s8d96keQdSH30ERwh4H2792HUJSAobpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 22/78] Input: input_event - fix struct padding on sparc64
Date:   Tue, 14 Jan 2020 11:00:56 +0100
Message-Id: <20200114094356.728628313@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit f729a1b0f8df7091cea3729fc0e414f5326e1163 upstream.

Going through all uses of timeval, I noticed that we screwed up
input_event in the previous attempts to fix it:

The time fields now match between kernel and user space, but all following
fields are in the wrong place.

Add the required padding that is implied by the glibc timeval definition
to fix the layout, and use a struct initializer to avoid leaking kernel
stack data.

Fixes: 141e5dcaa735 ("Input: input_event - fix the CONFIG_SPARC64 mixup")
Fixes: 2e746942ebac ("Input: input_event - provide override for sparc64")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20191213204936.3643476-2-arnd@arndb.de
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/evdev.c       |   14 +++++++-------
 drivers/input/misc/uinput.c |   14 +++++++++-----
 include/uapi/linux/input.h  |    1 +
 3 files changed, 17 insertions(+), 12 deletions(-)

--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -224,13 +224,13 @@ static void __pass_event(struct evdev_cl
 		 */
 		client->tail = (client->head - 2) & (client->bufsize - 1);
 
-		client->buffer[client->tail].input_event_sec =
-						event->input_event_sec;
-		client->buffer[client->tail].input_event_usec =
-						event->input_event_usec;
-		client->buffer[client->tail].type = EV_SYN;
-		client->buffer[client->tail].code = SYN_DROPPED;
-		client->buffer[client->tail].value = 0;
+		client->buffer[client->tail] = (struct input_event) {
+			.input_event_sec = event->input_event_sec,
+			.input_event_usec = event->input_event_usec,
+			.type = EV_SYN,
+			.code = SYN_DROPPED,
+			.value = 0,
+		};
 
 		client->packet_head = client->tail;
 	}
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -74,12 +74,16 @@ static int uinput_dev_event(struct input
 	struct uinput_device	*udev = input_get_drvdata(dev);
 	struct timespec64	ts;
 
-	udev->buff[udev->head].type = type;
-	udev->buff[udev->head].code = code;
-	udev->buff[udev->head].value = value;
 	ktime_get_ts64(&ts);
-	udev->buff[udev->head].input_event_sec = ts.tv_sec;
-	udev->buff[udev->head].input_event_usec = ts.tv_nsec / NSEC_PER_USEC;
+
+	udev->buff[udev->head] = (struct input_event) {
+		.input_event_sec = ts.tv_sec,
+		.input_event_usec = ts.tv_nsec / NSEC_PER_USEC,
+		.type = type,
+		.code = code,
+		.value = value,
+	};
+
 	udev->head = (udev->head + 1) % UINPUT_BUFFER_SIZE;
 
 	wake_up_interruptible(&udev->waitq);
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -34,6 +34,7 @@ struct input_event {
 	__kernel_ulong_t __sec;
 #if defined(__sparc__) && defined(__arch64__)
 	unsigned int __usec;
+	unsigned int __pad;
 #else
 	__kernel_ulong_t __usec;
 #endif


