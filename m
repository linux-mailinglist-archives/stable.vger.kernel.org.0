Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E02AA153F4C
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 08:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgBFHkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 02:40:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50758 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgBFHkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 02:40:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4SHnacpU3z6rwPbuwxqPp87/czkd+vfQfsodqyoPOpg=; b=gS8qgYxMwBK5Z0IaUgyOyKsHAn
        um7U5jjT50W7q1nlEAWR0gIhFWzNU9koaXmi+vFO1HcJB2DXNZRixRPG/MEpxxDYGeqAqdU2CqsHr
        MDqqDZ3MnFCHHYBTfxK8dgi9MaadoF7T98dpXy7SyagxFbnivmgHnoadjN3Ek/+zrmC3c64TjMuwg
        dmVNNuirC2KPewcM1nwm+F3yUltGkCNsMWSJK27EgmHHpmJfbJdEGp2fgQ81Evc24z6DQUrBi5RNV
        C/dTrMp1TkSqwCjb4GXfQlBdlBLgNetwGyQfALmrFNFS4rtB5H5tTof9PKN+O2CBnCpoa1tDkgYHn
        CY/2/zlw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izbld-0001A6-G5; Thu, 06 Feb 2020 07:40:05 +0000
Date:   Wed, 5 Feb 2020 23:40:05 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     John Stultz <john.stultz@linaro.org>
Cc:     Felipe Balbi <balbi@kernel.org>, "Yang, Fei" <fei.yang@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when using
 adb over f_fs
Message-ID: <20200206074005.GA28365@infradead.org>
References: <20200122222645.38805-1-john.stultz@linaro.org>
 <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com>
 <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com>
 <87o8uu3wqd.fsf@kernel.org>
 <02E7334B1630744CBDC55DA8586225837F9EE335@ORSMSX102.amr.corp.intel.com>
 <87lfpy3w1g.fsf@kernel.org>
 <CALAqxLUQ0ciJTLrmEAu9WKCJHAbpY9szuVm=+VapN2QWWGnNjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUQ0ciJTLrmEAu9WKCJHAbpY9szuVm=+VapN2QWWGnNjA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 01:03:51PM -0800, John Stultz wrote:
> On Thu, Jan 23, 2020 at 9:46 AM Felipe Balbi <balbi@kernel.org> wrote:
> > >> I'm pretty sure this should be solved at the DMA API level, just want to confirm.
> > >
> > > I have sent you the tracepoints long time ago. Also my analysis of the
> > > problem (BTW, I don't think the tracepoints helped much). It's
> > > basically a logic problem in function dwc3_gadget_ep_reclaim_trb_sg().
> >
> > AFAICT, this is caused by DMA API merging pages together when map an
> > sglist for DMA. While doing that, it does *not* move the SG_END flag
> > which sg_is_last() checks.
> >
> > I consider that an overlook on the DMA API, wouldn't you? Why should DMA
> > API users care if pages were merged or not while mapping the sglist? We
> > have for_each_sg() and sg_is_last() for a reason.
> >
> 
> >From an initial look, I agree this is pretty confusing.   dma_map_sg()
> can coalesce entries in the sg list, modifying the sg entires
> themselves, however, in doing so it doesn't modify the number of
> entries in the sglist (nor the end state bit).  That's pretty subtle!

dma_map_sg only coalesces the dma address.  The page, offset and len
members are immutable.

The problem is really the design of the scatterlist structure - it
combines immutable input parameters (page, offset, len) and output
parameters (dma_addr, dma_len) in one data structure, and then needs
different accessors depending on which information you care about.
The end marker only works for the "CPU" view.

The right fix is top stop using struct scatterlist, but that is going to
be larger and painful change.  At least for block layer stuff I plan to
incrementally do that, though.

> So I'm not sure that sg_is_last() is really valid for iterating on
> mapped sg lists.
> 
> Should it be? Probably (at least with my unfamiliar eyes), but
> sg_is_last() has been around for almost as long coexisting with this
> behavioral quirk, so I'm also not sure this is the best hill for the
> dwc3 driver to die on. :)

No, it shoudn't.  dma_map_sg returns the number of mapped segments,
and the callers need to remember that.

> 
> The fix here:
>   https://lore.kernel.org/lkml/20200122222645.38805-3-john.stultz@linaro.org/
> Or maybe the slightly cleaner varient here:
>   https://git.linaro.org/people/john.stultz/android-dev.git/commit/?h=dev/db845c-mainline-WIP&id=61a5816aa71ec719e77df9f2260dbbf6bcec7c99
> seems like it would correctly address things following the
> documentation and avoid the failures we're seeing.

The first version is the corret one.  sg_is_last has no meaning for the
"DMA" view of the scatterlist.
