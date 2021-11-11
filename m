Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E792544D019
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 03:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhKKCpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 21:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233144AbhKKCpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8C6D60F46;
        Thu, 11 Nov 2021 02:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598544;
        bh=q5Jw2Fdr6Ao3BFIGPnfLXfJpzGE9PBKAju1jpfMvHnY=;
        h=Date:From:To:Subject:From;
        b=1/Cq+wfpM20TJLpS09wY6qHMUH8dXQ+gLVBYN8DbME3STWrka9eJ/PBRVnG0snL+a
         KuPSJO7NHz6z8q4vzJK09mSsRxNSPDhPu4BQ5U81GUVkfZyU7FHddN9u+1o8vdYFEj
         iVA6y9tBXYlXrHB9EOSE+pAPJeW/R0WDXuu8dwuM=
Date:   Wed, 10 Nov 2021 18:42:23 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, shakeelb@google.com,
        stable@vger.kernel.org, urezki@gmail.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  [merged]
 mm-oom-do-not-trigger-out_of_memory-from-the-pf.patch removed from -mm tree
Message-ID: <20211111024223.Xl4xt4tyv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, oom: do not trigger out_of_memory from the #PF
has been removed from the -mm tree.  Its filename was
     mm-oom-do-not-trigger-out_of_memory-from-the-pf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: do not trigger out_of_memory from the #PF

Any allocation failure during the #PF path will return with VM_FAULT_OOM
which in turn results in pagefault_out_of_memory.  This can happen for 2
different reasons.  a) Memcg is out of memory and we rely on
mem_cgroup_oom_synchronize to perform the memcg OOM handling or b) normal
allocation fails.

The latter is quite problematic because allocation paths already trigger
out_of_memory and the page allocator tries really hard to not fail
allocations.  Anyway, if the OOM killer has been already invoked there is
no reason to invoke it again from the #PF path.  Especially when the OOM
condition might be gone by that time and we have no way to find out other
than allocate.

Moreover if the allocation failed and the OOM killer hasn't been invoked
then we are unlikely to do the right thing from the #PF context because we
have already lost the allocation context and restictions and therefore
might oom kill a task from a different NUMA domain.

This all suggests that there is no legitimate reason to trigger
out_of_memory from pagefault_out_of_memory so drop it.  Just to be sure
that no #PF path returns with VM_FAULT_OOM without allocation print a
warning that this is happening before we restart the #PF.

[VvS: #PF allocation can hit into limit of cgroup v1 kmem controller. 
This is a local problem related to memcg, however, it causes unnecessary
global OOM kills that are repeated over and over again and escalate into a
real disaster.  This has been broken since kmem accounting has been
introduced for cgroup v1 (3.8).  There was no kmem specific reclaim for
the separate limit so the only way to handle kmem hard limit was to return
with ENOMEM.  In upstream the problem will be fixed by removing the
outdated kmem limit, however stable and LTS kernels cannot do it and are
still affected.  This patch fixes the problem and should be backported
into stable/LTS.]

Link: https://lkml.kernel.org/r/f5fd8dd8-0ad4-c524-5f65-920b01972a42@virtuozzo.com
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/mm/oom_kill.c~mm-oom-do-not-trigger-out_of_memory-from-the-pf
+++ a/mm/oom_kill.c
@@ -1120,19 +1120,15 @@ bool out_of_memory(struct oom_control *o
 }
 
 /*
- * The pagefault handler calls here because it is out of memory, so kill a
- * memory-hogging task. If oom_lock is held by somebody else, a parallel oom
- * killing is already in progress so do nothing.
+ * The pagefault handler calls here because some allocation has failed. We have
+ * to take care of the memcg OOM here because this is the only safe context without
+ * any locks held but let the oom killer triggered from the allocation context care
+ * about the global OOM.
  */
 void pagefault_out_of_memory(void)
 {
-	struct oom_control oc = {
-		.zonelist = NULL,
-		.nodemask = NULL,
-		.memcg = NULL,
-		.gfp_mask = 0,
-		.order = 0,
-	};
+	static DEFINE_RATELIMIT_STATE(pfoom_rs, DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
 
 	if (mem_cgroup_oom_synchronize(true))
 		return;
@@ -1140,10 +1136,8 @@ void pagefault_out_of_memory(void)
 	if (fatal_signal_pending(current))
 		return;
 
-	if (!mutex_trylock(&oom_lock))
-		return;
-	out_of_memory(&oc);
-	mutex_unlock(&oom_lock);
+	if (__ratelimit(&pfoom_rs))
+		pr_warn("Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF\n");
 }
 
 SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
_

Patches currently in -mm which might be from mhocko@suse.com are


