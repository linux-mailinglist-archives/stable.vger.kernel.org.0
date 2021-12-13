Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4179747282E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbhLMKIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238836AbhLMKGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:06:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B6CC0A888B;
        Mon, 13 Dec 2021 01:51:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7BFBB80DE8;
        Mon, 13 Dec 2021 09:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285DFC341DB;
        Mon, 13 Dec 2021 09:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389064;
        bh=Qg9489yHjf8bUZe92HYxbHQzUEj8VgMsgS+lFbgvtSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWd0D5qeFGQ0BcdVmOKJGLlvTawyzzI2vBCTr6wU6mbuLdcdtYbVMgVvYzZKqoA4f
         XpCs7oKYSylTc2VTu1U54SgCTa1uu7N77TKPHY6muXGbl81d06HOSrShnFC6l2A0g9
         6Go15G/H7TnZUTVeTTATgWZq/+zFIhd3qcmQ2gNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.10 105/132] xhci: avoid race between disable slot command and host runtime suspend
Date:   Mon, 13 Dec 2021 10:30:46 +0100
Message-Id: <20211213092942.700785798@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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
@@ -631,6 +631,7 @@ static int xhci_enter_test_mode(struct x
 			continue;
 
 		retval = xhci_disable_slot(xhci, i);
+		xhci_free_virt_device(xhci, i);
 		if (retval)
 			xhci_err(xhci, "Failed to disable slot %d, %d. Enter test mode anyway\n",
 				 i, retval);
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1298,7 +1298,6 @@ static void xhci_handle_cmd_disable_slot
 	if (xhci->quirks & XHCI_EP_LIMIT_QUIRK)
 		/* Delete default control endpoint resources */
 		xhci_free_device_endpoint_resources(xhci, virt_dev, true);
-	xhci_free_virt_device(xhci, slot_id);
 }
 
 static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3918,9 +3918,8 @@ static void xhci_free_dev(struct usb_hcd
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
@@ -3930,7 +3929,7 @@ int xhci_disable_slot(struct xhci_hcd *x
 	u32 state;
 	int ret = 0;
 
-	command = xhci_alloc_command(xhci, false, GFP_KERNEL);
+	command = xhci_alloc_command(xhci, true, GFP_KERNEL);
 	if (!command)
 		return -ENOMEM;
 
@@ -3955,6 +3954,15 @@ int xhci_disable_slot(struct xhci_hcd *x
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
 
@@ -4063,9 +4071,8 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 	return 1;
 
 disable_slot:
-	ret = xhci_disable_slot(xhci, udev->slot_id);
-	if (ret)
-		xhci_free_virt_device(xhci, udev->slot_id);
+	xhci_disable_slot(xhci, udev->slot_id);
+	xhci_free_virt_device(xhci, udev->slot_id);
 
 	return 0;
 }
@@ -4195,6 +4202,7 @@ static int xhci_setup_device(struct usb_
 
 		mutex_unlock(&xhci->mutex);
 		ret = xhci_disable_slot(xhci, udev->slot_id);
+		xhci_free_virt_device(xhci, udev->slot_id);
 		if (!ret)
 			xhci_alloc_dev(hcd, udev);
 		kfree(command->completion);


