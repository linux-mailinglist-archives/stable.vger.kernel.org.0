Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF19A25789B
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 13:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHaLnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 07:43:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:61623 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgHaLnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 07:43:46 -0400
IronPort-SDR: 0T/xZVrd4A0dr/NYSHtbDNeFh8Lf1RneXHbqUTUw693S4PZcGb+0iF34jH2AiATIlmE2x04lfV
 JHZPAGBuBNiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9729"; a="137004565"
X-IronPort-AV: E=Sophos;i="5.76,375,1592895600"; 
   d="scan'208";a="137004565"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 04:43:45 -0700
IronPort-SDR: aTJNMC2+4y9eLEFcoMP1x3MH7AiE8BZ/JoE+p+6AyJMvmuZrCrVAiyTYTFliqSj+QScm8qUw4H
 kjP9hWUKKTvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,375,1592895600"; 
   d="scan'208";a="501303306"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by fmsmga006.fm.intel.com with ESMTP; 31 Aug 2020 04:43:43 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>, <stern@rowland.harvard.edu>,
        mthierer@gmail.com, Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] usb: Fix out of sync data toggle if a configured device is reconfigured
Date:   Mon, 31 Aug 2020 14:46:49 +0300
Message-Id: <20200831114649.24183-1-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Userspace drivers that use a SetConfiguration() request to "lightweight"
reset a already configured usb device might cause data toggles to get out
of sync between the device and host, and the device becomes unusable.

The xHCI host requires endpoints to be dropped and added back to reset the
toggle. USB core avoids these otherwise extra steps if the current active
configuration is the same as the new requested configuration.

A SetConfiguration() request will reset the device side data toggles.
Make sure usb core drops and adds back the endpoints in this case.

To avoid code duplication split the current usb_disable_device() function
and reuse the endpoint specific part.

Cc: stable <stable@vger.kernel.org>
Tested-by: Martin Thierer <mthierer@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/core/message.c | 92 ++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 49 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 6197938dcc2d..a1f67efc261f 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1205,6 +1205,35 @@ void usb_disable_interface(struct usb_device *dev, struct usb_interface *intf,
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
+
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
@@ -1218,7 +1247,6 @@ void usb_disable_interface(struct usb_device *dev, struct usb_interface *intf,
 void usb_disable_device(struct usb_device *dev, int skip_ep0)
 {
 	int i;
-	struct usb_hcd *hcd = bus_to_hcd(dev->bus);
 
 	/* getting rid of interfaces will disconnect
 	 * any drivers bound to them (a key side effect)
@@ -1264,22 +1292,8 @@ void usb_disable_device(struct usb_device *dev, int skip_ep0)
 
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
@@ -1522,6 +1536,9 @@ EXPORT_SYMBOL_GPL(usb_set_interface);
  * The caller must own the device lock.
  *
  * Return: Zero on success, else a negative error code.
+ *
+ * If this routine fails the device will probably be in an unusable state
+ * with endpoints disabled, and interfaces only partially enabled.
  */
 int usb_reset_configuration(struct usb_device *dev)
 {
@@ -1537,10 +1554,7 @@ int usb_reset_configuration(struct usb_device *dev)
 	 * calls during probe() are fine
 	 */
 
-	for (i = 1; i < 16; ++i) {
-		usb_disable_endpoint(dev, i, true);
-		usb_disable_endpoint(dev, i + USB_DIR_IN, true);
-	}
+	usb_disable_device_endpoints(dev, 1); /* skip ep0*/
 
 	config = dev->actconfig;
 	retval = 0;
@@ -1553,34 +1567,10 @@ int usb_reset_configuration(struct usb_device *dev)
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
@@ -1589,8 +1579,12 @@ int usb_reset_configuration(struct usb_device *dev)
 			USB_REQ_SET_CONFIGURATION, 0,
 			config->desc.bConfigurationValue, 0,
 			NULL, 0, USB_CTRL_SET_TIMEOUT);
-	if (retval < 0)
-		goto reset_old_alts;
+	if (retval < 0) {
+		retval = usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
+		usb_enable_lpm(dev);
+		mutex_unlock(hcd->bandwidth_mutex);
+		return retval;
+	}
 	mutex_unlock(hcd->bandwidth_mutex);
 
 	/* re-init hc/hcd interface/endpoint state */
-- 
2.17.1

