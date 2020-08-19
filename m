Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB5E2499AE
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 11:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgHSJy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 05:54:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726759AbgHSJy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 05:54:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 213C220658;
        Wed, 19 Aug 2020 09:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597830864;
        bh=8EY+IBQDDCv5P9UuDuo2rQxQv71SvqG067tuW06wzqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EC1hqzItQZbCZIxxM+eqNtFB+HuDbvH1LbxDOiZgZ67t3+Ss8TIYrLKHKmGIGmwAJ
         p3xM7ezi0YDTsOLgXLpEMl6WkLP8CNn60aopaIkt+t4oNOMcPMRdG7O2b/xfFIEr/8
         yCDI0ZAgSeeSZMTDvINfVapgZbe2LDdF6izBUwk4=
Date:   Wed, 19 Aug 2020 11:54:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 5.4] genirq/affinity: Make affinity setting if activated
 opt-in
Message-ID: <20200819095446.GA2558675@kroah.com>
References: <20200810202503.22317-1-fllinden@amazon.com>
 <20200810202740.GA22367@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810202740.GA22367@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 08:27:40PM +0000, Frank van der Linden wrote:
> On Mon, Aug 10, 2020 at 08:25:03PM +0000, Frank van der Linden wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > commit f0c7baca180046824e07fc5f1326e83a8fd150c7 upstream.
> > 
> > John reported that on a RK3288 system the perf per CPU interrupts are all
> > affine to CPU0 and provided the analysis:
> > 
> >  "It looks like what happens is that because the interrupts are not per-CPU
> >   in the hardware, armpmu_request_irq() calls irq_force_affinity() while
> >   the interrupt is deactivated and then request_irq() with IRQF_PERCPU |
> >   IRQF_NOBALANCING.
> > 
> >   Now when irq_startup() runs with IRQ_STARTUP_NORMAL, it calls
> >   irq_setup_affinity() which returns early because IRQF_PERCPU and
> >   IRQF_NOBALANCING are set, leaving the interrupt on its original CPU."
> > 
> > This was broken by the recent commit which blocked interrupt affinity
> > setting in hardware before activation of the interrupt. While this works in
> > general, it does not work for this particular case. As contrary to the
> > initial analysis not all interrupt chip drivers implement an activate
> > callback, the safe cure is to make the deferred interrupt affinity setting
> > at activation time opt-in.
> > 
> > Implement the necessary core logic and make the two irqchip implementations
> > for which this is required opt-in. In hindsight this would have been the
> > right thing to do, but ...
> 
> I backported this one since it had a minor conflict, so while the main
> one was Cc-ed to stable@, it didn't get picked up.

I didn't have the chance to get to it in the long list yet :)

I've done so now, and this matches my backport.  I've also backported it
to 4.19.y, and that seems to match this almost identically as well (one
minor difference).

thanks,

greg k-h
