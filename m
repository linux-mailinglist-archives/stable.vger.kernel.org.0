Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2878264A0
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbfEVNZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:25:03 -0400
Received: from foss.arm.com ([217.140.101.70]:51026 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729324AbfEVNZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:25:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC72715AB;
        Wed, 22 May 2019 06:25:02 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A32BB3F575;
        Wed, 22 May 2019 06:24:58 -0700 (PDT)
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
Subject: [PATCH 11/18] locking/atomic: riscv: fix atomic64_sub_if_positive() offset argument
Date:   Wed, 22 May 2019 14:22:43 +0100
Message-Id: <20190522132250.26499-12-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Presently the riscv implementation of atomic64_sub_if_positive() takes
a 32-bit offset value rather than a 64-bit offset value as it should do.
Thus, if called with a 64-bit offset, the value will be unexpectedly
truncated to 32 bits.

Fix this by taking the offset as a long rather than an int.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Palmer Dabbelt <palmer@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: stable@vger.kernel.org
---
 arch/riscv/include/asm/atomic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/atomic.h b/arch/riscv/include/asm/atomic.h
index 93826771b616..c9e18289d65c 100644
--- a/arch/riscv/include/asm/atomic.h
+++ b/arch/riscv/include/asm/atomic.h
@@ -336,7 +336,7 @@ static __always_inline int atomic_sub_if_positive(atomic_t *v, int offset)
 #define atomic_dec_if_positive(v)	atomic_sub_if_positive(v, 1)
 
 #ifndef CONFIG_GENERIC_ATOMIC64
-static __always_inline long atomic64_sub_if_positive(atomic64_t *v, int offset)
+static __always_inline long atomic64_sub_if_positive(atomic64_t *v, long offset)
 {
        long prev, rc;
 
-- 
2.11.0

