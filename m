Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9D5DC724
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 16:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442887AbfJROSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 10:18:41 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35811 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442841AbfJROSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 10:18:40 -0400
Received: by mail-lf1-f68.google.com with SMTP id w6so4872305lfl.2;
        Fri, 18 Oct 2019 07:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x5fLSsgcwRkjtr6+BGZpbF35YRXG1jBQ4j2b2IIrKsw=;
        b=aPOvcs1Nhzc3I1O3HsmpZEpdIyG8y8SG4x9Bi0HLnEdlrWXpq8DdJtUUpMrW2IVWz8
         2GaqHInlmblecx21nJ5iPkrLuw64mOVNW803gNkn/1D37t4t3/7Rck9xnZjRWdgWQqLy
         4m59H5dF2c2d+aqOgt7Ted4dDFYeCzBdC9NKc7a68Gf8pgpnkgPOiiOoZF5uXL8ErH5S
         cVAh8M1qxzKvhFBDO/NcQL1cAqVA+Dg3cY40x44ZZ0mVys9AXl72MIdHHgyB64bW80/T
         WbzpNgjvK3C4HDL/O8WYJBzE7CXT1u8lvgg7+hak+cxQ+SdrXjw9uWlwOEZsBMgJxpWJ
         Sqow==
X-Gm-Message-State: APjAAAX7WT7fx7JNzVg3ELRsc7327P7BOp+wRFZ3ZEK5zfrtwxsE/DOa
        tf0m6NSTvoyuShH8WFREAZ4=
X-Google-Smtp-Source: APXvYqwjzLZK3eeD7S7jRV6sdX/7KxZzeRukRCeOaTZmcwv/z19KM/T90ml2KOu3T+i9K4iwNjvqVQ==
X-Received: by 2002:a05:6512:219:: with SMTP id a25mr6443149lfo.155.1571408318664;
        Fri, 18 Oct 2019 07:18:38 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id c16sm2632736lfj.8.2019.10.18.07.18.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 07:18:36 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iLT5d-0006C9-6I; Fri, 18 Oct 2019 16:18:49 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+6fe95b826644f7f12b0b@syzkaller.appspotmail.com
Subject: [PATCH 1/2] USB: ldusb: fix read info leaks
Date:   Fri, 18 Oct 2019 16:17:49 +0200
Message-Id: <20191018141750.23756-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191018141750.23756-1-johan@kernel.org>
References: <20191018141750.23756-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix broken read implementation, which could be used to trigger slab info
leaks.

The driver failed to check if the custom ring buffer was still empty
when waking up after having waited for more data. This would happen on
every interrupt-in completion, even if no data had been added to the
ring buffer (e.g. on disconnect events).

Due to missing sanity checks and uninitialised (kmalloced) ring-buffer
entries, this meant that huge slab info leaks could easily be triggered.

Note that the empty-buffer check after wakeup is enough to fix the info
leak on disconnect, but let's clear the buffer on allocation and add a
sanity check to read() to prevent further leaks.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Reported-by: syzbot+6fe95b826644f7f12b0b@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/ldusb.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index 147c90c2a4e5..94780e14e95d 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -464,7 +464,7 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
 
 	/* wait for data */
 	spin_lock_irq(&dev->rbsl);
-	if (dev->ring_head == dev->ring_tail) {
+	while (dev->ring_head == dev->ring_tail) {
 		dev->interrupt_in_done = 0;
 		spin_unlock_irq(&dev->rbsl);
 		if (file->f_flags & O_NONBLOCK) {
@@ -474,12 +474,17 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
 		retval = wait_event_interruptible(dev->read_wait, dev->interrupt_in_done);
 		if (retval < 0)
 			goto unlock_exit;
-	} else {
-		spin_unlock_irq(&dev->rbsl);
+
+		spin_lock_irq(&dev->rbsl);
 	}
+	spin_unlock_irq(&dev->rbsl);
 
 	/* actual_buffer contains actual_length + interrupt_in_buffer */
 	actual_buffer = (size_t *)(dev->ring_buffer + dev->ring_tail * (sizeof(size_t)+dev->interrupt_in_endpoint_size));
+	if (*actual_buffer > sizeof(size_t) + dev->interrupt_in_endpoint_size) {
+		retval = -EIO;
+		goto unlock_exit;
+	}
 	bytes_to_read = min(count, *actual_buffer);
 	if (bytes_to_read < *actual_buffer)
 		dev_warn(&dev->intf->dev, "Read buffer overflow, %zd bytes dropped\n",
@@ -690,10 +695,9 @@ static int ld_usb_probe(struct usb_interface *intf, const struct usb_device_id *
 		dev_warn(&intf->dev, "Interrupt out endpoint not found (using control endpoint instead)\n");
 
 	dev->interrupt_in_endpoint_size = usb_endpoint_maxp(dev->interrupt_in_endpoint);
-	dev->ring_buffer =
-		kmalloc_array(ring_buffer_size,
-			      sizeof(size_t) + dev->interrupt_in_endpoint_size,
-			      GFP_KERNEL);
+	dev->ring_buffer = kcalloc(ring_buffer_size,
+			sizeof(size_t) + dev->interrupt_in_endpoint_size,
+			GFP_KERNEL);
 	if (!dev->ring_buffer)
 		goto error;
 	dev->interrupt_in_buffer = kmalloc(dev->interrupt_in_endpoint_size, GFP_KERNEL);
-- 
2.23.0

