Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A2BD2776
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 12:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfJJKqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 06:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfJJKqO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 06:46:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3532A20650;
        Thu, 10 Oct 2019 10:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570704373;
        bh=6xhPAZxdUofmKVZBjS2RWB9RbqBGEGikgKQVJPpxckk=;
        h=Subject:To:From:Date:From;
        b=nT6qOoau8HMPofyX6tdk8vL42OjyFEzOn1ufUUs+HjfWXtpEwbJ47R++GzKazgQLs
         kkjhwNewlfT0twu25kWvXwJkShBJ8DRt33I5NjMokHTq2iDGj8gNB8mE+URTD89xLU
         JsX/FQ6q0mZfd5vAmo5ykxPnQjDkFn4uo3LhXgTg=
Subject: patch "USB: iowarrior: fix use-after-free after driver unbind" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 12:45:55 +0200
Message-ID: <1570704355130249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: iowarrior: fix use-after-free after driver unbind

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b5f8d46867ca233d773408ffbe691a8062ed718f Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 9 Oct 2019 12:48:43 +0200
Subject: USB: iowarrior: fix use-after-free after driver unbind

Make sure to stop also the asynchronous write URBs on disconnect() to
avoid use-after-free in the completion handler after driver unbind.

Fixes: 946b960d13c1 ("USB: add driver for iowarrior devices.")
Cc: stable <stable@vger.kernel.org>	# 2.6.21: 51a2f077c44e ("USB: introduce usb_anchor")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009104846.5925-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 6841267820c6..f405fa734bcc 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -87,6 +87,7 @@ struct iowarrior {
 	char chip_serial[9];		/* the serial number string of the chip connected */
 	int report_size;		/* number of bytes in a report */
 	u16 product_id;
+	struct usb_anchor submitted;
 };
 
 /*--------------*/
@@ -425,11 +426,13 @@ static ssize_t iowarrior_write(struct file *file,
 			retval = -EFAULT;
 			goto error;
 		}
+		usb_anchor_urb(int_out_urb, &dev->submitted);
 		retval = usb_submit_urb(int_out_urb, GFP_KERNEL);
 		if (retval) {
 			dev_dbg(&dev->interface->dev,
 				"submit error %d for urb nr.%d\n",
 				retval, atomic_read(&dev->write_busy));
+			usb_unanchor_urb(int_out_urb);
 			goto error;
 		}
 		/* submit was ok */
@@ -770,6 +773,8 @@ static int iowarrior_probe(struct usb_interface *interface,
 	iface_desc = interface->cur_altsetting;
 	dev->product_id = le16_to_cpu(udev->descriptor.idProduct);
 
+	init_usb_anchor(&dev->submitted);
+
 	res = usb_find_last_int_in_endpoint(iface_desc, &dev->int_in_endpoint);
 	if (res) {
 		dev_err(&interface->dev, "no interrupt-in endpoint found\n");
@@ -885,6 +890,7 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 		   Deleting the device is postponed until close() was called.
 		 */
 		usb_kill_urb(dev->int_in_urb);
+		usb_kill_anchored_urbs(&dev->submitted);
 		wake_up_interruptible(&dev->read_wait);
 		wake_up_interruptible(&dev->write_wait);
 		mutex_unlock(&dev->mutex);
-- 
2.23.0


