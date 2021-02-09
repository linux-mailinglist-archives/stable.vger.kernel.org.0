Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771403149EF
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 09:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhBIIFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 03:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhBIIFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 03:05:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE0D664E50;
        Tue,  9 Feb 2021 08:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612857872;
        bh=zPK+5MZsx1tSvH2HRp1p3HtPtCmnOHY9jiF0A95/QwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Avm+GfAVXF4EksYujMA/CDdtYumq9mFdLJEs2zSEghuaaGAEeAmAE8ALnUIuCt+aM
         zb7IZIEoOJxxxT8U7DM62ZovMxPGZGcVVPmz0oBWmqNTKEf33vg9GEFOaSVsNBjQo+
         fNJYB/4IPVoWeLGW/uCJ6r0XhQ7Q6Qyb82RAit68=
Date:   Tue, 9 Feb 2021 09:04:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     obayashi.yoshimasa@socionext.com, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: DMA direct mapping fix for 5.4 and earlier stable branches
Message-ID: <YCJCDZGa1Dhqv6Ni@kroah.com>
References: <CAFA6WYNazCmYN20irLdNV+2vcv5dqR+grvaY-FA7q2WOBMs__g@mail.gmail.com>
 <YCIym62vHfbG+dWf@kroah.com>
 <CAFA6WYM+xJ0YDKenWFPMHrTz4gLWatnog84wyk31Xy2dTiT2RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYM+xJ0YDKenWFPMHrTz4gLWatnog84wyk31Xy2dTiT2RA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 01:28:47PM +0530, Sumit Garg wrote:
> Thanks Greg for your response.
> 
> On Tue, 9 Feb 2021 at 12:28, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Feb 09, 2021 at 11:39:25AM +0530, Sumit Garg wrote:
> > > Hi Christoph, Greg,
> > >
> > > Currently we are observing an incorrect address translation
> > > corresponding to DMA direct mapping methods on 5.4 stable kernel while
> > > sharing dmabuf from one device to another where both devices have
> > > their own coherent DMA memory pools.
> >
> > What devices have this problem?
> 
> The problem is seen with V4L2 device drivers which are currently under
> development for UniPhier PXs3 Reference Board from Socionext [1].

Ok, so it's not even a driver in the 5.4 kernel today, so there's
nothing I can do here as there is no regression of the existing source
tree.

> Following is brief description of the test framework:
> 
> The issue is observed while trying to construct a Gstreamer pipeline
> leveraging hardware video converter engine (VPE device) and hardware
> video encode/decode engine (CODEC device) where we use dmabuf
> framework for Zero-Copy.
> 
> Example GStreamer pipeline is:
> gst-launch-1.0 -v -e videotestsrc \
> > ! video/x-raw, width=480, height=270, format=NV15 \
> > ! v4l2convert device=/dev/vpe0 capture-io-mode=dmabuf-import \
> > ! video/x-raw, width=480, height=270, format=NV12 \
> > ! v4l2h265enc device=/dev/codec0 output-io-mode=dmabuf \
> > ! video/x-h265, format=byte-stream, width=480, height=270 \
> > ! filesink location=out.hevc
> 
> Using GStreamer's V4L2 plugin,
> - v4l2convert controls VPE driver,
> - v4l2h265enc controls CODEC driver.
> 
> In the above pipeline, VPE driver imports CODEC driver's DMABUF for Zero-Copy.
> 
> [1] arch/arm64/boot/dts/socionext/uniphier-pxs3-ref.dts
> 
> > And why can't then just use 5.10 to
> > solve this issue as that problem has always been present for them,
> > right?
> 
> As the drivers are currently under development and Socionext has
> chosen 5.4 stable kernel for their development. So I will let
> Obayashi-san answer this if it's possible for them to migrate to 5.10
> instead?

Why pick a kernel that doesn not support the features they require?
That seems very odd and unwise.

> BTW, this problem belongs to the common code, so others may experience
> this issue as well.

Then they should move to 5.10 or newer as this just doesn't work on
older kernels, right?

> > > I am able to root cause this issue which is caused by incorrect virt
> > > to phys translation for addresses belonging to vmalloc space using
> > > virt_to_page(). But while looking at the mainline kernel, this patch
> > > [1] changes address translation from virt->to->phys to dma->to->phys
> > > which fixes the issue observed on 5.4 stable kernel as well (minimal
> > > fix [2]).
> > >
> > > So I would like to seek your suggestion for backport to stable kernels
> > > (5.4 or earlier) as to whether we should backport the complete
> > > mainline commit [1] or we should just apply the minimal fix [2]?
> >
> > Whenever you try to create a "minimal" fix, 90% of the time it is wrong
> > and does not work and I end up having to deal with the mess.
> 
> I agree with your concerns for having to apply a non-mainline commit
> onto a stable kernel.
> 
> >  What
> > prevents you from doing the real thing here?  Are the patches to big?
> >
> 
> IMHO, yes the mainline patch is big enough to touch multiple
> architectures. But if that's the only way preferred then I can
> backport the mainline patch instead.
> 
> > And again, why not just use 5.10 for this hardware?  What hardware is
> > it?
> >
> 
> Please see my response above.

If a feature in the kernel was not present on older kernels, trying to
shoe-horn it into them is not wise at all.  You pick a kernel version
to reflect the features/options that you require, and it sounds like 5.4
just will not work for them, so to stick with that would be quite
foolish.

Just move to 5.10, much simpler!

thanks,

greg k-h
