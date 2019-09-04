Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE627A913F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390756AbfIDSOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389453AbfIDSOV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:14:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B4EB22CF7;
        Wed,  4 Sep 2019 18:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620860;
        bh=QiiWuGcgOjRZ/srI8+ia0peu/RvqTW7WEzFTV7LwK2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8nQ2EfQj4U0y30WV8ndFenN+Z0q0Gj/h906XDFW3f589s8vz1M1XmVcmHwYfd9eY
         1q1xNaFYB3whMG1mhweHjFiQYHQJddtiZW8z2SOvK0KCESKI/Q8Ry/dKe4hrHSgJCU
         QpoM0bK1ZT4nsXqS5h6rZitVZCT1R5LploQsWwSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 122/143] mm, memcg: partially revert "mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones"
Date:   Wed,  4 Sep 2019 19:54:25 +0200
Message-Id: <20190904175319.173967594@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit b4c46484dc3fa3721d68fdfae85c1d7b1f6b5472 upstream.

Commit 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync
with the hierarchical ones") effectively decreased the precision of
per-memcg vmstats_local and per-memcg-per-node lruvec percpu counters.

That's good for displaying in memory.stat, but brings a serious
regression into the reclaim process.

One issue I've discovered and debugged is the following:
lruvec_lru_size() can return 0 instead of the actual number of pages in
the lru list, preventing the kernel to reclaim last remaining pages.
Result is yet another dying memory cgroups flooding.  The opposite is
also happening: scanning an empty lru list is the waste of cpu time.

Also, inactive_list_is_low() can return incorrect values, preventing the
active lru from being scanned and freed.  It can fail both because the
size of active and inactive lists are inaccurate, and because the number
of workingset refaults isn't precise.  In other words, the result is
pretty random.

I'm not sure, if using the approximate number of slab pages in
count_shadow_number() is acceptable, but issues described above are
enough to partially revert the patch.

Let's keep per-memcg vmstat_local batched (they are only used for
displaying stats to the userspace), but keep lruvec stats precise.  This
change fixes the dead memcg flooding on my setup.

Link: http://lkml.kernel.org/r/20190817004726.2530670-1-guro@fb.com
Fixes: 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones")
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -748,15 +748,13 @@ void __mod_lruvec_state(struct lruvec *l
 	/* Update memcg */
 	__mod_memcg_state(memcg, idx, val);
 
+	/* Update lruvec */
+	__this_cpu_add(pn->lruvec_stat_local->count[idx], val);
+
 	x = val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
 	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
 		struct mem_cgroup_per_node *pi;
 
-		/*
-		 * Batch local counters to keep them in sync with
-		 * the hierarchical ones.
-		 */
-		__this_cpu_add(pn->lruvec_stat_local->count[idx], x);
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, pgdat->node_id))
 			atomic_long_add(x, &pi->lruvec_stat[idx]);
 		x = 0;


