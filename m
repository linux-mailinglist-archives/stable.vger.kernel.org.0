Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335B5353D3B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhDEI7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236967AbhDEI7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:59:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B7D60238;
        Mon,  5 Apr 2021 08:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613143;
        bh=Apy6q+bMGSS/1hF7QbpWJ65K2jzFk48St325WYiVvfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbFx8l8vgRxkBdBbsHmg3sGJDT4lSDB2V6GEMXFDHZB+8nHpmmZ1pn08xRVTDwR8/
         60s2ifAN9NhoUXkxQrEn29yp4RRdlmR9s3Z8U94UYSwbuLUvxF5IOkiQ9I4mq8Z3Ml
         EGGtZGMSAaGYZpawsX9QMmBJoUOaMuLQtrF+8Jlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Thelen <gthelen@google.com>,
        Roman Gushchin <guro@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/52] mm: writeback: use exact memcg dirty counts
Date:   Mon,  5 Apr 2021 10:54:02 +0200
Message-Id: <20210405085023.164430007@linuxfoundation.org>
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

From: Greg Thelen <gthelen@google.com>

commit 0b3d6e6f2dd0a7b697b1aa8c167265908940624b upstream.

Since commit a983b5ebee57 ("mm: memcontrol: fix excessive complexity in
memory.stat reporting") memcg dirty and writeback counters are managed
as:

 1) per-memcg per-cpu values in range of [-32..32]

 2) per-memcg atomic counter

When a per-cpu counter cannot fit in [-32..32] it's flushed to the
atomic.  Stat readers only check the atomic.  Thus readers such as
balance_dirty_pages() may see a nontrivial error margin: 32 pages per
cpu.

Assuming 100 cpus:
   4k x86 page_size:  13 MiB error per memcg
  64k ppc page_size: 200 MiB error per memcg

Considering that dirty+writeback are used together for some decisions the
errors double.

This inaccuracy can lead to undeserved oom kills.  One nasty case is
when all per-cpu counters hold positive values offsetting an atomic
negative value (i.e.  per_cpu[*]=32, atomic=n_cpu*-32).
balance_dirty_pages() only consults the atomic and does not consider
throttling the next n_cpu*32 dirty pages.  If the file_lru is in the
13..200 MiB range then there's absolutely no dirty throttling, which
burdens vmscan with only dirty+writeback pages thus resorting to oom
kill.

It could be argued that tiny containers are not supported, but it's more
subtle.  It's the amount the space available for file lru that matters.
If a container has memory.max-200MiB of non reclaimable memory, then it
will also suffer such oom kills on a 100 cpu machine.

The following test reliably ooms without this patch.  This patch avoids
oom kills.

  $ cat test
  mount -t cgroup2 none /dev/cgroup
  cd /dev/cgroup
  echo +io +memory > cgroup.subtree_control
  mkdir test
  cd test
  echo 10M > memory.max
  (echo $BASHPID > cgroup.procs && exec /memcg-writeback-stress /foo)
  (echo $BASHPID > cgroup.procs && exec dd if=/dev/zero of=/foo bs=2M count=100)

  $ cat memcg-writeback-stress.c
  /*
   * Dirty pages from all but one cpu.
   * Clean pages from the non dirtying cpu.
   * This is to stress per cpu counter imbalance.
   * On a 100 cpu machine:
   * - per memcg per cpu dirty count is 32 pages for each of 99 cpus
   * - per memcg atomic is -99*32 pages
   * - thus the complete dirty limit: sum of all counters 0
   * - balance_dirty_pages() only sees atomic count -99*32 pages, which
   *   it max()s to 0.
   * - So a workload can dirty -99*32 pages before balance_dirty_pages()
   *   cares.
   */
  #define _GNU_SOURCE
  #include <err.h>
  #include <fcntl.h>
  #include <sched.h>
  #include <stdlib.h>
  #include <stdio.h>
  #include <sys/stat.h>
  #include <sys/sysinfo.h>
  #include <sys/types.h>
  #include <unistd.h>

  static char *buf;
  static int bufSize;

  static void set_affinity(int cpu)
  {
  	cpu_set_t affinity;

  	CPU_ZERO(&affinity);
  	CPU_SET(cpu, &affinity);
  	if (sched_setaffinity(0, sizeof(affinity), &affinity))
  		err(1, "sched_setaffinity");
  }

  static void dirty_on(int output_fd, int cpu)
  {
  	int i, wrote;

  	set_affinity(cpu);
  	for (i = 0; i < 32; i++) {
  		for (wrote = 0; wrote < bufSize; ) {
  			int ret = write(output_fd, buf+wrote, bufSize-wrote);
  			if (ret == -1)
  				err(1, "write");
  			wrote += ret;
  		}
  	}
  }

  int main(int argc, char **argv)
  {
  	int cpu, flush_cpu = 1, output_fd;
  	const char *output;

  	if (argc != 2)
  		errx(1, "usage: output_file");

  	output = argv[1];
  	bufSize = getpagesize();
  	buf = malloc(getpagesize());
  	if (buf == NULL)
  		errx(1, "malloc failed");

  	output_fd = open(output, O_CREAT|O_RDWR);
  	if (output_fd == -1)
  		err(1, "open(%s)", output);

  	for (cpu = 0; cpu < get_nprocs(); cpu++) {
  		if (cpu != flush_cpu)
  			dirty_on(output_fd, cpu);
  	}

  	set_affinity(flush_cpu);
  	if (fsync(output_fd))
  		err(1, "fsync(%s)", output);
  	if (close(output_fd))
  		err(1, "close(%s)", output);
  	free(buf);
  }

Make balance_dirty_pages() and wb_over_bg_thresh() work harder to
collect exact per memcg counters.  This avoids the aforementioned oom
kills.

This does not affect the overhead of memory.stat, which still reads the
single atomic counter.

Why not use percpu_counter? memcg already handles cpus going offline, so
no need for that overhead from percpu_counter.  And the percpu_counter
spinlocks are more heavyweight than is required.

It probably also makes sense to use exact dirty and writeback counters
in memcg oom reports.  But that is saved for later.

Link: http://lkml.kernel.org/r/20190329174609.164344-1-gthelen@google.com
Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>	[4.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h |  5 ++++-
 mm/memcontrol.c            | 20 ++++++++++++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b5cd86e320ff..365d5079d1cb 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -507,7 +507,10 @@ struct mem_cgroup *lock_page_memcg(struct page *page);
 void __unlock_page_memcg(struct mem_cgroup *memcg);
 void unlock_page_memcg(struct page *page);
 
-/* idx can be of type enum memcg_stat_item or node_stat_item */
+/*
+ * idx can be of type enum memcg_stat_item or node_stat_item.
+ * Keep in sync with memcg_exact_page_state().
+ */
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
 					     int idx)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ef6d996a920a..5e8b8e1b7d90 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3701,6 +3701,22 @@ struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb)
 	return &memcg->cgwb_domain;
 }
 
+/*
+ * idx can be of type enum memcg_stat_item or node_stat_item.
+ * Keep in sync with memcg_exact_page().
+ */
+static unsigned long memcg_exact_page_state(struct mem_cgroup *memcg, int idx)
+{
+	long x = atomic_long_read(&memcg->stat[idx]);
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		x += per_cpu_ptr(memcg->stat_cpu, cpu)->count[idx];
+	if (x < 0)
+		x = 0;
+	return x;
+}
+
 /**
  * mem_cgroup_wb_stats - retrieve writeback related stats from its memcg
  * @wb: bdi_writeback in question
@@ -3726,10 +3742,10 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
+	*pdirty = memcg_exact_page_state(memcg, NR_FILE_DIRTY);
 
 	/* this should eventually include NR_UNSTABLE_NFS */
-	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
+	*pwriteback = memcg_exact_page_state(memcg, NR_WRITEBACK);
 	*pfilepages = mem_cgroup_nr_lru_pages(memcg, (1 << LRU_INACTIVE_FILE) |
 						     (1 << LRU_ACTIVE_FILE));
 	*pheadroom = PAGE_COUNTER_MAX;
-- 
2.30.2



