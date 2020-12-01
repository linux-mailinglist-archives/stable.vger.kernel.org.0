Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C037B2C9D1D
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390588AbgLAJTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:19:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389663AbgLAJKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D44920656;
        Tue,  1 Dec 2020 09:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813803;
        bh=KS5sNnxLHtIs9E9OLCHNsPezCmnd4ggTIjINV5NcBbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RTpwM+XLx4C/M4IdEFK3gB4kQWY1TMWL4K3n19wApmu6GO7HPbo+7F5RnCjonFCch
         mC5TAGrZuGElK4TSKaOlpIbR6XUdqpGI32y87meMpJwU/QW9XZ5ltOZZH1z9AdFol3
         DxvEx9GjXH9SYnJw+JyyH5/GXh8KqVqtBKoq2rFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 064/152] lockdep: Put graph lock/unlock under lock_recursion protection
Date:   Tue,  1 Dec 2020 09:52:59 +0100
Message-Id: <20201201084720.323912400@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



