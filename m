Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C9F4521B9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346529AbhKPBGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:06:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245422AbhKOTUc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D77563279;
        Mon, 15 Nov 2021 18:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001268;
        bh=CQSKUf1FIsmfQk4kNQrCV7N2DYfkDGG2NHnpMk/XQk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqLn2ETASVoYEwQH5mOdGU98Buf//vX45tTq7A6/qpDhMFSOZKYGYr6jGXH0MgQTZ
         wbnj/uImqrvKPHeqd6eZEwMsSEqoNSpiVcLd/JHSMeIaSpDGAvc/mKQIRJ6nrnNU7S
         waec6NBp5WZhfs9hBLWfM5mfel2zVudw6CkTZqbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 124/917] KVM: nVMX: Query current VMCS when determining if MSR bitmaps are in use
Date:   Mon, 15 Nov 2021 17:53:39 +0100
Message-Id: <20211115165432.954145609@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 7dfbc624eb5726367900c8d86deff50836240361 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -769,15 +769,15 @@ void vmx_update_exception_bitmap(struct
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
@@ -6720,7 +6720,7 @@ static fastpath_t vmx_vcpu_run(struct kv
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
+	if (unlikely(!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL)))
 		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);


