Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B71955C85F
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbiF0IUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 04:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiF0IUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 04:20:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36267C76
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 01:20:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C991E61004
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 08:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DC4C341CB;
        Mon, 27 Jun 2022 08:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656318006;
        bh=0UMzQymF+fUIQ3gDpoQO5bHoP88TVOfjmW47oxbYMNo=;
        h=Subject:To:Cc:From:Date:From;
        b=a002rF6DJbEieTZMLUlGPLvd4MYqaQoaDftr8i0rGlpj9QfuCHWJoHI+m52rTmavz
         Sbo7hPOwpI1Ob61Ax7t+DjBswsENjrArJcmI4ZTPkOkJ5D5fsZkUhEgVtb3vloB/uQ
         4rpo0aGUGOkf5+MRSDn8Vo6i02q/LLO0nF2YsttE=
Subject: FAILED: patch "[PATCH] xhci: Keep interrupt disabled in initialization until host is" failed to apply to 5.4-stable tree
To:     xy521521@gmail.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, xiehongyu1@kylinos.cn
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 10:19:47 +0200
Message-ID: <165631798713649@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a808925075fb750804a60ff0710614466c396db4 Mon Sep 17 00:00:00 2001
From: Hongyu Xie <xy521521@gmail.com>
Date: Thu, 23 Jun 2022 14:19:42 +0300
Subject: [PATCH] xhci: Keep interrupt disabled in initialization until host is
 running.

irq is disabled in xhci_quiesce(called by xhci_halt, with bit:2 cleared
in USBCMD register), but xhci_run(called by usb_add_hcd) re-enable it.
It's possible that you will receive thousands of interrupt requests
after initialization for 2.0 roothub. And you will get a lot of
warning like, "xHCI dying, ignoring interrupt. Shouldn't IRQs be
disabled?". This amount of interrupt requests will cause the entire
system to freeze.
This problem was first found on a device with ASM2142 host controller
on it.

[tidy up old code while moving it, reword header -Mathias]

Cc: stable@kernel.org
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220623111945.1557702-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 9ac56e9ffc64..cb99bed5f755 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -611,15 +611,37 @@ static int xhci_init(struct usb_hcd *hcd)
 
 static int xhci_run_finished(struct xhci_hcd *xhci)
 {
+	unsigned long	flags;
+	u32		temp;
+
+	/*
+	 * Enable interrupts before starting the host (xhci 4.2 and 5.5.2).
+	 * Protect the short window before host is running with a lock
+	 */
+	spin_lock_irqsave(&xhci->lock, flags);
+
+	xhci_dbg_trace(xhci, trace_xhci_dbg_init, "Enable interrupts");
+	temp = readl(&xhci->op_regs->command);
+	temp |= (CMD_EIE);
+	writel(temp, &xhci->op_regs->command);
+
+	xhci_dbg_trace(xhci, trace_xhci_dbg_init, "Enable primary interrupter");
+	temp = readl(&xhci->ir_set->irq_pending);
+	writel(ER_IRQ_ENABLE(temp), &xhci->ir_set->irq_pending);
+
 	if (xhci_start(xhci)) {
 		xhci_halt(xhci);
+		spin_unlock_irqrestore(&xhci->lock, flags);
 		return -ENODEV;
 	}
+
 	xhci->cmd_ring_state = CMD_RING_STATE_RUNNING;
 
 	if (xhci->quirks & XHCI_NEC_HOST)
 		xhci_ring_cmd_db(xhci);
 
+	spin_unlock_irqrestore(&xhci->lock, flags);
+
 	return 0;
 }
 
@@ -668,19 +690,6 @@ int xhci_run(struct usb_hcd *hcd)
 	temp |= (xhci->imod_interval / 250) & ER_IRQ_INTERVAL_MASK;
 	writel(temp, &xhci->ir_set->irq_control);
 
-	/* Set the HCD state before we enable the irqs */
-	temp = readl(&xhci->op_regs->command);
-	temp |= (CMD_EIE);
-	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
-			"// Enable interrupts, cmd = 0x%x.", temp);
-	writel(temp, &xhci->op_regs->command);
-
-	temp = readl(&xhci->ir_set->irq_pending);
-	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
-			"// Enabling event ring interrupter %p by writing 0x%x to irq_pending",
-			xhci->ir_set, (unsigned int) ER_IRQ_ENABLE(temp));
-	writel(ER_IRQ_ENABLE(temp), &xhci->ir_set->irq_pending);
-
 	if (xhci->quirks & XHCI_NEC_HOST) {
 		struct xhci_command *command;
 

