Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3576627B33
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbiKNK6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236156AbiKNK6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:58:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2DBFC3
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16B62B80DE5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14444C433C1;
        Mon, 14 Nov 2022 10:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668423525;
        bh=rvFLXx+PaCRNjfqxm/WXfaSbvDlSsn6aFt0NXV+vUhQ=;
        h=Subject:To:Cc:From:Date:From;
        b=JmzgBNcyGFswJPDxykUq0VPv4YfvzOzOSNKQYzVX7vwDq0rQfJhvAGP3Ho9BhLDDR
         cKOIiL8xZuw4Kl8P5WI+QTyGSSjDjoCKOuw6DmactoaoOSEaZMsGcXLhFODBYX3fjl
         R73aLjK/3ZMXLRlB4zFHS0nLhhQzbnXETgXaLXlw=
Subject: FAILED: patch "[PATCH] KVM: x86: use a separate asm-offsets.c file" failed to apply to 5.15-stable tree
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 11:58:37 +0100
Message-ID: <166842351793119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

debc5a1ec0d1 ("KVM: x86: use a separate asm-offsets.c file")
bb06650634d3 ("KVM: VMX: Convert launched argument to flags")
8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()")
527a534c7326 ("x86/tdx: Provide common base for SEAMCALL and TDCALL C wrappers")
59bd54a84d15 ("x86/tdx: Detect running as a TDX guest in early boot")
6198311093da ("x86/cc: Move arch/x86/{kernel/cc_platform.c => coco/core.c}")
f94909ceb1ed ("x86: Prepare asm files for straight-line-speculation")
22da5a07c75e ("x86/lib/atomic64_386_32: Rename things")
1367afaa2ee9 ("x86/entry: Use the correct fence macro after swapgs in kernel CR3")
c07e45553da1 ("x86/entry: Add a fence for kernel entry SWAPGS in paranoid_entry()")
6e5772c8d9cf ("Merge tag 'x86_cc_for_v5.16_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From debc5a1ec0d195ffea70d11efeffb713de9fdbc7 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 8 Nov 2022 09:44:53 +0100
Subject: [PATCH] KVM: x86: use a separate asm-offsets.c file

This already removes an ugly #include "" from asm-offsets.c, but
especially it avoids a future error when trying to define asm-offsets
for KVM's svm/svm.h header.

This would not work for kernel/asm-offsets.c, because svm/svm.h
includes kvm_cache_regs.h which is not in the include path when
compiling asm-offsets.c.  The problem is not there if the .c file is
in arch/x86/kvm.

Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index cb50589a7102..437308004ef2 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -19,7 +19,6 @@
 #include <asm/suspend.h>
 #include <asm/tlbflush.h>
 #include <asm/tdx.h>
-#include "../kvm/vmx/vmx.h"
 
 #ifdef CONFIG_XEN
 #include <xen/interface/xen.h>
@@ -108,9 +107,4 @@ static void __used common(void)
 	OFFSET(TSS_sp0, tss_struct, x86_tss.sp0);
 	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
 	OFFSET(TSS_sp2, tss_struct, x86_tss.sp2);
-
-	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
-		BLANK();
-		OFFSET(VMX_spec_ctrl, vcpu_vmx, spec_ctrl);
-	}
 }
diff --git a/arch/x86/kvm/.gitignore b/arch/x86/kvm/.gitignore
new file mode 100644
index 000000000000..615d6ff35c00
--- /dev/null
+++ b/arch/x86/kvm/.gitignore
@@ -0,0 +1,2 @@
+/kvm-asm-offsets.s
+/kvm-asm-offsets.h
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 30f244b64523..a02cf9baacc8 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -34,3 +34,12 @@ endif
 obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
 obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
+
+AFLAGS_vmx/vmenter.o    := -iquote $(obj)
+$(obj)/vmx/vmenter.o: $(obj)/kvm-asm-offsets.h
+
+$(obj)/kvm-asm-offsets.h: $(obj)/kvm-asm-offsets.s FORCE
+	$(call filechk,offsets,__KVM_ASM_OFFSETS_H__)
+
+targets += kvm-asm-offsets.s
+clean-files += kvm-asm-offsets.h
diff --git a/arch/x86/kvm/kvm-asm-offsets.c b/arch/x86/kvm/kvm-asm-offsets.c
new file mode 100644
index 000000000000..9d84f2b32d7f
--- /dev/null
+++ b/arch/x86/kvm/kvm-asm-offsets.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generate definitions needed by assembly language modules.
+ * This code generates raw asm output which is post-processed to extract
+ * and format the required data.
+ */
+#define COMPILE_OFFSETS
+
+#include <linux/kbuild.h>
+#include "vmx/vmx.h"
+
+static void __used common(void)
+{
+	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
+		BLANK();
+		OFFSET(VMX_spec_ctrl, vcpu_vmx, spec_ctrl);
+	}
+}
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 8477d8bdd69c..0b5db4de4d09 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -1,12 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/linkage.h>
 #include <asm/asm.h>
-#include <asm/asm-offsets.h>
 #include <asm/bitsperlong.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
 #include <asm/percpu.h>
 #include <asm/segment.h>
+#include "kvm-asm-offsets.h"
 #include "run_flags.h"
 
 #define WORD_SIZE (BITS_PER_LONG / 8)

