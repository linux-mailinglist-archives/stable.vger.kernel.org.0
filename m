Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C199381C6D
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730866AbfHENXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730858AbfHENXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:23:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 293F221880;
        Mon,  5 Aug 2019 13:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011416;
        bh=8uCq6Hog5rSLXya+/nTvcvv2RE/+H2+vXoQZB/KOLes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BCtQaIzodfI8jEbOZRiaI53O16daspKgrsG+GfLcdlpYjW/HiVPOA7jbYq+RJtvOJ
         +ZKEz8SmzwjiK1tKlbUdwQRU4IqTPQpc88XiJrP3zP+6ktpjufuK9DeziSvVH0JM29
         JRk+1cPMRsSFN6tLElk8bC/KvSNUhpJ9JsGAm2JE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Yafang Shao <shaoyafang@didiglobal.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 049/131] mm/memcontrol.c: keep local VM counters in sync with the hierarchical ones
Date:   Mon,  5 Aug 2019 15:02:16 +0200
Message-Id: <20190805124954.714867980@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 591eafafbd8cb..902d020aa70e5 100644
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



