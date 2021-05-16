Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988D838204E
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 20:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhEPSXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 14:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhEPSXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 14:23:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F503C061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 11:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V4lnM4pJU/ho7NjnOBfSIUvXF7ZsxpBFONAvSbFZRa8=; b=UwO3/qwczdgZP24j0yGxKcvFuW
        h0BrPig70VLJZPgJl1CvGZ2FtQoOIa67qKYoUk9b9Yilfs3pgHvVJWzXl+o+5k1eSCZEfdELDWC3u
        RIDyvMvxT4QbREaNNzFPHgeO7TztoiNbc5Hch1B+86Dz/R5eYZ5/Hi0Ys0Q0B8rRJDlOUAuN5xQhy
        47HVAsrKaNEVGv5ZXCuTutBrNHfFxJFjhjRsLsCh841UWzs35FSSVlSVGEfzeSjb3cxSwxq9Db8+B
        cGmtoI6dDb3uLOWA8VEKC8z++LwWH7VP+wvSf0HVZF5wrtTCmJlvtn0U0dwWO6lTmqXfc04aCaPET
        Jtzo0onQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1liLP4-00CD2A-Ce; Sun, 16 May 2021 18:22:19 +0000
Date:   Sun, 16 May 2021 19:22:14 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
Message-ID: <YKFi1hIBGLIQOHgc@casper.infradead.org>
References: <20210516121844.2860628-1-willy@infradead.org>
 <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 16, 2021 at 09:29:41AM -0700, Linus Torvalds wrote:
> On Sun, May 16, 2021 at 5:19 AM Matthew Wilcox (Oracle)
> <willy@infradead.org> wrote:
> >
> > 32-bit architectures which expect 8-byte alignment for 8-byte integers and
> > need 64-bit DMA addresses (arm, mips, ppc) had their struct page
> > inadvertently expanded in 2019.  When the dma_addr_t was added, it forced
> > the alignment of the union to 8 bytes, which inserted a 4 byte gap between
> > 'flags' and the union.
> 
> So I already have this in my tree, but this stable submission made me go "Hmm".
> 
> Why do we actually want a full 64-bit DMA address on 32-bit architectures here?
> 
> It strikes me that the address is page-aligned, and I suspect we could
> just use a 32-bit "DMA page frame number" instead in 'struct page'?

Nobody's been willing to guarantee that all 32-bit architectures keep the
top 20 bits clear for their DMA addresses.  I've certainly seen hardware
(maybe PA-RISC?  MIPS?) which uses the top few bits of the DMA address to
indicate things like "coherent" or "bypasses IOMMU".  Rather than trying
to find out, I thought this was the safer option.  It only affects
32-bit architectures with PAE, and I'd rather not introduce a shift on
64-bit architectures to work around a 32-bit PAE problem.
