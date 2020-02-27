Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F90E171D83
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgB0OVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:21:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389700AbgB0ORZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:17:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C3C22468F;
        Thu, 27 Feb 2020 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813044;
        bh=XMLvaQRC/KuJ1tx84sN3yF4BFTu6dWttZFWCmDfN6HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dvMeKesWq7z47T1gz0ESx+2WoJb6JoHkbmb+xlILpvPngvP6+TAVKabB6vBnZxXf+
         YLxlFOyfB50Nwbnl4GN52roH9u0rnzVTpwptVOn/u07NhFD97pkfnln2BS2Zh3pL6p
         rwwzDsO17aeCEL9ZTxlhJLmyBv4qVhzoCJSbdWmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 116/150] drm/i915/gt: Protect defer_request() from new waiters
Date:   Thu, 27 Feb 2020 14:37:33 +0100
Message-Id: <20200227132249.809913684@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 19b5f3b419a61808ff2713f1f30b8a88fe14ac9b upstream.

Mika spotted

<4>[17436.705441] general protection fault: 0000 [#1] PREEMPT SMP PTI
<4>[17436.705447] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 5.5.0+ #1
<4>[17436.705449] Hardware name: System manufacturer System Product Name/Z170M-PLUS, BIOS 3805 05/16/2018
<4>[17436.705512] RIP: 0010:__execlists_submission_tasklet+0xc4d/0x16e0 [i915]
<4>[17436.705516] Code: c5 4c 8d 60 e0 75 17 e9 8c 07 00 00 49 8b 44 24 20 49 39 c5 4c 8d 60 e0 0f 84 7a 07 00 00 49 8b 5c 24 08 49 8b 87 80 00 00 00 <48> 39 83 d8 fe ff ff 75 d9 48 8b 83 88 fe ff ff a8 01 0f 84 b6 05
<4>[17436.705518] RSP: 0018:ffffc9000012ce80 EFLAGS: 00010083
<4>[17436.705521] RAX: ffff88822ae42000 RBX: 5a5a5a5a5a5a5a5a RCX: dead000000000122
<4>[17436.705523] RDX: ffff88822ae42588 RSI: ffff8881e32a7908 RDI: ffff8881c429fd48
<4>[17436.705525] RBP: ffffc9000012cf00 R08: ffff88822ae42588 R09: 00000000fffffffe
<4>[17436.705527] R10: ffff8881c429fb80 R11: 00000000a677cf08 R12: ffff8881c42a0aa8
<4>[17436.705529] R13: ffff8881c429fd38 R14: ffff88822ae42588 R15: ffff8881c429fb80
<4>[17436.705532] FS:  0000000000000000(0000) GS:ffff88822ed00000(0000) knlGS:0000000000000000
<4>[17436.705534] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[17436.705536] CR2: 00007f858c76d000 CR3: 0000000005610003 CR4: 00000000003606e0
<4>[17436.705538] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>[17436.705540] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
<4>[17436.705542] Call Trace:
<4>[17436.705545]  <IRQ>
<4>[17436.705603]  execlists_submission_tasklet+0xc0/0x130 [i915]

which is us consuming a partially initialised new waiter in
defer_requests(). We can prevent this by initialising the i915_dependency
prior to making it visible, and since we are using a concurrent
list_add/iterator mark them up to the compiler.

Fixes: 8ee36e048c98 ("drm/i915/execlists: Minimalistic timeslicing")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200206204915.2636606-2-chris@chris-wilson.co.uk
(cherry picked from commit f14f27b1663269a81ed62d3961fe70250a1a0623)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c   |    7 ++++++-
 drivers/gpu/drm/i915/i915_scheduler.c |    6 ++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -1433,6 +1433,11 @@ last_active(const struct intel_engine_ex
 	return *last;
 }
 
+#define for_each_waiter(p__, rq__) \
+	list_for_each_entry_lockless(p__, \
+				     &(rq__)->sched.waiters_list, \
+				     wait_link)
+
 static void defer_request(struct i915_request *rq, struct list_head * const pl)
 {
 	LIST_HEAD(list);
@@ -1450,7 +1455,7 @@ static void defer_request(struct i915_re
 		GEM_BUG_ON(i915_request_is_active(rq));
 		list_move_tail(&rq->sched.link, pl);
 
-		list_for_each_entry(p, &rq->sched.waiters_list, wait_link) {
+		for_each_waiter(p, rq) {
 			struct i915_request *w =
 				container_of(p->waiter, typeof(*w), sched);
 
--- a/drivers/gpu/drm/i915/i915_scheduler.c
+++ b/drivers/gpu/drm/i915/i915_scheduler.c
@@ -415,8 +415,6 @@ bool __i915_sched_node_add_dependency(st
 
 	if (!node_signaled(signal)) {
 		INIT_LIST_HEAD(&dep->dfs_link);
-		list_add(&dep->wait_link, &signal->waiters_list);
-		list_add(&dep->signal_link, &node->signalers_list);
 		dep->signaler = signal;
 		dep->waiter = node;
 		dep->flags = flags;
@@ -426,6 +424,10 @@ bool __i915_sched_node_add_dependency(st
 		    !node_started(signal))
 			node->flags |= I915_SCHED_HAS_SEMAPHORE_CHAIN;
 
+		/* All set, now publish. Beware the lockless walkers. */
+		list_add(&dep->signal_link, &node->signalers_list);
+		list_add_rcu(&dep->wait_link, &signal->waiters_list);
+
 		/*
 		 * As we do not allow WAIT to preempt inflight requests,
 		 * once we have executed a request, along with triggering


