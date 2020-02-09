Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D19C156AAB
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgBINmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:42:04 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55505 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBINmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:42:04 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7B1CA21AF1;
        Sun,  9 Feb 2020 08:42:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:42:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3H+FWk
        8gvHjPIjdu8NfPT30z7KpgIXnDCHvFjCgxB3M=; b=VSdVssaHXID3qxNPUNo9KI
        rIvRNthUqpEIeO0P6XqwBOGuyf7nGCQZPFIfuwmJmh+rIexzDrItGla9GwThIi7n
        mLPt07+srf/xW439T7Xlk7mx7QcdmTudC1133zk+f6nRuFziBSP7VBkfuByAGqh8
        KUdSqosoD5xG0G4XzcZtVwl+izKavp5QLseb07sOXB5N9PD0n8GtQxIrxvmH0ekZ
        AjF98eKWaotZVV6juZyP/9MOd+b4CbXR0HXr6Efe7fZa1t9JxtWVtQediMm1JmpM
        pJMMD0DDw1Pj+bwDHfErilrKNE+PpqFJXtcqJHjo9gy25vdyQh0D9u22XB8c9sGw
        ==
X-ME-Sender: <xms:KwxAXpkH1QQXsojf3RrKz-F9vpxbhUktzGIU5cvaUD7W3KIzifyeag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepfeenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:KwxAXvqc9sRU514jr13-vciVAzZSx5xV0hZqAexqFw8n9cg3RjGVLw>
    <xmx:KwxAXlQ4A4JLXLamS-Z3rpu48B8l4gVpoEYoIqajMmnUEZJZu2jF0A>
    <xmx:KwxAXuUKEqXmnb-uFr1wOMTMuWNavD5nZbwFmIHiU_4R8KBfwMGjnw>
    <xmx:KwxAXgD_UBq_I6ELH9Az2TwEjrtR0w5lHYXfp-4f9YUCMst-Vhv9eg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2049F3060272;
        Sun,  9 Feb 2020 08:42:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: Protect exit_reason from being used in" failed to apply to 5.4-stable tree
To:     pomonis@google.com, ahonig@google.com, nifi@google.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:33:06 +0100
Message-ID: <1581251586200113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c926f2f7230b1a29e31914b51db680f8cbf3103f Mon Sep 17 00:00:00 2001
From: Marios Pomonis <pomonis@google.com>
Date: Wed, 11 Dec 2019 12:47:51 -0800
Subject: [PATCH] KVM: x86: Protect exit_reason from being used in
 Spectre-v1/L1TF attacks

This fixes a Spectre-v1/L1TF vulnerability in vmx_handle_exit().
While exit_reason is set by the hardware and therefore should not be
attacker-influenced, an unknown exit_reason could potentially be used to
perform such an attack.

Fixes: 55d2375e58a6 ("KVM: nVMX: Move nested code to dedicated files")

Signed-off-by: Marios Pomonis <pomonis@google.com>
Signed-off-by: Nick Finco <nifi@google.com>
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Andrew Honig <ahonig@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5415cd40678c..62fb639895c2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5913,34 +5913,41 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	if (exit_fastpath == EXIT_FASTPATH_SKIP_EMUL_INS) {
 		kvm_skip_emulated_instruction(vcpu);
 		return 1;
-	} else if (exit_reason < kvm_vmx_max_exit_handlers
-	    && kvm_vmx_exit_handlers[exit_reason]) {
+	}
+
+	if (exit_reason >= kvm_vmx_max_exit_handlers)
+		goto unexpected_vmexit;
 #ifdef CONFIG_RETPOLINE
-		if (exit_reason == EXIT_REASON_MSR_WRITE)
-			return kvm_emulate_wrmsr(vcpu);
-		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
-			return handle_preemption_timer(vcpu);
-		else if (exit_reason == EXIT_REASON_INTERRUPT_WINDOW)
-			return handle_interrupt_window(vcpu);
-		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
-			return handle_external_interrupt(vcpu);
-		else if (exit_reason == EXIT_REASON_HLT)
-			return kvm_emulate_halt(vcpu);
-		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
-			return handle_ept_misconfig(vcpu);
+	if (exit_reason == EXIT_REASON_MSR_WRITE)
+		return kvm_emulate_wrmsr(vcpu);
+	else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
+		return handle_preemption_timer(vcpu);
+	else if (exit_reason == EXIT_REASON_INTERRUPT_WINDOW)
+		return handle_interrupt_window(vcpu);
+	else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+		return handle_external_interrupt(vcpu);
+	else if (exit_reason == EXIT_REASON_HLT)
+		return kvm_emulate_halt(vcpu);
+	else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
+		return handle_ept_misconfig(vcpu);
 #endif
-		return kvm_vmx_exit_handlers[exit_reason](vcpu);
-	} else {
-		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
-				exit_reason);
-		dump_vmcs();
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror =
+
+	exit_reason = array_index_nospec(exit_reason,
+					 kvm_vmx_max_exit_handlers);
+	if (!kvm_vmx_exit_handlers[exit_reason])
+		goto unexpected_vmexit;
+
+	return kvm_vmx_exit_handlers[exit_reason](vcpu);
+
+unexpected_vmexit:
+	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n", exit_reason);
+	dump_vmcs();
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror =
 			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-		vcpu->run->internal.ndata = 1;
-		vcpu->run->internal.data[0] = exit_reason;
-		return 0;
-	}
+	vcpu->run->internal.ndata = 1;
+	vcpu->run->internal.data[0] = exit_reason;
+	return 0;
 }
 
 /*

