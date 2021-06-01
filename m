Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325A138EF86
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhEXP6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234928AbhEXP5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:57:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B32946194B;
        Mon, 24 May 2021 15:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871003;
        bh=i/k9sDwLtgjF9ZDK+tYLppWwTyek+Su3iUDSGJxFHZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XTdAGxFwIA37guCommL8uwRArQnvieDCBIyfn+F0tUQFUMEPJlf846H0EoRSEHsLc
         b3dm71gMrAQ+kmQqQAw8rogINl/o6PVv9d3bb93u7oJ8SC17dQfp0vOsZ8dux6LRxV
         3bFdm67f59LO59x3/Lvz3pT2DSxKkwDG6uZH8Ycw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 028/127] powerpc/pseries: Fix hcall tracing recursion in pv queued spinlocks
Date:   Mon, 24 May 2021 17:25:45 +0200
Message-Id: <20210524152335.793850680@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 2c8c89b95831f46a2fb31a8d0fef4601694023ce ]

The paravit queued spinlock slow path adds itself to the queue then
calls pv_wait to wait for the lock to become free. This is implemented
by calling H_CONFER to donate cycles.

When hcall tracing is enabled, this H_CONFER call can lead to a spin
lock being taken in the tracing code, which will result in the lock to
be taken again, which will also go to the slow path because it queues
behind itself and so won't ever make progress.

An example trace of a deadlock:

  __pv_queued_spin_lock_slowpath
  trace_clock_global
  ring_buffer_lock_reserve
  trace_event_buffer_lock_reserve
  trace_event_buffer_reserve
  trace_event_raw_event_hcall_exit
  __trace_hcall_exit
  plpar_hcall_norets_trace
  __pv_queued_spin_lock_slowpath
  trace_clock_global
  ring_buffer_lock_reserve
  trace_event_buffer_lock_reserve
  trace_event_buffer_reserve
  trace_event_raw_event_rcu_dyntick
  rcu_irq_exit
  irq_exit
  __do_irq
  call_do_irq
  do_IRQ
  hardware_interrupt_common_virt

Fix this by introducing plpar_hcall_norets_notrace(), and using that to
make SPLPAR virtual processor dispatching hcalls by the paravirt
spinlock code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210508101455.1578318-2-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/hvcall.h       |  3 +++
 arch/powerpc/include/asm/paravirt.h     | 22 +++++++++++++++++++---
 arch/powerpc/platforms/pseries/hvCall.S | 10 ++++++++++
 arch/powerpc/platforms/pseries/lpar.c   |  3 +--
 4 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
index ed6086d57b22..0c92b01a3c3c 100644
--- a/arch/powerpc/include/asm/hvcall.h
+++ b/arch/powerpc/include/asm/hvcall.h
@@ -446,6 +446,9 @@
  */
 long plpar_hcall_norets(unsigned long opcode, ...);
 
+/* Variant which does not do hcall tracing */
+long plpar_hcall_norets_notrace(unsigned long opcode, ...);
+
 /**
  * plpar_hcall: - Make a pseries hypervisor call
  * @opcode: The hypervisor call to make.
diff --git a/arch/powerpc/include/asm/paravirt.h b/arch/powerpc/include/asm/paravirt.h
index 5d1726bb28e7..bcb7b5f917be 100644
--- a/arch/powerpc/include/asm/paravirt.h
+++ b/arch/powerpc/include/asm/paravirt.h
@@ -28,19 +28,35 @@ static inline u32 yield_count_of(int cpu)
 	return be32_to_cpu(yield_count);
 }
 
+/*
+ * Spinlock code confers and prods, so don't trace the hcalls because the
+ * tracing code takes spinlocks which can cause recursion deadlocks.
+ *
+ * These calls are made while the lock is not held: the lock slowpath yields if
+ * it can not acquire the lock, and unlock slow path might prod if a waiter has
+ * yielded). So this may not be a problem for simple spin locks because the
+ * tracing does not technically recurse on the lock, but we avoid it anyway.
+ *
+ * However the queued spin lock contended path is more strictly ordered: the
+ * H_CONFER hcall is made after the task has queued itself on the lock, so then
+ * recursing on that lock will cause the task to then queue up again behind the
+ * first instance (or worse: queued spinlocks use tricks that assume a context
+ * never waits on more than one spinlock, so such recursion may cause random
+ * corruption in the lock code).
+ */
 static inline void yield_to_preempted(int cpu, u32 yield_count)
 {
-	plpar_hcall_norets(H_CONFER, get_hard_smp_processor_id(cpu), yield_count);
+	plpar_hcall_norets_notrace(H_CONFER, get_hard_smp_processor_id(cpu), yield_count);
 }
 
 static inline void prod_cpu(int cpu)
 {
-	plpar_hcall_norets(H_PROD, get_hard_smp_processor_id(cpu));
+	plpar_hcall_norets_notrace(H_PROD, get_hard_smp_processor_id(cpu));
 }
 
 static inline void yield_to_any(void)
 {
-	plpar_hcall_norets(H_CONFER, -1, 0);
+	plpar_hcall_norets_notrace(H_CONFER, -1, 0);
 }
 #else
 static inline bool is_shared_processor(void)
diff --git a/arch/powerpc/platforms/pseries/hvCall.S b/arch/powerpc/platforms/pseries/hvCall.S
index 2136e42833af..8a2b8d64265b 100644
--- a/arch/powerpc/platforms/pseries/hvCall.S
+++ b/arch/powerpc/platforms/pseries/hvCall.S
@@ -102,6 +102,16 @@ END_FTR_SECTION(0, 1);						\
 #define HCALL_BRANCH(LABEL)
 #endif
 
+_GLOBAL_TOC(plpar_hcall_norets_notrace)
+	HMT_MEDIUM
+
+	mfcr	r0
+	stw	r0,8(r1)
+	HVSC				/* invoke the hypervisor */
+	lwz	r0,8(r1)
+	mtcrf	0xff,r0
+	blr				/* return r3 = status */
+
 _GLOBAL_TOC(plpar_hcall_norets)
 	HMT_MEDIUM
 
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index cd38bd421f38..d4aa6a46e1fa 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -1830,8 +1830,7 @@ void hcall_tracepoint_unregfunc(void)
 
 /*
  * Since the tracing code might execute hcalls we need to guard against
- * recursion. One example of this are spinlocks calling H_YIELD on
- * shared processor partitions.
+ * recursion.
  */
 static DEFINE_PER_CPU(unsigned int, hcall_trace_depth);
 
-- 
2.30.2



