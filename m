Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEA847262F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbhLMJt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38014 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbhLMJpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:45:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 14A84CE0E6B;
        Mon, 13 Dec 2021 09:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5340C341C5;
        Mon, 13 Dec 2021 09:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388704;
        bh=mln0Ou4ApRqoMfyotaxd7pUhZ1mnqDVi1NYG6zufuuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smfOetqSKbpRPtQL+yu0Oe1ytfxZVx3Y5TRztK9GnFwQS82x5fM0mRgjZvcxolomP
         rTWFO0omv9iQRvv2EgEeu3sdZyuirIHTVrptsAvhJT+leD2MOky2b79Zbpa0yuuw4O
         U/SMM4jAhsuFJP373VbjbSHZ6hpMo0GKze+kDU4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 69/88] xhci: avoid race between disable slot command and host runtime suspend
Date:   Mon, 13 Dec 2021 10:30:39 +0100
Message-Id: <20211213092935.638632334@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
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
@@ -629,6 +629,7 @@ static int xhci_enter_test_mode(struct x
 			continue;
 
 		retval = xhci_disable_slot(xhci, i);
+		xhci_free_virt_device(xhci, i);
 		if (retval)
 			xhci_err(xhci, "Failed to disable slot %d, %d. Enter test mode anyway\n",
 				 i, retval);
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1265,7 +1265,6 @@ static void xhci_handle_cmd_disable_slot
 	if (xhci->quirks & XHCI_EP_LIMIT_QUIRK)
 		/* Delete default control endpoint resources */
 		xhci_free_device_endpoint_resources(xhci, virt_dev, true);
-	xhci_free_virt_device(xhci, slot_id);
 }
 
 static void xhci_handle_cmd_config_ep(struct xhci_hcd *xhci, int slot_id,
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3914,9 +3914,8 @@ static void xhci_free_dev(struct usb_hcd
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
@@ -3926,7 +3925,7 @@ int xhci_disable_slot(struct xhci_hcd *x
 	u32 state;
 	int ret = 0;
 
-	command = xhci_alloc_command(xhci, false, GFP_KERNEL);
+	command = xhci_alloc_command(xhci, true, GFP_KERNEL);
 	if (!command)
 		return -ENOMEM;
 
@@ -3951,6 +3950,15 @@ int xhci_disable_slot(struct xhci_hcd *x
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
 
@@ -4059,9 +4067,8 @@ int xhci_alloc_dev(struct usb_hcd *hcd,
 	return 1;
 
 disable_slot:
-	ret = xhci_disable_slot(xhci, udev->slot_id);
-	if (ret)
-		xhci_free_virt_device(xhci, udev->slot_id);
+	xhci_disable_slot(xhci, udev->slot_id);
+	xhci_free_virt_device(xhci, udev->slot_id);
 
 	return 0;
 }
@@ -4191,6 +4198,7 @@ static int xhci_setup_device(struct usb_
 
 		mutex_unlock(&xhci->mutex);
 		ret = xhci_disable_slot(xhci, udev->slot_id);
+		xhci_free_virt_device(xhci, udev->slot_id);
 		if (!ret)
 			xhci_alloc_dev(hcd, udev);
 		kfree(command->completion);


