Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED7F3F2BF0
	for <lists+stable@lfdr.de>; Thu,  7 Nov 2019 11:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfKGKQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Nov 2019 05:16:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfKGKQH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Nov 2019 05:16:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F6CD2084D;
        Thu,  7 Nov 2019 10:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573121764;
        bh=JXEBTxiCjBFcGqCa+1IwzVpQYcKpaov7nk9Wi9pQMdo=;
        h=Subject:To:From:Date:From;
        b=DwwG2dKDgThYQz3nDGumEKeuvWNibQJl4GbOFEZveeCOjqbs/wxyiDLSxatCtoFPf
         r8D731YFZXDY8R9KxlI0wxkpe/O1tfX6Z4h0mASjf3Ir+ZKUrTmN6UGM7vcqVTghGR
         D9RT59ytw2fxw+m6ZHp39voGOby3fQ3gnuyMX710=
Subject: patch "usb: Allow USB device to be warm reset in suspended state" added to usb-testing
To:     kai.heng.feng@canonical.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 07 Nov 2019 11:15:52 +0100
Message-ID: <157312175222237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: Allow USB device to be warm reset in suspended state

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From e76b3bf7654c3c94554c24ba15a3d105f4006c80 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Wed, 6 Nov 2019 14:27:10 +0800
Subject: usb: Allow USB device to be warm reset in suspended state

On Dell WD15 dock, sometimes USB ethernet cannot be detected after plugging
cable to the ethernet port, the hub and roothub get runtime resumed and
runtime suspended immediately:
...
[  433.315169] xhci_hcd 0000:3a:00.0: hcd_pci_runtime_resume: 0
[  433.315204] usb usb4: usb auto-resume
[  433.315226] hub 4-0:1.0: hub_resume
[  433.315239] xhci_hcd 0000:3a:00.0: Get port status 4-1 read: 0x10202e2, return 0x10343
[  433.315264] usb usb4-port1: status 0343 change 0001
[  433.315279] xhci_hcd 0000:3a:00.0: clear port1 connect change, portsc: 0x10002e2
[  433.315293] xhci_hcd 0000:3a:00.0: Get port status 4-2 read: 0x2a0, return 0x2a0
[  433.317012] xhci_hcd 0000:3a:00.0: xhci_hub_status_data: stopping port polling.
[  433.422282] xhci_hcd 0000:3a:00.0: Get port status 4-1 read: 0x10002e2, return 0x343
[  433.422307] usb usb4-port1: do warm reset
[  433.422311] usb 4-1: device reset not allowed in state 8
[  433.422339] hub 4-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  433.422346] xhci_hcd 0000:3a:00.0: Get port status 4-1 read: 0x10002e2, return 0x343
[  433.422356] usb usb4-port1: do warm reset
[  433.422358] usb 4-1: device reset not allowed in state 8
[  433.422428] xhci_hcd 0000:3a:00.0: set port remote wake mask, actual port 0 status  = 0xf0002e2
[  433.422455] xhci_hcd 0000:3a:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
[  433.422465] hub 4-0:1.0: hub_suspend
[  433.422475] usb usb4: bus auto-suspend, wakeup 1
[  433.426161] xhci_hcd 0000:3a:00.0: xhci_hub_status_data: stopping port polling.
[  433.466209] xhci_hcd 0000:3a:00.0: port 0 polling in bus suspend, waiting
[  433.510204] xhci_hcd 0000:3a:00.0: port 0 polling in bus suspend, waiting
[  433.554051] xhci_hcd 0000:3a:00.0: port 0 polling in bus suspend, waiting
[  433.598235] xhci_hcd 0000:3a:00.0: port 0 polling in bus suspend, waiting
[  433.642154] xhci_hcd 0000:3a:00.0: port 0 polling in bus suspend, waiting
[  433.686204] xhci_hcd 0000:3a:00.0: port 0 polling in bus suspend, waiting
[  433.730205] xhci_hcd 0000:3a:00.0: port 0 polling in bus suspend, waiting
[  433.774203] xhci_hcd 0000:3a:00.0: port 0 polling in bus suspend, waiting
[  433.818207] xhci_hcd 0000:3a:00.0: port 0 polling in bus suspend, waiting
[  433.862040] xhci_hcd 0000:3a:00.0: port 0 polling in bus suspend, waiting
[  433.862053] xhci_hcd 0000:3a:00.0: xhci_hub_status_data: stopping port polling.
[  433.862077] xhci_hcd 0000:3a:00.0: xhci_suspend: stopping port polling.
[  433.862096] xhci_hcd 0000:3a:00.0: // Setting command ring address to 0x8578fc001
[  433.862312] xhci_hcd 0000:3a:00.0: hcd_pci_runtime_suspend: 0
[  433.862445] xhci_hcd 0000:3a:00.0: PME# enabled
[  433.902376] xhci_hcd 0000:3a:00.0: restoring config space at offset 0xc (was 0x0, writing 0x20)
[  433.902395] xhci_hcd 0000:3a:00.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100403)
[  433.902490] xhci_hcd 0000:3a:00.0: PME# disabled
[  433.902504] xhci_hcd 0000:3a:00.0: enabling bus mastering
[  433.902547] xhci_hcd 0000:3a:00.0: // Setting command ring address to 0x8578fc001
[  433.902649] pcieport 0000:00:1b.0: PME: Spurious native interrupt!
[  433.902839] xhci_hcd 0000:3a:00.0: Port change event, 4-1, id 3, portsc: 0xb0202e2
[  433.902842] xhci_hcd 0000:3a:00.0: resume root hub
[  433.902845] xhci_hcd 0000:3a:00.0: handle_port_status: starting port polling.
[  433.902877] xhci_hcd 0000:3a:00.0: xhci_resume: starting port polling.
[  433.902889] xhci_hcd 0000:3a:00.0: xhci_hub_status_data: stopping port polling.
[  433.902891] xhci_hcd 0000:3a:00.0: hcd_pci_runtime_resume: 0
[  433.902919] usb usb4: usb wakeup-resume
[  433.902942] usb usb4: usb auto-resume
[  433.902966] hub 4-0:1.0: hub_resume
...

As Mathias pointed out, the hub enters Cold Attach Status state and
requires a warm reset. However usb_reset_device() bails out early when
the device is in suspended state, as its callers port_event() and
hub_event() don't always resume the device.

Since there's nothing wrong to reset a suspended device, allow
usb_reset_device() to do so to solve the issue.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191106062710.29880-1-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index fdcfa85b5b12..1709895387b9 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5840,7 +5840,7 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
 
 /**
  * usb_reset_device - warn interface drivers and perform a USB port reset
- * @udev: device to reset (not in SUSPENDED or NOTATTACHED state)
+ * @udev: device to reset (not in NOTATTACHED state)
  *
  * Warns all drivers bound to registered interfaces (using their pre_reset
  * method), performs the port reset, and then lets the drivers know that
@@ -5868,8 +5868,7 @@ int usb_reset_device(struct usb_device *udev)
 	struct usb_host_config *config = udev->actconfig;
 	struct usb_hub *hub = usb_hub_to_struct_hub(udev->parent);
 
-	if (udev->state == USB_STATE_NOTATTACHED ||
-			udev->state == USB_STATE_SUSPENDED) {
+	if (udev->state == USB_STATE_NOTATTACHED) {
 		dev_dbg(&udev->dev, "device reset not allowed in state %d\n",
 				udev->state);
 		return -EINVAL;
-- 
2.23.0


