Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B663934F0E5
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 20:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbhC3STn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 14:19:43 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:60972 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbhC3STM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 14:19:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617128353; x=1648664353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ecLxUKexLXn/jG6DseW6edCqSL1Nrr/pEasr6s0rAmo=;
  b=saKE+W3ZpBohEf3HO8Byc/vG8zHLzGRr/IigvAn59DUZYgR4DqgOAIl/
   FZh7DwN6g8MGtdj3SKs6efoagTl7/MJer7mRsiX2FPOHbgTHswWaSiuKk
   fhFGF5DGkS7/Vjx6ILmUXxWhho1SKAkJJ0KIquYvWZSog+5nClW18bg5w
   E=;
X-IronPort-AV: E=Sophos;i="5.81,291,1610409600"; 
   d="scan'208";a="97732956"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 30 Mar 2021 18:19:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 6AE38A226A
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 18:19:11 +0000 (UTC)
Received: from EX13D13UWB003.ant.amazon.com (10.43.161.233) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Mar 2021 18:19:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D13UWB003.ant.amazon.com (10.43.161.233) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Mar 2021 18:19:11 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 30 Mar 2021 18:19:10 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id DD0E4DF600; Tue, 30 Mar 2021 18:19:10 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <fllinden@amazon.com>
Subject: [PATCH 4.14 1/5] mm: memcontrol: fix NR_WRITEBACK leak in memcg and system stats
Date:   Tue, 30 Mar 2021 18:19:06 +0000
Message-ID: <20210330181910.15378-2-fllinden@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210330181910.15378-1-fllinden@amazon.com>
References: <20210330181910.15378-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit c3cc39118c3610eb6ab4711bc624af7fc48a35fe upstream.

After commit a983b5ebee57 ("mm: memcontrol: fix excessive complexity in
memory.stat reporting"), we observed slowly upward creeping NR_WRITEBACK
counts over the course of several days, both the per-memcg stats as well
as the system counter in e.g.  /proc/meminfo.

The conversion from full per-cpu stat counts to per-cpu cached atomic
stat counts introduced an irq-unsafe RMW operation into the updates.

Most stat updates come from process context, but one notable exception
is the NR_WRITEBACK counter.  While writebacks are issued from process
context, they are retired from (soft)irq context.

When writeback completions interrupt the RMW counter updates of new
writebacks being issued, the decs from the completions are lost.

Since the global updates are routed through the joint lruvec API, both
the memcg counters as well as the system counters are affected.

This patch makes the joint stat and event API irq safe.

Link: http://lkml.kernel.org/r/20180203082353.17284-1-hannes@cmpxchg.org
Fixes: a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat reporting")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Debugged-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/memcontrol.h | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 882046863581..c46016bb25eb 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -523,9 +523,11 @@ static inline void __mod_memcg_state(struct mem_cgroup *memcg,
 static inline void mod_memcg_state(struct mem_cgroup *memcg,
 				   int idx, int val)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__mod_memcg_state(memcg, idx, val);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 /**
@@ -606,9 +608,11 @@ static inline void __mod_lruvec_state(struct lruvec *lruvec,
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__mod_lruvec_state(lruvec, idx, val);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 static inline void __mod_lruvec_page_state(struct page *page,
@@ -630,9 +634,11 @@ static inline void __mod_lruvec_page_state(struct page *page,
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__mod_lruvec_page_state(page, idx, val);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -659,9 +665,11 @@ static inline void __count_memcg_events(struct mem_cgroup *memcg,
 static inline void count_memcg_events(struct mem_cgroup *memcg,
 				      int idx, unsigned long count)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	__count_memcg_events(memcg, idx, count);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 /* idx can be of type enum memcg_event_item or vm_event_item */
-- 
2.23.3

