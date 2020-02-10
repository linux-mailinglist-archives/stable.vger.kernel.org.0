Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9663F15793A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbgBJNNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbgBJMij (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:39 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2895F20661;
        Mon, 10 Feb 2020 12:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338319;
        bh=pwgh38ltuMnOL+4RvfiyDg7TiATd0kVlvmn7UumDg1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4uuziuUTL+4ZltmffFeVKaPwKMDZZ6G13NvYIA2+3Rr/0xOduBOFtWUxgm6WinbA
         uApOhMgrdwqHJi/a5U8ZxfXPY29RaFcGj9tUUzSbGYC2XOODHpykp0YxMm6GrIPpCQ
         qZ72M34EGaRYvFBvHXuQWnDhl649vW5P+97OPnts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.4 222/309] KVM: x86: Handle TIF_NEED_FPU_LOAD in kvm_{load,put}_guest_fpu()
Date:   Mon, 10 Feb 2020 04:32:58 -0800
Message-Id: <20200210122427.883826991@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit c9aef3b85f425d1f6635382ec210ee5a7ef55d7d upstream.

Handle TIF_NEED_FPU_LOAD similar to how fpu__copy() handles the flag
when duplicating FPU state to a new task struct.  TIF_NEED_FPU_LOAD can
be set any time control is transferred out of KVM, be it voluntarily,
e.g. if I/O is triggered during a KVM call to get_user_pages, or
involuntarily, e.g. if softirq runs after an IRQ occurs.  Therefore,
KVM must account for TIF_NEED_FPU_LOAD whenever it is (potentially)
accessing CPU FPU state.

Fixes: 5f409e20b7945 ("x86/fpu: Defer FPU state load until return to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8493,12 +8493,26 @@ static int complete_emulated_mmio(struct
 	return 0;
 }
 
+static void kvm_save_current_fpu(struct fpu *fpu)
+{
+	/*
+	 * If the target FPU state is not resident in the CPU registers, just
+	 * memcpy() from current, else save CPU state directly to the target.
+	 */
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		memcpy(&fpu->state, &current->thread.fpu.state,
+		       fpu_kernel_xstate_size);
+	else
+		copy_fpregs_to_fpstate(fpu);
+}
+
 /* Swap (qemu) user FPU context for the guest FPU context. */
 static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	fpregs_lock();
 
-	copy_fpregs_to_fpstate(vcpu->arch.user_fpu);
+	kvm_save_current_fpu(vcpu->arch.user_fpu);
+
 	/* PKRU is separately restored in kvm_x86_ops->run.  */
 	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
 				~XFEATURE_MASK_PKRU);
@@ -8514,7 +8528,8 @@ static void kvm_put_guest_fpu(struct kvm
 {
 	fpregs_lock();
 
-	copy_fpregs_to_fpstate(vcpu->arch.guest_fpu);
+	kvm_save_current_fpu(vcpu->arch.guest_fpu);
+
 	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
 
 	fpregs_mark_activate();


