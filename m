Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C997A2F71E3
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 06:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbhAOFCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 00:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbhAOFCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 00:02:20 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F87C061757
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 21:01:39 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id 186so10664572qkj.3
        for <stable@vger.kernel.org>; Thu, 14 Jan 2021 21:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=4Da2wrXcwvMW3xjxzg5Yzo+hsQu0xI6skXEZ8PGHeBo=;
        b=VVQir19ai2MAc6/lWm0GP/+8uz1B0HQvBF/8Y4pXgSPvNtG0Z+1KNfj+zcXZN+1Cye
         3kOdouEdc0wpkTGOZqxltUYjs6knw98ICw7qYA8E/lNNSNKDkwsW0taa5sA+ugrzN/Ew
         97naxN6KCEx9JWQAD9uNGjCnsknKl4pxknq+byoBNsGshv5PjceBk+BobcdRbHtE3VDQ
         n+ukMHc5fQGwxSaSsgTMe8STWcDJM2MDMnZtptHWYHzo81g16bJBiMU93mDytKMe+JIu
         nGN4eol/OBroGpjl4jMpgoOEvxn5uUxd92FGaZ/B7jFWX9IqKidvMUsgtXw0rLXkk1Cr
         KJbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=4Da2wrXcwvMW3xjxzg5Yzo+hsQu0xI6skXEZ8PGHeBo=;
        b=E6lv6cKytfdhKvDCJ/nyVWhfZLR7/JxjjZaD9s3XIRq8Frh0jU6x2MyOzFZxRrMpXx
         Dfdlfy8VSPhQm35E2wLyFzIClP9Hez/hzfV6CfbMvg4Be9GGnk8zi8No9QQxnegPBl2s
         o4qxg7BX1RfK6/pbhjoXPnf5kDk4RouNY+BiiUeylUYyMVetN/sTIdgnlwIiG03XZoNF
         jL/aSWqkytllXABP/nUtiMvWdjLE17PE5bhl6qs3A7VpaKCmmE4PJca/5Is0SdzNYgHi
         dsPnNfRoMqBdRT+M3PFZjkIdwlkiqpgJ5rOT6CXHdleZ0wdNavXppEDWJywju55wGdwG
         CHWg==
X-Gm-Message-State: AOAM531bJBDQWyqr34zleCNbSPRrFv1vzo9m2MwO0HPJD6WkfpwcnThH
        S62o122+o18AeyLQEf6CvBg+22jgcH0ArCwkqdTUTl5nxye2iw==
X-Google-Smtp-Source: ABdhPJxVT8Y5Sx/Vi5Fe/OLr8eZd0j8ACTXg74oFPMGMZ4tKpSNw6wD1cLbgik9NwOTvK3zwfox8T2eN2nsoyavC0C0=
X-Received: by 2002:a05:620a:1256:: with SMTP id a22mr10630742qkl.484.1610686898628;
 Thu, 14 Jan 2021 21:01:38 -0800 (PST)
MIME-Version: 1.0
References: <20201210045230.26343-1-ping.cheng@wacom.com>
In-Reply-To: <20201210045230.26343-1-ping.cheng@wacom.com>
From:   Ping Cheng <pinglinux@gmail.com>
Date:   Thu, 14 Jan 2021 21:01:27 -0800
Message-ID: <CAF8JNhJupLp4hEaut-W2d1eO1EyV1WmdgRh0z0bPqHP1jGQkWQ@mail.gmail.com>
Subject: [PATCH] HID: wacom: Fix memory leakage caused by kfifo_alloc
To:     stable kernel <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch has been merged to Linus tree. The upstream commit ID is
37309f47e2f5.

The issue was introduced by 83417206427b ("HID: wacom: Queue events
with missing type/serial data for later processing"). I forgot to cc
stable.

Let me know if you have questions,
Ping

---------- Forwarded message ---------
From: Ping Cheng <pinglinux@gmail.com>
Date: Wed, Dec 9, 2020 at 8:52 PM
Subject: [PATCH] HID: wacom: Fix memory leakage caused by kfifo_alloc
To: <linux-input@vger.kernel.org>,
<syzbot+5b49c9695968d7250a26@syzkaller.appspotmail.com>
Cc: <jkosina@suse.cz>, <benjamin.tissoires@gmail.com>, Ping Cheng
<ping.cheng@wacom.com>


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
   [<00000000c6add147>] usbhid_probe+0x412/0x560
drivers/hid/usbhid/hid-core.c:1407
   [<00000000c33acdb4>] usb_probe_interface+0x177/0x370
drivers/usb/core/driver.c:396
   [<00000000aff7c640>] really_probe+0x159/0x480 drivers/base/dd.c:554
   [<00000000778d0bc3>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
   [<000000005108dbb5>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844

https://syzkaller.appspot.com/bug?extid=5b49c9695968d7250a26

Reported-by: syzbot+5b49c9695968d7250a26@syzkaller.appspotmail.com
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_sys.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index cd71e7133944..9e852b4bbf92 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -1270,6 +1270,37 @@ static int wacom_devm_sysfs_create_group(struct
wacom *wacom,
                                               group);
 }

+static void wacom_devm_kfifo_release(struct device *dev, void *res)
+{
+       struct kfifo_rec_ptr_2 *devres = res;
+
+       kfifo_free(devres);
+}
+
+static int wacom_devm_kfifo_alloc(struct wacom *wacom)
+{
+       struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+       struct kfifo_rec_ptr_2 *pen_fifo = &wacom_wac->pen_fifo;
+       int error;
+
+       pen_fifo = devres_alloc(wacom_devm_kfifo_release,
+                             sizeof(struct kfifo_rec_ptr_2),
+                             GFP_KERNEL);
+
+       if (!pen_fifo)
+               return -ENOMEM;
+
+       error = kfifo_alloc(pen_fifo, WACOM_PKGLEN_MAX, GFP_KERNEL);
+       if (error) {
+               devres_free(pen_fifo);
+               return error;
+       }
+
+       devres_add(&wacom->hdev->dev, pen_fifo);
+
+       return 0;
+}
+
 enum led_brightness wacom_leds_brightness_get(struct wacom_led *led)
 {
        struct wacom *wacom = led->wacom;
@@ -2724,7 +2755,7 @@ static int wacom_probe(struct hid_device *hdev,
        if (features->check_for_hid_type && features->hid_type != hdev->type)
                return -ENODEV;

-       error = kfifo_alloc(&wacom_wac->pen_fifo, WACOM_PKGLEN_MAX, GFP_KERNEL);
+       error = wacom_devm_kfifo_alloc(wacom);
        if (error)
                return error;

@@ -2786,8 +2817,6 @@ static void wacom_remove(struct hid_device *hdev)

        if (wacom->wacom_wac.features.type != REMOTE)
                wacom_release_resources(wacom);
-
-       kfifo_free(&wacom_wac->pen_fifo);
 }

 #ifdef CONFIG_PM
--
2.17.1
