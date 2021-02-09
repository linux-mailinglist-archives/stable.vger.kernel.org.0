Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3B315334
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 16:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhBIPvn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 10:51:43 -0500
Received: from verein.lst.de ([213.95.11.211]:47186 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232384AbhBIPvm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 10:51:42 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9E5D467373; Tue,  9 Feb 2021 16:50:58 +0100 (CET)
Date:   Tue, 9 Feb 2021 16:50:58 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Sumit Garg <sumit.garg@linaro.org>, Christoph Hellwig <hch@lst.de>,
        Greg KH <gregkh@linuxfoundation.org>,
        obayashi.yoshimasa@socionext.com, m.szyprowski@samsung.com,
        iommu@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: DMA direct mapping fix for 5.4 and earlier stable branches
Message-ID: <20210209155058.GA8912@lst.de>
References: <CAFA6WYNazCmYN20irLdNV+2vcv5dqR+grvaY-FA7q2WOBMs__g@mail.gmail.com> <YCIym62vHfbG+dWf@kroah.com> <CAFA6WYM+xJ0YDKenWFPMHrTz4gLWatnog84wyk31Xy2dTiT2RA@mail.gmail.com> <YCJCDZGa1Dhqv6Ni@kroah.com> <27bbe35deacb4ca49f31307f4ed551b5@SOC-EX02V.e01.socionext.com> <YCJUgKDNVjJ4dUqM@kroah.com> <20210209093642.GA1006@lst.de> <CAFA6WYO59w=wif8W16sG6BnzSjFhaY6PmRUTdSCu9A+zA7gzBw@mail.gmail.com> <e36b8a7d-a999-da09-d7d9-cc26579a65d1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e36b8a7d-a999-da09-d7d9-cc26579a65d1@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 12:45:11PM +0000, Robin Murphy wrote:
> It's not a bug, it's a fundamental design failure. dma_get_sgtable() has 
> only ever sort-of-worked for DMA buffers that come from CMA or regular page 
> allocations. In particular, a "no-map" DMA pool is not backed by kernel 
> memory, so does not have any corresponding page structs, so it's impossible 
> to generate a *valid* scatterlist to represent memory from that pool, 
> regardless of what you might get away with provided you don't poke too hard 
> at it.
>
> It is not a good API...

Yes, I don't think anyone should add new users of the API.

That being said the commit he is trying to backport fixes a bug in
the implementation that at least in theory could also affect in-tree
drivers.
