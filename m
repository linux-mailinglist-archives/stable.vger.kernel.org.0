Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F80117202A
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731400AbgB0Nv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:51:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730900AbgB0Nv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:51:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFEBC20801;
        Thu, 27 Feb 2020 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811487;
        bh=EliFeSDdMi0mT5wTIYtel+ZW30wkztJxSnJZo/GF23g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDrquzMOhEm5IZFihMFXEn+TrO/Dl1SR2PNSJI975m5zWTVulcF+vHHhkYCXrZJeT
         dtTAuKHHQ/Rznh+7C9/ySa6YzJ+bVDIHelY0JZQQcDlkrbdTPCsDR5L+DITAGMThwn
         drPpm+meZr+V9G2EYnNC0PGYixvWrdW95JRZYrAg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 151/165] KVM: nVMX: Check IO instruction VM-exit conditions
Date:   Thu, 27 Feb 2020 14:37:05 +0100
Message-Id: <20200227132252.780927083@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

commit 35a571346a94fb93b5b3b6a599675ef3384bc75c upstream.

Consult the 'unconditional IO exiting' and 'use IO bitmaps' VM-execution
controls when checking instruction interception. If the 'use IO bitmaps'
VM-execution control is 1, check the instruction access against the IO
bitmaps to determine if the instruction causes a VM-exit.

Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4647,7 +4647,7 @@ static bool nested_vmx_exit_handled_io(s
 				       struct vmcs12 *vmcs12)
 {
 	unsigned long exit_qualification;
-	unsigned int port;
+	unsigned short port;
 	int size;
 
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
@@ -11349,6 +11349,39 @@ static void nested_vmx_entry_failure(str
 		to_vmx(vcpu)->nested.sync_shadow_vmcs = true;
 }
 
+static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
+				  struct x86_instruction_info *info)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	unsigned short port;
+	bool intercept;
+	int size;
+
+	if (info->intercept == x86_intercept_in ||
+	    info->intercept == x86_intercept_ins) {
+		port = info->src_val;
+		size = info->dst_bytes;
+	} else {
+		port = info->dst_val;
+		size = info->src_bytes;
+	}
+
+	/*
+	 * If the 'use IO bitmaps' VM-execution control is 0, IO instruction
+	 * VM-exits depend on the 'unconditional IO exiting' VM-execution
+	 * control.
+	 *
+	 * Otherwise, IO instruction VM-exits are controlled by the IO bitmaps.
+	 */
+	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
+		intercept = nested_cpu_has(vmcs12,
+					   CPU_BASED_UNCOND_IO_EXITING);
+	else
+		intercept = nested_vmx_check_io_bitmaps(vcpu, port, size);
+
+	return intercept ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
+}
+
 static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage)
@@ -11356,18 +11389,30 @@ static int vmx_check_intercept(struct kv
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 
+	switch (info->intercept) {
 	/*
 	 * RDPID causes #UD if disabled through secondary execution controls.
 	 * Because it is marked as EmulateOnUD, we need to intercept it here.
 	 */
-	if (info->intercept == x86_intercept_rdtscp &&
-	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_RDTSCP)) {
-		ctxt->exception.vector = UD_VECTOR;
-		ctxt->exception.error_code_valid = false;
-		return X86EMUL_PROPAGATE_FAULT;
-	}
+	case x86_intercept_rdtscp:
+		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_RDTSCP)) {
+			ctxt->exception.vector = UD_VECTOR;
+			ctxt->exception.error_code_valid = false;
+			return X86EMUL_PROPAGATE_FAULT;
+		}
+		break;
+
+	case x86_intercept_in:
+	case x86_intercept_ins:
+	case x86_intercept_out:
+	case x86_intercept_outs:
+		return vmx_check_intercept_io(vcpu, info);
 
 	/* TODO: check more intercepts... */
+	default:
+		break;
+	}
+
 	return X86EMUL_UNHANDLEABLE;
 }
 


