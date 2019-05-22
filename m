Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858F0264A8
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfEVNZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:25:34 -0400
Received: from foss.arm.com ([217.140.101.70]:51240 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbfEVNZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:25:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A969580D;
        Wed, 22 May 2019 06:25:32 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 688ED3F575;
        Wed, 22 May 2019 06:25:28 -0700 (PDT)
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
Subject: [PATCH 15/18] locking/atomic: x86: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:47 +0100
Message-Id: <20190522132250.26499-16-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As a step towards making the atomic64 API use consistent types treewide,
let's have the x86 atomic64 implementation use s64 as the underlying
type for atomic64_t, rather than long or long long, matching the
generated headers.

Note that the x86 arch_atomic64 implementation is already wrapped by the
generic instrumented atomic64 implementation, which uses s64
consistently.

Otherwise, there should be no functional change as a result of this
patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/x86/include/asm/atomic64_32.h | 66 ++++++++++++++++++--------------------
 arch/x86/include/asm/atomic64_64.h | 38 +++++++++++-----------
 2 files changed, 51 insertions(+), 53 deletions(-)

diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 6a5b0ec460da..52cfaecb13f9 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -9,7 +9,7 @@
 /* An 64bit atomic type */
 
 typedef struct {
-	u64 __aligned(8) counter;
+	s64 __aligned(8) counter;
 } atomic64_t;
 
 #define ATOMIC64_INIT(val)	{ (val) }
@@ -71,8 +71,7 @@ ATOMIC64_DECL(add_unless);
  * the old value.
  */
 
-static inline long long arch_atomic64_cmpxchg(atomic64_t *v, long long o,
-					      long long n)
+static inline s64 arch_atomic64_cmpxchg(atomic64_t *v, s64 o, s64 n)
 {
 	return arch_cmpxchg64(&v->counter, o, n);
 }
@@ -85,9 +84,9 @@ static inline long long arch_atomic64_cmpxchg(atomic64_t *v, long long o,
  * Atomically xchgs the value of @v to @n and returns
  * the old value.
  */
-static inline long long arch_atomic64_xchg(atomic64_t *v, long long n)
+static inline s64 arch_atomic64_xchg(atomic64_t *v, s64 n)
 {
-	long long o;
+	s64 o;
 	unsigned high = (unsigned)(n >> 32);
 	unsigned low = (unsigned)n;
 	alternative_atomic64(xchg, "=&A" (o),
@@ -103,7 +102,7 @@ static inline long long arch_atomic64_xchg(atomic64_t *v, long long n)
  *
  * Atomically sets the value of @v to @n.
  */
-static inline void arch_atomic64_set(atomic64_t *v, long long i)
+static inline void arch_atomic64_set(atomic64_t *v, s64 i)
 {
 	unsigned high = (unsigned)(i >> 32);
 	unsigned low = (unsigned)i;
@@ -118,9 +117,9 @@ static inline void arch_atomic64_set(atomic64_t *v, long long i)
  *
  * Atomically reads the value of @v and returns it.
  */
-static inline long long arch_atomic64_read(const atomic64_t *v)
+static inline s64 arch_atomic64_read(const atomic64_t *v)
 {
-	long long r;
+	s64 r;
 	alternative_atomic64(read, "=&A" (r), "c" (v) : "memory");
 	return r;
 }
@@ -132,7 +131,7 @@ static inline long long arch_atomic64_read(const atomic64_t *v)
  *
  * Atomically adds @i to @v and returns @i + *@v
  */
-static inline long long arch_atomic64_add_return(long long i, atomic64_t *v)
+static inline s64 arch_atomic64_add_return(s64 i, atomic64_t *v)
 {
 	alternative_atomic64(add_return,
 			     ASM_OUTPUT2("+A" (i), "+c" (v)),
@@ -143,7 +142,7 @@ static inline long long arch_atomic64_add_return(long long i, atomic64_t *v)
 /*
  * Other variants with different arithmetic operators:
  */
-static inline long long arch_atomic64_sub_return(long long i, atomic64_t *v)
+static inline s64 arch_atomic64_sub_return(s64 i, atomic64_t *v)
 {
 	alternative_atomic64(sub_return,
 			     ASM_OUTPUT2("+A" (i), "+c" (v)),
@@ -151,18 +150,18 @@ static inline long long arch_atomic64_sub_return(long long i, atomic64_t *v)
 	return i;
 }
 
-static inline long long arch_atomic64_inc_return(atomic64_t *v)
+static inline s64 arch_atomic64_inc_return(atomic64_t *v)
 {
-	long long a;
+	s64 a;
 	alternative_atomic64(inc_return, "=&A" (a),
 			     "S" (v) : "memory", "ecx");
 	return a;
 }
 #define arch_atomic64_inc_return arch_atomic64_inc_return
 
-static inline long long arch_atomic64_dec_return(atomic64_t *v)
+static inline s64 arch_atomic64_dec_return(atomic64_t *v)
 {
-	long long a;
+	s64 a;
 	alternative_atomic64(dec_return, "=&A" (a),
 			     "S" (v) : "memory", "ecx");
 	return a;
@@ -176,7 +175,7 @@ static inline long long arch_atomic64_dec_return(atomic64_t *v)
  *
  * Atomically adds @i to @v.
  */
-static inline long long arch_atomic64_add(long long i, atomic64_t *v)
+static inline s64 arch_atomic64_add(s64 i, atomic64_t *v)
 {
 	__alternative_atomic64(add, add_return,
 			       ASM_OUTPUT2("+A" (i), "+c" (v)),
@@ -191,7 +190,7 @@ static inline long long arch_atomic64_add(long long i, atomic64_t *v)
  *
  * Atomically subtracts @i from @v.
  */
-static inline long long arch_atomic64_sub(long long i, atomic64_t *v)
+static inline s64 arch_atomic64_sub(s64 i, atomic64_t *v)
 {
 	__alternative_atomic64(sub, sub_return,
 			       ASM_OUTPUT2("+A" (i), "+c" (v)),
@@ -234,8 +233,7 @@ static inline void arch_atomic64_dec(atomic64_t *v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if the add was done, zero otherwise.
  */
-static inline int arch_atomic64_add_unless(atomic64_t *v, long long a,
-					   long long u)
+static inline int arch_atomic64_add_unless(atomic64_t *v, s64 a, s64 u)
 {
 	unsigned low = (unsigned)u;
 	unsigned high = (unsigned)(u >> 32);
@@ -254,9 +252,9 @@ static inline int arch_atomic64_inc_not_zero(atomic64_t *v)
 }
 #define arch_atomic64_inc_not_zero arch_atomic64_inc_not_zero
 
-static inline long long arch_atomic64_dec_if_positive(atomic64_t *v)
+static inline s64 arch_atomic64_dec_if_positive(atomic64_t *v)
 {
-	long long r;
+	s64 r;
 	alternative_atomic64(dec_if_positive, "=&A" (r),
 			     "S" (v) : "ecx", "memory");
 	return r;
@@ -266,17 +264,17 @@ static inline long long arch_atomic64_dec_if_positive(atomic64_t *v)
 #undef alternative_atomic64
 #undef __alternative_atomic64
 
-static inline void arch_atomic64_and(long long i, atomic64_t *v)
+static inline void arch_atomic64_and(s64 i, atomic64_t *v)
 {
-	long long old, c = 0;
+	s64 old, c = 0;
 
 	while ((old = arch_atomic64_cmpxchg(v, c, c & i)) != c)
 		c = old;
 }
 
-static inline long long arch_atomic64_fetch_and(long long i, atomic64_t *v)
+static inline s64 arch_atomic64_fetch_and(s64 i, atomic64_t *v)
 {
-	long long old, c = 0;
+	s64 old, c = 0;
 
 	while ((old = arch_atomic64_cmpxchg(v, c, c & i)) != c)
 		c = old;
@@ -284,17 +282,17 @@ static inline long long arch_atomic64_fetch_and(long long i, atomic64_t *v)
 	return old;
 }
 
-static inline void arch_atomic64_or(long long i, atomic64_t *v)
+static inline void arch_atomic64_or(s64 i, atomic64_t *v)
 {
-	long long old, c = 0;
+	s64 old, c = 0;
 
 	while ((old = arch_atomic64_cmpxchg(v, c, c | i)) != c)
 		c = old;
 }
 
-static inline long long arch_atomic64_fetch_or(long long i, atomic64_t *v)
+static inline s64 arch_atomic64_fetch_or(s64 i, atomic64_t *v)
 {
-	long long old, c = 0;
+	s64 old, c = 0;
 
 	while ((old = arch_atomic64_cmpxchg(v, c, c | i)) != c)
 		c = old;
@@ -302,17 +300,17 @@ static inline long long arch_atomic64_fetch_or(long long i, atomic64_t *v)
 	return old;
 }
 
-static inline void arch_atomic64_xor(long long i, atomic64_t *v)
+static inline void arch_atomic64_xor(s64 i, atomic64_t *v)
 {
-	long long old, c = 0;
+	s64 old, c = 0;
 
 	while ((old = arch_atomic64_cmpxchg(v, c, c ^ i)) != c)
 		c = old;
 }
 
-static inline long long arch_atomic64_fetch_xor(long long i, atomic64_t *v)
+static inline s64 arch_atomic64_fetch_xor(s64 i, atomic64_t *v)
 {
-	long long old, c = 0;
+	s64 old, c = 0;
 
 	while ((old = arch_atomic64_cmpxchg(v, c, c ^ i)) != c)
 		c = old;
@@ -320,9 +318,9 @@ static inline long long arch_atomic64_fetch_xor(long long i, atomic64_t *v)
 	return old;
 }
 
-static inline long long arch_atomic64_fetch_add(long long i, atomic64_t *v)
+static inline s64 arch_atomic64_fetch_add(s64 i, atomic64_t *v)
 {
-	long long old, c = 0;
+	s64 old, c = 0;
 
 	while ((old = arch_atomic64_cmpxchg(v, c, c + i)) != c)
 		c = old;
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
index dadc20adba21..703b7dfd45e0 100644
--- a/arch/x86/include/asm/atomic64_64.h
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -17,7 +17,7 @@
  * Atomically reads the value of @v.
  * Doesn't imply a read memory barrier.
  */
-static inline long arch_atomic64_read(const atomic64_t *v)
+static inline s64 arch_atomic64_read(const atomic64_t *v)
 {
 	return READ_ONCE((v)->counter);
 }
@@ -29,7 +29,7 @@ static inline long arch_atomic64_read(const atomic64_t *v)
  *
  * Atomically sets the value of @v to @i.
  */
-static inline void arch_atomic64_set(atomic64_t *v, long i)
+static inline void arch_atomic64_set(atomic64_t *v, s64 i)
 {
 	WRITE_ONCE(v->counter, i);
 }
@@ -41,7 +41,7 @@ static inline void arch_atomic64_set(atomic64_t *v, long i)
  *
  * Atomically adds @i to @v.
  */
-static __always_inline void arch_atomic64_add(long i, atomic64_t *v)
+static __always_inline void arch_atomic64_add(s64 i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "addq %1,%0"
 		     : "=m" (v->counter)
@@ -55,7 +55,7 @@ static __always_inline void arch_atomic64_add(long i, atomic64_t *v)
  *
  * Atomically subtracts @i from @v.
  */
-static inline void arch_atomic64_sub(long i, atomic64_t *v)
+static inline void arch_atomic64_sub(s64 i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "subq %1,%0"
 		     : "=m" (v->counter)
@@ -71,7 +71,7 @@ static inline void arch_atomic64_sub(long i, atomic64_t *v)
  * true if the result is zero, or false for all
  * other cases.
  */
-static inline bool arch_atomic64_sub_and_test(long i, atomic64_t *v)
+static inline bool arch_atomic64_sub_and_test(s64 i, atomic64_t *v)
 {
 	return GEN_BINARY_RMWcc(LOCK_PREFIX "subq", v->counter, e, "er", i);
 }
@@ -142,7 +142,7 @@ static inline bool arch_atomic64_inc_and_test(atomic64_t *v)
  * if the result is negative, or false when
  * result is greater than or equal to zero.
  */
-static inline bool arch_atomic64_add_negative(long i, atomic64_t *v)
+static inline bool arch_atomic64_add_negative(s64 i, atomic64_t *v)
 {
 	return GEN_BINARY_RMWcc(LOCK_PREFIX "addq", v->counter, s, "er", i);
 }
@@ -155,43 +155,43 @@ static inline bool arch_atomic64_add_negative(long i, atomic64_t *v)
  *
  * Atomically adds @i to @v and returns @i + @v
  */
-static __always_inline long arch_atomic64_add_return(long i, atomic64_t *v)
+static __always_inline s64 arch_atomic64_add_return(s64 i, atomic64_t *v)
 {
 	return i + xadd(&v->counter, i);
 }
 
-static inline long arch_atomic64_sub_return(long i, atomic64_t *v)
+static inline s64 arch_atomic64_sub_return(s64 i, atomic64_t *v)
 {
 	return arch_atomic64_add_return(-i, v);
 }
 
-static inline long arch_atomic64_fetch_add(long i, atomic64_t *v)
+static inline s64 arch_atomic64_fetch_add(s64 i, atomic64_t *v)
 {
 	return xadd(&v->counter, i);
 }
 
-static inline long arch_atomic64_fetch_sub(long i, atomic64_t *v)
+static inline s64 arch_atomic64_fetch_sub(s64 i, atomic64_t *v)
 {
 	return xadd(&v->counter, -i);
 }
 
-static inline long arch_atomic64_cmpxchg(atomic64_t *v, long old, long new)
+static inline s64 arch_atomic64_cmpxchg(atomic64_t *v, s64 old, s64 new)
 {
 	return arch_cmpxchg(&v->counter, old, new);
 }
 
 #define arch_atomic64_try_cmpxchg arch_atomic64_try_cmpxchg
-static __always_inline bool arch_atomic64_try_cmpxchg(atomic64_t *v, s64 *old, long new)
+static __always_inline bool arch_atomic64_try_cmpxchg(atomic64_t *v, s64 *old, s64 new)
 {
 	return try_cmpxchg(&v->counter, old, new);
 }
 
-static inline long arch_atomic64_xchg(atomic64_t *v, long new)
+static inline s64 arch_atomic64_xchg(atomic64_t *v, s64 new)
 {
 	return arch_xchg(&v->counter, new);
 }
 
-static inline void arch_atomic64_and(long i, atomic64_t *v)
+static inline void arch_atomic64_and(s64 i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "andq %1,%0"
 			: "+m" (v->counter)
@@ -199,7 +199,7 @@ static inline void arch_atomic64_and(long i, atomic64_t *v)
 			: "memory");
 }
 
-static inline long arch_atomic64_fetch_and(long i, atomic64_t *v)
+static inline s64 arch_atomic64_fetch_and(s64 i, atomic64_t *v)
 {
 	s64 val = arch_atomic64_read(v);
 
@@ -208,7 +208,7 @@ static inline long arch_atomic64_fetch_and(long i, atomic64_t *v)
 	return val;
 }
 
-static inline void arch_atomic64_or(long i, atomic64_t *v)
+static inline void arch_atomic64_or(s64 i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "orq %1,%0"
 			: "+m" (v->counter)
@@ -216,7 +216,7 @@ static inline void arch_atomic64_or(long i, atomic64_t *v)
 			: "memory");
 }
 
-static inline long arch_atomic64_fetch_or(long i, atomic64_t *v)
+static inline s64 arch_atomic64_fetch_or(s64 i, atomic64_t *v)
 {
 	s64 val = arch_atomic64_read(v);
 
@@ -225,7 +225,7 @@ static inline long arch_atomic64_fetch_or(long i, atomic64_t *v)
 	return val;
 }
 
-static inline void arch_atomic64_xor(long i, atomic64_t *v)
+static inline void arch_atomic64_xor(s64 i, atomic64_t *v)
 {
 	asm volatile(LOCK_PREFIX "xorq %1,%0"
 			: "+m" (v->counter)
@@ -233,7 +233,7 @@ static inline void arch_atomic64_xor(long i, atomic64_t *v)
 			: "memory");
 }
 
-static inline long arch_atomic64_fetch_xor(long i, atomic64_t *v)
+static inline s64 arch_atomic64_fetch_xor(s64 i, atomic64_t *v)
 {
 	s64 val = arch_atomic64_read(v);
 
-- 
2.11.0

