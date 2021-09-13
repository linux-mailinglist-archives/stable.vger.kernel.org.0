Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC3F409364
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343968AbhIMOVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343883AbhIMOSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:18:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45B8C61B3A;
        Mon, 13 Sep 2021 13:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540723;
        bh=dSSwxNR22pqNEu8qQY4t32lLb4KK1l2y3PGYoECrEb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HMV+S1IHpP6vc5/OvozQWQ+rPxFOXzh9RdYH81Vp6Et2mxG19Gy3u+x9iHjznrf9r
         kMWUYTX1N8khWcaSWqkuIt7XaUdqBneI2g3XEo11dLdSg3U/pkx1H8u3x3rD13LR0w
         giOdKD7CB3OWT+qxPig+6Pgw3w+W641AYhyo1tqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanfei Xu <yanfei.xu@windriver.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 001/334] locking/mutex: Fix HANDOFF condition
Date:   Mon, 13 Sep 2021 15:10:55 +0200
Message-Id: <20210913131113.440891090@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



