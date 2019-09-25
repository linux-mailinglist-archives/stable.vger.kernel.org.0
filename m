Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1D6BDAF4
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 11:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbfIYJ3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 05:29:25 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35249 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727635AbfIYJ3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 05:29:24 -0400
Received: by mail-lj1-f195.google.com with SMTP id m7so4904784lji.2;
        Wed, 25 Sep 2019 02:29:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dd8Bj+SsAYNVwg79OrKDBOgClQX6Coby2DC7H5g+GYE=;
        b=UiP/ID2ZahT5uajSj3GoWeoAu6hfIZrUyFJN8IQr0cJwzX1l+9X5CYz7chewQipwfI
         hHVSMnOvRJmvvPbOIR5A9EP4Cixxj47bw5CT/omrOtRc2CQImHb/VYWSEBLHGsLODD1H
         UxKL9NXzJsZN6VOvF42HFgxAq2GbTyVuWok+7Ml6Lzw1j807Wr9BInSbqzf6OrgW532l
         pKl4Zl7Ucrun9UmCkhV3jgWKT2s+aux7OS3gwK3xWGpwE6N60n+MB4oQGp23MHH4Q0Wl
         pah1krtgtQcqFxWONElP3GvF0VX+XZI1+zBn8CQWdLEwo0ubZJOTnYuWqhc6wOr5/Eni
         x2yg==
X-Gm-Message-State: APjAAAXRESkCj6lyY1vQPQoTH6IPu12iLpVu76amWxutJhCdJJHI6ir9
        s+SF3Q3aNxek89nurWOei/Q=
X-Google-Smtp-Source: APXvYqyiIMY4Vxtvl6Umln32hktQBkXEMinsP7PdVS4Fs+Ubv+S1yRPlBOeR/rElGGfRj6Nfegsf5g==
X-Received: by 2002:a05:651c:21b:: with SMTP id y27mr5256626ljn.219.1569403762537;
        Wed, 25 Sep 2019 02:29:22 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id t24sm1085858ljc.23.2019.09.25.02.29.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 02:29:21 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iD3c0-0002Fe-1f; Wed, 25 Sep 2019 11:29:28 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/2] USB: adutux: fix NULL-derefs on disconnect
Date:   Wed, 25 Sep 2019 11:29:13 +0200
Message-Id: <20190925092913.8608-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925092913.8608-1-johan@kernel.org>
References: <20190925092913.8608-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was using its struct usb_device pointer as an inverted
disconnected flag, but was setting it to NULL before making sure all
completion handlers had run. This could lead to a NULL-pointer
dereference in a number of dev_dbg statements in the completion handlers
which relies on said pointer.

The pointer was also dereferenced unconditionally in a dev_dbg statement
release() something which would lead to a NULL-deref whenever a device
was disconnected before the final character-device close if debugging
was enabled.

Fix this by unconditionally stopping all I/O and preventing
resubmissions by poisoning the interrupt URBs at disconnect and using a
dedicated disconnected flag.

This also makes sure that all I/O has completed by the time the
disconnect callback returns.

Fixes: 1ef37c6047fe ("USB: adutux: remove custom debug macro and module parameter")
Fixes: 66d4bc30d128 ("USB: adutux: remove custom debug macro")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/adutux.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index bcc138990e2f..f9efec719359 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -75,6 +75,7 @@ struct adu_device {
 	char			serial_number[8];
 
 	int			open_count; /* number of times this port has been opened */
+	unsigned long		disconnected:1;
 
 	char		*read_buffer_primary;
 	int			read_buffer_length;
@@ -116,7 +117,7 @@ static void adu_abort_transfers(struct adu_device *dev)
 {
 	unsigned long flags;
 
-	if (dev->udev == NULL)
+	if (dev->disconnected)
 		return;
 
 	/* shutdown transfer */
@@ -243,7 +244,7 @@ static int adu_open(struct inode *inode, struct file *file)
 	}
 
 	dev = usb_get_intfdata(interface);
-	if (!dev || !dev->udev) {
+	if (!dev) {
 		retval = -ENODEV;
 		goto exit_no_device;
 	}
@@ -326,7 +327,7 @@ static int adu_release(struct inode *inode, struct file *file)
 	}
 
 	adu_release_internal(dev);
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 		if (!dev->open_count)	/* ... and we're the last user */
 			adu_delete(dev);
@@ -354,7 +355,7 @@ static ssize_t adu_read(struct file *file, __user char *buffer, size_t count,
 		return -ERESTARTSYS;
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto exit;
@@ -518,7 +519,7 @@ static ssize_t adu_write(struct file *file, const __user char *buffer,
 		goto exit_nolock;
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto exit;
@@ -764,11 +765,14 @@ static void adu_disconnect(struct usb_interface *interface)
 
 	usb_deregister_dev(interface, &adu_class);
 
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&adutux_mutex);
 	usb_set_intfdata(interface, NULL);
 
 	mutex_lock(&dev->mtx);	/* not interruptible */
-	dev->udev = NULL;	/* poison */
+	dev->disconnected = 1;
 	mutex_unlock(&dev->mtx);
 
 	/* if the device is not opened, then we clean up right now */
-- 
2.23.0

