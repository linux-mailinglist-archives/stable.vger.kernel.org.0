Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA7643567E
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJTX3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 19:29:15 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:34244 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhJTX3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 19:29:14 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 680DA92009C; Thu, 21 Oct 2021 01:26:57 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 5AA0E92009B;
        Thu, 21 Oct 2021 01:26:57 +0200 (CEST)
Date:   Thu, 21 Oct 2021 01:26:57 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] MIPS: Fix assembly error from MIPSr2 code used within
 MIPS_ISA_ARCH_LEVEL
Message-ID: <alpine.DEB.2.21.2110210054080.31442@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix assembly errors like:

{standard input}: Assembler messages:
{standard input}:287: Error: opcode not supported on this processor: mips3 (mips3) `dins $10,$7,32,32'
{standard input}:680: Error: opcode not supported on this processor: mips3 (mips3) `dins $10,$7,32,32'
{standard input}:1274: Error: opcode not supported on this processor: mips3 (mips3) `dins $12,$9,32,32'
{standard input}:2175: Error: opcode not supported on this processor: mips3 (mips3) `dins $10,$7,32,32'
make[1]: *** [scripts/Makefile.build:277: mm/highmem.o] Error 1

with code produced from `__cmpxchg64' for MIPS64r2 configurations.

This is due to MIPS_ISA_ARCH_LEVEL downgrading the assembly architecture 
to `r4000' for MIPS64r2 configurations while there is a block of code 
containing a DINS MIPS64r2 instruction conditionalized on MIPS_ISA_REV
>= 2 within the scope of the downgrade.

The assembly architecture override is only there for the LLD/SCD 
instructions, so fix the problem by wrapping these instructions on their 
own only, following the practice established with commit cfd54de3b0e4 
("MIPS: Avoid move psuedo-instruction whilst using MIPS_ISA_LEVEL") and 
commit 378ed6f0e3c5 ("MIPS: Avoid using .set mips0 to restore ISA").

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: c7e2d71dda7a ("MIPS: Fix set_pte() for Netlogic XLR using cmpxchg64()")
Cc: stable@vger.kernel.org # v5.1+
---
 arch/mips/include/asm/cmpxchg.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

linux-mips-cmpxchg64-isa-arch-level.diff
Index: linux-test/arch/mips/include/asm/cmpxchg.h
===================================================================
--- linux-test.orig/arch/mips/include/asm/cmpxchg.h
+++ linux-test/arch/mips/include/asm/cmpxchg.h
@@ -244,11 +244,12 @@ static inline unsigned long __cmpxchg64(
 	local_irq_save(flags);
 
 	asm volatile(
+	"	" __SYNC(full, loongson3_war) "		\n"
 	"	.set	push				\n"
 	"	.set	" MIPS_ISA_ARCH_LEVEL "		\n"
 	/* Load 64 bits from ptr */
-	"	" __SYNC(full, loongson3_war) "		\n"
 	"1:	lld	%L0, %3		# __cmpxchg64	\n"
+	"	.set	pop				\n"
 	/*
 	 * Split the 64 bit value we loaded into the 2 registers that hold the
 	 * ret variable.
@@ -276,11 +277,13 @@ static inline unsigned long __cmpxchg64(
 	"	or	%L1, %L1, $at			\n"
 	"	.set	at				\n"
 #  endif
+	"	.set	push				\n"
+	"	.set	" MIPS_ISA_ARCH_LEVEL "		\n"
 	/* Attempt to store new at ptr */
 	"	scd	%L1, %2				\n"
+	"	.set	pop				\n"
 	/* If we failed, loop! */
 	"\t" __SC_BEQZ "%L1, 1b				\n"
-	"	.set	pop				\n"
 	"2:	" __SYNC(full, loongson3_war) "		\n"
 	: "=&r"(ret),
 	  "=&r"(tmp),
