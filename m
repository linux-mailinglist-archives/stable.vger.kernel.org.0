Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D23AC436DCE
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 00:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhJUXAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 19:00:48 -0400
Received: from angie.orcam.me.uk ([78.133.224.34]:34286 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbhJUXAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 19:00:47 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 4427692009C; Fri, 22 Oct 2021 00:58:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 3581692009B;
        Fri, 22 Oct 2021 00:58:23 +0200 (CEST)
Date:   Fri, 22 Oct 2021 00:58:23 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] MIPS: Fix assembly error from MIPSr2 code used within
 MIPS_ISA_ARCH_LEVEL
Message-ID: <alpine.DEB.2.21.2110220001430.10706@angie.orcam.me.uk>
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

with code produced from `__cmpxchg64' for MIPS64r2 CPU configurations 
using CONFIG_32BIT and CONFIG_PHYS_ADDR_T_64BIT.

This is due to MIPS_ISA_ARCH_LEVEL downgrading the assembly architecture 
to `r4000' i.e. MIPS III for MIPS64r2 configurations, while there is a 
block of code containing a DINS MIPS64r2 instruction conditionalized on 
MIPS_ISA_REV >= 2 within the scope of the downgrade.

The assembly architecture override code pattern has been put there for 
LL/SC instructions, so that code compiles for configurations that select 
a processor to build for that does not support these instructions while 
still providing run-time support for processors that do, dynamically 
switched by non-constant `cpu_has_llsc'.  It went in with linux-mips.org 
commit aac8aa7717a2 ("Enable a suitable ISA for the assembler around 
ll/sc so that code builds even for processors that don't support the 
instructions. Plus minor formatting fixes.") back in 2005.

Fix the problem by wrapping these instructions along with the adjacent 
SYNC instructions only, following the practice established with commit 
cfd54de3b0e4 ("MIPS: Avoid move psuedo-instruction whilst using 
MIPS_ISA_LEVEL") and commit 378ed6f0e3c5 ("MIPS: Avoid using .set mips0 
to restore ISA").  Strictly speaking the SYNC instructions do not have 
to be wrapped as they are only used as a Loongson3 erratum workaround, 
so they will be enabled in the assembler by default, but do this so as 
to keep code consistent with other places.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: c7e2d71dda7a ("MIPS: Fix set_pte() for Netlogic XLR using cmpxchg64()")
Cc: stable@vger.kernel.org # v5.1+
---
So it's turned out I was right after all with v1, just did not correctly 
remember the reason for the arrangement with an ISA override around LL/SC, 
actually made by myself back in 2005.  Therefore here is a minor update to 
v1 only, which was actually right except for a cosmetic issue around SYNC.

And as I have thought major decluttering is due here.  What seemed a good 
idea back in 2005 has never materialised and I think we don't really want 
to support dynamic `cpu_has_llsc' anymore in 2021.  But let's leave it for 
another occasion and fix the build error at hand only.

Changes from v1:

- Keep __SYNC references under MIPS_ISA_ARCH_LEVEL.

- Expand change description.
---
 arch/mips/include/asm/cmpxchg.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

linux-mips-cmpxchg64-isa-arch-level.diff
Index: linux-test/arch/mips/include/asm/cmpxchg.h
===================================================================
--- linux-test.orig/arch/mips/include/asm/cmpxchg.h
+++ linux-test/arch/mips/include/asm/cmpxchg.h
@@ -249,6 +249,7 @@ static inline unsigned long __cmpxchg64(
 	/* Load 64 bits from ptr */
 	"	" __SYNC(full, loongson3_war) "		\n"
 	"1:	lld	%L0, %3		# __cmpxchg64	\n"
+	"	.set	pop				\n"
 	/*
 	 * Split the 64 bit value we loaded into the 2 registers that hold the
 	 * ret variable.
@@ -276,12 +277,14 @@ static inline unsigned long __cmpxchg64(
 	"	or	%L1, %L1, $at			\n"
 	"	.set	at				\n"
 #  endif
+	"	.set	push				\n"
+	"	.set	" MIPS_ISA_ARCH_LEVEL "		\n"
 	/* Attempt to store new at ptr */
 	"	scd	%L1, %2				\n"
 	/* If we failed, loop! */
 	"\t" __SC_BEQZ "%L1, 1b				\n"
-	"	.set	pop				\n"
 	"2:	" __SYNC(full, loongson3_war) "		\n"
+	"	.set	pop				\n"
 	: "=&r"(ret),
 	  "=&r"(tmp),
 	  "=" GCC_OFF_SMALL_ASM() (*(unsigned long long *)ptr)
