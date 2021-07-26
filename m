Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ADC3D6136
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhGZPaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231362AbhGZP2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:28:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9419E60FE3;
        Mon, 26 Jul 2021 16:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315610;
        bh=J4AhUA7x+vqG2sywfhNOO/+6xAQSl/Bi+CKhBLBFGoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubd/LJ+bNkAOlPV0b8cj6uCdvq0E+1xZhG331VvPV2Aiq68d5c/kav2O5b0Nl+bzS
         wBiJtsdklOJ/zYOd6FyBQJ09x3ME2oINV9BVkySPvsfHzPqLRs8wepQjngZJQ5SyBp
         Dod4HxVU+fCpsuivcb2P7U3uDt2nbqFDnGEabDOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurence Oberman <loberman@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Jeffery <djeffery@redhat.com>
Subject: [PATCH 5.10 164/167] usb: ehci: Prevent missed ehci interrupts with edge-triggered MSI
Date:   Mon, 26 Jul 2021 17:39:57 +0200
Message-Id: <20210726153844.911987832@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Jeffery <djeffery@redhat.com>

commit 0b60557230adfdeb8164e0b342ac9cd469a75759 upstream.

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
 drivers/usb/host/ehci-hcd.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -703,7 +703,8 @@ EXPORT_SYMBOL_GPL(ehci_setup);
 static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 {
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
-	u32			status, masked_status, pcd_status = 0, cmd;
+	u32			status, current_status, masked_status, pcd_status = 0;
+	u32			cmd;
 	int			bh;
 	unsigned long		flags;
 
@@ -715,19 +716,22 @@ static irqreturn_t ehci_irq (struct usb_
 	 */
 	spin_lock_irqsave(&ehci->lock, flags);
 
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
@@ -737,6 +741,12 @@ static irqreturn_t ehci_irq (struct usb_
 
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
 


