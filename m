Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261DE431DAF
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhJRNyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233806AbhJRNv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:51:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 710FB61407;
        Mon, 18 Oct 2021 13:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564312;
        bh=+3F4SyqcM68dnobRqmLg+3dSvYtGBunsbqezh4KDSYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5kS3+6rRJ+45qJAxCvBT02OwWGIiq1Qkho4mBeh6aOxKD03/G9rd94aG7peb6u0C
         roDRIHgUm4UFHLYLyYhL8GuytOFfmq8XPsyzKlFJNRL4cbJx1H/RMC2YTJ+Th0j5X1
         kxoJeN6VenNTA8JnjVZuI0yXlrKkIF42Z6f7kcrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Bell <jonathan@raspberrypi.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.14 042/151] xhci: add quirk for host controllers that dont update endpoint DCS
Date:   Mon, 18 Oct 2021 15:23:41 +0200
Message-Id: <20211018132342.069514792@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bell <jonathan@raspberrypi.org>

commit 5255660b208aebfdb71d574f3952cf48392f4306 upstream.

Seen on a VLI VL805 PCIe to USB controller. For non-stream endpoints
at least, if the xHC halts on a particular TRB due to an error then
the DCS field in the Out Endpoint Context maintained by the hardware
is not updated with the current cycle state.

Using the quirk XHCI_EP_CTX_BROKEN_DCS and instead fetch the DCS bit
from the TRB that the xHC stopped on.

[ bjorn: rebased to v5.14-rc2 ]

Link: https://github.com/raspberrypi/linux/issues/3060
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Bell <jonathan@raspberrypi.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20211008092547.3996295-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c  |    4 +++-
 drivers/usb/host/xhci-ring.c |   25 ++++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |    1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -279,8 +279,10 @@ static void xhci_pci_quirks(struct devic
 			pdev->device == 0x3432)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
-	if (pdev->vendor == PCI_VENDOR_ID_VIA && pdev->device == 0x3483)
+	if (pdev->vendor == PCI_VENDOR_ID_VIA && pdev->device == 0x3483) {
 		xhci->quirks |= XHCI_LPM_SUPPORT;
+		xhci->quirks |= XHCI_EP_CTX_BROKEN_DCS;
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -559,8 +559,11 @@ static int xhci_move_dequeue_past_td(str
 	struct xhci_ring *ep_ring;
 	struct xhci_command *cmd;
 	struct xhci_segment *new_seg;
+	struct xhci_segment *halted_seg = NULL;
 	union xhci_trb *new_deq;
 	int new_cycle;
+	union xhci_trb *halted_trb;
+	int index = 0;
 	dma_addr_t addr;
 	u64 hw_dequeue;
 	bool cycle_found = false;
@@ -598,7 +601,27 @@ static int xhci_move_dequeue_past_td(str
 	hw_dequeue = xhci_get_hw_deq(xhci, dev, ep_index, stream_id);
 	new_seg = ep_ring->deq_seg;
 	new_deq = ep_ring->dequeue;
-	new_cycle = hw_dequeue & 0x1;
+
+	/*
+	 * Quirk: xHC write-back of the DCS field in the hardware dequeue
+	 * pointer is wrong - use the cycle state of the TRB pointed to by
+	 * the dequeue pointer.
+	 */
+	if (xhci->quirks & XHCI_EP_CTX_BROKEN_DCS &&
+	    !(ep->ep_state & EP_HAS_STREAMS))
+		halted_seg = trb_in_td(xhci, td->start_seg,
+				       td->first_trb, td->last_trb,
+				       hw_dequeue & ~0xf, false);
+	if (halted_seg) {
+		index = ((dma_addr_t)(hw_dequeue & ~0xf) - halted_seg->dma) /
+			 sizeof(*halted_trb);
+		halted_trb = &halted_seg->trbs[index];
+		new_cycle = halted_trb->generic.field[3] & 0x1;
+		xhci_dbg(xhci, "Endpoint DCS = %d TRB index = %d cycle = %d\n",
+			 (u8)(hw_dequeue & 0x1), index, new_cycle);
+	} else {
+		new_cycle = hw_dequeue & 0x1;
+	}
 
 	/*
 	 * We want to find the pointer, segment and cycle state of the new trb
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1899,6 +1899,7 @@ struct xhci_hcd {
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 #define XHCI_BROKEN_D3COLD	BIT_ULL(41)
+#define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;


