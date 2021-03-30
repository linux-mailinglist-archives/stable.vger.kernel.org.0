Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1C434F0E6
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 20:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhC3STo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 14:19:44 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:29503 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbhC3STN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 14:19:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617128353; x=1648664353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=duwQVjGYkOrOvXtM8bKl9OMPh3xurpKbK0qbhH01PVU=;
  b=cYmcGVUNEnfZmiRMacdjTkBuo2FV9FRePwRYrAzE5hBUun6ltjIQ/uTa
   azE4YPOa1uoz8YAvs91WxVdcP3mdhlXpiYXeTzR0qnDJEMdq2HPdKpmIT
   6rEYsFOs9+QF6yU+haEUJVRsk3F99hbZA0IIzSSLn5IVnD2PV/B+vDskQ
   8=;
X-IronPort-AV: E=Sophos;i="5.81,291,1610409600"; 
   d="scan'208";a="922494444"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 30 Mar 2021 18:19:12 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-16acd5e0.us-east-1.amazon.com (Postfix) with ESMTPS id 742A4A2F16
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 18:19:12 +0000 (UTC)
Received: from EX13D13UWA002.ant.amazon.com (10.43.160.172) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Mar 2021 18:19:12 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D13UWA002.ant.amazon.com (10.43.160.172) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Mar 2021 18:19:11 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 30 Mar 2021 18:19:10 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id E5F6DDF92E; Tue, 30 Mar 2021 18:19:10 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <fllinden@amazon.com>
Subject: [PATCH 4.14 4/5] mm: fix oom_kill event handling
Date:   Tue, 30 Mar 2021 18:19:09 +0000
Message-ID: <20210330181910.15378-5-fllinden@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210330181910.15378-1-fllinden@amazon.com>
References: <20210330181910.15378-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Gushchin <guro@fb.com>

commit fe6bdfc8e1e131720abbe77a2eb990c94c9024cb upstream.

Commit e27be240df53 ("mm: memcg: make sure memory.events is uptodate
when waking pollers") converted most of memcg event counters to
per-memcg atomics, which made them less confusing for a user.  The
"oom_kill" counter remained untouched, so now it behaves differently
than other counters (including "oom").  This adds nothing but confusion.

Let's fix this by adding the MEMCG_OOM_KILL event, and follow the
MEMCG_OOM approach.

This also removes a hack from count_memcg_event_mm(), introduced earlier
specially for the OOM_KILL counter.

[akpm@linux-foundation.org: fix for droppage of memcg-replace-mm-owner-with-mm-memcg.patch]
Link: http://lkml.kernel.org/r/20180508124637.29984-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[fllinden@amazon.com: backport to 4.14, minor contextual changes]
Signed-off-by: Frank van der Linden <fllinden@amazon.com>
---
 include/linux/memcontrol.h | 26 ++++++++++++++++++++++----
 mm/memcontrol.c            |  6 ++++--
 mm/oom_kill.c              |  2 +-
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c7876eadd206..b5cd86e320ff 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -53,6 +53,7 @@ enum memcg_memory_event {
 	MEMCG_HIGH,
 	MEMCG_MAX,
 	MEMCG_OOM,
+	MEMCG_OOM_KILL,
 	MEMCG_NR_MEMORY_EVENTS,
 };
 
@@ -706,11 +707,8 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
-	if (likely(memcg)) {
+	if (likely(memcg))
 		count_memcg_events(memcg, idx, 1);
-		if (idx == OOM_KILL)
-			cgroup_file_notify(&memcg->events_file);
-	}
 	rcu_read_unlock();
 }
 
@@ -721,6 +719,21 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
 	cgroup_file_notify(&memcg->events_file);
 }
 
+static inline void memcg_memory_event_mm(struct mm_struct *mm,
+					 enum memcg_memory_event event)
+{
+	struct mem_cgroup *memcg;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	if (likely(memcg))
+		memcg_memory_event(memcg, event);
+	rcu_read_unlock();
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
@@ -742,6 +755,11 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
 {
 }
 
+static inline void memcg_memory_event_mm(struct mm_struct *mm,
+					 enum memcg_memory_event event)
+{
+}
+
 static inline bool mem_cgroup_low(struct mem_cgroup *root,
 				  struct mem_cgroup *memcg)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 31972189a827..ef6d996a920a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3648,7 +3648,8 @@ static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
 
 	seq_printf(sf, "oom_kill_disable %d\n", memcg->oom_kill_disable);
 	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
-	seq_printf(sf, "oom_kill %lu\n", memcg_sum_events(memcg, OOM_KILL));
+	seq_printf(sf, "oom_kill %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
 	return 0;
 }
 
@@ -5320,7 +5321,8 @@ static int memory_events_show(struct seq_file *m, void *v)
 		   atomic_long_read(&memcg->memory_events[MEMCG_MAX]));
 	seq_printf(m, "oom %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_OOM]));
-	seq_printf(m, "oom_kill %lu\n", memcg_sum_events(memcg, OOM_KILL));
+	seq_printf(m, "oom_kill %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
 
 	return 0;
 }
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 6482d743c5c8..6f1bed211122 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -917,7 +917,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 
 	/* Raise event before sending signal: task reaper must see this */
 	count_vm_event(OOM_KILL);
-	count_memcg_event_mm(mm, OOM_KILL);
+	memcg_memory_event_mm(mm, MEMCG_OOM_KILL);
 
 	/*
 	 * We should send SIGKILL before granting access to memory reserves
-- 
2.23.3

