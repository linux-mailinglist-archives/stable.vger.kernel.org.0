Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2C5272F08
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgIUQqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728448AbgIUQp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:45:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5ACCE2223E;
        Mon, 21 Sep 2020 16:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706755;
        bh=awV9qEtlN3RW3XQCr+gKb4y+X76hYG80ePS0CIgFqHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzPBO90htO4b2Yj5STRZbP6LMz1QF9HRTL1/vj8sNNcX6CpXfVgFF/HA+4/Kp3z0o
         bASsH9EbQeNkklGOuhAy+8BPjshkp8uvPiMgse2MFHykOKKk4CaLdFuT14aq95U/nu
         YVFGZJhOHo4tJjZ/pnHlnG8xtzl65lINr44VneR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 081/118] locking/percpu-rwsem: Use this_cpu_{inc,dec}() for read_count
Date:   Mon, 21 Sep 2020 18:28:13 +0200
Message-Id: <20200921162040.097611100@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit e6b1a44eccfcab5e5e280be376f65478c3b2c7a2 ]

The __this_cpu*() accessors are (in general) IRQ-unsafe which, given
that percpu-rwsem is a blocking primitive, should be just fine.

However, file_end_write() is used from IRQ context and will cause
load-store issues on architectures where the per-cpu accessors are not
natively irq-safe.

Fix it by using the IRQ-safe this_cpu_*() for operations on
read_count. This will generate more expensive code on a number of
platforms, which might cause a performance regression for some of the
other percpu-rwsem users.

If any such is reported, we can consider alternative solutions.

Fixes: 70fe2f48152e ("aio: fix freeze protection of aio writes")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lkml.kernel.org/r/20200915140750.137881-1-houtao1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/percpu-rwsem.h  | 8 ++++----
 kernel/locking/percpu-rwsem.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index 5e033fe1ff4e9..5fda40f97fe91 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -60,7 +60,7 @@ static inline void percpu_down_read(struct percpu_rw_semaphore *sem)
 	 * anything we did within this RCU-sched read-size critical section.
 	 */
 	if (likely(rcu_sync_is_idle(&sem->rss)))
-		__this_cpu_inc(*sem->read_count);
+		this_cpu_inc(*sem->read_count);
 	else
 		__percpu_down_read(sem, false); /* Unconditional memory barrier */
 	/*
@@ -79,7 +79,7 @@ static inline bool percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
 	 * Same as in percpu_down_read().
 	 */
 	if (likely(rcu_sync_is_idle(&sem->rss)))
-		__this_cpu_inc(*sem->read_count);
+		this_cpu_inc(*sem->read_count);
 	else
 		ret = __percpu_down_read(sem, true); /* Unconditional memory barrier */
 	preempt_enable();
@@ -103,7 +103,7 @@ static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
 	 * Same as in percpu_down_read().
 	 */
 	if (likely(rcu_sync_is_idle(&sem->rss))) {
-		__this_cpu_dec(*sem->read_count);
+		this_cpu_dec(*sem->read_count);
 	} else {
 		/*
 		 * slowpath; reader will only ever wake a single blocked
@@ -115,7 +115,7 @@ static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
 		 * aggregate zero, as that is the only time it matters) they
 		 * will also see our critical section.
 		 */
-		__this_cpu_dec(*sem->read_count);
+		this_cpu_dec(*sem->read_count);
 		rcuwait_wake_up(&sem->writer);
 	}
 	preempt_enable();
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index 8bbafe3e5203d..70a32a576f3f2 100644
--- a/kernel/locking/percpu-rwsem.c
+++ b/kernel/locking/percpu-rwsem.c
@@ -45,7 +45,7 @@ EXPORT_SYMBOL_GPL(percpu_free_rwsem);
 
 static bool __percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
 {
-	__this_cpu_inc(*sem->read_count);
+	this_cpu_inc(*sem->read_count);
 
 	/*
 	 * Due to having preemption disabled the decrement happens on
@@ -71,7 +71,7 @@ static bool __percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
 	if (likely(!atomic_read_acquire(&sem->block)))
 		return true;
 
-	__this_cpu_dec(*sem->read_count);
+	this_cpu_dec(*sem->read_count);
 
 	/* Prod writer to re-evaluate readers_active_check() */
 	rcuwait_wake_up(&sem->writer);
-- 
2.25.1



