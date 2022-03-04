Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585564CDCCE
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 19:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241784AbiCDSlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 13:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240522AbiCDSle (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 13:41:34 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772851BF90D
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 10:40:45 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d5258e8a4bso77428217b3.22
        for <stable@vger.kernel.org>; Fri, 04 Mar 2022 10:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kcmyAeGkpK7r59rcNcxz8jTE3yUE+N3ayzd6XBblM0I=;
        b=mvLff3CoVSfT2aw6kcMrK88S909hTrrgtBVT9DD32PyLCwH95gcIWOBgv7d+B5Lk94
         6hmjfyCbTACgGXuUxAuHbq2YdDtEgFXLlDJxgr16HWSidmhaQZ6/Gn0xcRhFCGj2H6To
         joT1GP1IfVR8Dsrm2glTVD3Xsj5i27miNaXmBqU2Azi8dzDhqV8o3qr/7mu6pH73YOfD
         iR8mjRPGmKQl8K5kVyArnaFqeOTwfccrAcc9Za6ETbCJER3RiaXUWmRkYm/aKORgLWsh
         7uBH2hMZTq4emcVx+Hfi9V3Yfk9hJdS9TbVc4g33OkzABHo84zPYWIo6YrfcDWw/wA7/
         lX6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kcmyAeGkpK7r59rcNcxz8jTE3yUE+N3ayzd6XBblM0I=;
        b=53D2sMBwXsTE9CAZZ5JNG/CGbJFysuK02H/FfXSrYrBnYB5O9loUMVGa7V6MhfDeaj
         kEakBJ3pm/wurUfAjVPuzkMF5y/pmYHjfV6ibW9QBudvwYfQ43rxr9t4MXuIf7l4FVUC
         fiOVc12B3AfWC/1/qtibOY2CeRSbxM8x5EObrWpVTxX9OvHWU3aEfot2MO3TjDF38zk0
         oQFW1bQDIBT0s1DhGrpVJw5TnCWWdJC6vDD+Qoxor3x7k8lq8DRW2B/xXe1qc6Sm60L3
         NuLWduPiv5k3F4fmLi7MM0nRJ7AJAZl+GovLRZtd+/wqpq9JzcQPA1vid7F57XUvEIDu
         nTZA==
X-Gm-Message-State: AOAM5318Ts8cnDvdZZf1ocGjMHWX2u1mlCe64w1+hs4a2hEFa+3Rj1X4
        1+4DtK3cN0Dr4/QjR7Xe+bYFmqtssWna9g==
X-Google-Smtp-Source: ABdhPJxQbsi8RSzb6NYSX+gqf9JicHEI9Ols5mWOZ9t2xvgAme8I6b6RNy28Q54iJFfl4DPUNTHiNJ/cEzgcew==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:28b])
 (user=shakeelb job=sendgmr) by 2002:a81:2450:0:b0:2d6:aee8:f0d5 with SMTP id
 k77-20020a812450000000b002d6aee8f0d5mr43748864ywk.81.1646419244705; Fri, 04
 Mar 2022 10:40:44 -0800 (PST)
Date:   Fri,  4 Mar 2022 18:40:40 +0000
Message-Id: <20220304184040.1304781-1-shakeelb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH] memcg: sync flush only if periodic flush is delayed
From:   Shakeel Butt <shakeelb@google.com>
To:     "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Ivan Babrou <ivan@cloudflare.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Daniel Dao <dqminh@cloudflare.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Daniel Dao has reported [1] a regression on workloads that may trigger
a lot of refaults (anon and file). The underlying issue is that flushing
rstat is expensive. Although rstat flush are batched with (nr_cpus *
MEMCG_BATCH) stat updates, it seems like there are workloads which
genuinely do stat updates larger than batch value within short amount of
time. Since the rstat flush can happen in the performance critical
codepaths like page faults, such workload can suffer greatly.

This patch fixes this regression by making the rstat flushing
conditional in the performance critical codepaths. More specifically,
the kernel relies on the async periodic rstat flusher to flush the stats
and only if the periodic flusher is delayed by more than twice the
amount of its normal time window then the kernel allows rstat flushing
from the performance critical codepaths.

Now the question: what are the side-effects of this change? The worst
that can happen is the refault codepath will see 4sec old lruvec stats
and may cause false (or missed) activations of the refaulted page which
may under-or-overestimate the workingset size. Though that is not very
concerning as the kernel can already miss or do false activations.

There are two more codepaths whose flushing behavior is not changed by
this patch and we may need to come to them in future. One is the
writeback stats used by dirty throttling and second is the deactivation
heuristic in the reclaim. For now keeping an eye on them and if there is
report of regression due to these codepaths, we will reevaluate then.

Link: https://lore.kernel.org/all/CA+wXwBSyO87ZX5PVwdHm-=dBjZYECGmfnydUicUyrQqndgX2MQ@mail.gmail.com [1]
Fixes: 1f828223b799 ("memcg: flush lruvec stats in the refault")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Daniel Dao <dqminh@cloudflare.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/memcontrol.h |  5 +++++
 mm/memcontrol.c            | 12 +++++++++++-
 mm/workingset.c            |  2 +-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a68dce3873fc..89b14729d59f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1012,6 +1012,7 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 }
 
 void mem_cgroup_flush_stats(void);
+void mem_cgroup_flush_stats_delayed(void);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1455,6 +1456,10 @@ static inline void mem_cgroup_flush_stats(void)
 {
 }
 
+static inline void mem_cgroup_flush_stats_delayed(void)
+{
+}
+
 static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
 					    enum node_stat_item idx, int val)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f79bb3f25ce4..edfb337e6948 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -587,6 +587,9 @@ static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
 static DEFINE_SPINLOCK(stats_flush_lock);
 static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
+static u64 flush_next_time;
+
+#define FLUSH_TIME (2UL*HZ)
 
 /*
  * Accessors to ensure that preemption is disabled on PREEMPT_RT because it can
@@ -637,6 +640,7 @@ static void __mem_cgroup_flush_stats(void)
 	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
 		return;
 
+	flush_next_time = jiffies_64 + 2*FLUSH_TIME;
 	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
 	spin_unlock_irqrestore(&stats_flush_lock, flag);
@@ -648,10 +652,16 @@ void mem_cgroup_flush_stats(void)
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
diff --git a/mm/workingset.c b/mm/workingset.c
index 8a3828acc0bf..592569a8974c 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -355,7 +355,7 @@ void workingset_refault(struct folio *folio, void *shadow)
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_delayed();
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
-- 
2.35.1.616.g0bdcbb4464-goog

