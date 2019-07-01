Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8252F1F380
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfEOLDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:32856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbfEOLDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7428D2084F;
        Wed, 15 May 2019 11:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918211;
        bh=OskQQ6RAq93IvGJYfVRei+T4gBjyMCYAd097Xk5SGa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVdjncvqz0ux9DABJgUnY/H5PbANEstYaxJI1S/qVsOc+NDj/DjRt26LgA11h3eqm
         qDob/cKdXQdlCtjPRa1UIALtYk4aPj5d5QmIBUULxnQzPA0qnGL+A61chNzgLYYFPV
         8Mlezq937ycAZ0MRx8KEMFVmIkal11lWW3Ynguxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Diana Craciun <diana.craciun@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 047/266] powerpc/64: Add CONFIG_PPC_BARRIER_NOSPEC
Date:   Wed, 15 May 2019 12:52:34 +0200
Message-Id: <20190515090724.051674056@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 179ab1cbf883575c3a585bcfc0f2160f1d22a149 upstream.

Add a config symbol to encode which platforms support the
barrier_nospec speculation barrier. Currently this is just Book3S 64
but we will add Book3E in a future patch.

Signed-off-by: Diana Craciun <diana.craciun@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/Kconfig               |    7 ++++++-
 arch/powerpc/include/asm/barrier.h |    6 +++---
 arch/powerpc/include/asm/setup.h   |    2 +-
 arch/powerpc/kernel/Makefile       |    3 ++-
 arch/powerpc/kernel/module.c       |    4 +++-
 arch/powerpc/kernel/vmlinux.lds.S  |    4 +++-
 arch/powerpc/lib/feature-fixups.c  |    6 ++++--
 7 files changed, 22 insertions(+), 10 deletions(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -136,7 +136,7 @@ config PPC
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_TIME_VSYSCALL_OLD
-	select GENERIC_CPU_VULNERABILITIES	if PPC_BOOK3S_64
+	select GENERIC_CPU_VULNERABILITIES	if PPC_BARRIER_NOSPEC
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
@@ -162,6 +162,11 @@ config PPC
 	select ARCH_HAS_DMA_SET_COHERENT_MASK
 	select HAVE_ARCH_SECCOMP_FILTER
 
+config PPC_BARRIER_NOSPEC
+    bool
+    default y
+    depends on PPC_BOOK3S_64
+
 config GENERIC_CSUM
 	def_bool CPU_LITTLE_ENDIAN
 
--- a/arch/powerpc/include/asm/barrier.h
+++ b/arch/powerpc/include/asm/barrier.h
@@ -92,7 +92,7 @@ do {									\
 #define smp_mb__after_atomic()      smp_mb()
 #define smp_mb__before_spinlock()   smp_mb()
 
-#ifdef CONFIG_PPC_BOOK3S_64
+#ifdef CONFIG_PPC_BARRIER_NOSPEC
 /*
  * Prevent execution of subsequent instructions until preceding branches have
  * been fully resolved and are no longer executing speculatively.
@@ -102,9 +102,9 @@ do {									\
 // This also acts as a compiler barrier due to the memory clobber.
 #define barrier_nospec() asm (stringify_in_c(barrier_nospec_asm) ::: "memory")
 
-#else /* !CONFIG_PPC_BOOK3S_64 */
+#else /* !CONFIG_PPC_BARRIER_NOSPEC */
 #define barrier_nospec_asm
 #define barrier_nospec()
-#endif
+#endif /* CONFIG_PPC_BARRIER_NOSPEC */
 
 #endif /* _ASM_POWERPC_BARRIER_H */
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -42,7 +42,7 @@ void setup_barrier_nospec(void);
 void do_barrier_nospec_fixups(bool enable);
 extern bool barrier_nospec_enabled;
 
-#ifdef CONFIG_PPC_BOOK3S_64
+#ifdef CONFIG_PPC_BARRIER_NOSPEC
 void do_barrier_nospec_fixups_range(bool enable, void *start, void *end);
 #else
 static inline void do_barrier_nospec_fixups_range(bool enable, void *start, void *end) { };
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -40,10 +40,11 @@ obj-$(CONFIG_PPC64)		+= setup_64.o sys_p
 obj-$(CONFIG_VDSO32)		+= vdso32/
 obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
 obj-$(CONFIG_PPC_BOOK3S_64)	+= cpu_setup_ppc970.o cpu_setup_pa6t.o
-obj-$(CONFIG_PPC_BOOK3S_64)	+= cpu_setup_power.o security.o
+obj-$(CONFIG_PPC_BOOK3S_64)	+= cpu_setup_power.o
 obj-$(CONFIG_PPC_BOOK3S_64)	+= mce.o mce_power.o
 obj64-$(CONFIG_RELOCATABLE)	+= reloc_64.o
 obj-$(CONFIG_PPC_BOOK3E_64)	+= exceptions-64e.o idle_book3e.o
+obj-$(CONFIG_PPC_BARRIER_NOSPEC) += security.o
 obj-$(CONFIG_PPC64)		+= vdso64/
 obj-$(CONFIG_ALTIVEC)		+= vecemu.o
 obj-$(CONFIG_PPC_970_NAP)	+= idle_power4.o
--- a/arch/powerpc/kernel/module.c
+++ b/arch/powerpc/kernel/module.c
@@ -67,13 +67,15 @@ int module_finalize(const Elf_Ehdr *hdr,
 		do_feature_fixups(powerpc_firmware_features,
 				  (void *)sect->sh_addr,
 				  (void *)sect->sh_addr + sect->sh_size);
+#endif /* CONFIG_PPC64 */
 
+#ifdef CONFIG_PPC_BARRIER_NOSPEC
 	sect = find_section(hdr, sechdrs, "__spec_barrier_fixup");
 	if (sect != NULL)
 		do_barrier_nospec_fixups_range(barrier_nospec_enabled,
 				  (void *)sect->sh_addr,
 				  (void *)sect->sh_addr + sect->sh_size);
-#endif
+#endif /* CONFIG_PPC_BARRIER_NOSPEC */
 
 	sect = find_section(hdr, sechdrs, "__lwsync_fixup");
 	if (sect != NULL)
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -93,14 +93,16 @@ SECTIONS
 		*(__rfi_flush_fixup)
 		__stop___rfi_flush_fixup = .;
 	}
+#endif /* CONFIG_PPC64 */
 
+#ifdef CONFIG_PPC_BARRIER_NOSPEC
 	. = ALIGN(8);
 	__spec_barrier_fixup : AT(ADDR(__spec_barrier_fixup) - LOAD_OFFSET) {
 		__start___barrier_nospec_fixup = .;
 		*(__barrier_nospec_fixup)
 		__stop___barrier_nospec_fixup = .;
 	}
-#endif
+#endif /* CONFIG_PPC_BARRIER_NOSPEC */
 
 	EXCEPTION_TABLE(0)
 
--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -301,6 +301,9 @@ void do_barrier_nospec_fixups_range(bool
 	printk(KERN_DEBUG "barrier-nospec: patched %d locations\n", i);
 }
 
+#endif /* CONFIG_PPC_BOOK3S_64 */
+
+#ifdef CONFIG_PPC_BARRIER_NOSPEC
 void do_barrier_nospec_fixups(bool enable)
 {
 	void *start, *end;
@@ -310,8 +313,7 @@ void do_barrier_nospec_fixups(bool enabl
 
 	do_barrier_nospec_fixups_range(enable, start, end);
 }
-
-#endif /* CONFIG_PPC_BOOK3S_64 */
+#endif /* CONFIG_PPC_BARRIER_NOSPEC */
 
 void do_lwsync_fixups(unsigned long value, void *fixup_start, void *fixup_end)
 {


