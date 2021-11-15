Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAAD4527CD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354252AbhKPCpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241776AbhKPCnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 21:43:05 -0500
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DF54C0DEA70
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 15:23:52 -0800 (PST)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id BCD439200B4; Tue, 16 Nov 2021 00:23:50 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id B70A09200B3
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 23:23:50 +0000 (GMT)
Date:   Mon, 15 Nov 2021 23:23:50 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4] MIPS: Fix assembly error from MIPSr2 code used within
 MIPS_ISA_ARCH_LEVEL
Message-ID: <alpine.DEB.2.21.2111152316210.19625@angie.orcam.me.uk>
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
Hi,

 This is a version of commit a923a2676e60 for 5.4-stable and before (where 
the SYNC instructions mentioned in the description have not been added yet 
and hence the merge conflict).  No functional change, just a mechanical 
update.  Verified to build.  Please apply.

  Maciej
---
 arch/mips/include/asm/cmpxchg.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-5.4-test/arch/mips/include/asm/cmpxchg.h
===================================================================
--- linux-5.4-test.orig/arch/mips/include/asm/cmpxchg.h
+++ linux-5.4-test/arch/mips/include/asm/cmpxchg.h
@@ -239,6 +239,7 @@ static inline unsigned long __cmpxchg64(
 	"	.set	" MIPS_ISA_ARCH_LEVEL "		\n"
 	/* Load 64 bits from ptr */
 	"1:	lld	%L0, %3		# __cmpxchg64	\n"
+	"	.set	pop				\n"
 	/*
 	 * Split the 64 bit value we loaded into the 2 registers that hold the
 	 * ret variable.
@@ -266,6 +267,8 @@ static inline unsigned long __cmpxchg64(
 	"	or	%L1, %L1, $at			\n"
 	"	.set	at				\n"
 #  endif
+	"	.set	push				\n"
+	"	.set	" MIPS_ISA_ARCH_LEVEL "		\n"
 	/* Attempt to store new at ptr */
 	"	scd	%L1, %2				\n"
 	/* If we failed, loop! */
