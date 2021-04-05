Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DE0353D7E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhDEJAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhDEJAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:00:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C8896124C;
        Mon,  5 Apr 2021 08:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613200;
        bh=jTHoZX3UF3nh8M5BAk6bVFMyICGH9LQEk/OSGAroItM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qp0P8zWW4DCGe4Tua+3IuPqR+dLPm/wFcO5yVaIRe2cm0dfOymOxtQmos2RxZ5q9A
         /bOj6w/kKwc8CPpnBwG0hrsKEGFWBh5/+hApF74QtzxuC3YzhGWkvHJFrMgr8faQR1
         iBDDHdz+cLCl5hxB7ufGazxtxZ3KcmqeP111uKKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@surriel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.14 32/52] mm: memcontrol: fix NR_WRITEBACK leak in memcg and system stats
Date:   Mon,  5 Apr 2021 10:53:58 +0200
Message-Id: <20210405085023.034096614@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.30.2



