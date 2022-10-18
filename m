Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDD9601E49
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiJRAIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiJRAIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:08:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1321F86889;
        Mon, 17 Oct 2022 17:07:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6ECEBB81BE3;
        Tue, 18 Oct 2022 00:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4168BC433D6;
        Tue, 18 Oct 2022 00:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051675;
        bh=SgkjwT6v/aZrh3kwyQxdb4EprkFZCGb0ZaVoc8w3ZXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLl20I5sHy+uwXgbVuv7GhuflgH5Rp/HW8IvQawfWqUcilowAt5/iAfuxHsglfo78
         h8TxvW5xGA3/IIjiYR/ln9zcQuRm8iFf1hA1tP17QEnyja3Z36qJgaWVtl9OVFllcj
         04jEZjDxpSVc439GCBJ2rgk69AhG8zEb6NSHfXRwGf4grqacZG+H8+uycNssDj+l/3
         yR4WjzEem72PmngKeGgWZlvpf90rAm7f2aV9IJAQKuqpzz3tK9YpvWS9A08IFcN5+P
         bip2DCu+lIsTcIhVT/vWRkslXkuTBLIl9eoHJNbGqc/iNlkTgPWmVDo/lOPs1QOLtV
         +27PNqh2mBRrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        will@kernel.org
Subject: [PATCH AUTOSEL 6.0 11/32] locking/rwsem: Disable preemption while trying for rwsem lock
Date:   Mon, 17 Oct 2022 20:07:08 -0400
Message-Id: <20221018000729.2730519-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>

[ Upstream commit 48dfb5d2560d36fb16c7d430c229d1604ea7d185 ]

Make the region inside the rwsem_write_trylock non preemptible.

We observe RT task is hogging CPU when trying to acquire rwsem lock
which was acquired by a kworker task but before the rwsem owner was set.

Here is the scenario:
1. CFS task (affined to a particular CPU) takes rwsem lock.

2. CFS task gets preempted by a RT task before setting owner.

3. RT task (FIFO) is trying to acquire the lock, but spinning until
RT throttling happens for the lock as the lock was taken by CFS task.

This patch attempts to fix the above issue by disabling preemption
until owner is set for the lock. While at it also fix the issues
at the places where rwsem_{set,clear}_owner() are called.

This also adds lockdep annotation of preemption disable in
rwsem_{set,clear}_owner() on Peter Z. suggestion.

Signed-off-by: Gokul krishna Krishnakumar <quic_gokukris@quicinc.com>
Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/1662661467-24203-1-git-send-email-quic_mojha@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/rwsem.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 65f0262f635e..44873594de03 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -133,14 +133,19 @@
  * the owner value concurrently without lock. Read from owner, however,
  * may not need READ_ONCE() as long as the pointer value is only used
  * for comparison and isn't being dereferenced.
+ *
+ * Both rwsem_{set,clear}_owner() functions should be in the same
+ * preempt disable section as the atomic op that changes sem->count.
  */
 static inline void rwsem_set_owner(struct rw_semaphore *sem)
 {
+	lockdep_assert_preemption_disabled();
 	atomic_long_set(&sem->owner, (long)current);
 }
 
 static inline void rwsem_clear_owner(struct rw_semaphore *sem)
 {
+	lockdep_assert_preemption_disabled();
 	atomic_long_set(&sem->owner, 0);
 }
 
@@ -251,13 +256,16 @@ static inline bool rwsem_read_trylock(struct rw_semaphore *sem, long *cntp)
 static inline bool rwsem_write_trylock(struct rw_semaphore *sem)
 {
 	long tmp = RWSEM_UNLOCKED_VALUE;
+	bool ret = false;
 
+	preempt_disable();
 	if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp, RWSEM_WRITER_LOCKED)) {
 		rwsem_set_owner(sem);
-		return true;
+		ret = true;
 	}
 
-	return false;
+	preempt_enable();
+	return ret;
 }
 
 /*
@@ -1352,8 +1360,10 @@ static inline void __up_write(struct rw_semaphore *sem)
 	DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) &&
 			    !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE), sem);
 
+	preempt_disable();
 	rwsem_clear_owner(sem);
 	tmp = atomic_long_fetch_add_release(-RWSEM_WRITER_LOCKED, &sem->count);
+	preempt_enable();
 	if (unlikely(tmp & RWSEM_FLAG_WAITERS))
 		rwsem_wake(sem);
 }
-- 
2.35.1

