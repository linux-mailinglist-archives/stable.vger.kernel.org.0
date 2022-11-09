Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E36622E7C
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 15:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiKIOy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 09:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiKIOyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 09:54:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DF91C429
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 06:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668005524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5gQroWF+Ry5WJmQE3/wfDXwimkNpE9ZNMNdQ9MXPy2Q=;
        b=K8GIr/IfAoi4oK3BQ+C/6woMXWrASYqkY9qHxny7Wk9pobmpa8tp8+9wK30gZGjQwyo2iA
        I/ZzphZbDQBT+QOMJZrmSRgMoab0kxwBXliVpl4I/J64O/6rsogyMlKaC+QbHqKll0DBN7
        Trif450sOTBEbx+703FFBI7L+z1U2pc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-B05BQmZFP6W3-2Ji-l47PA-1; Wed, 09 Nov 2022 09:51:58 -0500
X-MC-Unique: B05BQmZFP6W3-2Ji-l47PA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC83881B900;
        Wed,  9 Nov 2022 14:51:57 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ECB01401C2E;
        Wed,  9 Nov 2022 14:51:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com, jmattson@google.com, seanjc@google.com,
        stable@vger.kernel.org
Subject: [PATCH 01/11] KVM: x86: use a separate asm-offsets.c file
Date:   Wed,  9 Nov 2022 09:51:46 -0500
Message-Id: <20221109145156.84714-2-pbonzini@redhat.com>
In-Reply-To: <20221109145156.84714-1-pbonzini@redhat.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This already removes the ugly #includes from asm-offsets.c, but especially
it avoids a future error when asm-offsets will try to include svm/svm.h.

This would not work for kernel/asm-offsets.c, because svm/svm.h
includes kvm_cache_regs.h which is not in the include path when
compiling asm-offsets.c.  The problem is not there if the .c file is
in arch/x86/kvm.

Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/asm-offsets.c  |  6 ------
 arch/x86/kvm/.gitignore        |  2 ++
 arch/x86/kvm/Makefile          |  9 +++++++++
 arch/x86/kvm/kvm-asm-offsets.c | 18 ++++++++++++++++++
 arch/x86/kvm/vmx/vmenter.S     |  2 +-
 5 files changed, 30 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/kvm/.gitignore
 create mode 100644 arch/x86/kvm/kvm-asm-offsets.c

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
-- 
2.31.1


