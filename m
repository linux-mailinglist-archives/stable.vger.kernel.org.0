Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F25451035
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242424AbhKOSog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:44:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242216AbhKOSme (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:42:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3F47632F5;
        Mon, 15 Nov 2021 18:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999499;
        bh=qBXhcfRIkT+gW40R/i3GsRWC5nKLP/VUTkqRaf1BxYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=op8QxQvhcB550hmy68mu1A970ACW9Cu+JZHmU25rM/4bemsXn9esLwNZXOKvc1tqG
         myPtK/dqOgImRm+JiMvnVMKkrKPfTe3dczpvjnh4Y7F765T4LNYS+VXZDAisHrrJBF
         5F2Ykh+jLsgIS6+e+jgpjQU6f7Ba5WNM0/r/u3ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanfei Xu <yanfei.xu@windriver.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 286/849] locking/rwsem: Disable preemption for spinning region
Date:   Mon, 15 Nov 2021 17:56:09 +0100
Message-Id: <20211115165429.948858608@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>

[ Upstream commit 7cdacc5f52d68a9370f182c844b5b3e6cc975cc1 ]

The spinning region rwsem_spin_on_owner() should not be preempted,
however the rwsem_down_write_slowpath() invokes it and don't disable
preemption. Fix it by adding a pair of preempt_disable/enable().

Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
[peterz: Fix CONFIG_RWSEM_SPIN_ON_OWNER=n build]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20211013134154.1085649-3-yanfei.xu@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/rwsem.c | 53 ++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 16bfbb10c74d7..1d42c18736380 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -576,6 +576,24 @@ static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 	return true;
 }
 
+/*
+ * The rwsem_spin_on_owner() function returns the following 4 values
+ * depending on the lock owner state.
+ *   OWNER_NULL  : owner is currently NULL
+ *   OWNER_WRITER: when owner changes and is a writer
+ *   OWNER_READER: when owner changes and the new owner may be a reader.
+ *   OWNER_NONSPINNABLE:
+ *		   when optimistic spinning has to stop because either the
+ *		   owner stops running, is unknown, or its timeslice has
+ *		   been used up.
+ */
+enum owner_state {
+	OWNER_NULL		= 1 << 0,
+	OWNER_WRITER		= 1 << 1,
+	OWNER_READER		= 1 << 2,
+	OWNER_NONSPINNABLE	= 1 << 3,
+};
+
 #ifdef CONFIG_RWSEM_SPIN_ON_OWNER
 /*
  * Try to acquire write lock before the writer has been put on wait queue.
@@ -631,23 +649,6 @@ static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
 	return ret;
 }
 
-/*
- * The rwsem_spin_on_owner() function returns the following 4 values
- * depending on the lock owner state.
- *   OWNER_NULL  : owner is currently NULL
- *   OWNER_WRITER: when owner changes and is a writer
- *   OWNER_READER: when owner changes and the new owner may be a reader.
- *   OWNER_NONSPINNABLE:
- *		   when optimistic spinning has to stop because either the
- *		   owner stops running, is unknown, or its timeslice has
- *		   been used up.
- */
-enum owner_state {
-	OWNER_NULL		= 1 << 0,
-	OWNER_WRITER		= 1 << 1,
-	OWNER_READER		= 1 << 2,
-	OWNER_NONSPINNABLE	= 1 << 3,
-};
 #define OWNER_SPINNABLE		(OWNER_NULL | OWNER_WRITER | OWNER_READER)
 
 static inline enum owner_state
@@ -877,12 +878,11 @@ static inline bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 
 static inline void clear_nonspinnable(struct rw_semaphore *sem) { }
 
-static inline int
+static inline enum owner_state
 rwsem_spin_on_owner(struct rw_semaphore *sem)
 {
-	return 0;
+	return OWNER_NONSPINNABLE;
 }
-#define OWNER_NULL	1
 #endif
 
 /*
@@ -1094,9 +1094,16 @@ wait:
 		 * In this case, we attempt to acquire the lock again
 		 * without sleeping.
 		 */
-		if (wstate == WRITER_HANDOFF &&
-		    rwsem_spin_on_owner(sem) == OWNER_NULL)
-			goto trylock_again;
+		if (wstate == WRITER_HANDOFF) {
+			enum owner_state owner_state;
+
+			preempt_disable();
+			owner_state = rwsem_spin_on_owner(sem);
+			preempt_enable();
+
+			if (owner_state == OWNER_NULL)
+				goto trylock_again;
+		}
 
 		/* Block until there are no active lockers. */
 		for (;;) {
-- 
2.33.0



