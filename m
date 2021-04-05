Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B308353EAB
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbhDEJHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238269AbhDEJHJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:07:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AECA61398;
        Mon,  5 Apr 2021 09:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613623;
        bh=xCGmuBCetSBOXtZaRSCKhhI8Vsve5Ejh8kNFeNeeWUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBt9SMfjHy8UvsA6igLadgcDDhO31ghHenbpCc22G5esTDFDlh+j2g5jLvEgdaoto
         mqS0oSF7JQKWV31w72BdfXxcU4t8I5+jhJJW93h+/6wQiLdrq/t3uDqfc45XA6pOxJ
         497gJuxhnME0qEI3l2R9lcY0Z8+1QZ6zpONpcO04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/126] locking/ww_mutex: Simplify use_ww_ctx & ww_ctx handling
Date:   Mon,  5 Apr 2021 10:53:12 +0200
Message-Id: <20210405085032.038089859@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 5de2055d31ea88fd9ae9709ac95c372a505a60fa ]

The use_ww_ctx flag is passed to mutex_optimistic_spin(), but the
function doesn't use it. The frequent use of the (use_ww_ctx && ww_ctx)
combination is repetitive.

In fact, ww_ctx should not be used at all if !use_ww_ctx.  Simplify
ww_mutex code by dropping use_ww_ctx from mutex_optimistic_spin() an
clear ww_ctx if !use_ww_ctx. In this way, we can replace (use_ww_ctx &&
ww_ctx) by just (ww_ctx).

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Link: https://lore.kernel.org/r/20210316153119.13802-2-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/mutex.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 5352ce50a97e..2c25b830203c 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -636,7 +636,7 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
  */
 static __always_inline bool
 mutex_optimistic_spin(struct mutex *lock, struct ww_acquire_ctx *ww_ctx,
-		      const bool use_ww_ctx, struct mutex_waiter *waiter)
+		      struct mutex_waiter *waiter)
 {
 	if (!waiter) {
 		/*
@@ -712,7 +712,7 @@ fail:
 #else
 static __always_inline bool
 mutex_optimistic_spin(struct mutex *lock, struct ww_acquire_ctx *ww_ctx,
-		      const bool use_ww_ctx, struct mutex_waiter *waiter)
+		      struct mutex_waiter *waiter)
 {
 	return false;
 }
@@ -932,6 +932,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct ww_mutex *ww;
 	int ret;
 
+	if (!use_ww_ctx)
+		ww_ctx = NULL;
+
 	might_sleep();
 
 #ifdef CONFIG_DEBUG_MUTEXES
@@ -939,7 +942,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 #endif
 
 	ww = container_of(lock, struct ww_mutex, base);
-	if (use_ww_ctx && ww_ctx) {
+	if (ww_ctx) {
 		if (unlikely(ww_ctx == READ_ONCE(ww->ctx)))
 			return -EALREADY;
 
@@ -956,10 +959,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	mutex_acquire_nest(&lock->dep_map, subclass, 0, nest_lock, ip);
 
 	if (__mutex_trylock(lock) ||
-	    mutex_optimistic_spin(lock, ww_ctx, use_ww_ctx, NULL)) {
+	    mutex_optimistic_spin(lock, ww_ctx, NULL)) {
 		/* got the lock, yay! */
 		lock_acquired(&lock->dep_map, ip);
-		if (use_ww_ctx && ww_ctx)
+		if (ww_ctx)
 			ww_mutex_set_context_fastpath(ww, ww_ctx);
 		preempt_enable();
 		return 0;
@@ -970,7 +973,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 * After waiting to acquire the wait_lock, try again.
 	 */
 	if (__mutex_trylock(lock)) {
-		if (use_ww_ctx && ww_ctx)
+		if (ww_ctx)
 			__ww_mutex_check_waiters(lock, ww_ctx);
 
 		goto skip_wait;
@@ -1023,7 +1026,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 			goto err;
 		}
 
-		if (use_ww_ctx && ww_ctx) {
+		if (ww_ctx) {
 			ret = __ww_mutex_check_kill(lock, &waiter, ww_ctx);
 			if (ret)
 				goto err;
@@ -1036,7 +1039,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * ww_mutex needs to always recheck its position since its waiter
 		 * list is not FIFO ordered.
 		 */
-		if ((use_ww_ctx && ww_ctx) || !first) {
+		if (ww_ctx || !first) {
 			first = __mutex_waiter_is_first(lock, &waiter);
 			if (first)
 				__mutex_set_flag(lock, MUTEX_FLAG_HANDOFF);
@@ -1049,7 +1052,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * or we must see its unlock and acquire.
 		 */
 		if (__mutex_trylock(lock) ||
-		    (first && mutex_optimistic_spin(lock, ww_ctx, use_ww_ctx, &waiter)))
+		    (first && mutex_optimistic_spin(lock, ww_ctx, &waiter)))
 			break;
 
 		spin_lock(&lock->wait_lock);
@@ -1058,7 +1061,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 acquired:
 	__set_current_state(TASK_RUNNING);
 
-	if (use_ww_ctx && ww_ctx) {
+	if (ww_ctx) {
 		/*
 		 * Wound-Wait; we stole the lock (!first_waiter), check the
 		 * waiters as anyone might want to wound us.
@@ -1078,7 +1081,7 @@ skip_wait:
 	/* got the lock - cleanup and rejoice! */
 	lock_acquired(&lock->dep_map, ip);
 
-	if (use_ww_ctx && ww_ctx)
+	if (ww_ctx)
 		ww_mutex_lock_acquired(ww, ww_ctx);
 
 	spin_unlock(&lock->wait_lock);
-- 
2.30.1



