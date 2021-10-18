Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14E5432465
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 19:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhJRRJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 13:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhJRRJN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 13:09:13 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B95C06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 10:07:01 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 19IH6kvq1381403
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 18 Oct 2021 19:06:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1634576807; bh=VQzrfrtS9JizLxJ1rlOvc6Amovl9XyMY4nYnHLAuCLI=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=iscjovcZOOxlueLuJIdClNuajs/kPR6GtjPlX0OV2kqHvqh6KNnSMo+U38WUJQ5Oq
         gmjAaTPMjBls2g7U4jUwE5zLhHMb0CDAiNuHX0nzEBb/ux06UboCdvmj7XwEQl2mXU
         /ox5UqgvYzVcUsUOEKV0bLfsqAsLTsDJEz1YJYY8=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1mcW61-0001UH-K8; Mon, 18 Oct 2021 19:06:45 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     stable@vger.kernel.org
Cc:     Jonathan Bell <jonathan@raspberrypi.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH backport for v5.10] xhci: add quirk for host controllers that don't update endpoint DCS
Date:   Mon, 18 Oct 2021 19:06:34 +0200
Message-Id: <20211018170634.5673-1-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Bell <jonathan@raspberrypi.org>

upstream commit 5255660b208a

Seen on a VLI VL805 PCIe to USB controller. For non-stream endpoints
at least, if the xHC halts on a particular TRB due to an error then
the DCS field in the Out Endpoint Context maintained by the hardware
is not updated with the current cycle state.

Using the quirk XHCI_EP_CTX_BROKEN_DCS and instead fetch the DCS bit
from the TRB that the xHC stopped on.

See: https://github.com/raspberrypi/linux/issues/3060

Signed-off-by: Jonathan Bell <jonathan@raspberrypi.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
---

This isn't really a backport.  It's the original patch for 5.10 from
https://github.com/raspberrypi/linux.git , which was forward ported
and ended up as upstream commit 5255660b208a

The XHCI_EP_CTX_BROKEN_DCS constant has been syncronozed with upstream
to avoid collisions, though.

I hope that is OK.



Bjørn

 drivers/usb/host/xhci-pci.c  |  4 +++-
 drivers/usb/host/xhci-ring.c | 26 +++++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |  1 +
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 119d1a8fbb19..618a131bdd53 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -274,8 +274,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
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
index dc2068e3bedb..c8d733ff3eb5 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -556,7 +556,10 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	struct xhci_virt_ep *ep = &dev->eps[ep_index];
 	struct xhci_ring *ep_ring;
 	struct xhci_segment *new_seg;
+	struct xhci_segment *halted_seg = NULL;
 	union xhci_trb *new_deq;
+	union xhci_trb *halted_trb;
+	int index = 0;
 	dma_addr_t addr;
 	u64 hw_dequeue;
 	bool cycle_found = false;
@@ -594,7 +597,28 @@ void xhci_find_new_dequeue_state(struct xhci_hcd *xhci,
 	hw_dequeue = xhci_get_hw_deq(xhci, dev, ep_index, stream_id);
 	new_seg = ep_ring->deq_seg;
 	new_deq = ep_ring->dequeue;
-	state->new_cycle_state = hw_dequeue & 0x1;
+
+	/*
+	 * Quirk: xHC write-back of the DCS field in the hardware dequeue
+	 * pointer is wrong - use the cycle state of the TRB pointed to by
+	 * the dequeue pointer.
+	 */
+	if (xhci->quirks & XHCI_EP_CTX_BROKEN_DCS &&
+	    !(ep->ep_state & EP_HAS_STREAMS))
+		halted_seg = trb_in_td(xhci, cur_td->start_seg,
+				       cur_td->first_trb, cur_td->last_trb,
+				       hw_dequeue & ~0xf, false);
+	if (halted_seg) {
+		index = ((dma_addr_t)(hw_dequeue & ~0xf) - halted_seg->dma) /
+			 sizeof(*halted_trb);
+		halted_trb = &halted_seg->trbs[index];
+		state->new_cycle_state = halted_trb->generic.field[3] & 0x1;
+		xhci_dbg(xhci, "Endpoint DCS = %d TRB index = %d cycle = %d\n",
+			 (u8)(hw_dequeue & 0x1), index,
+			 state->new_cycle_state);
+	} else {
+		state->new_cycle_state = hw_dequeue & 0x1;
+	}
 	state->stream_id = stream_id;
 
 	/*
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 1c97c8d81154..45584a278336 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1884,6 +1884,7 @@ struct xhci_hcd {
 #define XHCI_DISABLE_SPARSE	BIT_ULL(38)
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
+#define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.30.2

