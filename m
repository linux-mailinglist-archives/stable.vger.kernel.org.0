Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04CF83AA6A
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731442AbfFIQwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731420AbfFIQwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:52:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 081CD205ED;
        Sun,  9 Jun 2019 16:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099157;
        bh=9pQV96GQ5yaR3ppCHishu8Pql1cXDN8GY/jBzvaDq3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8UzKRs9BrZEvuTQ56O33WvpOAGDey2D1jSysYTxvCUUdvSGhLoduc96LUamGarMw
         Fpg62sEmH8Kj40yVej594YBuXS7XatlW6W8EJMPZ5ynlXt0xSXHnfqps7mNB5mjd0q
         rXMrdailXoXGe5RaF30r7O//dJ9jSGVIzBaHVZsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Johan Hovold <johan@kernel.org>,
        syzbot+53f029db71c19a47325a@syzkaller.appspotmail.com
Subject: [PATCH 4.9 31/83] media: usb: siano: Fix general protection fault in smsusb
Date:   Sun,  9 Jun 2019 18:42:01 +0200
Message-Id: <20190609164130.323240519@linuxfoundation.org>
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
CC: <stable@vger.kernel.org>
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/siano/smsusb.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -402,6 +402,7 @@ static int smsusb_init_device(struct usb
 	struct smsusb_device_t *dev;
 	void *mdev;
 	int i, rc;
+	int in_maxp;
 
 	/* create device object */
 	dev = kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);
@@ -413,6 +414,24 @@ static int smsusb_init_device(struct usb
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
@@ -427,24 +446,12 @@ static int smsusb_init_device(struct usb
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
 	params.buffer_size = dev->buffer_size;
 	params.num_buffers = MAX_BUFFERS;


