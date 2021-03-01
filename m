Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B31E3291AD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242264AbhCAUaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:30:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243307AbhCAUXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:23:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 482B26504E;
        Mon,  1 Mar 2021 18:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621943;
        bh=TgQidPWdU1tn64DHfTIhKIJzP+NSV1Ilb/6NV4j1/94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+qulaLbiwynzJ8f+dlZ3BfXMmbKgblkcPjEy+j9s/6fGAC2HjD/x+Bcrg+dVaiQ1
         QlI1WK0qQvVJzMH5f8AZOANz8xu4lg/NSMqCK8rFxqFGYCuTxXpFXCz1jZbwMqRF4c
         e4rDiB5rsdiiJ3aksubkftgm7ns+NhiDQeb0IJdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 701/775] mm: memcontrol: fix swap undercounting in cgroup2
Date:   Mon,  1 Mar 2021 17:14:29 +0100
Message-Id: <20210301161236.012063726@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

commit cae3af62b33aa931427a0f211e04347b22180b36 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6758,7 +6758,19 @@ int mem_cgroup_charge(struct page *page,
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


