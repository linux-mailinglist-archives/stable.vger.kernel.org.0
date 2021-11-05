Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5480C4469CB
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhKEUko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232468AbhKEUkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Nov 2021 16:40:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BCEE60174;
        Fri,  5 Nov 2021 20:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144683;
        bh=oYskhWGQjMRbogBIr+BmH6a6+9MqQrXa1LGipJld3Kc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1uXlQCd6CfVEJRqAvdXg8xud5nqwKNSFEdF8lM+ki2CBmt0n1Ju2DcJHpNwBg+1Sm
         TdmFzSYY9ysMO2myveEAwmAD2XjkeBHr9mglo0nnfjtlZe+4mHIlTKpcHcir7yoNPb
         vb5Y2u+tUvjR8at+MBUvE7O/maRgEHECrgiF0NR0=
Date:   Fri, 05 Nov 2021 13:38:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        shakeelb@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, urezki@gmail.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com, vvs@virtuozzo.com
Subject:  [patch 065/262] mm, oom: pagefault_out_of_memory: don't
 force global OOM for dying tasks
Message-ID: <20211105203802.Yoox9Lj1y%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
