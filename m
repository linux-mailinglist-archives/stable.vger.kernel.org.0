Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38050D9FEF
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388305AbfJPWGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438202AbfJPV6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:36 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF0221A49;
        Wed, 16 Oct 2019 21:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263116;
        bh=CJs3yn7alcvNqyp/9A9UfDSb6xC+SD3serV43YoYq3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cu26i0iXYbBJQw79mwiZ7cXwRBGyj4FEFxNgADcfxVDIW4JZIMjLE3zU9VcNeyt2/
         /C0TM7jzPvTUzBNvvt/rbcgBFAnoo//NMLWOPoKZeki0K8vE9UNpopygdnIxMUf1sL
         /TqRFCvd5nLeXU/dr5UzRuFDBHLM/EZTWXAHVrwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f9549f5ee8a5416f0b95@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 040/112] USB: legousbtower: fix deadlock on disconnect
Date:   Wed, 16 Oct 2019 14:50:32 -0700
Message-Id: <20191016214854.292268903@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 33a7813219f208f4952ece60ee255fd983272dec upstream.

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
Link: https://lore.kernel.org/r/20190919083039.30898-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/legousbtower.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -179,7 +179,6 @@ static const struct usb_device_id tower_
 };
 
 MODULE_DEVICE_TABLE (usb, tower_table);
-static DEFINE_MUTEX(open_disc_mutex);
 
 #define LEGO_USB_TOWER_MINOR_BASE	160
 
@@ -332,18 +331,14 @@ static int tower_open (struct inode *ino
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
@@ -351,12 +346,10 @@ static int tower_open (struct inode *ino
 
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
@@ -423,10 +416,9 @@ static int tower_release (struct inode *
 
 	if (dev == NULL) {
 		retval = -ENODEV;
-		goto exit_nolock;
+		goto exit;
 	}
 
-	mutex_lock(&open_disc_mutex);
 	if (mutex_lock_interruptible(&dev->lock)) {
 	        retval = -ERESTARTSYS;
 		goto exit;
@@ -456,10 +448,7 @@ static int tower_release (struct inode *
 
 unlock_exit:
 	mutex_unlock(&dev->lock);
-
 exit:
-	mutex_unlock(&open_disc_mutex);
-exit_nolock:
 	return retval;
 }
 
@@ -912,7 +901,6 @@ static int tower_probe (struct usb_inter
 	if (retval) {
 		/* something prevented us from registering this driver */
 		dev_err(idev, "Not able to get a minor for this device.\n");
-		usb_set_intfdata (interface, NULL);
 		goto error;
 	}
 	dev->minor = interface->minor;
@@ -944,16 +932,13 @@ static void tower_disconnect (struct usb
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


