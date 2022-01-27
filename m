Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E103F49EA0D
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245459AbiA0SLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:11:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59598 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245172AbiA0SLK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:11:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03FC1B820C8;
        Thu, 27 Jan 2022 18:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F281C340E4;
        Thu, 27 Jan 2022 18:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643307067;
        bh=kc7n4vXVa9HKC6Vt7j6gNErEtePQL2/efnvjxesyjEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2NGWz99Hef4WyAtUd63kK1uexG3lUDr2qbW7Z6WmXODph3onHxlTvwk4dly90tM4
         AgiRHubVIVd1FRI1eLtaNSyJw+LPf8bnQLjGNIu4zE6V6EE1O5CgwAK3RuA2smX4UQ
         vLLkVU2qfxcTlFH/zORofNulP7qJBsshQZ5UuBgI=
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
Subject: [PATCH 5.15 07/12] memcg: unify memcg stat flushing
Date:   Thu, 27 Jan 2022 19:09:31 +0100
Message-Id: <20220127180259.324584685@linuxfoundation.org>
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

commit fd25a9e0e23b995fd0ba5e2f00a1099452cbc3cf upstream.

The memcg stats can be flushed in multiple context and potentially in
parallel too.  For example multiple parallel user space readers for
memcg stats will contend on the rstat locks with each other.  There is
no need for that.  We just need one flusher and everyone else can
benefit.

In addition after aa48e47e3906 ("memcg: infrastructure to flush memcg
stats") the kernel periodically flush the memcg stats from the root, so,
the other flushers will potentially have much less work to do.

Link: https://lkml.kernel.org/r/20211001190040.48086-2-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -660,12 +660,14 @@ static inline void memcg_rstat_updated(s
 
 static void __mem_cgroup_flush_stats(void)
 {
-	if (!spin_trylock(&stats_flush_lock))
+	unsigned long flag;
+
+	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
 		return;
 
 	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
-	spin_unlock(&stats_flush_lock);
+	spin_unlock_irqrestore(&stats_flush_lock, flag);
 }
 
 void mem_cgroup_flush_stats(void)
@@ -1461,7 +1463,7 @@ static char *memory_stat_format(struct m
 	 *
 	 * Current memory state:
 	 */
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -3554,8 +3556,7 @@ static unsigned long mem_cgroup_usage(st
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		/* mem_cgroup_threshold() calls here from irqsafe context */
-		cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
+		mem_cgroup_flush_stats();
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
@@ -3936,7 +3937,7 @@ static int memcg_numa_stat_show(struct s
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -4008,7 +4009,7 @@ static int memcg_stat_show(struct seq_fi
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4511,7 +4512,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
@@ -6394,7 +6395,7 @@ static int memory_numa_stat_show(struct
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;


