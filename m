Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD49E4520A2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344398AbhKPAzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:55:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343495AbhKOTVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF2B63596;
        Mon, 15 Nov 2021 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001645;
        bh=4wf8UWcTv1rLGHS8fgHGu8myWQH7RZ2C2LTKyq8rh1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQ6VuX5fk7vAJWWvEk2MZAKBYezjAuUY+CZkRBkYk889EyO2+PGWTH8OYC1oVb0zU
         UpY52h9HCUa/M2S6dD+gaIPzYq23ko0BKge7GLivLbGCjBi3/LcxnVBuDDLSUXsVae
         My1UGRn5yX3wMe2MaOoHFijo76HeM2zqkUJVpEfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yanfei Xu <yanfei.xu@windriver.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/917] locking/rwsem: Disable preemption for spinning region
Date:   Mon, 15 Nov 2021 17:56:02 +0100
Message-Id: <20211115165437.830505099@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 000e8d5a28841..29eea50a3e678 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -577,6 +577,24 @@ static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
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
@@ -632,23 +650,6 @@ static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
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
@@ -878,12 +879,11 @@ static inline bool rwsem_optimistic_spin(struct rw_semaphore *sem)
 
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
@@ -1095,9 +1095,16 @@ wait:
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



