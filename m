Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26CC4FD413
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353092AbiDLHdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355235AbiDLH1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:27:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027C648E4E;
        Tue, 12 Apr 2022 00:07:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8688EB81B4F;
        Tue, 12 Apr 2022 07:07:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81CCC385A1;
        Tue, 12 Apr 2022 07:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747239;
        bh=jZ9OyGMlutFC7CgIcngmbcnEnIoe5Nr2Zego+PXvzVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mitMoU6LU7/fDCaIA3nk/LmNwkGwzaQSMUcDHgQ350igX+ZHO06t2HJ/d7qLzruJ9
         A7gPzIfbJFxtsCrh8tD1PM2ZTk84OACtZJpyLuiTEfl51A3hm81DNqO6c9M+W5aO7V
         dZFQeoH/Nic842wnPcl0GMq6B68WC2PmJkl5r0ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>, Nadav Amit <namit@vmware.com>
Subject: [PATCH 5.16 243/285] x86/mm/tlb: Revert retpoline avoidance approach
Date:   Tue, 12 Apr 2022 08:31:40 +0200
Message-Id: <20220412062950.675511361@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

commit d39268ad24c0fd0665d0c5cf55a7c1a0ebf94766 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/tlb.c |   37 +++++--------------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -854,13 +854,11 @@ done:
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
 
@@ -889,36 +887,11 @@ STATIC_NOPV void native_flush_tlb_multi(
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


