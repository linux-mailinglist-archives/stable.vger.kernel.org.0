Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF08657991A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237697AbiGSL6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237530AbiGSL6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:58:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864EE4333B;
        Tue, 19 Jul 2022 04:57:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1CC5615AC;
        Tue, 19 Jul 2022 11:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2AA3C341C6;
        Tue, 19 Jul 2022 11:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231826;
        bh=Ngq6XT5KILSGZYCIKyZdb2wfHQ37stdoyQM51xzmYZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zg8xMDGZfX6vkIj6Ez3KURf1IjVuXHph8Lq9GBkBX/zXWgshdedYF1T9EHnK5KgLi
         MM8bHoepjUPBl5CA2F3/yqQurqoP1IXzA1A9AqWPiMFovDl4Bj3rnmLy5dwKJrWIc5
         WOBOvr//1lbXwix/8JejgD7kk8eBOhVQW0BPYwyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Pavan Kondeti <quic_pkondeti@quicinc.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 11/43] xhci: make xhci_handshake timeout for xhci_reset() adjustable
Date:   Tue, 19 Jul 2022 13:53:42 +0200
Message-Id: <20220719114523.024157797@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c |    2 +-
 drivers/usb/host/xhci-mem.c |    2 +-
 drivers/usb/host/xhci.c     |   20 +++++++++-----------
 drivers/usb/host/xhci.h     |    7 +++++--
 4 files changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -683,7 +683,7 @@ static int xhci_exit_test_mode(struct xh
 	}
 	pm_runtime_allow(xhci_to_hcd(xhci)->self.controller);
 	xhci->test_mode = 0;
-	return xhci_reset(xhci);
+	return xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 }
 
 void xhci_set_link_state(struct xhci_hcd *xhci, __le32 __iomem **port_array,
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2574,7 +2574,7 @@ int xhci_mem_init(struct xhci_hcd *xhci,
 
 fail:
 	xhci_halt(xhci);
-	xhci_reset(xhci);
+	xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	xhci_mem_cleanup(xhci);
 	return -ENOMEM;
 }
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -76,7 +76,7 @@ static bool td_on_ring(struct xhci_td *t
  * handshake done).  There are two failure modes:  "usec" have passed (major
  * hardware flakeout), or the register reads as all-ones (hardware removed).
  */
-int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, int usec)
+int xhci_handshake(void __iomem *ptr, u32 mask, u32 done, u64 timeout_us)
 {
 	u32	result;
 	int	ret;
@@ -84,7 +84,7 @@ int xhci_handshake(void __iomem *ptr, u3
 	ret = readl_poll_timeout_atomic(ptr, result,
 					(result & mask) == done ||
 					result == U32_MAX,
-					1, usec);
+					1, timeout_us);
 	if (result == U32_MAX)		/* card removed */
 		return -ENODEV;
 
@@ -173,7 +173,7 @@ int xhci_start(struct xhci_hcd *xhci)
  * Transactions will be terminated immediately, and operational registers
  * will be set to their defaults.
  */
-int xhci_reset(struct xhci_hcd *xhci)
+int xhci_reset(struct xhci_hcd *xhci, u64 timeout_us)
 {
 	u32 command;
 	u32 state;
@@ -206,8 +206,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	if (xhci->quirks & XHCI_INTEL_HOST)
 		udelay(1000);
 
-	ret = xhci_handshake(&xhci->op_regs->command,
-			CMD_RESET, 0, 10 * 1000 * 1000);
+	ret = xhci_handshake(&xhci->op_regs->command, CMD_RESET, 0, timeout_us);
 	if (ret)
 		return ret;
 
@@ -220,8 +219,7 @@ int xhci_reset(struct xhci_hcd *xhci)
 	 * xHCI cannot write to any doorbells or operational registers other
 	 * than status until the "Controller Not Ready" flag is cleared.
 	 */
-	ret = xhci_handshake(&xhci->op_regs->status,
-			STS_CNR, 0, 10 * 1000 * 1000);
+	ret = xhci_handshake(&xhci->op_regs->status, STS_CNR, 0, timeout_us);
 
 	for (i = 0; i < 2; i++) {
 		xhci->bus_state[i].port_c_suspend = 0;
@@ -675,7 +673,7 @@ static void xhci_stop(struct usb_hcd *hc
 	xhci->xhc_state |= XHCI_STATE_HALTED;
 	xhci->cmd_ring_state = CMD_RING_STATE_STOPPED;
 	xhci_halt(xhci);
-	xhci_reset(xhci);
+	xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
@@ -739,7 +737,7 @@ void xhci_shutdown(struct usb_hcd *hcd)
 	xhci_halt(xhci);
 	/* Workaround for spurious wakeups at shutdown with HSW */
 	if (xhci->quirks & XHCI_SPURIOUS_WAKEUP)
-		xhci_reset(xhci);
+		xhci_reset(xhci, XHCI_RESET_SHORT_USEC);
 	spin_unlock_irq(&xhci->lock);
 
 	xhci_cleanup_msix(xhci);
@@ -1111,7 +1109,7 @@ int xhci_resume(struct xhci_hcd *xhci, b
 
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
-		retval = xhci_reset(xhci);
+		retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 		spin_unlock_irq(&xhci->lock);
 		if (retval)
 			return retval;
@@ -4990,7 +4988,7 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 
 	xhci_dbg(xhci, "Resetting HCD\n");
 	/* Reset the internal HC memory state and registers. */
-	retval = xhci_reset(xhci);
+	retval = xhci_reset(xhci, XHCI_RESET_LONG_USEC);
 	if (retval)
 		return retval;
 	xhci_dbg(xhci, "Reset complete\n");
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -236,6 +236,9 @@ struct xhci_op_regs {
 #define CMD_ETE		(1 << 14)
 /* bits 15:31 are reserved (and should be preserved on writes). */
 
+#define XHCI_RESET_LONG_USEC		(10 * 1000 * 1000)
+#define XHCI_RESET_SHORT_USEC		(250 * 1000)
+
 /* IMAN - Interrupt Management Register */
 #define IMAN_IE		(1 << 1)
 #define IMAN_IP		(1 << 0)
@@ -2016,11 +2019,11 @@ void xhci_free_command(struct xhci_hcd *
 
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


