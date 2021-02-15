Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6505931BD2C
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhBOPl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:41:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231592AbhBOPiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:38:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C751864EA6;
        Mon, 15 Feb 2021 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403233;
        bh=KqdBtz4ottQ7UIvyckd2fMKx7JZ7EDOeuUQjGaqDG/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/jR1HQnmxFPBRbofUWEGsb4Z86VOJspGo0niGdkK3GO+2xZCUUueuCrtIJfLqm/D
         hVSc36XvxCdKX5Xj0Y0zwZGcKgP9pL/2ltM8WClrSKAJojQvBkAeJkai5h9Guhtep+
         TnNCEMKzs4v7oIivwffD6IjN1jDJnv8YXszS4w1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Giancarlo Ferrari <giancarlo.ferrari89@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/104] ARM: kexec: fix oops after TLB are invalidated
Date:   Mon, 15 Feb 2021 16:26:55 +0100
Message-Id: <20210215152720.831687013@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 4d62e81b60d4025e2dfcd5ea531cc1394ce9226f ]

Giancarlo Ferrari reports the following oops while trying to use kexec:

 Unable to handle kernel paging request at virtual address 80112f38
 pgd = fd7ef03e
 [80112f38] *pgd=0001141e(bad)
 Internal error: Oops: 80d [#1] PREEMPT SMP ARM
 ...

This is caused by machine_kexec() trying to set the kernel text to be
read/write, so it can poke values into the relocation code before
copying it - and an interrupt occuring which changes the page tables.
The subsequent writes then hit read-only sections that trigger a
data abort resulting in the above oops.

Fix this by copying the relocation code, and then writing the variables
into the destination, thereby avoiding the need to make the kernel text
read/write.

Reported-by: Giancarlo Ferrari <giancarlo.ferrari89@gmail.com>
Tested-by: Giancarlo Ferrari <giancarlo.ferrari89@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/kexec-internal.h | 12 +++++++++
 arch/arm/kernel/asm-offsets.c         |  5 ++++
 arch/arm/kernel/machine_kexec.c       | 20 ++++++--------
 arch/arm/kernel/relocate_kernel.S     | 38 ++++++++-------------------
 4 files changed, 36 insertions(+), 39 deletions(-)
 create mode 100644 arch/arm/include/asm/kexec-internal.h

diff --git a/arch/arm/include/asm/kexec-internal.h b/arch/arm/include/asm/kexec-internal.h
new file mode 100644
index 0000000000000..ecc2322db7aa1
--- /dev/null
+++ b/arch/arm/include/asm/kexec-internal.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ARM_KEXEC_INTERNAL_H
+#define _ARM_KEXEC_INTERNAL_H
+
+struct kexec_relocate_data {
+	unsigned long kexec_start_address;
+	unsigned long kexec_indirection_page;
+	unsigned long kexec_mach_type;
+	unsigned long kexec_r2;
+};
+
+#endif
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index a1570c8bab25a..be8050b0c3dfb 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <asm/cacheflush.h>
+#include <asm/kexec-internal.h>
 #include <asm/glue-df.h>
 #include <asm/glue-pf.h>
 #include <asm/mach/arch.h>
@@ -170,5 +171,9 @@ int main(void)
   DEFINE(MPU_RGN_PRBAR,	offsetof(struct mpu_rgn, prbar));
   DEFINE(MPU_RGN_PRLAR,	offsetof(struct mpu_rgn, prlar));
 #endif
+  DEFINE(KEXEC_START_ADDR,	offsetof(struct kexec_relocate_data, kexec_start_address));
+  DEFINE(KEXEC_INDIR_PAGE,	offsetof(struct kexec_relocate_data, kexec_indirection_page));
+  DEFINE(KEXEC_MACH_TYPE,	offsetof(struct kexec_relocate_data, kexec_mach_type));
+  DEFINE(KEXEC_R2,		offsetof(struct kexec_relocate_data, kexec_r2));
   return 0; 
 }
diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 5d84ad333f050..2b09dad7935eb 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -13,6 +13,7 @@
 #include <linux/of_fdt.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
+#include <asm/kexec-internal.h>
 #include <asm/fncpy.h>
 #include <asm/mach-types.h>
 #include <asm/smp_plat.h>
@@ -22,11 +23,6 @@
 extern void relocate_new_kernel(void);
 extern const unsigned int relocate_new_kernel_size;
 
-extern unsigned long kexec_start_address;
-extern unsigned long kexec_indirection_page;
-extern unsigned long kexec_mach_type;
-extern unsigned long kexec_boot_atags;
-
 static atomic_t waiting_for_crash_ipi;
 
 /*
@@ -159,6 +155,7 @@ void (*kexec_reinit)(void);
 void machine_kexec(struct kimage *image)
 {
 	unsigned long page_list, reboot_entry_phys;
+	struct kexec_relocate_data *data;
 	void (*reboot_entry)(void);
 	void *reboot_code_buffer;
 
@@ -174,18 +171,17 @@ void machine_kexec(struct kimage *image)
 
 	reboot_code_buffer = page_address(image->control_code_page);
 
-	/* Prepare parameters for reboot_code_buffer*/
-	set_kernel_text_rw();
-	kexec_start_address = image->start;
-	kexec_indirection_page = page_list;
-	kexec_mach_type = machine_arch_type;
-	kexec_boot_atags = image->arch.kernel_r2;
-
 	/* copy our kernel relocation code to the control code page */
 	reboot_entry = fncpy(reboot_code_buffer,
 			     &relocate_new_kernel,
 			     relocate_new_kernel_size);
 
+	data = reboot_code_buffer + relocate_new_kernel_size;
+	data->kexec_start_address = image->start;
+	data->kexec_indirection_page = page_list;
+	data->kexec_mach_type = machine_arch_type;
+	data->kexec_r2 = image->arch.kernel_r2;
+
 	/* get the identity mapping physical address for the reboot code */
 	reboot_entry_phys = virt_to_idmap(reboot_entry);
 
diff --git a/arch/arm/kernel/relocate_kernel.S b/arch/arm/kernel/relocate_kernel.S
index 72a08786e16eb..218d524360fcd 100644
--- a/arch/arm/kernel/relocate_kernel.S
+++ b/arch/arm/kernel/relocate_kernel.S
@@ -5,14 +5,16 @@
 
 #include <linux/linkage.h>
 #include <asm/assembler.h>
+#include <asm/asm-offsets.h>
 #include <asm/kexec.h>
 
 	.align	3	/* not needed for this code, but keeps fncpy() happy */
 
 ENTRY(relocate_new_kernel)
 
-	ldr	r0,kexec_indirection_page
-	ldr	r1,kexec_start_address
+	adr	r7, relocate_new_kernel_end
+	ldr	r0, [r7, #KEXEC_INDIR_PAGE]
+	ldr	r1, [r7, #KEXEC_START_ADDR]
 
 	/*
 	 * If there is no indirection page (we are doing crashdumps)
@@ -57,34 +59,16 @@ ENTRY(relocate_new_kernel)
 
 2:
 	/* Jump to relocated kernel */
-	mov lr,r1
-	mov r0,#0
-	ldr r1,kexec_mach_type
-	ldr r2,kexec_boot_atags
- ARM(	ret lr	)
- THUMB(	bx lr		)
-
-	.align
-
-	.globl kexec_start_address
-kexec_start_address:
-	.long	0x0
-
-	.globl kexec_indirection_page
-kexec_indirection_page:
-	.long	0x0
-
-	.globl kexec_mach_type
-kexec_mach_type:
-	.long	0x0
-
-	/* phy addr of the atags for the new kernel */
-	.globl kexec_boot_atags
-kexec_boot_atags:
-	.long	0x0
+	mov	lr, r1
+	mov	r0, #0
+	ldr	r1, [r7, #KEXEC_MACH_TYPE]
+	ldr	r2, [r7, #KEXEC_R2]
+ ARM(	ret	lr	)
+ THUMB(	bx	lr	)
 
 ENDPROC(relocate_new_kernel)
 
+	.align	3
 relocate_new_kernel_end:
 
 	.globl relocate_new_kernel_size
-- 
2.27.0



