Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C650F1E8718
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 21:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgE2TAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 15:00:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55477 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725865AbgE2TAc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 15:00:32 -0400
Received: (qmail 4157 invoked by uid 1000); 29 May 2020 15:00:31 -0400
Date:   Fri, 29 May 2020 15:00:31 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Doug Anderson <dianders@chromium.org>
Cc:     Frank Mori Hess <fmh6jj@gmail.com>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc2: Fix shutdown callback in platform
Message-ID: <20200529190031.GA2271@rowland.harvard.edu>
References: <1d3bae1b3048f5d6e19f7ef569dd77e9e160a026.1590753016.git.hminas@synopsys.com>
 <CAD=FV=W1x_HJNCYMUb11QNA8yGs0heEiZzHZdeMPzFaRHaTOsA@mail.gmail.com>
 <0f6b1580-41d8-b7e7-206b-64cda87abfd5@synopsys.com>
 <CAD=FV=UCMqyX92o9m7H40E3sHzAFieHSu3TUY953VqNb-vuPPg@mail.gmail.com>
 <CAJz5OpfDnHfGf=dLbc0hTtaz-CERsQyaBNeqDiRz7u4jMywNow@mail.gmail.com>
 <CAD=FV=URUeE55xyL3iB5GmS7BRoDG2ey3UE4qSwwc7XZHR0c-Q@mail.gmail.com>
 <CAJz5OpdMDumfdYC+aj0N20p4qVEkEkHhNY3uKest6RSpPtrDWQ@mail.gmail.com>
 <CAD=FV=XsLA3w2QPcNF3-mgZbZoGsz4kg_QvHcoZV=XTVDYhnSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=XsLA3w2QPcNF3-mgZbZoGsz4kg_QvHcoZV=XTVDYhnSg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 29, 2020 at 11:45:53AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Fri, May 29, 2020 at 11:21 AM Frank Mori Hess <fmh6jj@gmail.com> wrote:
> >
> > On Fri, May 29, 2020 at 1:53 PM Doug Anderson <dianders@chromium.org> wrote:
> > > >
> > > > I don't get it.  A hypothetical machine could have literally anything
> > > > sharing the IRQ line, right?
> > >
> > > It's not a real physical line, though?  I don't think it's common to
> > > have a shared interrupt between different IP blocks in a given SoC.
> > > Even if it existed, all the drivers should disable their interrupts?
> >
> > I don't know, it's a hypothetical machine so it can be whatever you
> > want.  The driver requests shared irqs, if it doesn't actually support
> > irq sharing, it shouldn't request them.
> 
> I guess?  As I understood it drivers have to be very carefully coded
> up to support sharing their IRQ with someone else and I'm not
> convinced dwc2 does that anyway.  Certainly it doesn't hurt to keep
> dwc2 clean, but until I see someone that's actually sharing dwc2's
> interrupt and I can actually see an example I'm not sure I'm going to
> spend too much time thinking about it.

This is silly.  If the driver says it supports shared IRQs, then it 
should actually support them.

> > > > Anyways, my screaming interrupt occurs after a a new kernel has been
> > > > booted with kexec.  In this case, it doesn't matter if the old kernel
> > > > called disable_irq or not.  As soon as the new kernel re-enables the
> > > > interrupt line, the kernel immediately disables it again with a
> > > > backtrace due to the unhandled screaming interrupt.  That's why the
> > > > dwc2 hardware needs to have its interrupts turned off when the old
> > > > kernel is shutdown.
> > >
> > > Isn't that a bug with your new kernel?  I've seen plenty of bugs where
> > > drivers enable their interrupt before their interrupt handler is set
> > > to handle it.  You never know what state the bootloader (or previous
> > > kernel) might have left things in and if an interrupt was pending it
> > > shouldn't kill you.
> >
> > It wouldn't hurt to add disabling of the dwc2 irq early in dwc2
> > initialization,
> 
> More than it not hurting, I'd consider it a bug in the driver (and a
> much more serious one than shutdown not disabling the interrupt).

Normally the first thing a driver would do is reset the hardware, and 
that reset should disable any interrupt source.

> > but why leave the irq screaming after shutdown?
> 
> Sure.  So I guess the answer is to just do both disable the interrupt
> and make sure that the interrupt handler has finished.
> 
> dwc2_disable_global_interrupts(hsotg);
> disable_irq(hsotg->irq);

Drivers with shared IRQs don't call disable_irq(); they call 
synchronize_irq().  It will do what you want (wait until all running 
handlers have returned).

Alan Stern
