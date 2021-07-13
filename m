Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895A33C7801
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 22:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhGMUdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 16:33:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:1574 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhGMUdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 16:33:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="189922304"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="189922304"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 13:30:54 -0700
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="413069463"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 13:30:52 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1m3P3F-00D4lX-AZ; Tue, 13 Jul 2021 23:30:45 +0300
Date:   Tue, 13 Jul 2021 23:30:45 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Laurence Oberman <loberman@redhat.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, emilne@redhat.com, djeffery@redhat.com,
        apanagio@redhat.com, torez@redhat.com
Subject: Re: [PATCH] usb: hcd: Revert
 306c54d0edb6ba94d39877524dddebaad7770cf2: Try MSI interrupts on PCI devices
Message-ID: <YO339bl18pjSABGA@smile.fi.intel.com>
References: <1626202242-14984-1-git-send-email-loberman@redhat.com>
 <20210713191548.GD355405@rowland.harvard.edu>
 <e4cfb11631b00cb45b385be6048d5b39d301f433.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4cfb11631b00cb45b385be6048d5b39d301f433.camel@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 04:05:06PM -0400, Laurence Oberman wrote:
> On Tue, 2021-07-13 at 15:15 -0400, Alan Stern wrote:
> > On Tue, Jul 13, 2021 at 02:50:42PM -0400, Laurence Oberman wrote:
> > > Customers have been reporting that the I/O is radically being
> > > slowed down to HPE virtual USB ILO served DVD images during
> > > installation.

Thanks for the report!

> > > Lots of investigation by the Red Hat lab has found that the issue
> > > is 
> > > because MSI edge interrupts do not work properly for these 
> > > ILO USB devices.
> > > We start fast and then drop to polling mode and its unusable.
> > > 
> > > The issue exists currently upstream on 5.13 as tested by Red Hat, 
> > > and reverting the mentioned patch corrects this upstream.
> > > 
> > > David Jeffery has this explanation:
> > > 
> > > The problem with the patch turning on MSI appears to be that the
> > > ehci 
> > > driver (and possibly other usb controller types too) wasn't written
> > > to
> > > support edge-triggered interrupts.
> > > The ehci_irq routine appears to be written in such a way that it
> > > will 
> > > be racy with multiple interrupt source bits.
> > > With a level-triggered interrupt, it gets called another time and
> > > cleans 
> > > up other interrupt sources.
> > > But with MSI edge, the interrupt state staying high results in no 
> > > new interrupt and ehci has to run based on polling.
> > > 
> > > static irqreturn_t ehci_irq (struct usb_hcd *hcd)
> > > {
> > > ...
> > >         status = ehci_readl(ehci, &ehci->regs->status);
> > > 
> > >         /* e.g. cardbus physical eject */
> > >         if (status == ~(u32) 0) {
> > >                 ehci_dbg (ehci, "device removed\n");
> > >                 goto dead;
> > >         }
> > > 
> > >         /*
> > >          * We don't use STS_FLR, but some controllers don't like it
> > > to
> > >          * remain on, so mask it out along with the other status
> > > bits.
> > >          */
> > >         masked_status = status & (INTR_MASK | STS_FLR);
> > > 
> > >         /* Shared IRQ? */
> > >         if (!masked_status || unlikely(ehci->rh_state ==
> > > EHCI_RH_HALTED)) {
> > >                 spin_unlock_irqrestore(&ehci->lock, flags);
> > >                 return IRQ_NONE;
> > >         }
> > > 
> > >         /* clear (just) interrupts */
> > >         ehci_writel(ehci, masked_status, &ehci->regs->status);
> > > ...
> > > 
> > > ehci_irq() reads the interrupt status register and then writes the
> > > active 
> > > interrupt-related bits back out to ack the interrupt cause.
> > > But with an edge interrupt, this is racy as another source of
> > > interrupt 
> > > could be raised by ehci between the read and the write reaching
> > > the 
> > > hardware. 
> > > e.g.  If STS_IAA was set during the initial read, but some other
> > > bit like 
> > > STS_INT gets raised by the hardware between the read and the write
> > > to the 
> > > interrupt status register, the interrupt signal state won't drop.
> > > The interrupt state says high, and since it is now edged triggered
> > > with 
> > > MSI, no new invocation of the interrupt handler gets triggered.
> > 
> > Wouldn't it be better to change these other PCI drivers by adding 
> > proper MSI support?  I don't know what would be involved, but 
> > presumably it wouldn't be very hard.  (Just run the handler in a
> > loop 
> > until all the interrupt status bits are off?)

My first impression is the same as Alan's. Can we have at least more
information on this?

> Agree with you that is a big hammer approach,  but it's such a key
> piece of the massive number of HPE servers out there and we have many
> affected customers.
> 
> While I did all the test work and discovery etc, I am definitely not a
> USB kernel guy very often, I spend most of my time in storage.
> I will listen for the other replies to see how the folks who know the
> subsystem better than I would want this reolved.

As a quick fix I would suggest to quirk out the current EHCI controllers on
the affected machines rather then drop MSI for all.

It may be done via PCI quirk mechanism. In any case I prefer what Alan says.

-- 
With Best Regards,
Andy Shevchenko


