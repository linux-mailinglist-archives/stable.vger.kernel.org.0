Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A75648F3B7
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 02:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiAOBBx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 20:01:53 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34456 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiAOBBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 20:01:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA527CE24C6
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 01:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E595C36AED;
        Sat, 15 Jan 2022 01:01:49 +0000 (UTC)
From:   Jaegeuk Kim <jaegeuk@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/7] locking/rwsem: Introduce rwsem_write_trylock()
Date:   Fri, 14 Jan 2022 16:59:41 -0800
Message-Id: <20220115005945.2125174-3-jaegeuk@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
In-Reply-To: <20220115005945.2125174-1-jaegeuk@google.com>
References: <20220115005945.2125174-1-jaegeuk@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 285c61aedf6bc5d81b37e4dc48c19012e8ff9836 upstream.

One copy of this logic is better than three.

Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201207090243.GE3040@hirez.programming.kicks-ass.net
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 kernel/locking/rwsem.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 5c0dc7ebace9..7915456b9dfa 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -285,6 +285,18 @@ static inline bool rwsem_read_trylock(struct rw_semaphore *sem)
 	return false;
 }
 
+static inline bool rwsem_write_trylock(struct rw_semaphore *sem)
+{
+	long tmp = RWSEM_UNLOCKED_VALUE;
+
+	if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp, RWSEM_WRITER_LOCKED)) {
+		rwsem_set_owner(sem);
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Return just the real task structure pointer of the owner
  */
@@ -1395,42 +1407,24 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
  */
 static inline void __down_write(struct rw_semaphore *sem)
 {
-	long tmp = RWSEM_UNLOCKED_VALUE;
-
-	if (unlikely(!atomic_long_try_cmpxchg_acquire(&sem->count, &tmp,
-						      RWSEM_WRITER_LOCKED)))
+	if (unlikely(!rwsem_write_trylock(sem)))
 		rwsem_down_write_slowpath(sem, TASK_UNINTERRUPTIBLE);
-	else
-		rwsem_set_owner(sem);
 }
 
 static inline int __down_write_killable(struct rw_semaphore *sem)
 {
-	long tmp = RWSEM_UNLOCKED_VALUE;
-
-	if (unlikely(!atomic_long_try_cmpxchg_acquire(&sem->count, &tmp,
-						      RWSEM_WRITER_LOCKED))) {
+	if (unlikely(!rwsem_write_trylock(sem))) {
 		if (IS_ERR(rwsem_down_write_slowpath(sem, TASK_KILLABLE)))
 			return -EINTR;
-	} else {
-		rwsem_set_owner(sem);
 	}
+
 	return 0;
 }
 
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	long tmp;
-
 	DEBUG_RWSEMS_WARN_ON(sem->magic != sem, sem);
-
-	tmp  = RWSEM_UNLOCKED_VALUE;
-	if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp,
-					    RWSEM_WRITER_LOCKED)) {
-		rwsem_set_owner(sem);
-		return true;
-	}
-	return false;
+	return rwsem_write_trylock(sem);
 }
 
 /*
-- 
2.34.1.703.g22d0c6ccf7-goog

