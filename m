Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B53F662
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbfD3LrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730629AbfD3Lq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE3F721783;
        Tue, 30 Apr 2019 11:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624818;
        bh=5vTVgx5rzCtrmNgVqwNFZgnPXSr7nJIQmp1UOJVDO8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8Ac3gQbGy5DiDnBGzU+/5EWIR/r4U8IxNCZNkFWT15Swl99WRIvNCauXpLsOmoXZ
         +sEJ+vxUioE6wnCCWMryl+bDdn9pxn04fwnJRrbwGqFbWSMS6TDSmapM0GH1Dp7XVA
         iUViE3wPrFBYlLEofzZiZoL18/qgjDVqgiNZk07Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Borislav Petkov <bp@suse.de>, Rik van Riel <riel@surriel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kvm ML <kvm@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>, x86-ml <x86@kernel.org>
Subject: [PATCH 4.19 083/100] x86/fpu: Dont export __kernel_fpu_{begin,end}()
Date:   Tue, 30 Apr 2019 13:38:52 +0200
Message-Id: <20190430113612.682532449@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 12209993e98c5fa1855c467f22a24e3d5b8be205 upstream.

There is one user of __kernel_fpu_begin() and before invoking it,
it invokes preempt_disable(). So it could invoke kernel_fpu_begin()
right away. The 32bit version of arch_efi_call_virt_setup() and
arch_efi_call_virt_teardown() does this already.

The comment above *kernel_fpu*() claims that before invoking
__kernel_fpu_begin() preemption should be disabled and that KVM is a
good example of doing it. Well, KVM doesn't do that since commit

  f775b13eedee2 ("x86,kvm: move qemu/guest FPU switching out to vcpu_run")

so it is not an example anymore.

With EFI gone as the last user of __kernel_fpu_{begin|end}(), both can
be made static and not exported anymore.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Rik van Riel <riel@surriel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nicolai Stange <nstange@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm ML <kvm@vger.kernel.org>
Cc: linux-efi <linux-efi@vger.kernel.org>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20181129150210.2k4mawt37ow6c2vq@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/efi.h     |    6 ++----
 arch/x86/include/asm/fpu/api.h |   15 +++++----------
 arch/x86/kernel/fpu/core.c     |    6 ++----
 3 files changed, 9 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -82,8 +82,7 @@ struct efi_scratch {
 #define arch_efi_call_virt_setup()					\
 ({									\
 	efi_sync_low_kernel_mappings();					\
-	preempt_disable();						\
-	__kernel_fpu_begin();						\
+	kernel_fpu_begin();						\
 	firmware_restrict_branch_speculation_start();			\
 									\
 	if (!efi_enabled(EFI_OLD_MEMMAP))				\
@@ -99,8 +98,7 @@ struct efi_scratch {
 		efi_switch_mm(efi_scratch.prev_mm);			\
 									\
 	firmware_restrict_branch_speculation_end();			\
-	__kernel_fpu_end();						\
-	preempt_enable();						\
+	kernel_fpu_end();						\
 })
 
 extern void __iomem *__init efi_ioremap(unsigned long addr, unsigned long size,
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -12,17 +12,12 @@
 #define _ASM_X86_FPU_API_H
 
 /*
- * Careful: __kernel_fpu_begin/end() must be called with preempt disabled
- * and they don't touch the preempt state on their own.
- * If you enable preemption after __kernel_fpu_begin(), preempt notifier
- * should call the __kernel_fpu_end() to prevent the kernel/user FPU
- * state from getting corrupted. KVM for example uses this model.
- *
- * All other cases use kernel_fpu_begin/end() which disable preemption
- * during kernel FPU usage.
+ * Use kernel_fpu_begin/end() if you intend to use FPU in kernel context. It
+ * disables preemption so be careful if you intend to use it for long periods
+ * of time.
+ * If you intend to use the FPU in softirq you need to check first with
+ * irq_fpu_usable() if it is possible.
  */
-extern void __kernel_fpu_begin(void);
-extern void __kernel_fpu_end(void);
 extern void kernel_fpu_begin(void);
 extern void kernel_fpu_end(void);
 extern bool irq_fpu_usable(void);
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -93,7 +93,7 @@ bool irq_fpu_usable(void)
 }
 EXPORT_SYMBOL(irq_fpu_usable);
 
-void __kernel_fpu_begin(void)
+static void __kernel_fpu_begin(void)
 {
 	struct fpu *fpu = &current->thread.fpu;
 
@@ -111,9 +111,8 @@ void __kernel_fpu_begin(void)
 		__cpu_invalidate_fpregs_state();
 	}
 }
-EXPORT_SYMBOL(__kernel_fpu_begin);
 
-void __kernel_fpu_end(void)
+static void __kernel_fpu_end(void)
 {
 	struct fpu *fpu = &current->thread.fpu;
 
@@ -122,7 +121,6 @@ void __kernel_fpu_end(void)
 
 	kernel_fpu_enable();
 }
-EXPORT_SYMBOL(__kernel_fpu_end);
 
 void kernel_fpu_begin(void)
 {


