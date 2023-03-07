Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3236AEDDC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjCGSH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbjCGSHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:07:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51C599BCD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:01:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A16ECB819BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81CEC433EF;
        Tue,  7 Mar 2023 18:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212067;
        bh=9h6R7RBQpKzyBaLqKeRHPV03rq46PwuKgXF7ADSdT2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f66L+PWFmqU/7Syn+VOeReV/rVTiJ6D3M9fJUR0iKncWVEAaHsGWYrfWZJOTP+7bl
         gocq5hNXCqgVJGha5IW1a49WbVbzKQZThv2LE60UMFIb3CAESbUbW/vxD4mSv3mGja
         uD0ONVkbs4dZpzMui0emsnyrxOD8m/jiouNxLIn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mukesh Ojha <quic_mojha@quicinc.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 066/885] locking/rwsem: Disable preemption in all down_read*() and up_read() code paths
Date:   Tue,  7 Mar 2023 17:50:00 +0100
Message-Id: <20230307170004.644474928@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 3f5245538a1964ae186ab7e1636020a41aa63143 ]

Commit:

  91d2a812dfb9 ("locking/rwsem: Make handoff writer optimistically spin on owner")

... assumes that when the owner field is changed to NULL, the lock will
become free soon. But commit:

  48dfb5d2560d ("locking/rwsem: Disable preemption while trying for rwsem lock")

... disabled preemption when acquiring rwsem for write.

However, preemption has not yet been disabled when acquiring a read lock
on a rwsem.  So a reader can add a RWSEM_READER_BIAS to count without
setting owner to signal a reader, got preempted out by a RT task which
then spins in the writer slowpath as owner remains NULL leading to live lock.

One easy way to fix this problem is to disable preemption at all the
down_read*() and up_read() code paths as implemented in this patch.

Fixes: 91d2a812dfb9 ("locking/rwsem: Make handoff writer optimistically spin on owner")
Reported-by: Mukesh Ojha <quic_mojha@quicinc.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230126003628.365092-3-longman@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/rwsem.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 44873594de031..324fc370b6a68 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1092,7 +1092,7 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, unsigned int stat
 			/* Ordered by sem->wait_lock against rwsem_mark_wake(). */
 			break;
 		}
-		schedule();
+		schedule_preempt_disabled();
 		lockevent_inc(rwsem_sleep_reader);
 	}
 
@@ -1254,14 +1254,20 @@ static struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
  */
 static inline int __down_read_common(struct rw_semaphore *sem, int state)
 {
+	int ret = 0;
 	long count;
 
+	preempt_disable();
 	if (!rwsem_read_trylock(sem, &count)) {
-		if (IS_ERR(rwsem_down_read_slowpath(sem, count, state)))
-			return -EINTR;
+		if (IS_ERR(rwsem_down_read_slowpath(sem, count, state))) {
+			ret = -EINTR;
+			goto out;
+		}
 		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
 	}
-	return 0;
+out:
+	preempt_enable();
+	return ret;
 }
 
 static inline void __down_read(struct rw_semaphore *sem)
@@ -1281,19 +1287,23 @@ static inline int __down_read_killable(struct rw_semaphore *sem)
 
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
+	int ret = 0;
 	long tmp;
 
 	DEBUG_RWSEMS_WARN_ON(sem->magic != sem, sem);
 
+	preempt_disable();
 	tmp = atomic_long_read(&sem->count);
 	while (!(tmp & RWSEM_READ_FAILED_MASK)) {
 		if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp,
 						    tmp + RWSEM_READER_BIAS)) {
 			rwsem_set_reader_owned(sem);
-			return 1;
+			ret = 1;
+			break;
 		}
 	}
-	return 0;
+	preempt_enable();
+	return ret;
 }
 
 /*
@@ -1335,6 +1345,7 @@ static inline void __up_read(struct rw_semaphore *sem)
 	DEBUG_RWSEMS_WARN_ON(sem->magic != sem, sem);
 	DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
 
+	preempt_disable();
 	rwsem_clear_reader_owned(sem);
 	tmp = atomic_long_add_return_release(-RWSEM_READER_BIAS, &sem->count);
 	DEBUG_RWSEMS_WARN_ON(tmp < 0, sem);
@@ -1343,6 +1354,7 @@ static inline void __up_read(struct rw_semaphore *sem)
 		clear_nonspinnable(sem);
 		rwsem_wake(sem);
 	}
+	preempt_enable();
 }
 
 /*
@@ -1662,6 +1674,12 @@ void down_read_non_owner(struct rw_semaphore *sem)
 {
 	might_sleep();
 	__down_read(sem);
+	/*
+	 * The owner value for a reader-owned lock is mostly for debugging
+	 * purpose only and is not critical to the correct functioning of
+	 * rwsem. So it is perfectly fine to set it in a preempt-enabled
+	 * context here.
+	 */
 	__rwsem_set_reader_owned(sem, NULL);
 }
 EXPORT_SYMBOL(down_read_non_owner);
-- 
2.39.2



