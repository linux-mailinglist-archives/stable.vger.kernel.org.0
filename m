Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016E050DE9E
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 13:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241718AbiDYLUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 07:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241695AbiDYLUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 07:20:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D0FAFB10
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 04:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B1C1611EA
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 11:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C967C385A4;
        Mon, 25 Apr 2022 11:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650885421;
        bh=koSAOTTMGMhi0eBtwz6nLTYE12Dd23fyWAdLN/Vwr/M=;
        h=Subject:To:Cc:From:Date:From;
        b=LwhxUe0WvVE1PBsZa3d7RZ7n3AGQpLRsGmWSqDrrRMvsTiae84t1s3uYKbcnv0pTt
         easdB7aPT+77r/jVkSPYe467/a8AbsVuGC0iIJ6heHpOUormTyJgeVG7xEFY+JRHxo
         ouQel7+foWKoQ23V6e5Y4lXbqJCDs92K46+QnIds=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Defer APICv updates while L2 is active until L1 is" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Apr 2022 13:16:50 +0200
Message-ID: <165088541045178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

From 7c69661e225cc484fbf44a0b99b56714a5241ae3 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 20 Apr 2022 01:37:30 +0000
Subject: [PATCH] KVM: nVMX: Defer APICv updates while L2 is active until L1 is
 active

Defer APICv updates that occur while L2 is active until nested VM-Exit,
i.e. until L1 regains control.  vmx_refresh_apicv_exec_ctrl() assumes L1
is active and (a) stomps all over vmcs02 and (b) neglects to ever updated
vmcs01.  E.g. if vmcs12 doesn't enable the TPR shadow for L2 (and thus no
APICv controls), L1 performs nested VM-Enter APICv inhibited, and APICv
becomes unhibited while L2 is active, KVM will set various APICv controls
in vmcs02 and trigger a failed VM-Entry.  The kicker is that, unless
running with nested_early_check=1, KVM blames L1 and chaos ensues.

In all cases, ignoring vmcs02 and always deferring the inhibition change
to vmcs01 is correct (or at least acceptable).  The ABSENT and DISABLE
inhibitions cannot truly change while L2 is active (see below).

IRQ_BLOCKING can change, but it is firmly a best effort debug feature.
Furthermore, only L2's APIC is accelerated/virtualized to the full extent
possible, e.g. even if L1 passes through its APIC to L2, normal MMIO/MSR
interception will apply to the virtual APIC managed by KVM.
The exception is the SELF_IPI register when x2APIC is enabled, but that's
an acceptable hole.

Lastly, Hyper-V's Auto EOI can technically be toggled if L1 exposes the
MSRs to L2, but for that to work in any sane capacity, L1 would need to
pass through IRQs to L2 as well, and IRQs must be intercepted to enable
virtual interrupt delivery.  I.e. exposing Auto EOI to L2 and enabling
VID for L2 are, for all intents and purposes, mutually exclusive.

Lack of dynamic toggling is also why this scenario is all but impossible
to encounter in KVM's current form.  But a future patch will pend an
APICv update request _during_ vCPU creation to plug a race where a vCPU
that's being created doesn't get included in the "all vCPUs request"
because it's not yet visible to other vCPUs.  If userspaces restores L2
after VM creation (hello, KVM selftests), the first KVM_RUN will occur
while L2 is active and thus service the APICv update request made during
VM creation.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220420013732.3308816-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f18744f7ff82..856c87563883 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4618,6 +4618,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 	}
 
+	if (vmx->nested.update_vmcs01_apicv_status) {
+		vmx->nested.update_vmcs01_apicv_status = false;
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+	}
+
 	if ((vm_exit_reason != -1) &&
 	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 04d170c4b61e..d58b763df855 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4174,6 +4174,11 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (is_guest_mode(vcpu)) {
+		vmx->nested.update_vmcs01_apicv_status = true;
+		return;
+	}
+
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
 	if (cpu_has_secondary_exec_ctrls()) {
 		if (kvm_vcpu_apicv_active(vcpu))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9c6bfcd84008..b98c7e96697a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -183,6 +183,7 @@ struct nested_vmx {
 	bool change_vmcs01_virtual_apic_mode;
 	bool reload_vmcs01_apic_access_page;
 	bool update_vmcs01_cpu_dirty_logging;
+	bool update_vmcs01_apicv_status;
 
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to

