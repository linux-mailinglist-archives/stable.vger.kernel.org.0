Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880F5462441
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhK2WRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbhK2WQo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A0DC08ED9B;
        Mon, 29 Nov 2021 10:21:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93272CE13D5;
        Mon, 29 Nov 2021 18:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E74FC53FC7;
        Mon, 29 Nov 2021 18:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210081;
        bh=ffMOAoGGmO/I45Fixa7kk9JNj3cLIX06aCNInIs7IJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U+9M0CwHsFEHjZ7Aks/U/03Kz2cNoshyD+z9LQvEgGKbKArG5i81Tq0EjWH2mFwPS
         44qwZyMHX748qa4Ov77IoeejIVmLfd6qDh69e+rbo7mIO+q3UIT4kApntnd84U4vje
         +FlZcg2kgpbXBPyZ2bTz1lLdAwz6/+5agYtPNIkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 04/69] usb: hub: Fix usb enumeration issue due to address0 race
Date:   Mon, 29 Nov 2021 19:17:46 +0100
Message-Id: <20211129181703.808440882@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 6ae6dc22d2d1ce6aa77a6da8a761e61aca216f8b upstream.

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
 drivers/usb/core/hub.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4575,8 +4575,6 @@ hub_port_init(struct usb_hub *hub, struc
 	if (oldspeed == USB_SPEED_LOW)
 		delay = HUB_LONG_RESET_TIME;
 
-	mutex_lock(hcd->address0_mutex);
-
 	/* Reset the device; full speed may morph to high speed */
 	/* FIXME a USB 2.0 device may morph into SuperSpeed on reset. */
 	retval = hub_port_reset(hub, port1, udev, delay, false);
@@ -4891,7 +4889,6 @@ fail:
 		hub_port_disable(hub, port1, 0);
 		update_devnum(udev, devnum);	/* for disconnect processing */
 	}
-	mutex_unlock(hcd->address0_mutex);
 	return retval;
 }
 
@@ -5036,6 +5033,9 @@ static void hub_port_connect(struct usb_
 		unit_load = 100;
 
 	status = 0;
+
+	mutex_lock(hcd->address0_mutex);
+
 	for (i = 0; i < SET_CONFIG_TRIES; i++) {
 
 		/* reallocate for each attempt, since references
@@ -5072,6 +5072,8 @@ static void hub_port_connect(struct usb_
 		if (status < 0)
 			goto loop;
 
+		mutex_unlock(hcd->address0_mutex);
+
 		if (udev->quirks & USB_QUIRK_DELAY_INIT)
 			msleep(2000);
 
@@ -5160,6 +5162,7 @@ static void hub_port_connect(struct usb_
 
 loop_disable:
 		hub_port_disable(hub, port1, 1);
+		mutex_lock(hcd->address0_mutex);
 loop:
 		usb_ep0_reinit(udev);
 		release_devnum(udev);
@@ -5186,6 +5189,8 @@ loop:
 	}
 
 done:
+	mutex_unlock(hcd->address0_mutex);
+
 	hub_port_disable(hub, port1, 1);
 	if (hcd->driver->relinquish_port && !hub->hdev->parent) {
 		if (status != -ENOTCONN && status != -ENODEV)
@@ -5722,6 +5727,8 @@ static int usb_reset_and_verify_device(s
 	bos = udev->bos;
 	udev->bos = NULL;
 
+	mutex_lock(hcd->address0_mutex);
+
 	for (i = 0; i < SET_CONFIG_TRIES; ++i) {
 
 		/* ep0 maxpacket size may change; let the HCD know about it.
@@ -5731,6 +5738,7 @@ static int usb_reset_and_verify_device(s
 		if (ret >= 0 || ret == -ENOTCONN || ret == -ENODEV)
 			break;
 	}
+	mutex_unlock(hcd->address0_mutex);
 
 	if (ret < 0)
 		goto re_enumerate;


