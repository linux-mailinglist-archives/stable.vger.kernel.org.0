Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C360EDA143
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407559AbfJPWVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437544AbfJPVxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:35 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47BF2218DE;
        Wed, 16 Oct 2019 21:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262815;
        bh=gSHT5nwhuBITXuAxDeFbYLByEHnhOE5H5fgoKH0A+fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGNS2i8Xs4lYPRx3atMw0XWIHHpX/VLk1l0QsHfLh/ChdbIwWaXhMZpum5LPQGr0s
         NYMBxD4Ya1pgkWzL7jTqS3fuvuuXOsHukBGX7Fw007TXkcKcxTke0As/LrMHSYNeYi
         9LU8BPfFWW+Ebuop7TzXs77c/LHxm0dp+WZPDzM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 40/79] USB: adutux: fix NULL-derefs on disconnect
Date:   Wed, 16 Oct 2019 14:50:15 -0700
Message-Id: <20191016214802.465136845@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b2fa7baee744fde746c17bc1860b9c6f5c2eebb7 upstream.

The driver was using its struct usb_device pointer as an inverted
disconnected flag, but was setting it to NULL before making sure all
completion handlers had run. This could lead to a NULL-pointer
dereference in a number of dev_dbg statements in the completion handlers
which relies on said pointer.

The pointer was also dereferenced unconditionally in a dev_dbg statement
release() something which would lead to a NULL-deref whenever a device
was disconnected before the final character-device close if debugging
was enabled.

Fix this by unconditionally stopping all I/O and preventing
resubmissions by poisoning the interrupt URBs at disconnect and using a
dedicated disconnected flag.

This also makes sure that all I/O has completed by the time the
disconnect callback returns.

Fixes: 1ef37c6047fe ("USB: adutux: remove custom debug macro and module parameter")
Fixes: 66d4bc30d128 ("USB: adutux: remove custom debug macro")
Cc: stable <stable@vger.kernel.org>     # 3.12
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190925092913.8608-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/adutux.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -80,6 +80,7 @@ struct adu_device {
 	char			serial_number[8];
 
 	int			open_count; /* number of times this port has been opened */
+	unsigned long		disconnected:1;
 
 	char		*read_buffer_primary;
 	int			read_buffer_length;
@@ -121,7 +122,7 @@ static void adu_abort_transfers(struct a
 {
 	unsigned long flags;
 
-	if (dev->udev == NULL)
+	if (dev->disconnected)
 		return;
 
 	/* shutdown transfer */
@@ -244,7 +245,7 @@ static int adu_open(struct inode *inode,
 	}
 
 	dev = usb_get_intfdata(interface);
-	if (!dev || !dev->udev) {
+	if (!dev) {
 		retval = -ENODEV;
 		goto exit_no_device;
 	}
@@ -327,7 +328,7 @@ static int adu_release(struct inode *ino
 	}
 
 	adu_release_internal(dev);
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		/* the device was unplugged before the file was released */
 		if (!dev->open_count)	/* ... and we're the last user */
 			adu_delete(dev);
@@ -356,7 +357,7 @@ static ssize_t adu_read(struct file *fil
 		return -ERESTARTSYS;
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto exit;
@@ -525,7 +526,7 @@ static ssize_t adu_write(struct file *fi
 		goto exit_nolock;
 
 	/* verify that the device wasn't unplugged */
-	if (dev->udev == NULL) {
+	if (dev->disconnected) {
 		retval = -ENODEV;
 		pr_err("No device or device unplugged %d\n", retval);
 		goto exit;
@@ -805,11 +806,14 @@ static void adu_disconnect(struct usb_in
 
 	usb_deregister_dev(interface, &adu_class);
 
+	usb_poison_urb(dev->interrupt_in_urb);
+	usb_poison_urb(dev->interrupt_out_urb);
+
 	mutex_lock(&adutux_mutex);
 	usb_set_intfdata(interface, NULL);
 
 	mutex_lock(&dev->mtx);	/* not interruptible */
-	dev->udev = NULL;	/* poison */
+	dev->disconnected = 1;
 	mutex_unlock(&dev->mtx);
 
 	/* if the device is not opened, then we clean up right now */


