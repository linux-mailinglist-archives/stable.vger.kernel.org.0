Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0055386D79
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 01:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbhEQXEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 19:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbhEQXEN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 19:04:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8255DC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MqShhdABM233SCJgnGpQt+G4mNfMGlwL2xS2TzocMpQ=; b=vXbRUpa/YDL75qFDDqNMETEt+W
        XDs8I2VC4aP+w8LB0PqiHzX4w511LE1ZyWbULqvx71zuYSWX5/TYfCID5/PZGS9yXRv/faReMTRU9
        a/ZzWD3koVyakAyKggWO4q6sb1XHPqa9Vtsu3h5Jh13ySIiLN5YbLfclGxZjmvo2vePz3Waiq33go
        0zdHJNgugs8FwYRxWu4FtpUutAdPDYFQnzQ6IvU/KXsbQy5sIprVlTjMV6CIr+UpTxFoqWVIWTLD8
        7Imv1aOGfH2P5/zfiyMLdVsz5rcl9DcPtil3yCsKT5OX+fJVpMLnR2CF88Io1MQP20+en41ik6ZZQ
        Df7MWtIA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1limFv-00DTTj-6p; Mon, 17 May 2021 23:02:44 +0000
Date:   Tue, 18 May 2021 00:02:35 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
Message-ID: <YKL2C0YtlxYbsRdT@casper.infradead.org>
References: <20210516121844.2860628-1-willy@infradead.org>
 <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
 <YKFi1hIBGLIQOHgc@casper.infradead.org>
 <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
 <YKFt4Njj5au/JEhT@casper.infradead.org>
 <CAHk-=wj6RAF5OFq3Pp725e0BFU2e0QnMCvhfF_3TBhk=UqN3Jw@mail.gmail.com>
 <YKHYFpyPcnwpetM5@casper.infradead.org>
 <CAHk-=wi0Vp7DRh5ZwOsWKpQUyPpwo=9qG2hRw2uFp0adMp=brg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi0Vp7DRh5ZwOsWKpQUyPpwo=9qG2hRw2uFp0adMp=brg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 03:18:38PM -0700, Linus Torvalds wrote:
> On Sun, May 16, 2021 at 7:42 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > Ah, if you just put one dummy word in front, then dma_addr_t overlaps with
> > page->mapping, which used to be fine, but now we can map network queues
> > to userspace, page->mapping has to be NULL.
> 
> Well, that's a problem in itself. We shouldn't have those kinds of
> "oh, it uses one field from one union, and another field from
> another".

No, I agree.  I wasn't aware of that particular problem until recently,
and adjusting the contents of struct page always makes me a little
nervous, so I haven't done it yet.

> At least that "low bit of the first word" thing is documented, but
> this kind of "oh, it uses dma_addr from one union and mapping from
> another" really needs to go away. Because that's just not acceptable.
> 
> So that network stack thing should just make the mapping thing explicit then.

One of the pending patches for next merge window has this:

                struct {        /* page_pool used by netstack */
-                       /**
-                        * @dma_addr: might require a 64-bit value on
-                        * 32-bit architectures.
-                        */
+                       unsigned long pp_magic;
+                       struct page_pool *pp;
+                       unsigned long _pp_mapping_pad;
                        unsigned long dma_addr[2];
                };

(people are still bikeshedding the comments, etc, but fundamentally this
is the new struct layout).  It's not the networking stack that uses
page->mapping, it's if somebody decides to do something like call
get_user_pages() on a mapped page_pool page, which then calls
page_mapping() ... if that doesn't return NULL, then things go wrong.

Andrey Ryabinin found the path:
: Some implementation of the flush_dcache_page(), also set_page_dirty()
: can be called on userspace-mapped vmalloc pages during unmap -
: zap_pte_range() -> set_page_dirty()

> Possibly by making mapping/index be the first fields (for both the
> page cache and the page_pool thing) and then have the LRU list and the
> dma_addr be after that?

Unfortunately, we also use the bottom two bits of ->mapping for PageAnon
/ PageKSM / PageMovable.  We could move ->mapping to the fifth word of
the union, where it's less in the way.

> > While I've got you on the subject of compound_head ... have you had a look
> > at the folio work?  It decreases the number of calls to compound_head()
> > by about 25%, as well as shrinking the (compiled size) of the kernel and
> > laying the groundwork for supporting things like 32kB anonymous pages
> > and adaptive page sizes in the page cache.  Andrew's a bit nervous of
> > it, probably because it's such a large change.
> 
> I guess I need to take a look. Mind sending me another pointer to the series?

This is probably a good place to start:
https://lore.kernel.org/lkml/20210505150628.111735-10-willy@infradead.org/
or if you'd rather look at a git tree,
https://git.infradead.org/users/willy/pagecache.git/shortlog/refs/heads/folio

