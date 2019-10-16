Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0001DA002
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407020AbfJPWG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438128AbfJPV6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:19 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E001D21928;
        Wed, 16 Oct 2019 21:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263099;
        bh=nDFW/KXTTRLxhK+S/6xxs6fJH57zdvFinbc4C0dY+u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kr5pdc+oBaa3sQ1dKjGZ4ecSYFkkF7GfQqZeeCLCHbrVbHDsoypj6MAXobJ+PZcH8
         1zF6okPkA/CJfIBWrr7tAoqFVGtQ/6KUHPK+Osal/YtN0Q1VF0kUlw1zkYByTDFva7
         n8PkD0LOq6FUhMIV0Gqm4l4HCePlfxEsegvPruMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 020/112] USB: iowarrior: fix use-after-free after driver unbind
Date:   Wed, 16 Oct 2019 14:50:12 -0700
Message-Id: <20191016214849.604722565@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b5f8d46867ca233d773408ffbe691a8062ed718f upstream.

Make sure to stop also the asynchronous write URBs on disconnect() to
avoid use-after-free in the completion handler after driver unbind.

Fixes: 946b960d13c1 ("USB: add driver for iowarrior devices.")
Cc: stable <stable@vger.kernel.org>	# 2.6.21: 51a2f077c44e ("USB: introduce usb_anchor")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009104846.5925-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/iowarrior.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -87,6 +87,7 @@ struct iowarrior {
 	char chip_serial[9];		/* the serial number string of the chip connected */
 	int report_size;		/* number of bytes in a report */
 	u16 product_id;
+	struct usb_anchor submitted;
 };
 
 /*--------------*/
@@ -425,11 +426,13 @@ static ssize_t iowarrior_write(struct fi
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
@@ -770,6 +773,8 @@ static int iowarrior_probe(struct usb_in
 	iface_desc = interface->cur_altsetting;
 	dev->product_id = le16_to_cpu(udev->descriptor.idProduct);
 
+	init_usb_anchor(&dev->submitted);
+
 	res = usb_find_last_int_in_endpoint(iface_desc, &dev->int_in_endpoint);
 	if (res) {
 		dev_err(&interface->dev, "no interrupt-in endpoint found\n");
@@ -885,6 +890,7 @@ static void iowarrior_disconnect(struct
 		   Deleting the device is postponed until close() was called.
 		 */
 		usb_kill_urb(dev->int_in_urb);
+		usb_kill_anchored_urbs(&dev->submitted);
 		wake_up_interruptible(&dev->read_wait);
 		wake_up_interruptible(&dev->write_wait);
 		mutex_unlock(&dev->mutex);


