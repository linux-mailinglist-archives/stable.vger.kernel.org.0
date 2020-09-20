Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDC727118A
	for <lists+stable@lfdr.de>; Sun, 20 Sep 2020 02:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgITARN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 20:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgITARN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Sep 2020 20:17:13 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40924C0613CE
        for <stable@vger.kernel.org>; Sat, 19 Sep 2020 17:17:13 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id e23so9031815otk.7
        for <stable@vger.kernel.org>; Sat, 19 Sep 2020 17:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=oC/hVouNsJRqHx4d5Y9JP014dEn9+Y6OJHXD1JMwOVc=;
        b=uvYqGsdBbo/3VhAtUJWqpcFhbWrdNzU6D07c6leInVPEn6MC9bfcjBvXT6SNlz1ihI
         ZKFPlEzB8s3kmqwIN06anOuZSRlxlu5BiKM2WxXq+/iXM08j8tSHdXGN03ZcZBDld6uP
         ZVp6nCUOAMpQ/zeEM2/ehE/HPbVxtB8Q1tuBaZKb8zyA8Wpt7OZ+LYJEb8haDro4uyHw
         xWLZ91nxMJ0RvKqJnZpzQcA8SQLmbhpIghgEQfS2HsUjtuunuIbj3rvWBCjyO0mmVvay
         SHMpP33SaIMycb3MRIOZ+EkrMzNP1pJG1HJVUe0JBeQnRcgNHcTRhl+70raxwghlj1q3
         mnMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=oC/hVouNsJRqHx4d5Y9JP014dEn9+Y6OJHXD1JMwOVc=;
        b=LMXZfRbjU88VMDii6hSrLo/OWSSgexedqyJSSurRW5LyKg0BmluLgGyTHrVTR3j6M+
         ab7u6jWId0zIEyUn1blPGzq0zVwHA4U6pgLgvsbvRd1C9bjaS5FjzaZvVFdvGh7cLLDu
         fk5Dd4yJmWfczUdXrpQPIoIsyZaZb58mARqO4OM6+17KcAOH7CPq9vowW1U3Hskq4dFU
         Or6Z+5fAN5nBPTY+nDK+MuqQ2KmjAfLYgnDJpkiaFDczaa0VwARsi+H2vUwguNDvydVd
         0M/fACzFkMoCwr23ujnLCOzGYRjvThgLnbER/DKeW0hmb3WbsJ9hLwuMl7cV2iweMG15
         /8RQ==
X-Gm-Message-State: AOAM530VTmnBXxSs1xQovo/a7v5eaFV73YJOGNywT6HQgjLB+uaRWUNV
        QdEJ6r2b+0HrB15J6hG4MXFtJidC1TfeoQ==
X-Google-Smtp-Source: ABdhPJy/cuAdvDzRlEC3vV8Dz7gY2Gl8GZbB4r0wkEX83f510JjLdg7hd38/vlWCJIBTkoHDqmtofA==
X-Received: by 2002:a05:6830:14d9:: with SMTP id t25mr28835098otq.188.1600561031883;
        Sat, 19 Sep 2020 17:17:11 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id g23sm6506479ooh.45.2020.09.19.17.17.09
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Sat, 19 Sep 2020 17:17:10 -0700 (PDT)
Date:   Sat, 19 Sep 2020 17:16:57 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Matthew Wilcox <willy@infradead.org>
cc:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        alex.shi@linux.alibaba.com, cai@lca.pw, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [patch 04/15] shmem: shmem_writepage() split unlikely i915 THP
In-Reply-To: <20200919161847.GN32101@casper.infradead.org>
Message-ID: <alpine.LSU.2.11.2009191557320.1018@eggly.anvils>
References: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org> <20200919042009.bomzxmrg7%akpm@linux-foundation.org> <20200919044408.GL32101@casper.infradead.org> <alpine.LSU.2.11.2009182208210.13525@eggly.anvils>
 <20200919161847.GN32101@casper.infradead.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 19 Sep 2020, Matthew Wilcox wrote:
> On Fri, Sep 18, 2020 at 10:44:32PM -0700, Hugh Dickins wrote:
> > It behaves a lot better with this patch in than without it; but you're
> > right, only the head will get written to swap, and the tails left in
> > memory; with dirty cleared, so they may be left indefinitely (I've
> > not yet looked to see when if ever PageDirty might get set later).
> > 
> > Hmm. It may just be a matter of restyling the i915 code with
> > 
> > 		if (!page_mapped(page)) {
> > 			clear_page_dirty_for_io(page);
> > 
> > but I don't want to rush to that conclusion - there might turn
> > out to be a good way of doing it at the shmem_writepage() end, but
> > probably only hacks available.  I'll mull it over: it deserves some
> > thought about what would suit, if a THP arrived here some other way.
> 
> I think the ultimate solution is to do as I have done for iomap and make
> ->writepage handle arbitrary sized pages.  However, I don't know the
> swap I/O path particularly well, and I would rather not learn it just yet.

Understood ;)

> 
> How about this for a band-aid until we sort that out properly?  Just mark
> the page as dirty before splitting it so subsequent iterations see the
> subpages as dirty.

This is certainly much better than my original, and I've had no problem
in running with it (briefly); and it's what I'll now keep in my testing
tree - thanks.  But it is more obviously a hack, or as you put it, a
band-aid: fit for Linus's tree?

This issue has only come up with i915 and shmem_enabled "force", nobody
has been bleeding except me: but if it's something that impedes or may
impede your own testing, or that you feel should go in anyway, say so and
I'll push your new improved version to akpm (adding your signoff to mine).

> Arguably, we should use set_page_dirty() instead of SetPageDirty,

My position on that has changed down the years: I went through a
phase of replacing shmem.c's SetPageDirtys by set_page_dirtys, with
the idea that its "if (!PageDirty)" is good to avoid setting cacheline
dirty.  Then Spectre changed the balance, so now I'd rather avoid the
indirect function call, and go with your SetPageDirty.  But the bdi
flags are such that they do the same thing, and if they ever diverge,
then we make the necessary changes at that time.

> but I don't think i915 cares.  In particular, it uses
> an untagged iteration instead of searching for PAGECACHE_TAG_DIRTY.

PAGECACHE_TAG_DIRTY comes with bdi flags that shmem does not use:
with one exception, every shmem page is always dirty (since its swap
is freed as soon as the page is moved from swap cache to file cache);
unless I'm forgetting something (like the tails in my patch!), the
only exception is a page allocated to a hole on fault (after which
a write fault will soon set pte dirty).

So I didn't quite get what i915 was doing with its set_page_dirty()s:
but very probably being a good citizen, marking when it exposed the
page to changes itself, making no assumption of what shmem.c does.

It would be good to have a conversation with i915 guys about huge pages
sometime (they forked off their own mount point in i915_gemfs_init(),
precisely in order to make use of huge pages, but couldn't get them
working, so removed the option to ask for them, but kept the separate
mount point.  But not a conversation I'll be responsive on at present.)

Hugh

> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 271548ca20f3..6231207ab1eb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1362,8 +1362,21 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>  	swp_entry_t swap;
>  	pgoff_t index;
>  
> -	VM_BUG_ON_PAGE(PageCompound(page), page);
>  	BUG_ON(!PageLocked(page));
> +
> +	/*
> +	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "force",
> +	 * then drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
> +	 * and its shmem_writeback() needs them to be split when swapping.
> +	 */
> +	if (PageTransCompound(page)) {
> +		/* Ensure the subpages are still dirty */
> +		SetPageDirty(page);
> +		if (split_huge_page(page) < 0)
> +			goto redirty;
> +		ClearPageDirty(page);
> +	}
> +
>  	mapping = page->mapping;
>  	index = page->index;
>  	inode = mapping->host;
