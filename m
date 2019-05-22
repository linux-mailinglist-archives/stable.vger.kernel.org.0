Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B14264A2
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729324AbfEVNZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:25:13 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:51078 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbfEVNZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:25:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6FD2E80D;
        Wed, 22 May 2019 06:25:12 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2DFF13F575;
        Wed, 22 May 2019 06:25:08 -0700 (PDT)
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
Subject: [PATCH 12/18] locking/atomic: riscv: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:44 +0100
Message-Id: <20190522132250.26499-13-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As a step towards making the atomic64 API use consistent types treewide,
let's have the s390 atomic64 implementation use s64 as the underlying
type for atomic64_t, rather than long, matching the generated headers.

As atomic64_read() depends on the generic defintion of atomic64_t, this
still returns long on 64-bit. This will be converted in a subsequent
patch.

Otherwise, there should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/riscv/include/asm/atomic.h | 44 +++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/riscv/include/asm/atomic.h b/arch/riscv/include/asm/atomic.h
index c9e18289d65c..bffebc57357d 100644
--- a/arch/riscv/include/asm/atomic.h
+++ b/arch/riscv/include/asm/atomic.h
@@ -42,11 +42,11 @@ static __always_inline void atomic_set(atomic_t *v, int i)
 
 #ifndef CONFIG_GENERIC_ATOMIC64
 #define ATOMIC64_INIT(i) { (i) }
-static __always_inline long atomic64_read(const atomic64_t *v)
+static __always_inline s64 atomic64_read(const atomic64_t *v)
 {
 	return READ_ONCE(v->counter);
 }
-static __always_inline void atomic64_set(atomic64_t *v, long i)
+static __always_inline void atomic64_set(atomic64_t *v, s64 i)
 {
 	WRITE_ONCE(v->counter, i);
 }
@@ -70,11 +70,11 @@ void atomic##prefix##_##op(c_type i, atomic##prefix##_t *v)		\
 
 #ifdef CONFIG_GENERIC_ATOMIC64
 #define ATOMIC_OPS(op, asm_op, I)					\
-        ATOMIC_OP (op, asm_op, I, w,  int,   )
+        ATOMIC_OP (op, asm_op, I, w, int,   )
 #else
 #define ATOMIC_OPS(op, asm_op, I)					\
-        ATOMIC_OP (op, asm_op, I, w,  int,   )				\
-        ATOMIC_OP (op, asm_op, I, d, long, 64)
+        ATOMIC_OP (op, asm_op, I, w, int,   )				\
+        ATOMIC_OP (op, asm_op, I, d, s64, 64)
 #endif
 
 ATOMIC_OPS(add, add,  i)
@@ -131,14 +131,14 @@ c_type atomic##prefix##_##op##_return(c_type i, atomic##prefix##_t *v)	\
 
 #ifdef CONFIG_GENERIC_ATOMIC64
 #define ATOMIC_OPS(op, asm_op, c_op, I)					\
-        ATOMIC_FETCH_OP( op, asm_op,       I, w,  int,   )		\
-        ATOMIC_OP_RETURN(op, asm_op, c_op, I, w,  int,   )
+        ATOMIC_FETCH_OP( op, asm_op,       I, w, int,   )		\
+        ATOMIC_OP_RETURN(op, asm_op, c_op, I, w, int,   )
 #else
 #define ATOMIC_OPS(op, asm_op, c_op, I)					\
-        ATOMIC_FETCH_OP( op, asm_op,       I, w,  int,   )		\
-        ATOMIC_OP_RETURN(op, asm_op, c_op, I, w,  int,   )		\
-        ATOMIC_FETCH_OP( op, asm_op,       I, d, long, 64)		\
-        ATOMIC_OP_RETURN(op, asm_op, c_op, I, d, long, 64)
+        ATOMIC_FETCH_OP( op, asm_op,       I, w, int,   )		\
+        ATOMIC_OP_RETURN(op, asm_op, c_op, I, w, int,   )		\
+        ATOMIC_FETCH_OP( op, asm_op,       I, d, s64, 64)		\
+        ATOMIC_OP_RETURN(op, asm_op, c_op, I, d, s64, 64)
 #endif
 
 ATOMIC_OPS(add, add, +,  i)
@@ -170,11 +170,11 @@ ATOMIC_OPS(sub, add, +, -i)
 
 #ifdef CONFIG_GENERIC_ATOMIC64
 #define ATOMIC_OPS(op, asm_op, I)					\
-        ATOMIC_FETCH_OP(op, asm_op, I, w,  int,   )
+        ATOMIC_FETCH_OP(op, asm_op, I, w, int,   )
 #else
 #define ATOMIC_OPS(op, asm_op, I)					\
-        ATOMIC_FETCH_OP(op, asm_op, I, w,  int,   )			\
-        ATOMIC_FETCH_OP(op, asm_op, I, d, long, 64)
+        ATOMIC_FETCH_OP(op, asm_op, I, w, int,   )			\
+        ATOMIC_FETCH_OP(op, asm_op, I, d, s64, 64)
 #endif
 
 ATOMIC_OPS(and, and, i)
@@ -223,9 +223,10 @@ static __always_inline int atomic_fetch_add_unless(atomic_t *v, int a, int u)
 #define atomic_fetch_add_unless atomic_fetch_add_unless
 
 #ifndef CONFIG_GENERIC_ATOMIC64
-static __always_inline long atomic64_fetch_add_unless(atomic64_t *v, long a, long u)
+static __always_inline s64 atomic64_fetch_add_unless(atomic64_t *v, s64 a, s64 u)
 {
-       long prev, rc;
+       s64 prev;
+       long rc;
 
 	__asm__ __volatile__ (
 		"0:	lr.d     %[p],  %[c]\n"
@@ -294,11 +295,11 @@ c_t atomic##prefix##_cmpxchg(atomic##prefix##_t *v, c_t o, c_t n)	\
 
 #ifdef CONFIG_GENERIC_ATOMIC64
 #define ATOMIC_OPS()							\
-	ATOMIC_OP( int,   , 4)
+	ATOMIC_OP(int,   , 4)
 #else
 #define ATOMIC_OPS()							\
-	ATOMIC_OP( int,   , 4)						\
-	ATOMIC_OP(long, 64, 8)
+	ATOMIC_OP(int,   , 4)						\
+	ATOMIC_OP(s64, 64, 8)
 #endif
 
 ATOMIC_OPS()
@@ -336,9 +337,10 @@ static __always_inline int atomic_sub_if_positive(atomic_t *v, int offset)
 #define atomic_dec_if_positive(v)	atomic_sub_if_positive(v, 1)
 
 #ifndef CONFIG_GENERIC_ATOMIC64
-static __always_inline long atomic64_sub_if_positive(atomic64_t *v, long offset)
+static __always_inline s64 atomic64_sub_if_positive(atomic64_t *v, s64 offset)
 {
-       long prev, rc;
+       s64 prev;
+       long rc;
 
 	__asm__ __volatile__ (
 		"0:	lr.d     %[p],  %[c]\n"
-- 
2.11.0

