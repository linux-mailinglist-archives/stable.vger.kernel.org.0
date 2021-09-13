Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B27408DF6
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241137AbhIMNaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242191AbhIMN1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00D4861262;
        Mon, 13 Sep 2021 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539395;
        bh=awkMFSxMCgFztQ1H6e9Os/EiJVcjRzIoHJ5ntvCINHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IORVmElHw79KMUc3uSk+zMA7Gpbe4/tOlak2CkHpd2SQGDDlGL1UZIQz7e+xh7Frn
         QDINLY/ioPy133r+0V8/atjPsb9scJkha/lBgyFEZzSZ1yFXubyqatm3OWlQm9V8wM
         EG8aHeKCfMMRMj039sMh5BV7vR+ZscHdzgkB1piI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanfei Xu <yanfei.xu@windriver.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/236] locking/mutex: Fix HANDOFF condition
Date:   Mon, 13 Sep 2021 15:11:46 +0200
Message-Id: <20210913131100.371445248@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
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
index 15ac7c4bb111..86061901636c 100644
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



