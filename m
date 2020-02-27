Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B394171D92
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388234AbgB0OQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389570AbgB0OQo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:16:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 618AC24690;
        Thu, 27 Feb 2020 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813003;
        bh=fIbIHdKoVC8BBdOOAk/IjBOIaUu4oAJVa3qmLISHSLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ss/F/55kpQg/cTnEzZkjZ+UzUIs+Xw21QL/jHg7Gi/T4f2wp+FF+Z6iVGFCS30/dM
         Dh+QJqlkdRDyYlHfMaw6IerMpCNpMXy/2qCfCWgYBn+hvMRksZ7t7sqMquwE4rwDhZ
         hxk1rr5N2vgezk1ySi/5f2aqt1jsTMB6U2Brgfyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 098/150] KVM: nVMX: Refactor IO bitmap checks into helper function
Date:   Thu, 27 Feb 2020 14:37:15 +0100
Message-Id: <20200227132247.321902030@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

commit e71237d3ff1abf9f3388337cfebf53b96df2020d upstream.

Checks against the IO bitmap are useful for both instruction emulation
and VM-exit reflection. Refactor the IO bitmap checks into a helper
function.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |   39 +++++++++++++++++++++++++--------------
 arch/x86/kvm/vmx/nested.h |    2 ++
 2 files changed, 27 insertions(+), 14 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5304,24 +5304,17 @@ fail:
 	return 1;
 }
 
-
-static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
-				       struct vmcs12 *vmcs12)
+/*
+ * Return true if an IO instruction with the specified port and size should cause
+ * a VM-exit into L1.
+ */
+bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
+				 int size)
 {
-	unsigned long exit_qualification;
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	gpa_t bitmap, last_bitmap;
-	unsigned int port;
-	int size;
 	u8 b;
 
-	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
-		return nested_cpu_has(vmcs12, CPU_BASED_UNCOND_IO_EXITING);
-
-	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
-
-	port = exit_qualification >> 16;
-	size = (exit_qualification & 7) + 1;
-
 	last_bitmap = (gpa_t)-1;
 	b = -1;
 
@@ -5348,6 +5341,24 @@ static bool nested_vmx_exit_handled_io(s
 	return false;
 }
 
+static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
+				       struct vmcs12 *vmcs12)
+{
+	unsigned long exit_qualification;
+	unsigned int port;
+	int size;
+
+	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
+		return nested_cpu_has(vmcs12, CPU_BASED_UNCOND_IO_EXITING);
+
+	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+
+	port = exit_qualification >> 16;
+	size = (exit_qualification & 7) + 1;
+
+	return nested_vmx_check_io_bitmaps(vcpu, port, size);
+}
+
 /*
  * Return 1 if we should exit from L2 to L1 to handle an MSR access access,
  * rather than handle it ourselves in L0. I.e., check whether L1 expressed
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -34,6 +34,8 @@ int vmx_get_vmx_msr(struct nested_vmx_ms
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
 void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
+bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
+				 int size);
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 {


