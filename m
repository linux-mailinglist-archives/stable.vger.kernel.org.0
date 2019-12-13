Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4B311EC10
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 21:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLMUvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 15:51:08 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:41421 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMUvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 15:51:08 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N2m7O-1hjKJl2E7I-0132dq; Fri, 13 Dec 2019 21:50:53 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, sparclinux@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-input@vger.kernel.org
Subject: [PATCH v2 01/24] Input: input_event: fix struct padding on sparc64
Date:   Fri, 13 Dec 2019 21:49:10 +0100
Message-Id: <20191213204936.3643476-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191213204936.3643476-1-arnd@arndb.de>
References: <20191213204936.3643476-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:b8gCujveRfENF93qhn+QoZv/ckKyXm1BIFaTvxXniIUqRp+b6PR
 3VSHWZW1SQzZk8GlNQpYeUFnSdkbDpGEpUozYthsO7HpZiAKH3XYDHJcXFjjxf1Xn91Ch+s
 d37azDmn1CwgETn8euOshiFS2oUw9MuYpYmhu4tm/a1iwNWERIkO3OEYl1dsNDQfqxG7TYm
 fURnjI/jbKO29eu5hdNRw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iIbuBbbotM0=:qlSem9fmmr21xU4JKbUkwr
 2jwTBbOAuCE4GVBIZFL0TrE/kDGXnz2zZkeJWYbvGhf+HZcfLqu65WFtRkkx228BcNZwOKIuh
 m0vU7lTquEbBCKwj68bhb6jg52BeQS62G3gR7WtmaOG52gnMGQ7W9iI1b+2CPLzB/kJqfjRUk
 iDa20EOw/qK/icA36YWIJQ+d5sEL1cQgFIfmGlwltdAj1t67KpOG9oVbzTAPVjb8EQZMqjnRb
 6n5Qt1hKLWA3v+lZcc5SWtgzNzDDO283oCyYzbjuCtd5h8mLYN6I5J3x2PZAP0qKyogu7VcFd
 HB1zgOJJhV8/WHRkK/EWdtBnJc/ESEqPoEtK7MfK71LPTdw0v3voVoAHsAVJX1pm0Fk+s0rR3
 cYSUuppiTTS5dtk/Ax653eDoLYwd5IksUWHIi6xidTr1GLuNGXco5sYWCDzMXHhp4o6ep1BTP
 9zQOWWG132l95PNjSlfAR+4Og26QjT5jl5vnixgkx3Xy4jmEcCqFBQZZ3OtT+ghGZjzbdiSC0
 Q96LFa3Ok8s1OF2cYR4NceiklpMC1gL3SMx9J6VL3WwaWZaRL2HrteTd1g0+P+6z1ZSoih2X0
 8FDcLDf7AZiGd9EZshJ2pgTMVdvla3OEsdKZtBBszML+XDxoHjZ/Z/siWJZRVVn7Bi6zSudWi
 FhePVLTxrdj9pmsSHjNYgfz3mjhMOGn0wSWLlRojj3pa6ro9WcB5IPOKUzO9nDkG+lDEL7t4s
 6NeUbkktu6PAykWYIEkirix4f1fhKC98FsS63bdTHP5mkguDUvDk82s6Z8cEkdOlToy00NEZz
 SvEOR0X0odwBLMSr130fEcLaibcRh0+p5Yyt7FIfuEYhWpzlaT9WI+Eg+Mqp/hfvRZqc/VKLj
 3QYw1ddrTu8UT6Yy+YIg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Going through all uses of timeval, I noticed that we screwed up
input_event in the previous attempts to fix it:

The time fields now match between kernel and user space, but
all following fields are in the wrong place.

Add the required padding that is implied by the glibc timeval
definition to fix the layout, and use a struct initializer
to avoid leaking kernel stack data.

Cc: sparclinux@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Fixes: 141e5dcaa735 ("Input: input_event - fix the CONFIG_SPARC64 mixup")
Fixes: 2e746942ebac ("Input: input_event - provide override for sparc64")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/input/evdev.c       | 14 +++++++-------
 drivers/input/misc/uinput.c | 14 +++++++++-----
 include/uapi/linux/input.h  |  1 +
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index d7dd6fcf2db0..f918fca9ada3 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -224,13 +224,13 @@ static void __pass_event(struct evdev_client *client,
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
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index fd253781be71..2dabbe47d43e 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -74,12 +74,16 @@ static int uinput_dev_event(struct input_dev *dev,
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
diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index f056b2a00d5c..9a61c28ed3ae 100644
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
-- 
2.20.0

