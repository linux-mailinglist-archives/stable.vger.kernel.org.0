Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA29D20E7A9
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404792AbgF2V7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgF2Sf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DF5C2479D;
        Mon, 29 Jun 2020 15:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444107;
        bh=ARduPwl3VyyP0USeSLLRDrPw+fVXr/4EYbZ1T3ACobM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZouYuiIAN/WTKhIOcR6fSeRXnitUZYOv+JMc+iN+LVc6Ah6Dh6m9uzelKuhVktwH
         1mPzGxUmHA1ru9XORma02VrztFYZtA4mRzobnz0XkSOfr5tfum9RP1ou93u3yp4yCh
         V+Xga0KNVAi4dkKtSJvFP2bCQ5ZFPn8eizR7oP/A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>, Tao Xu <tao3.xu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 218/265] KVM: VMX: Stop context switching MSR_IA32_UMWAIT_CONTROL
Date:   Mon, 29 Jun 2020 11:17:31 -0400
Message-Id: <20200629151818.2493727-219-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit bf09fb6cba4f7099620cc9ed32d94c27c4af992e upstream.

Remove support for context switching between the guest's and host's
desired UMWAIT_CONTROL.  Propagating the guest's value to hardware isn't
required for correct functionality, e.g. KVM intercepts reads and writes
to the MSR, and the latency effects of the settings controlled by the
MSR are not architecturally visible.

As a general rule, KVM should not allow the guest to control power
management settings unless explicitly enabled by userspace, e.g. see
KVM_CAP_X86_DISABLE_EXITS.  E.g. Intel's SDM explicitly states that C0.2
can improve the performance of SMT siblings.  A devious guest could
disable C0.2 so as to improve the performance of their workloads at the
detriment to workloads running in the host or on other VMs.

Wholesale removal of UMWAIT_CONTROL context switching also fixes a race
condition where updates from the host may cause KVM to enter the guest
with the incorrect value.  Because updates are are propagated to all
CPUs via IPI (SMP function callback), the value in hardware may be
stale with respect to the cached value and KVM could enter the guest
with the wrong value in hardware.  As above, the guest can't observe the
bad value, but it's a weird and confusing wart in the implementation.

Removal also fixes the unnecessary usage of VMX's atomic load/store MSR
lists.  Using the lists is only necessary for MSRs that are required for
correct functionality immediately upon VM-Enter/VM-Exit, e.g. EFER on
old hardware, or for MSRs that need to-the-uop precision, e.g. perf
related MSRs.  For UMWAIT_CONTROL, the effects are only visible in the
kernel via TPAUSE/delay(), and KVM doesn't do any form of delay in
vcpu_vmx_run().  Using the atomic lists is undesirable as they are more
expensive than direct RDMSR/WRMSR.

Furthermore, even if giving the guest control of the MSR is legitimate,
e.g. in pass-through scenarios, it's not clear that the benefits would
outweigh the overhead.  E.g. saving and restoring an MSR across a VMX
roundtrip costs ~250 cycles, and if the guest diverged from the host
that cost would be paid on every run of the guest.  In other words, if
there is a legitimate use case then it should be enabled by a new
per-VM capability.

Note, KVM still needs to emulate MSR_IA32_UMWAIT_CONTROL so that it can
correctly expose other WAITPKG features to the guest, e.g. TPAUSE,
UMWAIT and UMONITOR.

Fixes: 6e3ba4abcea56 ("KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL")
Cc: stable@vger.kernel.org
Cc: Jingqi Liu <jingqi.liu@intel.com>
Cc: Tao Xu <tao3.xu@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200623005135.10414-1-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/mwait.h |  2 --
 arch/x86/kernel/cpu/umwait.c |  6 ------
 arch/x86/kvm/vmx/vmx.c       | 18 ------------------
 3 files changed, 26 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index b809f117f3f46..9d5252c9685c6 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -23,8 +23,6 @@
 #define MWAITX_MAX_LOOPS		((u32)-1)
 #define MWAITX_DISABLE_CSTATES		0xf0
 
-u32 get_umwait_control_msr(void);
-
 static inline void __monitor(const void *eax, unsigned long ecx,
 			     unsigned long edx)
 {
diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
index 300e3fd5ade3e..ec8064c0ae035 100644
--- a/arch/x86/kernel/cpu/umwait.c
+++ b/arch/x86/kernel/cpu/umwait.c
@@ -18,12 +18,6 @@
  */
 static u32 umwait_control_cached = UMWAIT_CTRL_VAL(100000, UMWAIT_C02_ENABLE);
 
-u32 get_umwait_control_msr(void)
-{
-	return umwait_control_cached;
-}
-EXPORT_SYMBOL_GPL(get_umwait_control_msr);
-
 /*
  * Cache the original IA32_UMWAIT_CONTROL MSR value which is configured by
  * hardware or BIOS before kernel boot.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2d7ce012b1d5f..390ec34e4b4f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6467,23 +6467,6 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host, false);
 }
 
-static void atomic_switch_umwait_control_msr(struct vcpu_vmx *vmx)
-{
-	u32 host_umwait_control;
-
-	if (!vmx_has_waitpkg(vmx))
-		return;
-
-	host_umwait_control = get_umwait_control_msr();
-
-	if (vmx->msr_ia32_umwait_control != host_umwait_control)
-		add_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL,
-			vmx->msr_ia32_umwait_control,
-			host_umwait_control, false);
-	else
-		clear_atomic_switch_msr(vmx, MSR_IA32_UMWAIT_CONTROL);
-}
-
 static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6576,7 +6559,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
-	atomic_switch_umwait_control_msr(vmx);
 
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
-- 
2.25.1

