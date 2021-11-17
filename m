Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA4545481E
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbhKQOIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:08:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:60930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhKQOI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:08:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A6C619F6;
        Wed, 17 Nov 2021 14:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157930;
        bh=QVsZkmL/31EH0nF0aJziN9JFgD/4Bc+8F+KHmbkyiog=;
        h=Subject:To:From:Date:From;
        b=Mqa8N8VOsuLWAj6JUKDQVDz9M3h2ErpDPy322tdcco9e4ZfoBwi3eA3UHO4EfZT9x
         n7ppX5b7sd72OUhCXevpx8EnjjVbiORNPQ/cHEu+Ro5dUgYz7lw/cERY+dfvJ46aGb
         2+y4yQvDrd2UOLpbSWscCdrEKDIUVI5yepdymD6s=
Subject: patch "usb: hub: Fix usb enumeration issue due to address0 race" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:05:27 +0100
Message-ID: <163715792712640@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: hub: Fix usb enumeration issue due to address0 race

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6ae6dc22d2d1ce6aa77a6da8a761e61aca216f8b Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Tue, 16 Nov 2021 00:16:30 +0200
Subject: usb: hub: Fix usb enumeration issue due to address0 race

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
Fixes: 638139eb95d2 ("usb: hub: allow to process more usb hub events in parallel")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211115221630.871204-1-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.34.0


