Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEF93C4D95
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242501AbhGLHNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242488AbhGLHMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:12:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A7F661175;
        Mon, 12 Jul 2021 07:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073753;
        bh=LEaUvOGmtjnNWHHqHt2TzPzUVP0K1SqxJk02a9w+omI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p87EKrgJxl1wkPRDq90FWukYsIQWm5qlORv9wTRmP/5mUj2LU4LozwWJTMuPKWhfZ
         tQIuoPv9DvNEtLP1kpV6QSN4wy5hrcB++PhK8K2XoLBE2whEP5rh7sGQn70VZ4+lAQ
         Yzl18HyTuQ0AEY5Ux3NGF8Dv+KBEhKzmkMoIgnvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 346/700] mm: mmap_lock: use local locks instead of disabling preemption
Date:   Mon, 12 Jul 2021 08:07:09 +0200
Message-Id: <20210712061013.100327782@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Saenz Julienne <nsaenzju@redhat.com>

[ Upstream commit 832b50725373e8c46781b7d4db104ec9cf564a6b ]

mmap_lock will explicitly disable/enable preemption upon manipulating its
local CPU variables.  This is to be expected, but in this case, it doesn't
play well with PREEMPT_RT.  The preemption disabled code section also
takes a spin-lock.  Spin-locks in RT systems will try to schedule, which
is exactly what we're trying to avoid.

To mitigate this, convert the explicit preemption handling to local_locks.
Which are RT aware, and will disable migration instead of preemption when
PREEMPT_RT=y.

The faulty call trace looks like the following:
    __mmap_lock_do_trace_*()
      preempt_disable()
      get_mm_memcg_path()
        cgroup_path()
          kernfs_path_from_node()
            spin_lock_irqsave() /* Scheduling while atomic! */

Link: https://lkml.kernel.org/r/20210604163506.2103900-1-nsaenzju@redhat.com
Fixes: 2b5067a8143e3 ("mm: mmap_lock: add tracepoints around lock acquisition ")
Signed-off-by: Nicolas Saenz Julienne <nsaenzju@redhat.com>
Tested-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap_lock.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index dcdde4f722a4..2ae3f33b85b1 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -11,6 +11,7 @@
 #include <linux/rcupdate.h>
 #include <linux/smp.h>
 #include <linux/trace_events.h>
+#include <linux/local_lock.h>
 
 EXPORT_TRACEPOINT_SYMBOL(mmap_lock_start_locking);
 EXPORT_TRACEPOINT_SYMBOL(mmap_lock_acquire_returned);
@@ -39,21 +40,30 @@ static int reg_refcount; /* Protected by reg_lock. */
  */
 #define CONTEXT_COUNT 4
 
-static DEFINE_PER_CPU(char __rcu *, memcg_path_buf);
+struct memcg_path {
+	local_lock_t lock;
+	char __rcu *buf;
+	local_t buf_idx;
+};
+static DEFINE_PER_CPU(struct memcg_path, memcg_paths) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+	.buf_idx = LOCAL_INIT(0),
+};
+
 static char **tmp_bufs;
-static DEFINE_PER_CPU(int, memcg_path_buf_idx);
 
 /* Called with reg_lock held. */
 static void free_memcg_path_bufs(void)
 {
+	struct memcg_path *memcg_path;
 	int cpu;
 	char **old = tmp_bufs;
 
 	for_each_possible_cpu(cpu) {
-		*(old++) = rcu_dereference_protected(
-			per_cpu(memcg_path_buf, cpu),
+		memcg_path = per_cpu_ptr(&memcg_paths, cpu);
+		*(old++) = rcu_dereference_protected(memcg_path->buf,
 			lockdep_is_held(&reg_lock));
-		rcu_assign_pointer(per_cpu(memcg_path_buf, cpu), NULL);
+		rcu_assign_pointer(memcg_path->buf, NULL);
 	}
 
 	/* Wait for inflight memcg_path_buf users to finish. */
@@ -88,7 +98,7 @@ int trace_mmap_lock_reg(void)
 		new = kmalloc(MEMCG_PATH_BUF_SIZE * CONTEXT_COUNT, GFP_KERNEL);
 		if (new == NULL)
 			goto out_fail_free;
-		rcu_assign_pointer(per_cpu(memcg_path_buf, cpu), new);
+		rcu_assign_pointer(per_cpu_ptr(&memcg_paths, cpu)->buf, new);
 		/* Don't need to wait for inflights, they'd have gotten NULL. */
 	}
 
@@ -122,23 +132,24 @@ out:
 
 static inline char *get_memcg_path_buf(void)
 {
+	struct memcg_path *memcg_path = this_cpu_ptr(&memcg_paths);
 	char *buf;
 	int idx;
 
 	rcu_read_lock();
-	buf = rcu_dereference(*this_cpu_ptr(&memcg_path_buf));
+	buf = rcu_dereference(memcg_path->buf);
 	if (buf == NULL) {
 		rcu_read_unlock();
 		return NULL;
 	}
-	idx = this_cpu_add_return(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE) -
+	idx = local_add_return(MEMCG_PATH_BUF_SIZE, &memcg_path->buf_idx) -
 	      MEMCG_PATH_BUF_SIZE;
 	return &buf[idx];
 }
 
 static inline void put_memcg_path_buf(void)
 {
-	this_cpu_sub(memcg_path_buf_idx, MEMCG_PATH_BUF_SIZE);
+	local_sub(MEMCG_PATH_BUF_SIZE, &this_cpu_ptr(&memcg_paths)->buf_idx);
 	rcu_read_unlock();
 }
 
@@ -179,14 +190,14 @@ out:
 #define TRACE_MMAP_LOCK_EVENT(type, mm, ...)                                   \
 	do {                                                                   \
 		const char *memcg_path;                                        \
-		preempt_disable();                                             \
+		local_lock(&memcg_paths.lock);				       \
 		memcg_path = get_mm_memcg_path(mm);                            \
 		trace_mmap_lock_##type(mm,                                     \
 				       memcg_path != NULL ? memcg_path : "",   \
 				       ##__VA_ARGS__);                         \
 		if (likely(memcg_path != NULL))                                \
 			put_memcg_path_buf();                                  \
-		preempt_enable();                                              \
+		local_unlock(&memcg_paths.lock);			       \
 	} while (0)
 
 #else /* !CONFIG_MEMCG */
-- 
2.30.2



