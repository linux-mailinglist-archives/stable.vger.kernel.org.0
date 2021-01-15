Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2CE2F7B82
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbhAONCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:02:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731571AbhAOMct (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:32:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A45323370;
        Fri, 15 Jan 2021 12:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713953;
        bh=Gt+rQPe5/Sexg0deAvmAIeRLgOhY//NlDdJoT7x92pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfbcFz9G0TK80n3g7jlbsXjBNdyxnISRkXNlb8mrBkn0cP5XS1FI9/wlvuV3Jx/WM
         V+GE6Q2w0qoQ4p2LhcYQ92EywqTCKxZUUnuYMXxMFwhEGj6WIRJOw/TOGSzOUmqMXr
         Hbll00Ki25OmJxifX7p2ftStUeX8h9qzdZFdXfpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5b49c9695968d7250a26@syzkaller.appspotmail.com,
        Ping Cheng <ping.cheng@wacom.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 23/43] HID: wacom: Fix memory leakage caused by kfifo_alloc
Date:   Fri, 15 Jan 2021 13:27:53 +0100
Message-Id: <20210115121958.174264650@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121957.037407908@linuxfoundation.org>
References: <20210115121957.037407908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping Cheng <pinglinux@gmail.com>

commit 37309f47e2f5674f3e86cb765312ace42cfcedf5 upstream.

As reported by syzbot below, kfifo_alloc'd memory would not be freed
if a non-zero return value is triggered in wacom_probe. This patch
creates and uses devm_kfifo_alloc to allocate and free itself.

BUG: memory leak
unreferenced object 0xffff88810dc44a00 (size 512):
  comm "kworker/1:2", pid 3674, jiffies 4294943617 (age 14.100s)
  hex dump (first 32 bytes):
   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
   [<0000000023e1afac>] kmalloc_array include/linux/slab.h:592 [inline]
   [<0000000023e1afac>] __kfifo_alloc+0xad/0x100 lib/kfifo.c:43
   [<00000000c477f737>] wacom_probe+0x1a1/0x3b0 drivers/hid/wacom_sys.c:2727
   [<00000000b3109aca>] hid_device_probe+0x16b/0x210 drivers/hid/hid-core.c:2281
   [<00000000aff7c640>] really_probe+0x159/0x480 drivers/base/dd.c:554
   [<00000000778d0bc3>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
   [<000000005108dbb5>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844
   [<00000000efb7c59e>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431
   [<0000000024ab1590>] __device_attach+0x122/0x250 drivers/base/dd.c:912
   [<000000004c7ac048>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:491
   [<00000000b93050a3>] device_add+0x5ac/0xc30 drivers/base/core.c:2936
   [<00000000e5b46ea5>] hid_add_device+0x151/0x390 drivers/hid/hid-core.c:2437
   [<00000000c6add147>] usbhid_probe+0x412/0x560 drivers/hid/usbhid/hid-core.c:1407
   [<00000000c33acdb4>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
   [<00000000aff7c640>] really_probe+0x159/0x480 drivers/base/dd.c:554
   [<00000000778d0bc3>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
   [<000000005108dbb5>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844

https://syzkaller.appspot.com/bug?extid=5b49c9695968d7250a26

Reported-by: syzbot+5b49c9695968d7250a26@syzkaller.appspotmail.com
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/wacom_sys.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -1241,6 +1241,37 @@ static int wacom_devm_sysfs_create_group
 					       group);
 }
 
+static void wacom_devm_kfifo_release(struct device *dev, void *res)
+{
+	struct kfifo_rec_ptr_2 *devres = res;
+
+	kfifo_free(devres);
+}
+
+static int wacom_devm_kfifo_alloc(struct wacom *wacom)
+{
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+	struct kfifo_rec_ptr_2 *pen_fifo = &wacom_wac->pen_fifo;
+	int error;
+
+	pen_fifo = devres_alloc(wacom_devm_kfifo_release,
+			      sizeof(struct kfifo_rec_ptr_2),
+			      GFP_KERNEL);
+
+	if (!pen_fifo)
+		return -ENOMEM;
+
+	error = kfifo_alloc(pen_fifo, WACOM_PKGLEN_MAX, GFP_KERNEL);
+	if (error) {
+		devres_free(pen_fifo);
+		return error;
+	}
+
+	devres_add(&wacom->hdev->dev, pen_fifo);
+
+	return 0;
+}
+
 enum led_brightness wacom_leds_brightness_get(struct wacom_led *led)
 {
 	struct wacom *wacom = led->wacom;
@@ -2697,7 +2728,7 @@ static int wacom_probe(struct hid_device
 		goto fail;
 	}
 
-	error = kfifo_alloc(&wacom_wac->pen_fifo, WACOM_PKGLEN_MAX, GFP_KERNEL);
+	error = wacom_devm_kfifo_alloc(wacom);
 	if (error)
 		goto fail;
 
@@ -2764,8 +2795,6 @@ static void wacom_remove(struct hid_devi
 	if (wacom->wacom_wac.features.type != REMOTE)
 		wacom_release_resources(wacom);
 
-	kfifo_free(&wacom_wac->pen_fifo);
-
 	hid_set_drvdata(hdev, NULL);
 }
 


