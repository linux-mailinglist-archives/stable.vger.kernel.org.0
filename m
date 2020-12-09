Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B892D3DCB
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 09:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgLIInb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 03:43:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44570 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728179AbgLIInb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 03:43:31 -0500
Date:   Wed, 09 Dec 2020 08:42:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607503368;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HfDzJo4wPnHtKfTb9/Z3YlrbW/dNQfM9HGLI8JBTYR0=;
        b=2ym3woZAq+8DEohWg+ll509hkqRGVjquGPPSCSmZESeDNmh8ThU6KSk/hrt4UdGGaZEjHh
        hpe81JyGB85TRts0h5Sh+Waesc30Pg7xsxfhO6FFArQI0MpjgXhvqCqqsA3T7M7cLx6s4T
        27P7ZxBCbd1HiEZfTBas1WWmCgjG4yPbWGbN5zo6or3CYPyH5hVHl5KjCfURYxLW1LRtp4
        vu4zLMHxOPi0/JGY1+H31LfdWzKWGlZOQEA9w1QAGa9783PH/gRHTKFu9n8ok2Mp1rD/Qf
        irZOs5ZC8ZLw+chtadDJn66OqtZ1gZSus7bE4l0A9zf+6KXlWpRChSKD5IcBvw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607503368;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HfDzJo4wPnHtKfTb9/Z3YlrbW/dNQfM9HGLI8JBTYR0=;
        b=baU1B7pVtuPqnKwapwDxdObLMq+NdeCw4PnRU8c9ijdRQFDRRfcsihMuTXKPiSEHkrpbC5
        aoDwBosBxdX458Bw==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/membarrier: Get rid of a dubious optimization
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <5afc7632be1422f91eaf7611aaaa1b5b8580a086.1607058304.git.luto@kernel.org>
References: <5afc7632be1422f91eaf7611aaaa1b5b8580a086.1607058304.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <160750336786.3364.17691454567808013905.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a493d1ca1a03b532871f1da27f8dbda2b28b04c4
Gitweb:        https://git.kernel.org/tip/a493d1ca1a03b532871f1da27f8dbda2b28b04c4
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Thu, 03 Dec 2020 21:07:03 -08:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 09 Dec 2020 09:37:42 +01:00

x86/membarrier: Get rid of a dubious optimization

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

---
 arch/x86/include/asm/sync_core.h |  9 +++++----
 arch/x86/mm/tlb.c                | 10 ++++++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/sync_core.h b/arch/x86/include/asm/sync_core.h
index 0fd4a9d..ab7382f 100644
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
index 11666ba..569ac1d 100644
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
