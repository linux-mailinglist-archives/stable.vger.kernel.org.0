Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C2338F6A
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfFGPla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730317AbfFGPla (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:41:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E0C7212F5;
        Fri,  7 Jun 2019 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922089;
        bh=1JsI5gQ3IcheMaeIGHRetkAhp1pxnQk4mSBRrkEzFhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxrFS6HNKCfTfbLbvRdsPs2MuInwyxFmsZ0oSJPT9QF+x6Th43lLXao6Hfjrck/80
         0SFKIiyiktmGwNBW4VxXiLUnEiSG9a3kTpavvN2v6sicEVUjcDVlzTuZ9fhSq5Co8r
         FnyobQTxtL8SuBOeM4LSmNDxgddYGe9EVB+sr5tM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        syzbot+35f04d136fc975a70da4@syzkaller.appspotmail.com
Subject: [PATCH 4.14 32/69] USB: rio500: refuse more than one device at a time
Date:   Fri,  7 Jun 2019 17:39:13 +0200
Message-Id: <20190607153852.347815659@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.271562617@linuxfoundation.org>
References: <20190607153848.271562617@linuxfoundation.org>
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
@@ -460,15 +460,23 @@ static int probe_rio(struct usb_interfac
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
@@ -477,7 +485,8 @@ static int probe_rio(struct usb_interfac
 		dev_err(&dev->dev,
 			"probe_rio: Not enough memory for the output buffer\n");
 		usb_deregister_dev(intf, &usb_rio_class);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto bail_out;
 	}
 	dev_dbg(&intf->dev, "obuf address:%p\n", rio->obuf);
 
@@ -486,7 +495,8 @@ static int probe_rio(struct usb_interfac
 			"probe_rio: Not enough memory for the input buffer\n");
 		usb_deregister_dev(intf, &usb_rio_class);
 		kfree(rio->obuf);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto bail_out;
 	}
 	dev_dbg(&intf->dev, "ibuf address:%p\n", rio->ibuf);
 
@@ -494,8 +504,10 @@ static int probe_rio(struct usb_interfac
 
 	usb_set_intfdata (intf, rio);
 	rio->present = 1;
+bail_out:
+	mutex_unlock(&rio500_mutex);
 
-	return 0;
+	return retval;
 }
 
 static void disconnect_rio(struct usb_interface *intf)


