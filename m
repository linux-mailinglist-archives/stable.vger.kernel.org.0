Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8548D2E41E2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408422AbgL1PO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:14:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438183AbgL1OGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8607A206E5;
        Mon, 28 Dec 2020 14:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164364;
        bh=sqn/z52A55G3oNY8muazdnlW1t/Vy6kuWp62mL26Al0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7zy7aVsi+/s0CZTKoTi1MQL8UCCnVsN3Nkb9D4hDlOv1hb9YqI6hYTOJR5lVvJMD
         IVmB/JwOCjzw9nX6oqE4uAcUp637aUNxR0ciWkghiYGgJRWdxZXnFm7BIRrTxTjK0W
         SET/OjU5O73UfTAlTny1yLp6ru9QRkF1Vct6Td+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/717] powerpc: Avoid broken GCC __attribute__((optimize))
Date:   Mon, 28 Dec 2020 13:42:33 +0100
Message-Id: <20201228125028.381969974@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
index bf0bf1b900d21..fe2ef598e2ead 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -173,6 +173,9 @@ KCOV_INSTRUMENT_cputable.o := n
 KCOV_INSTRUMENT_setup_64.o := n
 KCOV_INSTRUMENT_paca.o := n
 
+CFLAGS_setup_64.o		+= -fno-stack-protector
+CFLAGS_paca.o			+= -fno-stack-protector
+
 extra-$(CONFIG_PPC_FPU)		+= fpu.o
 extra-$(CONFIG_ALTIVEC)		+= vector.o
 extra-$(CONFIG_PPC64)		+= entry_64.o
diff --git a/arch/powerpc/kernel/paca.c b/arch/powerpc/kernel/paca.c
index 0ad15768d762c..7f5aae3c387d2 100644
--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -208,7 +208,7 @@ static struct rtas_args * __init new_rtas_args(int cpu, unsigned long limit)
 struct paca_struct **paca_ptrs __read_mostly;
 EXPORT_SYMBOL(paca_ptrs);
 
-void __init __nostackprotector initialise_paca(struct paca_struct *new_paca, int cpu)
+void __init initialise_paca(struct paca_struct *new_paca, int cpu)
 {
 #ifdef CONFIG_PPC_PSERIES
 	new_paca->lppaca_ptr = NULL;
@@ -241,7 +241,7 @@ void __init __nostackprotector initialise_paca(struct paca_struct *new_paca, int
 }
 
 /* Put the paca pointer into r13 and SPRG_PACA */
-void __nostackprotector setup_paca(struct paca_struct *new_paca)
+void setup_paca(struct paca_struct *new_paca)
 {
 	/* Setup r13 */
 	local_paca = new_paca;
diff --git a/arch/powerpc/kernel/setup.h b/arch/powerpc/kernel/setup.h
index 2ec835574cc94..2dd0d9cb5a208 100644
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
index 74fd47f46fa58..c28e949cc2229 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -283,7 +283,7 @@ void __init record_spr_defaults(void)
  * device-tree is not accessible via normal means at this point.
  */
 
-void __init __nostackprotector early_setup(unsigned long dt_ptr)
+void __init early_setup(unsigned long dt_ptr)
 {
 	static __initdata struct paca_struct boot_paca;
 
-- 
2.27.0



