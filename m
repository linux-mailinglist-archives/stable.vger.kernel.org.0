Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42BB40126B
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbhIFBU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231383AbhIFBU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:20:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 827AB60F5E;
        Mon,  6 Sep 2021 01:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891193;
        bh=dSSwxNR22pqNEu8qQY4t32lLb4KK1l2y3PGYoECrEb0=;
        h=From:To:Cc:Subject:Date:From;
        b=CJUluLIAa3NWJ7jbkVmQglESVF0h+ochOtqj22tl4a6aXmQg+1osZnTXgrz85vtfR
         MAvH2MuRCfGVNsE8X4Cao38kTpclNce9RDc2OH27JBjO21Hz2XIqJD8V7/YurH+Djy
         8/E7U9B7OAI9rzSuS16udWUyKxNzbqpu4knIBv2xfVDEq+ySiY34iRiaui4K1QnJP6
         /TVswZ6gy44TfA/CL2oEYI9B4SC3HUX1ARgrtCAp3qlZtEhJqFrqC8kSxlL5qvr9V2
         Gf3VvMqCqvQEgSY8cySoxAbmHQDOOWJB/G/1pH5VAoU5PBEKoXn2H74lE/rZgnvHJB
         BvoLjqfZlyy/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 01/47] locking/mutex: Fix HANDOFF condition
Date:   Sun,  5 Sep 2021 21:19:05 -0400
Message-Id: <20210906011951.928679-1-sashal@kernel.org>
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
index d2df5e68b503..fb30e1436dfb 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -928,7 +928,6 @@ __mutex_lock_common(struct mutex *lock, unsigned int state, unsigned int subclas
 		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
 {
 	struct mutex_waiter waiter;
-	bool first = false;
 	struct ww_mutex *ww;
 	int ret;
 
@@ -1007,6 +1006,8 @@ __mutex_lock_common(struct mutex *lock, unsigned int state, unsigned int subclas
 
 	set_current_state(state);
 	for (;;) {
+		bool first;
+
 		/*
 		 * Once we hold wait_lock, we're serialized against
 		 * mutex_unlock() handing the lock off to us, do a trylock
@@ -1035,15 +1036,9 @@ __mutex_lock_common(struct mutex *lock, unsigned int state, unsigned int subclas
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

