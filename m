Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDDCDA095
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389853AbfJPWM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437916AbfJPV4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:09 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58B6F218DE;
        Wed, 16 Oct 2019 21:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262968;
        bh=APRF+9GQdbz/EjdVjICcn1/8on6f+zqsjqluURkzn7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9v1IlwvConN38KazqKzLBQDZRvsSTrjBS9cwpcaiYns1pl2/wj1u3PWcaHMbSznF
         1Z8Gm6Hbup1sg3QdfdL2qUHTy/k4T7XTNjc7zuxwJhPLObElbu9eR7mbJiTBOKRCfH
         b/KK9xQ7YnzVFXnxUwwHtfheZxxkjwRpLSXODpq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f9549f5ee8a5416f0b95@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 35/65] USB: legousbtower: fix deadlock on disconnect
Date:   Wed, 16 Oct 2019 14:50:49 -0700
Message-Id: <20191016214827.229297486@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
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
@@ -183,7 +183,6 @@ static const struct usb_device_id tower_
 };
 
 MODULE_DEVICE_TABLE (usb, tower_table);
-static DEFINE_MUTEX(open_disc_mutex);
 
 #define LEGO_USB_TOWER_MINOR_BASE	160
 
@@ -336,18 +335,14 @@ static int tower_open (struct inode *ino
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
@@ -355,12 +350,10 @@ static int tower_open (struct inode *ino
 
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
@@ -427,10 +420,9 @@ static int tower_release (struct inode *
 
 	if (dev == NULL) {
 		retval = -ENODEV;
-		goto exit_nolock;
+		goto exit;
 	}
 
-	mutex_lock(&open_disc_mutex);
 	if (mutex_lock_interruptible(&dev->lock)) {
 	        retval = -ERESTARTSYS;
 		goto exit;
@@ -460,10 +452,7 @@ static int tower_release (struct inode *
 
 unlock_exit:
 	mutex_unlock(&dev->lock);
-
 exit:
-	mutex_unlock(&open_disc_mutex);
-exit_nolock:
 	return retval;
 }
 
@@ -915,7 +904,6 @@ static int tower_probe (struct usb_inter
 	if (retval) {
 		/* something prevented us from registering this driver */
 		dev_err(idev, "Not able to get a minor for this device.\n");
-		usb_set_intfdata (interface, NULL);
 		goto error;
 	}
 	dev->minor = interface->minor;
@@ -947,16 +935,13 @@ static void tower_disconnect (struct usb
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


