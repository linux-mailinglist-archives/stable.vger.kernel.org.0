Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F264266A7
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 11:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235642AbhJHJZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 05:25:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:41430 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237621AbhJHJZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 05:25:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="249830684"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="249830684"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 02:23:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="489390477"
Received: from mattu-haswell.fi.intel.com ([10.237.72.170])
  by orsmga008.jf.intel.com with ESMTP; 08 Oct 2021 02:23:15 -0700
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Jonathan Bell <jonathan@raspberrypi.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 2/5] xhci: add quirk for host controllers that don't update endpoint DCS
Date:   Fri,  8 Oct 2021 12:25:44 +0300
Message-Id: <20211008092547.3996295-3-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008092547.3996295-1-mathias.nyman@linux.intel.com>
References: <20211008092547.3996295-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bell <jonathan@raspberrypi.org>

Seen on a VLI VL805 PCIe to USB controller. For non-stream endpoints
at least, if the xHC halts on a particular TRB due to an error then
the DCS field in the Out Endpoint Context maintained by the hardware
is not updated with the current cycle state.

Using the quirk XHCI_EP_CTX_BROKEN_DCS and instead fetch the DCS bit
from the TRB that the xHC stopped on.

[ bjorn: rebased to v5.14-rc2 ]
Cc: stable@vger.kernel.org
Link: https://github.com/raspberrypi/linux/issues/3060
Signed-off-by: Jonathan Bell <jonathan@raspberrypi.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-pci.c  |  4 +++-
 drivers/usb/host/xhci-ring.c | 25 ++++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 2c9f25ca8edd..633413d78380 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -279,8 +279,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 			pdev->device == 0x3432)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
-	if (pdev->vendor == PCI_VENDOR_ID_VIA && pdev->device == 0x3483)
+	if (pdev->vendor == PCI_VENDOR_ID_VIA && pdev->device == 0x3483) {
 		xhci->quirks |= XHCI_LPM_SUPPORT;
+		xhci->quirks |= XHCI_EP_CTX_BROKEN_DCS;
+	}
 
 	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
 		pdev->device == PCI_DEVICE_ID_ASMEDIA_1042_XHCI)
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index e676749f543b..7dbd26a9bc24 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -559,8 +559,11 @@ static int xhci_move_dequeue_past_td(struct xhci_hcd *xhci,
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
@@ -598,7 +601,27 @@ static int xhci_move_dequeue_past_td(struct xhci_hcd *xhci,
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
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index dca6181c33fd..5a75fe563123 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1899,6 +1899,7 @@ struct xhci_hcd {
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 #define XHCI_BROKEN_D3COLD	BIT_ULL(41)
+#define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.25.1

