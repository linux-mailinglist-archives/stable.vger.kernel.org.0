Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18A771629C0
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 16:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgBRPrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 10:47:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:50102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgBRPrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 10:47:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C13E1AE2A;
        Tue, 18 Feb 2020 15:47:15 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] x86/ioperm: add new paravirt function update_io_bitmap
Date:   Tue, 18 Feb 2020 16:47:12 +0100
Message-Id: <20200218154712.25490-1-jgross@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 111e7b15cf10f6 ("x86/ioperm: Extend IOPL config to control
ioperm() as well") reworked the iopl syscall to use I/O bitmaps.

Unfortunately this broke Xen PV domains using that syscall as there
is currently no I/O bitmap support in PV domains.

Add I/O bitmap support via a new paravirt function update_io_bitmap
which Xen PV domains can use to update their I/O bitmaps via a
hypercall.

Fixes: 111e7b15cf10f6 ("x86/ioperm: Extend IOPL config to control ioperm() as well")
Reported-by: Jan Beulich <jbeulich@suse.com>
Cc: <stable@vger.kernel.org> # 5.5
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Tested-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/include/asm/io_bitmap.h      |  9 ++++++++-
 arch/x86/include/asm/paravirt.h       |  7 +++++++
 arch/x86/include/asm/paravirt_types.h |  4 ++++
 arch/x86/kernel/paravirt.c            |  5 +++++
 arch/x86/kernel/process.c             |  2 +-
 arch/x86/xen/enlighten_pv.c           | 25 +++++++++++++++++++++++++
 6 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/io_bitmap.h b/arch/x86/include/asm/io_bitmap.h
index 02c6ef8f7667..07344d82e88e 100644
--- a/arch/x86/include/asm/io_bitmap.h
+++ b/arch/x86/include/asm/io_bitmap.h
@@ -19,7 +19,14 @@ struct task_struct;
 void io_bitmap_share(struct task_struct *tsk);
 void io_bitmap_exit(void);
 
-void tss_update_io_bitmap(void);
+void native_tss_update_io_bitmap(void);
+
+#ifdef CONFIG_PARAVIRT_XXL
+#include <asm/paravirt.h>
+#else
+#define tss_update_io_bitmap native_tss_update_io_bitmap
+#endif
+
 #else
 static inline void io_bitmap_share(struct task_struct *tsk) { }
 static inline void io_bitmap_exit(void) { }
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 86e7317eb31f..694d8daf4983 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -295,6 +295,13 @@ static inline void write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
 	PVOP_VCALL3(cpu.write_idt_entry, dt, entry, g);
 }
 
+#ifdef CONFIG_X86_IOPL_IOPERM
+static inline void tss_update_io_bitmap(void)
+{
+	PVOP_VCALL0(cpu.update_io_bitmap);
+}
+#endif
+
 static inline void paravirt_activate_mm(struct mm_struct *prev,
 					struct mm_struct *next)
 {
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 84812964d3dd..732f62e04ddb 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -140,6 +140,10 @@ struct pv_cpu_ops {
 
 	void (*load_sp0)(unsigned long sp0);
 
+#ifdef CONFIG_X86_IOPL_IOPERM
+	void (*update_io_bitmap)(void);
+#endif
+
 	void (*wbinvd)(void);
 
 	/* cpuid emulation, mostly so that caps bits can be disabled */
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 789f5e4f89de..c131ba4e70ef 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -30,6 +30,7 @@
 #include <asm/timer.h>
 #include <asm/special_insns.h>
 #include <asm/tlb.h>
+#include <asm/io_bitmap.h>
 
 /*
  * nop stub, which must not clobber anything *including the stack* to
@@ -341,6 +342,10 @@ struct paravirt_patch_template pv_ops = {
 	.cpu.iret		= native_iret,
 	.cpu.swapgs		= native_swapgs,
 
+#ifdef CONFIG_X86_IOPL_IOPERM
+	.cpu.update_io_bitmap	= native_tss_update_io_bitmap,
+#endif
+
 	.cpu.start_context_switch	= paravirt_nop,
 	.cpu.end_context_switch		= paravirt_nop,
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 839b5244e3b7..3053c85e0e42 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -374,7 +374,7 @@ static void tss_copy_io_bitmap(struct tss_struct *tss, struct io_bitmap *iobm)
 /**
  * tss_update_io_bitmap - Update I/O bitmap before exiting to usermode
  */
-void tss_update_io_bitmap(void)
+void native_tss_update_io_bitmap(void)
 {
 	struct tss_struct *tss = this_cpu_ptr(&cpu_tss_rw);
 	struct thread_struct *t = &current->thread;
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 1f756ffffe8b..feaf2e68ee5c 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -72,6 +72,9 @@
 #include <asm/mwait.h>
 #include <asm/pci_x86.h>
 #include <asm/cpu.h>
+#ifdef CONFIG_X86_IOPL_IOPERM
+#include <asm/io_bitmap.h>
+#endif
 
 #ifdef CONFIG_ACPI
 #include <linux/acpi.h>
@@ -837,6 +840,25 @@ static void xen_load_sp0(unsigned long sp0)
 	this_cpu_write(cpu_tss_rw.x86_tss.sp0, sp0);
 }
 
+#ifdef CONFIG_X86_IOPL_IOPERM
+static void xen_update_io_bitmap(void)
+{
+	struct physdev_set_iobitmap iobitmap;
+	struct tss_struct *tss = this_cpu_ptr(&cpu_tss_rw);
+
+	native_tss_update_io_bitmap();
+
+	iobitmap.bitmap = (uint8_t *)(&tss->x86_tss) +
+			  tss->x86_tss.io_bitmap_base;
+	if (tss->x86_tss.io_bitmap_base == IO_BITMAP_OFFSET_INVALID)
+		iobitmap.nr_ports = 0;
+	else
+		iobitmap.nr_ports = IO_BITMAP_BITS;
+
+	HYPERVISOR_physdev_op(PHYSDEVOP_set_iobitmap, &iobitmap);
+}
+#endif
+
 static void xen_io_delay(void)
 {
 }
@@ -1046,6 +1068,9 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.write_idt_entry = xen_write_idt_entry,
 	.load_sp0 = xen_load_sp0,
 
+#ifdef CONFIG_X86_IOPL_IOPERM
+	.update_io_bitmap = xen_update_io_bitmap,
+#endif
 	.io_delay = xen_io_delay,
 
 	/* Xen takes care of %gs when switching to usermode for us */
-- 
2.16.4

