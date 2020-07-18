Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F96224AA2
	for <lists+stable@lfdr.de>; Sat, 18 Jul 2020 12:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgGRKc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jul 2020 06:32:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46418 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGRKc7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jul 2020 06:32:59 -0400
Date:   Sat, 18 Jul 2020 10:32:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595068376;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymd8qYWaEdTTftBfZmoWaKrPhR1IfPBGgx9wCBkgyHE=;
        b=du6QDH8A6ETSLW6R0jB8LCZJSTRS69Ngrg3eOccUiMHWuV4M7M9HI29Jq9pD15bTZx9DGz
        PzdASszTDxz5PN2UM65rMQNTVGSU2G7JqjLBQxG77XDwUHn5GWDqeBWpMRrzwG2G9l1MhA
        zTaAGrPuBtUdoYhyvhexIVP3s5arjjyeWEFQXdC88CWx4SY0TkJYcYUFyYxSF7SnZHDzfe
        65nRcLriWGi1UrEjichWIDnRbmOKVEKuk6N3YAL2sRMabN0kLs3rnkdHcRQd81drr/7hSk
        fva03phQs1nxNDl4yN7D0t3q7vDXhVqTi40VUD3rBq0IjHgLyIXn0Ju2N+MprQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595068376;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymd8qYWaEdTTftBfZmoWaKrPhR1IfPBGgx9wCBkgyHE=;
        b=Wbac0Hawfcn5aHf+XE6x8bXSBsDJJrQIsreCdNgFqcRxx5VpO0O9UdT57w8LUuGfx2ioBu
        jrwGFysiUnHt+hBg==
From:   "tip-bot2 for Andy Lutomirski" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/ioperm: Fix io bitmap invalidation on Xen PV
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <d53075590e1f91c19f8af705059d3ff99424c020.1595030016.git.luto@kernel.org>
References: <d53075590e1f91c19f8af705059d3ff99424c020.1595030016.git.luto@kernel.org>
MIME-Version: 1.0
Message-ID: <159506837509.4006.13838291680032075449.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     cadfad870154e14f745ec845708bc17d166065f2
Gitweb:        https://git.kernel.org/tip/cadfad870154e14f745ec845708bc17d166065f2
Author:        Andy Lutomirski <luto@kernel.org>
AuthorDate:    Fri, 17 Jul 2020 16:53:55 -07:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Sat, 18 Jul 2020 12:31:49 +02:00

x86/ioperm: Fix io bitmap invalidation on Xen PV

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

---
 arch/x86/include/asm/io_bitmap.h      | 16 ++++++++++++++++
 arch/x86/include/asm/paravirt.h       |  5 +++++
 arch/x86/include/asm/paravirt_types.h |  1 +
 arch/x86/kernel/paravirt.c            |  3 ++-
 arch/x86/kernel/process.c             | 18 ++----------------
 arch/x86/xen/enlighten_pv.c           | 12 ++++++++++++
 6 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/io_bitmap.h b/arch/x86/include/asm/io_bitmap.h
index ac1a99f..7f080f5 100644
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
index 5ca5d29..3d2afec 100644
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
index 732f62e..8dfcb25 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -141,6 +141,7 @@ struct pv_cpu_ops {
 	void (*load_sp0)(unsigned long sp0);
 
 #ifdef CONFIG_X86_IOPL_IOPERM
+	void (*invalidate_io_bitmap)(void);
 	void (*update_io_bitmap)(void);
 #endif
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 674a7d6..de2138b 100644
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
index f362ce0..fe67dbd 100644
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
index 0d68948..c46b9f2 100644
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
