Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAD144D018
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 03:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhKKCpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 21:45:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233144AbhKKCpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 21:45:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD336610F7;
        Thu, 11 Nov 2021 02:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598541;
        bh=ScrH7jOWc3XpvCpMHTwWVfUajm8w3Qwf2jIRWmP+X8U=;
        h=Date:From:To:Subject:From;
        b=abA+EpPFXpktM7OalL4vRiWhwGg4vcxw1Ur+47MLAMYM3i7+bVMUIj0HzYonUxXm2
         sbslk/8Q0CtlrgFsV0wQbwNd8ctg/om4crpjwAiSh3P7qU3Pkfq5H28OzYFQiQ4Tfl
         Td7ibm+Ylx92v069I9VEfuw1XRrdnsX6qtBPgkIM=
Date:   Wed, 10 Nov 2021 18:42:20 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org,
        penguin-kernel@i-love.sakura.ne.jp, shakeelb@google.com,
        stable@vger.kernel.org, urezki@gmail.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  [merged]
 mm-oom-pagefault_out_of_memory-dont-force-global-oom-for-dying-tasks.patch
 removed from -mm tree
Message-ID: <20211111024220.9QbYiBZ79%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks
has been removed from the -mm tree.  Its filename was
     mm-oom-pagefault_out_of_memory-dont-force-global-oom-for-dying-tasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vasily Averin <vvs@virtuozzo.com>
Subject: mm, oom: pagefault_out_of_memory: don't force global OOM for dying tasks

Patch series "memcg: prohibit unconditional exceeding the limit of dying tasks", v3.

Memory cgroup charging allows killed or exiting tasks to exceed the hard
limit.  It can be misused and allowed to trigger global OOM from inside a
memcg-limited container.  On the other hand if memcg fails allocation,
called from inside #PF handler it triggers global OOM from inside
pagefault_out_of_memory().

To prevent these problems this patchset:
a) removes execution of out_of_memory() from pagefault_out_of_memory(),
   becasue nobody can explain why it is necessary.
b) allow memcg to fail allocation of dying/killed tasks.


This patch (of 3):

Any allocation failure during the #PF path will return with VM_FAULT_OOM
which in turn results in pagefault_out_of_memory which in turn executes
out_out_memory() and can kill a random task.

An allocation might fail when the current task is the oom victim and there
are no memory reserves left.  The OOM killer is already handled at the
page allocator level for the global OOM and at the charging level for the
memcg one.  Both have much more information about the scope of
allocation/charge request.  This means that either the OOM killer has been
invoked properly and didn't lead to the allocation success or it has been
skipped because it couldn't have been invoked.  In both cases triggering
it from here is pointless and even harmful.

It makes much more sense to let the killed task die rather than to wake up
an eternally hungry oom-killer and send him to choose a fatter victim for
breakfast.

Link: https://lkml.kernel.org/r/0828a149-786e-7c06-b70a-52d086818ea3@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
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

 mm/oom_kill.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/oom_kill.c~mm-oom-pagefault_out_of_memory-dont-force-global-oom-for-dying-tasks
+++ a/mm/oom_kill.c
@@ -1137,6 +1137,9 @@ void pagefault_out_of_memory(void)
 	if (mem_cgroup_oom_synchronize(true))
 		return;
 
+	if (fatal_signal_pending(current))
+		return;
+
 	if (!mutex_trylock(&oom_lock))
 		return;
 	out_of_memory(&oc);
_

Patches currently in -mm which might be from vvs@virtuozzo.com are


