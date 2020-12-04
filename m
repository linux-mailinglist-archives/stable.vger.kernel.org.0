Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3702CF2DC
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 18:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgLDRM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 12:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729262AbgLDRM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Dec 2020 12:12:58 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916D5C061A4F
        for <stable@vger.kernel.org>; Fri,  4 Dec 2020 09:12:12 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t3so3867240pgi.11
        for <stable@vger.kernel.org>; Fri, 04 Dec 2020 09:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w9E2vqL2vBEG4WzcpjcyMiL+hH3T0fG6UMOMTRmC3F0=;
        b=ajmjjMsKO0thEFFYvukx2A+aJpXbSY4ACheNxzco5GXfQn/1Eie5zRMF2k3NUsBTdj
         5trbkHJHwHAF6s6wgwtJNMmFJOA05wdz4GWkCWyfU2/BeBN8fYYWI0z3EmbCVtN949vW
         m3BJVZYCeinE/ZRq/bFL958fRftfh/dfjDJPUuoEapw5BVVYDbpuiFZpvqtr/xWKMKkM
         GX2HyEX+asQYxy9WuAx1nnt+H8q1wc3VdRakPHAl4E+/BS8bm5KXHZ4kuEocLAX13r5l
         MaXcNLuLF2MHU5oQTPjtZ3QF2jAZ66jeNqYkJ91Pho6DIaJcN7lqnlA8FDZyTOvi60Gh
         RvfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w9E2vqL2vBEG4WzcpjcyMiL+hH3T0fG6UMOMTRmC3F0=;
        b=VK0ws5/ZEpzLGukinuARLf2nq1FHJ/sTIveJnVLXFjpn5tjJp9/H8iD9C1n9fVRcRf
         5BhGzDXsYeN70y3v0kltb32d9rqmMQbGcBQLPljO+Uk/S3AihRd8Ke8BVE1GgSIFdNEQ
         FyBJUBEHqsvbUhDPZqg57XFhbGpI2/FFnR/wh6UqrLC6l1ClFk0OxsjytJgHkmsnvEEn
         T8a5LfxDma+gOefRukM48pqXogLj2EhsbsLnh8p3Eg8mJnzzVAvqjD0T5hkP/ldX41BE
         zikkwoCurM21iWpvfsXvhI0xvNOvmFEL+tLcupIcqva7sWNhYWkWoia7Eucg1Kmgq5mk
         jp9A==
X-Gm-Message-State: AOAM530pJGo7VPwmM4/QrUUSqYZP/tZ+rzeHNXp0SZAB36jFuGYAvpT1
        u/Gyc5xZZ/V0Q9NtYzLptM018A==
X-Google-Smtp-Source: ABdhPJw0p8xdjSJxBfGU7jHLkQsMopTK6eghybnByP6RyD6eoQa8xMCxt0AXqxVDuCiI/w5zep9H3w==
X-Received: by 2002:a65:60c4:: with SMTP id r4mr8194169pgv.291.1607101931942;
        Fri, 04 Dec 2020 09:12:11 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id o14sm4477629pgh.1.2020.12.04.09.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 09:12:11 -0800 (PST)
Date:   Fri, 4 Dec 2020 09:12:05 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, "Denis V . Lunev" <den@openvz.org>
Subject: Re: [PATCH] KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL
 cpuid bits
Message-ID: <X8pt5WxwJ+yOZUAq@google.com>
References: <20201203151516.14441-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203151516.14441-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 03, 2020, Paolo Bonzini wrote:
> Until commit e7c587da1252 ("x86/speculation: Use synthetic bits for IBRS/IBPB/STIBP",
> 2018-05-17), KVM was testing both Intel and AMD CPUID bits before allowing the
> guest to write MSR_IA32_SPEC_CTRL and MSR_IA32_PRED_CMD.  Testing only Intel bits
> on VMX processors, or only AMD bits on SVM processors, fails if the guests are
> created with the "opposite" vendor as the host.
> 
> While at it, also tweak the host CPU check to use the vendor-agnostic feature bit
> X86_FEATURE_IBPB, since we only care about the availability of the MSR on the host
> here and not about specific CPUID bits.
> 
> Fixes: e7c587da1252 ("x86/speculation: Use synthetic bits for IBRS/IBPB/STIBP")
> Cc: stable@vger.kernel.org
> Reported-by: Denis V. Lunev <den@openvz.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c |  3 ++-
>  arch/x86/kvm/vmx/vmx.c | 10 +++++++---
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 62390fbc9233..0b4aa60b2754 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2686,12 +2686,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		break;
>  	case MSR_IA32_PRED_CMD:
>  		if (!msr->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB))
>  			return 1;
>  
>  		if (data & ~PRED_CMD_IBPB)
>  			return 1;
> -		if (!boot_cpu_has(X86_FEATURE_AMD_IBPB))
> +		if (!boot_cpu_has(X86_FEATURE_IBPB))
>  			return 1;
>  		if (!data)
>  			break;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c3441e7e5a87..b74d2105ced7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2028,7 +2028,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)

Doesn't vmx_get_msr() also need to be changed for SPEC_CTRL?  Assuming that's
the case, adding helpers in cpuid.h to detect guest support for SPEC_CTRL (and
maybe for PRED_CMD?) would be helpful.  It'd reduce duplicate code and document
that KVM allows cross-vendor emulation.  The condition for SPEC_CTRL support is
especially long.

>  		break;
>  	case MSR_IA32_SPEC_CTRL:
>  		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> +                    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
> +                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
> +                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
> +                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))

Whitespace is messed up.

ERROR: code indent should use tabs where possible
#54: FILE: arch/x86/kvm/vmx/vmx.c:2031:
+                    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&$

WARNING: please, no spaces at the start of a line
#54: FILE: arch/x86/kvm/vmx/vmx.c:2031:
+                    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&$

ERROR: code indent should use tabs where possible
#55: FILE: arch/x86/kvm/vmx/vmx.c:2032:
+                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&$

WARNING: please, no spaces at the start of a line
#55: FILE: arch/x86/kvm/vmx/vmx.c:2032:
+                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&$

ERROR: code indent should use tabs where possible
#56: FILE: arch/x86/kvm/vmx/vmx.c:2033:
+                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&$

WARNING: please, no spaces at the start of a line
#56: FILE: arch/x86/kvm/vmx/vmx.c:2033:
+                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&$

ERROR: code indent should use tabs where possible
#57: FILE: arch/x86/kvm/vmx/vmx.c:2034:
+                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))$

WARNING: please, no spaces at the start of a line
#57: FILE: arch/x86/kvm/vmx/vmx.c:2034:
+                    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))$


>  			return 1;
>  
>  		if (kvm_spec_ctrl_test_value(data))
> @@ -2063,12 +2066,13 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		goto find_uret_msr;
>  	case MSR_IA32_PRED_CMD:
>  		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB))
>  			return 1;
>  
>  		if (data & ~PRED_CMD_IBPB)
>  			return 1;
> -		if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL))
> +		if (!boot_cpu_has(X86_FEATURE_IBPB))
>  			return 1;
>  		if (!data)
>  			break;
> -- 
> 2.26.2
> 
