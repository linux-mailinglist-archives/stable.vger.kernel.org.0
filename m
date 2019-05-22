Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A552648D
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbfEVNYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:24:06 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:50656 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728912AbfEVNYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:24:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14A5C80D;
        Wed, 22 May 2019 06:24:05 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C6BBE3F575;
        Wed, 22 May 2019 06:24:00 -0700 (PDT)
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
Subject: [PATCH 04/18] locking/atomic: alpha: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:36 +0100
Message-Id: <20190522132250.26499-5-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As a step towards making the atomic64 API use consistent types treewide,
let's have the alpha atomic64 implementation use s64 as the underlying
type for atomic64_t, rather than long, matching the generated headers.

As atomic64_read() depends on the generic defintion of atomic64_t, this
still returns long. This will be converted in a subsequent patch.

Otherwise, there should be no functional change as a result of this
patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/alpha/include/asm/atomic.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index 150a1c5d6a2c..2144530d1428 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -93,9 +93,9 @@ static inline int atomic_fetch_##op##_relaxed(int i, atomic_t *v)	\
 }
 
 #define ATOMIC64_OP(op, asm_op)						\
-static __inline__ void atomic64_##op(long i, atomic64_t * v)		\
+static __inline__ void atomic64_##op(s64 i, atomic64_t * v)		\
 {									\
-	unsigned long temp;						\
+	s64 temp;							\
 	__asm__ __volatile__(						\
 	"1:	ldq_l %0,%1\n"						\
 	"	" #asm_op " %0,%2,%0\n"					\
@@ -109,9 +109,9 @@ static __inline__ void atomic64_##op(long i, atomic64_t * v)		\
 }									\
 
 #define ATOMIC64_OP_RETURN(op, asm_op)					\
-static __inline__ long atomic64_##op##_return_relaxed(long i, atomic64_t * v)	\
+static __inline__ s64 atomic64_##op##_return_relaxed(s64 i, atomic64_t * v)	\
 {									\
-	long temp, result;						\
+	s64 temp, result;						\
 	__asm__ __volatile__(						\
 	"1:	ldq_l %0,%1\n"						\
 	"	" #asm_op " %0,%3,%2\n"					\
@@ -128,9 +128,9 @@ static __inline__ long atomic64_##op##_return_relaxed(long i, atomic64_t * v)	\
 }
 
 #define ATOMIC64_FETCH_OP(op, asm_op)					\
-static __inline__ long atomic64_fetch_##op##_relaxed(long i, atomic64_t * v)	\
+static __inline__ s64 atomic64_fetch_##op##_relaxed(s64 i, atomic64_t * v)	\
 {									\
-	long temp, result;						\
+	s64 temp, result;						\
 	__asm__ __volatile__(						\
 	"1:	ldq_l %2,%1\n"						\
 	"	" #asm_op " %2,%3,%0\n"					\
@@ -246,9 +246,9 @@ static __inline__ int atomic_fetch_add_unless(atomic_t *v, int a, int u)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns the old value of @v.
  */
-static __inline__ long atomic64_fetch_add_unless(atomic64_t *v, long a, long u)
+static __inline__ s64 atomic64_fetch_add_unless(atomic64_t *v, s64 a, s64 u)
 {
-	long c, new, old;
+	s64 c, new, old;
 	smp_mb();
 	__asm__ __volatile__(
 	"1:	ldq_l	%[old],%[mem]\n"
@@ -276,9 +276,9 @@ static __inline__ long atomic64_fetch_add_unless(atomic64_t *v, long a, long u)
  * The function returns the old value of *v minus 1, even if
  * the atomic variable, v, was not decremented.
  */
-static inline long atomic64_dec_if_positive(atomic64_t *v)
+static inline s64 atomic64_dec_if_positive(atomic64_t *v)
 {
-	long old, tmp;
+	s64 old, tmp;
 	smp_mb();
 	__asm__ __volatile__(
 	"1:	ldq_l	%[old],%[mem]\n"
-- 
2.11.0

