Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9C83C491F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbhGLGl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235900AbhGLGk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:40:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB41D61006;
        Mon, 12 Jul 2021 06:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071888;
        bh=3mBqEYyaaQ/Qcvta2Rn9sULZ1PCuyv9hA17rSJ6xj8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GxmMGh+g4qktadE6Y0EbcMEBS1dtowJXKGThVsr4siJRKjq3H5BWkbUN6sYJPW4DH
         aygk3+oc8G32eirJGD5P55q0YuCDBV1v19/4GW8OhRHnNQsE47ttK3nvQ5nsRsur/+
         Wtfjyo38WocWHKK6IuPurGlng7M8FVBOYVE2r92I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 246/593] arm64: consistently use reserved_pg_dir
Date:   Mon, 12 Jul 2021 08:06:46 +0200
Message-Id: <20210712060909.968604334@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 833be850f1cabd0e3b5337c0fcab20a6e936dd48 ]

Depending on configuration options and specific code paths, we either
use the empty_zero_page or the configuration-dependent reserved_ttbr0
as a reserved value for TTBR{0,1}_EL1.

To simplify this code, let's always allocate and use the same
reserved_pg_dir, replacing reserved_ttbr0. Note that this is allocated
(and hence pre-zeroed), and is also marked as read-only in the kernel
Image mapping.

Keeping this separate from the empty_zero_page potentially helps with
robustness as the empty_zero_page is used in a number of cases where a
failure to map it read-only could allow it to become corrupted.

The (presently unused) swapper_pg_end symbol is also removed, and
comments are added wherever we rely on the offsets between the
pre-allocated pg_dirs to keep these cases easily identifiable.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201103102229.8542-1-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/asm-uaccess.h    | 4 ++--
 arch/arm64/include/asm/kernel-pgtable.h | 6 ------
 arch/arm64/include/asm/mmu_context.h    | 6 +++---
 arch/arm64/include/asm/pgtable.h        | 1 +
 arch/arm64/include/asm/uaccess.h        | 4 ++--
 arch/arm64/kernel/entry.S               | 6 ++++--
 arch/arm64/kernel/setup.c               | 2 +-
 arch/arm64/kernel/vmlinux.lds.S         | 8 +++-----
 arch/arm64/mm/proc.S                    | 2 +-
 9 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/asm-uaccess.h b/arch/arm64/include/asm/asm-uaccess.h
index f68a0e64482a..5ef624fef44a 100644
--- a/arch/arm64/include/asm/asm-uaccess.h
+++ b/arch/arm64/include/asm/asm-uaccess.h
@@ -15,10 +15,10 @@
 	.macro	__uaccess_ttbr0_disable, tmp1
 	mrs	\tmp1, ttbr1_el1			// swapper_pg_dir
 	bic	\tmp1, \tmp1, #TTBR_ASID_MASK
-	sub	\tmp1, \tmp1, #RESERVED_TTBR0_SIZE	// reserved_ttbr0 just before swapper_pg_dir
+	sub	\tmp1, \tmp1, #PAGE_SIZE		// reserved_pg_dir just before swapper_pg_dir
 	msr	ttbr0_el1, \tmp1			// set reserved TTBR0_EL1
 	isb
-	add	\tmp1, \tmp1, #RESERVED_TTBR0_SIZE
+	add	\tmp1, \tmp1, #PAGE_SIZE
 	msr	ttbr1_el1, \tmp1		// set reserved ASID
 	isb
 	.endm
diff --git a/arch/arm64/include/asm/kernel-pgtable.h b/arch/arm64/include/asm/kernel-pgtable.h
index 19ca76ea60d9..587c504a4c8b 100644
--- a/arch/arm64/include/asm/kernel-pgtable.h
+++ b/arch/arm64/include/asm/kernel-pgtable.h
@@ -89,12 +89,6 @@
 #define INIT_DIR_SIZE (PAGE_SIZE * EARLY_PAGES(KIMAGE_VADDR, _end))
 #define IDMAP_DIR_SIZE		(IDMAP_PGTABLE_LEVELS * PAGE_SIZE)
 
-#ifdef CONFIG_ARM64_SW_TTBR0_PAN
-#define RESERVED_TTBR0_SIZE	(PAGE_SIZE)
-#else
-#define RESERVED_TTBR0_SIZE	(0)
-#endif
-
 /* Initial memory map size */
 #if ARM64_SWAPPER_USES_SECTION_MAPS
 #define SWAPPER_BLOCK_SHIFT	SECTION_SHIFT
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 4e2ba9477845..68028de06d18 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -36,11 +36,11 @@ static inline void contextidr_thread_switch(struct task_struct *next)
 }
 
 /*
- * Set TTBR0 to empty_zero_page. No translations will be possible via TTBR0.
+ * Set TTBR0 to reserved_pg_dir. No translations will be possible via TTBR0.
  */
 static inline void cpu_set_reserved_ttbr0(void)
 {
-	unsigned long ttbr = phys_to_ttbr(__pa_symbol(empty_zero_page));
+	unsigned long ttbr = phys_to_ttbr(__pa_symbol(reserved_pg_dir));
 
 	write_sysreg(ttbr, ttbr0_el1);
 	isb();
@@ -192,7 +192,7 @@ static inline void update_saved_ttbr0(struct task_struct *tsk,
 		return;
 
 	if (mm == &init_mm)
-		ttbr = __pa_symbol(empty_zero_page);
+		ttbr = __pa_symbol(reserved_pg_dir);
 	else
 		ttbr = virt_to_phys(mm->pgd) | ASID(mm) << 48;
 
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 717f13d52ecc..10ffbc96ac31 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -530,6 +530,7 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 extern pgd_t idmap_pg_end[];
 extern pgd_t tramp_pg_dir[PTRS_PER_PGD];
+extern pgd_t reserved_pg_dir[PTRS_PER_PGD];
 
 extern void set_swapper_pgd(pgd_t *pgdp, pgd_t pgd);
 
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 991dd5f031e4..385a189f7d39 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -113,8 +113,8 @@ static inline void __uaccess_ttbr0_disable(void)
 	local_irq_save(flags);
 	ttbr = read_sysreg(ttbr1_el1);
 	ttbr &= ~TTBR_ASID_MASK;
-	/* reserved_ttbr0 placed before swapper_pg_dir */
-	write_sysreg(ttbr - RESERVED_TTBR0_SIZE, ttbr0_el1);
+	/* reserved_pg_dir placed before swapper_pg_dir */
+	write_sysreg(ttbr - PAGE_SIZE, ttbr0_el1);
 	isb();
 	/* Set reserved ASID */
 	write_sysreg(ttbr, ttbr1_el1);
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 60d399123360..fe83d6d67ec3 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -770,9 +770,10 @@ SYM_CODE_END(ret_to_user)
  */
 	.pushsection ".entry.tramp.text", "ax"
 
+	// Move from tramp_pg_dir to swapper_pg_dir
 	.macro tramp_map_kernel, tmp
 	mrs	\tmp, ttbr1_el1
-	add	\tmp, \tmp, #(PAGE_SIZE + RESERVED_TTBR0_SIZE)
+	add	\tmp, \tmp, #(2 * PAGE_SIZE)
 	bic	\tmp, \tmp, #USER_ASID_FLAG
 	msr	ttbr1_el1, \tmp
 #ifdef CONFIG_QCOM_FALKOR_ERRATUM_1003
@@ -789,9 +790,10 @@ alternative_else_nop_endif
 #endif /* CONFIG_QCOM_FALKOR_ERRATUM_1003 */
 	.endm
 
+	// Move from swapper_pg_dir to tramp_pg_dir
 	.macro tramp_unmap_kernel, tmp
 	mrs	\tmp, ttbr1_el1
-	sub	\tmp, \tmp, #(PAGE_SIZE + RESERVED_TTBR0_SIZE)
+	sub	\tmp, \tmp, #(2 * PAGE_SIZE)
 	orr	\tmp, \tmp, #USER_ASID_FLAG
 	msr	ttbr1_el1, \tmp
 	/*
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 133257ffd859..c28a9ec76b11 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -366,7 +366,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	 * faults in case uaccess_enable() is inadvertently called by the init
 	 * thread.
 	 */
-	init_task.thread_info.ttbr0 = __pa_symbol(empty_zero_page);
+	init_task.thread_info.ttbr0 = __pa_symbol(reserved_pg_dir);
 #endif
 
 	if (boot_args[1] || boot_args[2] || boot_args[3]) {
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 1bda604f4c70..30c102978942 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -164,13 +164,11 @@ SECTIONS
 	. += PAGE_SIZE;
 #endif
 
-#ifdef CONFIG_ARM64_SW_TTBR0_PAN
-	reserved_ttbr0 = .;
-	. += RESERVED_TTBR0_SIZE;
-#endif
+	reserved_pg_dir = .;
+	. += PAGE_SIZE;
+
 	swapper_pg_dir = .;
 	. += PAGE_SIZE;
-	swapper_pg_end = .;
 
 	. = ALIGN(SEGMENT_ALIGN);
 	__init_begin = .;
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index a14927360be2..aacc7eab9b2f 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -168,7 +168,7 @@ SYM_FUNC_END(cpu_do_resume)
 	.pushsection ".idmap.text", "awx"
 
 .macro	__idmap_cpu_set_reserved_ttbr1, tmp1, tmp2
-	adrp	\tmp1, empty_zero_page
+	adrp	\tmp1, reserved_pg_dir
 	phys_to_ttbr \tmp2, \tmp1
 	offset_ttbr1 \tmp2, \tmp1
 	msr	ttbr1_el1, \tmp2
-- 
2.30.2



