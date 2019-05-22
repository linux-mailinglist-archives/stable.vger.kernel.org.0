Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D411726496
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbfEVNYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:24:37 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:50818 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729059AbfEVNYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:24:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89EBD15AB;
        Wed, 22 May 2019 06:24:36 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4A2F83F575;
        Wed, 22 May 2019 06:24:32 -0700 (PDT)
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        will.deacon@arm.com
Cc:     aou@eecs.berkeley.edu, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, davem@davemloft.net, fenghua.yu@intel.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        ink@jurassic.park.msu.ru, jhogan@kernel.org, linux@armlinux.org.uk,
        mark.rutland@arm.com, mattst88@gmail.com, mingo@kernel.org,
        mpe@ellerman.id.au, palmer@sifive.com, paul.burton@mips.com,
        paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net,
        stable@vger.kernel.org, tglx@linutronix.de, tony.luck@intel.com,
        vgupta@synopsys.com
Subject: [PATCH 07/18] locking/atomic: arm64: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:39 +0100
Message-Id: <20190522132250.26499-8-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As a step towards making the atomic64 API use consistent types treewide,
let's have the arm64 atomic64 implementation use s64 as the underlying
type for atomic64_t, rather than long, matching the generated headers.

As atomic64_read() depends on the generic defintion of atomic64_t, this
still returns long. This will be converted in a subsequent patch.

Note that in arch_atomic64_dec_if_positive(), the x0 variable is left as
long, as this variable is also used to hold the pointer to the
atomic64_t.

Otherwise, there should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/atomic_ll_sc.h | 20 ++++++++++----------
 arch/arm64/include/asm/atomic_lse.h   | 34 +++++++++++++++++-----------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/atomic_ll_sc.h b/arch/arm64/include/asm/atomic_ll_sc.h
index e321293e0c89..f3b12d7f431f 100644
--- a/arch/arm64/include/asm/atomic_ll_sc.h
+++ b/arch/arm64/include/asm/atomic_ll_sc.h
@@ -133,9 +133,9 @@ ATOMIC_OPS(xor, eor)
 
 #define ATOMIC64_OP(op, asm_op)						\
 __LL_SC_INLINE void							\
-__LL_SC_PREFIX(arch_atomic64_##op(long i, atomic64_t *v))		\
+__LL_SC_PREFIX(arch_atomic64_##op(s64 i, atomic64_t *v))		\
 {									\
-	long result;							\
+	s64 result;							\
 	unsigned long tmp;						\
 									\
 	asm volatile("// atomic64_" #op "\n"				\
@@ -150,10 +150,10 @@ __LL_SC_PREFIX(arch_atomic64_##op(long i, atomic64_t *v))		\
 __LL_SC_EXPORT(arch_atomic64_##op);
 
 #define ATOMIC64_OP_RETURN(name, mb, acq, rel, cl, op, asm_op)		\
-__LL_SC_INLINE long							\
-__LL_SC_PREFIX(arch_atomic64_##op##_return##name(long i, atomic64_t *v))\
+__LL_SC_INLINE s64							\
+__LL_SC_PREFIX(arch_atomic64_##op##_return##name(s64 i, atomic64_t *v))\
 {									\
-	long result;							\
+	s64 result;							\
 	unsigned long tmp;						\
 									\
 	asm volatile("// atomic64_" #op "_return" #name "\n"		\
@@ -172,10 +172,10 @@ __LL_SC_PREFIX(arch_atomic64_##op##_return##name(long i, atomic64_t *v))\
 __LL_SC_EXPORT(arch_atomic64_##op##_return##name);
 
 #define ATOMIC64_FETCH_OP(name, mb, acq, rel, cl, op, asm_op)		\
-__LL_SC_INLINE long							\
-__LL_SC_PREFIX(arch_atomic64_fetch_##op##name(long i, atomic64_t *v))	\
+__LL_SC_INLINE s64							\
+__LL_SC_PREFIX(arch_atomic64_fetch_##op##name(s64 i, atomic64_t *v))	\
 {									\
-	long result, val;						\
+	s64 result, val;						\
 	unsigned long tmp;						\
 									\
 	asm volatile("// atomic64_fetch_" #op #name "\n"		\
@@ -225,10 +225,10 @@ ATOMIC64_OPS(xor, eor)
 #undef ATOMIC64_OP_RETURN
 #undef ATOMIC64_OP
 
-__LL_SC_INLINE long
+__LL_SC_INLINE s64
 __LL_SC_PREFIX(arch_atomic64_dec_if_positive(atomic64_t *v))
 {
-	long result;
+	s64 result;
 	unsigned long tmp;
 
 	asm volatile("// atomic64_dec_if_positive\n"
diff --git a/arch/arm64/include/asm/atomic_lse.h b/arch/arm64/include/asm/atomic_lse.h
index 9256a3921e4b..c53832b08af7 100644
--- a/arch/arm64/include/asm/atomic_lse.h
+++ b/arch/arm64/include/asm/atomic_lse.h
@@ -224,9 +224,9 @@ ATOMIC_FETCH_OP_SUB(        , al, "memory")
 
 #define __LL_SC_ATOMIC64(op)	__LL_SC_CALL(arch_atomic64_##op)
 #define ATOMIC64_OP(op, asm_op)						\
-static inline void arch_atomic64_##op(long i, atomic64_t *v)		\
+static inline void arch_atomic64_##op(s64 i, atomic64_t *v)		\
 {									\
-	register long x0 asm ("x0") = i;				\
+	register s64 x0 asm ("x0") = i;					\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
 	asm volatile(ARM64_LSE_ATOMIC_INSN(__LL_SC_ATOMIC64(op),	\
@@ -244,9 +244,9 @@ ATOMIC64_OP(add, stadd)
 #undef ATOMIC64_OP
 
 #define ATOMIC64_FETCH_OP(name, mb, op, asm_op, cl...)			\
-static inline long arch_atomic64_fetch_##op##name(long i, atomic64_t *v)\
+static inline s64 arch_atomic64_fetch_##op##name(s64 i, atomic64_t *v)	\
 {									\
-	register long x0 asm ("x0") = i;				\
+	register s64 x0 asm ("x0") = i;					\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
 	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
@@ -276,9 +276,9 @@ ATOMIC64_FETCH_OPS(add, ldadd)
 #undef ATOMIC64_FETCH_OPS
 
 #define ATOMIC64_OP_ADD_RETURN(name, mb, cl...)				\
-static inline long arch_atomic64_add_return##name(long i, atomic64_t *v)\
+static inline s64 arch_atomic64_add_return##name(s64 i, atomic64_t *v)	\
 {									\
-	register long x0 asm ("x0") = i;				\
+	register s64 x0 asm ("x0") = i;					\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
 	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
@@ -302,9 +302,9 @@ ATOMIC64_OP_ADD_RETURN(        , al, "memory")
 
 #undef ATOMIC64_OP_ADD_RETURN
 
-static inline void arch_atomic64_and(long i, atomic64_t *v)
+static inline void arch_atomic64_and(s64 i, atomic64_t *v)
 {
-	register long x0 asm ("x0") = i;
+	register s64 x0 asm ("x0") = i;
 	register atomic64_t *x1 asm ("x1") = v;
 
 	asm volatile(ARM64_LSE_ATOMIC_INSN(
@@ -320,9 +320,9 @@ static inline void arch_atomic64_and(long i, atomic64_t *v)
 }
 
 #define ATOMIC64_FETCH_OP_AND(name, mb, cl...)				\
-static inline long arch_atomic64_fetch_and##name(long i, atomic64_t *v)	\
+static inline s64 arch_atomic64_fetch_and##name(s64 i, atomic64_t *v)	\
 {									\
-	register long x0 asm ("x0") = i;				\
+	register s64 x0 asm ("x0") = i;					\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
 	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
@@ -346,9 +346,9 @@ ATOMIC64_FETCH_OP_AND(        , al, "memory")
 
 #undef ATOMIC64_FETCH_OP_AND
 
-static inline void arch_atomic64_sub(long i, atomic64_t *v)
+static inline void arch_atomic64_sub(s64 i, atomic64_t *v)
 {
-	register long x0 asm ("x0") = i;
+	register s64 x0 asm ("x0") = i;
 	register atomic64_t *x1 asm ("x1") = v;
 
 	asm volatile(ARM64_LSE_ATOMIC_INSN(
@@ -364,9 +364,9 @@ static inline void arch_atomic64_sub(long i, atomic64_t *v)
 }
 
 #define ATOMIC64_OP_SUB_RETURN(name, mb, cl...)				\
-static inline long arch_atomic64_sub_return##name(long i, atomic64_t *v)\
+static inline s64 arch_atomic64_sub_return##name(s64 i, atomic64_t *v)	\
 {									\
-	register long x0 asm ("x0") = i;				\
+	register s64 x0 asm ("x0") = i;					\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
 	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
@@ -392,9 +392,9 @@ ATOMIC64_OP_SUB_RETURN(        , al, "memory")
 #undef ATOMIC64_OP_SUB_RETURN
 
 #define ATOMIC64_FETCH_OP_SUB(name, mb, cl...)				\
-static inline long arch_atomic64_fetch_sub##name(long i, atomic64_t *v)	\
+static inline s64 arch_atomic64_fetch_sub##name(s64 i, atomic64_t *v)	\
 {									\
-	register long x0 asm ("x0") = i;				\
+	register s64 x0 asm ("x0") = i;					\
 	register atomic64_t *x1 asm ("x1") = v;				\
 									\
 	asm volatile(ARM64_LSE_ATOMIC_INSN(				\
@@ -418,7 +418,7 @@ ATOMIC64_FETCH_OP_SUB(        , al, "memory")
 
 #undef ATOMIC64_FETCH_OP_SUB
 
-static inline long arch_atomic64_dec_if_positive(atomic64_t *v)
+static inline s64 arch_atomic64_dec_if_positive(atomic64_t *v)
 {
 	register long x0 asm ("x0") = (long)v;
 
-- 
2.11.0

