Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5B0270ABD
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 06:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgISEor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 00:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISEor (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Sep 2020 00:44:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10855C0613CE;
        Fri, 18 Sep 2020 21:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eUq4iAXCgmFRQuJG0LnzSDMdVRozT7gWX2kuRsCkalg=; b=gSbClo97rMqgVp1lVlT/Lan5kn
        Sk7fMmRclfGNJfh6EwNI7gK7TPAkF+1VBfLHxRIw9+vRa6CNbD6YslYLCWU6924xhBw3i1+VLFOBo
        KLTOtV/e08d0DyTIMNhi3QRsy7x7TImPyd58y/0fenwah9pZwpPRAoN19ri40HdQGc35cenMxHm/t
        hnQtHXyznv+NLgXHNvhOmwVRoVN7obH3346uF7Mq2gGO6yCCe7GypOD1THHY+mhE/6rbY8RzFLy0I
        oHqg1NvQUyEltMq3Qubls05CH3qGElWTCqCPVExyOJcOCwf0X6Wa3kSbl9QQWcjSkpvX+Kq9KnnaJ
        ZHEQx8Ug==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJUjI-0006WP-L8; Sat, 19 Sep 2020 04:44:08 +0000
Date:   Sat, 19 Sep 2020 05:44:08 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     alex.shi@linux.alibaba.com, cai@lca.pw, hannes@cmpxchg.org,
        hughd@google.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [patch 04/15] shmem: shmem_writepage() split unlikely i915 THP
Message-ID: <20200919044408.GL32101@casper.infradead.org>
References: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
 <20200919042009.bomzxmrg7%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919042009.bomzxmrg7%akpm@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 09:20:09PM -0700, Andrew Morton wrote:
> LRU page reclaim always splits the shmem huge page first: I'd prefer not
> to demand that of i915, so check and split compound in shmem_writepage().

Sorry for not checking this earlier, but I don't think this is right.

        for (i = 0; i < obj->base.size >> PAGE_SHIFT; i++) {
...
                if (!page_mapped(page) && clear_page_dirty_for_io(page)) {
...
                        ret = mapping->a_ops->writepage(page, &wbc);

so we cleared the dirty bit on the entire hugepage, but then split
it after clearing the dirty bit, so the subpages are now not dirty.
I think we'll lose writes as a result?  At least we won't swap pages
out that deserve to be paged out.

>  
> -	VM_BUG_ON_PAGE(PageCompound(page), page);
> +	/*
> +	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "force",
> +	 * then drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
> +	 * and its shmem_writeback() needs them to be split when swapping.
> +	 */
> +	if (PageTransCompound(page))
> +		if (split_huge_page(page) < 0)
> +			goto redirty;
> +
>  	BUG_ON(!PageLocked(page));
>  	mapping = page->mapping;
>  	index = page->index;
> _
> 
