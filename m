Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C97691220F9
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfLQA7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:59:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34706 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbfLQAvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:35 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0003KD-Pm; Tue, 17 Dec 2019 00:51:30 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0005TH-2G; Tue, 17 Dec 2019 00:51:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+f9549f5ee8a5416f0b95@syzkaller.appspotmail.com,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 00:45:59 +0000
Message-ID: <lsq.1576543535.698689005@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 025/136] USB: legousbtower: fix deadlock on disconnect
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Reported-by: syzbot+f9549f5ee8a5416f0b95@syzkaller.appspotmail.com
Tested-by: syzbot+f9549f5ee8a5416f0b95@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190919083039.30898-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/legousbtower.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -185,7 +185,6 @@ static const struct usb_device_id tower_
 };
 
 MODULE_DEVICE_TABLE (usb, tower_table);
-static DEFINE_MUTEX(open_disc_mutex);
 
 #define LEGO_USB_TOWER_MINOR_BASE	160
 
@@ -338,18 +337,14 @@ static int tower_open (struct inode *ino
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
@@ -357,12 +352,10 @@ static int tower_open (struct inode *ino
 
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
@@ -429,10 +422,9 @@ static int tower_release (struct inode *
 
 	if (dev == NULL) {
 		retval = -ENODEV;
-		goto exit_nolock;
+		goto exit;
 	}
 
-	mutex_lock(&open_disc_mutex);
 	if (mutex_lock_interruptible(&dev->lock)) {
 	        retval = -ERESTARTSYS;
 		goto exit;
@@ -462,10 +454,7 @@ static int tower_release (struct inode *
 
 unlock_exit:
 	mutex_unlock(&dev->lock);
-
 exit:
-	mutex_unlock(&open_disc_mutex);
-exit_nolock:
 	return retval;
 }
 
@@ -944,7 +933,6 @@ static int tower_probe (struct usb_inter
 	if (retval) {
 		/* something prevented us from registering this driver */
 		dev_err(idev, "Not able to get a minor for this device.\n");
-		usb_set_intfdata (interface, NULL);
 		goto error;
 	}
 	dev->minor = interface->minor;
@@ -976,16 +964,13 @@ static void tower_disconnect (struct usb
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

