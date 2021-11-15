Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163BD45252B
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353583AbhKPBrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:47:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240597AbhKOSQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:16:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AFE3633E6;
        Mon, 15 Nov 2021 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998618;
        bh=8NInpRxBQamurNtjFAu+O8CuNybOvIgZbgsCXWujwow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3R2jx0+fzr9xTpqpF8LgGZY7xc8gxNZh5cs5+xxPrHu+PP1VpdRRyT6qEoORCeW3
         7bHHlQO6gD8GKX91FZZybgwFkX7KSyegmYlS7OTUWgFcEuJgF62eeOu0gqY+1a8iTq
         ynXPErMly+Xz+gYaVWgxGj267EiVw4UVfjP3eOkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 542/575] MIPS: Fix assembly error from MIPSr2 code used within MIPS_ISA_ARCH_LEVEL
Date:   Mon, 15 Nov 2021 18:04:27 +0100
Message-Id: <20211115165402.431420311@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit a923a2676e60683aee46aa4b93c30aff240ac20d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/cmpxchg.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/mips/include/asm/cmpxchg.h
+++ b/arch/mips/include/asm/cmpxchg.h
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


