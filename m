Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7433AA1E
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732120AbfFIQyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732529AbfFIQyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:54:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 004CD205ED;
        Sun,  9 Jun 2019 16:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099250;
        bh=wM8+B39AJFJBYFNNMwIZM79LNZKa3Xj6rCHc923s3GE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUUTt4GD5Vn8LGdsFl06GQgZUHqNajPoC6lh3PexGGFK6IvjUwfwwRdCs8bIkzkW3
         KfPx4oKaMBh4DvIWUZgjc8kkt1zRTF/tK4LbNnCn+1IK+4TVx7/upKlI5Z1CVI13CT
         5bbyGxfHDomCdjwk418e9+yU3d9mp72FntmZoXDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+35f04d136fc975a70da4@syzkaller.appspotmail.com
Subject: [PATCH 4.9 29/83] USB: rio500: refuse more than one device at a time
Date:   Sun,  9 Jun 2019 18:41:59 +0200
Message-Id: <20190609164130.117291274@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 3864d33943b4a76c6e64616280e98d2410b1190f upstream.

This driver is using a global variable. It cannot handle more than
one device at a time. The issue has been existing since the dawn
of the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+35f04d136fc975a70da4@syzkaller.appspotmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/rio500.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -464,15 +464,23 @@ static int probe_rio(struct usb_interfac
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
@@ -481,7 +489,8 @@ static int probe_rio(struct usb_interfac
 		dev_err(&dev->dev,
 			"probe_rio: Not enough memory for the output buffer\n");
 		usb_deregister_dev(intf, &usb_rio_class);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto bail_out;
 	}
 	dev_dbg(&intf->dev, "obuf address:%p\n", rio->obuf);
 
@@ -490,7 +499,8 @@ static int probe_rio(struct usb_interfac
 			"probe_rio: Not enough memory for the input buffer\n");
 		usb_deregister_dev(intf, &usb_rio_class);
 		kfree(rio->obuf);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto bail_out;
 	}
 	dev_dbg(&intf->dev, "ibuf address:%p\n", rio->ibuf);
 
@@ -498,8 +508,10 @@ static int probe_rio(struct usb_interfac
 
 	usb_set_intfdata (intf, rio);
 	rio->present = 1;
+bail_out:
+	mutex_unlock(&rio500_mutex);
 
-	return 0;
+	return retval;
 }
 
 static void disconnect_rio(struct usb_interface *intf)


