Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0406DB9285
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391329AbfITOd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:33:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36374 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388249AbfITOZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:08 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqM-0004xe-Ed; Fri, 20 Sep 2019 15:25:06 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007yg-Bc; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.539744470@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 118/132] media: usb: siano: Fix general protection
 fault in smsusb
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 31e0456de5be379b10fea0fa94a681057114a96e upstream.

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
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/siano/smsusb.c | 33 +++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -359,6 +359,7 @@ static int smsusb_init_device(struct usb
 	struct smsdevice_params_t params;
 	struct smsusb_device_t *dev;
 	int i, rc;
+	int in_maxp;
 
 	/* create device object */
 	dev = kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);
@@ -372,6 +373,24 @@ static int smsusb_init_device(struct usb
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
@@ -386,24 +405,12 @@ static int smsusb_init_device(struct usb
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
-	sms_info("in_ep = %02x, out_ep = %02x",
-		dev->in_ep, dev->out_ep);
-
 	params.device = &dev->udev->dev;
 	params.buffer_size = dev->buffer_size;
 	params.num_buffers = MAX_BUFFERS;

