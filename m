Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F59500E79
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243825AbiDNNRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243778AbiDNNRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:17:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F289154F;
        Thu, 14 Apr 2022 06:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5C99B82910;
        Thu, 14 Apr 2022 13:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D8EC385A1;
        Thu, 14 Apr 2022 13:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942104;
        bh=NQPIVR0e7eIba3kPb+i1E5KNRk2Vm5TI+XO/0mqC11U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFeFa0cMAVCku28JGjhP0ruIxkBYwnJQOcy46z9as8aqn1puEoloR5IgacLm/PFUh
         MYaJDxMuJ31OgbhkbYc/Rmfp8CWvNCla3tDDERJG2SLl0dFrtWEkTr1LSyQo519Aoj
         lM/wAjSvRX1jKXnrTrtVIIvprNpqJ3h5yQ0M9ZNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Pavan Kondeti <quic_pkondeti@quicinc.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 017/338] xhci: make xhci_handshake timeout for xhci_reset() adjustable
Date:   Thu, 14 Apr 2022 15:08:40 +0200
Message-Id: <20220414110839.381869170@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit 14073ce951b5919da450022c050772902f24f054 upstream.

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

Fixes: 22ceac191211 ("xhci: Increase reset timeout for Renesas 720201 host.")
Cc: stable@vger.kernel.org
Reported-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reported-by: Pavan Kondeti <quic_pkondeti@quicinc.com>
Tested-by: Pavan Kondeti <quic_pkondeti@quicinc.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220303110903.1662404-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c |    2 +-
 drivers/usb/host/xhci-mem.c |    2 +-
 drivers/usb/host/xhci.c     |   20 +++++++++-----------
 drivers/usb/host/xhci.h     |    7 +++++--
 4 files changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -670,7 +670,7 @@ static int xhci_exit_test_mode(struct xh
 	}
 	pm_runtime_allow(xhci_to_hcd(xhci)->self.controller);
 	xhci->test_mode = 0;
-	return xhci_reset(xhci);
+	return xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 }
 
 void xhci_set_link_state(struct xhci_hcd *xhci, struct xhci_port *port,
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2595,7 +2595,7 @@ int xhci_mem_init(struct xhci_hcd *xhci,
 
 fail:
 	xhci_halt(xhci);
-	xhci_reset(xhci);
+	xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	xhci_mem_cleanup(xhci);
 	return -ENOMEM;
 }
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -66,7 +66,7 @@ static bool td_on_ring(struct xhci_td *t
  * handshake done).  There are two failure modes:  "usec" have passed (major
  * hardware flakeout), or the register reads as all-ones (hardware removed).
  */
-int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec)
+int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, u64 timeout_us)
 {
 	u32	result;
 	int	ret;
@@ -74,7 +74,7 @@ int xhci_handshake(void __iomem *ptr, u3
 	ret = readl_poll_timeout_atomic(ptr, result,
 					(result & mask) == done ||
 					result == U32_MAX,
-					1, usec);
+					1, timeout_us);
 	if (result == U32_MAX)		/* card removed */
 		return -ENODEV;
 
@@ -163,7 +163,7 @@ int xhci_start(struct xhci_hcd *xhci)
  * Transactions will be terminated immediately, and operational registers
  * will be set to their defaults.
  */
-int xhci_reset(struct xhci_hcd *xhci)
+int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 {
 	u32 command;
 	u32 state;
@@ -196,8 +196,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	if (xhci->quirks & XHCI_INTEL_HOST)
 		udelay(1000);
 
-	ret = xhci_handshake(&xhci->op_regs->command,
-			CMD_RESET, 0, 10 * 1000 * 1000);
+	ret = xhci_handshake(&xhci->op_regs->command, CMD_RESET, 0, timeout_us);
 	if (ret)
 		return ret;
 
@@ -210,8 +209,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	 * xHCI cannot write to any doorbells or operational registers other
 	 * than status until the "Controller Not Ready" flag is cleared.
 	 */
-	ret = xhci_handshake(&xhci->op_regs->status,
-			STS_CNR, 0, 10 * 1000 * 1000);
+	ret = xhci_handshake(&xhci->op_regs->status, STS_CNR, 0, timeout_us);
 
 	for (i = 0; i < 2; i++) {
 		xhci->bus_state[i].port_c_suspend = 0;
@@ -731,7 +729,7 @@ static void xhci_stop(struct usb_hcd *hc
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
@@ -1162,7 +1160,7 @@ int xhci_resume(struct xhci_hcd *xhci, b
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
 		xhci_zero_64b_regs(xhci);
-		retval = xhci_reset(xhci);
+		retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 		spin_unlock_irq(&xhci->lock);
 		if (retval)
 			return retval;
@@ -5190,7 +5188,7 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 
 	xhci_dbg(xhci, "Resetting HCD\n");
 	/* Reset the internal HC memory state and registers. */
-	retval = xhci_reset(xhci);
+	retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 	if (retval)
 		return retval;
 	xhci_dbg(xhci, "Reset complete\n");
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -226,6 +226,9 @@ struct xhci_op_regs {
 #define CMD_ETE		(1 << 14)
 /* bits 15:31 are reserved (and should be preserved on writes). */
 
+#define XHCI_RESET_LONG_USEC		(10 * 1000 * 1000)
+#define XHCI_RESET_SHORT_USEC		(250 * 1000)
+
 /* IMAN - Interrupt Management Register */
 #define IMAN_IE		(1 << 1)
 #define IMAN_IP		(1 << 0)
@@ -2057,11 +2060,11 @@ void xhci_free_container_ctx(struct xhci
 
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


