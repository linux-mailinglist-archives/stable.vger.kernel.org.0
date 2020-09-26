Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9B7279613
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 03:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbgIZB5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 21:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727495AbgIZB5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 21:57:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0143207EA;
        Sat, 26 Sep 2020 01:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085474;
        bh=nNYXXG8CmdNa0dataxSs+WwxzEM65kjutU3uMb9U8ig=;
        h=Date:From:To:Subject:From;
        b=uW1B19QLqbQl6fqD3reNrfOGMZIWsWOY3rbDDYsAs3NLzyVLCuYJpvAu/zAMxR7Ca
         P8q+aS1QuHSBqHnSxaccxdAXx5A3yuwcDVYVSdHKmOZ8zEl/UU5Fz9e1ugFCBJiBcW
         tElk/UM+b6+LIEA7BWAHUdyG/ft3eCGJBt1Eq1S4=
Date:   Fri, 25 Sep 2020 18:57:53 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, cai@lca.pw, hannes@cmpxchg.org,
        hughd@google.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org
Subject:  [merged] ksm-reinstate-memcg-charge-on-copied-pages.patch
 removed from -mm tree
Message-ID: <20200926015753.jM6OK4VA3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ksm: reinstate memcg charge on copied pages
has been removed from the -mm tree.  Its filename was
     ksm-reinstate-memcg-charge-on-copied-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: ksm: reinstate memcg charge on copied pages

Patch series "mm: fixes to past from future testing".

Here's a set of independent fixes against 5.9-rc2: prompted by
testing Alex Shi's "warning on !memcg" and lru_lock series, but
I think fit for 5.9 - though maybe only the first for stable.


This patch (of 5):

In 5.8 some instances of memcg charging in do_swap_page() and unuse_pte()
were removed, on the understanding that swap cache is now already charged
at those points; but a case was missed, when ksm_might_need_to_copy() has
decided it must allocate a substitute page: such pages were never charged.
Fix it inside ksm_might_need_to_copy().

This was discovered by Alex Shi's prospective commit "mm/memcg: warning on
!memcg after readahead page charged".

But there is a another surprise: this also fixes some rarer uncharged
PageAnon cases, when KSM is configured in, but has never been activated. 
ksm_might_need_to_copy()'s anon_vma->root and linear_page_index() check
sometimes catches a case which would need to have been copied if KSM were
turned on.  Or that's my optimistic interpretation (of my own old code),
but it leaves some doubt as to whether everything is working as intended
there - might it hint at rare anon ptes which rmap cannot find?  A
question not easily answered: put in the fix for missed memcg charges.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008301343270.5954@eggly.anvils
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008301358020.5954@eggly.anvils
Fixes: 4c6355b25e8b ("mm: memcontrol: charge swapin pages on instantiation")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc; Matthew Wilcox <willy@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>	[5.8]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/ksm.c~ksm-reinstate-memcg-charge-on-copied-pages
+++ a/mm/ksm.c
@@ -2586,6 +2586,10 @@ struct page *ksm_might_need_to_copy(stru
 		return page;		/* let do_swap_page report the error */
 
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+	if (new_page && mem_cgroup_charge(new_page, vma->vm_mm, GFP_KERNEL)) {
+		put_page(new_page);
+		new_page = NULL;
+	}
 	if (new_page) {
 		copy_user_highpage(new_page, page, address, vma);
 
_

Patches currently in -mm which might be from hughd@google.com are


