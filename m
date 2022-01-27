Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9772F49EA0B
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245178AbiA0SLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:11:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48398 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245453AbiA0SLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:11:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21E4861BBE;
        Thu, 27 Jan 2022 18:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86FEC340EA;
        Thu, 27 Jan 2022 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307064;
        bh=GA5eNXgUfM830krmZvOIBK/0Wefb3xbr8kDYvGwxOf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYYhgryN0tZoqOYbZ+5gAqOev+jcOvFiIzXdqVqPW2wux75BwObvLbM3KNnaYphwz
         o4s1iiTGhL/jOgcYkeb30cnCaZxrjtcHCvXv6MMLULxP7+itcAL9tNMPjdiyTtwlEE
         xzaHU6bS8PQq++2pB/eHhS6/FglicDJOuIT5Xwlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Babrou <ivan@cloudflare.com>
Subject: [PATCH 5.15 06/12] memcg: flush stats only if updated
Date:   Thu, 27 Jan 2022 19:09:30 +0100
Message-Id: <20220127180259.289970836@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180259.078563735@linuxfoundation.org>
References: <20220127180259.078563735@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

commit 11192d9c124d58d66449b163ed0d2cdff03761a1 upstream.

At the moment, the kernel flushes the memcg stats on every refault and
also on every reclaim iteration.  Although rstat maintains per-cpu
update tree but on the flush the kernel still has to go through all the
cpu rstat update tree to check if there is anything to flush.  This
patch adds the tracking on the stats update side to make flush side more
clever by skipping the flush if there is no update.

The stats update codepath is very sensitive performance wise for many
workloads and benchmarks.  So, we can not follow what the commit
aa48e47e3906 ("memcg: infrastructure to flush memcg stats") did which
was triggering async flush through queue_work() and caused a lot
performance regression reports.  That got reverted by the commit
1f828223b799 ("memcg: flush lruvec stats in the refault").

In this patch we kept the stats update codepath very minimal and let the
stats reader side to flush the stats only when the updates are over a
specific threshold.  For now the threshold is (nr_cpus * CHARGE_BATCH).

To evaluate the impact of this patch, an 8 GiB tmpfs file is created on
a system with swap-on-zram and the file was pushed to swap through
memory.force_empty interface.  On reading the whole file, the memcg stat
flush in the refault code path is triggered.  With this patch, we
observed 63% reduction in the read time of 8 GiB file.

Link: https://lkml.kernel.org/r/20211001190040.48086-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Reviewed-by: "Michal Koutný" <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   78 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 55 insertions(+), 23 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -103,11 +103,6 @@ static bool do_memsw_account(void)
 	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_noswap;
 }
 
-/* memcg and lruvec stats flushing */
-static void flush_memcg_stats_dwork(struct work_struct *w);
-static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
-static DEFINE_SPINLOCK(stats_flush_lock);
-
 #define THRESHOLDS_EVENTS_TARGET 128
 #define SOFTLIMIT_EVENTS_TARGET 1024
 
@@ -635,6 +630,56 @@ mem_cgroup_largest_soft_limit_node(struc
 	return mz;
 }
 
+/*
+ * memcg and lruvec stats flushing
+ *
+ * Many codepaths leading to stats update or read are performance sensitive and
+ * adding stats flushing in such codepaths is not desirable. So, to optimize the
+ * flushing the kernel does:
+ *
+ * 1) Periodically and asynchronously flush the stats every 2 seconds to not let
+ *    rstat update tree grow unbounded.
+ *
+ * 2) Flush the stats synchronously on reader side only when there are more than
+ *    (MEMCG_CHARGE_BATCH * nr_cpus) update events. Though this optimization
+ *    will let stats be out of sync by atmost (MEMCG_CHARGE_BATCH * nr_cpus) but
+ *    only for 2 seconds due to (1).
+ */
+static void flush_memcg_stats_dwork(struct work_struct *w);
+static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
+static DEFINE_SPINLOCK(stats_flush_lock);
+static DEFINE_PER_CPU(unsigned int, stats_updates);
+static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
+
+static inline void memcg_rstat_updated(struct mem_cgroup *memcg)
+{
+	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	if (!(__this_cpu_inc_return(stats_updates) % MEMCG_CHARGE_BATCH))
+		atomic_inc(&stats_flush_threshold);
+}
+
+static void __mem_cgroup_flush_stats(void)
+{
+	if (!spin_trylock(&stats_flush_lock))
+		return;
+
+	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
+	atomic_set(&stats_flush_threshold, 0);
+	spin_unlock(&stats_flush_lock);
+}
+
+void mem_cgroup_flush_stats(void)
+{
+	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
+		__mem_cgroup_flush_stats();
+}
+
+static void flush_memcg_stats_dwork(struct work_struct *w)
+{
+	mem_cgroup_flush_stats();
+	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
+}
+
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -647,7 +692,7 @@ void __mod_memcg_state(struct mem_cgroup
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	memcg_rstat_updated(memcg);
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -675,10 +720,12 @@ void __mod_memcg_lruvec_state(struct lru
 	memcg = pn->memcg;
 
 	/* Update memcg */
-	__mod_memcg_state(memcg, idx, val);
+	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
 
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
+
+	memcg_rstat_updated(memcg);
 }
 
 /**
@@ -780,7 +827,7 @@ void __count_memcg_events(struct mem_cgr
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	memcg_rstat_updated(memcg);
 }
 
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
@@ -5330,21 +5377,6 @@ static void mem_cgroup_css_reset(struct
 	memcg_wb_domain_size_changed(memcg);
 }
 
-void mem_cgroup_flush_stats(void)
-{
-	if (!spin_trylock(&stats_flush_lock))
-		return;
-
-	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
-	spin_unlock(&stats_flush_lock);
-}
-
-static void flush_memcg_stats_dwork(struct work_struct *w)
-{
-	mem_cgroup_flush_stats();
-	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
-}
-
 static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);


