Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CE1404C2B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236201AbhIIL4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243659AbhIILyV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:54:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2024361209;
        Thu,  9 Sep 2021 11:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187884;
        bh=CV74dxIjhbf32IWeE/xsVObqeVRJv4nlTAX7l/Jk+zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwfE2WfQhkad/Iq80VqL3vE/yQA3ueA853twQl7Rk0ro1QNd6nT02DB3UwjfakxcQ
         uN0ma7JjiALGroIu22hN4Tf61YG4K+ykCjt9xOYhU92K63kFWexTiDeOn4Hs+LDPDt
         m9n1X3neU6ErO3RpXrWObgC5o0nGyrZ+bpLc6A+/MejCOGf1xji10b/R9UefDwiDJ2
         2xguN/OrB95nSDLidp+0kKbj7W20fM9hcndafNrziFgWmRW1QLEvX7bVnZNFWYhOo5
         K/+pSa0DZqsONrKzPavalWOtNkAPl7vCp8gRTnr2s3WffaPnSP2ezRI13z5bTs+Wyy
         +Vg+L2P0OW+rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.14 167/252] locking/rtmutex: Set proper wait context for lockdep
Date:   Thu,  9 Sep 2021 07:39:41 -0400
Message-Id: <20210909114106.141462-167-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

