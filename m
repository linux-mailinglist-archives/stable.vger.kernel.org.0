Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECFD4013D7
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbhIFB3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:29:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239189AbhIFB1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:27:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B8FD61183;
        Mon,  6 Sep 2021 01:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891365;
        bh=8GMfLaMzTij4R1fqr5DnHUDWQf97gN4MxHWyK995UkE=;
        h=From:To:Cc:Subject:Date:From;
        b=hf8eL/a0624FqzSvj399rQFzd6uALo6uDLpqZycDTVQI6z5aiASb4jjA/famyPOXj
         RXJI0HbkMkfxZsgm47QXNzDjTMWqZlnRMPiVUgNuAApcO4vA9ObcI11thpJawWLJyn
         egwiijtpVkXZHaEHvadLc+/uJGLoSbGSCn5tuHzlOaFqTLRnJDNgMFJIt6NK8ucHEN
         PQns53zd1vhtqfd9rZ4PjNjgNOJ6qLUzIUa9xugL4VHvdkQDNoKYbwYU9zplZvuUv1
         /+baKxeEF66lRvxxm/4dtJ5Ox5fz9OHWRsDLgtwDdmN6IwMjC8lhee/I4Ba27CCzu8
         AFgU0enYL50YA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 01/30] locking/mutex: Fix HANDOFF condition
Date:   Sun,  5 Sep 2021 21:22:14 -0400
Message-Id: <20210906012244.930338-1-sashal@kernel.org>
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
index c0c7784f074b..b02fff28221f 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -938,7 +938,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
 {
 	struct mutex_waiter waiter;
-	bool first = false;
 	struct ww_mutex *ww;
 	int ret;
 
@@ -1017,6 +1016,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	set_current_state(state);
 	for (;;) {
+		bool first;
+
 		/*
 		 * Once we hold wait_lock, we're serialized against
 		 * mutex_unlock() handing the lock off to us, do a trylock
@@ -1045,15 +1046,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
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

