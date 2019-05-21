Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C3F249E6
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 10:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfEUILh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727415AbfEUILh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 04:11:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F802173E;
        Tue, 21 May 2019 08:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558426296;
        bh=dtt2u4FDF6jUWZmJipRbr/D1GFouLtIte/exQcM5oec=;
        h=Subject:To:From:Date:From;
        b=DOhDYobkc6QVZbO/xcfCG1KS4T73Bh031EwckIoBKd9gmzIntUoTYvdmt6eJPujjN
         qrLRtjj9piVp1V1eqQnVVqprc6mckvikZUrlCx11PGkB3iJGnZ8kvAHUOrQuqrfrpg
         pZBdXcchBBY5WLWWjwOiTN2f5MLmB6/HAqrlOwAg=
Subject: patch "USB: rio500: refuse more than one device at a time" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 May 2019 10:11:34 +0200
Message-ID: <155842629417035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: rio500: refuse more than one device at a time

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3864d33943b4a76c6e64616280e98d2410b1190f Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 9 May 2019 11:30:58 +0200
Subject: USB: rio500: refuse more than one device at a time

This driver is using a global variable. It cannot handle more than
one device at a time. The issue has been existing since the dawn
of the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+35f04d136fc975a70da4@syzkaller.appspotmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/rio500.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index 7b9adeb3e7aa..1d397d93d127 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -447,15 +447,23 @@ static int probe_rio(struct usb_interface *intf,
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
 	struct rio_usb_data *rio = &rio_instance;
-	int retval;
+	int retval = 0;
 
-	dev_info(&intf->dev, "USB Rio found at address %d\n", dev->devnum);
+	mutex_lock(&rio500_mutex);
+	if (rio->present) {
+		dev_info(&intf->dev, "Second USB Rio at address %d refused\n", dev->devnum);
+		retval = -EBUSY;
+		goto bail_out;
+	} else {
+		dev_info(&intf->dev, "USB Rio found at address %d\n", dev->devnum);
+	}
 
 	retval = usb_register_dev(intf, &usb_rio_class);
 	if (retval) {
 		dev_err(&dev->dev,
 			"Not able to get a minor for this device.\n");
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto bail_out;
 	}
 
 	rio->rio_dev = dev;
@@ -464,7 +472,8 @@ static int probe_rio(struct usb_interface *intf,
 		dev_err(&dev->dev,
 			"probe_rio: Not enough memory for the output buffer\n");
 		usb_deregister_dev(intf, &usb_rio_class);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto bail_out;
 	}
 	dev_dbg(&intf->dev, "obuf address:%p\n", rio->obuf);
 
@@ -473,7 +482,8 @@ static int probe_rio(struct usb_interface *intf,
 			"probe_rio: Not enough memory for the input buffer\n");
 		usb_deregister_dev(intf, &usb_rio_class);
 		kfree(rio->obuf);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto bail_out;
 	}
 	dev_dbg(&intf->dev, "ibuf address:%p\n", rio->ibuf);
 
@@ -481,8 +491,10 @@ static int probe_rio(struct usb_interface *intf,
 
 	usb_set_intfdata (intf, rio);
 	rio->present = 1;
+bail_out:
+	mutex_unlock(&rio500_mutex);
 
-	return 0;
+	return retval;
 }
 
 static void disconnect_rio(struct usb_interface *intf)
-- 
2.21.0


