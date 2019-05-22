Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2E9264A6
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbfEVNZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:25:25 -0400
Received: from foss.arm.com ([217.140.101.70]:51180 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbfEVNZY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:25:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D0AF15BF;
        Wed, 22 May 2019 06:25:24 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F345D3F575;
        Wed, 22 May 2019 06:25:19 -0700 (PDT)
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
Subject: [PATCH 14/18] locking/atomic: sparc: use s64 for atomic64
Date:   Wed, 22 May 2019 14:22:46 +0100
Message-Id: <20190522132250.26499-15-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As a step towards making the atomic64 API use consistent types treewide,
let's have the sparc atomic64 implementation use s64 as the underlying
type for atomic64_t, rather than long, matching the generated headers.

As atomic64_read() depends on the generic defintion of atomic64_t, this
still returns long. This will be converted in a subsequent patch.

Otherwise, there should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/sparc/include/asm/atomic_64.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index 6963482c81d8..b60448397d4f 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -23,15 +23,15 @@
 
 #define ATOMIC_OP(op)							\
 void atomic_##op(int, atomic_t *);					\
-void atomic64_##op(long, atomic64_t *);
+void atomic64_##op(s64, atomic64_t *);
 
 #define ATOMIC_OP_RETURN(op)						\
 int atomic_##op##_return(int, atomic_t *);				\
-long atomic64_##op##_return(long, atomic64_t *);
+s64 atomic64_##op##_return(s64, atomic64_t *);
 
 #define ATOMIC_FETCH_OP(op)						\
 int atomic_fetch_##op(int, atomic_t *);					\
-long atomic64_fetch_##op(long, atomic64_t *);
+s64 atomic64_fetch_##op(s64, atomic64_t *);
 
 #define ATOMIC_OPS(op) ATOMIC_OP(op) ATOMIC_OP_RETURN(op) ATOMIC_FETCH_OP(op)
 
@@ -61,7 +61,7 @@ static inline int atomic_xchg(atomic_t *v, int new)
 	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
-long atomic64_dec_if_positive(atomic64_t *v);
+s64 atomic64_dec_if_positive(atomic64_t *v);
 #define atomic64_dec_if_positive atomic64_dec_if_positive
 
 #endif /* !(__ARCH_SPARC64_ATOMIC__) */
-- 
2.11.0

