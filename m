Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0295470281
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 15:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238527AbhLJOT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 09:19:56 -0500
Received: from mga12.intel.com ([192.55.52.136]:31713 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238496AbhLJOTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Dec 2021 09:19:55 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="218372242"
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="218372242"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 06:16:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="463677544"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga006.jf.intel.com with ESMTP; 10 Dec 2021 06:16:06 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] xhci: avoid race between disable slot command and host runtime suspend
Date:   Fri, 10 Dec 2021 16:17:35 +0200
Message-Id: <20211210141735.1384209-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211210141735.1384209-1-mathias.nyman@linux.intel.com>
References: <20211210141735.1384209-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.25.1

