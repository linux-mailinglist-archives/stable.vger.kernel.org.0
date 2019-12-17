Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 793A11220DF
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLQA6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:58:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34796 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726743AbfLQAvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:37 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0003Ky-Pc; Tue, 17 Dec 2019 00:51:31 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005Vv-Ff; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 00:46:31 +0000
Message-ID: <lsq.1576543535.632412410@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 057/136] USB: iowarrior: fix use-after-free after
 driver unbind
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

commit b5f8d46867ca233d773408ffbe691a8062ed718f upstream.

Make sure to stop also the asynchronous write URBs on disconnect() to
avoid use-after-free in the completion handler after driver unbind.

Fixes: 946b960d13c1 ("USB: add driver for iowarrior devices.")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009104846.5925-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/iowarrior.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -89,6 +89,7 @@ struct iowarrior {
 	char chip_serial[9];		/* the serial number string of the chip connected */
 	int report_size;		/* number of bytes in a report */
 	u16 product_id;
+	struct usb_anchor submitted;
 };
 
 /*--------------*/
@@ -437,11 +438,13 @@ static ssize_t iowarrior_write(struct fi
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
@@ -788,6 +791,8 @@ static int iowarrior_probe(struct usb_in
 	iface_desc = interface->cur_altsetting;
 	dev->product_id = le16_to_cpu(udev->descriptor.idProduct);
 
+	init_usb_anchor(&dev->submitted);
+
 	/* set up the endpoint information */
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
@@ -917,6 +922,7 @@ static void iowarrior_disconnect(struct
 		   Deleting the device is postponed until close() was called.
 		 */
 		usb_kill_urb(dev->int_in_urb);
+		usb_kill_anchored_urbs(&dev->submitted);
 		wake_up_interruptible(&dev->read_wait);
 		wake_up_interruptible(&dev->write_wait);
 		mutex_unlock(&dev->mutex);

