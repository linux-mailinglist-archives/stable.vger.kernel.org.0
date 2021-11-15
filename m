Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83435450494
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 13:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhKOMn3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 07:43:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231375AbhKOMnR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 07:43:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B917960FC2;
        Mon, 15 Nov 2021 12:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636980022;
        bh=whJicKlKh+b+Abe9QWNgLzsi1gLiFxZtYxmb5I4cOwk=;
        h=Subject:To:Cc:From:Date:From;
        b=SDLl+QOSlzGHvHM6obJKaxj59PXWE5BIiScby9j6D1aSnFLNCeXjE1SoxtMeNvT3O
         PH3B+dUwy9z2vDHls7+YRk/E1Na6Gr0ljSvxbQKb/fQ1eLEGSJLbfYheCp1f7jHjTV
         pQ5GnHE+2YRZlnwzeXpfl8ZSRJWs3yen1Wu9VIzU=
Subject: FAILED: patch "[PATCH] MIPS: Fix assembly error from MIPSr2 code used within" failed to apply to 5.4-stable tree
To:     macro@orcam.me.uk, lkp@intel.com, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 13:40:19 +0100
Message-ID: <1636980019254191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a923a2676e60683aee46aa4b93c30aff240ac20d Mon Sep 17 00:00:00 2001
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
Date: Fri, 22 Oct 2021 00:58:23 +0200
Subject: [PATCH] MIPS: Fix assembly error from MIPSr2 code used within
 MIPS_ISA_ARCH_LEVEL

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
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

diff --git a/arch/mips/include/asm/cmpxchg.h b/arch/mips/include/asm/cmpxchg.h
index 0b983800f48b..66a8b293fd80 100644
--- a/arch/mips/include/asm/cmpxchg.h
+++ b/arch/mips/include/asm/cmpxchg.h
@@ -249,6 +249,7 @@ static inline unsigned long __cmpxchg64(volatile void *ptr,
 	/* Load 64 bits from ptr */
 	"	" __SYNC(full, loongson3_war) "		\n"
 	"1:	lld	%L0, %3		# __cmpxchg64	\n"
+	"	.set	pop				\n"
 	/*
 	 * Split the 64 bit value we loaded into the 2 registers that hold the
 	 * ret variable.
@@ -276,12 +277,14 @@ static inline unsigned long __cmpxchg64(volatile void *ptr,
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

