Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65016B7522
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 10:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388317AbfISIaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 04:30:55 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42193 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730637AbfISIay (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 04:30:54 -0400
Received: by mail-lf1-f66.google.com with SMTP id c195so1683048lfg.9;
        Thu, 19 Sep 2019 01:30:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=41PvRhGRLq0dlBM5WD0KyQTd8CspilI9BYvqI9ESeqY=;
        b=EV/XWoPNnBFyZF+CLg92YWPHQCjqVBO3juEmR1GMIQsGnnXAuySRWYf1yh1Es1oIdA
         6x5N4gu1/CkMIk1kcPhwpD05/ZJrYr8/GrXRMw7T90U//w2FpPucsmE5EsEoJZSSMpx7
         Z8Jh0ShB9vQ3N/Tvvu6bjE8QRfJRnQYbJuWaulMuS7aQ2TNlO/u5nit/g7/COJUHeTpv
         v+aiMabGzi6nmGPRoKOXfBBgMbf30d9eW7G9cB5USWCPfKudAlJVHMetBQt7+pLLTf6a
         vQQ3iB43W28yKJWN5Ocnr2yXjb2IbRbPCGTdAgkqgJifNG974+Uh+Ep9xmC5xth+eDMr
         ejsA==
X-Gm-Message-State: APjAAAWRi/a2OKOzhTpTPe4U9C0SsoeWd4rAbkUprccMVFKWi5r3go4a
        8JPRJw2N3BkgwdCRBCe1+7lyhq/O
X-Google-Smtp-Source: APXvYqxV9rylGTlck9D/jjAV7I+lDZZq96WtiWxXB1wgGQPeJoPo9UofKLtGw/geHrBVFjklLRESYg==
X-Received: by 2002:a19:5515:: with SMTP id n21mr4596570lfe.131.1568881851161;
        Thu, 19 Sep 2019 01:30:51 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id a23sm1430920lfl.66.2019.09.19.01.30.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 01:30:49 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iArpx-00083I-Od; Thu, 19 Sep 2019 10:30:49 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>,
        Juergen Stuber <starblue@users.sourceforge.net>,
        legousb-devel@lists.sourceforge.net,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+f9549f5ee8a5416f0b95@syzkaller.appspotmail.com
Subject: [PATCH RESEND 2/4] USB: legousbtower: fix deadlock on disconnect
Date:   Thu, 19 Sep 2019 10:30:37 +0200
Message-Id: <20190919083039.30898-3-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919083039.30898-1-johan@kernel.org>
References: <20190919083039.30898-1-johan@kernel.org>
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

