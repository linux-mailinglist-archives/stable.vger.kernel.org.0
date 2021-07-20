Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0593CFE9B
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237508AbhGTPZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238833AbhGTOd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 10:33:29 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C45C061768;
        Tue, 20 Jul 2021 08:10:03 -0700 (PDT)
Received: from miraculix.mork.no ([IPv6:2a01:799:961:430a:744a:d5d7:6f76:7145])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 16KF9j5O000624
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 20 Jul 2021 17:09:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1626793786; bh=UQZD9gxUv5YCW7UvplPTsBWa+iovIkDODIAm9tJLh+Q=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=Jjdr0ybtXuWMImHx/v7L/CAEUoKAvAWAmWBB8p+uWTBW5eVLfcB5Bf+27RXRkh56T
         pnDiMtLEMzCWO28Q0LAy5ayTl7OP1f65KW/KJBpe3uUUVPM1WSvZepz3kZYhbBFPy4
         s3z/2pD4SwT241OKXrbatQVYNXPdc4d2mHI0KG38=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1m5rNM-001MgG-AN; Tue, 20 Jul 2021 17:09:40 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     Mathias Nyman <mathias.nyman@intel.com>
Cc:     linux-usb@vger.kernel.org,
        Jonathan Bell <jonathan@raspberrypi.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v2] xhci: add quirk for host controllers that don't update endpoint DCS
Date:   Tue, 20 Jul 2021 17:09:37 +0200
Message-Id: <20210720150937.325469-1-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87h7hdf5dy.fsf@miraculix.mork.no>
References: <87h7hdf5dy.fsf@miraculix.mork.no>
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

[ bjorn: rebased to v5.14-rc2 ]
Cc: stable@vger.kernel.org
Link: https://github.com/raspberrypi/linux/issues/3060
Signed-off-by: Jonathan Bell <jonathan@raspberrypi.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
This took some time...

But now it is at least build and runtime tested on top of v5.14-rc2,
using an RPi4 and a generic RTL2838 DVB-T radio.  Running rtl_test
from rtl-sdr on an unpatched v5.14-rc2:


root@idefix:/home/bjorn#  rtl_test
Found 1 device(s):
  0:  Realtek, RTL2838UHIDIR, SN: 00000001

Using device 0: Generic RTL2832U OEM
rtlsdr_read_reg failed with -7
rtlsdr_write_reg failed with -7
rtlsdr_read_reg failed with -7
rtlsdr_write_reg failed with -7
rtlsdr_read_reg failed with -7
rtlsdr_write_reg failed with -7
rtlsdr_read_reg failed with -7
rtlsdr_write_reg failed with -7
No supported tuner found
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
Enabled direct sampling mode, input 1
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
Supported gain values (1): 0.0 
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
WARNING: Failed to set sample rate.
rtlsdr_demod_write_reg failed with -7
rtlsdr_demod_read_reg failed with -7
rtlsdr_write_reg failed with -7
rtlsdr_write_reg failed with -7

Info: This tool will continuously read from the device, and report if
samples get lost. If you observe no further output, everything is fine.

Reading samples in async mode...
Allocating 15 zero-copy buffers



And with this fix in place:



root@idefix:/home/bjorn# rtl_test
Found 1 device(s):
  0:  Realtek, RTL2838UHIDIR, SN: 00000001

Using device 0: Generic RTL2832U OEM
Detached kernel driver
Found Fitipower FC0012 tuner
Supported gain values (5): -9.9 -4.0 7.1 17.9 19.2 
Sampling at 2048000 S/s.

Info: This tool will continuously read from the device, and report if
samples get lost. If you observe no further output, everything is fine.

Reading samples in async mode...
Allocating 15 zero-copy buffers
lost at least 88 bytes



Please apply to stable as well. I'd really like to see this fixed in
my favourite distro kernel.  You'll probably want Jonathans original
patch, as posted in <20210702071338.42777-1-bjorn@mork.no>, for
anything older than v5.12.  I'll resend that for stable once/if this
is accepted in mainline.



Bjørn


 drivers/usb/host/xhci-pci.c  |  4 +++-
 drivers/usb/host/xhci-ring.c | 25 ++++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |  1 +
 3 files changed, 28 insertions(+), 2 deletions(-)

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
index 8fea44bbc266..ba978a8fa414 100644
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
2.20.1

