Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53874F1B11
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379430AbiDDVTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379767AbiDDSDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 14:03:21 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B3937BCA;
        Mon,  4 Apr 2022 11:01:25 -0700 (PDT)
Date:   Mon, 04 Apr 2022 18:01:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649095283;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wX8w8FV4yP7/hACZ/Dkubahfg7SLkix1Wjx+nmRLJUU=;
        b=LaMADLt/l4qyMI5pC7WKkpqmut6W0mjP5aAozvaZhOgI6Nb/vWEGSLXaX9Ou/ra0VhFFD5
        JcMdWTtMeyf2Lyoky7F4TMn1QugrvFlxiGVBqj5aLwzGW0ucMdHpCnJzEJI5EaLAf/EkN6
        Wao2LLBBsVg5AvvSTZf2hqhVVGJJ7DlIvC6EBq1K61sW09GxnGC7X2dAqOWffGw+jR64WA
        N8Uw3Pl0BgGhaaH3rn54j7vdfztDomPx+mtDVybJrFcU+LgiJn9505PaA3iyySQx4zmPzu
        G46aDWd2gIJSLx6KPfqbYtg/QkB8PUio8NezQznRxfWtSeiKVW1iprtJ/c34pA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649095283;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wX8w8FV4yP7/hACZ/Dkubahfg7SLkix1Wjx+nmRLJUU=;
        b=E+K+bx2uZut2Ke6OKYm5DsmLWzcL8IvtlAaOAcxsvb+LSi85vslkt2jx2Y6XN3OowESBuJ
        vQ6dK5r6QwggCMDQ==
From:   "tip-bot2 for Dave Hansen" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mm/tlb: Revert retpoline avoidance approach
Cc:     kernel test robot <oliver.sang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, Nadav Amit <namit@vmware.com>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <164874672286.389.7021457716635788197.tip-bot2@tip-bot2>
References: <164874672286.389.7021457716635788197.tip-bot2@tip-bot2>
MIME-Version: 1.0
Message-ID: <164909528267.389.5092308187702493426.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     d39268ad24c0fd0665d0c5cf55a7c1a0ebf94766
Gitweb:        https://git.kernel.org/tip/d39268ad24c0fd0665d0c5cf55a7c1a0ebf94766
Author:        Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate:    Fri, 18 Mar 2022 06:52:59 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 04 Apr 2022 19:41:36 +02:00

x86/mm/tlb: Revert retpoline avoidance approach

0day reported a regression on a microbenchmark which is intended to
stress the TLB flushing path:

	https://lore.kernel.org/all/20220317090415.GE735@xsang-OptiPlex-9020/

It pointed at a commit from Nadav which intended to remove retpoline
overhead in the TLB flushing path by taking the 'cond'-ition in
on_each_cpu_cond_mask(), pre-calculating it, and incorporating it into
'cpumask'.  That allowed the code to use a bunch of earlier direct
calls instead of later indirect calls that need a retpoline.

But, in practice, threads can go idle (and into lazy TLB mode where
they don't need to flush their TLB) between the early and late calls.
It works in this direction and not in the other because TLB-flushing
threads tend to hold mmap_lock for write.  Contention on that lock
causes threads to _go_ idle right in this early/late window.

There was not any performance data in the original commit specific
to the retpoline overhead.  I did a few tests on a system with
retpolines:

	https://lore.kernel.org/all/dd8be93c-ded6-b962-50d4-96b1c3afb2b7@intel.com/

which showed a possible small win.  But, that small win pales in
comparison with the bigger loss induced on non-retpoline systems.

Revert the patch that removed the retpolines.  This was not a
clean revert, but it was self-contained enough not to be too painful.

Fixes: 6035152d8eeb ("x86/mm/tlb: Open-code on_each_cpu_cond_mask() for tlb_is_not_lazy()")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Nadav Amit <namit@vmware.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/164874672286.389.7021457716635788197.tip-bot2@tip-bot2
---
 arch/x86/mm/tlb.c | 37 +++++--------------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 6eb4d91..d400b6d 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -855,13 +855,11 @@ done:
 			nr_invalidate);
 }
 
-static bool tlb_is_not_lazy(int cpu)
+static bool tlb_is_not_lazy(int cpu, void *data)
 {
 	return !per_cpu(cpu_tlbstate_shared.is_lazy, cpu);
 }
 
-static DEFINE_PER_CPU(cpumask_t, flush_tlb_mask);
-
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state_shared, cpu_tlbstate_shared);
 EXPORT_PER_CPU_SYMBOL(cpu_tlbstate_shared);
 
@@ -890,36 +888,11 @@ STATIC_NOPV void native_flush_tlb_multi(const struct cpumask *cpumask,
 	 * up on the new contents of what used to be page tables, while
 	 * doing a speculative memory access.
 	 */
-	if (info->freed_tables) {
+	if (info->freed_tables)
 		on_each_cpu_mask(cpumask, flush_tlb_func, (void *)info, true);
-	} else {
-		/*
-		 * Although we could have used on_each_cpu_cond_mask(),
-		 * open-coding it has performance advantages, as it eliminates
-		 * the need for indirect calls or retpolines. In addition, it
-		 * allows to use a designated cpumask for evaluating the
-		 * condition, instead of allocating one.
-		 *
-		 * This code works under the assumption that there are no nested
-		 * TLB flushes, an assumption that is already made in
-		 * flush_tlb_mm_range().
-		 *
-		 * cond_cpumask is logically a stack-local variable, but it is
-		 * more efficient to have it off the stack and not to allocate
-		 * it on demand. Preemption is disabled and this code is
-		 * non-reentrant.
-		 */
-		struct cpumask *cond_cpumask = this_cpu_ptr(&flush_tlb_mask);
-		int cpu;
-
-		cpumask_clear(cond_cpumask);
-
-		for_each_cpu(cpu, cpumask) {
-			if (tlb_is_not_lazy(cpu))
-				__cpumask_set_cpu(cpu, cond_cpumask);
-		}
-		on_each_cpu_mask(cond_cpumask, flush_tlb_func, (void *)info, true);
-	}
+	else
+		on_each_cpu_cond_mask(tlb_is_not_lazy, flush_tlb_func,
+				(void *)info, 1, cpumask);
 }
 
 void flush_tlb_multi(const struct cpumask *cpumask,
