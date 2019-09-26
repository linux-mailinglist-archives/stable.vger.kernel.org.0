Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D288EBEF95
	for <lists+stable@lfdr.de>; Thu, 26 Sep 2019 12:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfIZK32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Sep 2019 06:29:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfIZK31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Sep 2019 06:29:27 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D073F3B58C
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 10:29:26 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id n3so747761wrt.9
        for <stable@vger.kernel.org>; Thu, 26 Sep 2019 03:29:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BY8HJnI4XVFhCNATjy1RWGMjwAHNDYeseMH3rD1F4Xc=;
        b=nvQhqzLy8T4Wvo7op1rHZTo4JslkNaOh2kp4zfdKqGlRSuYo5xdhgxgVxkITjEsfDd
         ZdwohhKlxVtC52WcR5oxXSpFUhRa6hpiifMno9a1I+5fJSAgNXg912N/bw+f7q7phqkP
         N+xkEra5VHcmVliW4mg4vfMA8SXHIZTXtliTRzCNesqrEmB+Z5FEJ7ccBShN7xQaX+KW
         nHSjhCO7Nw8Tt8IRUwa9aqS3D6ey7CA3/MiYNStMH5v/gJyauUm/ZxCnYo9ezVSTFAl8
         AhNxaJwjBItgLYiZrP780aPdLODdBuq3g79W7M5edmkRUWsILfD3byvkPBoFxXtRZbU3
         q2bg==
X-Gm-Message-State: APjAAAWFBKQTvHVMFZdtdwTvjxRGTbaBb4ghp1pJXUnJ18dqlU1bvoHf
        CeyBULFn5iKY9IktNtZntk2GeDWYfPvSlhsrlJFNiHOqQzATrcCz0upM0UJ1pg8+1tLC85sRuhE
        +S2W1WVYpXHpUf4Y1
X-Received: by 2002:a7b:c152:: with SMTP id z18mr2326494wmi.70.1569493765202;
        Thu, 26 Sep 2019 03:29:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzE5lcwm+xbGXmpzIj2zShy+VtcwYstdlWDIfWOGZs9gThvQMeAx3wCPLig0ZwD1i+BFw7oaw==
X-Received: by 2002:a7b:c152:: with SMTP id z18mr2326467wmi.70.1569493764888;
        Thu, 26 Sep 2019 03:29:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id k9sm3285943wrd.7.2019.09.26.03.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 03:29:24 -0700 (PDT)
Subject: Re: [PATCH v3] KVM: X86: Fix userspace set invalid CR4
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
References: <1568800210-3127-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <851fbe10-289b-c11c-375a-c6daa188ce17@redhat.com>
Date:   Thu, 26 Sep 2019 12:29:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568800210-3127-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/09/19 11:50, Wanpeng Li wrote:
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
> 
> syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=138efb99600000
> 
> Reported-by: syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 38 +++++++++++++++++++++-----------------
>  1 file changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f7cfd8e..d23cf0d 100644
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
>  	if (cr4 & CR4_RESERVED_BITS)
> -		return 1;
> +		return -EINVAL;
>  
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
> +	if (kvm_valid_cr4(vcpu, cr4))
>  		return 1;
>  
>  	if (is_long_mode(vcpu)) {
> @@ -8641,10 +8649,6 @@ EXPORT_SYMBOL_GPL(kvm_task_switch);
>  
>  static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  {
> -	if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> -			(sregs->cr4 & X86_CR4_OSXSAVE))
> -		return  -EINVAL;
> -
>  	if ((sregs->efer & EFER_LME) && (sregs->cr0 & X86_CR0_PG)) {
>  		/*
>  		 * When EFER.LME and CR0.PG are set, the processor is in
> @@ -8663,7 +8667,7 @@ static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  			return -EINVAL;
>  	}
>  
> -	return 0;
> +	return kvm_valid_cr4(vcpu, sregs->cr4);
>  }
>  
>  static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
> 

Queued, thanks.

Paolo
