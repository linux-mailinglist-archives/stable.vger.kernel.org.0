Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E8250F628
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbiDZIwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347311AbiDZIvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:51:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5413263DA;
        Tue, 26 Apr 2022 01:40:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C689260EC3;
        Tue, 26 Apr 2022 08:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D9EC385A0;
        Tue, 26 Apr 2022 08:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962408;
        bh=C+Emsd2dvUZs4sS+uJikxoTnvtK6V3iRkCJ7myLYyI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RDUttGCxQCtc2DUIfYhTDL4YlzQ7U7PaT8piZ5prXDb+VVkqZgzvlxDbEKZXNFwyZ
         xFW/PQYvGxoGuF70RZu2c/TAxUWTaqFHtBRG4p6uHgaGhCFa44O/dCUDj+SXIzVRes
         fb/SfJHvfFY2Izz4nvHeqsRdG16AHvMbjyYNs9Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Daniel Dao <dqminh@cloudflare.com>,
        Ivan Babrou <ivan@cloudflare.com>,
        Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 079/124] memcg: sync flush only if periodic flush is delayed
Date:   Tue, 26 Apr 2022 10:21:20 +0200
Message-Id: <20220426081749.546421968@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

commit 9b3016154c913b2e7ec5ae5c9a42eb9e732d86aa upstream.

Daniel Dao has reported [1] a regression on workloads that may trigger a
lot of refaults (anon and file).  The underlying issue is that flushing
rstat is expensive.  Although rstat flush are batched with (nr_cpus *
MEMCG_BATCH) stat updates, it seems like there are workloads which
genuinely do stat updates larger than batch value within short amount of
time.  Since the rstat flush can happen in the performance critical
codepaths like page faults, such workload can suffer greatly.

This patch fixes this regression by making the rstat flushing
conditional in the performance critical codepaths.  More specifically,
the kernel relies on the async periodic rstat flusher to flush the stats
and only if the periodic flusher is delayed by more than twice the
amount of its normal time window then the kernel allows rstat flushing
from the performance critical codepaths.

Now the question: what are the side-effects of this change? The worst
that can happen is the refault codepath will see 4sec old lruvec stats
and may cause false (or missed) activations of the refaulted page which
may under-or-overestimate the workingset size.  Though that is not very
concerning as the kernel can already miss or do false activations.

There are two more codepaths whose flushing behavior is not changed by
this patch and we may need to come to them in future.  One is the
writeback stats used by dirty throttling and second is the deactivation
heuristic in the reclaim.  For now keeping an eye on them and if there
is report of regression due to these codepaths, we will reevaluate then.

Link: https://lore.kernel.org/all/CA+wXwBSyO87ZX5PVwdHm-=dBjZYECGmfnydUicUyrQqndgX2MQ@mail.gmail.com [1]
Link: https://lkml.kernel.org/r/20220304184040.1304781-1-shakeelb@google.com
Fixes: 1f828223b799 ("memcg: flush lruvec stats in the refault")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Daniel Dao <dqminh@cloudflare.com>
Tested-by: Ivan Babrou <ivan@cloudflare.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Frank Hofmann <fhofmann@cloudflare.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/memcontrol.h |    5 +++++
 mm/memcontrol.c            |   12 +++++++++++-
 mm/workingset.c            |    2 +-
 3 files changed, 17 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1002,6 +1002,7 @@ static inline unsigned long lruvec_page_
 }
 
 void mem_cgroup_flush_stats(void);
+void mem_cgroup_flush_stats_delayed(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1422,6 +1423,10 @@ static inline void mem_cgroup_flush_stat
 {
 }
 
+static inline void mem_cgroup_flush_stats_delayed(void)
+{
+}
+
 static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
 					    enum node_stat_item idx, int val)
 {
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -650,6 +650,9 @@ static DECLARE_DEFERRABLE_WORK(stats_flu
 static DEFINE_SPINLOCK(stats_flush_lock);
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
+static u64 flush_next_time;
+
+#define FLUSH_TIME (2UL*HZ)
 
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
@@ -671,6 +674,7 @@ static void __mem_cgroup_flush_stats(voi
 	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
 		return;
 
+	flush_next_time = jiffies_64 + 2*FLUSH_TIME;
 	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
 	spin_unlock_irqrestore(&stats_flush_lock, flag);
@@ -682,10 +686,16 @@ void mem_cgroup_flush_stats(void)
 		__mem_cgroup_flush_stats();
 }
 
+void mem_cgroup_flush_stats_delayed(void)
+{
+	if (time_after64(jiffies_64, flush_next_time))
+		mem_cgroup_flush_stats();
+}
+
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	__mem_cgroup_flush_stats();
-	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
+	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
 /**
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -352,7 +352,7 @@ void workingset_refault(struct page *pag
 
 	inc_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_delayed();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if


