Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEABF5869D2
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbiHAMHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiHAMHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:07:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0CB5F130;
        Mon,  1 Aug 2022 04:55:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 663C761227;
        Mon,  1 Aug 2022 11:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705DBC433D6;
        Mon,  1 Aug 2022 11:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354921;
        bh=b3RRbMvj1I7RgAEBxzdVO+YSM6bS7D3bRC0SQIiEaLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j90pg0R8bZjGnBVsPgWC/KD687byOQwUOXkg2Jt5LH3YZ7bsxKH5a0Pdkc0K5F6Hu
         m1tIgV2/cNqmNNxRhqtvAAYQatUE4tlKouqdCNDTtcOCjWfecFtik9GnhiYlgaEBDU
         PtkSg/rHxuXkKxD1Qjufo6zQSP0Ix11a3dIyXaN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 5.15 68/69] locking/rwsem: Allow slowpath writer to ignore handoff bit if not set by first waiter
Date:   Mon,  1 Aug 2022 13:47:32 +0200
Message-Id: <20220801114137.213981995@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit 6eebd5fb20838f5971ba17df9f55cc4f84a31053 upstream.

With commit d257cc8cb8d5 ("locking/rwsem: Make handoff bit handling more
consistent"), the writer that sets the handoff bit can be interrupted
out without clearing the bit if the wait queue isn't empty. This disables
reader and writer optimistic lock spinning and stealing.

Now if a non-first writer in the queue is somehow woken up or a new
waiter enters the slowpath, it can't acquire the lock.  This is not the
case before commit d257cc8cb8d5 as the writer that set the handoff bit
will clear it when exiting out via the out_nolock path. This is less
efficient as the busy rwsem stays in an unlock state for a longer time.

In some cases, this new behavior may cause lockups as shown in [1] and
[2].

This patch allows a non-first writer to ignore the handoff bit if it
is not originally set or initiated by the first waiter. This patch is
shown to be effective in fixing the lockup problem reported in [1].

[1] https://lore.kernel.org/lkml/20220617134325.GC30825@techsingularity.net/
[2] https://lore.kernel.org/lkml/3f02975c-1a9d-be20-32cf-f1d8e3dfafcc@oracle.com/

Fixes: d257cc8cb8d5 ("locking/rwsem: Make handoff bit handling more consistent")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: John Donnelly <john.p.donnelly@oracle.com>
Tested-by: Mel Gorman <mgorman@techsingularity.net>
Link: https://lore.kernel.org/r/20220622200419.778799-1-longman@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rwsem.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -335,8 +335,6 @@ struct rwsem_waiter {
 	struct task_struct *task;
 	enum rwsem_waiter_type type;
 	unsigned long timeout;
-
-	/* Writer only, not initialized in reader */
 	bool handoff_set;
 };
 #define rwsem_first_waiter(sem) \
@@ -456,10 +454,12 @@ static void rwsem_mark_wake(struct rw_se
 			 * to give up the lock), request a HANDOFF to
 			 * force the issue.
 			 */
-			if (!(oldcount & RWSEM_FLAG_HANDOFF) &&
-			    time_after(jiffies, waiter->timeout)) {
-				adjustment -= RWSEM_FLAG_HANDOFF;
-				lockevent_inc(rwsem_rlock_handoff);
+			if (time_after(jiffies, waiter->timeout)) {
+				if (!(oldcount & RWSEM_FLAG_HANDOFF)) {
+					adjustment -= RWSEM_FLAG_HANDOFF;
+					lockevent_inc(rwsem_rlock_handoff);
+				}
+				waiter->handoff_set = true;
 			}
 
 			atomic_long_add(-adjustment, &sem->count);
@@ -569,7 +569,7 @@ static void rwsem_mark_wake(struct rw_se
 static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 					struct rwsem_waiter *waiter)
 {
-	bool first = rwsem_first_waiter(sem) == waiter;
+	struct rwsem_waiter *first = rwsem_first_waiter(sem);
 	long count, new;
 
 	lockdep_assert_held(&sem->wait_lock);
@@ -579,11 +579,20 @@ static inline bool rwsem_try_write_lock(
 		bool has_handoff = !!(count & RWSEM_FLAG_HANDOFF);
 
 		if (has_handoff) {
-			if (!first)
+			/*
+			 * Honor handoff bit and yield only when the first
+			 * waiter is the one that set it. Otherwisee, we
+			 * still try to acquire the rwsem.
+			 */
+			if (first->handoff_set && (waiter != first))
 				return false;
 
-			/* First waiter inherits a previously set handoff bit */
-			waiter->handoff_set = true;
+			/*
+			 * First waiter can inherit a previously set handoff
+			 * bit and spin on rwsem if lock acquisition fails.
+			 */
+			if (waiter == first)
+				waiter->handoff_set = true;
 		}
 
 		new = count;
@@ -978,6 +987,7 @@ queue:
 	waiter.task = current;
 	waiter.type = RWSEM_WAITING_FOR_READ;
 	waiter.timeout = jiffies + RWSEM_WAIT_TIMEOUT;
+	waiter.handoff_set = false;
 
 	raw_spin_lock_irq(&sem->wait_lock);
 	if (list_empty(&sem->wait_list)) {


