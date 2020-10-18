Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4734B291FA0
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388783AbgJRUBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 16:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgJRTSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3303E22282;
        Sun, 18 Oct 2020 19:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048694;
        bh=W06gv4MHpN2EYp5m9MR3JNXE4HzyvCiCnegRPutDrR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktSrjnfkCmssr3LtfOtnNCB94xjdulir5e5p189CR/hhkXauGNguLSzqlsUhr1WYp
         f7BQSFnWCfzS/Z45rkcguC1mwm+jbQ24HMIlCO6g/fCdQglvftFjwqVar9qKYpg0Ov
         Swmb32vC1BbWwP7oj68gJxE+6BpAwKxQc3HNbToM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 005/111] x86/asm: Replace __force_order with a memory clobber
Date:   Sun, 18 Oct 2020 15:16:21 -0400
Message-Id: <20201018191807.4052726-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit aa5cacdc29d76a005cbbee018a47faa6e724dd2d ]

The CRn accessor functions use __force_order as a dummy operand to
prevent the compiler from reordering CRn reads/writes with respect to
each other.

The fact that the asm is volatile should be enough to prevent this:
volatile asm statements should be executed in program order. However GCC
4.9.x and 5.x have a bug that might result in reordering. This was fixed
in 8.1, 7.3 and 6.5. Versions prior to these, including 5.x and 4.9.x,
may reorder volatile asm statements with respect to each other.

There are some issues with __force_order as implemented:
- It is used only as an input operand for the write functions, and hence
  doesn't do anything additional to prevent reordering writes.
- It allows memory accesses to be cached/reordered across write
  functions, but CRn writes affect the semantics of memory accesses, so
  this could be dangerous.
- __force_order is not actually defined in the kernel proper, but the
  LLVM toolchain can in some cases require a definition: LLVM (as well
  as GCC 4.9) requires it for PIE code, which is why the compressed
  kernel has a definition, but also the clang integrated assembler may
  consider the address of __force_order to be significant, resulting in
  a reference that requires a definition.

Fix this by:
- Using a memory clobber for the write functions to additionally prevent
  caching/reordering memory accesses across CRn writes.
- Using a dummy input operand with an arbitrary constant address for the
  read functions, instead of a global variable. This will prevent reads
  from being reordered across writes, while allowing memory loads to be
  cached/reordered across CRn reads, which should be safe.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82602
Link: https://lore.kernel.org/lkml/20200527135329.1172644-1-arnd@arndb.de/
Link: https://lkml.kernel.org/r/20200902232152.3709896-1-nivedita@alum.mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/pgtable_64.c |  9 ---------
 arch/x86/include/asm/special_insns.h  | 28 ++++++++++++++-------------
 arch/x86/kernel/cpu/common.c          |  4 ++--
 3 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
index c8862696a47b9..7d0394f4ebf97 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -5,15 +5,6 @@
 #include "pgtable.h"
 #include "../string.h"
 
-/*
- * __force_order is used by special_insns.h asm code to force instruction
- * serialization.
- *
- * It is not referenced from the code, but GCC < 5 with -fPIE would fail
- * due to an undefined symbol. Define it to make these ancient GCCs work.
- */
-unsigned long __force_order;
-
 #define BIOS_START_MIN		0x20000U	/* 128K, less than this is insane */
 #define BIOS_START_MAX		0x9f000U	/* 640K, absolute maximum */
 
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 59a3e13204c34..d6e3bb9363d22 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -11,45 +11,47 @@
 #include <linux/jump_label.h>
 
 /*
- * Volatile isn't enough to prevent the compiler from reordering the
- * read/write functions for the control registers and messing everything up.
- * A memory clobber would solve the problem, but would prevent reordering of
- * all loads stores around it, which can hurt performance. Solution is to
- * use a variable and mimic reads and writes to it to enforce serialization
+ * The compiler should not reorder volatile asm statements with respect to each
+ * other: they should execute in program order. However GCC 4.9.x and 5.x have
+ * a bug (which was fixed in 8.1, 7.3 and 6.5) where they might reorder
+ * volatile asm. The write functions are not affected since they have memory
+ * clobbers preventing reordering. To prevent reads from being reordered with
+ * respect to writes, use a dummy memory operand.
  */
-extern unsigned long __force_order;
+
+#define __FORCE_ORDER "m"(*(unsigned int *)0x1000UL)
 
 void native_write_cr0(unsigned long val);
 
 static inline unsigned long native_read_cr0(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr0,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr0,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 	return val;
 }
 
 static __always_inline unsigned long native_read_cr2(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr2,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr2,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 	return val;
 }
 
 static __always_inline void native_write_cr2(unsigned long val)
 {
-	asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr2": : "r" (val) : "memory");
 }
 
 static inline unsigned long __native_read_cr3(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr3,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 	return val;
 }
 
 static inline void native_write_cr3(unsigned long val)
 {
-	asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr3": : "r" (val) : "memory");
 }
 
 static inline unsigned long native_read_cr4(void)
@@ -64,10 +66,10 @@ static inline unsigned long native_read_cr4(void)
 	asm volatile("1: mov %%cr4, %0\n"
 		     "2:\n"
 		     _ASM_EXTABLE(1b, 2b)
-		     : "=r" (val), "=m" (__force_order) : "0" (0));
+		     : "=r" (val) : "0" (0), __FORCE_ORDER);
 #else
 	/* CR4 always exists on x86_64. */
-	asm volatile("mov %%cr4,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr4,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 #endif
 	return val;
 }
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c5d6f17d9b9d3..178499f903661 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -359,7 +359,7 @@ void native_write_cr0(unsigned long val)
 	unsigned long bits_missing = 0;
 
 set_register:
-	asm volatile("mov %0,%%cr0": "+r" (val), "+m" (__force_order));
+	asm volatile("mov %0,%%cr0": "+r" (val) : : "memory");
 
 	if (static_branch_likely(&cr_pinning)) {
 		if (unlikely((val & X86_CR0_WP) != X86_CR0_WP)) {
@@ -378,7 +378,7 @@ void native_write_cr4(unsigned long val)
 	unsigned long bits_changed = 0;
 
 set_register:
-	asm volatile("mov %0,%%cr4": "+r" (val), "+m" (cr4_pinned_bits));
+	asm volatile("mov %0,%%cr4": "+r" (val) : : "memory");
 
 	if (static_branch_likely(&cr_pinning)) {
 		if (unlikely((val & cr4_pinned_mask) != cr4_pinned_bits)) {
-- 
2.25.1

