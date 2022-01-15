Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DE548F3B2
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 02:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiAOBBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 20:01:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38270 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiAOBBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 20:01:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D037620C8
        for <stable@vger.kernel.org>; Sat, 15 Jan 2022 01:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FDFC36AEF;
        Sat, 15 Jan 2022 01:01:49 +0000 (UTC)
From:   Jaegeuk Kim <jaegeuk@google.com>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/7] locking/rwsem: Fold __down_{read,write}*()
Date:   Fri, 14 Jan 2022 16:59:42 -0800
Message-Id: <20220115005945.2125174-4-jaegeuk@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
In-Reply-To: <20220115005945.2125174-1-jaegeuk@google.com>
References: <20220115005945.2125174-1-jaegeuk@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit c995e638ccbbc65a76d1713c4fdcf927e7e2cb83 upstream.

There's a lot needless duplication in __down_{read,write}*(), cure
that with a helper.

Cc: <stable@vger.kernel.org> # 5.10
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201207090243.GE3040@hirez.programming.kicks-ass.net
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 kernel/locking/rwsem.c | 45 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 7915456b9dfa..67ae366d08dd 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1354,32 +1354,29 @@ static struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
 /*
  * lock for reading
  */
-static inline void __down_read(struct rw_semaphore *sem)
+static inline int __down_read_common(struct rw_semaphore *sem, int state)
 {
 	if (!rwsem_read_trylock(sem)) {
-		rwsem_down_read_slowpath(sem, TASK_UNINTERRUPTIBLE);
+		if (IS_ERR(rwsem_down_read_slowpath(sem, state)))
+			return -EINTR;
 		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
 	}
+	return 0;
+}
+
+static inline void __down_read(struct rw_semaphore *sem)
+{
+	__down_read_common(sem, TASK_UNINTERRUPTIBLE);
 }
 
 static inline int __down_read_interruptible(struct rw_semaphore *sem)
 {
-	if (!rwsem_read_trylock(sem)) {
-		if (IS_ERR(rwsem_down_read_slowpath(sem, TASK_INTERRUPTIBLE)))
-			return -EINTR;
-		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
-	}
-	return 0;
+	return __down_read_common(sem, TASK_INTERRUPTIBLE);
 }
 
 static inline int __down_read_killable(struct rw_semaphore *sem)
 {
-	if (!rwsem_read_trylock(sem)) {
-		if (IS_ERR(rwsem_down_read_slowpath(sem, TASK_KILLABLE)))
-			return -EINTR;
-		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
-	}
-	return 0;
+	return __down_read_common(sem, TASK_KILLABLE);
 }
 
 static inline int __down_read_trylock(struct rw_semaphore *sem)
@@ -1405,22 +1402,26 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 /*
  * lock for writing
  */
-static inline void __down_write(struct rw_semaphore *sem)
-{
-	if (unlikely(!rwsem_write_trylock(sem)))
-		rwsem_down_write_slowpath(sem, TASK_UNINTERRUPTIBLE);
-}
-
-static inline int __down_write_killable(struct rw_semaphore *sem)
+static inline int __down_write_common(struct rw_semaphore *sem, int state)
 {
 	if (unlikely(!rwsem_write_trylock(sem))) {
-		if (IS_ERR(rwsem_down_write_slowpath(sem, TASK_KILLABLE)))
+		if (IS_ERR(rwsem_down_write_slowpath(sem, state)))
 			return -EINTR;
 	}
 
 	return 0;
 }
 
+static inline void __down_write(struct rw_semaphore *sem)
+{
+	__down_write_common(sem, TASK_UNINTERRUPTIBLE);
+}
+
+static inline int __down_write_killable(struct rw_semaphore *sem)
+{
+	return __down_write_common(sem, TASK_KILLABLE);
+}
+
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
 	DEBUG_RWSEMS_WARN_ON(sem->magic != sem, sem);
-- 
2.34.1.703.g22d0c6ccf7-goog

