Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B7A4A9619
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbiBDJW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:22:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41756 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357625AbiBDJWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:22:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F6F0615DC;
        Fri,  4 Feb 2022 09:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEDFC004E1;
        Fri,  4 Feb 2022 09:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966536;
        bh=XbccLvw/D0ZxgOoY+2yrv/Y8kbTKWwmyKM28ESuMBcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRErtUQZS2eyAQg7+79VtMNhz3i3/DDfvdt4+qCiKejrVaLA9xf1jQ0c1Tnqdak5G
         JPoG1TZajf7fmgGWGfjAo0k5rpmv6pzr2MQBZsrCNMq19WrAiJ7GMKLh+vo5U+5abT
         b/ABE2OdVZQMSv6O6bJ5Hd92MpyoHlksiKQ9tYns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.10 06/25] KVM: x86: Forcibly leave nested virt when SMM state is toggled
Date:   Fri,  4 Feb 2022 10:20:13 +0100
Message-Id: <20220204091914.497446272@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit f7e570780efc5cec9b2ed1e0472a7da14e864fdb upstream.

Forcibly leave nested virtualization operation if userspace toggles SMM
state via KVM_SET_VCPU_EVENTS or KVM_SYNC_X86_EVENTS.  If userspace
forces the vCPU out of SMM while it's post-VMXON and then injects an SMI,
vmx_enter_smm() will overwrite vmx->nested.smm.vmxon and end up with both
vmxon=false and smm.vmxon=false, but all other nVMX state allocated.

Don't attempt to gracefully handle the transition as (a) most transitions
are nonsencial, e.g. forcing SMM while L2 is running, (b) there isn't
sufficient information to handle all transitions, e.g. SVM wants access
to the SMRAM save state, and (c) KVM_SET_VCPU_EVENTS must precede
KVM_SET_NESTED_STATE during state restore as the latter disallows putting
the vCPU into L2 if SMM is active, and disallows tagging the vCPU as
being post-VMXON in SMM if SMM is not active.

Abuse of KVM_SET_VCPU_EVENTS manifests as a WARN and memory leak in nVMX
due to failure to free vmcs01's shadow VMCS, but the bug goes far beyond
just a memory leak, e.g. toggling SMM on while L2 is active puts the vCPU
in an architecturally impossible state.

  WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
  WARNING: CPU: 0 PID: 3606 at free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
  Modules linked in:
  CPU: 1 PID: 3606 Comm: syz-executor725 Not tainted 5.17.0-rc1-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:free_loaded_vmcs arch/x86/kvm/vmx/vmx.c:2665 [inline]
  RIP: 0010:free_loaded_vmcs+0x158/0x1a0 arch/x86/kvm/vmx/vmx.c:2656
  Code: <0f> 0b eb b3 e8 8f 4d 9f 00 e9 f7 fe ff ff 48 89 df e8 92 4d 9f 00
  Call Trace:
   <TASK>
   kvm_arch_vcpu_destroy+0x72/0x2f0 arch/x86/kvm/x86.c:11123
   kvm_vcpu_destroy arch/x86/kvm/../../../virt/kvm/kvm_main.c:441 [inline]
   kvm_destroy_vcpus+0x11f/0x290 arch/x86/kvm/../../../virt/kvm/kvm_main.c:460
   kvm_free_vcpus arch/x86/kvm/x86.c:11564 [inline]
   kvm_arch_destroy_vm+0x2e8/0x470 arch/x86/kvm/x86.c:11676
   kvm_destroy_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1217 [inline]
   kvm_put_kvm+0x4fa/0xb00 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1250
   kvm_vm_release+0x3f/0x50 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1273
   __fput+0x286/0x9f0 fs/file_table.c:311
   task_work_run+0xdd/0x1a0 kernel/task_work.c:164
   exit_task_work include/linux/task_work.h:32 [inline]
   do_exit+0xb29/0x2a30 kernel/exit.c:806
   do_group_exit+0xd2/0x2f0 kernel/exit.c:935
   get_signal+0x4b0/0x28c0 kernel/signal.c:2862
   arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
   handle_signal_work kernel/entry/common.c:148 [inline]
   exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
   exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
   __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
   syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
   do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>

Cc: stable@vger.kernel.org
Reported-by: syzbot+8112db3ab20e70d50c31@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220125220358.2091737-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Backported-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/svm/nested.c       |   10 ++++++++--
 arch/x86/kvm/svm/svm.c          |    2 +-
 arch/x86/kvm/svm/svm.h          |    2 +-
 arch/x86/kvm/vmx/nested.c       |    1 +
 arch/x86/kvm/x86.c              |    2 ++
 6 files changed, 14 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1285,6 +1285,7 @@ struct kvm_x86_ops {
 };
 
 struct kvm_x86_nested_ops {
+	void (*leave_nested)(struct kvm_vcpu *vcpu);
 	int (*check_events)(struct kvm_vcpu *vcpu);
 	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -783,8 +783,10 @@ void svm_free_nested(struct vcpu_svm *sv
 /*
  * Forcibly leave nested mode in order to be able to reset the VCPU later on.
  */
-void svm_leave_nested(struct vcpu_svm *svm)
+void svm_leave_nested(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	if (is_guest_mode(&svm->vcpu)) {
 		struct vmcb *hsave = svm->nested.hsave;
 		struct vmcb *vmcb = svm->vmcb;
@@ -1185,7 +1187,7 @@ static int svm_set_nested_state(struct k
 		return -EINVAL;
 
 	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
-		svm_leave_nested(svm);
+		svm_leave_nested(vcpu);
 		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 		return 0;
 	}
@@ -1238,6 +1240,9 @@ static int svm_set_nested_state(struct k
 	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
 	hsave->save = *save;
 
+	if (is_guest_mode(vcpu))
+		svm_leave_nested(vcpu);
+
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
 	load_nested_vmcb_control(svm, ctl);
 	nested_prepare_vmcb_control(svm);
@@ -1252,6 +1257,7 @@ out_free:
 }
 
 struct kvm_x86_nested_ops svm_nested_ops = {
+	.leave_nested = svm_leave_nested,
 	.check_events = svm_check_nested_events,
 	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -279,7 +279,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu,
 
 	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
 		if (!(efer & EFER_SVME)) {
-			svm_leave_nested(svm);
+			svm_leave_nested(vcpu);
 			svm_set_gif(svm, true);
 
 			/*
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -393,7 +393,7 @@ static inline bool nested_exit_on_nmi(st
 
 int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			 struct vmcb *nested_vmcb);
-void svm_leave_nested(struct vcpu_svm *svm);
+void svm_leave_nested(struct kvm_vcpu *vcpu);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct vcpu_svm *svm);
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6628,6 +6628,7 @@ __init int nested_vmx_hardware_setup(int
 }
 
 struct kvm_x86_nested_ops vmx_nested_ops = {
+	.leave_nested = vmx_leave_nested,
 	.check_events = vmx_check_nested_events,
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.get_state = vmx_get_nested_state,
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4391,6 +4391,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_e
 				vcpu->arch.hflags |= HF_SMM_MASK;
 			else
 				vcpu->arch.hflags &= ~HF_SMM_MASK;
+
+			kvm_x86_ops.nested_ops->leave_nested(vcpu);
 			kvm_smm_changed(vcpu);
 		}
 


