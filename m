Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07FD026492
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbfEVNYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:24:22 -0400
Received: from foss.arm.com ([217.140.101.70]:50714 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbfEVNYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:24:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 836CD80D;
        Wed, 22 May 2019 06:24:21 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 438E03F575;
        Wed, 22 May 2019 06:24:17 -0700 (PDT)
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
Subject: [PATCH 05/18] locking/atomic: arc: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:37 +0100
Message-Id: <20190522132250.26499-6-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As a step towards making the atomic64 API use consistent types treewide,
let's have the arc atomic64 implementation use s64 as the underlying
type for atomic64_t, rather than u64, matching the generated headers.

Otherwise, there should be no functional change as a result of this
patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arc/include/asm/atomic.h | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/arch/arc/include/asm/atomic.h b/arch/arc/include/asm/atomic.h
index 158af079838d..2c75df55d0d2 100644
--- a/arch/arc/include/asm/atomic.h
+++ b/arch/arc/include/asm/atomic.h
@@ -324,14 +324,14 @@ ATOMIC_OPS(xor, ^=, CTOP_INST_AXOR_DI_R2_R2_R3)
  */
 
 typedef struct {
-	aligned_u64 counter;
+	s64 __aligned(8) counter;
 } atomic64_t;
 
 #define ATOMIC64_INIT(a) { (a) }
 
-static inline long long atomic64_read(const atomic64_t *v)
+static inline s64 atomic64_read(const atomic64_t *v)
 {
-	unsigned long long val;
+	s64 val;
 
 	__asm__ __volatile__(
 	"	ldd   %0, [%1]	\n"
@@ -341,7 +341,7 @@ static inline long long atomic64_read(const atomic64_t *v)
 	return val;
 }
 
-static inline void atomic64_set(atomic64_t *v, long long a)
+static inline void atomic64_set(atomic64_t *v, s64 a)
 {
 	/*
 	 * This could have been a simple assignment in "C" but would need
@@ -362,9 +362,9 @@ static inline void atomic64_set(atomic64_t *v, long long a)
 }
 
 #define ATOMIC64_OP(op, op1, op2)					\
-static inline void atomic64_##op(long long a, atomic64_t *v)		\
+static inline void atomic64_##op(s64 a, atomic64_t *v)			\
 {									\
-	unsigned long long val;						\
+	s64 val;							\
 									\
 	__asm__ __volatile__(						\
 	"1:				\n"				\
@@ -375,13 +375,13 @@ static inline void atomic64_##op(long long a, atomic64_t *v)		\
 	"	bnz     1b		\n"				\
 	: "=&r"(val)							\
 	: "r"(&v->counter), "ir"(a)					\
-	: "cc");						\
+	: "cc");							\
 }									\
 
 #define ATOMIC64_OP_RETURN(op, op1, op2)		        	\
-static inline long long atomic64_##op##_return(long long a, atomic64_t *v)	\
+static inline s64 atomic64_##op##_return(s64 a, atomic64_t *v)		\
 {									\
-	unsigned long long val;						\
+	s64 val;							\
 									\
 	smp_mb();							\
 									\
@@ -402,9 +402,9 @@ static inline long long atomic64_##op##_return(long long a, atomic64_t *v)	\
 }
 
 #define ATOMIC64_FETCH_OP(op, op1, op2)		        		\
-static inline long long atomic64_fetch_##op(long long a, atomic64_t *v)	\
+static inline s64 atomic64_fetch_##op(s64 a, atomic64_t *v)		\
 {									\
-	unsigned long long val, orig;					\
+	s64 val, orig;							\
 									\
 	smp_mb();							\
 									\
@@ -444,10 +444,10 @@ ATOMIC64_OPS(xor, xor, xor)
 #undef ATOMIC64_OP_RETURN
 #undef ATOMIC64_OP
 
-static inline long long
-atomic64_cmpxchg(atomic64_t *ptr, long long expected, long long new)
+static inline s64
+atomic64_cmpxchg(atomic64_t *ptr, s64 expected, s64 new)
 {
-	long long prev;
+	s64 prev;
 
 	smp_mb();
 
@@ -467,9 +467,9 @@ atomic64_cmpxchg(atomic64_t *ptr, long long expected, long long new)
 	return prev;
 }
 
-static inline long long atomic64_xchg(atomic64_t *ptr, long long new)
+static inline s64 atomic64_xchg(atomic64_t *ptr, s64 new)
 {
-	long long prev;
+	s64 prev;
 
 	smp_mb();
 
@@ -495,9 +495,9 @@ static inline long long atomic64_xchg(atomic64_t *ptr, long long new)
  * the atomic variable, v, was not decremented.
  */
 
-static inline long long atomic64_dec_if_positive(atomic64_t *v)
+static inline s64 atomic64_dec_if_positive(atomic64_t *v)
 {
-	long long val;
+	s64 val;
 
 	smp_mb();
 
@@ -528,10 +528,9 @@ static inline long long atomic64_dec_if_positive(atomic64_t *v)
  * Atomically adds @a to @v, if it was not @u.
  * Returns the old value of @v
  */
-static inline long long atomic64_fetch_add_unless(atomic64_t *v, long long a,
-						  long long u)
+static inline s64 atomic64_fetch_add_unless(atomic64_t *v, s64 a, s64 u)
 {
-	long long old, temp;
+	s64 old, temp;
 
 	smp_mb();
 
-- 
2.11.0

