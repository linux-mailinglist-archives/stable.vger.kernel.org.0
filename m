Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA9E270F65
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 18:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgISQTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 12:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgISQTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Sep 2020 12:19:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AF0C0613CE;
        Sat, 19 Sep 2020 09:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UtLIhuknFyVgzypgVMrilrLbQcc//rMRWCAqNplTMFw=; b=i6jr004Sx1Q6M4lYER+1trw9PV
        UJHcGIjVJMAmfeQG+N56N2SDIeDrPL0XfrYQ/+FmoKrJc3yo8Glyvc99/wgfIrpz//tP0I5pYQBPt
        9JMHDBzXu5rDdb3nkSRDCdlTtn+47LLgN+39dg+qMyTkTVDBUmfwzQrTKhKP3gPBkNTf0X4qQ7MBH
        x5BnfatJ8xgm4CMQxPz2usJsz+isLKnW6hnLInP9WX/t2444SR9BgoXJVGJaTYdZ3bjiBYd8+owWT
        ZEKPl4qX5Dsdi5Q2PylRHQ/398TFCV6jHU26MTmGw78Vqx10ZhrbwDyK7NHpFY9uBdkiOJp8XGDvh
        CzyJ/u6w==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJfZX-00028j-Be; Sat, 19 Sep 2020 16:18:47 +0000
Date:   Sat, 19 Sep 2020 17:18:47 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        alex.shi@linux.alibaba.com, cai@lca.pw, hannes@cmpxchg.org,
        linux-mm@kvack.org, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [patch 04/15] shmem: shmem_writepage() split unlikely i915 THP
Message-ID: <20200919161847.GN32101@casper.infradead.org>
References: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
 <20200919042009.bomzxmrg7%akpm@linux-foundation.org>
 <20200919044408.GL32101@casper.infradead.org>
 <alpine.LSU.2.11.2009182208210.13525@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2009182208210.13525@eggly.anvils>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 18, 2020 at 10:44:32PM -0700, Hugh Dickins wrote:
> It behaves a lot better with this patch in than without it; but you're
> right, only the head will get written to swap, and the tails left in
> memory; with dirty cleared, so they may be left indefinitely (I've
> not yet looked to see when if ever PageDirty might get set later).
> 
> Hmm. It may just be a matter of restyling the i915 code with
> 
> 		if (!page_mapped(page)) {
> 			clear_page_dirty_for_io(page);
> 
> but I don't want to rush to that conclusion - there might turn
> out to be a good way of doing it at the shmem_writepage() end, but
> probably only hacks available.  I'll mull it over: it deserves some
> thought about what would suit, if a THP arrived here some other way.

I think the ultimate solution is to do as I have done for iomap and make
->writepage handle arbitrary sized pages.  However, I don't know the
swap I/O path particularly well, and I would rather not learn it just yet.

How about this for a band-aid until we sort that out properly?  Just mark
the page as dirty before splitting it so subsequent iterations see the
subpages as dirty.  Arguably, we should use set_page_dirty() instead of
SetPageDirty, but I don't think i915 cares.  In particular, it uses
an untagged iteration instead of searching for PAGECACHE_TAG_DIRTY.

diff --git a/mm/shmem.c b/mm/shmem.c
index 271548ca20f3..6231207ab1eb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1362,8 +1362,21 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 	swp_entry_t swap;
 	pgoff_t index;
 
-	VM_BUG_ON_PAGE(PageCompound(page), page);
 	BUG_ON(!PageLocked(page));
+
+	/*
+	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "force",
+	 * then drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
+	 * and its shmem_writeback() needs them to be split when swapping.
+	 */
+	if (PageTransCompound(page)) {
+		/* Ensure the subpages are still dirty */
+		SetPageDirty(page);
+		if (split_huge_page(page) < 0)
+			goto redirty;
+		ClearPageDirty(page);
+	}
+
 	mapping = page->mapping;
 	index = page->index;
 	inode = mapping->host;

