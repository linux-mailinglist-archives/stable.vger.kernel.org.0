Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F7A307D39
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 18:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhA1R7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 12:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhA1R5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 12:57:43 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D7CC061756
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 09:57:01 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id md11so4298780pjb.0
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 09:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gcQo9DlTrKPUw2TM/2+qTxye/Ipd7oPvbrj/DrgbKNs=;
        b=V5eOiBkPxLowtQCwFGZnLKykhH0E5j34s2WU7DG8yQWMdmhxRK0riR9KJCB656eWMC
         EGTZhybyoIPJyzpC0AoakhrWy31rYn4AeXM7+rqMP09U+4UQRsdjWpQtOFia87IYugXp
         qp8l5PidvWzKDyoDx2tEQuQ+eHcHnWil2tPdrDX4XCWBtlOeiv9KzsUTF1swsBho1dqe
         DvkKAYFmJW+JmM9F/nMIB5IwDaXuM0X+Hp4zXAhyd6vbBOlpZdDFQUJbU1TjMzQvsmWd
         DFSAA2B78/6pw5Z+ndIhqlgN+5dozTsvvd/YLQi5ftES3f+Bgo2Hq6HgGGqelKTUYjq0
         K9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gcQo9DlTrKPUw2TM/2+qTxye/Ipd7oPvbrj/DrgbKNs=;
        b=XjRAwN2R0689nijNesT6FDG74nX1iYBBhEdUHrAhXyR/OnvOJjwNCMOghoc54+xw2M
         xuWA0Ow2YjOc+73j6ueTEmzyDIveCSn1yCZJlxO/BK1CjBxlOhMKSud5gMvjxv/Aq1Yg
         lgkW57o8Sj6jgbLY3AnUjvn99dgSzrzqXkf0IEZ1PnH+zCZNb/rdTa6AfLdyN2UB5AiH
         U1sFVRIdAQ0cmL2izp5wG2uPDcSCD5I8cu0crdc/uBJc4TSz8LrbmwIFArjeqITCeuI0
         zCv+s+v5Zv8bYRPnqXyUeckUcR1Fsk8XsdKQ0YFHRUvaBP/sx1nYuRs1aHBCLZimMirY
         e5lw==
X-Gm-Message-State: AOAM533Qm8yFa786HrdHT1SWgSGH2WI+0gYxzN8/vsq9uqbalBe9O49I
        doW5/EOrrCrA5/poVzr0I+njpu31+v4scg==
X-Google-Smtp-Source: ABdhPJxiv/0uKPxi8S+EooAgHxt4JtUqVj2xI9hV2qCJFVLcLPlamDT7ovBKC462uGHeU5BqTED91Q==
X-Received: by 2002:a17:90a:5c81:: with SMTP id r1mr524096pji.175.1611856620790;
        Thu, 28 Jan 2021 09:57:00 -0800 (PST)
Received: from google.com ([2620:15c:f:10:91fd:c415:8a8b:ccc4])
        by smtp.gmail.com with ESMTPSA id z16sm6552063pgj.51.2021.01.28.09.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 09:57:00 -0800 (PST)
Date:   Thu, 28 Jan 2021 09:56:54 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Allow guests to see MSR_IA32_TSX_CTRL even if
 tsx=off
Message-ID: <YBL65uIZggTjGO7F@google.com>
References: <20210128170800.1783502-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128170800.1783502-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021, Paolo Bonzini wrote:
> Userspace that does not know about KVM_GET_MSR_FEATURE_INDEX_LIST will
> generally use the default value for MSR_IA32_ARCH_CAPABILITIES.
> When this happens and the host has tsx=on, it is possible to end up
> with virtual machines that have HLE and RTM disabled, but TSX_CTRL
> disabled.

Thos wording is confusing the heck out of me.  I think what you're saying is
"but TSX disabled in the guest via TSX_CTRL".  I read "but TSX_CTRL disabled" as
saying the the TSX_CTRL itself was disabled/unsupported.

> If the fleet is then switched to tsx=off, kvm_get_arch_capabilities()
> will clear the ARCH_CAP_TSX_CTRL_MSR bit and it will not be possible
> to use the tsx=off as migration destinations, even though the guests
> indeed do not have TSX enabled.
> 
> When tsx=off is used, however, we know that guests will not have
> HLE and RTM (or if userspace sets bogus CPUID data, we do not
> expect HLE and RTM to work in guests).  Therefore we can keep
> TSX_CTRL_RTM_DISABLE set for the entire life of the guests and
> save MSR reads and writes on KVM_RUN and in the user return
> notifiers.
> 
> Cc: stable@vger.kernel.org
> Fixes: cbbaa2727aa3 ("KVM: x86: fix presentation of TSX feature in ARCH_CAPABILITIES")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 12 +++++++++++-
>  arch/x86/kvm/x86.c     |  2 +-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cc60b1fc3ee7..80491a729408 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6863,8 +6863,18 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  			 * No need to pass TSX_CTRL_CPUID_CLEAR through, so
>  			 * let's avoid changing CPUID bits under the host
>  			 * kernel's feet.
> +			 *
> +			 * If the host disabled RTM, we may still need TSX_CTRL
> +			 * to be supported in the guest; for example the guest
> +			 * could have been created on a tsx=on host with hle=0,
> +			 * rtm=0, tsx_ctrl=1 and later migrate to a tsx=off host.
> +			 * In that case however do not change the value on the host,
> +			 * so that TSX remains always disabled.

Oof, can you reword this to clarify what "the value" refers to?  The previous
paragraphs talks about TSX_CTRL_CPUID_CLEAR, and the obvious "value" in the code
is also TSX_CTRL_CPUID_CLEAR, and so I thought the comment was saying "don't
change the value of CPUID_CLEAR", which is non-sensical because that's the the
RTM-enabled case does...

>  			 */
> -			vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> +			if (boot_cpu_has(X86_FEATURE_RTM))
> +				vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
> +			else
> +				vmx->guest_uret_msrs[j].mask = 0;

IMO, this is an unnecessarily confusing way to "remove" the user return MSR.
Changing the ordering to do a 'continue' would also provide a separate chunk of
code for the new comment.  And maybe replace the switch with an if-statement to
avoid a 'continue' buried in a switch?

		vmx->guest_uret_msrs[j].slot = i;
		vmx->guest_uret_msrs[j].data = 0;
		if (index == MSR_IA32_TSX_CTRL) {
			/* Fancy new comment here. */
			if (!boot_cpu_has(X86_FEATURE_RTM))
				continue;

			/*
			 * No need to pass TSX_CTRL_CPUID_CLEAR through, so
			 * let's avoid changing CPUID bits under the host
			 * kernel's feet.
			 */
			vmx->guest_uret_msrs[j].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
		} else {
			vmx->guest_uret_msrs[j].mask = -1ull;

		}

>  			break;
>  		default:
>  			vmx->guest_uret_msrs[j].mask = -1ull;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 76bce832cade..15733013b266 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1401,7 +1401,7 @@ static u64 kvm_get_arch_capabilities(void)

This comments needs to be rewritten, it reflects the old behavior of exposing
the feature iff RTM/TSC is supported by the host.

>  	 *	  This lets the guest use VERW to clear CPU buffers.
>  	 */
>  	if (!boot_cpu_has(X86_FEATURE_RTM))
> -		data &= ~(ARCH_CAP_TAA_NO | ARCH_CAP_TSX_CTRL_MSR);
> +		data &= ~ARCH_CAP_TAA_NO;
>  	else if (!boot_cpu_has_bug(X86_BUG_TAA))
>  		data |= ARCH_CAP_TAA_NO;
>  
> -- 
> 2.26.2
> 
