Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E639D353D83
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbhDEJAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237066AbhDEJAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:00:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 888E7613A5;
        Mon,  5 Apr 2021 09:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613207;
        bh=MlyoqGQDdBgFgvy9WiTiNYHqEhDIjQiHUhgVS/YCSTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRPSfNx4UZWWkKmekycLeLWf4LnqDOcCpF9kWIBAvz81Ny1Vjv3VfJ4BMg9LDCfMW
         ukclBOoklmzE5W5aMahy4IAVroS38z/FTAtSujS+vl3IYdmsyow05XaPvHzfJDGfqG
         w9qgpbRahaOcUdjsl225xHbhGEVZa9AlAZE8Dfv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frank van der Linden <fllinden@amazon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/52] mm: fix oom_kill event handling
Date:   Mon,  5 Apr 2021 10:54:01 +0200
Message-Id: <20210405085023.135458367@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.30.2



