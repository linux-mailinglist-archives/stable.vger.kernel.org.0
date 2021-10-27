Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40C643D6C1
	for <lists+stable@lfdr.de>; Thu, 28 Oct 2021 00:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhJ0Wix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 18:38:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230080AbhJ0Wix (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 18:38:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5B23610E5;
        Wed, 27 Oct 2021 22:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635374187;
        bh=gw8iu7ItjplwpkVG7GDUj0JVvpYh8S/oBugrdu0lpVg=;
        h=Date:From:To:Subject:From;
        b=K52BxY4BtXy8uXcuhi5HoyFHnmyIkBdDNYQcfNzdPJGQashKemm4jG6OJk+tev6+G
         nn8NcFn7zkVCkahUJwktp2QTr1mnWMneC9J1SxcXmLh6INz1Cq3zg1yLmexQZd5Djc
         t5BqrnpWI1X6hSO4V/9zD+ZbEkreE1oER6u17jSY=
Date:   Wed, 27 Oct 2021 15:36:26 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, shakeelb@google.com,
        stable@vger.kernel.org, urezki@gmail.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  + mm-oom-do-not-trigger-out_of_memory-from-the-pf.patch
 added to -mm tree
Message-ID: <20211027223626.V-Tli-Tl2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, oom: do not trigger out_of_memory from the #PF
has been added to the -mm tree.  Its filename is
     mm-oom-do-not-trigger-out_of_memory-from-the-pf.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom-do-not-trigger-out_of_memory-from-the-pf.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-do-not-trigger-out_of_memory-from-the-pf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-oom-do-not-trigger-out_of_memory-from-the-pf.patch
mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch

