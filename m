Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C5338949F
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 19:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347659AbhESR01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 13:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242522AbhESR0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 13:26:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2935610A2;
        Wed, 19 May 2021 17:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621445104;
        bh=YlBkuoIMgL2ocfCxSkiFLsPSD2d3mcoBaM8bNM7Kh3c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q2pqsWWyPyDhjgmZ1ESQeKTSUhpdEbyJoaO4K8/BzApogQhuATUyXVsYsc2vNjHIp
         s9hFaBWhGK4tI3/7qpbPW9LTZijD+V/dOUSwen+VBLXclyZZTttS8PE2ZcvaOiJDTc
         1LYKhOTDM4DV86q65OJTYogOShbGTg4aGMOLNSRQ=
Date:   Wed, 19 May 2021 19:25:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marc Orr <marcorr@google.com>
Cc:     Jianxiong Gao <jxgao@google.com>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, sashal@kernel.org
Subject: Re: [PATCH 5.4 v2 0/9] preserve DMA offsets when using swiotlb
Message-ID: <YKVJ7vjUmIUAmdC0@kroah.com>
References: <20210518221818.2963918-1-jxgao@google.com>
 <YKTIJsD2KmiV3mIb@kroah.com>
 <CAMGD6P1FBwYBnVPPSFtn0qgHbs+y=stZXhnYHjX82H+vqei+AQ@mail.gmail.com>
 <YKVE2kerpTzoeIL+@kroah.com>
 <CAA03e5E9ojmsVNcHK4MyuYKCCFLo-RTFa17dA5Ay5v9rCMH+kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5E9ojmsVNcHK4MyuYKCCFLo-RTFa17dA5Ay5v9rCMH+kg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 10:18:38AM -0700, Marc Orr wrote:
> On Wed, May 19, 2021 at 10:03 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, May 19, 2021 at 09:42:42AM -0700, Jianxiong Gao wrote:
> > > On Wed, May 19, 2021 at 1:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > I still fail to understand why you can not just use the 5.10.y kernel or
> > > > newer.  What is preventing you from doing this if you wish to use this
> > > > type of hardware?  This is not a "regression" in that the 5.4.y kernel
> > > > has never worked with this hardware before, it feels like a new feature.
> > > >
> > > NVMe + SWIOTLB is not a new feature. From my understanding it should
> > > be supported by 5.4.y kernel correctly. Currently without the patch, any
> > > NVMe device (along with some other devices that relies on offset to
> > > work correctly), could be broken if the SWIOTLB is used on a 5.4.y kernel.
> >
> > Then do not do that, as obviously it never worked without your fixes, so
> > this isn't a "regression".
> 
> NVMe + SWIOTLB works fine without this bug fix. By fine I mean that a
> guest kernel using this configuration boots and runs stably for weeks
> and months under general-purpose usage. The bug that this patch set
> fixes was only encountered when a user tried to format an xfs
> filesystem under a RHEL guest kernel.
> 
> > And again, why can you not just use 5.10.y?
> 
> For our use case, this fixes the guest kernel, not the host kernel.
> The guest distros that we support use 5.4 kernels. We do not control
> the kernel that the distros deploy for usage as a guest OS on cloud.
> We only control the host kernel.

And how are you going to get your guest kernels to update to these
patches?  What specific ones are you concerned about?

RHEL ignores stable kernel updates, so if you are worried about them,
please just work with that company directly.

Good luck!

greg k-h
