Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC8F4A8B2E
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 19:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353114AbiBCSGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 13:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238019AbiBCSGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 13:06:18 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB1FC061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 10:06:18 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id y17so2818977plg.7
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 10:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=5t2uJ1SRgWhDPevhVlaoaukHXWnQMBc0kE+r3X/iA4s=;
        b=X+MS5/s1nZM3grMbUollWC4gHUlMqruvqgbJKiyaU1P2nODRvg+TSDgZ3zwPYdUZIv
         3to4dgl3ln+iXeJPYMgKV7IBSTPXD66ZQ3IB1cFAC/WTJY+o/FOP5VbVcw7a4ln+bZcW
         Qq7R68/TT6WECeXRwFxlUTtQwurdlBwfn8RLiuyscgJlEQCr46keKttM/V4nDANk5IP/
         05hHO9Oo7gwCQ3Bgm7vzZUxkg28yJsr/8cIZeJUSCUkP0fQ91vp1+9D8GieAhQxqk0gE
         RaSEfh+ipy/wH2UzWRMIAkVDgOzfU7a8ZqwsUf2SrxivsjwYytepI1WtnDoCaZDXdhM5
         sAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=5t2uJ1SRgWhDPevhVlaoaukHXWnQMBc0kE+r3X/iA4s=;
        b=yhgCgiI7oZCe/hnC0tLlJliFPACixk9dICJhqIjR6wm7+bJpLfaxo0TCE9dY1hCrXV
         u5tpU853lzveUh7yAmrwmBRAWNflvDR7Waw36IZqIEvWDcWmDs95AJBT0ahX+zEmwIh8
         LkfYt6knWIlnCBRjklfpdq/KJ7ngsJg+T5FmlpZcxqTAhCCISdLCEtkl64anahivVd0T
         Qoc7z9JrS5inE6hUsZ8TFQudwnEztHUA2NegIhGmvy6G4jMyEzJ7t5f22VSr0VNwr7Ql
         U/uuyIzpEFJEg+zW6h5/t6w2Hm8pMi63g43jTOdBb5Z0/G9gMXWRDiL/hqV/KY+LaSIs
         GKXQ==
X-Gm-Message-State: AOAM530IdgqrGVXFwBXulrGV1/nxTbC/oxmP27t9nxh9yyRDbq3y3zBz
        30TpDToy4Zi7u8D9ZdNXp1uhHEpv9au+nw==
X-Google-Smtp-Source: ABdhPJwQ0Z2ROaabUKQhz/8jClHQ4UvVVbLmF9atxRprOQdKwW1UFrzTZGUH458n23RIgCCo7NS5bg==
X-Received: by 2002:a17:902:d483:: with SMTP id c3mr37441949plg.141.1643911577266;
        Thu, 03 Feb 2022 10:06:17 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id p8sm31563026pfo.41.2022.02.03.10.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 10:06:16 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Cc:     greg@kroah.com, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.10] KVM: x86: Forcibly leave nested virt when SMM state is toggled
Date:   Thu,  3 Feb 2022 10:05:50 -0800
Message-Id: <20220203180550.1167062-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.34.1
Reply-To: YfwUuiOPjiQ2/EH1@kroah.com
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Commit f7e570780efc5cec9b2ed1e0472a7da14e864fdb upstream.

Please apply it to 5.10.y. It fixes the following syzbot issue:
Link: https://syzkaller.appspot.com/bug?id=c46ee6f22a68171154cdd9217216b2a02cf4b71c

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

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: <stable@vger.kernel.org>
Cc: <x86@kernel.org>
Cc: <kvm@vger.kernel.org>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/nested.c       | 10 ++++++++--
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/svm/svm.h          |  2 +-
 arch/x86/kvm/vmx/nested.c       |  1 +
 arch/x86/kvm/x86.c              |  2 ++
 6 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b1cd8334db11..078494401046 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1285,6 +1285,7 @@ struct kvm_x86_ops {
 };
 
 struct kvm_x86_nested_ops {
+	void (*leave_nested)(struct kvm_vcpu *vcpu);
 	int (*check_events)(struct kvm_vcpu *vcpu);
 	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f0946872f5e6..23910e6a3f01 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -783,8 +783,10 @@ void svm_free_nested(struct vcpu_svm *svm)
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
@@ -1185,7 +1187,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
-		svm_leave_nested(svm);
+		svm_leave_nested(vcpu);
 		svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 		return 0;
 	}
@@ -1238,6 +1240,9 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
 	hsave->save = *save;
 
+	if (is_guest_mode(vcpu))
+		svm_leave_nested(vcpu);
+
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
 	load_nested_vmcb_control(svm, ctl);
 	nested_prepare_vmcb_control(svm);
@@ -1252,6 +1257,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 }
 
 struct kvm_x86_nested_ops svm_nested_ops = {
+	.leave_nested = svm_leave_nested,
 	.check_events = svm_check_nested_events,
 	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5e1d7396a6b8..b4f4ce5ace6b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -279,7 +279,7 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
 		if (!(efer & EFER_SVME)) {
-			svm_leave_nested(svm);
+			svm_leave_nested(vcpu);
 			svm_set_gif(svm, true);
 
 			/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be74e22b82ea..2c007241fbf5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -393,7 +393,7 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 
 int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			 struct vmcb *nested_vmcb);
-void svm_leave_nested(struct vcpu_svm *svm);
+void svm_leave_nested(struct kvm_vcpu *vcpu);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct vcpu_svm *svm);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d5f24a2f3e91..6a4b91b77cde 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6614,6 +6614,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 }
 
 struct kvm_x86_nested_ops vmx_nested_ops = {
+	.leave_nested = vmx_leave_nested,
 	.check_events = vmx_check_nested_events,
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.get_state = vmx_get_nested_state,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b885063dc393..ab31745c04d0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4390,6 +4390,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 				vcpu->arch.hflags |= HF_SMM_MASK;
 			else
 				vcpu->arch.hflags &= ~HF_SMM_MASK;
+
+			kvm_x86_ops.nested_ops->leave_nested(vcpu);
 			kvm_smm_changed(vcpu);
 		}
 
-- 
2.34.1

