Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB20F58A7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfKHUh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 15:37:59 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:60679 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKHUh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 15:37:59 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M9Evp-1iWjmN29CR-006RBe; Fri, 08 Nov 2019 21:37:48 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     y2038@lists.linaro.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        sparclinux@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-input@vger.kernel.org
Subject: [PATCH 8/8] Input: input_event: fix struct padding on sparc64
Date:   Fri,  8 Nov 2019 21:34:31 +0100
Message-Id: <20191108203435.112759-9-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191108203435.112759-1-arnd@arndb.de>
References: <20191108203435.112759-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:u6kVp9UKD+j5V6nf6JiBnsKaa0LcdKVi2XG79PhwgluwxaPn537
 JqX1+w4EzLmlGXpLjxX9AvVL+FsYlf7H6657Eapb17jd5kmqUqyaJHFBxnMPnUd4juxe6KT
 gRpRzLHS22sv0vGG9873r88aFqFY8GB1dGUaJUbh67CrdY3MMA9TlE3CGVC1wvOspK+YRBE
 tWERzIcvD8mD0C9zkhlRQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QoQHUljkwik=:jlY4L3FT8f0wD8u1XiFw7Z
 h3+AyZXRuq5c8ebfbAH/dp8y2Q5jMb+GbbhsPaEA2a7MPF1PF/N8JuK+q2AFFRuQJcHecE6M2
 wyIrgZ4fyGSpTREXcdY8PDWuk/NtBKzZuKkXyHreMWKYQub8/FI5mePtE7aORk/e14hj/mB2O
 ERwQFQyraRgE7aYwcH5d4B5CZX+k89/xrvFv2kNZc5Z5PmRNkIN/dfMDxpD9aNji++3uKGg5K
 AgkohYYZmv9XNXkwL4dC3iSCaEca5btoxk2/9tcBUUVMJRhDwgL0bAJpyaGLxrp9+H3ktoABj
 aUtYxzpSgzDnIhxNLyYgM00SIurLlTKQ2fzkQaOvqxXIi4CAcyLH1rfiJPGo+GCK3zdNV0Qbk
 1tWSII8WsC8sUNoRFhra6Om83Cthg66/7Lsnsvg7fKe3SlHkJpiJBzCxl3eSI/6XAkKG9OWWc
 owcuBuy3UuodiSTwazfxz3NQMGzvnKY+wGFVxuEYPPkJ6JHrVYCd+5k4SnScsgSHJmg3p/yzv
 mApihJBs6/Xj8PCPN688hICGCI4M/ldYU4qdniL17PGVFqVE6QB7E1cu1mOVvvgYUsudeZtcg
 b9b0JX0eKZAb1NfjT445ZS3XzyifaRdVy4gi/coV2v9AHQP8DkYepKymu7sYuKjOSP7D/Z9/v
 f5+XK1Qa4rLaE+NmzvrJxEItcA6IKiB814x53Xq2UjTXCL767wY+LuxXdNdewEwAcjaf+9AqF
 4iTvqs2QG0ugID76PJtSFqafr2c+sFqAflhL5Rc1RDkBWSQEUKPY3LJtUvVXP/CWSb0K3R14B
 Z3HQVxs+9OTO5jfMMLic3qWm8pn596v8xSot4nX0YnaO5nZSRxY4d0rIjcHMmLjGXxEqFG4m9
 uUXYlF7efhWsZ7UEubSA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Going through all uses of timeval, I noticed that we screwed up
input_event in the previous attempts to fix it:

The time fields now match between kernel and user space, but
all following fields are in the wrong place.

Add the required padding that is implied by the glibc timeval
definition to fix the layout, and add explicit initialization
to avoid leaking kernel stack data.

Cc: sparclinux@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org
Fixes: 141e5dcaa735 ("Input: input_event - fix the CONFIG_SPARC64 mixup")
Fixes: 2e746942ebac ("Input: input_event - provide override for sparc64")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/input/evdev.c       | 3 +++
 drivers/input/misc/uinput.c | 3 +++
 include/uapi/linux/input.h  | 1 +
 3 files changed, 7 insertions(+)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index d7dd6fcf2db0..24a90793caf0 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -228,6 +228,9 @@ static void __pass_event(struct evdev_client *client,
 						event->input_event_sec;
 		client->buffer[client->tail].input_event_usec =
 						event->input_event_usec;
+#ifdef CONFIG_SPARC64
+		client->buffer[client->tail].__pad = 0;
+#endif
 		client->buffer[client->tail].type = EV_SYN;
 		client->buffer[client->tail].code = SYN_DROPPED;
 		client->buffer[client->tail].value = 0;
diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 84051f20b18a..1d8c09e9fd47 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -80,6 +80,9 @@ static int uinput_dev_event(struct input_dev *dev,
 	ktime_get_ts64(&ts);
 	udev->buff[udev->head].input_event_sec = ts.tv_sec;
 	udev->buff[udev->head].input_event_usec = ts.tv_nsec / NSEC_PER_USEC;
+#ifdef CONFIG_SPARC64
+	udev->buff[udev->head].__pad = 0;
+#endif
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

