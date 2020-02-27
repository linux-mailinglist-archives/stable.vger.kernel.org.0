Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B65171E31
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388533AbgB0OK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388515AbgB0OKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:10:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6BE324656;
        Thu, 27 Feb 2020 14:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812622;
        bh=UtbNHMfivaE4luTQYXgsVskieXTbGxyFGjSorfKG0HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mCYEVzNuVwUqFGqilIPOKuzOrEi/LAQwE1BRIsOikAtdLRmAzqL3MVQk55MwQKtyB
         2foB+inxkwWIL3ztm5+oSmZqO593Pe5vH47TCpg3E5+AWLvaRl5jYqX42FR3EQ1j6e
         oI3fUpoFChkcu/wR0FMy38yLT4Z3420Yl4Od3s9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 088/135] KVM: nVMX: Check IO instruction VM-exit conditions
Date:   Thu, 27 Feb 2020 14:37:08 +0100
Message-Id: <20200227132242.560559525@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
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
 arch/x86/kvm/vmx/nested.c |    2 -
 arch/x86/kvm/vmx/vmx.c    |   57 +++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 52 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5173,7 +5173,7 @@ static bool nested_vmx_exit_handled_io(s
 				       struct vmcs12 *vmcs12)
 {
 	unsigned long exit_qualification;
-	unsigned int port;
+	unsigned short port;
 	int size;
 
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7132,6 +7132,39 @@ static void vmx_request_immediate_exit(s
 	to_vmx(vcpu)->req_immediate_exit = true;
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
@@ -7139,18 +7172,30 @@ static int vmx_check_intercept(struct kv
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
 


