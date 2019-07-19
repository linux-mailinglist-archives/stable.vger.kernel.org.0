Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC376DCF0
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbfGSETg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387437AbfGSENE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:13:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E4E221872;
        Fri, 19 Jul 2019 04:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509583;
        bh=4AGb6ozVNBFfK1SAoNSN96dxVzwAbBj6l8/GHaCHGf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MA2nCZx2itQChrgjBw2F1Yqq+nLWWr6c9nqEEzs2NXF6ze+t1VM4tvCLbUvo+/+8
         Sgqv/iztooe33c7fe9ONWRoEpPii4qXRx9S8/aen7W851gan1qQLuXzJnijcLR7xHO
         kiv/c/PzBiZlNcLjunlrvXkMxcsuRHs0g/vqsMYw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yuyang Du <duyuyang@gmail.com>, Qian Cai <cai@lca.pw>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, arnd@arndb.de,
        frederic@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 60/60] locking/lockdep: Fix lock used or unused stats error
Date:   Fri, 19 Jul 2019 00:11:09 -0400
Message-Id: <20190719041109.18262-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuyang Du <duyuyang@gmail.com>

[ Upstream commit 68d41d8c94a31dfb8233ab90b9baf41a2ed2da68 ]

The stats variable nr_unused_locks is incremented every time a new lock
class is register and decremented when the lock is first used in
__lock_acquire(). And after all, it is shown and checked in lockdep_stats.

However, under configurations that either CONFIG_TRACE_IRQFLAGS or
CONFIG_PROVE_LOCKING is not defined:

The commit:

  091806515124b20 ("locking/lockdep: Consolidate lock usage bit initialization")

missed marking the LOCK_USED flag at IRQ usage initialization because
as mark_usage() is not called. And the commit:

  886532aee3cd42d ("locking/lockdep: Move mark_lock() inside CONFIG_TRACE_IRQFLAGS && CONFIG_PROVE_LOCKING")

further made mark_lock() not defined such that the LOCK_USED cannot be
marked at all when the lock is first acquired.

As a result, we fix this by not showing and checking the stats under such
configurations for lockdep_stats.

Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Yuyang Du <duyuyang@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: arnd@arndb.de
Cc: frederic@kernel.org
Link: https://lkml.kernel.org/r/20190709101522.9117-1-duyuyang@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep_proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index ad69bbc9bd28..71631bef0e84 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -234,6 +234,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 		      nr_hardirq_read_safe = 0, nr_hardirq_read_unsafe = 0,
 		      sum_forward_deps = 0;
 
+#ifdef CONFIG_PROVE_LOCKING
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
 
 		if (class->usage_mask == 0)
@@ -265,12 +266,12 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 		if (class->usage_mask & LOCKF_ENABLED_HARDIRQ_READ)
 			nr_hardirq_read_unsafe++;
 
-#ifdef CONFIG_PROVE_LOCKING
 		sum_forward_deps += lockdep_count_forward_deps(class);
-#endif
 	}
 #ifdef CONFIG_DEBUG_LOCKDEP
 	DEBUG_LOCKS_WARN_ON(debug_atomic_read(nr_unused_locks) != nr_unused);
+#endif
+
 #endif
 	seq_printf(m, " lock-classes:                  %11lu [max: %lu]\n",
 			nr_lock_classes, MAX_LOCKDEP_KEYS);
-- 
2.20.1

