Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D161612575D
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 00:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfLRXFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 18:05:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41964 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726518AbfLRXFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 18:05:09 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIN0q3U006493
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 15:05:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=/aKylL4kU/TwGxGGc+890YHAgP4q9VV8UH8TTP0xIh0=;
 b=V2D0vRCqXifzjedw4JU21MkY3YV4bb2Xpppl8LR9q/1GhRfxYzppjLEDqvoj4uIj7W1o
 DkM0aA+WTAMAU6PO2a5lKVTyMIxQ4fXl2COPkA4PswdxXLN1AoZl6+FLvG0QPCom4fv5
 YVMF9MEWp5rxbPM5haImaMqgWxirfF7qfbk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wykmqk6s7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 18 Dec 2019 15:05:08 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 18 Dec 2019 15:05:06 -0800
Received: by devvm2643.prn2.facebook.com (Postfix, from userid 111017)
        id 4B5491C1D8D17; Wed, 18 Dec 2019 15:05:04 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm2643.prn2.facebook.com
To:     <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
CC:     Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Roman Gushchin <guro@fb.com>, <stable@vger.kernel.org>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH] mm: memcg/slab: fix percpu slab vmstats flushing
Date:   Wed, 18 Dec 2019 15:05:01 -0800
Message-ID: <20191218230501.3858124-1-guro@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=2 priorityscore=1501 malwarescore=0 mlxlogscore=998
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180172
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently slab percpu vmstats are flushed twice: during the memcg
offlining and just before freeing the memcg structure.

Each time percpu counters are summed, added to the atomic counterparts
and propagated up by the cgroup tree.

The problem is that percpu counters are not zeroed after the first
flushing. So every cached percpu value is summed twice. It creates
a small error (up to 32 pages per cpu, but usually less) which
accumulates on parent cgroup level. After creating and destroying
of thousands of child cgroups, slab counter on parent level can
be way off the real value.

For now, let's just stop flushing slab counters on memcg offlining.
It can't be done correctly without scheduling a work on each cpu:
reading and zeroing it during css offlining can race with an
asynchronous update, which doesn't expect values to be changed
underneath.

With this change, slab counters on parent level will become eventually
consistent. Once all dying children are gone, values are correct.
And if not, the error is capped by 32 * NR_CPUS pages per dying
cgroup.

It's not perfect, as slab are reparented, so any updates after
the reparenting will happen on the parent level. It means that
if a slab page was allocated, a counter on child level was bumped,
then the page was reparented and freed, the annihilation of positive
and negative counter values will not happen until the child cgroup is
released. It makes slab counters different from others, and it might
want us to implement flushing in a correct form again.
But it's also a question of performance: scheduling a work on each
cpu isn't free, and it's an open question if the benefit of having
more accurate counters is worth it.

We might also consider flushing all counters on offlining, not only
slab counters.

So let's fix the main problem now: make the slab counters eventually
consistent, so at least the error won't grow with uptime (or more
precisely the number of created and destroyed cgroups). And think
about the accuracy of counters separately.

Signed-off-by: Roman Gushchin <guro@fb.com>
Fixes: bee07b33db78 ("mm: memcontrol: flush percpu slab vmstats on kmem offlining")
Cc: stable@vger.kernel.org
---
 include/linux/mmzone.h |  5 ++---
 mm/memcontrol.c        | 37 +++++++++----------------------------
 2 files changed, 11 insertions(+), 31 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 89d8ff06c9ce..5334ad8fc7bd 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -215,9 +215,8 @@ enum node_stat_item {
 	NR_INACTIVE_FILE,	/*  "     "     "   "       "         */
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
 	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
-	NR_SLAB_RECLAIMABLE,	/* Please do not reorder this item */
-	NR_SLAB_UNRECLAIMABLE,	/* and this one without looking at
-				 * memcg_flush_percpu_vmstats() first. */
+	NR_SLAB_RECLAIMABLE,
+	NR_SLAB_UNRECLAIMABLE,
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	WORKINGSET_NODES,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 601405b207fb..3165db39827a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3287,49 +3287,34 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 	}
 }
 
-static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg, bool slab_only)
+static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg)
 {
-	unsigned long stat[MEMCG_NR_STAT];
+	unsigned long stat[MEMCG_NR_STAT] = {0};
 	struct mem_cgroup *mi;
 	int node, cpu, i;
-	int min_idx, max_idx;
-
-	if (slab_only) {
-		min_idx = NR_SLAB_RECLAIMABLE;
-		max_idx = NR_SLAB_UNRECLAIMABLE;
-	} else {
-		min_idx = 0;
-		max_idx = MEMCG_NR_STAT;
-	}
-
-	for (i = min_idx; i < max_idx; i++)
-		stat[i] = 0;
 
 	for_each_online_cpu(cpu)
-		for (i = min_idx; i < max_idx; i++)
+		for (i = 0; i < MEMCG_NR_STAT; i++)
 			stat[i] += per_cpu(memcg->vmstats_percpu->stat[i], cpu);
 
 	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
-		for (i = min_idx; i < max_idx; i++)
+		for (i = 0; i < MEMCG_NR_STAT; i++)
 			atomic_long_add(stat[i], &mi->vmstats[i]);
 
-	if (!slab_only)
-		max_idx = NR_VM_NODE_STAT_ITEMS;
-
 	for_each_node(node) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
 		struct mem_cgroup_per_node *pi;
 
-		for (i = min_idx; i < max_idx; i++)
+		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 			stat[i] = 0;
 
 		for_each_online_cpu(cpu)
-			for (i = min_idx; i < max_idx; i++)
+			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 				stat[i] += per_cpu(
 					pn->lruvec_stat_cpu->count[i], cpu);
 
 		for (pi = pn; pi; pi = parent_nodeinfo(pi, node))
-			for (i = min_idx; i < max_idx; i++)
+			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 				atomic_long_add(stat[i], &pi->lruvec_stat[i]);
 	}
 }
@@ -3403,13 +3388,9 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 		parent = root_mem_cgroup;
 
 	/*
-	 * Deactivate and reparent kmem_caches. Then flush percpu
-	 * slab statistics to have precise values at the parent and
-	 * all ancestor levels. It's required to keep slab stats
-	 * accurate after the reparenting of kmem_caches.
+	 * Deactivate and reparent kmem_caches.
 	 */
 	memcg_deactivate_kmem_caches(memcg, parent);
-	memcg_flush_percpu_vmstats(memcg, true);
 
 	kmemcg_id = memcg->kmemcg_id;
 	BUG_ON(kmemcg_id < 0);
@@ -4913,7 +4894,7 @@ static void mem_cgroup_free(struct mem_cgroup *memcg)
 	 * Flush percpu vmstats and vmevents to guarantee the value correctness
 	 * on parent's and all ancestor levels.
 	 */
-	memcg_flush_percpu_vmstats(memcg, false);
+	memcg_flush_percpu_vmstats(memcg);
 	memcg_flush_percpu_vmevents(memcg);
 	__mem_cgroup_free(memcg);
 }
-- 
2.17.1

