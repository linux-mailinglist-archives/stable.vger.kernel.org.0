Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB1325718D
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 03:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgHaBaV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Aug 2020 21:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgHaBaS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 30 Aug 2020 21:30:18 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F7342083E;
        Mon, 31 Aug 2020 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598837416;
        bh=tXrdeQ4c9FK/eBaFb0IIgUuq5v0Zmpp7DiYa9wGHUKc=;
        h=Date:From:To:Subject:From;
        b=ZlrZNkmhvPfPt0Ky5PrS01eqUM5apt0XqgBTuMnkkHypKESIpO5acwtNIog1bIfbc
         rNjvWCAd2N+TY7XZoCNwXbqgDeYEBkkcyhWDZI82RKf6oXKWWxWGrAQDStMELjgyEu
         3A7ZGc6PEjr5sBkMzxyZ2G2ppHFZuJyllikG2svE=
Date:   Sun, 30 Aug 2020 18:30:15 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shakeelb@google.com, mike.kravetz@oracle.com, mhocko@suse.com,
        hannes@cmpxchg.org, cai@lca.pw, alex.shi@linux.alibaba.com,
        hughd@google.com
Subject:  + ksm-reinstate-memcg-charge-on-copied-pages.patch added to
 -mm tree
Message-ID: <20200831013015.pdk_j%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: ksm: reinstate memcg charge on copied pages
has been added to the -mm tree.  Its filename is
     ksm-reinstate-memcg-charge-on-copied-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ksm-reinstate-memcg-charge-on-copied-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ksm-reinstate-memcg-charge-on-copied-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shakeel Butt <shakeelb@google.com>
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

ksm-reinstate-memcg-charge-on-copied-pages.patch
mm-migration-of-hugetlbfs-page-skip-memcg.patch
shmem-shmem_writepage-split-unlikely-i915-thp.patch
mm-fix-check_move_unevictable_pages-on-thp.patch
mlock-fix-unevictable_pgs-event-counts-on-thp.patch

