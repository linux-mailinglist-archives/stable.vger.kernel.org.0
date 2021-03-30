Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035E234F0E2
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 20:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhC3STi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 14:19:38 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:60972 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbhC3STN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 14:19:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1617128354; x=1648664354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=WBO2yQnZLyZ58LHMkJapbcc4AeOJTQQnOQmr0JkNZno=;
  b=gi7NmSi7CZqhC7VBXFthraDIr5j5FDZmdljlAzXUvnapPuoKMIIGQ6Zr
   gy0KHE3v/HTsa6b8uG/R2ppoJXQHM831DIWvEKZyK5/b3/pv9rB4fl0Tx
   oq3dkF2yUe70xoUcC4i2ZP00GqzAN95rWJHWtnLefejr6a5632wXG1fqd
   M=;
X-IronPort-AV: E=Sophos;i="5.81,291,1610409600"; 
   d="scan'208";a="97732965"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 30 Mar 2021 18:19:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id 68971A1C16
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 18:19:12 +0000 (UTC)
Received: from EX13D13UWB002.ant.amazon.com (10.43.161.21) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Mar 2021 18:19:12 +0000
Received: from EX13MTAUEA002.ant.amazon.com (10.43.61.77) by
 EX13D13UWB002.ant.amazon.com (10.43.161.21) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 30 Mar 2021 18:19:11 +0000
Received: from dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com
 (172.23.141.97) by mail-relay.amazon.com (10.43.61.169) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Tue, 30 Mar 2021 18:19:11 +0000
Received: by dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com (Postfix, from userid 6262777)
        id E3096DF92D; Tue, 30 Mar 2021 18:19:10 +0000 (UTC)
From:   Frank van der Linden <fllinden@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <fllinden@amazon.com>
Subject: [PATCH 4.14 3/5] mem_cgroup: make sure moving_account, move_lock_task and stat_cpu in the same cacheline
Date:   Tue, 30 Mar 2021 18:19:08 +0000
Message-ID: <20210330181910.15378-4-fllinden@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210330181910.15378-1-fllinden@amazon.com>
References: <20210330181910.15378-1-fllinden@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Lu <aaron.lu@intel.com>

commit e81bf9793b1861d74953ef041b4f6c7faecc2dbd upstream.

The LKP robot found a 27% will-it-scale/page_fault3 performance
regression regarding commit e27be240df53("mm: memcg: make sure
memory.events is uptodate when waking pollers").

What the test does is:
 1 mkstemp() a 128M file on a tmpfs;
 2 start $nr_cpu processes, each to loop the following:
   2.1 mmap() this file in shared write mode;
   2.2 write 0 to this file in a PAGE_SIZE step till the end of the file;
   2.3 unmap() this file and repeat this process.
 3 After 5 minutes, check how many loops they managed to complete, the
   higher the better.

The commit itself looks innocent enough as it merely changed some event
counting mechanism and this test didn't trigger those events at all.
Perf shows increased cycles spent on accessing root_mem_cgroup->stat_cpu
in count_memcg_event_mm()(called by handle_mm_fault()) and in
__mod_memcg_state() called by page_add_file_rmap().  So it's likely due
to the changed layout of 'struct mem_cgroup' that either make stat_cpu
falling into a constantly modifying cacheline or some hot fields stop
being in the same cacheline.

I verified this by moving memory_events[] back to where it was:

: --- a/include/linux/memcontrol.h
: +++ b/include/linux/memcontrol.h
: @@ -205,7 +205,6 @@ struct mem_cgroup {
:  	int		oom_kill_disable;
:
:  	/* memory.events */
: -	atomic_long_t memory_events[MEMCG_NR_MEMORY_EVENTS];
:  	struct cgroup_file events_file;
:
:  	/* protect arrays of thresholds */
: @@ -238,6 +237,7 @@ struct mem_cgroup {
:  	struct mem_cgroup_stat_cpu __percpu *stat_cpu;
:  	atomic_long_t		stat[MEMCG_NR_STAT];
:  	atomic_long_t		events[NR_VM_EVENT_ITEMS];
: +	atomic_long_t memory_events[MEMCG_NR_MEMORY_EVENTS];
:
:  	unsigned long		socket_pressure;

And performance restored.

Later investigation found that as long as the following 3 fields
moving_account, move_lock_task and stat_cpu are in the same cacheline,
performance will be good.  To avoid future performance surprise by other
commits changing the layout of 'struct mem_cgroup', this patch makes
sure the 3 fields stay in the same cacheline.

One concern of this approach is, moving_account and move_lock_task could
be modified when a process changes memory cgroup while stat_cpu is a
always read field, it might hurt to place them in the same cacheline.  I
assume it is rare for a process to change memory cgroup so this should
be OK.

Link: https://lkml.kernel.org/r/20180528114019.GF9904@yexl-desktop
Link: http://lkml.kernel.org/r/20180601071115.GA27302@intel.com
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Reported-by: kernel test robot <xiaolong.ye@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/memcontrol.h | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6503a9ca27c1..c7876eadd206 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -155,6 +155,15 @@ enum memcg_kmem_state {
 	KMEM_ONLINE,
 };
 
+#if defined(CONFIG_SMP)
+struct memcg_padding {
+	char x[0];
+} ____cacheline_internodealigned_in_smp;
+#define MEMCG_PADDING(name)      struct memcg_padding name;
+#else
+#define MEMCG_PADDING(name)
+#endif
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -202,7 +211,6 @@ struct mem_cgroup {
 	int		oom_kill_disable;
 
 	/* memory.events */
-	atomic_long_t memory_events[MEMCG_NR_MEMORY_EVENTS];
 	struct cgroup_file events_file;
 
 	/* protect arrays of thresholds */
@@ -222,19 +230,26 @@ struct mem_cgroup {
 	 * mem_cgroup ? And what type of charges should we move ?
 	 */
 	unsigned long move_charge_at_immigrate;
+	/* taken only while moving_account > 0 */
+	spinlock_t		move_lock;
+	unsigned long		move_lock_flags;
+
+	MEMCG_PADDING(_pad1_);
+
 	/*
 	 * set > 0 if pages under this cgroup are moving to other cgroup.
 	 */
 	atomic_t		moving_account;
-	/* taken only while moving_account > 0 */
-	spinlock_t		move_lock;
 	struct task_struct	*move_lock_task;
-	unsigned long		move_lock_flags;
 
 	/* memory.stat */
 	struct mem_cgroup_stat_cpu __percpu *stat_cpu;
+
+	MEMCG_PADDING(_pad2_);
+
 	atomic_long_t		stat[MEMCG_NR_STAT];
 	atomic_long_t		events[NR_VM_EVENT_ITEMS];
+	atomic_long_t memory_events[MEMCG_NR_MEMORY_EVENTS];
 
 	unsigned long		socket_pressure;
 
-- 
2.23.3

