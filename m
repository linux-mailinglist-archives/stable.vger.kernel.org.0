Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE00F26494
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfEVNYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:24:30 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:50766 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbfEVNY3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:24:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E71780D;
        Wed, 22 May 2019 06:24:29 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4F37C3F575;
        Wed, 22 May 2019 06:24:25 -0700 (PDT)
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
Subject: [PATCH 06/18] locking/atomic: arm: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:38 +0100
Message-Id: <20190522132250.26499-7-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As a step towards making the atomic64 API use consistent types treewide,
let's have the arm atomic64 implementation use s64 as the underlying
type for atomic64_t, rather than long long, matching the generated
headers.

Otherwise, there should be no functional change as a result of this
patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/atomic.h | 50 +++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index f74756641410..d45c41f6f69c 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -249,15 +249,15 @@ ATOMIC_OPS(xor, ^=, eor)
 
 #ifndef CONFIG_GENERIC_ATOMIC64
 typedef struct {
-	long long counter;
+	s64 counter;
 } atomic64_t;
 
 #define ATOMIC64_INIT(i) { (i) }
 
 #ifdef CONFIG_ARM_LPAE
-static inline long long atomic64_read(const atomic64_t *v)
+static inline s64 atomic64_read(const atomic64_t *v)
 {
-	long long result;
+	s64 result;
 
 	__asm__ __volatile__("@ atomic64_read\n"
 "	ldrd	%0, %H0, [%1]"
@@ -268,7 +268,7 @@ static inline long long atomic64_read(const atomic64_t *v)
 	return result;
 }
 
-static inline void atomic64_set(atomic64_t *v, long long i)
+static inline void atomic64_set(atomic64_t *v, s64 i)
 {
 	__asm__ __volatile__("@ atomic64_set\n"
 "	strd	%2, %H2, [%1]"
@@ -277,9 +277,9 @@ static inline void atomic64_set(atomic64_t *v, long long i)
 	);
 }
 #else
-static inline long long atomic64_read(const atomic64_t *v)
+static inline s64 atomic64_read(const atomic64_t *v)
 {
-	long long result;
+	s64 result;
 
 	__asm__ __volatile__("@ atomic64_read\n"
 "	ldrexd	%0, %H0, [%1]"
@@ -290,9 +290,9 @@ static inline long long atomic64_read(const atomic64_t *v)
 	return result;
 }
 
-static inline void atomic64_set(atomic64_t *v, long long i)
+static inline void atomic64_set(atomic64_t *v, s64 i)
 {
-	long long tmp;
+	s64 tmp;
 
 	prefetchw(&v->counter);
 	__asm__ __volatile__("@ atomic64_set\n"
@@ -307,9 +307,9 @@ static inline void atomic64_set(atomic64_t *v, long long i)
 #endif
 
 #define ATOMIC64_OP(op, op1, op2)					\
-static inline void atomic64_##op(long long i, atomic64_t *v)		\
+static inline void atomic64_##op(s64 i, atomic64_t *v)			\
 {									\
-	long long result;						\
+	s64 result;							\
 	unsigned long tmp;						\
 									\
 	prefetchw(&v->counter);						\
@@ -326,10 +326,10 @@ static inline void atomic64_##op(long long i, atomic64_t *v)		\
 }									\
 
 #define ATOMIC64_OP_RETURN(op, op1, op2)				\
-static inline long long							\
-atomic64_##op##_return_relaxed(long long i, atomic64_t *v)		\
+static inline s64							\
+atomic64_##op##_return_relaxed(s64 i, atomic64_t *v)			\
 {									\
-	long long result;						\
+	s64 result;							\
 	unsigned long tmp;						\
 									\
 	prefetchw(&v->counter);						\
@@ -349,10 +349,10 @@ atomic64_##op##_return_relaxed(long long i, atomic64_t *v)		\
 }
 
 #define ATOMIC64_FETCH_OP(op, op1, op2)					\
-static inline long long							\
-atomic64_fetch_##op##_relaxed(long long i, atomic64_t *v)		\
+static inline s64							\
+atomic64_fetch_##op##_relaxed(s64 i, atomic64_t *v)			\
 {									\
-	long long result, val;						\
+	s64 result, val;						\
 	unsigned long tmp;						\
 									\
 	prefetchw(&v->counter);						\
@@ -406,10 +406,9 @@ ATOMIC64_OPS(xor, eor, eor)
 #undef ATOMIC64_OP_RETURN
 #undef ATOMIC64_OP
 
-static inline long long
-atomic64_cmpxchg_relaxed(atomic64_t *ptr, long long old, long long new)
+static inline s64 atomic64_cmpxchg_relaxed(atomic64_t *ptr, s64 old, s64 new)
 {
-	long long oldval;
+	s64 oldval;
 	unsigned long res;
 
 	prefetchw(&ptr->counter);
@@ -430,9 +429,9 @@ atomic64_cmpxchg_relaxed(atomic64_t *ptr, long long old, long long new)
 }
 #define atomic64_cmpxchg_relaxed	atomic64_cmpxchg_relaxed
 
-static inline long long atomic64_xchg_relaxed(atomic64_t *ptr, long long new)
+static inline s64 atomic64_xchg_relaxed(atomic64_t *ptr, s64 new)
 {
-	long long result;
+	s64 result;
 	unsigned long tmp;
 
 	prefetchw(&ptr->counter);
@@ -450,9 +449,9 @@ static inline long long atomic64_xchg_relaxed(atomic64_t *ptr, long long new)
 }
 #define atomic64_xchg_relaxed		atomic64_xchg_relaxed
 
-static inline long long atomic64_dec_if_positive(atomic64_t *v)
+static inline s64 atomic64_dec_if_positive(atomic64_t *v)
 {
-	long long result;
+	s64 result;
 	unsigned long tmp;
 
 	smp_mb();
@@ -478,10 +477,9 @@ static inline long long atomic64_dec_if_positive(atomic64_t *v)
 }
 #define atomic64_dec_if_positive atomic64_dec_if_positive
 
-static inline long long atomic64_fetch_add_unless(atomic64_t *v, long long a,
-						  long long u)
+static inline s64 atomic64_fetch_add_unless(atomic64_t *v, s64 a, s64 u)
 {
-	long long oldval, newval;
+	s64 oldval, newval;
 	unsigned long tmp;
 
 	smp_mb();
-- 
2.11.0

