Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A1531DF9E
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 20:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhBQT10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 14:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233081AbhBQT1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 14:27:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0759364E45;
        Wed, 17 Feb 2021 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613589994;
        bh=twsFY5FBxWU1xZqz55d+iXQ5jRZ62RMUP+TY4TWcJGI=;
        h=Date:From:To:Subject:From;
        b=Jn8+u13/H6De+rF+6NF1LZ3vCBCrIMJHSMG94L7TDylJr15XV5WaYkKOOEtLBeJm1
         LvE+SCWirSV/fX7MHGFMJgPIBTe18SDJ0ai2WIVE6er37uZlT3L4It4c4RyVnnZrkU
         zVAlMComSufZoNZVN158SENFYcnUYRywn4qTX7Jg=
Date:   Wed, 17 Feb 2021 11:26:33 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        stable@vger.kernel.org, shakeelb@google.com, mhocko@suse.com,
        hannes@cmpxchg.org, songmuchun@bytedance.com
Subject:  + mm-memcontrol-fix-swap-undercounting-in-cgroup2.patch
 added to -mm tree
Message-ID: <20210217192633.mIbD0%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix swap undercounting in cgroup2
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-swap-undercounting-in-cgroup2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-swap-undercounting-in-cgroup2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-swap-undercounting-in-cgroup2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix swap undercounting in cgroup2

When pages are swapped in, the VM may retain the swap copy to avoid
repeated writes in the future.  It's also retained if shared pages are
faulted back in some processes, but not in others.  During that time we
have an in-memory copy of the page, as well as an on-swap copy.  Cgroup1
and cgroup2 handle these overlapping lifetimes slightly differently due to
the nature of how they account memory and swap:

Cgroup1 has a unified memory+swap counter that tracks a data page
regardless whether it's in-core or swapped out.  On swapin, we transfer
the charge from the swap entry to the newly allocated swapcache page, even
though the swap entry might stick around for a while.  That's why we have
a mem_cgroup_uncharge_swap() call inside mem_cgroup_charge().

Cgroup2 tracks memory and swap as separate, independent resources and thus
has split memory and swap counters.  On swapin, we charge the newly
allocated swapcache page as memory, while the swap slot in turn must
remain charged to the swap counter as long as its allocated too.

The cgroup2 logic was broken by commit 2d1c498072de ("mm: memcontrol: make
swap tracking an integral part of memory control"), because it
accidentally removed the do_memsw_account() check in the branch inside
mem_cgroup_uncharge() that was supposed to tell the difference between the
charge transfer in cgroup1 and the separate counters in cgroup2.

As a result, cgroup2 currently undercounts retained swap to varying
degrees: swap slots are cached up to 50% of the configured limit or total
available swap space; partially faulted back shared pages are only limited
by physical capacity.  This in turn allows cgroups to significantly
overconsume their alloted swap space.

Add the do_memsw_account() check back to fix this problem.

Link: https://lkml.kernel.org/r/20210217153237.92484-1-songmuchun@bytedance.com
Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>	[5.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-swap-undercounting-in-cgroup2
+++ a/mm/memcontrol.c
@@ -6748,7 +6748,19 @@ int mem_cgroup_charge(struct page *page,
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 
-	if (PageSwapCache(page)) {
+	/*
+	 * Cgroup1's unified memory+swap counter has been charged with the
+	 * new swapcache page, finish the transfer by uncharging the swap
+	 * slot. The swap slot would also get uncharged when it dies, but
+	 * it can stick around indefinitely and we'd count the page twice
+	 * the entire time.
+	 *
+	 * Cgroup2 has separate resource counters for memory and swap,
+	 * so this is a non-issue here. Memory and swap charge lifetimes
+	 * correspond 1:1 to page and swap slot lifetimes: we charge the
+	 * page to memory here, and uncharge swap when the slot is freed.
+	 */
+	if (do_memsw_account() && PageSwapCache(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 		/*
 		 * The swap entry might not get freed for a long time,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage.patch
mm-memcontrol-fix-nr_anon_thps-accounting-in-charge-moving.patch
mm-memcontrol-convert-nr_anon_thps-account-to-pages.patch
mm-memcontrol-convert-nr_file_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_thps-account-to-pages.patch
mm-memcontrol-convert-nr_shmem_pmdmapped-account-to-pages.patch
mm-memcontrol-convert-nr_file_pmdmapped-account-to-pages.patch
mm-memcontrol-make-the-slab-calculation-consistent.patch
mm-memcontrol-replace-the-loop-with-a-list_for_each_entry.patch
mm-memcontrol-fix-swap-undercounting-in-cgroup2.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag-fix.patch

