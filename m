Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2B79B40DA
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 21:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733259AbfIPTMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 15:12:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:18665 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfIPTMT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 15:12:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 12:12:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,513,1559545200"; 
   d="scan'208";a="187234562"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 16 Sep 2019 12:12:18 -0700
Date:   Mon, 16 Sep 2019 12:12:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Fix warning in handle_desc
Message-ID: <20190916191218.GM18871@linux.intel.com>
References: <1568617969-6934-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568617969-6934-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 16, 2019 at 03:12:49PM +0800, Wanpeng Li wrote:
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
> sregs values. SECONDARY_EXEC_DESC is enabled on writes to CR4.UMIP in 
> vmx_set_cr4 though guest doesn't have UMIP cpuid flag. The testcast 
> triggers handle_desc warning when executing ltr instruction since guest 
> architectural CR4 doesn't set UMIP. This patch fixes it by adding check 
> for guest UMIP cpuid flag when get sreg inputs from userspace.
> 
> Reported-by: syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com
> Fixes: 0367f205a3b7 ("KVM: vmx: add support for emulating UMIP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> Note: syzbot report link https://lkml.org/lkml/2019/9/11/799
> 
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f7cfd8e..83288ba 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8645,6 +8645,10 @@ static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  			(sregs->cr4 & X86_CR4_OSXSAVE))
>  		return  -EINVAL;
>  
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_UMIP) &&
> +			(sregs->cr4 & X86_CR4_UMIP))

Assuming vmx_set_cr4() fails because nested_cr4_valid() fails, isn't this
a generic problem with nested VMX that just happens to be visible because
of the WARN_ON() in handle_desc()?

In general, KVM lets userspace set broken combinations of CPUID vs. CRx so
that it doesn't dictate ordering, e.g. __set_sregs() intentionally calls
kvm_x86_ops->set_cr4() instead of kvm_set_cr4(), which has all the CPUID
checks.

The existing OSXSAVE check in kvm_valid_sregs() is more about ensuring
host support (see commit 6d1068b3a985, "KVM: x86: invalid opcode oops on
SET_SREGS with OSXSAVE bit set (CVE-2012-4461)").

Given that both vmx_set_cr4() and svm_set_cr4() can return failure and
cause __set_sregs() to silently fail, what about adding a new x86 ops to
pre-check cr4, e.g. vm_x86_ops->is_valid_cr4(), and then WARN if set_cr4()
fails during __set_sregs()?

> +		return -EINVAL;
> +
>  	if ((sregs->efer & EFER_LME) && (sregs->cr0 & X86_CR0_PG)) {
>  		/*
>  		 * When EFER.LME and CR0.PG are set, the processor is in
> -- 
> 2.7.4
> 
