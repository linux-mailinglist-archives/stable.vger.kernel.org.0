Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F2EDC84B
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 17:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501909AbfJRPUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 11:20:06 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35527 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501908AbfJRPUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 11:20:05 -0400
Received: by mail-lf1-f68.google.com with SMTP id w6so5030121lfl.2;
        Fri, 18 Oct 2019 08:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+AnJxrgOsF5pdHMRsdpMSMexStt/hgIWSycUyGA4QAg=;
        b=JRFvI3s7v+dr38puTvmC9iBqpU9pPsECM026W3PKld7UNAXFPbFz5r9bdS4GFfP/eG
         Dy+aWu+AXVRp9HoMfO+UZ3LYoxW/bFdgZrMu898bwULHsJ5fHZtFIOZofdxqRGNbvJ8T
         NwlybpP7mUpSJgV6QM7b/ioPiyKDi6bea1tYcdVObMF2PFaeUuGUe0QMOykiaUqNGBlp
         6M5KOL0N6nP7xQ861JL+sGHvmLghc852AP56TlmdZoK1kWrDihqTQBl+DJMrIGlOHLwh
         Wdl0LVBv6yXnlcUKqrwk9ceSOaACbTIhidQdyiRJj050D8e8utsKCK6flI56tInSvgkx
         121A==
X-Gm-Message-State: APjAAAUn7mKJtsJaI4tKF3zZBDXDYxuRLYzJmSE4RxYFUaNWBYsa0lE6
        h+VqRAFUoIWIOZ1oYhLe14U=
X-Google-Smtp-Source: APXvYqwZnHP5fM5ugg6DkmTBhXwuX0nTdcQH4m5Fbj3XQEpFQnlDh8mVi/DdcZNeL+QLbwYoMnxK9w==
X-Received: by 2002:a19:c6d6:: with SMTP id w205mr5561511lff.17.1571412001935;
        Fri, 18 Oct 2019 08:20:01 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id x5sm3197980lfg.71.2019.10.18.08.19.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 08:19:58 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iLU31-0006YM-6x; Fri, 18 Oct 2019 17:20:11 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH RFC v2 2/2] USB: ldusb: fix ring-buffer locking
Date:   Fri, 18 Oct 2019 17:19:55 +0200
Message-Id: <20191018151955.25135-3-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191018151955.25135-1-johan@kernel.org>
References: <20191018151955.25135-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The custom ring-buffer implementation was merged without any locking
whatsoever, but a spinlock was later added by commit 9d33efd9a791
("USB: ldusb bugfix").

The lock did not cover the loads from the ring-buffer entry after
determining the buffer was non-empty, nor the update of the tail index
once the entry had been processed. The former could lead to stale data
being returned, while the latter could lead to memory corruption on
sufficiently weakly ordered architectures.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Fixes: 9d33efd9a791 ("USB: ldusb bugfix")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/ldusb.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index 15b5f06fb0b3..6b5843b0071e 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -477,11 +477,11 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
 
 		spin_lock_irq(&dev->rbsl);
 	}
-	spin_unlock_irq(&dev->rbsl);
 
 	/* actual_buffer contains actual_length + interrupt_in_buffer */
 	actual_buffer = (size_t *)(dev->ring_buffer + dev->ring_tail * (sizeof(size_t)+dev->interrupt_in_endpoint_size));
 	if (*actual_buffer > dev->interrupt_in_endpoint_size) {
+		spin_unlock_irq(&dev->rbsl);
 		retval = -EIO;
 		goto unlock_exit;
 	}
@@ -489,17 +489,26 @@ static ssize_t ld_usb_read(struct file *file, char __user *buffer, size_t count,
 	if (bytes_to_read < *actual_buffer)
 		dev_warn(&dev->intf->dev, "Read buffer overflow, %zd bytes dropped\n",
 			 *actual_buffer-bytes_to_read);
+	spin_unlock_irq(&dev->rbsl);
+
+	/*
+	 * Pairs with spin_unlock_irqrestore() in
+	 * ld_usb_interrupt_in_callback() and makes sure the ring-buffer entry
+	 * has been updated before copy_to_user().
+	 */
+	smp_rmb();
 
 	/* copy one interrupt_in_buffer from ring_buffer into userspace */
 	if (copy_to_user(buffer, actual_buffer+1, bytes_to_read)) {
 		retval = -EFAULT;
 		goto unlock_exit;
 	}
-	dev->ring_tail = (dev->ring_tail+1) % ring_buffer_size;
-
 	retval = bytes_to_read;
 
 	spin_lock_irq(&dev->rbsl);
+
+	dev->ring_tail = (dev->ring_tail + 1) % ring_buffer_size;
+
 	if (dev->buffer_overflow) {
 		dev->buffer_overflow = 0;
 		spin_unlock_irq(&dev->rbsl);
-- 
2.23.0

