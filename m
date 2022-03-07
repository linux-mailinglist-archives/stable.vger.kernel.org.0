Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9888F4CF07E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 04:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiCGDnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Mar 2022 22:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiCGDnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Mar 2022 22:43:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDD56548;
        Sun,  6 Mar 2022 19:42:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 891D260F7D;
        Mon,  7 Mar 2022 03:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2D6C340F3;
        Mon,  7 Mar 2022 03:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646624557;
        bh=dlxNltCGxYkiCNG9Z7OiUhRYJzwO3keptp1KXilohZc=;
        h=Date:To:From:Subject:From;
        b=W5LBlfG0gqn9DNyX18AABgC4xH5OFzp2Vje3bTkgKBhbaPIEx1arz/wzaG1lm1IcH
         9R6tx0jtGm5LPL0fd0U5CWIuimzT4zueISDTi28l5TDnspXQyFW4UOMsKX0apeIJS/
         HfaJ8nU1tq2sOH3Lhw/RFn+GBMH1FioVeTk0onKs=
Date:   Sun, 06 Mar 2022 19:42:36 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        roman.gushchin@linux.dev, mkoutny@suse.com, mhocko@suse.com,
        ivan@cloudflare.com, hannes@cmpxchg.org, fhofmann@cloudflare.com,
        dqminh@cloudflare.com, shakeelb@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-sync-flush-only-if-periodic-flush-is-delayed.patch added to -mm tree
Message-Id: <20220307034236.DC2D6C340F3@smtp.kernel.org>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: memcg: sync flush only if periodic flush is delayed
has been added to the -mm tree.  Its filename is
     memcg-sync-flush-only-if-periodic-flush-is-delayed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-sync-flush-only-if-periodic-flush-is-delayed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-sync-flush-only-if-periodic-flush-is-delayed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: sync flush only if periodic flush is delayed

Daniel Dao has reported [1] a regression on workloads that may trigger a
lot of refaults (anon and file).  The underlying issue is that flushing
rstat is expensive.  Although rstat flush are batched with (nr_cpus *
MEMCG_BATCH) stat updates, it seems like there are workloads which
genuinely do stat updates larger than batch value within short amount of
time.  Since the rstat flush can happen in the performance critical
codepaths like page faults, such workload can suffer greatly.

This patch fixes this regression by making the rstat flushing conditional
in the performance critical codepaths.  More specifically, the kernel
relies on the async periodic rstat flusher to flush the stats and only if
the periodic flusher is delayed by more than twice the amount of its
normal time window then the kernel allows rstat flushing from the
performance critical codepaths.

Now the question: what are the side-effects of this change?  The worst
that can happen is the refault codepath will see 4sec old lruvec stats and
may cause false (or missed) activations of the refaulted page which may
under-or-overestimate the workingset size.  Though that is not very
concerning as the kernel can already miss or do false activations.

There are two more codepaths whose flushing behavior is not changed by
this patch and we may need to come to them in future.  One is the
writeback stats used by dirty throttling and second is the deactivation
heuristic in the reclaim.  For now keeping an eye on them and if there is
report of regression due to these codepaths, we will reevaluate then.

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
---

 include/linux/memcontrol.h |    5 +++++
 mm/memcontrol.c            |   12 +++++++++++-
 mm/workingset.c            |    2 +-
 3 files changed, 17 insertions(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~memcg-sync-flush-only-if-periodic-flush-is-delayed
+++ a/include/linux/memcontrol.h
@@ -999,6 +999,7 @@ static inline unsigned long lruvec_page_
 }
 
 void mem_cgroup_flush_stats(void);
+void mem_cgroup_flush_stats_delayed(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1442,6 +1443,10 @@ static inline void mem_cgroup_flush_stat
 {
 }
 
+static inline void mem_cgroup_flush_stats_delayed(void)
+{
+}
+
 static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
 					    enum node_stat_item idx, int val)
 {
--- a/mm/memcontrol.c~memcg-sync-flush-only-if-periodic-flush-is-delayed
+++ a/mm/memcontrol.c
@@ -628,6 +628,9 @@ static DECLARE_DEFERRABLE_WORK(stats_flu
 static DEFINE_SPINLOCK(stats_flush_lock);
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
+static u64 flush_next_time;
+
+#define FLUSH_TIME (2UL*HZ)
 
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
@@ -649,6 +652,7 @@ static void __mem_cgroup_flush_stats(voi
 	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
 		return;
 
+	flush_next_time = jiffies_64 + 2*FLUSH_TIME;
 	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
 	spin_unlock_irqrestore(&stats_flush_lock, flag);
@@ -660,10 +664,16 @@ void mem_cgroup_flush_stats(void)
 		__mem_cgroup_flush_stats();
 }
 
+void mem_cgroup_flush_stats_delayed(void)
+{
+	if (rstat_flush_time && time_after64(jiffies_64, flush_next_time))
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
--- a/mm/workingset.c~memcg-sync-flush-only-if-periodic-flush-is-delayed
+++ a/mm/workingset.c
@@ -354,7 +354,7 @@ void workingset_refault(struct folio *fo
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_delayed();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-sync-flush-only-if-periodic-flush-is-delayed.patch
memcg-replace-in_interrupt-with-in_task.patch
memcg-refactor-mem_cgroup_oom.patch
memcg-unify-force-charging-conditions.patch
selftests-memcg-test-high-limit-for-single-entry-allocation.patch
memcg-synchronously-enforce-memoryhigh-for-large-overcharges.patch

