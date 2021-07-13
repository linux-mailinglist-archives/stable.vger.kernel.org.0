Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BA13C76D5
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 21:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhGMTSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 15:18:39 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43035 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S234364AbhGMTSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 15:18:39 -0400
Received: (qmail 359381 invoked by uid 1000); 13 Jul 2021 15:15:48 -0400
Date:   Tue, 13 Jul 2021 15:15:48 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Laurence Oberman <loberman@redhat.com>
Cc:     linux-usb@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        stable@vger.kernel.org, emilne@redhat.com, djeffery@redhat.com,
        apanagio@redhat.com, torez@redhat.com
Subject: Re: [PATCH] usb: hcd: Revert
 306c54d0edb6ba94d39877524dddebaad7770cf2: Try MSI interrupts on PCI devices
Message-ID: <20210713191548.GD355405@rowland.harvard.edu>
References: <1626202242-14984-1-git-send-email-loberman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626202242-14984-1-git-send-email-loberman@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 02:50:42PM -0400, Laurence Oberman wrote:
> Customers have been reporting that the I/O is radically being
> slowed down to HPE virtual USB ILO served DVD images during installation.
> 
> Lots of investigation by the Red Hat lab has found that the issue is 
> because MSI edge interrupts do not work properly for these 
> ILO USB devices.
> We start fast and then drop to polling mode and its unusable.
> 
> The issue exists currently upstream on 5.13 as tested by Red Hat, 
> and reverting the mentioned patch corrects this upstream.
> 
> David Jeffery has this explanation:
> 
> The problem with the patch turning on MSI appears to be that the ehci 
> driver (and possibly other usb controller types too) wasn't written to
> support edge-triggered interrupts.
> The ehci_irq routine appears to be written in such a way that it will 
> be racy with multiple interrupt source bits.
> With a level-triggered interrupt, it gets called another time and cleans 
> up other interrupt sources.
> But with MSI edge, the interrupt state staying high results in no 
> new interrupt and ehci has to run based on polling.
> 
> static irqreturn_t ehci_irq (struct usb_hcd *hcd)
> {
> ...
>         status = ehci_readl(ehci, &ehci->regs->status);
> 
>         /* e.g. cardbus physical eject */
>         if (status == ~(u32) 0) {
>                 ehci_dbg (ehci, "device removed\n");
>                 goto dead;
>         }
> 
>         /*
>          * We don't use STS_FLR, but some controllers don't like it to
>          * remain on, so mask it out along with the other status bits.
>          */
>         masked_status = status & (INTR_MASK | STS_FLR);
> 
>         /* Shared IRQ? */
>         if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
>                 spin_unlock_irqrestore(&ehci->lock, flags);
>                 return IRQ_NONE;
>         }
> 
>         /* clear (just) interrupts */
>         ehci_writel(ehci, masked_status, &ehci->regs->status);
> ...
> 
> ehci_irq() reads the interrupt status register and then writes the active 
> interrupt-related bits back out to ack the interrupt cause.
> But with an edge interrupt, this is racy as another source of interrupt 
> could be raised by ehci between the read and the write reaching the 
> hardware. 
> e.g.  If STS_IAA was set during the initial read, but some other bit like 
> STS_INT gets raised by the hardware between the read and the write to the 
> interrupt status register, the interrupt signal state won't drop.
> The interrupt state says high, and since it is now edged triggered with 
> MSI, no new invocation of the interrupt handler gets triggered.

Wouldn't it be better to change these other PCI drivers by adding 
proper MSI support?  I don't know what would be involved, but 
presumably it wouldn't be very hard.  (Just run the handler in a loop 
until all the interrupt status bits are off?)

Alan Stern
