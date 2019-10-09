Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887F8D1313
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 17:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbfJIPi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 11:38:59 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39471 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730256AbfJIPi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 11:38:58 -0400
Received: by mail-lj1-f196.google.com with SMTP id y3so2972650ljj.6;
        Wed, 09 Oct 2019 08:38:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HWGhrR9zQu1kilGXu57u8nXDF16dj6cYe7KVAB6aMHE=;
        b=BlRdKv4v90THg+nkgbe0I7PiRPG5nFa35/cCKTTPuR8NT4eqYCEbcMHWhQ++QJzhDq
         +AiDZ2rQZLi3Xp8RcaSZAicwJYADaAvAIfC2aaZjrcuxcAgh4oQaKNcqsX154yf64BDj
         FX0cB6QuZ8c2JDFOhTeYcdWqohQkLw2qyraRTmaXSDkMVXvV2HsGkh1Z6TqPycnWiwz+
         xO8n+t8VgyigUvDbUTO0iOqrjpjuvcHP0fTs8wbnGWS3/rzB7NlhQEJJGBRoZLls+ujm
         DfQSRfseAIrOEoN7jE1pXbyDbiKAG6WzDCV9cUI+dC5jEtYrKduWJLTusRWsibQNsQ3Z
         JB1A==
X-Gm-Message-State: APjAAAVZ7Rj/3g3TUIlFBG5+r1QJTluY9HtOYUrh2wH0wsvzMPixB+T5
        3g+GoucYnYLfy6KnCWMfl2c=
X-Google-Smtp-Source: APXvYqzgDRhvqsI7XYqf5WepTJJQPmEGHKpTr7OeYL0U2W3l+9ztSYKra5VsB2hq888+pTB4gD8J/g==
X-Received: by 2002:a2e:b17b:: with SMTP id a27mr2765429ljm.7.1570635535414;
        Wed, 09 Oct 2019 08:38:55 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id 4sm557492ljv.87.2019.10.09.08.38.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 08:38:53 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iIE3J-0002HB-Kq; Wed, 09 Oct 2019 17:39:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 5/5] USB: yurex: fix NULL-derefs on disconnect
Date:   Wed,  9 Oct 2019 17:38:48 +0200
Message-Id: <20191009153848.8664-6-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009153848.8664-1-johan@kernel.org>
References: <20191009153848.8664-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver was using its struct usb_interface pointer as an inverted
disconnected flag, but was setting it to NULL without making sure all
code paths that used it were done with it.

Before commit ef61eb43ada6 ("USB: yurex: Fix protection fault after
device removal") this included the interrupt-in completion handler, but
there are further accesses in dev_err and dev_dbg statements in
yurex_write() and the driver-data destructor (sic!).

Fix this by unconditionally stopping also the control URB at disconnect
and by using a dedicated disconnected flag.

Note that we need to take a reference to the struct usb_interface to
avoid a use-after-free in the destructor whenever the device was
disconnected while the character device was still open.

Fixes: aadd6472d904 ("USB: yurex.c: remove dbg() usage")
Fixes: 45714104b9e8 ("USB: yurex.c: remove err() usage")
Cc: stable <stable@vger.kernel.org>     # 3.5: ef61eb43ada6
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/yurex.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 8d52d4336c29..be0505b8b5d4 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -60,6 +60,7 @@ struct usb_yurex {
 
 	struct kref		kref;
 	struct mutex		io_mutex;
+	unsigned long		disconnected:1;
 	struct fasync_struct	*async_queue;
 	wait_queue_head_t	waitq;
 
@@ -107,6 +108,7 @@ static void yurex_delete(struct kref *kref)
 				dev->int_buffer, dev->urb->transfer_dma);
 		usb_free_urb(dev->urb);
 	}
+	usb_put_intf(dev->interface);
 	usb_put_dev(dev->udev);
 	kfree(dev);
 }
@@ -205,7 +207,7 @@ static int yurex_probe(struct usb_interface *interface, const struct usb_device_
 	init_waitqueue_head(&dev->waitq);
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
-	dev->interface = interface;
+	dev->interface = usb_get_intf(interface);
 
 	/* set up the endpoint information */
 	iface_desc = interface->cur_altsetting;
@@ -316,8 +318,9 @@ static void yurex_disconnect(struct usb_interface *interface)
 
 	/* prevent more I/O from starting */
 	usb_poison_urb(dev->urb);
+	usb_poison_urb(dev->cntl_urb);
 	mutex_lock(&dev->io_mutex);
-	dev->interface = NULL;
+	dev->disconnected = 1;
 	mutex_unlock(&dev->io_mutex);
 
 	/* wakeup waiters */
@@ -405,7 +408,7 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 	dev = file->private_data;
 
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* already disconnected */
+	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		return -ENODEV;
 	}
@@ -440,7 +443,7 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
 		goto error;
 
 	mutex_lock(&dev->io_mutex);
-	if (!dev->interface) {		/* already disconnected */
+	if (dev->disconnected) {		/* already disconnected */
 		mutex_unlock(&dev->io_mutex);
 		retval = -ENODEV;
 		goto error;
-- 
2.23.0

