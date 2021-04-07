Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AD6356945
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 12:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbhDGKSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 06:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236446AbhDGKSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 06:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08EA66113B;
        Wed,  7 Apr 2021 10:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617790707;
        bh=SOWVzp8gCkmkm/U3hNAcN0Nkcqi9dh5you+xfuOLuV0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LNRGPuD2VGGLL3oGZoIZmUOqEoz+sDAJ9ODIT+YV+ViQo/sTh/uUY3GZsnOtWlpA8
         1Gf1bnLf+C/TWicuiLCGNptQEYf3m6q5kFkQkr2YKYDoZvyL9JY9Ktiiw9+k+bqsiY
         1RhuBQYANFyb75QygaER+pL2lBOwAz8T5kAHdpAQ=
Date:   Wed, 7 Apr 2021 12:18:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/35] 4.9.265-rc1 review
Message-ID: <YG2G8DzlWaY7mgOb@kroah.com>
References: <20210405085018.871387942@linuxfoundation.org>
 <20210405175629.GB93485@roeck-us.net>
 <20210405235155.GA75187@roeck-us.net>
 <20210406022200.GA20578@roeck-us.net>
 <20210406023602.GB20578@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406023602.GB20578@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 07:36:02PM -0700, Guenter Roeck wrote:
> On Mon, Apr 05, 2021 at 07:22:00PM -0700, Guenter Roeck wrote:
> > On Mon, Apr 05, 2021 at 04:51:55PM -0700, Guenter Roeck wrote:
> > > On Mon, Apr 05, 2021 at 10:56:29AM -0700, Guenter Roeck wrote:
> > > > On Mon, Apr 05, 2021 at 10:53:35AM +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 4.9.265 release.
> > > > > There are 35 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > 
> > > > Build results:
> > > > 	total: 163 pass: 163 fail: 0
> > > > Qemu test results:
> > > > 	total: 383 pass: 382 fail: 1
> > > > Failed tests:
> > > > 	parisc:generic-32bit_defconfig:smp:net,pcnet:scsi[53C895A]:rootfs
> > > > 
> > > > In the failing test, the network interfcace instantiates but fails to get
> > > > an IP address. This is not a new problem but a new test. For some reason
> > > > it only happens with this specific network interface, this specific SCSI
> > > > controller, and with v4.9.y. No reason for concern; I'll try to track down
> > > > what is going on.
> > > > 
> > > 
> > > Interesting. The problem affects all kernels up to and including
> > > v4.19.y. Unlike I thought initially, the problem is not associated
> > > with the SCSI controller (that was coincidental) but with pcnet
> > > Ethernet interfaces. It has been fixed in the upstream kernel with
> > > commit 518a2f1925c3 ("dma-mapping: zero memory returned from
> > > dma_alloc_*"). This patch does not apply cleanly to any of the
> > > affected kernels. I backported part of it to v4.19.y and v4.9.y
> > > and confirmed that it fixes the problem in those branches.
> > > 
> > > Question is what we should do: try to backport 518a2f1925c3 to v4.19.y
> > > and earlier, or stop testing against this specific problem.
> > > 
> > 
> > Another update: The following code change fixes the problem as well.
> > Commit 518a2f1925c3 fixes it only as side effect since it clears
> > all DMA buffers.
> > 
> > diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
> > index c22bf52d3320..7a25ec8390e4 100644
> > --- a/drivers/net/ethernet/amd/pcnet32.c
> > +++ b/drivers/net/ethernet/amd/pcnet32.c
> > @@ -1967,7 +1967,7 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
> >                 return -ENOMEM;
> >         }
> > 
> > -       lp->rx_ring = pci_alloc_consistent(lp->pci_dev,
> > +       lp->rx_ring = pci_zalloc_consistent(lp->pci_dev,
> >                                            sizeof(struct pcnet32_rx_head) *
> >                                            lp->rx_ring_size,
> >                                            &lp->rx_ring_dma_addr);
> > 
> > I'll submit a patch implementing that; we'll see how it goes.
> 
> Sigh. That doesn't work; upstream uses dma_alloc_coherent().
> We could apply the patch making the switch, but dma_alloc_coherent()
> doesn't clear memory in older kernels (we are back to commit 518a2f1925c3
> which is introducing that). I'll just drop pcnet tests for kernels older
> than v5.4.

If the patch above fixes this in the older kernel versions, I'm all for
taking it if needed.

thanks,

greg k-h
