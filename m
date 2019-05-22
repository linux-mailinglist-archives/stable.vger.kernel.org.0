Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9973A2649A
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbfEVNYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:24:49 -0400
Received: from foss.arm.com ([217.140.101.70]:50926 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729059AbfEVNYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:24:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBC0315AB;
        Wed, 22 May 2019 06:24:48 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7C1893F575;
        Wed, 22 May 2019 06:24:44 -0700 (PDT)
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
Subject: [PATCH 09/18] locking/atomic: mips: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:41 +0100
Message-Id: <20190522132250.26499-10-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As a step towards making the atomic64 API use consistent types treewide,
let's have the mips atomic64 implementation use s64 as the underlying
type for atomic64_t, rather than long or __s64, matching the generated
headers.

As atomic64_read() depends on the generic defintion of atomic64_t, this
still returns long on 64-bit. This will be converted in a subsequent
patch.

Otherwise, there should be no functional change as a result of this
patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/mips/include/asm/atomic.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 94096299fc56..9a82dd11c0e9 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -254,10 +254,10 @@ static __inline__ int atomic_sub_if_positive(int i, atomic_t * v)
 #define atomic64_set(v, i)	WRITE_ONCE((v)->counter, (i))
 
 #define ATOMIC64_OP(op, c_op, asm_op)					      \
-static __inline__ void atomic64_##op(long i, atomic64_t * v)		      \
+static __inline__ void atomic64_##op(s64 i, atomic64_t * v)		      \
 {									      \
 	if (kernel_uses_llsc) {						      \
-		long temp;						      \
+		s64 temp;						      \
 									      \
 		loongson_llsc_mb();					      \
 		__asm__ __volatile__(					      \
@@ -280,12 +280,12 @@ static __inline__ void atomic64_##op(long i, atomic64_t * v)		      \
 }
 
 #define ATOMIC64_OP_RETURN(op, c_op, asm_op)				      \
-static __inline__ long atomic64_##op##_return_relaxed(long i, atomic64_t * v) \
+static __inline__ s64 atomic64_##op##_return_relaxed(s64 i, atomic64_t * v)   \
 {									      \
-	long result;							      \
+	s64 result;							      \
 									      \
 	if (kernel_uses_llsc) {						      \
-		long temp;						      \
+		s64 temp;						      \
 									      \
 		loongson_llsc_mb();					      \
 		__asm__ __volatile__(					      \
@@ -314,12 +314,12 @@ static __inline__ long atomic64_##op##_return_relaxed(long i, atomic64_t * v) \
 }
 
 #define ATOMIC64_FETCH_OP(op, c_op, asm_op)				      \
-static __inline__ long atomic64_fetch_##op##_relaxed(long i, atomic64_t * v)  \
+static __inline__ s64 atomic64_fetch_##op##_relaxed(s64 i, atomic64_t * v)    \
 {									      \
-	long result;							      \
+	s64 result;							      \
 									      \
 	if (kernel_uses_llsc) {						      \
-		long temp;						      \
+		s64 temp;						      \
 									      \
 		loongson_llsc_mb();					      \
 		__asm__ __volatile__(					      \
@@ -386,14 +386,14 @@ ATOMIC64_OPS(xor, ^=, xor)
  * Atomically test @v and subtract @i if @v is greater or equal than @i.
  * The function returns the old value of @v minus @i.
  */
-static __inline__ long atomic64_sub_if_positive(long i, atomic64_t * v)
+static __inline__ s64 atomic64_sub_if_positive(s64 i, atomic64_t * v)
 {
-	long result;
+	s64 result;
 
 	smp_mb__before_llsc();
 
 	if (kernel_uses_llsc) {
-		long temp;
+		s64 temp;
 
 		__asm__ __volatile__(
 		"	.set	push					\n"
-- 
2.11.0

