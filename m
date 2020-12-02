Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30652CC0F8
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 16:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgLBPf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 10:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbgLBPf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 10:35:58 -0500
From:   Andy Lutomirski <luto@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     x86@kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/4] x86/membarrier: Get rid of a dubious optimization
Date:   Wed,  2 Dec 2020 07:35:09 -0800
Message-Id: <5afc7632be1422f91eaf7611aaaa1b5b8580a086.1606923183.git.luto@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1606923183.git.luto@kernel.org>
References: <cover.1606923183.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

sync_core_before_usermode() had an incorrect optimization.  If we're
in an IRQ, we can get to usermode without IRET -- we just have to
schedule to a different task in the same mm and do SYSRET.
Fortunately, there were no callers of sync_core_before_usermode()
that could have had in_irq() or in_nmi() equal to true, because it's
only ever called from the scheduler.

While we're at it, clarify a related comment.

Cc: stable@vger.kernel.org
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/include/asm/sync_core.h |  9 +++++----
 arch/x86/mm/tlb.c                | 10 ++++++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/sync_core.h b/arch/x86/include/asm/sync_core.h
index 0fd4a9dfb29c..ab7382f92aff 100644
--- a/arch/x86/include/asm/sync_core.h
+++ b/arch/x86/include/asm/sync_core.h
@@ -98,12 +98,13 @@ static inline void sync_core_before_usermode(void)
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
 
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 11666ba19b62..569ac1d57f55 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -474,8 +474,14 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
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
-- 
2.28.0

