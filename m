Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194523261CC
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 12:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhBZLKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 06:10:55 -0500
Received: from proxmox-new.maurer-it.com ([212.186.127.180]:5637 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhBZLKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 06:10:54 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2021 06:10:52 EST
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id B606041CE7;
        Fri, 26 Feb 2021 12:03:23 +0100 (CET)
Message-ID: <85e3f488-4ec5-2ad3-26a6-097d532824e1@proxmox.com>
Date:   Fri, 26 Feb 2021 12:03:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:86.0) Gecko/20100101
 Thunderbird/86.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Jim Mattson <jmattson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
References: <20210104155705.740576914@linuxfoundation.org>
 <20210104155706.339275609@linuxfoundation.org>
From:   Thomas Lamprecht <t.lamprecht@proxmox.com>
Subject: Re: [PATCH 5.4 12/47] KVM: x86: avoid incorrect writes to host
 MSR_IA32_SPEC_CTRL
In-Reply-To: <20210104155706.339275609@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.01.21 16:57, Greg Kroah-Hartman wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit 6441fa6178f5456d1d4b512c08798888f99db185 ]
> 
> If the guest is configured to have SPEC_CTRL but the host does not
> (which is a nonsensical configuration but these are not explicitly
> forbidden) then a host-initiated MSR write can write vmx->spec_ctrl
> (respectively svm->spec_ctrl) and trigger a #GP when KVM tries to
> restore the host value of the MSR.  Add a more comprehensive check
> for valid bits of SPEC_CTRL, covering host CPUID flags and,
> since we are at it and it is more correct that way, guest CPUID
> flags too.
> 
> For AMD, remove the unnecessary is_guest_mode check around setting
> the MSR interception bitmap, so that the code looks the same as
> for Intel.
> 

A git bisect between 5.4.86 and 5.4.98 showed that this breaks boot of QEMU
guests running Windows 10 20H2 on AMD Ryzen X3700 CPUs with a BSOD showing
"KERNEL SECURITY CHECK FAILURE".

Reverting this commit or setting the CPU type of the QEMU/KVM command from
host to qemu64 allows one to boot Windows 10 in the VM again.

I found a followup, commit 841c2be09fe4f495fe5224952a419bd8c7e5b455 [0],
which has a fixes line for this commit and mentions Zen2 AMD CPUs (which
the X3700 is).
Applying a backport of that commit on top of 5.4.98 stable tree fixed the
issue here see below for the backport I used, it applies also cleanly on the
more current 5.4.101 release.

So can you please add this patch to the stable trees that backported the
problematic upstream commit 6441fa6178f5456d1d4b512c08798888f99db185 ?

If I should submit this in any other way just ask, was not sure about
what works best with a patch which cannot be cherry-picked cleanly.

cheers,
Thomas

[0]: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=841c2be09fe4f495fe5224952a419bd8c7e5b455

----8<---
From: Maxim Levitsky <mlevitsk@redhat.com>
Date: Wed, 8 Jul 2020 14:57:31 +0300
Subject: [PATCH] kvm: x86: replace kvm_spec_ctrl_test_value with runtime test
 on the host

To avoid complex and in some cases incorrect logic in
kvm_spec_ctrl_test_value, just try the guest's given value on the host
processor instead, and if it doesn't #GP, allow the guest to set it.

One such case is when host CPU supports STIBP mitigation
but doesn't support IBRS (as is the case with some Zen2 AMD cpus),
and in this case we were giving guest #GP when it tried to use STIBP

The reason why can can do the host test is that IA32_SPEC_CTRL msr is
passed to the guest, after the guest sets it to a non zero value
for the first time (due to performance reasons),
and as as result of this, it is pointless to emulate #GP condition on
this first access, in a different way than what the host CPU does.

This is based on a patch from Sean Christopherson, who suggested this idea.

Fixes: 6441fa6178f5 ("KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTRL")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20200708115731.180097-1-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
(cherry picked from commit 841c2be09fe4f495fe5224952a419bd8c7e5b455)
[ Thomas: resolved merge conflict in arch/x86/kvm/x86.h and
  replicated the change to arch/x86/kvm/svm/svm.c to the in 5.4 not
  yet moved out arch/x86/kvm/svm.c ]
Signed-off-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
---
 arch/x86/kvm/svm.c     |  2 +-
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     | 38 +++++++++++++++++++++-----------------
 arch/x86/kvm/x86.h     |  2 +-
 4 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8d386efc2540..372a958bec72 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4327,7 +4327,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
+		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
 		svm->spec_ctrl = data;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e7fd2f00edc1..e177848a3631 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1974,7 +1974,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
+		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
 		vmx->spec_ctrl = data;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5a827150664..1330fc4dc7c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10376,28 +10376,32 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
-u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
+
+int kvm_spec_ctrl_test_value(u64 value)
 {
-	uint64_t bits = SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD;
+	/*
+	 * test that setting IA32_SPEC_CTRL to given value
+	 * is allowed by the host processor
+	 */
 
-	/* The STIBP bit doesn't fault even if it's not advertised */
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS))
-		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
-	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
-	    !boot_cpu_has(X86_FEATURE_AMD_IBRS))
-		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
+	u64 saved_value;
+	unsigned long flags;
+	int ret = 0;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
-		bits &= ~SPEC_CTRL_SSBD;
-	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) &&
-	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
-		bits &= ~SPEC_CTRL_SSBD;
+	local_irq_save(flags);
 
-	return bits;
+	if (rdmsrl_safe(MSR_IA32_SPEC_CTRL, &saved_value))
+		ret = 1;
+	else if (wrmsrl_safe(MSR_IA32_SPEC_CTRL, value))
+		ret = 1;
+	else
+		wrmsrl(MSR_IA32_SPEC_CTRL, saved_value);
+
+	local_irq_restore(flags);
+
+	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
+EXPORT_SYMBOL_GPL(kvm_spec_ctrl_test_value);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 301286d92432..c520d373790a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -368,6 +368,6 @@ static inline bool kvm_pat_valid(u64 data)
 
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
-u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
+int kvm_spec_ctrl_test_value(u64 value);
 
 #endif
-- 
2.20.1


