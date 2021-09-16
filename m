Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F043F40E7DB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244616AbhIPRgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353426AbhIPRdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3170961A7F;
        Thu, 16 Sep 2021 16:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810908;
        bh=CV74dxIjhbf32IWeE/xsVObqeVRJv4nlTAX7l/Jk+zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3hKnymlRTXok7Gt56F3g3mQHkowFytI5QVjyPm5EWGfCHteD+kM7MLz2HhzIDu0X
         rtplUp7uCYSb4dDUfoxEbfwzRJFBoCthdw4wbAcujFGifrHbzGPJHXKSFYS86K5tIz
         Id5/mFSHRS4qLSqBxk5N0YnLWDU3l5VahRO9KBVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 313/432] locking/rtmutex: Set proper wait context for lockdep
Date:   Thu, 16 Sep 2021 18:01:02 +0200
Message-Id: <20210916155821.429725873@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit b41cda03765580caf7723b8c1b672d191c71013f ]

RT mutexes belong to the LD_WAIT_SLEEP class. Make them so.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210815211302.031014562@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rtmutex.h  | 19 ++++++++++++-------
 kernel/locking/rtmutex.c |  2 +-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index d1672de9ca89..87b325aec508 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -52,17 +52,22 @@ do { \
 } while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define __DEP_MAP_RT_MUTEX_INITIALIZER(mutexname) \
-	, .dep_map = { .name = #mutexname }
+#define __DEP_MAP_RT_MUTEX_INITIALIZER(mutexname)	\
+	.dep_map = {					\
+		.name = #mutexname,			\
+		.wait_type_inner = LD_WAIT_SLEEP,	\
+	}
 #else
 #define __DEP_MAP_RT_MUTEX_INITIALIZER(mutexname)
 #endif
 
-#define __RT_MUTEX_INITIALIZER(mutexname) \
-	{ .wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
-	, .waiters = RB_ROOT_CACHED \
-	, .owner = NULL \
-	__DEP_MAP_RT_MUTEX_INITIALIZER(mutexname)}
+#define __RT_MUTEX_INITIALIZER(mutexname)				\
+{									\
+	.wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock),	\
+	.waiters = RB_ROOT_CACHED,					\
+	.owner = NULL,							\
+	__DEP_MAP_RT_MUTEX_INITIALIZER(mutexname)			\
+}
 
 #define DEFINE_RT_MUTEX(mutexname) \
 	struct rt_mutex mutexname = __RT_MUTEX_INITIALIZER(mutexname)
diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index ad0db322ed3b..1a7e3f838077 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1556,7 +1556,7 @@ void __sched __rt_mutex_init(struct rt_mutex *lock, const char *name,
 		     struct lock_class_key *key)
 {
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
-	lockdep_init_map(&lock->dep_map, name, key, 0);
+	lockdep_init_map_wait(&lock->dep_map, name, key, 0, LD_WAIT_SLEEP);
 
 	__rt_mutex_basic_init(lock);
 }
-- 
2.30.2



