Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B52E4469CD
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhKEUku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232258AbhKEUku (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B872A611C0;
        Fri,  5 Nov 2021 20:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144690;
        bh=t5wHbGfIuJW7vsDOUJJHIHgqWF5JBs2z11pDnbCKrQ0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cRM87EKqt0tRqXyf//aIvYRgAh5V4iOMfoNhyvLJ/x2Yj5K+FIkMwjWrmVep9Mz8E
         IFJsG0ZXMr8Y0oFaNzmnRXgluFHio5rUTFBsjvAqd/1NRfJ4DHnvB9PP5FssdtLaLT
         mOeeUr2F6af/jFAVgDFDZO74JavCzckNTBCqnzNE=
Date:   Fri, 05 Nov 2021 13:38:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        shakeelb@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, urezki@gmail.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  [patch 067/262] memcg: prohibit unconditional exceeding
 the limit of dying tasks
Message-ID: <20211105203809.1Zku99VL8%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Subject: memcg: prohibit unconditional exceeding the limit of dying tasks

Memory cgroup charging allows killed or exiting tasks to exceed the hard
limit.  It is assumed that the amount of the memory charged by those tasks
is bound and most of the memory will get released while the task is
exiting.  This is resembling a heuristic for the global OOM situation when
tasks get access to memory reserves.  There is no global memory shortage
at the memcg level so the memcg heuristic is more relieved.

The above assumption is overly optimistic though.  E.g.  vmalloc can scale
to really large requests and the heuristic would allow that.  We used to
have an early break in the vmalloc allocator for killed tasks but this has
been reverted by commit b8c8a338f75e ("Revert "vmalloc: back off when the
current task is killed"").  There are likely other similar code paths
which do not check for fatal signals in an allocation&charge loop.  Also
there are some kernel objects charged to a memcg which are not bound to a
process life time.

It has been observed that it is not really hard to trigger these bypasses
and cause global OOM situation.

One potential way to address these runaways would be to limit the amount
of excess (similar to the global OOM with limited oom reserves).  This is
certainly possible but it is not really clear how much of an excess is
desirable and still protects from global OOMs as that would have to
consider the overall memcg configuration.

This patch is addressing the problem by removing the heuristic altogether.
Bypass is only allowed for requests which either cannot fail or where the
failure is not desirable while excess should be still limited (e.g. 
atomic requests).  Implementation wise a killed or dying task fails to
charge if it has passed the OOM killer stage.  That should give all forms
of reclaim chance to restore the limit before the failure (ENOMEM) and
tell the caller to back off.

In addition, this patch renames should_force_charge() helper to
task_is_dying() because now its use is not associated witch forced
charging.

This patch depends on pagefault_out_of_memory() to not trigger
out_of_memory(), because then a memcg failure can unwind to VM_FAULT_OOM
and cause a global OOM killer.

Link: https://lkml.kernel.org/r/8f5cebbb-06da-4902-91f0-6566fc4b4203@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

--- a/mm/memcontrol.c~memcg-prohibit-unconditional-exceeding-the-limit-of-dying-tasks
+++ a/mm/memcontrol.c
@@ -234,7 +234,7 @@ enum res_type {
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
-static inline bool should_force_charge(void)
+static inline bool task_is_dying(void)
 {
 	return tsk_is_oom_victim(current) || fatal_signal_pending(current) ||
 		(current->flags & PF_EXITING);
@@ -1624,7 +1624,7 @@ static bool mem_cgroup_out_of_memory(str
 	 * A few threads which were not waiting at mutex_lock_killable() can
 	 * fail to bail out. Therefore, check again after holding oom_lock.
 	 */
-	ret = should_force_charge() || out_of_memory(&oc);
+	ret = task_is_dying() || out_of_memory(&oc);
 
 unlock:
 	mutex_unlock(&oom_lock);
@@ -2579,6 +2579,7 @@ static int try_charge_memcg(struct mem_c
 	struct page_counter *counter;
 	enum oom_status oom_status;
 	unsigned long nr_reclaimed;
+	bool passed_oom = false;
 	bool may_swap = true;
 	bool drained = false;
 	unsigned long pflags;
@@ -2614,15 +2615,6 @@ retry:
 		goto force;
 
 	/*
-	 * Unlike in global OOM situations, memcg is not in a physical
-	 * memory shortage.  Allow dying and OOM-killed tasks to
-	 * bypass the last charges so that they can exit quickly and
-	 * free their memory.
-	 */
-	if (unlikely(should_force_charge()))
-		goto force;
-
-	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
 	 * but we prefer facilitating memory reclaim and getting back
@@ -2679,8 +2671,9 @@ retry:
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
-	if (fatal_signal_pending(current))
-		goto force;
+	/* Avoid endless loop for tasks bypassed by the oom killer */
+	if (passed_oom && task_is_dying())
+		goto nomem;
 
 	/*
 	 * keep retrying as long as the memcg oom killer is able to make
@@ -2689,14 +2682,10 @@ retry:
 	 */
 	oom_status = mem_cgroup_oom(mem_over_limit, gfp_mask,
 		       get_order(nr_pages * PAGE_SIZE));
-	switch (oom_status) {
-	case OOM_SUCCESS:
+	if (oom_status == OOM_SUCCESS) {
+		passed_oom = true;
 		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
-	case OOM_FAILED:
-		goto force;
-	default:
-		goto nomem;
 	}
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
_
