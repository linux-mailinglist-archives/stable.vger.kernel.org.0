Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D192C40142E
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240925AbhIFBck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243531AbhIFB30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 072566103B;
        Mon,  6 Sep 2021 01:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891404;
        bh=dGLfehhFTy0eJ6fGMxY1QVBpciXrFxL5nfABSAi8V0Y=;
        h=From:To:Cc:Subject:Date:From;
        b=I2rxh7MfE2DRW1S/XUeHv4NOFJ7cNQWxS9cwj9dVQYlt+ogCQbWpdciA49TnYs6fw
         2LXXi4Y/Aq7TijzbNwBNs7WtjNacLFTZuTdMPuDdsGWc1ZsYdSOUP/29LAcZfdamzP
         VrBaACDoh5I9otJ5HLZWvovp+C2qWjJzMoFaqMHij/nHTpVQMKbaii3mG3dthS/6UX
         4CidQ46z7cBSnxVWawJFGYHGjKzeTuvsVaF18Bj8SwVXaIQshRsi4jd/p84vZOQrY8
         iqKH8xfWTr7jSrEusvn4cqJAngGLEt0nivgfcthMWCtvs7ZEXbM7D1EF6y3LmwkpfO
         UZ8/FHyiJHy0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 01/23] locking/mutex: Fix HANDOFF condition
Date:   Sun,  5 Sep 2021 21:23:00 -0400
Message-Id: <20210906012322.930668-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 048661a1f963e9517630f080687d48af79ed784c ]

Yanfei reported that setting HANDOFF should not depend on recomputing
@first, only on @first state. Which would then give:

  if (ww_ctx || !first)
    first = __mutex_waiter_is_first(lock, &waiter);
  if (first)
    __mutex_set_flag(lock, MUTEX_FLAG_HANDOFF);

But because 'ww_ctx || !first' is basically 'always' and the test for
first is relatively cheap, omit that first branch entirely.

Reported-by: Yanfei Xu <yanfei.xu@windriver.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Reviewed-by: Yanfei Xu <yanfei.xu@windriver.com>
Link: https://lore.kernel.org/r/20210630154114.896786297@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/mutex.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 354151fef06a..fbc62d360419 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -911,7 +911,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
 {
 	struct mutex_waiter waiter;
-	bool first = false;
 	struct ww_mutex *ww;
 	int ret;
 
@@ -986,6 +985,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	set_current_state(state);
 	for (;;) {
+		bool first;
+
 		/*
 		 * Once we hold wait_lock, we're serialized against
 		 * mutex_unlock() handing the lock off to us, do a trylock
@@ -1014,15 +1015,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		spin_unlock(&lock->wait_lock);
 		schedule_preempt_disabled();
 
-		/*
-		 * ww_mutex needs to always recheck its position since its waiter
-		 * list is not FIFO ordered.
-		 */
-		if (ww_ctx || !first) {
-			first = __mutex_waiter_is_first(lock, &waiter);
-			if (first)
-				__mutex_set_flag(lock, MUTEX_FLAG_HANDOFF);
-		}
+		first = __mutex_waiter_is_first(lock, &waiter);
+		if (first)
+			__mutex_set_flag(lock, MUTEX_FLAG_HANDOFF);
 
 		set_current_state(state);
 		/*
-- 
2.30.2

