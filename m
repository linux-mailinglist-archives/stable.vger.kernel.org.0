Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78BD2B74F9
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 10:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbfISISl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 04:18:41 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35763 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731438AbfISISl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 04:18:41 -0400
Received: by mail-lf1-f66.google.com with SMTP id w6so1692353lfl.2;
        Thu, 19 Sep 2019 01:18:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=41PvRhGRLq0dlBM5WD0KyQTd8CspilI9BYvqI9ESeqY=;
        b=jaqaea8pq2YMLXDsgitliBYKlTEp/SWDVlmYSqytEsc+hO7zqyvXonJEewOjy1eZUG
         py0DSw49E4iWG79ogZPOOcorQN+oKZ50eQCOxgsC1lHgzP/z2HBfjgLJa9F3H1nJX/hY
         Zy8hLhWgNNEuZPHYOy5a9ADDRtb0EeB4MS4cYVmu6YJAx3aCsi6vO55tQiRXgimjI7Uc
         uR+3wR9IGfLgFUa8+kqQQk3BVExkqRi0v4Pwzms2o+dZ7Qh6SqZ7m4BKo7E72qXJc6Gh
         MHi5jCLP0QsesanVWj5H6FZXXf7yt50gO4AVGPqsCeOsWE2q6F9a0b9Mo5OoIvdkwADR
         rg6w==
X-Gm-Message-State: APjAAAXouppEVfHobCmL9SXdsnJqLVoQj03q18Ig9UAYkZTiByKrEN2u
        JyhHF9bzh7FtfLR0RzXB57WJvJ5+
X-Google-Smtp-Source: APXvYqwvgUFbUYoSP+QmdWnjtl75JNe+swZCRFGtaUYhuavjY6QqsYGv4d+kSblLOLjALHSSExtNNw==
X-Received: by 2002:ac2:52a9:: with SMTP id r9mr4233821lfm.172.1568881119509;
        Thu, 19 Sep 2019 01:18:39 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id b63sm1481804ljf.38.2019.09.19.01.18.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 01:18:37 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iAre8-0007vd-Oy; Thu, 19 Sep 2019 10:18:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+f9549f5ee8a5416f0b95@syzkaller.appspotmail.com
Subject: [PATCH 2/4] USB: legousbtower: fix deadlock on disconnect
Date:   Thu, 19 Sep 2019 10:18:13 +0200
Message-Id: <20190919081815.30422-3-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919081815.30422-1-johan@kernel.org>
References: <20190919081815.30422-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a potential deadlock if disconnect races with open.

Since commit d4ead16f50f9 ("USB: prevent char device open/deregister
race") core holds an rw-semaphore while open is called and when
releasing the minor number during deregistration. This can lead to an
ABBA deadlock if a driver takes a lock in open which it also holds
during deregistration.

This effectively reverts commit 78663ecc344b ("USB: disconnect open race
in legousbtower") which needlessly introduced this issue after a generic
fix for this race had been added to core by commit d4ead16f50f9 ("USB:
prevent char device open/deregister race").

Fixes: 78663ecc344b ("USB: disconnect open race in legousbtower")
Cc: stable <stable@vger.kernel.org>	# 2.6.24
Reported-by: syzbot+f9549f5ee8a5416f0b95@syzkaller.appspotmail.com
Tested-by: syzbot+f9549f5ee8a5416f0b95@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/misc/legousbtower.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 1db07d4dc738..773e4188f336 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -179,7 +179,6 @@ static const struct usb_device_id tower_table[] = {
 };
 
 MODULE_DEVICE_TABLE (usb, tower_table);
-static DEFINE_MUTEX(open_disc_mutex);
 
 #define LEGO_USB_TOWER_MINOR_BASE	160
 
@@ -332,18 +331,14 @@ static int tower_open (struct inode *inode, struct file *file)
 		goto exit;
 	}
 
-	mutex_lock(&open_disc_mutex);
 	dev = usb_get_intfdata(interface);
-
 	if (!dev) {
-		mutex_unlock(&open_disc_mutex);
 		retval = -ENODEV;
 		goto exit;
 	}
 
 	/* lock this device */
 	if (mutex_lock_interruptible(&dev->lock)) {
-		mutex_unlock(&open_disc_mutex);
 	        retval = -ERESTARTSYS;
 		goto exit;
 	}
@@ -351,12 +346,10 @@ static int tower_open (struct inode *inode, struct file *file)
 
 	/* allow opening only once */
 	if (dev->open_count) {
-		mutex_unlock(&open_disc_mutex);
 		retval = -EBUSY;
 		goto unlock_exit;
 	}
 	dev->open_count = 1;
-	mutex_unlock(&open_disc_mutex);
 
 	/* reset the tower */
 	result = usb_control_msg (dev->udev,
@@ -423,10 +416,9 @@ static int tower_release (struct inode *inode, struct file *file)
 
 	if (dev == NULL) {
 		retval = -ENODEV;
-		goto exit_nolock;
+		goto exit;
 	}
 
-	mutex_lock(&open_disc_mutex);
 	if (mutex_lock_interruptible(&dev->lock)) {
 	        retval = -ERESTARTSYS;
 		goto exit;
@@ -456,10 +448,7 @@ static int tower_release (struct inode *inode, struct file *file)
 
 unlock_exit:
 	mutex_unlock(&dev->lock);
-
 exit:
-	mutex_unlock(&open_disc_mutex);
-exit_nolock:
 	return retval;
 }
 
@@ -912,7 +901,6 @@ static int tower_probe (struct usb_interface *interface, const struct usb_device
 	if (retval) {
 		/* something prevented us from registering this driver */
 		dev_err(idev, "Not able to get a minor for this device.\n");
-		usb_set_intfdata (interface, NULL);
 		goto error;
 	}
 	dev->minor = interface->minor;
@@ -944,16 +932,13 @@ static void tower_disconnect (struct usb_interface *interface)
 	int minor;
 
 	dev = usb_get_intfdata (interface);
-	mutex_lock(&open_disc_mutex);
-	usb_set_intfdata (interface, NULL);
 
 	minor = dev->minor;
 
-	/* give back our minor */
+	/* give back our minor and prevent further open() */
 	usb_deregister_dev (interface, &tower_class);
 
 	mutex_lock(&dev->lock);
-	mutex_unlock(&open_disc_mutex);
 
 	/* if the device is not opened, then we clean up right now */
 	if (!dev->open_count) {
-- 
2.23.0

