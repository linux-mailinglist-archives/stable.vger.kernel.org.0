Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30473386E86
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 02:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237793AbhERAzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 20:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235791AbhERAzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 20:55:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2CEC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 17:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kayOwVdlaHUJmlpcWi5q16iDaq0AfwVfkPvQvcQt5tY=; b=Zf6r3WYFUsU0jWWUQwUUh5R+xR
        IyiaR+1vUe5NC47/TCK5OJBsyuDmAkM1i6h4D2RECtzjr/3h4dW6zM3hm886qwDL6kEqYhkxG/AaJ
        mbGV5txve8smeo2zYFssXkCPQdly1tYDBccOhuL2QAdhs+VJ4KQ9UdcrOBZhdJZ4FoKRLZX65+Ymn
        zoMncLv5Lqb+T1yskTaEGcgBkUKKCtzXWp9XuyjqhbL9Xr2QhXVcPycdiq2SGTj9RDl2hFxhty3aS
        luyXczeRJDdBsFuS02MjYGERWZXqV7YLw2pP52ytPBllVLYdgclSVLtkz9KOCWHRluAF04/Bh8P7n
        ke00W4Sg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1linzT-00DXlI-4Y; Tue, 18 May 2021 00:53:44 +0000
Date:   Tue, 18 May 2021 01:53:43 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: fix struct page layout on 32-bit systems
Message-ID: <YKMQFz5PpI65lc+R@casper.infradead.org>
References: <CAHk-=wgTG0Bb30NzXX=3F=n-rHjVrQAHVzFFCxRKWTTu1QxABQ@mail.gmail.com>
 <YKFi1hIBGLIQOHgc@casper.infradead.org>
 <CAHk-=wihKAt+Wz6=nccQAXxi_VWFJpx4JwWTJSwT0UvUs1RtZw@mail.gmail.com>
 <YKFt4Njj5au/JEhT@casper.infradead.org>
 <CAHk-=wj6RAF5OFq3Pp725e0BFU2e0QnMCvhfF_3TBhk=UqN3Jw@mail.gmail.com>
 <YKHYFpyPcnwpetM5@casper.infradead.org>
 <CAHk-=wi0Vp7DRh5ZwOsWKpQUyPpwo=9qG2hRw2uFp0adMp=brg@mail.gmail.com>
 <YKL2C0YtlxYbsRdT@casper.infradead.org>
 <CAHk-=wja9m_sdu2VekWNJWhswZ8CVKROPvtCreZmANE1jBCHDw@mail.gmail.com>
 <CAHk-=wiH2++_KaaunpNYWD6YiMuU_VyCHgO-1RbvGUq=0_mAJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiH2++_KaaunpNYWD6YiMuU_VyCHgO-1RbvGUq=0_mAJg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 05:02:01PM -0700, Linus Torvalds wrote:
> On Mon, May 17, 2021 at 4:37 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I don't mind that rule, but what's the advantage of introducing a new
> > name for that? IOW, I get the feeling that almost all of this
> > could/should just be "don't use non-head pages".
> 
> Put another way: I've often wanted to remove the (quite expensive)
> "compund_head()" calls out of the code page functions, and move them
> into the callers (and in most cases they probably just end up
> disappearing entirely, because the callers fundamentally always have a
> proper head page).
> 
> It feels like this is what the folio patches do, they just spend a
> *lot* of effort doing so incrementally by renaming things and
> duplicating functionality, rather than just do it (again
> incrementally) by just doing one compound_head() movement at a time..

I tried that, and I ended up in whack-a-mole hell trying to
figure out all the places that weren't expecting to see a
head page.  If you look at the master branch from that repo:
https://git.infradead.org/users/willy/pagecache.git/shortlog

it basically redefines a THP to be arbitrary order and then tries to
ram through using head pages everywhere.  It's definitely missing a few
spots in the writeback code that get the accounting entirely wrong.
So I decided a new type was in order to distinguish between the
places which do need to see a struct page (vmf->page being one)
and those that are dealing with pages for accounting purposes.
