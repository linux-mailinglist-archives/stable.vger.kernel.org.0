Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B1C4525B8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358958AbhKPB5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237988AbhKOSO3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:14:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAAAB633D8;
        Mon, 15 Nov 2021 17:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998565;
        bh=J432w0JpZsIRUHRIErYeSP4sN43Fw3heu91iwsnB6iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vn2BUBf9RLrzbaNMO+b3SJ8AA4pADCzQ5qzKcKHiaK2P4i5ymo7CYnuIl4F4KJs3F
         YOoKj6qDSQQUZHrdgg35IG9qkEJrwdiHTlVH9U+J/e0lW+F4uZ4IvPwXw4xsFk1oJ+
         XrmU2YUVJyDYbyb4uRQSl1wj8CnKtmUVzS2bRQgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Roman Gushchin <guro@fb.com>,
        Shakeel Butt <shakeelb@google.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Uladzislau Rezki <urezki@gmail.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 555/575] mm, oom: do not trigger out_of_memory from the #PF
Date:   Mon, 15 Nov 2021 18:04:40 +0100
Message-Id: <20211115165402.880039180@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

commit 60e2793d440a3ec95abb5d6d4fc034a4b480472d upstream.

Any allocation failure during the #PF path will return with VM_FAULT_OOM
which in turn results in pagefault_out_of_memory.  This can happen for 2
different reasons.  a) Memcg is out of memory and we rely on
mem_cgroup_oom_synchronize to perform the memcg OOM handling or b)
normal allocation fails.

The latter is quite problematic because allocation paths already trigger
out_of_memory and the page allocator tries really hard to not fail
allocations.  Anyway, if the OOM killer has been already invoked there
is no reason to invoke it again from the #PF path.  Especially when the
OOM condition might be gone by that time and we have no way to find out
other than allocate.

Moreover if the allocation failed and the OOM killer hasn't been invoked
then we are unlikely to do the right thing from the #PF context because
we have already lost the allocation context and restictions and
therefore might oom kill a task from a different NUMA domain.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/oom_kill.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1118,19 +1118,15 @@ bool out_of_memory(struct oom_control *o
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
@@ -1138,8 +1134,6 @@ void pagefault_out_of_memory(void)
 	if (fatal_signal_pending(current))
 		return;
 
-	if (!mutex_trylock(&oom_lock))
-		return;
-	out_of_memory(&oc);
-	mutex_unlock(&oom_lock);
+	if (__ratelimit(&pfoom_rs))
+		pr_warn("Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF\n");
 }


