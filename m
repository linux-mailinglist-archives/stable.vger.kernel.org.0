Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7426A2C43BC
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgKYPgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:36:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730639AbgKYPgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16B7421D1A;
        Wed, 25 Nov 2020 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318589;
        bh=KS5sNnxLHtIs9E9OLCHNsPezCmnd4ggTIjINV5NcBbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msLtS9d+M3c+WFEp7t045+jPnhCJgJzg6TKrp2O4olXBJDOfbKCKLMeghz7fVlOvP
         xssCm9kRS7eiW4nLLcfU00wzu7bmbDtjSwHq1O5Km9iI8TxGN/hOEZeTZnZOYXurPR
         zRFu93Q9vvzIuRVqy0tlWEjQKfNI9vw7MwawrwIA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 28/33] lockdep: Put graph lock/unlock under lock_recursion protection
Date:   Wed, 25 Nov 2020 10:35:45 -0500
Message-Id: <20201125153550.810101-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit 43be4388e94b915799a24f0eaf664bf95b85231f ]

A warning was hit when running xfstests/generic/068 in a Hyper-V guest:

[...] ------------[ cut here ]------------
[...] DEBUG_LOCKS_WARN_ON(lockdep_hardirqs_enabled())
[...] WARNING: CPU: 2 PID: 1350 at kernel/locking/lockdep.c:5280 check_flags.part.0+0x165/0x170
[...] ...
[...] Workqueue: events pwq_unbound_release_workfn
[...] RIP: 0010:check_flags.part.0+0x165/0x170
[...] ...
[...] Call Trace:
[...]  lock_is_held_type+0x72/0x150
[...]  ? lock_acquire+0x16e/0x4a0
[...]  rcu_read_lock_sched_held+0x3f/0x80
[...]  __send_ipi_one+0x14d/0x1b0
[...]  hv_send_ipi+0x12/0x30
[...]  __pv_queued_spin_unlock_slowpath+0xd1/0x110
[...]  __raw_callee_save___pv_queued_spin_unlock_slowpath+0x11/0x20
[...]  .slowpath+0x9/0xe
[...]  lockdep_unregister_key+0x128/0x180
[...]  pwq_unbound_release_workfn+0xbb/0xf0
[...]  process_one_work+0x227/0x5c0
[...]  worker_thread+0x55/0x3c0
[...]  ? process_one_work+0x5c0/0x5c0
[...]  kthread+0x153/0x170
[...]  ? __kthread_bind_mask+0x60/0x60
[...]  ret_from_fork+0x1f/0x30

The cause of the problem is we have call chain lockdep_unregister_key()
-> <irq disabled by raw_local_irq_save()> lockdep_unlock() ->
arch_spin_unlock() -> __pv_queued_spin_unlock_slowpath() -> pv_kick() ->
__send_ipi_one() -> trace_hyperv_send_ipi_one().

Although this particular warning is triggered because Hyper-V has a
trace point in ipi sending, but in general arch_spin_unlock() may call
another function having a trace point in it, so put the arch_spin_lock()
and arch_spin_unlock() after lock_recursion protection to fix this
problem and avoid similiar problems.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201113110512.1056501-1-boqun.feng@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 3eb35ad1b5241..04134a242f3d5 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -108,19 +108,21 @@ static inline void lockdep_lock(void)
 {
 	DEBUG_LOCKS_WARN_ON(!irqs_disabled());
 
+	__this_cpu_inc(lockdep_recursion);
 	arch_spin_lock(&__lock);
 	__owner = current;
-	__this_cpu_inc(lockdep_recursion);
 }
 
 static inline void lockdep_unlock(void)
 {
+	DEBUG_LOCKS_WARN_ON(!irqs_disabled());
+
 	if (debug_locks && DEBUG_LOCKS_WARN_ON(__owner != current))
 		return;
 
-	__this_cpu_dec(lockdep_recursion);
 	__owner = NULL;
 	arch_spin_unlock(&__lock);
+	__this_cpu_dec(lockdep_recursion);
 }
 
 static inline bool lockdep_assert_locked(void)
-- 
2.27.0

