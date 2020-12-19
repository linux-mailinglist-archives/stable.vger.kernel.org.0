Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20EF2DEF93
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgLSNFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:05:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbgLSNEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 08:04:04 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 5.4 32/34] membarrier: Explicitly sync remote cores when SYNC_CORE is requested
Date:   Sat, 19 Dec 2020 14:03:29 +0100
Message-Id: <20201219125342.979283107@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
References: <20201219125341.384025953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit 758c9373d84168dc7d039cf85a0e920046b17b41 upstream.

membarrier() does not explicitly sync_core() remote CPUs; instead, it
relies on the assumption that an IPI will result in a core sync.  On x86,
this may be true in practice, but it's not architecturally reliable.  In
particular, the SDM and APM do not appear to guarantee that interrupt
delivery is serializing.  While IRET does serialize, IPI return can
schedule, thereby switching to another task in the same mm that was
sleeping in a syscall.  The new task could then SYSRET back to usermode
without ever executing IRET.

Make this more robust by explicitly calling sync_core_before_usermode()
on remote cores.  (This also helps people who search the kernel tree for
instances of sync_core() and sync_core_before_usermode() -- one might be
surprised that the core membarrier code doesn't currently show up in a
such a search.)

Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYNC_CORE")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/776b448d5f7bd6b12690707f5ed67bcda7f1d427.1607058304.git.luto@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 kernel/sched/membarrier.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -30,6 +30,23 @@ static void ipi_mb(void *info)
 	smp_mb();	/* IPIs should be serializing but paranoid. */
 }
 
+static void ipi_sync_core(void *info)
+{
+	/*
+	 * The smp_mb() in membarrier after all the IPIs is supposed to
+	 * ensure that memory on remote CPUs that occur before the IPI
+	 * become visible to membarrier()'s caller -- see scenario B in
+	 * the big comment at the top of this file.
+	 *
+	 * A sync_core() would provide this guarantee, but
+	 * sync_core_before_usermode() might end up being deferred until
+	 * after membarrier()'s smp_mb().
+	 */
+	smp_mb();	/* IPIs should be serializing but paranoid. */
+
+	sync_core_before_usermode();
+}
+
 static void ipi_sync_rq_state(void *info)
 {
 	struct mm_struct *mm = (struct mm_struct *) info;
@@ -134,6 +151,7 @@ static int membarrier_private_expedited(
 	int cpu;
 	cpumask_var_t tmpmask;
 	struct mm_struct *mm = current->mm;
+	smp_call_func_t ipi_func = ipi_mb;
 
 	if (flags & MEMBARRIER_FLAG_SYNC_CORE) {
 		if (!IS_ENABLED(CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE))
@@ -141,6 +159,7 @@ static int membarrier_private_expedited(
 		if (!(atomic_read(&mm->membarrier_state) &
 		      MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READY))
 			return -EPERM;
+		ipi_func = ipi_sync_core;
 	} else {
 		if (!(atomic_read(&mm->membarrier_state) &
 		      MEMBARRIER_STATE_PRIVATE_EXPEDITED_READY))
@@ -181,7 +200,7 @@ static int membarrier_private_expedited(
 	rcu_read_unlock();
 
 	preempt_disable();
-	smp_call_function_many(tmpmask, ipi_mb, NULL, 1);
+	smp_call_function_many(tmpmask, ipi_func, NULL, 1);
 	preempt_enable();
 
 	free_cpumask_var(tmpmask);


