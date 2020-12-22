Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D20D2D9DD7
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502205AbgLNRgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:36:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502167AbgLNRgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:36:32 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 5.4 33/36] x86/membarrier: Get rid of a dubious optimization
Date:   Mon, 14 Dec 2020 18:28:17 +0100
Message-Id: <20201214172544.932545074@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172543.302523401@linuxfoundation.org>
References: <20201214172543.302523401@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit a493d1ca1a03b532871f1da27f8dbda2b28b04c4 upstream.

sync_core_before_usermode() had an incorrect optimization.  If the kernel
returns from an interrupt, it can get to usermode without IRET. It just has
to schedule to a different task in the same mm and do SYSRET.  Fortunately,
there were no callers of sync_core_before_usermode() that could have had
in_irq() or in_nmi() equal to true, because it's only ever called from the
scheduler.

While at it, clarify a related comment.

Fixes: 70216e18e519 ("membarrier: Provide core serializing command, *_SYNC_CORE")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/5afc7632be1422f91eaf7611aaaa1b5b8580a086.1607058304.git.luto@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/sync_core.h |    9 +++++----
 arch/x86/mm/tlb.c                |   10 ++++++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/sync_core.h
+++ b/arch/x86/include/asm/sync_core.h
@@ -16,12 +16,13 @@ static inline void sync_core_before_user
 	/* With PTI, we unconditionally serialize before running user code. */
 	if (static_cpu_has(X86_FEATURE_PTI))
 		return;
+
 	/*
-	 * Return from interrupt and NMI is done through iret, which is core
-	 * serializing.
+	 * Even if we're in an interrupt, we might reschedule before returning,
+	 * in which case we could switch to a different thread in the same mm
+	 * and return using SYSRET or SYSEXIT.  Instead of trying to keep
+	 * track of our need to sync the core, just sync right away.
 	 */
-	if (in_irq() || in_nmi())
-		return;
 	sync_core();
 }
 
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -327,8 +327,14 @@ void switch_mm_irqs_off(struct mm_struct
 	/*
 	 * The membarrier system call requires a full memory barrier and
 	 * core serialization before returning to user-space, after
-	 * storing to rq->curr. Writing to CR3 provides that full
-	 * memory barrier and core serializing instruction.
+	 * storing to rq->curr, when changing mm.  This is because
+	 * membarrier() sends IPIs to all CPUs that are in the target mm
+	 * to make them issue memory barriers.  However, if another CPU
+	 * switches to/from the target mm concurrently with
+	 * membarrier(), it can cause that CPU not to receive an IPI
+	 * when it really should issue a memory barrier.  Writing to CR3
+	 * provides that full memory barrier and core serializing
+	 * instruction.
 	 */
 	if (real_prev == next) {
 		VM_WARN_ON(this_cpu_read(cpu_tlbstate.ctxs[prev_asid].ctx_id) !=


