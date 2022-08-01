Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549D2586A9F
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiHAMTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbiHAMTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:19:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DDB41D15;
        Mon,  1 Aug 2022 04:59:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DE078CE13BB;
        Mon,  1 Aug 2022 11:59:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B723BC433C1;
        Mon,  1 Aug 2022 11:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355168;
        bh=XxqsD3U98yw1lQ/BwBmwPGQr8/vBQvrLbn9UdZ7K0EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDxKbnPfv4BOevoR+fLZOKD4tki4X15zWvSMsK4XMWwHCY97evuyFj36L0U75R6w1
         toYazf0DmU7GhXO27DxvjLNaXEwXSb86WpJyR2wtBLITXjlxoK/EWBbukbjKEhUE6t
         Msd0MbnKKEO8ygJuISo9NFdLi+QdDPTglc1RFQUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        John Donnelly <john.p.donnelly@oracle.com>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 5.18 87/88] locking/rwsem: Allow slowpath writer to ignore handoff bit if not set by first waiter
Date:   Mon,  1 Aug 2022 13:47:41 +0200
Message-Id: <20220801114141.946225686@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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
@@ -334,8 +334,6 @@ struct rwsem_waiter {
 	struct task_struct *task;
 	enum rwsem_waiter_type type;
 	unsigned long timeout;
-
-	/* Writer only, not initialized in reader */
 	bool handoff_set;
 };
 #define rwsem_first_waiter(sem) \
@@ -455,10 +453,12 @@ static void rwsem_mark_wake(struct rw_se
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
@@ -568,7 +568,7 @@ static void rwsem_mark_wake(struct rw_se
 static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 					struct rwsem_waiter *waiter)
 {
-	bool first = rwsem_first_waiter(sem) == waiter;
+	struct rwsem_waiter *first = rwsem_first_waiter(sem);
 	long count, new;
 
 	lockdep_assert_held(&sem->wait_lock);
@@ -578,11 +578,20 @@ static inline bool rwsem_try_write_lock(
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
@@ -972,6 +981,7 @@ queue:
 	waiter.task = current;
 	waiter.type = RWSEM_WAITING_FOR_READ;
 	waiter.timeout = jiffies + RWSEM_WAIT_TIMEOUT;
+	waiter.handoff_set = false;
 
 	raw_spin_lock_irq(&sem->wait_lock);
 	if (list_empty(&sem->wait_list)) {


