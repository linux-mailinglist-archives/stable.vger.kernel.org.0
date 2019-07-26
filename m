Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6E176A48
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfGZNlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbfGZNlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:41:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 935C122CD5;
        Fri, 26 Jul 2019 13:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148459;
        bh=kL3mlcYcc+Q9jAb4Pl1atYrXYmTb6HeWN92nUpHLk3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fw6HTIlJ+dAqBanjdLDnU16zhOoRdqUtIylBtdNW2WzzF5FvL2Cx8vuj8jhqG1j9M
         M3B+u6aLF4Gk3rzzT/VYncTazb8cwYNb5xdX3nivM5JTBdyB7WLV2x2rmt8R/F2hxY
         U7BmMX8rV2rgejZsHmQ2yjPpYzbhRRGaDk4MvuHs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yafang Shao <laoar.shao@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Yafang Shao <shaoyafang@didiglobal.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.2 52/85] mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones
Date:   Fri, 26 Jul 2019 09:39:02 -0400
Message-Id: <20190726133936.11177-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 766a4c19d880887c457811b86f1f68525e416965 ]

After commit 815744d75152 ("mm: memcontrol: don't batch updates of local
VM stats and events"), the local VM counter are not in sync with the
hierarchical ones.

Below is one example in a leaf memcg on my server (with 8 CPUs):

	inactive_file 3567570944
	total_inactive_file 3568029696

We find that the deviation is very great because the 'val' in
__mod_memcg_state() is in pages while the effective value in
memcg_stat_show() is in bytes.

So the maximum of this deviation between local VM stats and total VM
stats can be (32 * number_of_cpu * PAGE_SIZE), that may be an
unacceptably great value.

We should keep the local VM stats in sync with the total stats.  In
order to keep this behavior the same across counters, this patch updates
__mod_lruvec_state() and __count_memcg_events() as well.

Link: http://lkml.kernel.org/r/1562851979-10610-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yafang Shao <shaoyafang@didiglobal.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ba9138a4a1de..07b4ca559bcc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -691,12 +691,15 @@ void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
 	if (mem_cgroup_disabled())
 		return;
 
-	__this_cpu_add(memcg->vmstats_local->stat[idx], val);
-
 	x = val + __this_cpu_read(memcg->vmstats_percpu->stat[idx]);
 	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
 		struct mem_cgroup *mi;
 
+		/*
+		 * Batch local counters to keep them in sync with
+		 * the hierarchical ones.
+		 */
+		__this_cpu_add(memcg->vmstats_local->stat[idx], x);
 		for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
 			atomic_long_add(x, &mi->vmstats[idx]);
 		x = 0;
@@ -745,13 +748,15 @@ void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 	/* Update memcg */
 	__mod_memcg_state(memcg, idx, val);
 
-	/* Update lruvec */
-	__this_cpu_add(pn->lruvec_stat_local->count[idx], val);
-
 	x = val + __this_cpu_read(pn->lruvec_stat_cpu->count[idx]);
 	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
 		struct mem_cgroup_per_node *pi;
 
+		/*
+		 * Batch local counters to keep them in sync with
+		 * the hierarchical ones.
+		 */
+		__this_cpu_add(pn->lruvec_stat_local->count[idx], x);
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, pgdat->node_id))
 			atomic_long_add(x, &pi->lruvec_stat[idx]);
 		x = 0;
@@ -773,12 +778,15 @@ void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 	if (mem_cgroup_disabled())
 		return;
 
-	__this_cpu_add(memcg->vmstats_local->events[idx], count);
-
 	x = count + __this_cpu_read(memcg->vmstats_percpu->events[idx]);
 	if (unlikely(x > MEMCG_CHARGE_BATCH)) {
 		struct mem_cgroup *mi;
 
+		/*
+		 * Batch local counters to keep them in sync with
+		 * the hierarchical ones.
+		 */
+		__this_cpu_add(memcg->vmstats_local->events[idx], x);
 		for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
 			atomic_long_add(x, &mi->vmevents[idx]);
 		x = 0;
-- 
2.20.1

