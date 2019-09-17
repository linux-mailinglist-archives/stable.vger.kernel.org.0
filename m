Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5597B5450
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 19:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbfIQRdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 13:33:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:21166 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbfIQRdA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Sep 2019 13:33:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 10:32:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,517,1559545200"; 
   d="scan'208";a="193808590"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Sep 2019 10:32:58 -0700
Date:   Tue, 17 Sep 2019 10:32:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: X86: Fix userspace set broken combinations
 of CPUID and CR4
Message-ID: <20190917173258.GB2876@linux.intel.com>
References: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
 <1568708186-20260-2-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568708186-20260-2-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 17, 2019 at 04:16:25PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Reported by syzkaller:
> 
> 	WARNING: CPU: 0 PID: 6544 at /home/kernel/data/kvm/arch/x86/kvm//vmx/vmx.c:4689 handle_desc+0x37/0x40 [kvm_intel]
> 	CPU: 0 PID: 6544 Comm: a.out Tainted: G           OE     5.3.0-rc4+ #4
> 	RIP: 0010:handle_desc+0x37/0x40 [kvm_intel]
> 	Call Trace:
> 	 vmx_handle_exit+0xbe/0x6b0 [kvm_intel]
> 	 vcpu_enter_guest+0x4dc/0x18d0 [kvm]
> 	 kvm_arch_vcpu_ioctl_run+0x407/0x660 [kvm]
> 	 kvm_vcpu_ioctl+0x3ad/0x690 [kvm]
> 	 do_vfs_ioctl+0xa2/0x690
> 	 ksys_ioctl+0x6d/0x80
> 	 __x64_sys_ioctl+0x1a/0x20
> 	 do_syscall_64+0x74/0x720
> 	 entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> When CR4.UMIP is set, guest should have UMIP cpuid flag. Current
> kvm set_sregs function doesn't have such check when userspace inputs
> sregs values. SECONDARY_EXEC_DESC is enabled on writes to CR4.UMIP
> in vmx_set_cr4 though guest doesn't have UMIP cpuid flag. The testcast
> triggers handle_desc warning when executing ltr instruction since
> guest architectural CR4 doesn't set UMIP. This patch fixes it by
> adding valid CR4 and CPUID combination checking in __set_sregs.

Checking CPUID will fix this specific scenario, but it doesn't resolve
the underlying issue of __set_sregs() ignoring the return of kvm_x86_ops'
set_cr4(), e.g. I think vmx_set_cr4() can still fail if userspace sets a
custom MSR_IA32_VMX_CR4_FIXED0 when nested VMX is on.
 
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=138efb99600000
> 
> Reported-by: syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++---------------
>  1 file changed, 24 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f7cfd8e..cafb4d4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -884,34 +884,42 @@ int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_xcr);
>  
> -int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> +static int kvm_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
> -	unsigned long old_cr4 = kvm_read_cr4(vcpu);
> -	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
> -				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
> -
> -	if (cr4 & CR4_RESERVED_BITS)
> -		return 1;
> -
>  	if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) && (cr4 & X86_CR4_OSXSAVE))
> -		return 1;
> +		return -EINVAL;
>  
>  	if (!guest_cpuid_has(vcpu, X86_FEATURE_SMEP) && (cr4 & X86_CR4_SMEP))
> -		return 1;
> +		return -EINVAL;
>  
>  	if (!guest_cpuid_has(vcpu, X86_FEATURE_SMAP) && (cr4 & X86_CR4_SMAP))
> -		return 1;
> +		return -EINVAL;
>  
>  	if (!guest_cpuid_has(vcpu, X86_FEATURE_FSGSBASE) && (cr4 & X86_CR4_FSGSBASE))
> -		return 1;
> +		return -EINVAL;
>  
>  	if (!guest_cpuid_has(vcpu, X86_FEATURE_PKU) && (cr4 & X86_CR4_PKE))
> -		return 1;
> +		return -EINVAL;
>  
>  	if (!guest_cpuid_has(vcpu, X86_FEATURE_LA57) && (cr4 & X86_CR4_LA57))
> -		return 1;
> +		return -EINVAL;
>  
>  	if (!guest_cpuid_has(vcpu, X86_FEATURE_UMIP) && (cr4 & X86_CR4_UMIP))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> +{
> +	unsigned long old_cr4 = kvm_read_cr4(vcpu);
> +	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
> +				   X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE;
> +
> +	if (cr4 & CR4_RESERVED_BITS)
> +		return 1;

Checking CPUID bits but allowing unconditionally reserved bits to be set
feels wrong.

Paolo, can you provide an "official" ruling on how KVM_SET_SREGS should
interact with reserved bits?  It's not at all clear from the git history
if skipping the checks was intentional or an oversight.

The CR4_RESERVED_BITS check has been in kvm_set_cr4() since the beginning
of time (commit 6aa8b732ca01, "[PATCH] kvm: userspace interface").

The first CPUID check came later, in commit 2acf923e38fb ("KVM: VMX:
Enable XSAVE/XRSTOR for guest"), but its changelog is decidedly unhelpful.

> +
> +	if (kvm_valid_cr4(vcpu, cr4))
>  		return 1;
>  
>  	if (is_long_mode(vcpu)) {
> @@ -8675,7 +8683,8 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  	struct desc_ptr dt;
>  	int ret = -EINVAL;
>  
> -	if (kvm_valid_sregs(vcpu, sregs))
> +	if (kvm_valid_sregs(vcpu, sregs) ||

No need for a line break.  Even better, call kvm_valid_cr4() from
kvm_valid_sregs(), e.g. the X86_FEATURE_XSAVE check in kvm_valid_sregs()
is now redundant and can be dropped, and "return kvm_valid_cr4(...)" from
kvm_valid_sregs() can likely be optimized into a tail call.

> +		kvm_valid_cr4(vcpu, sregs->cr4))
>  		goto out;
>  
>  	apic_base_msr.data = sregs->apic_base;
> -- 
> 2.7.4
> 
