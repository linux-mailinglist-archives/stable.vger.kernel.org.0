Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A843248F3B8
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 02:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiAOBB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 20:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiAOBBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 20:01:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B674AC06173E
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 17:01:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB660620C5
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 01:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591FDC36AE9;
        Sat, 15 Jan 2022 01:01:51 +0000 (UTC)
From:   Jaegeuk Kim <jaegeuk@google.com>
To:     stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6/7] locking/rwsem: Enable reader optimistic lock stealing
Date:   Fri, 14 Jan 2022 16:59:45 -0800
Message-Id: <20220115005945.2125174-7-jaegeuk@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
In-Reply-To: <20220115005945.2125174-1-jaegeuk@google.com>
References: <20220115005945.2125174-1-jaegeuk@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit 1a728dff855a318bb58bcc1259b1826a7ad9f0bd upstream.

If the optimistic spinning queue is empty and the rwsem does not have
the handoff or write-lock bits set, it is actually not necessary to
call rwsem_optimistic_spin() to spin on it. Instead, it can steal the
lock directly as its reader bias is in the count already.  If it is
the first reader in this state, it will try to wake up other readers
in the wait queue.

With this patch applied, the following were the lock event counts
after rebooting a 2-socket system and a "make -j96" kernel rebuild.

  rwsem_opt_rlock=4437
  rwsem_rlock=29
  rwsem_rlock_steal=19

So lock stealing represents about 0.4% of all the read locks acquired
in the slow path.

Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Link: https://lkml.kernel.org/r/20201121041416.12285-4-longman@redhat.com
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 kernel/locking/lock_events_list.h |  1 +
 kernel/locking/rwsem.c            | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/kernel/locking/lock_events_list.h b/kernel/locking/lock_events_list.h
index 239039d0ce21..270a0d351932 100644
--- a/kernel/locking/lock_events_list.h
+++ b/kernel/locking/lock_events_list.h
@@ -63,6 +63,7 @@ LOCK_EVENT(rwsem_opt_nospin)	/* # of disabled optspins		*/
 LOCK_EVENT(rwsem_opt_norspin)	/* # of disabled reader-only optspins	*/
 LOCK_EVENT(rwsem_opt_rlock2)	/* # of opt-acquired 2ndary read locks	*/
 LOCK_EVENT(rwsem_rlock)		/* # of read locks acquired		*/
+LOCK_EVENT(rwsem_rlock_steal)	/* # of read locks by lock stealing	*/
 LOCK_EVENT(rwsem_rlock_fast)	/* # of fast read locks acquired	*/
 LOCK_EVENT(rwsem_rlock_fail)	/* # of failed read lock acquisitions	*/
 LOCK_EVENT(rwsem_rlock_handoff)	/* # of read lock handoffs		*/
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index c055f4b28b23..ba5e239d08e7 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -976,6 +976,12 @@ static inline bool rwsem_reader_phase_trylock(struct rw_semaphore *sem,
 	}
 	return false;
 }
+
+static inline bool rwsem_no_spinners(struct rw_semaphore *sem)
+{
+	return !osq_is_locked(&sem->osq);
+}
+
 #else
 static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem,
 					   unsigned long nonspinnable)
@@ -996,6 +1002,11 @@ static inline bool rwsem_reader_phase_trylock(struct rw_semaphore *sem,
 	return false;
 }
 
+static inline bool rwsem_no_spinners(sem)
+{
+	return false;
+}
+
 static inline int
 rwsem_spin_on_owner(struct rw_semaphore *sem, unsigned long nonspinnable)
 {
@@ -1026,6 +1037,22 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, int state)
 	   !(count & RWSEM_WRITER_LOCKED))
 		goto queue;
 
+	/*
+	 * Reader optimistic lock stealing
+	 *
+	 * We can take the read lock directly without doing
+	 * rwsem_optimistic_spin() if the conditions are right.
+	 * Also wake up other readers if it is the first reader.
+	 */
+	if (!(count & (RWSEM_WRITER_LOCKED | RWSEM_FLAG_HANDOFF)) &&
+	    rwsem_no_spinners(sem)) {
+		rwsem_set_reader_owned(sem);
+		lockevent_inc(rwsem_rlock_steal);
+		if (rcnt == 1)
+			goto wake_readers;
+		return sem;
+	}
+
 	/*
 	 * Save the current read-owner of rwsem, if available, and the
 	 * reader nonspinnable bit.
@@ -1048,6 +1075,7 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, int state)
 		 * Wake up other readers in the wait list if the front
 		 * waiter is a reader.
 		 */
+wake_readers:
 		if ((atomic_long_read(&sem->count) & RWSEM_FLAG_WAITERS)) {
 			raw_spin_lock_irq(&sem->wait_lock);
 			if (!list_empty(&sem->wait_list))
-- 
2.34.1.703.g22d0c6ccf7-goog

