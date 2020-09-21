Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9914272FD4
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgIUQka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbgIUQkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:40:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65777238E6;
        Mon, 21 Sep 2020 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706410;
        bh=ml9WTvepXB3089hPPOmk+nzTVHg1VLLptGKTt6FkVpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLMSBBcMyJbKRBL7mMU2J7MC993sj3aJBPzDFdRb6XBlhUGpLGrSc28GXvWEHDyq+
         MLDDigleOG6iNzPMc5lpyDLindolUsdjiwguVm/WuQPv/thTiDFVpa6Fr8Qi3ArVc7
         jjxR6w5FueC5Scnhz/yIt0Csx3/J3xDGw4i/K7Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Thierer <mthierer@gmail.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.14 58/94] usb: Fix out of sync data toggle if a configured device is reconfigured
Date:   Mon, 21 Sep 2020 18:27:45 +0200
Message-Id: <20200921162038.210221956@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit cfd54fa83a5068b61b7eb28d3c117d8354c74c7a upstream.

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
 drivers/usb/core/message.c |   93 ++++++++++++++++++++-------------------------
 1 file changed, 43 insertions(+), 50 deletions(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1143,6 +1143,34 @@ void usb_disable_interface(struct usb_de
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
@@ -1156,7 +1184,6 @@ void usb_disable_interface(struct usb_de
 void usb_disable_device(struct usb_device *dev, int skip_ep0)
 {
 	int i;
-	struct usb_hcd *hcd = bus_to_hcd(dev->bus);
 
 	/* getting rid of interfaces will disconnect
 	 * any drivers bound to them (a key side effect)
@@ -1202,22 +1229,8 @@ void usb_disable_device(struct usb_devic
 
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
@@ -1460,6 +1473,9 @@ EXPORT_SYMBOL_GPL(usb_set_interface);
  * The caller must own the device lock.
  *
  * Return: Zero on success, else a negative error code.
+ *
+ * If this routine fails the device will probably be in an unusable state
+ * with endpoints disabled, and interfaces only partially enabled.
  */
 int usb_reset_configuration(struct usb_device *dev)
 {
@@ -1475,10 +1491,7 @@ int usb_reset_configuration(struct usb_d
 	 * calls during probe() are fine
 	 */
 
-	for (i = 1; i < 16; ++i) {
-		usb_disable_endpoint(dev, i, true);
-		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
-	}
+	usb_disable_device_endpoints(dev, 1); /* skip ep0*/
 
 	config = dev->actconfig;
 	retval = 0;
@@ -1491,34 +1504,10 @@ int usb_reset_configuration(struct usb_d
 		mutex_unlock(hcd->bandwidth_mutex);
 		return -ENOMEM;
 	}
-	/* Make sure we have enough bandwidth for each alternate setting 0 */
-	for (i = 0; i < config->desc.bNumInterfaces; i++) {
-		struct usb_interface *intf = config->interface[i];
-		struct usb_host_interface *alt;
-
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
+
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
@@ -1527,8 +1516,12 @@ reset_old_alts:
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


