Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259BE5F991B
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiJJHH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbiJJHHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:07:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059D258DC8;
        Mon, 10 Oct 2022 00:05:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8C2A60E84;
        Mon, 10 Oct 2022 07:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEC6C433D7;
        Mon, 10 Oct 2022 07:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385522;
        bh=PSMXGnsG+3jG0WxZXNAHq0UZqhqCZ0vRVwIh4w1G0Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvHqmLkOdxlNXnbrO6R/7/DuBt7ufDgPy3l0/JHGuMjSOlXHXdyeuSpzmj4a7AyH7
         w8n670ZNwDm3NmIeZmctQZvWOpFdQjbtLYoGl/XLd7bO1nyONYTO2BDWf16U1NL7Bj
         vXuQ8lU+ZOJkaqLrP7JoABY3Z6L6qL2BRDC0A9UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Andreas Larsson <andreas@gaisler.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.19 01/48] sparc: Unbreak the build
Date:   Mon, 10 Oct 2022 09:04:59 +0200
Message-Id: <20221010070333.719441469@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 17006e86a7641fa3c50324cfb602f0e74dac8527 upstream.

Fix the following build errors:

arch/sparc/mm/srmmu.c: In function ‘smp_flush_page_for_dma’:
arch/sparc/mm/srmmu.c:1639:13: error: cast between incompatible function types from ‘void (*)(long unsigned int)’ to ‘void (*)(long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int)’ [-Werror=cast-function-type]
 1639 |         xc1((smpfunc_t) local_ops->page_for_dma, page);
      |             ^
arch/sparc/mm/srmmu.c: In function ‘smp_flush_cache_mm’:
arch/sparc/mm/srmmu.c:1662:29: error: cast between incompatible function types from ‘void (*)(struct mm_struct *)’ to ‘void (*)(long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int,  long unsigned int)’ [-Werror=cast-function-type]
 1662 |                         xc1((smpfunc_t) local_ops->cache_mm, (unsigned long) mm);
      |
[ ... ]

Compile-tested only.

Fixes: 552a23a0e5d0 ("Makefile: Enable -Wcast-function-type")
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220830205854.1918026-1-bvanassche@acm.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/smp_32.h |   15 ++++++---------
 arch/sparc/kernel/leon_smp.c    |   12 +++++++-----
 arch/sparc/kernel/sun4d_smp.c   |   12 +++++++-----
 arch/sparc/kernel/sun4m_smp.c   |   10 ++++++----
 arch/sparc/mm/srmmu.c           |   29 +++++++++++++----------------
 5 files changed, 39 insertions(+), 39 deletions(-)

--- a/arch/sparc/include/asm/smp_32.h
+++ b/arch/sparc/include/asm/smp_32.h
@@ -33,9 +33,6 @@ extern volatile unsigned long cpu_callin
 extern cpumask_t smp_commenced_mask;
 extern struct linux_prom_registers smp_penguin_ctable;
 
-typedef void (*smpfunc_t)(unsigned long, unsigned long, unsigned long,
-		       unsigned long, unsigned long);
-
 void cpu_panic(void);
 
 /*
@@ -57,7 +54,7 @@ void smp_bogo(struct seq_file *);
 void smp_info(struct seq_file *);
 
 struct sparc32_ipi_ops {
-	void (*cross_call)(smpfunc_t func, cpumask_t mask, unsigned long arg1,
+	void (*cross_call)(void *func, cpumask_t mask, unsigned long arg1,
 			   unsigned long arg2, unsigned long arg3,
 			   unsigned long arg4);
 	void (*resched)(int cpu);
@@ -66,28 +63,28 @@ struct sparc32_ipi_ops {
 };
 extern const struct sparc32_ipi_ops *sparc32_ipi_ops;
 
-static inline void xc0(smpfunc_t func)
+static inline void xc0(void *func)
 {
 	sparc32_ipi_ops->cross_call(func, *cpu_online_mask, 0, 0, 0, 0);
 }
 
-static inline void xc1(smpfunc_t func, unsigned long arg1)
+static inline void xc1(void *func, unsigned long arg1)
 {
 	sparc32_ipi_ops->cross_call(func, *cpu_online_mask, arg1, 0, 0, 0);
 }
-static inline void xc2(smpfunc_t func, unsigned long arg1, unsigned long arg2)
+static inline void xc2(void *func, unsigned long arg1, unsigned long arg2)
 {
 	sparc32_ipi_ops->cross_call(func, *cpu_online_mask, arg1, arg2, 0, 0);
 }
 
-static inline void xc3(smpfunc_t func, unsigned long arg1, unsigned long arg2,
+static inline void xc3(void *func, unsigned long arg1, unsigned long arg2,
 		       unsigned long arg3)
 {
 	sparc32_ipi_ops->cross_call(func, *cpu_online_mask,
 				    arg1, arg2, arg3, 0);
 }
 
-static inline void xc4(smpfunc_t func, unsigned long arg1, unsigned long arg2,
+static inline void xc4(void *func, unsigned long arg1, unsigned long arg2,
 		       unsigned long arg3, unsigned long arg4)
 {
 	sparc32_ipi_ops->cross_call(func, *cpu_online_mask,
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -359,7 +359,7 @@ void leonsmp_ipi_interrupt(void)
 }
 
 static struct smp_funcall {
-	smpfunc_t func;
+	void *func;
 	unsigned long arg1;
 	unsigned long arg2;
 	unsigned long arg3;
@@ -372,7 +372,7 @@ static struct smp_funcall {
 static DEFINE_SPINLOCK(cross_call_lock);
 
 /* Cross calls must be serialized, at least currently. */
-static void leon_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
+static void leon_cross_call(void *func, cpumask_t mask, unsigned long arg1,
 			    unsigned long arg2, unsigned long arg3,
 			    unsigned long arg4)
 {
@@ -384,7 +384,7 @@ static void leon_cross_call(smpfunc_t fu
 
 		{
 			/* If you make changes here, make sure gcc generates proper code... */
-			register smpfunc_t f asm("i0") = func;
+			register void *f asm("i0") = func;
 			register unsigned long a1 asm("i1") = arg1;
 			register unsigned long a2 asm("i2") = arg2;
 			register unsigned long a3 asm("i3") = arg3;
@@ -444,11 +444,13 @@ static void leon_cross_call(smpfunc_t fu
 /* Running cross calls. */
 void leon_cross_call_irq(void)
 {
+	void (*func)(unsigned long, unsigned long, unsigned long, unsigned long,
+		     unsigned long) = ccall_info.func;
 	int i = smp_processor_id();
 
 	ccall_info.processors_in[i] = 1;
-	ccall_info.func(ccall_info.arg1, ccall_info.arg2, ccall_info.arg3,
-			ccall_info.arg4, ccall_info.arg5);
+	func(ccall_info.arg1, ccall_info.arg2, ccall_info.arg3, ccall_info.arg4,
+	     ccall_info.arg5);
 	ccall_info.processors_out[i] = 1;
 }
 
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -268,7 +268,7 @@ static void sun4d_ipi_resched(int cpu)
 }
 
 static struct smp_funcall {
-	smpfunc_t func;
+	void *func;
 	unsigned long arg1;
 	unsigned long arg2;
 	unsigned long arg3;
@@ -281,7 +281,7 @@ static struct smp_funcall {
 static DEFINE_SPINLOCK(cross_call_lock);
 
 /* Cross calls must be serialized, at least currently. */
-static void sun4d_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
+static void sun4d_cross_call(void *func, cpumask_t mask, unsigned long arg1,
 			     unsigned long arg2, unsigned long arg3,
 			     unsigned long arg4)
 {
@@ -296,7 +296,7 @@ static void sun4d_cross_call(smpfunc_t f
 			 * If you make changes here, make sure
 			 * gcc generates proper code...
 			 */
-			register smpfunc_t f asm("i0") = func;
+			register void *f asm("i0") = func;
 			register unsigned long a1 asm("i1") = arg1;
 			register unsigned long a2 asm("i2") = arg2;
 			register unsigned long a3 asm("i3") = arg3;
@@ -353,11 +353,13 @@ static void sun4d_cross_call(smpfunc_t f
 /* Running cross calls. */
 void smp4d_cross_call_irq(void)
 {
+	void (*func)(unsigned long, unsigned long, unsigned long, unsigned long,
+		     unsigned long) = ccall_info.func;
 	int i = hard_smp_processor_id();
 
 	ccall_info.processors_in[i] = 1;
-	ccall_info.func(ccall_info.arg1, ccall_info.arg2, ccall_info.arg3,
-			ccall_info.arg4, ccall_info.arg5);
+	func(ccall_info.arg1, ccall_info.arg2, ccall_info.arg3, ccall_info.arg4,
+	     ccall_info.arg5);
 	ccall_info.processors_out[i] = 1;
 }
 
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -157,7 +157,7 @@ static void sun4m_ipi_mask_one(int cpu)
 }
 
 static struct smp_funcall {
-	smpfunc_t func;
+	void *func;
 	unsigned long arg1;
 	unsigned long arg2;
 	unsigned long arg3;
@@ -170,7 +170,7 @@ static struct smp_funcall {
 static DEFINE_SPINLOCK(cross_call_lock);
 
 /* Cross calls must be serialized, at least currently. */
-static void sun4m_cross_call(smpfunc_t func, cpumask_t mask, unsigned long arg1,
+static void sun4m_cross_call(void *func, cpumask_t mask, unsigned long arg1,
 			     unsigned long arg2, unsigned long arg3,
 			     unsigned long arg4)
 {
@@ -230,11 +230,13 @@ static void sun4m_cross_call(smpfunc_t f
 /* Running cross calls. */
 void smp4m_cross_call_irq(void)
 {
+	void (*func)(unsigned long, unsigned long, unsigned long, unsigned long,
+		     unsigned long) = ccall_info.func;
 	int i = smp_processor_id();
 
 	ccall_info.processors_in[i] = 1;
-	ccall_info.func(ccall_info.arg1, ccall_info.arg2, ccall_info.arg3,
-			ccall_info.arg4, ccall_info.arg5);
+	func(ccall_info.arg1, ccall_info.arg2, ccall_info.arg3, ccall_info.arg4,
+	     ccall_info.arg5);
 	ccall_info.processors_out[i] = 1;
 }
 
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -1636,19 +1636,19 @@ static void __init get_srmmu_type(void)
 /* Local cross-calls. */
 static void smp_flush_page_for_dma(unsigned long page)
 {
-	xc1((smpfunc_t) local_ops->page_for_dma, page);
+	xc1(local_ops->page_for_dma, page);
 	local_ops->page_for_dma(page);
 }
 
 static void smp_flush_cache_all(void)
 {
-	xc0((smpfunc_t) local_ops->cache_all);
+	xc0(local_ops->cache_all);
 	local_ops->cache_all();
 }
 
 static void smp_flush_tlb_all(void)
 {
-	xc0((smpfunc_t) local_ops->tlb_all);
+	xc0(local_ops->tlb_all);
 	local_ops->tlb_all();
 }
 
@@ -1659,7 +1659,7 @@ static void smp_flush_cache_mm(struct mm
 		cpumask_copy(&cpu_mask, mm_cpumask(mm));
 		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 		if (!cpumask_empty(&cpu_mask))
-			xc1((smpfunc_t) local_ops->cache_mm, (unsigned long) mm);
+			xc1(local_ops->cache_mm, (unsigned long)mm);
 		local_ops->cache_mm(mm);
 	}
 }
@@ -1671,7 +1671,7 @@ static void smp_flush_tlb_mm(struct mm_s
 		cpumask_copy(&cpu_mask, mm_cpumask(mm));
 		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 		if (!cpumask_empty(&cpu_mask)) {
-			xc1((smpfunc_t) local_ops->tlb_mm, (unsigned long) mm);
+			xc1(local_ops->tlb_mm, (unsigned long)mm);
 			if (atomic_read(&mm->mm_users) == 1 && current->active_mm == mm)
 				cpumask_copy(mm_cpumask(mm),
 					     cpumask_of(smp_processor_id()));
@@ -1691,8 +1691,8 @@ static void smp_flush_cache_range(struct
 		cpumask_copy(&cpu_mask, mm_cpumask(mm));
 		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 		if (!cpumask_empty(&cpu_mask))
-			xc3((smpfunc_t) local_ops->cache_range,
-			    (unsigned long) vma, start, end);
+			xc3(local_ops->cache_range, (unsigned long)vma, start,
+			    end);
 		local_ops->cache_range(vma, start, end);
 	}
 }
@@ -1708,8 +1708,8 @@ static void smp_flush_tlb_range(struct v
 		cpumask_copy(&cpu_mask, mm_cpumask(mm));
 		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 		if (!cpumask_empty(&cpu_mask))
-			xc3((smpfunc_t) local_ops->tlb_range,
-			    (unsigned long) vma, start, end);
+			xc3(local_ops->tlb_range, (unsigned long)vma, start,
+			    end);
 		local_ops->tlb_range(vma, start, end);
 	}
 }
@@ -1723,8 +1723,7 @@ static void smp_flush_cache_page(struct
 		cpumask_copy(&cpu_mask, mm_cpumask(mm));
 		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 		if (!cpumask_empty(&cpu_mask))
-			xc2((smpfunc_t) local_ops->cache_page,
-			    (unsigned long) vma, page);
+			xc2(local_ops->cache_page, (unsigned long)vma, page);
 		local_ops->cache_page(vma, page);
 	}
 }
@@ -1738,8 +1737,7 @@ static void smp_flush_tlb_page(struct vm
 		cpumask_copy(&cpu_mask, mm_cpumask(mm));
 		cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 		if (!cpumask_empty(&cpu_mask))
-			xc2((smpfunc_t) local_ops->tlb_page,
-			    (unsigned long) vma, page);
+			xc2(local_ops->tlb_page, (unsigned long)vma, page);
 		local_ops->tlb_page(vma, page);
 	}
 }
@@ -1753,7 +1751,7 @@ static void smp_flush_page_to_ram(unsign
 	 * XXX This experiment failed, research further... -DaveM
 	 */
 #if 1
-	xc1((smpfunc_t) local_ops->page_to_ram, page);
+	xc1(local_ops->page_to_ram, page);
 #endif
 	local_ops->page_to_ram(page);
 }
@@ -1764,8 +1762,7 @@ static void smp_flush_sig_insns(struct m
 	cpumask_copy(&cpu_mask, mm_cpumask(mm));
 	cpumask_clear_cpu(smp_processor_id(), &cpu_mask);
 	if (!cpumask_empty(&cpu_mask))
-		xc2((smpfunc_t) local_ops->sig_insns,
-		    (unsigned long) mm, insn_addr);
+		xc2(local_ops->sig_insns, (unsigned long)mm, insn_addr);
 	local_ops->sig_insns(mm, insn_addr);
 }
 


