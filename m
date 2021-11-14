Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACBD44F7D1
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 13:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhKNMWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 07:22:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234477AbhKNMWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 07:22:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D11B60EBC;
        Sun, 14 Nov 2021 12:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636892381;
        bh=I8G4uR6WQQBYSZw/tkf+0sK4/HqHwNCViFbDjGyLloA=;
        h=Subject:To:Cc:From:Date:From;
        b=lwxcNbWTA6ho59TqUC2XPvRvgzo20zTWph1fhrfgNNCUnSTfsO0wmDiUnH6mxg3Qe
         Ui557gwiRL9ngE/CayF8ygFKlR4XEw2SRFyrDBflRnie6MvVMUZbQCWMxfSP/K5mXj
         qE7b5MNxZ3q9yWvsbPI2ScvYagSkcQqyINI5EX1c=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Query current VMCS when determining if MSR bitmaps" failed to apply to 4.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 13:19:39 +0100
Message-ID: <16368923796549@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7dfbc624eb5726367900c8d86deff50836240361 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 9 Nov 2021 01:30:44 +0000
Subject: [PATCH] KVM: nVMX: Query current VMCS when determining if MSR bitmaps
 are in use

Check the current VMCS controls to determine if an MSR write will be
intercepted due to MSR bitmaps being disabled.  In the nested VMX case,
KVM will disable MSR bitmaps in vmcs02 if they're disabled in vmcs12 or
if KVM can't map L1's bitmaps for whatever reason.

Note, the bad behavior is relatively benign in the current code base as
KVM sets all bits in vmcs02's MSR bitmap by default, clears bits if and
only if L0 KVM also disables interception of an MSR, and only uses the
buggy helper for MSR_IA32_SPEC_CTRL.  Because KVM explicitly tests WRMSR
before disabling interception of MSR_IA32_SPEC_CTRL, the flawed check
will only result in KVM reading MSR_IA32_SPEC_CTRL from hardware when it
isn't strictly necessary.

Tag the fix for stable in case a future fix wants to use
msr_write_intercepted(), in which case a buggy implementation in older
kernels could prove subtly problematic.

Fixes: d28b387fb74d ("KVM/VMX: Allow direct access to MSR_IA32_SPEC_CTRL")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211109013047.2041518-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e4fc9ff7cd94..16726418ada9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -769,15 +769,15 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 /*
  * Check if MSR is intercepted for currently loaded MSR bitmap.
  */
-static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
+static bool msr_write_intercepted(struct vcpu_vmx *vmx, u32 msr)
 {
 	unsigned long *msr_bitmap;
 	int f = sizeof(unsigned long);
 
-	if (!cpu_has_vmx_msr_bitmap())
+	if (!(exec_controls_get(vmx) & CPU_BASED_USE_MSR_BITMAPS))
 		return true;
 
-	msr_bitmap = to_vmx(vcpu)->loaded_vmcs->msr_bitmap;
+	msr_bitmap = vmx->loaded_vmcs->msr_bitmap;
 
 	if (msr <= 0x1fff) {
 		return !!test_bit(msr, msr_bitmap + 0x800 / f);
@@ -6751,7 +6751,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
+	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
 		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);

