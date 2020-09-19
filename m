Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8189B270AFD
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 07:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgISFou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 01:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISFot (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Sep 2020 01:44:49 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC79FC0613CE
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 22:44:49 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id i17so9828581oig.10
        for <stable@vger.kernel.org>; Fri, 18 Sep 2020 22:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=IdgEvO659anbjqoEUxCWG3G4X4Q8jshF4kz+icDVEO0=;
        b=cC74EChNmXBjUOISk+RHKIrrHyqfgPiP9ZrktBD6i44ja/2RgpItR1qM/yZFM69b2e
         /ssXccqiKlRJs3IuCDOOvGl5fByQTH3LdNbu9OkssGH7tgts/juYELIFCxVzfI5zUQiU
         ABwHL2IhU0EQLlMiGfBI8pi6eiwK7I3byPq81X5qTq7ON+Ndx5Cg26s0QI4+SXumiEWB
         8ka5vRBsQ7Dk5iJPpTs9z7y4ILa3roiCg1T6N0QaOZOBeuoEKp7PpmQUEr28676tU4h6
         mCK1giCUu0AEjP3bfdCZJyPIQuX60Bpj7QOKiNUPc7wkr2xzsMGXSismuYumK5WV2+Z/
         ir/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=IdgEvO659anbjqoEUxCWG3G4X4Q8jshF4kz+icDVEO0=;
        b=lY+BZdqGGDRg277SPFPkBawHkw/smNmP5wCRqqSPyMSg96akB45Wpu4DqddMhJP6ul
         U/1Yhyk0I1NucCIv7SLSJvcRavZDD006z7qrjNWo0SZ+oFF/iiSdzdEzQSfTzz1C+iws
         iljwS0RmluLbnZnbfbEcrjHZ/MhJXu5TzSgzDNOTzP25FUKJTFaOBpoJtaCnopnFvQ6G
         zrT5h+5KdKhG6wyzAYD0L2b+J0D82yJ4dbuOX398thbmmY7c0jCRM9/V+2bDglGnpSAJ
         Y8+gyyX9YHO0vpJokjtgjuieUPNNzWPw04DHUZAvOD+ptSp63p/Ow5ZC3+hz8nl9rvhy
         k2iw==
X-Gm-Message-State: AOAM530dKpe8Q7/fDrAYjLclzc1Qc7mCD5YtethxcTyhyNKmeBvlurln
        JM+hRafBf5pen9uv2iz2cohfuA==
X-Google-Smtp-Source: ABdhPJx+43X+/sjynMZCrss0ocZVc3UvE8E4vgymTb3xV51n3atl9j5nsgWTKCFSukJl27Moo3QmrQ==
X-Received: by 2002:aca:ad0e:: with SMTP id w14mr98049oie.64.1600494288750;
        Fri, 18 Sep 2020 22:44:48 -0700 (PDT)
Received: from eggly.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 9sm4455329ois.10.2020.09.18.22.44.46
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Fri, 18 Sep 2020 22:44:47 -0700 (PDT)
Date:   Fri, 18 Sep 2020 22:44:32 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To:     Matthew Wilcox <willy@infradead.org>
cc:     Andrew Morton <akpm@linux-foundation.org>,
        alex.shi@linux.alibaba.com, cai@lca.pw, hannes@cmpxchg.org,
        hughd@google.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [patch 04/15] shmem: shmem_writepage() split unlikely i915 THP
In-Reply-To: <20200919044408.GL32101@casper.infradead.org>
Message-ID: <alpine.LSU.2.11.2009182208210.13525@eggly.anvils>
References: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org> <20200919042009.bomzxmrg7%akpm@linux-foundation.org> <20200919044408.GL32101@casper.infradead.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 19 Sep 2020, Matthew Wilcox wrote:
> On Fri, Sep 18, 2020 at 09:20:09PM -0700, Andrew Morton wrote:
> > LRU page reclaim always splits the shmem huge page first: I'd prefer not
> > to demand that of i915, so check and split compound in shmem_writepage().
> 
> Sorry for not checking this earlier, but I don't think this is right.
> 
>         for (i = 0; i < obj->base.size >> PAGE_SHIFT; i++) {
> ...
>                 if (!page_mapped(page) && clear_page_dirty_for_io(page)) {
> ...
>                         ret = mapping->a_ops->writepage(page, &wbc);
> 
> so we cleared the dirty bit on the entire hugepage, but then split
> it after clearing the dirty bit, so the subpages are now not dirty.
> I think we'll lose writes as a result?  At least we won't swap pages
> out that deserve to be paged out.

Very good observation, thank you.

It behaves a lot better with this patch in than without it; but you're
right, only the head will get written to swap, and the tails left in
memory; with dirty cleared, so they may be left indefinitely (I've
not yet looked to see when if ever PageDirty might get set later).

Hmm. It may just be a matter of restyling the i915 code with

		if (!page_mapped(page)) {
			clear_page_dirty_for_io(page);

but I don't want to rush to that conclusion - there might turn
out to be a good way of doing it at the shmem_writepage() end, but
probably only hacks available.  I'll mull it over: it deserves some
thought about what would suit, if a THP arrived here some other way.

We did have some i915 guys Cc'ed on the original posting, but no
need to Cc them again until I'm closer to deciding what's right.

Linus, Andrew, probably best to drop this patch for now, since
no-one else has reported the problem here than me, testing with 
/sys/kernel/mm/transparent_hugepage/shmem_enabled set to "force";
and what it fixes is not a new regression in 5.9.

Though no harm done if the patch goes in: it is an improvement,
but seriously incomplete, as Matthew has observed.

Hugh

> 
> >  
> > -	VM_BUG_ON_PAGE(PageCompound(page), page);
> > +	/*
> > +	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "force",
> > +	 * then drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
> > +	 * and its shmem_writeback() needs them to be split when swapping.
> > +	 */
> > +	if (PageTransCompound(page))
> > +		if (split_huge_page(page) < 0)
> > +			goto redirty;
> > +
> >  	BUG_ON(!PageLocked(page));
> >  	mapping = page->mapping;
> >  	index = page->index;
> > _
> > 
