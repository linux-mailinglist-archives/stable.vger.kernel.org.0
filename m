Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FAE1713D2
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgB0JNx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:13:53 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:58455 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728555AbgB0JNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:13:52 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 96C1B753;
        Thu, 27 Feb 2020 04:13:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:13:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LLMw79
        qbYowAsYrDqz4OGOtmmy8kK/qm+hd7UqAC9fA=; b=F6V/TPVtm3DamqYkl7RdD2
        43B6RZ0vzSiHVPjLp6qG8spTPqwFStIBceLMuoD488XBHedr41YTswMnIyqo/zcI
        qtagJgsaiLZ+JF26HA1a8ZskKOwM0Cy5V61RMbmTjaVqEnDIY37LDvleMDCzFdBz
        OcJYDfkykrj7NpwnyGDKEobgj5THOwmCUG/R5H0Qjjbj1dLNvXJ/Nj5Mw6PcpJ//
        vF54P4GcBWa+8JU+BjraBV24dSE2RLi1MS3OoO4WaFKt2fGLl8BiGyQpBSLtU2fW
        NAuRzjKWK1H2FVxls2EH7VUKIKUFAjxt0siV5KGLpRQw2EMJ+r/sZZINkknIFKjA
        ==
X-ME-Sender: <xms:TohXXirw3NDP-Z3YqAgKqyKRI8dvLuINPdn_E7QWDlPw4CqEuV35Pg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:TohXXqEz0e2XTtZUgpIXFhh98WeHz_0KEXRaCkBgETjcz5koM2dp1g>
    <xmx:TohXXmzvd7utzBXafeZdzghxNmurHCpSL4w_R9JdvPGHJZqx55iQpA>
    <xmx:TohXXnoMp3o5C0-MncByui1wtf3RfyG0J7oz2MhBPD_JTq9Vb2oCng>
    <xmx:T4hXXgQWAWvOhjfTY92j_x66y0q8cfnDib56dHzUgTQ-MoZmRPYRVg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 930B23060F09;
        Thu, 27 Feb 2020 04:13:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: nVMX: handle nested posted interrupts when apicv is" failed to apply to 4.9-stable tree
To:     vkuznets@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:13:48 +0100
Message-ID: <1582794828129242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 91a5f413af596ad01097e59bf487eb07cb3f1331 Mon Sep 17 00:00:00 2001
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Thu, 20 Feb 2020 18:22:05 +0100
Subject: [PATCH] KVM: nVMX: handle nested posted interrupts when apicv is
 disabled for L1

Even when APICv is disabled for L1 it can (and, actually, is) still
available for L2, this means we need to always call
vmx_deliver_nested_posted_interrupt() when attempting an interrupt
delivery.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 40a0c0fd95ca..a84e8c5acda8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1146,7 +1146,7 @@ struct kvm_x86_ops {
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu, hpa_t hpa);
-	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
+	int (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index afcd30d44cbb..cc8ee8125712 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1046,11 +1046,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 						       apic->regs + APIC_TMR);
 		}
 
-		if (vcpu->arch.apicv_active)
-			kvm_x86_ops->deliver_posted_interrupt(vcpu, vector);
-		else {
+		if (kvm_x86_ops->deliver_posted_interrupt(vcpu, vector)) {
 			kvm_lapic_set_irr(vector, apic);
-
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 			kvm_vcpu_kick(vcpu);
 		}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a391b29138f0..8787a123b8e7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5258,8 +5258,11 @@ static void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	return;
 }
 
-static void svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
+static int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 {
+	if (!vcpu->arch.apicv_active)
+		return -1;
+
 	kvm_lapic_set_irr(vec, vcpu->arch.apic);
 	smp_mb__after_atomic();
 
@@ -5271,6 +5274,8 @@ static void svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 		put_cpu();
 	} else
 		kvm_vcpu_wake_up(vcpu);
+
+	return 0;
 }
 
 static bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dafe4df893c8..63ccc435a602 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3822,24 +3822,29 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
  * 2. If target vcpu isn't running(root mode), kick it to pick up the
  * interrupt from PIR in next vmentry.
  */
-static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
+static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int r;
 
 	r = vmx_deliver_nested_posted_interrupt(vcpu, vector);
 	if (!r)
-		return;
+		return 0;
+
+	if (!vcpu->arch.apicv_active)
+		return -1;
 
 	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
-		return;
+		return 0;
 
 	/* If a previous notification has sent the IPI, nothing to do.  */
 	if (pi_test_and_set_on(&vmx->pi_desc))
-		return;
+		return 0;
 
 	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
 		kvm_vcpu_kick(vcpu);
+
+	return 0;
 }
 
 /*

