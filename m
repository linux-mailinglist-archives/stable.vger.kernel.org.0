Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0A249EA1D
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245696AbiA0SMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245297AbiA0SLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:11:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E848DC061755;
        Thu, 27 Jan 2022 10:11:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8939261D21;
        Thu, 27 Jan 2022 18:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CC6C340E8;
        Thu, 27 Jan 2022 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307097;
        bh=NpAgHUFHYKvcWMOdR8Ba/pBoUUaYSLhG8STRhUIzvuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2wG8izJzGaWDiIfgh91MxHNVlHq2/qePau/QDu5ZUBSOa9umF4Ce4TFCmYt7Ida2
         bJAFpdjjphQhwqKXZzV56jbA4LJYr6bgTr+5B8rwabSTvCzrua39tQT39cJHSrO0cK
         IHt+7HkZaw0oXKTB/g6m0OpkU3kjZSVM1+yBWU5c=
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
Subject: [PATCH 5.16 6/9] memcg: better bounds on the memcg stats updates
Date:   Thu, 27 Jan 2022 19:09:41 +0100
Message-Id: <20220127180259.095266393@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
References: <20220127180258.892788582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

commit 5b3be698a872c490dbed524f3e2463701ab21339 upstream.

Commit 11192d9c124d ("memcg: flush stats only if updated") added
tracking of memcg stats updates which is used by the readers to flush
only if the updates are over a certain threshold.  However each
individual update can correspond to a large value change for a given
stat.  For example adding or removing a hugepage to an LRU changes the
stat by thp_nr_pages (512 on x86_64).

Treating the update related to THP as one can keep the stat off, in
theory, by (thp_nr_pages * nr_cpus * CHARGE_BATCH) before flush.

To handle such scenarios, this patch adds consideration of the stat
update value as well instead of just the update event.  In addition let
the asyn flusher unconditionally flush the stats to put time limit on
the stats skew and hopefully a lot less readers would need to flush.

Link: https://lkml.kernel.org/r/20211118065350.697046-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -629,11 +629,17 @@ static DEFINE_SPINLOCK(stats_flush_lock)
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
 
-static inline void memcg_rstat_updated(struct mem_cgroup *memcg)
+static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
+	unsigned int x;
+
 	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
-	if (!(__this_cpu_inc_return(stats_updates) % MEMCG_CHARGE_BATCH))
-		atomic_inc(&stats_flush_threshold);
+
+	x = __this_cpu_add_return(stats_updates, abs(val));
+	if (x > MEMCG_CHARGE_BATCH) {
+		atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
+		__this_cpu_write(stats_updates, 0);
+	}
 }
 
 static void __mem_cgroup_flush_stats(void)
@@ -656,7 +662,7 @@ void mem_cgroup_flush_stats(void)
 
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
-	mem_cgroup_flush_stats();
+	__mem_cgroup_flush_stats();
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
 }
 
@@ -672,7 +678,7 @@ void __mod_memcg_state(struct mem_cgroup
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
-	memcg_rstat_updated(memcg);
+	memcg_rstat_updated(memcg, val);
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
@@ -705,7 +711,7 @@ void __mod_memcg_lruvec_state(struct lru
 	/* Update lruvec */
 	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
 
-	memcg_rstat_updated(memcg);
+	memcg_rstat_updated(memcg, val);
 }
 
 /**
@@ -789,7 +795,7 @@ void __count_memcg_events(struct mem_cgr
 		return;
 
 	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
-	memcg_rstat_updated(memcg);
+	memcg_rstat_updated(memcg, count);
 }
 
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)


