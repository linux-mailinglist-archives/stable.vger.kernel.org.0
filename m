Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9A37F14D
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbfHBJfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391644AbfHBJfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:35:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A70A217D4;
        Fri,  2 Aug 2019 09:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738522;
        bh=2iokwITC+I3NWDqkdf26jEzIjBLZs6me/Tt0hsy0/rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxAbdBHNjkXOgMaJQVE8WlRcLB0R3L9bZYvVhdOUcpdCbZjiJj6drcewysAVytiTR
         N6Ubd9x812gIuF8fgZglxOg2kKRI12RVrZepxTy2nNd2b54qpyCb5OBq1wHAoJ6KjN
         E6bfWXzw5oRaxtCVq/wWwXyW5K3fDg76+b7UCkO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Yuyang Du <duyuyang@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, arnd@arndb.de,
        frederic@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 137/158] locking/lockdep: Fix lock used or unused stats error
Date:   Fri,  2 Aug 2019 11:29:18 +0200
Message-Id: <20190802092230.893830860@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index dbb61a302548..9778b6701019 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -227,6 +227,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 		      nr_hardirq_read_safe = 0, nr_hardirq_read_unsafe = 0,
 		      sum_forward_deps = 0;
 
+#ifdef CONFIG_PROVE_LOCKING
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
 
 		if (class->usage_mask == 0)
@@ -258,12 +259,12 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
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



