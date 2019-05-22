Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E035E2648B
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbfEVNX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:23:58 -0400
Received: from foss.arm.com ([217.140.101.70]:50610 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728912AbfEVNX5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:23:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4042415AB;
        Wed, 22 May 2019 06:23:57 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 012153F575;
        Wed, 22 May 2019 06:23:52 -0700 (PDT)
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
Subject: [PATCH 03/18] locking/atomic: generic: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:35 +0100
Message-Id: <20190522132250.26499-4-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As a step towards making the atomic64 API use consistent types treewide,
let's have the generic atomic64 implementation use s64 as the underlying
type for atomic64_t, rather than long long, matching the generated
headers.

Otherwise, there should be no functional change as a result of this
patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 include/asm-generic/atomic64.h | 20 ++++++++++----------
 lib/atomic64.c                 | 32 ++++++++++++++++----------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/asm-generic/atomic64.h b/include/asm-generic/atomic64.h
index 97b28b7f1f29..fc7b831ed632 100644
--- a/include/asm-generic/atomic64.h
+++ b/include/asm-generic/atomic64.h
@@ -14,24 +14,24 @@
 #include <linux/types.h>
 
 typedef struct {
-	long long counter;
+	s64 counter;
 } atomic64_t;
 
 #define ATOMIC64_INIT(i)	{ (i) }
 
-extern long long atomic64_read(const atomic64_t *v);
-extern void	 atomic64_set(atomic64_t *v, long long i);
+extern s64 atomic64_read(const atomic64_t *v);
+extern void atomic64_set(atomic64_t *v, s64 i);
 
 #define atomic64_set_release(v, i)	atomic64_set((v), (i))
 
 #define ATOMIC64_OP(op)							\
-extern void	 atomic64_##op(long long a, atomic64_t *v);
+extern void	 atomic64_##op(s64 a, atomic64_t *v);
 
 #define ATOMIC64_OP_RETURN(op)						\
-extern long long atomic64_##op##_return(long long a, atomic64_t *v);
+extern s64 atomic64_##op##_return(s64 a, atomic64_t *v);
 
 #define ATOMIC64_FETCH_OP(op)						\
-extern long long atomic64_fetch_##op(long long a, atomic64_t *v);
+extern s64 atomic64_fetch_##op(s64 a, atomic64_t *v);
 
 #define ATOMIC64_OPS(op)	ATOMIC64_OP(op) ATOMIC64_OP_RETURN(op) ATOMIC64_FETCH_OP(op)
 
@@ -50,11 +50,11 @@ ATOMIC64_OPS(xor)
 #undef ATOMIC64_OP_RETURN
 #undef ATOMIC64_OP
 
-extern long long atomic64_dec_if_positive(atomic64_t *v);
+extern s64 atomic64_dec_if_positive(atomic64_t *v);
 #define atomic64_dec_if_positive atomic64_dec_if_positive
-extern long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n);
-extern long long atomic64_xchg(atomic64_t *v, long long new);
-extern long long atomic64_fetch_add_unless(atomic64_t *v, long long a, long long u);
+extern s64 atomic64_cmpxchg(atomic64_t *v, s64 o, s64 n);
+extern s64 atomic64_xchg(atomic64_t *v, s64 new);
+extern s64 atomic64_fetch_add_unless(atomic64_t *v, s64 a, s64 u);
 #define atomic64_fetch_add_unless atomic64_fetch_add_unless
 
 #endif  /*  _ASM_GENERIC_ATOMIC64_H  */
diff --git a/lib/atomic64.c b/lib/atomic64.c
index 1d91e31eceec..62f218bf50a0 100644
--- a/lib/atomic64.c
+++ b/lib/atomic64.c
@@ -46,11 +46,11 @@ static inline raw_spinlock_t *lock_addr(const atomic64_t *v)
 	return &atomic64_lock[addr & (NR_LOCKS - 1)].lock;
 }
 
-long long atomic64_read(const atomic64_t *v)
+s64 atomic64_read(const atomic64_t *v)
 {
 	unsigned long flags;
 	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
+	s64 val;
 
 	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter;
@@ -59,7 +59,7 @@ long long atomic64_read(const atomic64_t *v)
 }
 EXPORT_SYMBOL(atomic64_read);
 
-void atomic64_set(atomic64_t *v, long long i)
+void atomic64_set(atomic64_t *v, s64 i)
 {
 	unsigned long flags;
 	raw_spinlock_t *lock = lock_addr(v);
@@ -71,7 +71,7 @@ void atomic64_set(atomic64_t *v, long long i)
 EXPORT_SYMBOL(atomic64_set);
 
 #define ATOMIC64_OP(op, c_op)						\
-void atomic64_##op(long long a, atomic64_t *v)				\
+void atomic64_##op(s64 a, atomic64_t *v)				\
 {									\
 	unsigned long flags;						\
 	raw_spinlock_t *lock = lock_addr(v);				\
@@ -83,11 +83,11 @@ void atomic64_##op(long long a, atomic64_t *v)				\
 EXPORT_SYMBOL(atomic64_##op);
 
 #define ATOMIC64_OP_RETURN(op, c_op)					\
-long long atomic64_##op##_return(long long a, atomic64_t *v)		\
+s64 atomic64_##op##_return(s64 a, atomic64_t *v)			\
 {									\
 	unsigned long flags;						\
 	raw_spinlock_t *lock = lock_addr(v);				\
-	long long val;							\
+	s64 val;							\
 									\
 	raw_spin_lock_irqsave(lock, flags);				\
 	val = (v->counter c_op a);					\
@@ -97,11 +97,11 @@ long long atomic64_##op##_return(long long a, atomic64_t *v)		\
 EXPORT_SYMBOL(atomic64_##op##_return);
 
 #define ATOMIC64_FETCH_OP(op, c_op)					\
-long long atomic64_fetch_##op(long long a, atomic64_t *v)		\
+s64 atomic64_fetch_##op(s64 a, atomic64_t *v)				\
 {									\
 	unsigned long flags;						\
 	raw_spinlock_t *lock = lock_addr(v);				\
-	long long val;							\
+	s64 val;							\
 									\
 	raw_spin_lock_irqsave(lock, flags);				\
 	val = v->counter;						\
@@ -134,11 +134,11 @@ ATOMIC64_OPS(xor, ^=)
 #undef ATOMIC64_OP_RETURN
 #undef ATOMIC64_OP
 
-long long atomic64_dec_if_positive(atomic64_t *v)
+s64 atomic64_dec_if_positive(atomic64_t *v)
 {
 	unsigned long flags;
 	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
+	s64 val;
 
 	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter - 1;
@@ -149,11 +149,11 @@ long long atomic64_dec_if_positive(atomic64_t *v)
 }
 EXPORT_SYMBOL(atomic64_dec_if_positive);
 
-long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
+s64 atomic64_cmpxchg(atomic64_t *v, s64 o, s64 n)
 {
 	unsigned long flags;
 	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
+	s64 val;
 
 	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter;
@@ -164,11 +164,11 @@ long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n)
 }
 EXPORT_SYMBOL(atomic64_cmpxchg);
 
-long long atomic64_xchg(atomic64_t *v, long long new)
+s64 atomic64_xchg(atomic64_t *v, s64 new)
 {
 	unsigned long flags;
 	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
+	s64 val;
 
 	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter;
@@ -178,11 +178,11 @@ long long atomic64_xchg(atomic64_t *v, long long new)
 }
 EXPORT_SYMBOL(atomic64_xchg);
 
-long long atomic64_fetch_add_unless(atomic64_t *v, long long a, long long u)
+s64 atomic64_fetch_add_unless(atomic64_t *v, s64 a, s64 u)
 {
 	unsigned long flags;
 	raw_spinlock_t *lock = lock_addr(v);
-	long long val;
+	s64 val;
 
 	raw_spin_lock_irqsave(lock, flags);
 	val = v->counter;
-- 
2.11.0

