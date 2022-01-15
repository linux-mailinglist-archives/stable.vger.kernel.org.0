Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB7448F3B4
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 02:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiAOBBv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 20:01:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38282 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiAOBBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 20:01:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFB6C620C3
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 01:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DFAC36AE7;
        Sat, 15 Jan 2022 01:01:50 +0000 (UTC)
From:   Jaegeuk Kim <jaegeuk@google.com>
To:     stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4/7] locking/rwsem: Pass the current atomic count to rwsem_down_read_slowpath()
Date:   Fri, 14 Jan 2022 16:59:43 -0800
Message-Id: <20220115005945.2125174-5-jaegeuk@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
In-Reply-To: <20220115005945.2125174-1-jaegeuk@google.com>
References: <20220115005945.2125174-1-jaegeuk@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit c8fe8b0564388f41147326f31e4587171aacccd4 upstream.

The atomic count value right after reader count increment can be useful
to determine the rwsem state at trylock time. So the count value is
passed down to rwsem_down_read_slowpath() to be used when appropriate.

Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Link: https://lkml.kernel.org/r/20201121041416.12285-2-longman@redhat.com
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 kernel/locking/rwsem.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 67ae366d08dd..5768b90223c0 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -270,14 +270,14 @@ static inline void rwsem_set_nonspinnable(struct rw_semaphore *sem)
 					  owner | RWSEM_NONSPINNABLE));
 }
 
-static inline bool rwsem_read_trylock(struct rw_semaphore *sem)
+static inline bool rwsem_read_trylock(struct rw_semaphore *sem, long *cntp)
 {
-	long cnt = atomic_long_add_return_acquire(RWSEM_READER_BIAS, &sem->count);
+	*cntp = atomic_long_add_return_acquire(RWSEM_READER_BIAS, &sem->count);
 
-	if (WARN_ON_ONCE(cnt < 0))
+	if (WARN_ON_ONCE(*cntp < 0))
 		rwsem_set_nonspinnable(sem);
 
-	if (!(cnt & RWSEM_READ_FAILED_MASK)) {
+	if (!(*cntp & RWSEM_READ_FAILED_MASK)) {
 		rwsem_set_reader_owned(sem);
 		return true;
 	}
@@ -1008,9 +1008,9 @@ rwsem_spin_on_owner(struct rw_semaphore *sem, unsigned long nonspinnable)
  * Wait for the read lock to be granted
  */
 static struct rw_semaphore __sched *
-rwsem_down_read_slowpath(struct rw_semaphore *sem, int state)
+rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, int state)
 {
-	long count, adjustment = -RWSEM_READER_BIAS;
+	long adjustment = -RWSEM_READER_BIAS;
 	struct rwsem_waiter waiter;
 	DEFINE_WAKE_Q(wake_q);
 	bool wake = false;
@@ -1356,8 +1356,10 @@ static struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
  */
 static inline int __down_read_common(struct rw_semaphore *sem, int state)
 {
-	if (!rwsem_read_trylock(sem)) {
-		if (IS_ERR(rwsem_down_read_slowpath(sem, state)))
+	long count;
+
+	if (!rwsem_read_trylock(sem, &count)) {
+		if (IS_ERR(rwsem_down_read_slowpath(sem, count, state)))
 			return -EINTR;
 		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
 	}
-- 
2.34.1.703.g22d0c6ccf7-goog

