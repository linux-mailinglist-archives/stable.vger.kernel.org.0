Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2070C226825
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbgGTQPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388025AbgGTQP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:15:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFCCA20656;
        Mon, 20 Jul 2020 16:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261727;
        bh=1Ff/nLzw5R7Lbjoxt3PMZ3q82rz7aPx4eBnyhDojGtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qnd9Tbg/9uvDSzgIC6+rRQ+3Y1fDxre1ZRgSRCz4oul2fU+det0r8DVPyhGSc/+0/
         Sdu+1DgQoYC8ScLYzoBl0K25XimWmehYU9ymeJ20v12LQqDTG3tlbt7ws7q1MsUtF+
         bf66ytycCgaly6VSPIf9aVsZoA+HwkRiiWBhYF+8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.7 221/244] x86/ioperm: Fix io bitmap invalidation on Xen PV
Date:   Mon, 20 Jul 2020 17:38:12 +0200
Message-Id: <20200720152836.362435840@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

commit cadfad870154e14f745ec845708bc17d166065f2 upstream.

tss_invalidate_io_bitmap() wasn't wired up properly through the pvop
machinery, so the TSS and Xen's io bitmap would get out of sync
whenever disabling a valid io bitmap.

Add a new pvop for tss_invalidate_io_bitmap() to fix it.

This is XSA-329.

Fixes: 22fe5b0439dd ("x86/ioperm: Move TSS bitmap update to exit to user work")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/d53075590e1f91c19f8af705059d3ff99424c020.1595030016.git.luto@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/io_bitmap.h      |   16 ++++++++++++++++
 arch/x86/include/asm/paravirt.h       |    5 +++++
 arch/x86/include/asm/paravirt_types.h |    1 +
 arch/x86/kernel/paravirt.c            |    3 ++-
 arch/x86/kernel/process.c             |   18 ++----------------
 arch/x86/xen/enlighten_pv.c           |   12 ++++++++++++
 6 files changed, 38 insertions(+), 17 deletions(-)

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
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -296,6 +296,11 @@ static inline void write_idt_entry(gate_
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
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -141,6 +141,7 @@ struct pv_cpu_ops {
 	void (*load_sp0)(unsigned long sp0);
 
 #ifdef CONFIG_X86_IOPL_IOPERM
+	void (*invalidate_io_bitmap)(void);
 	void (*update_io_bitmap)(void);
 #endif
 
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -343,7 +343,8 @@ struct paravirt_patch_template pv_ops =
 	.cpu.swapgs		= native_swapgs,
 
 #ifdef CONFIG_X86_IOPL_IOPERM
-	.cpu.update_io_bitmap	= native_tss_update_io_bitmap,
+	.cpu.invalidate_io_bitmap	= native_tss_invalidate_io_bitmap,
+	.cpu.update_io_bitmap		= native_tss_update_io_bitmap,
 #endif
 
 	.cpu.start_context_switch	= paravirt_nop,
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
@@ -346,7 +332,7 @@ static inline void switch_to_bitmap(unsi
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
 
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -841,6 +841,17 @@ static void xen_load_sp0(unsigned long s
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
@@ -1070,6 +1081,7 @@ static const struct pv_cpu_ops xen_cpu_o
 	.load_sp0 = xen_load_sp0,
 
 #ifdef CONFIG_X86_IOPL_IOPERM
+	.invalidate_io_bitmap = xen_invalidate_io_bitmap,
 	.update_io_bitmap = xen_update_io_bitmap,
 #endif
 	.io_delay = xen_io_delay,


