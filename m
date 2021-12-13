Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40E84727B4
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241445AbhLMKEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:04:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46252 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238383AbhLMKAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:00:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3A62B80E88;
        Mon, 13 Dec 2021 10:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27C9C34601;
        Mon, 13 Dec 2021 09:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389600;
        bh=zhftjHUsvaC5S4p/MhT8iyTl+iT9wIoFRmi1Q129fUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/H0D7AduvXpBJjV2WUW/CggegLUcmS49Im/yUKFPfPPRjQyphmmRy1Z3rhHrxk8X
         VtkfXotmGV4Dv4CfDgq7QFDDWRGFptJ5KOMVmOXb5XjMvseoMdnwgX2x7D7IRHGBJw
         txzkGpvCzFfOmWNgssB6fnDaibb0sK6BTuoGtZAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.15 142/171] xhci: avoid race between disable slot command and host runtime suspend
Date:   Mon, 13 Dec 2021 10:30:57 +0100
Message-Id: <20211213092949.807916163@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 7faac1953ed1f658f719cdf7bb7303fa5eef822c upstream.

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
 drivers/usb/host/xhci-hub.c  |    1 +
 drivers/usb/host/xhci-ring.c |    1 -
 drivers/usb/host/xhci.c      |   22 +++++++++++++++-------
 3 files changed, 16 insertions(+), 8 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -717,6 +717,7 @@ static int xhci_enter_test_mode(struct x
 			continue;
 
 		retval = xhci_disable_slot(xhci, i);
+		xhci_free_virt_device(xhci, i);
 		if (retval)
 			xhci_err(xhci, "Failed to disable slot %d, %d. Enter test mode anyway\n",
 				 i, retval);
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1525,7 +1525,6 @@ static void xhci_handle_cmd_disable_slot
 	if (xhci->quirks & XHCI_EP_LIMIT_QUIRK)
 		/* Delete default control endpoint resources */
 		xhci_free_device_endpoint_resources(xhci, virt_dev, true);
-	xhci_free_virt_device(xhci, slot_id);
 }
 
 static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3959,9 +3959,8 @@ static void xhci_free_dev(struct usb_hcd
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
@@ -3971,7 +3970,7 @@ int xhci_disable_slot(struct xhci_hcd *x
 	u32 state;
 	int ret = 0;
 
-	command = xhci_alloc_command(xhci, false, GFP_KERNEL);
+	command = xhci_alloc_command(xhci, true, GFP_KERNEL);
 	if (!command)
 		return -ENOMEM;
 
@@ -3996,6 +3995,15 @@ int xhci_disable_slot(struct xhci_hcd *x
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
 
@@ -4104,9 +4112,8 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 	return 1;
 
 disable_slot:
-	ret = xhci_disable_slot(xhci, udev->slot_id);
-	if (ret)
-		xhci_free_virt_device(xhci, udev->slot_id);
+	xhci_disable_slot(xhci, udev->slot_id);
+	xhci_free_virt_device(xhci, udev->slot_id);
 
 	return 0;
 }
@@ -4236,6 +4243,7 @@ static int xhci_setup_device(struct usb_
 
 		mutex_unlock(&xhci->mutex);
 		ret = xhci_disable_slot(xhci, udev->slot_id);
+		xhci_free_virt_device(xhci, udev->slot_id);
 		if (!ret)
 			xhci_alloc_dev(hcd, udev);
 		kfree(command->completion);


