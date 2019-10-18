Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADAF2DC848
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 17:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439596AbfJRPUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 11:20:03 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45297 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390388AbfJRPUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 11:20:02 -0400
Received: by mail-lj1-f194.google.com with SMTP id q64so6588494ljb.12;
        Fri, 18 Oct 2019 08:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NWEsXs2dpg7Z5tah6xitYaTbPYgefyb7xkTWhkm2Qdg=;
        b=RIJXSBl/VZkTLWruORCmOEYauiHEoxNiBYt2tKuZuWo4lBqT4RKwWH8clwAetLlSjg
         y9m2NwyQr9jJdsGN9PLH7CwQN/xbs2xdV40o3grwQQTKvyT4YapYvkIbt6r+px8+HjVC
         mCHpmTVjT8rLYOqXQmG7cJk+mymp8KYcvcYySfrpAWcWb9w1VbyLh1e8ddWwOntG+2Tl
         Oqmj3lpgUtKmGrCLHqoOcSowC7iRJjnHQTFPTuQIVjhB7JWAPCQxPenZ/CHXq0AA8oVb
         BLKneJZAzybZqdvT3kFH6DPvlDDEh36fBk0urlkFYd0wbLAG4iY8lyRwQWAfi7FcgVrb
         C68g==
X-Gm-Message-State: APjAAAVvf9/TaGcCg27mD7loPY48RAtn7hu2vcpREroK3sl+Bt4CQjdx
        ywArCeBgt9Zw7AYvio//lTMmU/xW
X-Google-Smtp-Source: APXvYqzXBMIbd9C3xS8GBqkUeuj4fmTPf93b5jl3oFBp4ALul+QVERZ5wgPQOftfyeX8gkzQrbE26Q==
X-Received: by 2002:a2e:8e87:: with SMTP id z7mr6588549ljk.9.1571412000231;
        Fri, 18 Oct 2019 08:20:00 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id u21sm5340202lje.92.2019.10.18.08.19.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 08:19:58 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iLU31-0006YH-3u; Fri, 18 Oct 2019 17:20:11 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+6fe95b826644f7f12b0b@syzkaller.appspotmail.com
Subject: [PATCH v2 1/2] USB: ldusb: fix read info leaks
Date:   Fri, 18 Oct 2019 17:19:54 +0200
Message-Id: <20191018151955.25135-2-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191018151955.25135-1-johan@kernel.org>
References: <20191018151955.25135-1-johan@kernel.org>
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
index 147c90c2a4e5..15b5f06fb0b3 100644
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
+	if (*actual_buffer > dev->interrupt_in_endpoint_size) {
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

