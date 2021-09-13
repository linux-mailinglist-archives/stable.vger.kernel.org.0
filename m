Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399864092A2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245749AbhIMONE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344237AbhIMOLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:11:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50FAD6134F;
        Mon, 13 Sep 2021 13:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540525;
        bh=6Qk9BssbyK0UYvw8za6Swqpm4GUFOO+l2eyAMHBkIfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9TGPck8CiebibiQGU7D2m8uNg5GEMNSvZgFGIOQsLXzn9P6TnMMKyOZ1s/kytzwF
         kl05slfunePUAPL66v85JsUr5fXbdQY/5Uej61OsvIETv8y83xw4x+EXCRHtkekKCh
         JiRoFSbR3WaO/NoY9EWdddISU6WOw6ZzJU7DasT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 197/300] locking/local_lock: Add missing owner initialization
Date:   Mon, 13 Sep 2021 15:14:18 +0200
Message-Id: <20210913131116.031623064@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit d8bbd97ad0b99a9394f2cd8410b884c48e218cf0 ]

If CONFIG_DEBUG_LOCK_ALLOC=y is enabled then local_lock_t has an 'owner'
member which is checked for consistency, but nothing initialized it to
zero explicitly.

The static initializer does so implicit, and the run time allocated per CPU
storage is usually zero initialized as well, but relying on that is not
really good practice.

Fixes: 91710728d172 ("locking: Introduce local_lock()")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210815211301.969975279@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/local_lock_internal.h | 42 ++++++++++++++++-------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lock_internal.h
index ded90b097e6e..3f02b818625e 100644
--- a/include/linux/local_lock_internal.h
+++ b/include/linux/local_lock_internal.h
@@ -14,29 +14,14 @@ typedef struct {
 } local_lock_t;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define LL_DEP_MAP_INIT(lockname)			\
+# define LOCAL_LOCK_DEBUG_INIT(lockname)		\
 	.dep_map = {					\
 		.name = #lockname,			\
 		.wait_type_inner = LD_WAIT_CONFIG,	\
-		.lock_type = LD_LOCK_PERCPU,			\
-	}
-#else
-# define LL_DEP_MAP_INIT(lockname)
-#endif
-
-#define INIT_LOCAL_LOCK(lockname)	{ LL_DEP_MAP_INIT(lockname) }
-
-#define __local_lock_init(lock)					\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	debug_check_no_locks_freed((void *)lock, sizeof(*lock));\
-	lockdep_init_map_type(&(lock)->dep_map, #lock, &__key, 0, \
-			      LD_WAIT_CONFIG, LD_WAIT_INV,	\
-			      LD_LOCK_PERCPU);			\
-} while (0)
+		.lock_type = LD_LOCK_PERCPU,		\
+	},						\
+	.owner = NULL,
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 static inline void local_lock_acquire(local_lock_t *l)
 {
 	lock_map_acquire(&l->dep_map);
@@ -51,11 +36,30 @@ static inline void local_lock_release(local_lock_t *l)
 	lock_map_release(&l->dep_map);
 }
 
+static inline void local_lock_debug_init(local_lock_t *l)
+{
+	l->owner = NULL;
+}
 #else /* CONFIG_DEBUG_LOCK_ALLOC */
+# define LOCAL_LOCK_DEBUG_INIT(lockname)
 static inline void local_lock_acquire(local_lock_t *l) { }
 static inline void local_lock_release(local_lock_t *l) { }
+static inline void local_lock_debug_init(local_lock_t *l) { }
 #endif /* !CONFIG_DEBUG_LOCK_ALLOC */
 
+#define INIT_LOCAL_LOCK(lockname)	{ LOCAL_LOCK_DEBUG_INIT(lockname) }
+
+#define __local_lock_init(lock)					\
+do {								\
+	static struct lock_class_key __key;			\
+								\
+	debug_check_no_locks_freed((void *)lock, sizeof(*lock));\
+	lockdep_init_map_type(&(lock)->dep_map, #lock, &__key,  \
+			      0, LD_WAIT_CONFIG, LD_WAIT_INV,	\
+			      LD_LOCK_PERCPU);			\
+	local_lock_debug_init(lock);				\
+} while (0)
+
 #define __local_lock(lock)					\
 	do {							\
 		preempt_disable();				\
-- 
2.30.2



