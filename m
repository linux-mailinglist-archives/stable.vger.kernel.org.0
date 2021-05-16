Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638D9382090
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 21:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbhEPTKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 15:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhEPTKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 15:10:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9620DC061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 12:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8WzF9uTDOuvCSZt3gwOf4HGtceH3l2+ge5emBoE+kpw=; b=golC+u2UhHgpqn7vSuSRMoIsDi
        szdUTaVwfcUVTjARtIBWIYubvGLKRyYVidP5p5r1jxEY5ItwMibWY8KbWsnZByoyhfkyq0OwxkT5o
        uUABxaHsBlpCA7HdvkPS7greSJrK1xQ0k9X63bzPnpJqqt+c23iRVA5KTkspznONgmW1EjyaL7eIS
        tY7gI4jBi8I4NxrXw2/pteqFPVYA8hRWnuCFhyPKaAi5lq31jEU72EPlnxygmTeQBH/MmYc9jZATq
        LSRVp1kdhGmd7utDES/OR+pkOUEchKzobwrKzoDZr4NHtpfjs5VxrFQDIJSJPffy3KPrV6tiPewJz
        ap2d9hDQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1liM8e-00CEnc-6D; Sun, 16 May 2021 19:09:20 +0000
Date:   Sun, 16 May 2021 20:09:20 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
Message-ID: <YKFt4Njj5au/JEhT@casper.infradead.org>
References: <20210516121844.2860628-1-willy@infradead.org>
 <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
 <YKFi1hIBGLIQOHgc@casper.infradead.org>
 <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 11:27:10AM -0700, Linus Torvalds wrote:
> On Sun, May 16, 2021 at 11:22 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > Nobody's been willing to guarantee that all 32-bit architectures keep the
> > top 20 bits clear for their DMA addresses.  I've certainly seen hardware
> > (maybe PA-RISC?  MIPS?) which uses the top few bits of the DMA address to
> > indicate things like "coherent" or "bypasses IOMMU".  Rather than trying
> > to find out, I thought this was the safer option.
> 
> Fair enough. I just find it somewhat odd.
> 
> But I still find this a bit ugly. Maybe we could just have made that
> one sub-structure "__aligned(4)", and avoided this all, and let the
> compiler generate the split load (or, more likely, just let the
> compiler generate a regular load from an unaligned location).
> 
> IOW, just
> 
>                 struct {        /* page_pool used by netstack */
>                         /**
>                          * @dma_addr: might require a 64-bit value even on
>                          * 32-bit architectures.
>                          */
>                         dma_addr_t dma_addr;
>                 } __aligned((4));
> 
> without the magic shifting games?

That was the other problem fixed by this patch -- on big-endian 32-bit
platforms with 64-bit dma_addr_t (mips, ppc), a DMA address with bit 32 set
inadvertently sets the PageTail bit.  So we need to store the low bits
in the first word, even on big-endian platforms.

There's an upcoming patch to move dma_addr out of the union with
compound_head, but that requires changing page_is_pfmemalloc() to
use an indicator other than page->index == -1.  Once we do that,
we can have fun with __aligned().  Since we knew it would have to
be backported, this felt like the least risky patch to start with.
