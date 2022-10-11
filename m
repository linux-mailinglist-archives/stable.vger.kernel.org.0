Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8BB5FB5B3
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiJKO4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJKOzs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488129C7EA;
        Tue, 11 Oct 2022 07:51:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDF78611C2;
        Tue, 11 Oct 2022 14:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502B6C433D7;
        Tue, 11 Oct 2022 14:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499918;
        bh=lTonXqYouYJDM8za04vImupYKIwiGTG24m+550NvVwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9g+Q4lGR/tA+/5bxNlorj4eOqUm93HIkptGemcQwp9pPKCkdaiipdxtCeCrDegr5
         5fndCmuwlRIvHSvQWXfFDrol96/qnV+sqMUFAOmiCt1m6kXUExW2Xqry1p57RIZyvD
         CZNpEjUc3uIFsOmbcRKPuvjjHkQ+knRQVrHX6RLDrpUDyAzpPHv9EMQdKns7PlT6Af
         bqPVTidxsy+3Db5g/VRogiwwtiy0akJ2fx/y4L3hDcRC7QNZehW9yyNSwJd/FYV6CV
         AMdr8p9VCKJTM+pyKMULHX7LJH1U68rUat9FQf4sat8RoEo2Not27gCBkfWDMhwFc1
         nb6RXiyMC0tOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 17/40] arm64: atomics: remove LL/SC trampolines
Date:   Tue, 11 Oct 2022 10:51:06 -0400
Message-Id: <20221011145129.1623487-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit b2c3ccbd0011bb3b51d0fec24cb3a5812b1ec8ea ]

When CONFIG_ARM64_LSE_ATOMICS=y, each use of an LL/SC atomic results in
a fragment of code being generated in a subsection without a clear
association with its caller. A trampoline in the caller branches to the
LL/SC atomic with with a direct branch, and the atomic directly branches
back into its trampoline.

This breaks backtracing, as any PC within the out-of-line fragment will
be symbolized as an offset from the nearest prior symbol (which may not
be the function using the atomic), and since the atomic returns with a
direct branch, the caller's PC may be missing from the backtrace.

For example, with secondary_start_kernel() hacked to contain
atomic_inc(NULL), the resulting exception can be reported as being taken
from cpus_are_stuck_in_kernel():

| Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
| Mem abort info:
|   ESR = 0x0000000096000004
|   EC = 0x25: DABT (current EL), IL = 32 bits
|   SET = 0, FnV = 0
|   EA = 0, S1PTW = 0
|   FSC = 0x04: level 0 translation fault
| Data abort info:
|   ISV = 0, ISS = 0x00000004
|   CM = 0, WnR = 0
| [0000000000000000] user address but active_mm is swapper
| Internal error: Oops: 96000004 [#1] PREEMPT SMP
| Modules linked in:
| CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.19.0-11219-geb555cb5b794-dirty #3
| Hardware name: linux,dummy-virt (DT)
| pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
| pc : cpus_are_stuck_in_kernel+0xa4/0x120
| lr : secondary_start_kernel+0x164/0x170
| sp : ffff80000a4cbe90
| x29: ffff80000a4cbe90 x28: 0000000000000000 x27: 0000000000000000
| x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
| x23: 0000000000000000 x22: 0000000000000000 x21: 0000000000000000
| x20: 0000000000000001 x19: 0000000000000001 x18: 0000000000000008
| x17: 3030383832343030 x16: 3030303030307830 x15: ffff80000a4cbab0
| x14: 0000000000000001 x13: 5d31666130663133 x12: 3478305b20313030
| x11: 3030303030303078 x10: 3020726f73736563 x9 : 726f737365636f72
| x8 : ffff800009ff2ef0 x7 : 0000000000000003 x6 : 0000000000000000
| x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000100
| x2 : 0000000000000000 x1 : ffff0000029bd880 x0 : 0000000000000000
| Call trace:
|  cpus_are_stuck_in_kernel+0xa4/0x120
|  __secondary_switched+0xb0/0xb4
| Code: 35ffffa3 17fffc6c d53cd040 f9800011 (885f7c01)
| ---[ end trace 0000000000000000 ]---

This is confusing and hinders debugging, and will be problematic for
CONFIG_LIVEPATCH as these cases cannot be unwound reliably.

This is very similar to recent issues with out-of-line exception fixups,
which were removed in commits:

  35d67794b8828333 ("arm64: lib: __arch_clear_user(): fold fixups into body")
  4012e0e22739eef9 ("arm64: lib: __arch_copy_from_user(): fold fixups into body")
  139f9ab73d60cf76 ("arm64: lib: __arch_copy_to_user(): fold fixups into body")

When the trampolines were introduced in commit:

  addfc38672c73efd ("arm64: atomics: avoid out-of-line ll/sc atomics")

The rationale was to improve icache performance by grouping the LL/SC
atomics together. This has never been measured, and this theoretical
benefit is outweighed by other factors:

* As the subsections are collapsed into sections at object file
  granularity, these are spread out throughout the kernel and can share
  cachelines with unrelated code regardless.

* GCC 12.1.0 has been observed to place the trampoline out-of-line in
  specialised __ll_sc_*() functions, introducing more branching than was
  intended.

* Removing the trampolines has been observed to shrink a defconfig
  kernel Image by 64KiB when building with GCC 12.1.0.

This patch removes the LL/SC trampolines, meaning that the LL/SC atomics
will be inlined into their callers (or placed in out-of line functions
using regular BL/RET pairs). When CONFIG_ARM64_LSE_ATOMICS=y, the LL/SC
atomics are always called in an unlikely branch, and will be placed in a
cold portion of the function, so this should have minimal impact to the
hot paths.

Other than the improved backtracing, there should be no functional
change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220817155914.3975112-2-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/atomic_ll_sc.h | 40 ++++++---------------------
 1 file changed, 9 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index fe0db8d416fb..906e2d8c254c 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -12,19 +12,6 @@
 
 #include <linux/stringify.h>
 
-#ifdef CONFIG_ARM64_LSE_ATOMICS
-#define __LL_SC_FALLBACK(asm_ops)					\
-"	b	3f\n"							\
-"	.subsection	1\n"						\
-"3:\n"									\
-asm_ops "\n"								\
-"	b	4f\n"							\
-"	.previous\n"							\
-"4:\n"
-#else
-#define __LL_SC_FALLBACK(asm_ops) asm_ops
-#endif
-
 #ifndef CONFIG_CC_HAS_K_CONSTRAINT
 #define K
 #endif
@@ -43,12 +30,11 @@ __ll_sc_atomic_##op(int i, atomic_t *v)					\
 	int result;							\
 									\
 	asm volatile("// atomic_" #op "\n"				\
-	__LL_SC_FALLBACK(						\
 	"	prfm	pstl1strm, %2\n"				\
 	"1:	ldxr	%w0, %2\n"					\
 	"	" #asm_op "	%w0, %w0, %w3\n"			\
 	"	stxr	%w1, %w0, %2\n"					\
-	"	cbnz	%w1, 1b\n")					\
+	"	cbnz	%w1, 1b\n"					\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i));				\
 }
@@ -61,13 +47,12 @@ __ll_sc_atomic_##op##_return##name(int i, atomic_t *v)			\
 	int result;							\
 									\
 	asm volatile("// atomic_" #op "_return" #name "\n"		\
-	__LL_SC_FALLBACK(						\
 	"	prfm	pstl1strm, %2\n"				\
 	"1:	ld" #acq "xr	%w0, %2\n"				\
 	"	" #asm_op "	%w0, %w0, %w3\n"			\
 	"	st" #rel "xr	%w1, %w0, %2\n"				\
 	"	cbnz	%w1, 1b\n"					\
-	"	" #mb )							\
+	"	" #mb							\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -83,13 +68,12 @@ __ll_sc_atomic_fetch_##op##name(int i, atomic_t *v)			\
 	int val, result;						\
 									\
 	asm volatile("// atomic_fetch_" #op #name "\n"			\
-	__LL_SC_FALLBACK(						\
 	"	prfm	pstl1strm, %3\n"				\
 	"1:	ld" #acq "xr	%w0, %3\n"				\
 	"	" #asm_op "	%w1, %w0, %w4\n"			\
 	"	st" #rel "xr	%w2, %w1, %3\n"				\
 	"	cbnz	%w2, 1b\n"					\
-	"	" #mb )							\
+	"	" #mb							\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -142,12 +126,11 @@ __ll_sc_atomic64_##op(s64 i, atomic64_t *v)				\
 	unsigned long tmp;						\
 									\
 	asm volatile("// atomic64_" #op "\n"				\
-	__LL_SC_FALLBACK(						\
 	"	prfm	pstl1strm, %2\n"				\
 	"1:	ldxr	%0, %2\n"					\
 	"	" #asm_op "	%0, %0, %3\n"				\
 	"	stxr	%w1, %0, %2\n"					\
-	"	cbnz	%w1, 1b")					\
+	"	cbnz	%w1, 1b"					\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i));				\
 }
@@ -160,13 +143,12 @@ __ll_sc_atomic64_##op##_return##name(s64 i, atomic64_t *v)		\
 	unsigned long tmp;						\
 									\
 	asm volatile("// atomic64_" #op "_return" #name "\n"		\
-	__LL_SC_FALLBACK(						\
 	"	prfm	pstl1strm, %2\n"				\
 	"1:	ld" #acq "xr	%0, %2\n"				\
 	"	" #asm_op "	%0, %0, %3\n"				\
 	"	st" #rel "xr	%w1, %0, %2\n"				\
 	"	cbnz	%w1, 1b\n"					\
-	"	" #mb )							\
+	"	" #mb							\
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)		\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -182,13 +164,12 @@ __ll_sc_atomic64_fetch_##op##name(s64 i, atomic64_t *v)			\
 	unsigned long tmp;						\
 									\
 	asm volatile("// atomic64_fetch_" #op #name "\n"		\
-	__LL_SC_FALLBACK(						\
 	"	prfm	pstl1strm, %3\n"				\
 	"1:	ld" #acq "xr	%0, %3\n"				\
 	"	" #asm_op "	%1, %0, %4\n"				\
 	"	st" #rel "xr	%w2, %1, %3\n"				\
 	"	cbnz	%w2, 1b\n"					\
-	"	" #mb )							\
+	"	" #mb							\
 	: "=&r" (result), "=&r" (val), "=&r" (tmp), "+Q" (v->counter)	\
 	: __stringify(constraint) "r" (i)				\
 	: cl);								\
@@ -240,7 +221,6 @@ __ll_sc_atomic64_dec_if_positive(atomic64_t *v)
 	unsigned long tmp;
 
 	asm volatile("// atomic64_dec_if_positive\n"
-	__LL_SC_FALLBACK(
 	"	prfm	pstl1strm, %2\n"
 	"1:	ldxr	%0, %2\n"
 	"	subs	%0, %0, #1\n"
@@ -248,7 +228,7 @@ __ll_sc_atomic64_dec_if_positive(atomic64_t *v)
 	"	stlxr	%w1, %0, %2\n"
 	"	cbnz	%w1, 1b\n"
 	"	dmb	ish\n"
-	"2:")
+	"2:"
 	: "=&r" (result), "=&r" (tmp), "+Q" (v->counter)
 	:
 	: "cc", "memory");
@@ -274,7 +254,6 @@ __ll_sc__cmpxchg_case_##name##sz(volatile void *ptr,			\
 		old = (u##sz)old;					\
 									\
 	asm volatile(							\
-	__LL_SC_FALLBACK(						\
 	"	prfm	pstl1strm, %[v]\n"				\
 	"1:	ld" #acq "xr" #sfx "\t%" #w "[oldval], %[v]\n"		\
 	"	eor	%" #w "[tmp], %" #w "[oldval], %" #w "[old]\n"	\
@@ -282,7 +261,7 @@ __ll_sc__cmpxchg_case_##name##sz(volatile void *ptr,			\
 	"	st" #rel "xr" #sfx "\t%w[tmp], %" #w "[new], %[v]\n"	\
 	"	cbnz	%w[tmp], 1b\n"					\
 	"	" #mb "\n"						\
-	"2:")								\
+	"2:"								\
 	: [tmp] "=&r" (tmp), [oldval] "=&r" (oldval),			\
 	  [v] "+Q" (*(u##sz *)ptr)					\
 	: [old] __stringify(constraint) "r" (old), [new] "r" (new)	\
@@ -326,7 +305,6 @@ __ll_sc__cmpxchg_double##name(unsigned long old1,			\
 	unsigned long tmp, ret;						\
 									\
 	asm volatile("// __cmpxchg_double" #name "\n"			\
-	__LL_SC_FALLBACK(						\
 	"	prfm	pstl1strm, %2\n"				\
 	"1:	ldxp	%0, %1, %2\n"					\
 	"	eor	%0, %0, %3\n"					\
@@ -336,7 +314,7 @@ __ll_sc__cmpxchg_double##name(unsigned long old1,			\
 	"	st" #rel "xp	%w0, %5, %6, %2\n"			\
 	"	cbnz	%w0, 1b\n"					\
 	"	" #mb "\n"						\
-	"2:")								\
+	"2:"								\
 	: "=&r" (tmp), "=&r" (ret), "+Q" (*(unsigned long *)ptr)	\
 	: "r" (old1), "r" (old2), "r" (new1), "r" (new2)		\
 	: cl);								\
-- 
2.35.1

