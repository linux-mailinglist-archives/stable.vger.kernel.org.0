Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB6E4CBB3F
	for <lists+stable@lfdr.de>; Thu,  3 Mar 2022 11:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiCCK0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Mar 2022 05:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiCCK0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Mar 2022 05:26:11 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12573179A10;
        Thu,  3 Mar 2022 02:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646303125; x=1677839125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+XGuIpM+r+m/AeunvYr+GHU0lBtwG4Ax8Jpj4Gu8764=;
  b=XjvLFDNSPjW3AwRj1g9UssIRvMXK7/dHqNwQjv8V5i/Befk17o3grms/
   AM3PmAGUUZJjWm4P5hRGBn3zV/GBusqU0V8sdrpIV1eicay7F9ELds1vZ
   3zcaQCa75qUUr0ole9XSWyjzY11ybRzBXCLC61YC/3NdTXwgWeL3bW/pi
   QwaDPbmMTu2Xq5kWzH4yIFucCpjGgUxHH8dKnTTAKblM3i3WEvLQUgqN5
   mm76xukMY9N5S/+0IUXwvkx6GiYAnqySBXy9Y5AT1PAb/jb3boS5eZQGy
   ZdJRGwjVY1tmbonMsv4HZ96ZIYYnQr/vZiUeNVOqGQPKtZgAs0OnYbdD2
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="253567113"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="253567113"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 02:25:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="535773300"
Received: from mattu-haswell.fi.intel.com ([10.237.72.199])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2022 02:25:22 -0800
From:   Mathias Nyman <mathias.nyman@linux.intel.com>
To:     <gregkh@linuxfoundation.org>
Cc:     <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Pavan Kondeti <quic_pkondeti@quicinc.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/9] xhci: make xhci_handshake timeout for xhci_reset() adjustable
Date:   Thu,  3 Mar 2022 12:26:48 +0200
Message-Id: <20220303102656.1661407-2-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303102656.1661407-1-mathias.nyman@linux.intel.com>
References: <20220303102656.1661407-1-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xhci_reset() timeout was increased from 250ms to 10 seconds in order to
give Renesas 720201 xHC enough time to get ready in probe.

xhci_reset() is called with interrupts disabled in other places, and
waiting for 10 seconds there is not acceptable.

Add a timeout parameter to xhci_reset(), and adjust it back to 250ms
when called from xhci_stop() or xhci_shutdown() where interrupts are
disabled, and successful reset isn't that critical.
This solves issues when deactivating host mode on platforms like SM8450.

For now don't change the timeout if xHC is reset in xhci_resume().
No issues are reported for it, and we need the reset to succeed.
Locking around that reset needs to be revisited later.

Additionally change the signed integer timeout parameter in
xhci_handshake() to a u64 to match the timeout value we pass to
readl_poll_timeout_atomic()

Reported-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reported-by: Pavan Kondeti <quic_pkondeti@quicinc.com>
Fixes: 22ceac191211 ("xhci: Increase reset timeout for Renesas 720201 host.")
Cc: stable@vger.kernel.org
Tested-by: Pavan Kondeti <quic_pkondeti@quicinc.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci-hub.c |  2 +-
 drivers/usb/host/xhci-mem.c |  2 +-
 drivers/usb/host/xhci.c     | 20 +++++++++-----------
 drivers/usb/host/xhci.h     |  7 +++++--
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index df3522dab31b..bb4f01ce90e3 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -762,7 +762,7 @@ static int xhci_exit_test_mode(struct xhci_hcd *xhci)
 	}
 	pm_runtime_allow(xhci_to_hcd(xhci)->self.controller);
 	xhci->test_mode = 0;
-	return xhci_reset(xhci);
+	return xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 }
 
 void xhci_set_link_state(struct xhci_hcd *xhci, struct xhci_port *port,
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index cb70d0b31e08..48114a462908 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2575,7 +2575,7 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 
 fail:
 	xhci_halt(xhci);
-	xhci_reset(xhci);
+	xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	xhci_mem_cleanup(xhci);
 	return -ENOMEM;
 }
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index a1c781f70d02..6b32f7e65d4c 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -65,7 +65,7 @@ static bool td_on_ring(struct xhci_td *td, struct xhci_ring *ring)
  * handshake done).  There are two failure modes:  "usec" have passed (major
  * hardware flakeout), or the register reads as all-ones (hardware removed).
  */
-int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec)
+int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, u64 timeout_us)
 {
 	u32	result;
 	int	ret;
@@ -73,7 +73,7 @@ int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec)
 	ret = readl_poll_timeout_atomic(ptr, result,
 					(result & mask) == done ||
 					result == U32_MAX,
-					1, usec);
+					1, timeout_us);
 	if (result == U32_MAX)		/* card removed */
 		return -ENODEV;
 
@@ -162,7 +162,7 @@ int xhci_start(struct xhci_hcd *xhci)
  * Transactions will be terminated immediately, and operational registers
  * will be set to their defaults.
  */
-int xhci_reset(struct xhci_hcd *xhci)
+int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 {
 	u32 command;
 	u32 state;
@@ -195,8 +195,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	if (xhci->quirks & XHCI_INTEL_HOST)
 		udelay(1000);
 
-	ret = xhci_handshake(&xhci->op_regs->command,
-			CMD_RESET, 0, 10 * 1000 * 1000);
+	ret = xhci_handshake(&xhci->op_regs->command, CMD_RESET, 0, timeout_us);
 	if (ret)
 		return ret;
 
@@ -209,8 +208,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	 * xHCI cannot write to any doorbells or operational registers other
 	 * than status until the "Controller Not Ready" flag is cleared.
 	 */
-	ret = xhci_handshake(&xhci->op_regs->status,
-			STS_CNR, 0, 10 * 1000 * 1000);
+	ret = xhci_handshake(&xhci->op_regs->status, STS_CNR, 0, timeout_us);
 
 	xhci->usb2_rhub.bus_state.port_c_suspend = 0;
 	xhci->usb2_rhub.bus_state.suspended_ports = 0;
@@ -731,7 +729,7 @@ static void xhci_stop(struct usb_hcd *hcd)
 	xhci->xhc_state |= XHCI_STATE_HALTED;
 	xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
 	xhci_halt(xhci);
-	xhci_reset(xhci);
+	xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
@@ -784,7 +782,7 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	xhci_halt(xhci);
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
-		xhci_reset(xhci);
+		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
@@ -1170,7 +1168,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
 		xhci_zero_64b_regs(xhci);
-		retval = xhci_reset(xhci);
+		retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 		spin_unlock_irq(&xhci->lock);
 		if (retval)
 			return retval;
@@ -5307,7 +5305,7 @@ int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks)
 
 	xhci_dbg(xhci, "Resetting HCD\n");
 	/* Reset the internal HC memory state and registers. */
-	retval = xhci_reset(xhci);
+	retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 	if (retval)
 		return retval;
 	xhci_dbg(xhci, "Reset complete\n");
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 8a0026ee9524..fce32f8ea9d0 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -229,6 +229,9 @@ struct xhci_op_regs {
 #define CMD_ETE		(1 << 14)
 /* bits 15:31 are reserved (and should be preserved on writes). */
 
+#define XHCI_RESET_LONG_USEC		(10 * 1000 * 1000)
+#define XHCI_RESET_SHORT_USEC		(250 * 1000)
+
 /* IMAN - Interrupt Management Register */
 #define IMAN_IE		(1 << 1)
 #define IMAN_IP		(1 << 0)
@@ -2081,11 +2084,11 @@ void xhci_free_container_ctx(struct xhci_hcd *xhci,
 
 /* xHCI host controller glue */
 typedef void (*xhci_get_quirks_t)(struct device *, struct xhci_hcd *);
-int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec);
+int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, u64 timeout_us);
 void xhci_quiesce(struct xhci_hcd *xhci);
 int xhci_halt(struct xhci_hcd *xhci);
 int xhci_start(struct xhci_hcd *xhci);
-int xhci_reset(struct xhci_hcd *xhci);
+int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us);
 int xhci_run(struct usb_hcd *hcd);
 int xhci_gen_setup(struct usb_hcd *hcd, xhci_get_quirks_t get_quirks);
 void xhci_shutdown(struct usb_hcd *hcd);
-- 
2.25.1

