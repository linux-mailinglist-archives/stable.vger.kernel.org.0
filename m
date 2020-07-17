Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E198C22473D
	for <lists+stable@lfdr.de>; Sat, 18 Jul 2020 01:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgGQXyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 19:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgGQXyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 19:54:03 -0400
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04C9D20717;
        Fri, 17 Jul 2020 23:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595030043;
        bh=kcN9TVXBy9jMhbNmLpZNBe1CtOH8TSWiFF+uuOkl4iQ=;
        h=From:To:Cc:Subject:Date:From;
        b=CfYiW388wwAUhO6d85U7hTgfSm08vZnI/b3z1SyQazuBM+YadGFfQv2w/ca4iAZDA
         3mri1/T1aHv9ricufOQqjhuCzX9SJtoslwj7sZeIbtl5umDlk5xz6OTeiZrruGAlai
         ZHiffo/y+J/rn+E/i6B3Z3XRE7golPaZ68EAcM5A=
From:   Andy Lutomirski <luto@kernel.org>
To:     x86@kernel.org
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v3] x86/ioperm: Fix io bitmap invalidation on Xen PV
Date:   Fri, 17 Jul 2020 16:53:55 -0700
Message-Id: <d53075590e1f91c19f8af705059d3ff99424c020.1595030016.git.luto@kernel.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tss_invalidate_io_bitmap() wasn't wired up properly through the pvop
machinery, so the TSS and Xen's io bitmap would get out of sync
whenever disabling a valid io bitmap.

Add a new pvop for tss_invalidate_io_bitmap() to fix it.

This is XSA-329.

Cc: Juergen Gross <jgross@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 22fe5b0439dd ("x86/ioperm: Move TSS bitmap update to exit to user work")
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/include/asm/io_bitmap.h      | 16 ++++++++++++++++
 arch/x86/include/asm/paravirt.h       |  5 +++++
 arch/x86/include/asm/paravirt_types.h |  1 +
 arch/x86/kernel/paravirt.c            |  3 ++-
 arch/x86/kernel/process.c             | 18 ++----------------
 arch/x86/xen/enlighten_pv.c           | 12 ++++++++++++
 6 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/io_bitmap.h b/arch/x86/include/asm/io_bitmap.h
index ac1a99ffbd8d..7f080f5c7def 100644
--- a/arch/x86/include/asm/io_bitmap.h
+++ b/arch/x86/include/asm/io_bitmap.h
@@ -19,12 +19,28 @@ struct task_struct;
 void io_bitmap_share(struct task_struct *tsk);
 void io_bitmap_exit(struct task_struct *tsk);
 
+static inline void native_tss_invalidate_io_bitmap(void)
+{
+	/*
+	 * Invalidate the I/O bitmap by moving io_bitmap_base outside the
+	 * TSS limit so any subsequent I/O access from user space will
+	 * trigger a #GP.
+	 *
+	 * This is correct even when VMEXIT rewrites the TSS limit
+	 * to 0x67 as the only requirement is that the base points
+	 * outside the limit.
+	 */
+	this_cpu_write(cpu_tss_rw.x86_tss.io_bitmap_base,
+		       IO_BITMAP_OFFSET_INVALID);
+}
+
 void native_tss_update_io_bitmap(void);
 
 #ifdef CONFIG_PARAVIRT_XXL
 #include <asm/paravirt.h>
 #else
 #define tss_update_io_bitmap native_tss_update_io_bitmap
+#define tss_invalidate_io_bitmap native_tss_invalidate_io_bitmap
 #endif
 
 #else
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 5ca5d297df75..3d2afecde50c 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -302,6 +302,11 @@ static inline void write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
 }
 
 #ifdef CONFIG_X86_IOPL_IOPERM
+static inline void tss_invalidate_io_bitmap(void)
+{
+	PVOP_VCALL0(cpu.invalidate_io_bitmap);
+}
+
 static inline void tss_update_io_bitmap(void)
 {
 	PVOP_VCALL0(cpu.update_io_bitmap);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 732f62e04ddb..8dfcb2508e6d 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -141,6 +141,7 @@ struct pv_cpu_ops {
 	void (*load_sp0)(unsigned long sp0);
 
 #ifdef CONFIG_X86_IOPL_IOPERM
+	void (*invalidate_io_bitmap)(void);
 	void (*update_io_bitmap)(void);
 #endif
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 674a7d66d960..de2138ba38e5 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -324,7 +324,8 @@ struct paravirt_patch_template pv_ops = {
 	.cpu.swapgs		= native_swapgs,
 
 #ifdef CONFIG_X86_IOPL_IOPERM
-	.cpu.update_io_bitmap	= native_tss_update_io_bitmap,
+	.cpu.invalidate_io_bitmap	= native_tss_invalidate_io_bitmap,
+	.cpu.update_io_bitmap		= native_tss_update_io_bitmap,
 #endif
 
 	.cpu.start_context_switch	= paravirt_nop,
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f362ce0d5ac0..fe67dbd76e51 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -322,20 +322,6 @@ void arch_setup_new_exec(void)
 }
 
 #ifdef CONFIG_X86_IOPL_IOPERM
-static inline void tss_invalidate_io_bitmap(struct tss_struct *tss)
-{
-	/*
-	 * Invalidate the I/O bitmap by moving io_bitmap_base outside the
-	 * TSS limit so any subsequent I/O access from user space will
-	 * trigger a #GP.
-	 *
-	 * This is correct even when VMEXIT rewrites the TSS limit
-	 * to 0x67 as the only requirement is that the base points
-	 * outside the limit.
-	 */
-	tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET_INVALID;
-}
-
 static inline void switch_to_bitmap(unsigned long tifp)
 {
 	/*
@@ -346,7 +332,7 @@ static inline void switch_to_bitmap(unsigned long tifp)
 	 * user mode.
 	 */
 	if (tifp & _TIF_IO_BITMAP)
-		tss_invalidate_io_bitmap(this_cpu_ptr(&cpu_tss_rw));
+		tss_invalidate_io_bitmap();
 }
 
 static void tss_copy_io_bitmap(struct tss_struct *tss, struct io_bitmap *iobm)
@@ -380,7 +366,7 @@ void native_tss_update_io_bitmap(void)
 	u16 *base = &tss->x86_tss.io_bitmap_base;
 
 	if (!test_thread_flag(TIF_IO_BITMAP)) {
-		tss_invalidate_io_bitmap(tss);
+		native_tss_invalidate_io_bitmap();
 		return;
 	}
 
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 0d68948c82ad..c46b9f2e732f 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -870,6 +870,17 @@ static void xen_load_sp0(unsigned long sp0)
 }
 
 #ifdef CONFIG_X86_IOPL_IOPERM
+static void xen_invalidate_io_bitmap(void)
+{
+	struct physdev_set_iobitmap iobitmap = {
+		.bitmap = 0,
+		.nr_ports = 0,
+	};
+
+	native_tss_invalidate_io_bitmap();
+	HYPERVISOR_physdev_op(PHYSDEVOP_set_iobitmap, &iobitmap);
+}
+
 static void xen_update_io_bitmap(void)
 {
 	struct physdev_set_iobitmap iobitmap;
@@ -1099,6 +1110,7 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.load_sp0 = xen_load_sp0,
 
 #ifdef CONFIG_X86_IOPL_IOPERM
+	.invalidate_io_bitmap = xen_invalidate_io_bitmap,
 	.update_io_bitmap = xen_update_io_bitmap,
 #endif
 	.io_delay = xen_io_delay,
-- 
2.25.4

