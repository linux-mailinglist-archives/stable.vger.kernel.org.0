Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13C4249CF
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 10:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfEUIJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbfEUIJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 04:09:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE68221773;
        Tue, 21 May 2019 08:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558426166;
        bh=45FS1FftW+YoB+ZZ/7DRsxjR+On/CpAuKn+NonYX7dI=;
        h=Subject:To:From:Date:From;
        b=l0MadjgXIm3b2+fTUzFO9AdD5TWyf9IiAMXq/J0xriluXjZ8l/QHKSKwgNt00AQxQ
         yHux9l1ycIEr50DjW1brwn0sEZQ02252gLuw/3iuggR7gn+3Xc4bLTZkzcjUnDBzXI
         E9zXkwThtYv2rS69C5drkU1FuCfaQ1hpDIm6vXzg=
Subject: patch "media: usb: siano: Fix general protection fault in smsusb" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 May 2019 10:09:13 +0200
Message-ID: <1558426153245181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    media: usb: siano: Fix general protection fault in smsusb

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 31e0456de5be379b10fea0fa94a681057114a96e Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 7 May 2019 12:39:47 -0400
Subject: media: usb: siano: Fix general protection fault in smsusb

The syzkaller USB fuzzer found a general-protection-fault bug in the
smsusb part of the Siano DVB driver.  The fault occurs during probe
because the driver assumes without checking that the device has both
IN and OUT endpoints and the IN endpoint is ep1.

By slightly rearranging the driver's initialization code, we can make
the appropriate checks early on and thus avoid the problem.  If the
expected endpoints aren't present, the new code safely returns -ENODEV
from the probe routine.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+53f029db71c19a47325a@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/siano/smsusb.c | 33 +++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 4fc03ec8a4f1..27ad14a3f831 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -400,6 +400,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	struct smsusb_device_t *dev;
 	void *mdev;
 	int i, rc;
+	int in_maxp;
 
 	/* create device object */
 	dev = kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);
@@ -411,6 +412,24 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	dev->udev = interface_to_usbdev(intf);
 	dev->state = SMSUSB_DISCONNECTED;
 
+	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
+		struct usb_endpoint_descriptor *desc =
+				&intf->cur_altsetting->endpoint[i].desc;
+
+		if (desc->bEndpointAddress & USB_DIR_IN) {
+			dev->in_ep = desc->bEndpointAddress;
+			in_maxp = usb_endpoint_maxp(desc);
+		} else {
+			dev->out_ep = desc->bEndpointAddress;
+		}
+	}
+
+	pr_debug("in_ep = %02x, out_ep = %02x\n", dev->in_ep, dev->out_ep);
+	if (!dev->in_ep || !dev->out_ep) {	/* Missing endpoints? */
+		smsusb_term_device(intf);
+		return -ENODEV;
+	}
+
 	params.device_type = sms_get_board(board_id)->type;
 
 	switch (params.device_type) {
@@ -425,24 +444,12 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		/* fall-thru */
 	default:
 		dev->buffer_size = USB2_BUFFER_SIZE;
-		dev->response_alignment =
-		    le16_to_cpu(dev->udev->ep_in[1]->desc.wMaxPacketSize) -
-		    sizeof(struct sms_msg_hdr);
+		dev->response_alignment = in_maxp - sizeof(struct sms_msg_hdr);
 
 		params.flags |= SMS_DEVICE_FAMILY2;
 		break;
 	}
 
-	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
-		if (intf->cur_altsetting->endpoint[i].desc. bEndpointAddress & USB_DIR_IN)
-			dev->in_ep = intf->cur_altsetting->endpoint[i].desc.bEndpointAddress;
-		else
-			dev->out_ep = intf->cur_altsetting->endpoint[i].desc.bEndpointAddress;
-	}
-
-	pr_debug("in_ep = %02x, out_ep = %02x\n",
-		dev->in_ep, dev->out_ep);
-
 	params.device = &dev->udev->dev;
 	params.usb_device = dev->udev;
 	params.buffer_size = dev->buffer_size;
-- 
2.21.0


