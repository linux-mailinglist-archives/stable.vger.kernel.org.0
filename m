Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6875428A250
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 00:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390316AbgJJW4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Oct 2020 18:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731314AbgJJTJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Oct 2020 15:09:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B19FC05BD2C;
        Sat, 10 Oct 2020 08:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Bk9taIvEeF09ddOrOZtGsVvZ8fTocrdR66a1B94enE8=; b=N8/lacCMf5nJB40agh5vipIvdy
        6VT3P8S+/hIfEmmBFcnNdPdQpKug0BNjB/MBO1SMLc7ivS86RkbFYDBmkeN1RTzRt4EJgLRaKuepk
        qUX1tf+y/4D+/u+qWjN88jwihkKLLf4iKBXeaqJsiKQQGqh9caZuQX7ct+aYZHK7XG2GZ7i27eAIe
        WSy37+SaclASmDFCAmoYMhpEFwGzuY763cx/N9ZLbxvZYMqDu7zl2CdelT5bwwArh7SCa4EEooOrT
        ENoHxBLtK4VNJsd3FspImND0NSeIvLFXF2N5VPScYsyEOsStBS2+aip6dG315h7+OmUwBqyVQJ4q+
        z++eAYZw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kRGrM-0005vv-C6; Sat, 10 Oct 2020 15:32:36 +0000
Date:   Sat, 10 Oct 2020 16:32:36 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Huang, Ying" <ying.huang@intel.com>
Cc:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        alex.shi@linux.alibaba.com, cai@lca.pw, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [patch 04/15] shmem: shmem_writepage() split unlikely i915 THP
Message-ID: <20201010153236.GY20115@casper.infradead.org>
References: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
 <20200919042009.bomzxmrg7%akpm@linux-foundation.org>
 <20200919044408.GL32101@casper.infradead.org>
 <alpine.LSU.2.11.2009182208210.13525@eggly.anvils>
 <20200919161847.GN32101@casper.infradead.org>
 <20201002183712.GA11185@casper.infradead.org>
 <877drz95pa.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877drz95pa.fsf@yhuang-dev.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 09, 2020 at 04:14:25PM +0800, Huang, Ying wrote:
> Matthew Wilcox <willy@infradead.org> writes:
> > On Sat, Sep 19, 2020 at 05:18:47PM +0100, Matthew Wilcox wrote:
> >> On Fri, Sep 18, 2020 at 10:44:32PM -0700, Hugh Dickins wrote:
> >> > It behaves a lot better with this patch in than without it; but you're
> >> > right, only the head will get written to swap, and the tails left in
> >> > memory; with dirty cleared, so they may be left indefinitely (I've
> >> > not yet looked to see when if ever PageDirty might get set later).
> >> > 
> >> > Hmm. It may just be a matter of restyling the i915 code with
> >> > 
> >> > 		if (!page_mapped(page)) {
> >> > 			clear_page_dirty_for_io(page);
> >> > 
> >> > but I don't want to rush to that conclusion - there might turn
> >> > out to be a good way of doing it at the shmem_writepage() end, but
> >> > probably only hacks available.  I'll mull it over: it deserves some
> >> > thought about what would suit, if a THP arrived here some other way.
> >> 
> >> I think the ultimate solution is to do as I have done for iomap and make
> >> ->writepage handle arbitrary sized pages.  However, I don't know the
> >> swap I/O path particularly well, and I would rather not learn it just yet.
> >> 
> >> How about this for a band-aid until we sort that out properly?  Just mark
> >> the page as dirty before splitting it so subsequent iterations see the
> >> subpages as dirty.  Arguably, we should use set_page_dirty() instead of
> >> SetPageDirty, but I don't think i915 cares.  In particular, it uses
> >> an untagged iteration instead of searching for PAGECACHE_TAG_DIRTY.
> >> 
> >> diff --git a/mm/shmem.c b/mm/shmem.c
> >> index 271548ca20f3..6231207ab1eb 100644
> >> --- a/mm/shmem.c
> >> +++ b/mm/shmem.c
> >> @@ -1362,8 +1362,21 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
> >>  	swp_entry_t swap;
> >>  	pgoff_t index;
> >>  
> >> -	VM_BUG_ON_PAGE(PageCompound(page), page);
> >>  	BUG_ON(!PageLocked(page));
> >> +
> >> +	/*
> >> +	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "force",
> >> +	 * then drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
> >> +	 * and its shmem_writeback() needs them to be split when swapping.
> >> +	 */
> >> +	if (PageTransCompound(page)) {
> >> +		/* Ensure the subpages are still dirty */
> >> +		SetPageDirty(page);
> >> +		if (split_huge_page(page) < 0)
> >> +			goto redirty;
> >> +		ClearPageDirty(page);
> >> +	}
> >> +
> >>  	mapping = page->mapping;
> >>  	index = page->index;
> >>  	inode = mapping->host;
> >
> > It turns out that I have an entirely different reason for wanting
> > ->writepage to handle an unsplit page.  In vmscan.c:shrink_page_list(),
> > we currently try to split file-backed THPs.  This always fails for XFS
> > file-backed THPs because they have page_private set which increments
> > the refcount by 1.  And so we OOM when the page cache is full of XFS
> > THPs.  I've been running successfully for a few days with this patch:
> >
> > @@ -1271,10 +1271,6 @@ static unsigned int shrink_page_list(struct list_head *page_list,
> >                                 /* Adding to swap updated mapping */
> >                                 mapping = page_mapping(page);
> >                         }
> > -               } else if (unlikely(PageTransHuge(page))) {
> > -                       /* Split file THP */
> > -                       if (split_huge_page_to_list(page, page_list))
> > -                               goto keep_locked;
> >                 }
> >  
> >                 /*
> >
> >
> > Kirill points out that this will probably make shmem unhappy (it's
> > possible that said pages will get split anyway if they're mapped
> > because we pass TTU_SPLIT_HUGE_PMD into try_to_unmap()), but if
> > they're (a) Dirty, (b) !mapped, we'll call pageout() which calls
> > ->writepage().
> 
> We may distinguish the shmem THPs from the XFS file cache THPs via
> PageSwapBacked()?

Yes, we _can_, but we now have two reasons for wanting to be able to write
THPs to swap without splitting them.  Another thing this solves is that,
in my tree, we don't allocate the bottom layer of the XArray for THPs.
So when we split, we have to allocate memory to store the split pages,
and it seems like a bad idea to allocate memory in order to free memory,
particularly when we don't have to.
