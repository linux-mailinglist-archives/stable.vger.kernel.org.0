Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771D14702E2
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 15:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242099AbhLJOh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 09:37:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49620 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbhLJOh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 09:37:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDDEBB8281C
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 14:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C887C00446;
        Fri, 10 Dec 2021 14:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639146860;
        bh=7CjalsJIFoFXE590Nr+FswsDADOnu5G8pH5xq9Kc5m8=;
        h=Subject:To:From:Date:From;
        b=p5ZaxOvk03NEnzlYH2PLxbrO2/e0g6pDcOl+UO3+nC/EF2xx2uDCjbElFQiSmWKKg
         rKhXfPCD/Jr1CnfnoHOVkLen9l6on+ggzf95XtxIhLqdKyH1gS5QMuVytKzPzoXieX
         hKD6fL2uLVZ65SEgqj9yE5a9S/m27lM2yy19MzVo=
Subject: patch "xhci: avoid race between disable slot command and host runtime" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 15:34:09 +0100
Message-ID: <1639146849230232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: avoid race between disable slot command and host runtime

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7faac1953ed1f658f719cdf7bb7303fa5eef822c Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Fri, 10 Dec 2021 16:17:35 +0200
Subject: xhci: avoid race between disable slot command and host runtime
 suspend

Make xhci_disable_slot() synchronous, thus ensuring it, and
xhci_free_dev() calling it return after xHC controller completes
the disable slot command.

Otherwise the roothub and xHC host may runtime suspend, and clear the
command ring while the disable slot command is being processed.

This causes a command completion mismatch as the completion event can't
be mapped to the correct command.
Command ring gets out of sync and commands time out.
Driver finally assumes host is unresponsive and bails out.

usb 2-4: USB disconnect, device number 10
xhci_hcd 0000:00:0d.0: ERROR mismatched command completion event
...
xhci_hcd 0000:00:0d.0: xHCI host controller not responding, assume dead
xhci_hcd 0000:00:0d.0: HC died; cleaning up

Cc: <stable@vger.kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211210141735.1384209-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c  |  1 +
 drivers/usb/host/xhci-ring.c |  1 -
 drivers/usb/host/xhci.c      | 22 +++++++++++++++-------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index af946c42b6f0..df3522dab31b 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -717,6 +717,7 @@ static int xhci_enter_test_mode(struct xhci_hcd *xhci,
 			continue;
 
 		retval = xhci_disable_slot(xhci, i);
+		xhci_free_virt_device(xhci, i);
 		if (retval)
 			xhci_err(xhci, "Failed to disable slot %d, %d. Enter test mode anyway\n",
 				 i, retval);
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index eaa49aef2935..d0b6806275e0 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1525,7 +1525,6 @@ static void xhci_handle_cmd_disable_slot(struct xhci_hcd *xhci, int slot_id)
 	if (xhci->quirks & XHCI_EP_LIMIT_QUIRK)
 		/* Delete default control endpoint resources */
 		xhci_free_device_endpoint_resources(xhci, virt_dev, true);
-	xhci_free_virt_device(xhci, slot_id);
 }
 
 static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index af92a9f8ed67..f5b1bcc875de 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3959,9 +3959,8 @@ static void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev)
 		del_timer_sync(&virt_dev->eps[i].stop_cmd_timer);
 	}
 	virt_dev->udev = NULL;
-	ret = xhci_disable_slot(xhci, udev->slot_id);
-	if (ret)
-		xhci_free_virt_device(xhci, udev->slot_id);
+	xhci_disable_slot(xhci, udev->slot_id);
+	xhci_free_virt_device(xhci, udev->slot_id);
 }
 
 int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id)
@@ -3971,7 +3970,7 @@ int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id)
 	u32 state;
 	int ret = 0;
 
-	command = xhci_alloc_command(xhci, false, GFP_KERNEL);
+	command = xhci_alloc_command(xhci, true, GFP_KERNEL);
 	if (!command)
 		return -ENOMEM;
 
@@ -3996,6 +3995,15 @@ int xhci_disable_slot(struct xhci_hcd *xhci, u32 slot_id)
 	}
 	xhci_ring_cmd_db(xhci);
 	spin_unlock_irqrestore(&xhci->lock, flags);
+
+	wait_for_completion(command->completion);
+
+	if (command->status != COMP_SUCCESS)
+		xhci_warn(xhci, "Unsuccessful disable slot %u command, status %d\n",
+			  slot_id, command->status);
+
+	xhci_free_command(xhci, command);
+
 	return ret;
 }
 
@@ -4104,9 +4112,8 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	return 1;
 
 disable_slot:
-	ret = xhci_disable_slot(xhci, udev->slot_id);
-	if (ret)
-		xhci_free_virt_device(xhci, udev->slot_id);
+	xhci_disable_slot(xhci, udev->slot_id);
+	xhci_free_virt_device(xhci, udev->slot_id);
 
 	return 0;
 }
@@ -4236,6 +4243,7 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 
 		mutex_unlock(&xhci->mutex);
 		ret = xhci_disable_slot(xhci, udev->slot_id);
+		xhci_free_virt_device(xhci, udev->slot_id);
 		if (!ret)
 			xhci_alloc_dev(hcd, udev);
 		kfree(command->completion);
-- 
2.34.1


