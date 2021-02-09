Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7841D314934
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 07:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhBIG7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 01:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:32816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhBIG7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 01:59:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA80D64E9A;
        Tue,  9 Feb 2021 06:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612853919;
        bh=dpxVE0srNtqxA2P2gotaZ3bV8h2QUfJrlvUUTfe0l7o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TXzbsFhDpAQgj9QwPWKvmB1zj6vFiKg4V4CTlVCZzGXPcxBW49yvO/txzd5T2Ii+w
         rtL1/wYnZETAmKBFTPqDlkEsOY+vxAe9mVCFLWZ97V8boxpU4loubPLrclacpCX3FY
         zrcJswcPX2TBjIjas307svqNOUapi81jMEm1i7hk=
Date:   Tue, 9 Feb 2021 07:58:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        obayashi.yoshimasa@socionext.com
Subject: Re: DMA direct mapping fix for 5.4 and earlier stable branches
Message-ID: <YCIym62vHfbG+dWf@kroah.com>
References: <CAFA6WYNazCmYN20irLdNV+2vcv5dqR+grvaY-FA7q2WOBMs__g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYNazCmYN20irLdNV+2vcv5dqR+grvaY-FA7q2WOBMs__g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 11:39:25AM +0530, Sumit Garg wrote:
> Hi Christoph, Greg,
> 
> Currently we are observing an incorrect address translation
> corresponding to DMA direct mapping methods on 5.4 stable kernel while
> sharing dmabuf from one device to another where both devices have
> their own coherent DMA memory pools.

What devices have this problem?  And why can't then just use 5.10 to
solve this issue as that problem has always been present for them,
right?

> I am able to root cause this issue which is caused by incorrect virt
> to phys translation for addresses belonging to vmalloc space using
> virt_to_page(). But while looking at the mainline kernel, this patch
> [1] changes address translation from virt->to->phys to dma->to->phys
> which fixes the issue observed on 5.4 stable kernel as well (minimal
> fix [2]).
> 
> So I would like to seek your suggestion for backport to stable kernels
> (5.4 or earlier) as to whether we should backport the complete
> mainline commit [1] or we should just apply the minimal fix [2]?

Whenever you try to create a "minimal" fix, 90% of the time it is wrong
and does not work and I end up having to deal with the mess.  What
prevents you from doing the real thing here?  Are the patches to big?

And again, why not just use 5.10 for this hardware?  What hardware is
it?

thanks,

greg k-h
