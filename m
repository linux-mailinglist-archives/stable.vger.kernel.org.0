Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA59345177D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 23:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346496AbhKOW3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 17:29:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:18278 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348206AbhKOWSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 17:18:16 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="231002595"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="231002595"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 14:15:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="645040431"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by fmsmga001.fm.intel.com with ESMTP; 15 Nov 2021 14:15:18 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        kishon@ti.com
Cc:     hdegoede@redhat.com, chris.chiu@canonical.com,
        linux-usb@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] usb: hub: Fix usb enumeration issue due to address0 race
Date:   Tue, 16 Nov 2021 00:16:30 +0200
Message-Id: <20211115221630.871204-1-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xHC hardware can only have one slot in default state with address 0
waiting for a unique address at a time, otherwise "undefined behavior
may occur" according to xhci spec 5.4.3.4

The address0_mutex exists to prevent this across both xhci roothubs.

If hub_port_init() fails, it may unlock the mutex and exit with a xhci
slot in default state. If the other xhci roothub calls hub_port_init()
at this point we end up with two slots in default state.

Make sure the address0_mutex protects the slot default state across
hub_port_init() retries, until slot is addressed or disabled.

Note, one known minor case is not fixed by this patch.
If device needs to be reset during resume, but fails all hub_port_init()
retries in usb_reset_and_verify_device(), then it's possible the slot is
still left in default state when address0_mutex is unlocked.

Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/core/hub.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 86658a81d284..00c3506324e4 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4700,8 +4700,6 @@ hub_port_init(struct usb_hub *hub, struct usb_device *udev, int port1,
 	if (oldspeed == USB_SPEED_LOW)
 		delay = HUB_LONG_RESET_TIME;
 
-	mutex_lock(hcd->address0_mutex);
-
 	/* Reset the device; full speed may morph to high speed */
 	/* FIXME a USB 2.0 device may morph into SuperSpeed on reset. */
 	retval = hub_port_reset(hub, port1, udev, delay, false);
@@ -5016,7 +5014,6 @@ hub_port_init(struct usb_hub *hub, struct usb_device *udev, int port1,
 		hub_port_disable(hub, port1, 0);
 		update_devnum(udev, devnum);	/* for disconnect processing */
 	}
-	mutex_unlock(hcd->address0_mutex);
 	return retval;
 }
 
@@ -5246,6 +5243,9 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 		unit_load = 100;
 
 	status = 0;
+
+	mutex_lock(hcd->address0_mutex);
+
 	for (i = 0; i < PORT_INIT_TRIES; i++) {
 
 		/* reallocate for each attempt, since references
@@ -5282,6 +5282,8 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 		if (status < 0)
 			goto loop;
 
+		mutex_unlock(hcd->address0_mutex);
+
 		if (udev->quirks & USB_QUIRK_DELAY_INIT)
 			msleep(2000);
 
@@ -5370,6 +5372,7 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 
 loop_disable:
 		hub_port_disable(hub, port1, 1);
+		mutex_lock(hcd->address0_mutex);
 loop:
 		usb_ep0_reinit(udev);
 		release_devnum(udev);
@@ -5396,6 +5399,8 @@ static void hub_port_connect(struct usb_hub *hub, int port1, u16 portstatus,
 	}
 
 done:
+	mutex_unlock(hcd->address0_mutex);
+
 	hub_port_disable(hub, port1, 1);
 	if (hcd->driver->relinquish_port && !hub->hdev->parent) {
 		if (status != -ENOTCONN && status != -ENODEV)
@@ -5915,6 +5920,8 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
 	bos = udev->bos;
 	udev->bos = NULL;
 
+	mutex_lock(hcd->address0_mutex);
+
 	for (i = 0; i < PORT_INIT_TRIES; ++i) {
 
 		/* ep0 maxpacket size may change; let the HCD know about it.
@@ -5924,6 +5931,7 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
 		if (ret >= 0 || ret == -ENOTCONN || ret == -ENODEV)
 			break;
 	}
+	mutex_unlock(hcd->address0_mutex);
 
 	if (ret < 0)
 		goto re_enumerate;
-- 
2.25.1

