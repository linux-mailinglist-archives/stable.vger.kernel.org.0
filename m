Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BC06280AF
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbiKNNIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237861AbiKNNIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:08:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FCD2AC7C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:08:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C103061173
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FA4C433D6;
        Mon, 14 Nov 2022 13:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431283;
        bh=j0CBVM0NEJ4jCmfmmPAJQWMEI8JBWgm+6yDckYBrbLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qm4nvgAvqGQfH3aBYKhz+dmzBg6js6BAIS7Cp968USeoakkG49ctoNvoIK+oYtWAq
         Dr4RcOGeapdM8VVWomBKBUM4yn2ZQAHzGWqQrcjlZK+o+ygYzvC2Kg5j/Y/GhBixzm
         89pb29b1gCHXxn1rbKgJmpkKbxNgSPoA9kCFS1T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 167/190] KVM: x86: use a separate asm-offsets.c file
Date:   Mon, 14 Nov 2022 13:46:31 +0100
Message-Id: <20221114124506.146730832@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit debc5a1ec0d195ffea70d11efeffb713de9fdbc7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/asm-offsets.c  |    6 ------
 arch/x86/kvm/.gitignore        |    2 ++
 arch/x86/kvm/Makefile          |    9 +++++++++
 arch/x86/kvm/kvm-asm-offsets.c |   18 ++++++++++++++++++
 arch/x86/kvm/vmx/vmenter.S     |    2 +-
 5 files changed, 30 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kvm/.gitignore
 create mode 100644 arch/x86/kvm/kvm-asm-offsets.c

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
--- /dev/null
+++ b/arch/x86/kvm/.gitignore
@@ -0,0 +1,2 @@
+/kvm-asm-offsets.s
+/kvm-asm-offsets.h
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


