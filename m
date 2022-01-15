Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9EE48F3B5
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 02:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiAOBBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 20:01:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38286 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiAOBBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 20:01:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0848D6208B
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 01:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FC3C36AEA;
        Sat, 15 Jan 2022 01:01:50 +0000 (UTC)
From:   Jaegeuk Kim <jaegeuk@google.com>
To:     stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5/7] locking/rwsem: Prevent potential lock starvation
Date:   Fri, 14 Jan 2022 16:59:44 -0800
Message-Id: <20220115005945.2125174-6-jaegeuk@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
In-Reply-To: <20220115005945.2125174-1-jaegeuk@google.com>
References: <20220115005945.2125174-1-jaegeuk@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit 2f06f702925b512a95b95dca3855549c047eef58 upstream.

The lock handoff bit is added in commit 4f23dbc1e657 ("locking/rwsem:
Implement lock handoff to prevent lock starvation") to avoid lock
starvation. However, allowing readers to do optimistic spinning does
introduce an unlikely scenario where lock starvation can happen.

The lock handoff bit may only be set when a waiter is being woken up.
In the case of reader unlock, wakeup happens only when the reader count
reaches 0. If there is a continuous stream of incoming readers acquiring
read lock via optimistic spinning, it is possible that the reader count
may never reach 0 and so the handoff bit will never be asserted.

One way to prevent this scenario from happening is to disallow optimistic
spinning if the rwsem is currently owned by readers. If the previous
or current owner is a writer, optimistic spinning will be allowed.

If the previous owner is a reader but the reader count has reached 0
before, a wakeup should have been issued. So the handoff mechanism
will be kicked in to prevent lock starvation. As a result, it should
be OK to do optimistic spinning in this case.

This patch may have some impact on reader performance as it reduces
reader optimistic spinning especially if the lock critical sections
are short the number of contending readers are small.

Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Link: https://lkml.kernel.org/r/20201121041416.12285-3-longman@redhat.com
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 kernel/locking/rwsem.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 5768b90223c0..c055f4b28b23 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1010,16 +1010,27 @@ rwsem_spin_on_owner(struct rw_semaphore *sem, unsigned long nonspinnable)
 static struct rw_semaphore __sched *
 rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, int state)
 {
-	long adjustment = -RWSEM_READER_BIAS;
+	long owner, adjustment = -RWSEM_READER_BIAS;
+	long rcnt = (count >> RWSEM_READER_SHIFT);
 	struct rwsem_waiter waiter;
 	DEFINE_WAKE_Q(wake_q);
 	bool wake = false;
 
+	/*
+	 * To prevent a constant stream of readers from starving a sleeping
+	 * waiter, don't attempt optimistic spinning if the lock is currently
+	 * owned by readers.
+	 */
+	owner = atomic_long_read(&sem->owner);
+	if ((owner & RWSEM_READER_OWNED) && (rcnt > 1) &&
+	   !(count & RWSEM_WRITER_LOCKED))
+		goto queue;
+
 	/*
 	 * Save the current read-owner of rwsem, if available, and the
 	 * reader nonspinnable bit.
 	 */
-	waiter.last_rowner = atomic_long_read(&sem->owner);
+	waiter.last_rowner = owner;
 	if (!(waiter.last_rowner & RWSEM_READER_OWNED))
 		waiter.last_rowner &= RWSEM_RD_NONSPINNABLE;
 
-- 
2.34.1.703.g22d0c6ccf7-goog

