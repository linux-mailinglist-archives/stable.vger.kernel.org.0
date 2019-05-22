Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB4B26498
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfEVNYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:24:43 -0400
Received: from foss.arm.com ([217.140.101.70]:50872 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729059AbfEVNYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:24:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDE5880D;
        Wed, 22 May 2019 06:24:42 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7C2A83F575;
        Wed, 22 May 2019 06:24:38 -0700 (PDT)
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
Subject: [PATCH 08/18] locking/atomic: ia64: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:40 +0100
Message-Id: <20190522132250.26499-9-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As a step towards making the atomic64 API use consistent types treewide,
let's have the ia64 atomic64 implementation use s64 as the underlying
type for atomic64_t, rather than long or __s64, matching the generated
headers.

As atomic64_read() depends on the generic defintion of atomic64_t, this
still returns long. This will be converted in a subsequent patch.

Otherwise, there should be no functional change as a result of this
patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/ia64/include/asm/atomic.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 206530d0751b..50440f3ddc43 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -124,10 +124,10 @@ ATOMIC_FETCH_OP(xor, ^)
 #undef ATOMIC_OP
 
 #define ATOMIC64_OP(op, c_op)						\
-static __inline__ long							\
-ia64_atomic64_##op (__s64 i, atomic64_t *v)				\
+static __inline__ s64							\
+ia64_atomic64_##op (s64 i, atomic64_t *v)				\
 {									\
-	__s64 old, new;							\
+	s64 old, new;							\
 	CMPXCHG_BUGCHECK_DECL						\
 									\
 	do {								\
@@ -139,10 +139,10 @@ ia64_atomic64_##op (__s64 i, atomic64_t *v)				\
 }
 
 #define ATOMIC64_FETCH_OP(op, c_op)					\
-static __inline__ long							\
-ia64_atomic64_fetch_##op (__s64 i, atomic64_t *v)			\
+static __inline__ s64							\
+ia64_atomic64_fetch_##op (s64 i, atomic64_t *v)				\
 {									\
-	__s64 old, new;							\
+	s64 old, new;							\
 	CMPXCHG_BUGCHECK_DECL						\
 									\
 	do {								\
@@ -162,7 +162,7 @@ ATOMIC64_OPS(sub, -)
 
 #define atomic64_add_return(i,v)					\
 ({									\
-	long __ia64_aar_i = (i);					\
+	s64 __ia64_aar_i = (i);						\
 	__ia64_atomic_const(i)						\
 		? ia64_fetch_and_add(__ia64_aar_i, &(v)->counter)	\
 		: ia64_atomic64_add(__ia64_aar_i, v);			\
@@ -170,7 +170,7 @@ ATOMIC64_OPS(sub, -)
 
 #define atomic64_sub_return(i,v)					\
 ({									\
-	long __ia64_asr_i = (i);					\
+	s64 __ia64_asr_i = (i);						\
 	__ia64_atomic_const(i)						\
 		? ia64_fetch_and_add(-__ia64_asr_i, &(v)->counter)	\
 		: ia64_atomic64_sub(__ia64_asr_i, v);			\
@@ -178,7 +178,7 @@ ATOMIC64_OPS(sub, -)
 
 #define atomic64_fetch_add(i,v)						\
 ({									\
-	long __ia64_aar_i = (i);					\
+	s64 __ia64_aar_i = (i);						\
 	__ia64_atomic_const(i)						\
 		? ia64_fetchadd(__ia64_aar_i, &(v)->counter, acq)	\
 		: ia64_atomic64_fetch_add(__ia64_aar_i, v);		\
@@ -186,7 +186,7 @@ ATOMIC64_OPS(sub, -)
 
 #define atomic64_fetch_sub(i,v)						\
 ({									\
-	long __ia64_asr_i = (i);					\
+	s64 __ia64_asr_i = (i);						\
 	__ia64_atomic_const(i)						\
 		? ia64_fetchadd(-__ia64_asr_i, &(v)->counter, acq)	\
 		: ia64_atomic64_fetch_sub(__ia64_asr_i, v);		\
-- 
2.11.0

