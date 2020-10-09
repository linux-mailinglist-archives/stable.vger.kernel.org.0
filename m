Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65512884FB
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 10:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732455AbgJIIOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 04:14:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:64707 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732337AbgJIIOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 04:14:30 -0400
IronPort-SDR: e+3puoUsUdb7L3TTi40fAdrDFeKcI4gZvBuXJNX74hClItggUuubWmDKln0RikKID3HGrcz+nK
 tthIkdISwazg==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="229642307"
X-IronPort-AV: E=Sophos;i="5.77,354,1596524400"; 
   d="scan'208";a="229642307"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 01:14:30 -0700
IronPort-SDR: YcJBdM1PzjfJwai4zUBc0OtOchYNS7a1Th0pljAQHNKxFRIN4DgsA8YWWqHyMIRW5JY21xCkRK
 HJlstn4ytQ6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,354,1596524400"; 
   d="scan'208";a="462112210"
Received: from yhuang-dev.sh.intel.com (HELO yhuang-dev) ([10.239.159.65])
  by orsmga004.jf.intel.com with ESMTP; 09 Oct 2020 01:14:26 -0700
From:   "Huang\, Ying" <ying.huang@intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        alex.shi@linux.alibaba.com, cai@lca.pw, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [patch 04/15] shmem: shmem_writepage() split unlikely i915 THP
References: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
        <20200919042009.bomzxmrg7%akpm@linux-foundation.org>
        <20200919044408.GL32101@casper.infradead.org>
        <alpine.LSU.2.11.2009182208210.13525@eggly.anvils>
        <20200919161847.GN32101@casper.infradead.org>
        <20201002183712.GA11185@casper.infradead.org>
Date:   Fri, 09 Oct 2020 16:14:25 +0800
In-Reply-To: <20201002183712.GA11185@casper.infradead.org> (Matthew Wilcox's
        message of "Fri, 2 Oct 2020 19:37:12 +0100")
Message-ID: <877drz95pa.fsf@yhuang-dev.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Matthew,

Sorry for late reply.  I just come back from a long holiday.

Matthew Wilcox <willy@infradead.org> writes:

> On Sat, Sep 19, 2020 at 05:18:47PM +0100, Matthew Wilcox wrote:
>> On Fri, Sep 18, 2020 at 10:44:32PM -0700, Hugh Dickins wrote:
>> > It behaves a lot better with this patch in than without it; but you're
>> > right, only the head will get written to swap, and the tails left in
>> > memory; with dirty cleared, so they may be left indefinitely (I've
>> > not yet looked to see when if ever PageDirty might get set later).
>> > 
>> > Hmm. It may just be a matter of restyling the i915 code with
>> > 
>> > 		if (!page_mapped(page)) {
>> > 			clear_page_dirty_for_io(page);
>> > 
>> > but I don't want to rush to that conclusion - there might turn
>> > out to be a good way of doing it at the shmem_writepage() end, but
>> > probably only hacks available.  I'll mull it over: it deserves some
>> > thought about what would suit, if a THP arrived here some other way.
>> 
>> I think the ultimate solution is to do as I have done for iomap and make
>> ->writepage handle arbitrary sized pages.  However, I don't know the
>> swap I/O path particularly well, and I would rather not learn it just yet.
>> 
>> How about this for a band-aid until we sort that out properly?  Just mark
>> the page as dirty before splitting it so subsequent iterations see the
>> subpages as dirty.  Arguably, we should use set_page_dirty() instead of
>> SetPageDirty, but I don't think i915 cares.  In particular, it uses
>> an untagged iteration instead of searching for PAGECACHE_TAG_DIRTY.
>> 
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 271548ca20f3..6231207ab1eb 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1362,8 +1362,21 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>>  	swp_entry_t swap;
>>  	pgoff_t index;
>>  
>> -	VM_BUG_ON_PAGE(PageCompound(page), page);
>>  	BUG_ON(!PageLocked(page));
>> +
>> +	/*
>> +	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "force",
>> +	 * then drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
>> +	 * and its shmem_writeback() needs them to be split when swapping.
>> +	 */
>> +	if (PageTransCompound(page)) {
>> +		/* Ensure the subpages are still dirty */
>> +		SetPageDirty(page);
>> +		if (split_huge_page(page) < 0)
>> +			goto redirty;
>> +		ClearPageDirty(page);
>> +	}
>> +
>>  	mapping = page->mapping;
>>  	index = page->index;
>>  	inode = mapping->host;
>
> It turns out that I have an entirely different reason for wanting
> ->writepage to handle an unsplit page.  In vmscan.c:shrink_page_list(),
> we currently try to split file-backed THPs.  This always fails for XFS
> file-backed THPs because they have page_private set which increments
> the refcount by 1.  And so we OOM when the page cache is full of XFS
> THPs.  I've been running successfully for a few days with this patch:
>
> @@ -1271,10 +1271,6 @@ static unsigned int shrink_page_list(struct list_head *page_list,
>                                 /* Adding to swap updated mapping */
>                                 mapping = page_mapping(page);
>                         }
> -               } else if (unlikely(PageTransHuge(page))) {
> -                       /* Split file THP */
> -                       if (split_huge_page_to_list(page, page_list))
> -                               goto keep_locked;
>                 }
>  
>                 /*
>
>
> Kirill points out that this will probably make shmem unhappy (it's
> possible that said pages will get split anyway if they're mapped
> because we pass TTU_SPLIT_HUGE_PMD into try_to_unmap()), but if
> they're (a) Dirty, (b) !mapped, we'll call pageout() which calls
> ->writepage().

We may distinguish the shmem THPs from the XFS file cache THPs via
PageSwapBacked()?

Best Regards,
Huang, Ying

> The patch above is probably not exactly the right solution for this
> case, since pageout() calls writepage only once, not once for each
> sub-page.  This is hard to write a cute patch for because the
> pages get unlocked by split_huge_page().  I think I'm going to have
> to learn about the swap path, unless someone can save me from that.
