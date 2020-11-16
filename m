Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A8D2B54AD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 00:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgKPW7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 17:59:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgKPW7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Nov 2020 17:59:47 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E89FA22453;
        Mon, 16 Nov 2020 22:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605567586;
        bh=ESAEEXir2XEKWdthDUOJ4zzzojBGvBb9FflN6dpLUm8=;
        h=Date:From:To:Subject:From;
        b=k7m7PA5Yp1koFy9gXF22xFkBitkcEqIyF9dtr5YtllDcCx6rh3Zi9LtDckTSo8/E+
         m6uLQ3znWjIDFsK1uRzW1Tc7etuTBB8CLx54Mhla365y3KcofwAfm2uVd5JG1r+TSa
         v/zV3b6QSjT8KlFsWsYo8ZLWyh/g3667UATlfMPA=
Date:   Mon, 16 Nov 2020 14:59:45 -0800
From:   akpm@linux-foundation.org
To:     aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        davem@davemloft.net, dongli.zhang@oracle.com, edumazet@google.com,
        joe.jin@oracle.com, manjunath.b.patil@oracle.com,
        mm-commits@vger.kernel.org, rama.nichanamatlu@oracle.com,
        srinivas.eeda@oracle.com, stable@vger.kernel.org, vbabka@suse.cz,
        venkat.x.venkatsubra@oracle.com, willy@infradead.org
Subject:  + page_frag-recover-from-memory-pressure.patch added to
 -mm tree
Message-ID: <20201116225945.HWjwagBNS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, page_frag: recover from memory pressure
has been added to the -mm tree.  Its filename is
     page_frag-recover-from-memory-pressure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/page_frag-recover-from-memory-pressure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/page_frag-recover-from-memory-pressure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: mm, page_frag: recover from memory pressure

The ethernet driver may allocate skb (and skb->data) via napi_alloc_skb().
This ends up to page_frag_alloc() to allocate skb->data from
page_frag_cache->va.

During the memory pressure, page_frag_cache->va may be allocated as
pfmemalloc page.  As a result, the skb->pfmemalloc is always true as
skb->data is from page_frag_cache->va.  The skb will be dropped if the
sock (receiver) does not have SOCK_MEMALLOC.  This is expected behaviour
under memory pressure.

However, once kernel is not under memory pressure any longer (suppose
large amount of memory pages are just reclaimed), the page_frag_alloc()
may still re-use the prior pfmemalloc page_frag_cache->va to allocate
skb->data.  As a result, the skb->pfmemalloc is always true unless
page_frag_cache->va is re-allocated, even if the kernel is not under
memory pressure any longer.

Here is how kernel runs into issue.

1. The kernel is under memory pressure and allocation of
   PAGE_FRAG_CACHE_MAX_ORDER in __page_frag_cache_refill() will fail. 
   Instead, the pfmemalloc page is allocated for page_frag_cache->va.

2. All skb->data from page_frag_cache->va (pfmemalloc) will have
   skb->pfmemalloc=true.  The skb will always be dropped by sock without
   SOCK_MEMALLOC.  This is an expected behaviour.

3. Suppose a large amount of pages are reclaimed and kernel is not
   under memory pressure any longer.  We expect skb->pfmemalloc drop will
   not happen.

4. Unfortunately, page_frag_alloc() does not proactively re-allocate
   page_frag_alloc->va and will always re-use the prior pfmemalloc page. 
   The skb->pfmemalloc is always true even kernel is not under memory
   pressure any longer.

Fix this by freeing and re-allocating the page instead of recycling it.

Link: https://lore.kernel.org/lkml/20201103193239.1807-1-dongli.zhang@oracle.com/
Link: https://lore.kernel.org/linux-mm/20201105042140.5253-1-willy@infradead.org/
Link: https://lkml.kernel.org/r/20201115201029.11903-1-dongli.zhang@oracle.com
Fixes: 79930f5892e ("net: do not deplete pfmemalloc reserve")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Bert Barbe <bert.barbe@oracle.com>
Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: SRINIVAS <srinivas.eeda@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c~page_frag-recover-from-memory-pressure
+++ a/mm/page_alloc.c
@@ -5103,6 +5103,11 @@ refill:
 		if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
 			goto refill;
 
+		if (unlikely(nc->pfmemalloc)) {
+			free_the_page(page, compound_order(page));
+			goto refill;
+		}
+
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
 		/* if size can vary use size else just use PAGE_SIZE */
 		size = nc->size;
_

Patches currently in -mm which might be from dongli.zhang@oracle.com are

page_frag-recover-from-memory-pressure.patch

