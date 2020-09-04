Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FB525DC2B
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbgIDOpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 10:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730021AbgIDOp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 10:45:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00C29206F2;
        Fri,  4 Sep 2020 14:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599230725;
        bh=De1cSFqTU9381mt9juSprNf1Bz0q0/fhF/QWwfNTYYA=;
        h=Subject:To:From:Date:From;
        b=U7a8iAudiO7fLM74S65C3gQ/zqvWxcdq5pS0rN5DtY2F8GGJFIt0NcFlYe13eQKM2
         3KAptKOoZxTpRrtGtsdXvk6Ki7XnoZzmgE4QfD7gKLXcZNyu7/md3RjDpZ8s2a0xf5
         WqIxylXRAXkXV+LrjbW8AbVgUdZNH7/bRBOQPqcE=
Subject: patch "usb: Fix out of sync data toggle if a configured device is" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        mthierer@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Sep 2020 16:45:46 +0200
Message-ID: <1599230746104211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: Fix out of sync data toggle if a configured device is

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cfd54fa83a5068b61b7eb28d3c117d8354c74c7a Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Tue, 1 Sep 2020 11:25:28 +0300
Subject: usb: Fix out of sync data toggle if a configured device is
 reconfigured

Userspace drivers that use a SetConfiguration() request to "lightweight"
reset an already configured usb device might cause data toggles to get out
of sync between the device and host, and the device becomes unusable.

The xHCI host requires endpoints to be dropped and added back to reset the
toggle. If USB core notices the new configuration is the same as the
current active configuration it will avoid these extra steps by calling
usb_reset_configuration() instead of usb_set_configuration().

A SetConfiguration() request will reset the device side data toggles.
Make sure usb_reset_configuration() function also drops and adds back the
endpoints to ensure data toggles are in sync.

To avoid code duplication split the current usb_disable_device() function
and reuse the endpoint specific part.

Cc: stable <stable@vger.kernel.org>
Tested-by: Martin Thierer <mthierer@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200901082528.12557-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/message.c | 91 ++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 49 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 6197938dcc2d..ae1de9cc4b09 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1205,6 +1205,34 @@ void usb_disable_interface(struct usb_device *dev, struct usb_interface *intf,
 	}
 }
 
+/*
+ * usb_disable_device_endpoints -- Disable all endpoints for a device
+ * @dev: the device whose endpoints are being disabled
+ * @skip_ep0: 0 to disable endpoint 0, 1 to skip it.
+ */
+static void usb_disable_device_endpoints(struct usb_device *dev, int skip_ep0)
+{
+	struct usb_hcd *hcd = bus_to_hcd(dev->bus);
+	int i;
+
+	if (hcd->driver->check_bandwidth) {
+		/* First pass: Cancel URBs, leave endpoint pointers intact. */
+		for (i = skip_ep0; i < 16; ++i) {
+			usb_disable_endpoint(dev, i, false);
+			usb_disable_endpoint(dev, i + USB_DIR_IN, false);
+		}
+		/* Remove endpoints from the host controller internal state */
+		mutex_lock(hcd->bandwidth_mutex);
+		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
+		mutex_unlock(hcd->bandwidth_mutex);
+	}
+	/* Second pass: remove endpoint pointers */
+	for (i = skip_ep0; i < 16; ++i) {
+		usb_disable_endpoint(dev, i, true);
+		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
+	}
+}
+
 /**
  * usb_disable_device - Disable all the endpoints for a USB device
  * @dev: the device whose endpoints are being disabled
@@ -1218,7 +1246,6 @@ void usb_disable_interface(struct usb_device *dev, struct usb_interface *intf,
 void usb_disable_device(struct usb_device *dev, int skip_ep0)
 {
 	int i;
-	struct usb_hcd *hcd = bus_to_hcd(dev->bus);
 
 	/* getting rid of interfaces will disconnect
 	 * any drivers bound to them (a key side effect)
@@ -1264,22 +1291,8 @@ void usb_disable_device(struct usb_device *dev, int skip_ep0)
 
 	dev_dbg(&dev->dev, "%s nuking %s URBs\n", __func__,
 		skip_ep0 ? "non-ep0" : "all");
-	if (hcd->driver->check_bandwidth) {
-		/* First pass: Cancel URBs, leave endpoint pointers intact. */
-		for (i = skip_ep0; i < 16; ++i) {
-			usb_disable_endpoint(dev, i, false);
-			usb_disable_endpoint(dev, i + USB_DIR_IN, false);
-		}
-		/* Remove endpoints from the host controller internal state */
-		mutex_lock(hcd->bandwidth_mutex);
-		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
-		mutex_unlock(hcd->bandwidth_mutex);
-		/* Second pass: remove endpoint pointers */
-	}
-	for (i = skip_ep0; i < 16; ++i) {
-		usb_disable_endpoint(dev, i, true);
-		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
-	}
+
+	usb_disable_device_endpoints(dev, skip_ep0);
 }
 
 /**
@@ -1522,6 +1535,9 @@ EXPORT_SYMBOL_GPL(usb_set_interface);
  * The caller must own the device lock.
  *
  * Return: Zero on success, else a negative error code.
+ *
+ * If this routine fails the device will probably be in an unusable state
+ * with endpoints disabled, and interfaces only partially enabled.
  */
 int usb_reset_configuration(struct usb_device *dev)
 {
@@ -1537,10 +1553,7 @@ int usb_reset_configuration(struct usb_device *dev)
 	 * calls during probe() are fine
 	 */
 
-	for (i = 1; i < 16; ++i) {
-		usb_disable_endpoint(dev, i, true);
-		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
-	}
+	usb_disable_device_endpoints(dev, 1); /* skip ep0*/
 
 	config = dev->actconfig;
 	retval = 0;
@@ -1553,34 +1566,10 @@ int usb_reset_configuration(struct usb_device *dev)
 		mutex_unlock(hcd->bandwidth_mutex);
 		return -ENOMEM;
 	}
-	/* Make sure we have enough bandwidth for each alternate setting 0 */
-	for (i = 0; i < config->desc.bNumInterfaces; i++) {
-		struct usb_interface *intf = config->interface[i];
-		struct usb_host_interface *alt;
 
-		alt = usb_altnum_to_altsetting(intf, 0);
-		if (!alt)
-			alt = &intf->altsetting[0];
-		if (alt != intf->cur_altsetting)
-			retval = usb_hcd_alloc_bandwidth(dev, NULL,
-					intf->cur_altsetting, alt);
-		if (retval < 0)
-			break;
-	}
-	/* If not, reinstate the old alternate settings */
+	/* xHCI adds all endpoints in usb_hcd_alloc_bandwidth */
+	retval = usb_hcd_alloc_bandwidth(dev, config, NULL, NULL);
 	if (retval < 0) {
-reset_old_alts:
-		for (i--; i >= 0; i--) {
-			struct usb_interface *intf = config->interface[i];
-			struct usb_host_interface *alt;
-
-			alt = usb_altnum_to_altsetting(intf, 0);
-			if (!alt)
-				alt = &intf->altsetting[0];
-			if (alt != intf->cur_altsetting)
-				usb_hcd_alloc_bandwidth(dev, NULL,
-						alt, intf->cur_altsetting);
-		}
 		usb_enable_lpm(dev);
 		mutex_unlock(hcd->bandwidth_mutex);
 		return retval;
@@ -1589,8 +1578,12 @@ int usb_reset_configuration(struct usb_device *dev)
 			USB_REQ_SET_CONFIGURATION, 0,
 			config->desc.bConfigurationValue, 0,
 			NULL, 0, USB_CTRL_SET_TIMEOUT);
-	if (retval < 0)
-		goto reset_old_alts;
+	if (retval < 0) {
+		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
+		usb_enable_lpm(dev);
+		mutex_unlock(hcd->bandwidth_mutex);
+		return retval;
+	}
 	mutex_unlock(hcd->bandwidth_mutex);
 
 	/* re-init hc/hcd interface/endpoint state */
-- 
2.28.0


