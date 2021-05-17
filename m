Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD5C3822D6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 04:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhEQCn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 22:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhEQCn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 22:43:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF72C061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 19:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=83lZs4j5473YL7dKkE/N9Fxr8HnhbMpxrkQ6QOQrtj8=; b=eFTV/+uO92duVnstBU54YuDVw+
        7NvK17J5YMjeiD2imbl9sCcp4h/SJsNDGzeJZkLWDdcVWaqln/9z6bV9kX350EaNUzqSibS5EGVI7
        azPgniOC0bejgN85Ne14queeyKsB8UiCh/A/ukbWYlQ9ePvOHJD9iHt7BmnO14DZVSG2udR4Ag2s/
        qJZY45gy/3MkEUd+b6EOefdsMhN/rWD3iC0NXyAPEG7Qok3rAaj5+hf6Baddleuscn1XHccF/K0bG
        cdNiAPlupAhdojrmmwPNkyBodmLwx+6lrKp8Jtf22Or5M52uI5qyYEmDAGRfkSk6ecJ4YZ2Ej8cds
        /DuyrcDQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1liTDC-00CULx-JB; Mon, 17 May 2021 02:42:33 +0000
Date:   Mon, 17 May 2021 03:42:30 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
Message-ID: <YKHYFpyPcnwpetM5@casper.infradead.org>
References: <20210516121844.2860628-1-willy@infradead.org>
 <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
 <YKFi1hIBGLIQOHgc@casper.infradead.org>
 <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
 <YKFt4Njj5au/JEhT@casper.infradead.org>
 <CAHk-=wj6RAF5OFq3Pp725e0BFU2e0QnMCvhfF_3TBhk=UqN3Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj6RAF5OFq3Pp725e0BFU2e0QnMCvhfF_3TBhk=UqN3Jw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 12:22:43PM -0700, Linus Torvalds wrote:
> On Sun, May 16, 2021 at 12:09 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > That was the other problem fixed by this patch -- on big-endian 32-bit
> > platforms with 64-bit dma_addr_t (mips, ppc), a DMA address with bit 32 set
> > inadvertently sets the PageTail bit.  So we need to store the low bits
> > in the first word, even on big-endian platforms.
> 
> Ouch. And yes, that would have shot down the "dma page frame number" model too.
> 
> Oh how I wish PageTail was in "flags". Yes, our compound_head() thing
> is "clever", but it's a pain,
> 
> That said, that union entry is "5 words", so the dma_addr_t thing
> could easily just have had a dummy word at the beginning.

Ah, if you just put one dummy word in front, then dma_addr_t overlaps with
page->mapping, which used to be fine, but now we can map network queues
to userspace, page->mapping has to be NULL.  So there's only two places to
put dma_addr; either overlapping compound_head or overlapping pfmemalloc.

I don't think PageTail is movable -- the issue is needing an atomic read
of both PageTail _and_ the location of the head page.  Even if x86 has
something, there are a lot of architectures that don't.

While I've got you on the subject of compound_head ... have you had a look
at the folio work?  It decreases the number of calls to compound_head()
by about 25%, as well as shrinking the (compiled size) of the kernel and
laying the groundwork for supporting things like 32kB anonymous pages
and adaptive page sizes in the page cache.  Andrew's a bit nervous of
it, probably because it's such a large change.

