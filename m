Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4098F2E640A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404637AbgL1PqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404621AbgL1Noj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:44:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C587C20731;
        Mon, 28 Dec 2020 13:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163038;
        bh=Y+hU/9rFnFfiBkKX+F+X9dIpD/bZ6nVE4GAQfHsgflo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w8SvEFG26QuWM40WBjGnuYKVi7A9cifmepOWXNPDl36j00s/PMwvpEq2/s+Xv3H28
         ZynhdnLPgiTaJiTj3De2ROv6WrsyGwl+N+8AAymu6mpPoA8dJLWv4z+tV7SwqSN2ZF
         0pL/1cnjgb+BBJKgAHvHANvOtrKlzx6bToOWCS2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/453] powerpc: Avoid broken GCC __attribute__((optimize))
Date:   Mon, 28 Dec 2020 13:46:24 +0100
Message-Id: <20201228124944.327586359@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit a7223f5bfcaeade4a86d35263493bcda6c940891 ]

Commit 7053f80d9696 ("powerpc/64: Prevent stack protection in early
boot") introduced a couple of uses of __attribute__((optimize)) with
function scope, to disable the stack protector in some early boot
code.

Unfortunately, and this is documented in the GCC man pages [0],
overriding function attributes for optimization is broken, and is only
supported for debug scenarios, not for production: the problem appears
to be that setting GCC -f flags using this method will cause it to
forget about some or all other optimization settings that have been
applied.

So the only safe way to disable the stack protector is to disable it
for the entire source file.

[0] https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html

Fixes: 7053f80d9696 ("powerpc/64: Prevent stack protection in early boot")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
[mpe: Drop one remaining use of __nostackprotector, reported by snowpatch]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201028080433.26799-1-ardb@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/Makefile   | 3 +++
 arch/powerpc/kernel/paca.c     | 4 ++--
 arch/powerpc/kernel/setup.h    | 6 ------
 arch/powerpc/kernel/setup_64.c | 2 +-
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 59260eb962916..afbd47b0a75cc 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -181,6 +181,9 @@ KCOV_INSTRUMENT_cputable.o := n
 KCOV_INSTRUMENT_setup_64.o := n
 KCOV_INSTRUMENT_paca.o := n
 
+CFLAGS_setup_64.o		+= -fno-stack-protector
+CFLAGS_paca.o			+= -fno-stack-protector
+
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_ALTIVEC)		+= vector.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
diff --git a/arch/powerpc/kernel/paca.c b/arch/powerpc/kernel/paca.c
index 4ea0cca52e162..c786adfb9413f 100644
--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -176,7 +176,7 @@ static struct slb_shadow * __init new_slb_shadow(int cpu, unsigned long limit)
 struct paca_struct **paca_ptrs __read_mostly;
 EXPORT_SYMBOL(paca_ptrs);
 
-void __init __nostackprotector initialise_paca(struct paca_struct *new_paca, int cpu)
+void __init initialise_paca(struct paca_struct *new_paca, int cpu)
 {
 #ifdef CONFIG_PPC_PSERIES
 	new_paca->lppaca_ptr = NULL;
@@ -205,7 +205,7 @@ void __init __nostackprotector initialise_paca(struct paca_struct *new_paca, int
 }
 
 /* Put the paca pointer into r13 and SPRG_PACA */
-void __nostackprotector setup_paca(struct paca_struct *new_paca)
+void setup_paca(struct paca_struct *new_paca)
 {
 	/* Setup r13 */
 	local_paca = new_paca;
diff --git a/arch/powerpc/kernel/setup.h b/arch/powerpc/kernel/setup.h
index 1b02d338a5f55..c82577c4b15d3 100644
--- a/arch/powerpc/kernel/setup.h
+++ b/arch/powerpc/kernel/setup.h
@@ -8,12 +8,6 @@
 #ifndef __ARCH_POWERPC_KERNEL_SETUP_H
 #define __ARCH_POWERPC_KERNEL_SETUP_H
 
-#ifdef CONFIG_CC_IS_CLANG
-#define __nostackprotector
-#else
-#define __nostackprotector __attribute__((__optimize__("no-stack-protector")))
-#endif
-
 void initialize_cache_info(void);
 void irqstack_early_init(void);
 
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 480c236724da2..5bc7e753df4d0 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -284,7 +284,7 @@ void __init record_spr_defaults(void)
  * device-tree is not accessible via normal means at this point.
  */
 
-void __init __nostackprotector early_setup(unsigned long dt_ptr)
+void __init early_setup(unsigned long dt_ptr)
 {
 	static __initdata struct paca_struct boot_paca;
 
-- 
2.27.0



