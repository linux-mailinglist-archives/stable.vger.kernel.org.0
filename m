Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886E63B9CCE
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 09:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhGBHQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 03:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhGBHQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 03:16:34 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05957C061762;
        Fri,  2 Jul 2021 00:14:02 -0700 (PDT)
Received: from miraculix.mork.no (fwa219.mork.no [192.168.9.219])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1627DiI7029093
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 2 Jul 2021 09:13:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1625210024; bh=R+jGgdiTe8/f1x+VMR1Hlad0GTYYmFFXNCFVp1D8WiY=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=Q8esaDJGLcbe6m7l22xWUab1Yisgb9k6VR7wxObgfc1/KK8Kj/zp5FSceDqSveIp+
         ky7NjtELywL+126oALJhqI620YBbiaixU5cjOlbGJj/OXIAMYdi7d5QCGbo+0d+zL6
         huMsiDRpKv/PzobC5rv7R1WTq7+TTeGTeZUZatI8=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1lzDMt-000B8i-Sf; Fri, 02 Jul 2021 09:13:43 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     Mathias Nyman <mathias.nyman@intel.com>
Cc:     linux-usb@vger.kernel.org,
        Jonathan Bell <jonathan@raspberrypi.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] xhci: add quirk for host controllers that don't update endpoint DCS
Date:   Fri,  2 Jul 2021 09:13:38 +0200
Message-Id: <20210702071338.42777-1-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at canardo
X-Virus-Status: Clean
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

Cc: stable@vger.kernel.org
Link: https://github.com/raspberrypi/linux/issues/3060
Signed-off-by: Jonathan Bell <jonathan@raspberrypi.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---

Ran into this issue on an RPi4 running Debian bullseye, having mostly
a plain v5.10.40 kernel. Using an RTL2838 (0bda:2838) with rtl-sdr
just did not work, showing all the issues described on the above link.

This quirk found in https://github.com/raspberrypi/linux.git solves
the problem for me.  I don't see why it shouldn't be in mainline. And
I propose adding it to stable as well, since it solves a real problem.
Mostly for my own convenience as I'd prefer just using a Debian built
kernel ;-)

Did not check this submission with Jonathan - hoping it is OK...


Bjørn

 drivers/usb/host/xhci-pci.c  |  4 +++-
 drivers/usb/host/xhci-ring.c | 26 ++++++++++++++++++++++++++
 drivers/usb/host/xhci.h      |  1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 18c2bbddf080..6f3bed09028c 100644
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
index 8fea44bbc266..a9c860ff5177 100644
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
@@ -600,6 +603,29 @@ static int xhci_move_dequeue_past_td(struct xhci_hcd *xhci,
 	new_deq = ep_ring->dequeue;
 	new_cycle = hw_dequeue & 0x1;
 
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
+	state->stream_id = stream_id;
+
 	/*
 	 * We want to find the pointer, segment and cycle state of the new trb
 	 * (the one after current TD's last_trb). We know the cycle state at
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 3c7d281672ae..911aeb7d8a19 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1896,6 +1896,7 @@ struct xhci_hcd {
 #define XHCI_SG_TRB_CACHE_SIZE_QUIRK	BIT_ULL(39)
 #define XHCI_NO_SOFT_RETRY	BIT_ULL(40)
 #define XHCI_BROKEN_D3COLD	BIT_ULL(41)
+#define XHCI_EP_CTX_BROKEN_DCS	BIT_ULL(42)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.30.2

