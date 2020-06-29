Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52DA20D9D0
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387812AbgF2Tu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387731AbgF2Tkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5586624912;
        Mon, 29 Jun 2020 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444467;
        bh=nr8fbONF3tDpmAoLcrs3fhK3KkecQR6+CE/6sRuNh9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqY0pUGWsVBpx5Fk3jkajDgcQBc09OJfJm6m8cXWj6nOE+1JzhPh+SXJInmEMj+Ob
         EiGVMHulYiJnn+ehI317ldTzQRu9P9C1pMAL/K84gTqZalQ3L2wEOPcMtebr9PqSmQ
         oKURhF6Bw+4Yz+hHcXl6U+m102/VVOb170hlFOy4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jingqi Liu <jingqi.liu@intel.com>, Tao Xu <tao3.xu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 147/178] KVM: VMX: Stop context switching MSR_IA32_UMWAIT_CONTROL
Date:   Mon, 29 Jun 2020 11:24:52 -0400
Message-Id: <20200629152523.2494198-148-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
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
 arch/x86/kernel/cpu/umwait.c |  6 ------
 arch/x86/kvm/vmx/vmx.c       | 18 ------------------
 arch/x86/kvm/vmx/vmx.h       |  2 --
 3 files changed, 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/umwait.c b/arch/x86/kernel/cpu/umwait.c
index c222f283b4560..32b4dc9030aa9 100644
--- a/arch/x86/kernel/cpu/umwait.c
+++ b/arch/x86/kernel/cpu/umwait.c
@@ -17,12 +17,6 @@
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
index 2e6d400ce0a01..10e6471896cdb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6427,23 +6427,6 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
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
@@ -6533,7 +6516,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
-	atomic_switch_umwait_control_msr(vmx);
 
 	if (enable_preemption_timer)
 		vmx_update_hv_timer(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 295c5f83842e5..a1919ec7fd108 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -14,8 +14,6 @@
 extern const u32 vmx_msr_index[];
 extern u64 host_efer;
 
-extern u32 get_umwait_control_msr(void);
-
 #define MSR_TYPE_R	1
 #define MSR_TYPE_W	2
 #define MSR_TYPE_RW	3
-- 
2.25.1

