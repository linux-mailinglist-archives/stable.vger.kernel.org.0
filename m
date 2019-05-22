Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BDF264A4
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfEVNZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:25:18 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:51132 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbfEVNZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:25:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CEE3015AB;
        Wed, 22 May 2019 06:25:17 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8DB443F575;
        Wed, 22 May 2019 06:25:13 -0700 (PDT)
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
Subject: [PATCH 13/18] locking/atomic: s390: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:45 +0100
Message-Id: <20190522132250.26499-14-mark.rutland@arm.com>
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
still returns long. This will be converted in a subsequent patch.

The s390-internal __atomic64_*() ops are also used by the s390 bitops,
and expect pointers to long. Since atomic64_t::counter will be converted
to s64 in a subsequent patch, pointes to this are explicitly cast to
pointers to long when passed to __atomic64_*() ops.

Otherwise, there should be no functional change as a result of this
patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/s390/include/asm/atomic.h | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index fd20ab5d4cf7..491ad53a0d4e 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -84,9 +84,9 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 
 #define ATOMIC64_INIT(i)  { (i) }
 
-static inline long atomic64_read(const atomic64_t *v)
+static inline s64 atomic64_read(const atomic64_t *v)
 {
-	long c;
+	s64 c;
 
 	asm volatile(
 		"	lg	%0,%1\n"
@@ -94,49 +94,49 @@ static inline long atomic64_read(const atomic64_t *v)
 	return c;
 }
 
-static inline void atomic64_set(atomic64_t *v, long i)
+static inline void atomic64_set(atomic64_t *v, s64 i)
 {
 	asm volatile(
 		"	stg	%1,%0\n"
 		: "=Q" (v->counter) : "d" (i));
 }
 
-static inline long atomic64_add_return(long i, atomic64_t *v)
+static inline s64 atomic64_add_return(s64 i, atomic64_t *v)
 {
-	return __atomic64_add_barrier(i, &v->counter) + i;
+	return __atomic64_add_barrier(i, (long *)&v->counter) + i;
 }
 
-static inline long atomic64_fetch_add(long i, atomic64_t *v)
+static inline s64 atomic64_fetch_add(s64 i, atomic64_t *v)
 {
-	return __atomic64_add_barrier(i, &v->counter);
+	return __atomic64_add_barrier(i, (long *)&v->counter);
 }
 
-static inline void atomic64_add(long i, atomic64_t *v)
+static inline void atomic64_add(s64 i, atomic64_t *v)
 {
 #ifdef CONFIG_HAVE_MARCH_Z196_FEATURES
 	if (__builtin_constant_p(i) && (i > -129) && (i < 128)) {
-		__atomic64_add_const(i, &v->counter);
+		__atomic64_add_const(i, (long *)&v->counter);
 		return;
 	}
 #endif
-	__atomic64_add(i, &v->counter);
+	__atomic64_add(i, (long *)&v->counter);
 }
 
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
-static inline long atomic64_cmpxchg(atomic64_t *v, long old, long new)
+static inline s64 atomic64_cmpxchg(atomic64_t *v, s64 old, s64 new)
 {
-	return __atomic64_cmpxchg(&v->counter, old, new);
+	return __atomic64_cmpxchg((long *)&v->counter, old, new);
 }
 
 #define ATOMIC64_OPS(op)						\
-static inline void atomic64_##op(long i, atomic64_t *v)			\
+static inline void atomic64_##op(s64 i, atomic64_t *v)			\
 {									\
-	__atomic64_##op(i, &v->counter);				\
+	__atomic64_##op(i, (long *)&v->counter);			\
 }									\
-static inline long atomic64_fetch_##op(long i, atomic64_t *v)		\
+static inline long atomic64_fetch_##op(s64 i, atomic64_t *v)		\
 {									\
-	return __atomic64_##op##_barrier(i, &v->counter);		\
+	return __atomic64_##op##_barrier(i, (long *)&v->counter);	\
 }
 
 ATOMIC64_OPS(and)
@@ -145,8 +145,8 @@ ATOMIC64_OPS(xor)
 
 #undef ATOMIC64_OPS
 
-#define atomic64_sub_return(_i, _v)	atomic64_add_return(-(long)(_i), _v)
-#define atomic64_fetch_sub(_i, _v)	atomic64_fetch_add(-(long)(_i), _v)
-#define atomic64_sub(_i, _v)		atomic64_add(-(long)(_i), _v)
+#define atomic64_sub_return(_i, _v)	atomic64_add_return(-(s64)(_i), _v)
+#define atomic64_fetch_sub(_i, _v)	atomic64_fetch_add(-(s64)(_i), _v)
+#define atomic64_sub(_i, _v)		atomic64_add(-(s64)(_i), _v)
 
 #endif /* __ARCH_S390_ATOMIC__  */
-- 
2.11.0

