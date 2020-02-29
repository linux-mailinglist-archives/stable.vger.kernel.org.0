Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9BB6174696
	for <lists+stable@lfdr.de>; Sat, 29 Feb 2020 12:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgB2LtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Feb 2020 06:49:21 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39029 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgB2LtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Feb 2020 06:49:21 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1j80cN-0007dh-RX; Sat, 29 Feb 2020 12:49:16 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id E69371C219B;
        Sat, 29 Feb 2020 12:49:13 +0100 (CET)
Date:   Sat, 29 Feb 2020 11:49:13 -0000
From:   "tip-bot2 for Juergen Gross" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/ioperm: Add new paravirt function update_io_bitmap()
Cc:     Jan Beulich <jbeulich@suse.com>, Juergen Gross <jgross@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>, <stable@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200218154712.25490-1-jgross@suse.com>
References: <20200218154712.25490-1-jgross@suse.com>
MIME-Version: 1.0
Message-ID: <158297695368.28353.16098971826744165928.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     99bcd4a6e5b8ba201fdd252f1054689884899fee
Gitweb:        https://git.kernel.org/tip/99bcd4a6e5b8ba201fdd252f1054689884899fee
Author:        Juergen Gross <jgross@suse.com>
AuthorDate:    Tue, 18 Feb 2020 16:47:12 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 29 Feb 2020 12:43:09 +01:00

x86/ioperm: Add new paravirt function update_io_bitmap()

Commit 111e7b15cf10f6 ("x86/ioperm: Extend IOPL config to control ioperm()
as well") reworked the iopl syscall to use I/O bitmaps.

Unfortunately this broke Xen PV domains using that syscall as there is
currently no I/O bitmap support in PV domains.

Add I/O bitmap support via a new paravirt function update_io_bitmap which
Xen PV domains can use to update their I/O bitmaps via a hypercall.

Fixes: 111e7b15cf10f6 ("x86/ioperm: Extend IOPL config to control ioperm() as well")
Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Cc: <stable@vger.kernel.org> # 5.5
Link: https://lkml.kernel.org/r/20200218154712.25490-1-jgross@suse.com

---
 arch/x86/include/asm/io_bitmap.h      |  9 ++++++++-
 arch/x86/include/asm/paravirt.h       |  7 +++++++
 arch/x86/include/asm/paravirt_types.h |  4 ++++
 arch/x86/kernel/paravirt.c            |  5 +++++
 arch/x86/kernel/process.c             |  2 +-
 arch/x86/xen/enlighten_pv.c           | 25 +++++++++++++++++++++++++
 6 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/io_bitmap.h b/arch/x86/include/asm/io_bitmap.h
index 02c6ef8..07344d8 100644
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
index 86e7317..694d8da 100644
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
index 8481296..732f62e 100644
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
index 789f5e4..c131ba4 100644
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
index 839b524..3053c85 100644
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
index 7940912..507f4fb 100644
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
@@ -1047,6 +1069,9 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.write_idt_entry = xen_write_idt_entry,
 	.load_sp0 = xen_load_sp0,
 
+#ifdef CONFIG_X86_IOPL_IOPERM
+	.update_io_bitmap = xen_update_io_bitmap,
+#endif
 	.io_delay = xen_io_delay,
 
 	/* Xen takes care of %gs when switching to usermode for us */
