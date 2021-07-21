Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B713D098A
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhGUGep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 02:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235289AbhGUGeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 02:34:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67EDE60232;
        Wed, 21 Jul 2021 07:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626851678;
        bh=hNYnGyH/70LIFsCnUhol5Uj21a7uHQc8GU7qx6Uo7ss=;
        h=Subject:To:From:Date:From;
        b=ls+EVs5GbCw5Z8IqbLjsVvswSnJwi2yGglAEE+g2SDfF05Sn1X5+hjqyeLjvXusMH
         Hnr6pDsuUWa0rga8p/upq947tvP5teUToEjppHKwlJ+ghHsiUuVlHC1tYdoYKJZ/NG
         GLUdbqACSvL/UU1kkBczgrV9tRPvl8rPWUFd66QQ=
Subject: patch "usb: ehci: Prevent missed ehci interrupts with edge-triggered MSI" added to usb-linus
To:     djeffery@redhat.com, andriy.shevchenko@linux.intel.com,
        gregkh@linuxfoundation.org, loberman@redhat.com,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:14:36 +0200
Message-ID: <16268516763148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: ehci: Prevent missed ehci interrupts with edge-triggered MSI

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0b60557230adfdeb8164e0b342ac9cd469a75759 Mon Sep 17 00:00:00 2001
From: David Jeffery <djeffery@redhat.com>
Date: Thu, 15 Jul 2021 17:37:44 -0400
Subject: usb: ehci: Prevent missed ehci interrupts with edge-triggered MSI

When MSI is used by the ehci-hcd driver, it can cause lost interrupts which
results in EHCI only continuing to work due to a polling fallback. But the
reliance of polling drastically reduces performance of any I/O through EHCI.

Interrupts are lost as the EHCI interrupt handler does not safely handle
edge-triggered interrupts. It fails to ensure all interrupt status bits are
cleared, which works with level-triggered interrupts but not the
edge-triggered interrupts typical from using MSI.

To fix this problem, check if the driver may have raced with the hardware
setting additional interrupt status bits and clear status until it is in a
stable state.

Fixes: 306c54d0edb6 ("usb: hcd: Try MSI interrupts on PCI devices")
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Link: https://lore.kernel.org/r/20210715213744.GA44506@redhat
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-hcd.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 36f5bf6a0752..10b0365f3439 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -703,24 +703,28 @@ EXPORT_SYMBOL_GPL(ehci_setup);
 static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
-	u32			status, masked_status, pcd_status = 0, cmd;
+	u32			status, current_status, masked_status, pcd_status = 0;
+	u32			cmd;
 	int			bh;
 
 	spin_lock(&ehci->lock);
 
-	status = ehci_readl(ehci, &ehci->regs->status);
+	status = 0;
+	current_status = ehci_readl(ehci, &ehci->regs->status);
+restart:
 
 	/* e.g. cardbus physical eject */
-	if (status == ~(u32) 0) {
+	if (current_status == ~(u32) 0) {
 		ehci_dbg (ehci, "device removed\n");
 		goto dead;
 	}
+	status |= current_status;
 
 	/*
 	 * We don't use STS_FLR, but some controllers don't like it to
 	 * remain on, so mask it out along with the other status bits.
 	 */
-	masked_status = status & (INTR_MASK | STS_FLR);
+	masked_status = current_status & (INTR_MASK | STS_FLR);
 
 	/* Shared IRQ? */
 	if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
@@ -730,6 +734,12 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 
 	/* clear (just) interrupts */
 	ehci_writel(ehci, masked_status, &ehci->regs->status);
+
+	/* For edge interrupts, don't race with an interrupt bit being raised */
+	current_status = ehci_readl(ehci, &ehci->regs->status);
+	if (current_status & INTR_MASK)
+		goto restart;
+
 	cmd = ehci_readl(ehci, &ehci->regs->command);
 	bh = 0;
 
-- 
2.32.0


