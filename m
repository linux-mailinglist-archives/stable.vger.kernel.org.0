Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA38391E18
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 19:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhEZR2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 13:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhEZR2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 13:28:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92245C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 10:27:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso772656pji.0
        for <stable@vger.kernel.org>; Wed, 26 May 2021 10:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CoNplCfjrcSDFcQORSZKbieGzoFc0tVb2QaR+5+KW4o=;
        b=R3RaDZ5pPOEcRrGF7YAc9kKiy/s8YyUZPVZigdVu56JdrWEZ5RJmXIqAm16XpdjKR0
         RHaamhV47DtinB3cdibBoorf/HXghHZzXt8BWdNo7YmiN0xerI7l/seKjf5GGoDO802O
         ZROzCsrvp0XjrK3ceden6UztWmQE6kGxZ8PsNpXrO1uUiSxro+Lk9jVC7gMUgwJQY5Tg
         saSa4FplZV8oLd7y0oCsnxANWb1v8PXpi90I0ST+0zDogjRGn3gDlabhPfVHtp7IA6Ei
         +EdC22DACWxWz+d8HTDlioNk+VRu5OcO4q+yiY/KzqQgOu4FtMbA4bnzaMv5ZOTQFNQS
         t6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CoNplCfjrcSDFcQORSZKbieGzoFc0tVb2QaR+5+KW4o=;
        b=XydWw9gNrMyigXP/CFEJayLBSEBCwlUf30DNGF+EyBZV8PFO7mNVYTjz1s6zv0oXYw
         VCbgLVEgWSD/9xB+wpEzkbNNK77pCsv4AixtOP/m+VyHL2VM5ofFOXi/vpvnB5NCCqaF
         dH0jD+AxzkVeN0sUsl7hyk/N0g328YNouDogZBU9+AGoilTlHatu0mkH57CLq0GdUW44
         QjJT/Z0hqXwNOuouOjsi3VG98Pgkn8RJW82+zLCPhXcaxBvCw1uE/v5ZKzsXue37CNOA
         md2AHyc5MNuGuZk0UDHe264Pr971uDRpQulZgF+RXJWPoFkon1rUaUV8cIEwU3iKXjcq
         9APg==
X-Gm-Message-State: AOAM5305/AVioZ+adLuFoMBGVCXU4VtHRAnThsKDnN5Ux8gEadXsmevd
        x7UuHMqPp6kWjf2jMRg41K2E+w==
X-Google-Smtp-Source: ABdhPJya+m+m16xOAuZHqbYdFnytU2u2a+uxUSV+KpX0U1uXb08CAe/nSl/mBbQmPAtCbwDILB/v2g==
X-Received: by 2002:a17:90a:9105:: with SMTP id k5mr37340618pjo.48.1622050024875;
        Wed, 26 May 2021 10:27:04 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s3sm18479111pgs.62.2021.05.26.10.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 10:27:04 -0700 (PDT)
Date:   Wed, 26 May 2021 17:27:00 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Pu Wen <puwen@hygon.cn>
Cc:     x86@kernel.org, joro@8bytes.org, thomas.lendacky@amd.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@suse.de, hpa@zytor.com,
        jroedel@suse.de, sashal@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
Message-ID: <YK6E5NnmRpYYDMTA@google.com>
References: <20210526072424.22453-1-puwen@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526072424.22453-1-puwen@hygon.cn>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 26, 2021, Pu Wen wrote:
> The first two bits of the CPUID leaf 0x8000001F EAX indicate whether
> SEV or SME is supported respectively. It's better to check whether
> SEV or SME is supported before checking the SEV MSR(0xc0010131) to
> see whether SEV or SME is enabled.
> 
> This also avoid the MSR reading failure on the first generation Hygon
> Dhyana CPU which does not support SEV or SME.
> 
> Fixes: eab696d8e8b9 ("x86/sev: Do not require Hypervisor CPUID bit for SEV guests")
> Cc: <stable@vger.kernel.org> # v5.10+
> Signed-off-by: Pu Wen <puwen@hygon.cn>
> ---
>  arch/x86/mm/mem_encrypt_identity.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
> index a9639f663d25..470b20208430 100644
> --- a/arch/x86/mm/mem_encrypt_identity.c
> +++ b/arch/x86/mm/mem_encrypt_identity.c
> @@ -504,10 +504,6 @@ void __init sme_enable(struct boot_params *bp)
>  #define AMD_SME_BIT	BIT(0)
>  #define AMD_SEV_BIT	BIT(1)
>  
> -	/* Check the SEV MSR whether SEV or SME is enabled */
> -	sev_status   = __rdmsr(MSR_AMD64_SEV);
> -	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
> -
>  	/*
>  	 * Check for the SME/SEV feature:
>  	 *   CPUID Fn8000_001F[EAX]
> @@ -519,11 +515,16 @@ void __init sme_enable(struct boot_params *bp)
>  	eax = 0x8000001f;
>  	ecx = 0;
>  	native_cpuid(&eax, &ebx, &ecx, &edx);
> -	if (!(eax & feature_mask))
> +	/* Check whether SEV or SME is supported */
> +	if (!(eax & (AMD_SEV_BIT | AMD_SME_BIT)))

Hmm, checking CPUID at all before MSR_AMD64_SEV is flawed for SEV, e.g. the VMM
doesn't need to pass-through CPUID to attack the guest, it can lie directly.

SEV-ES is protected by virtue of CPUID interception being reflected as #VC, which
effectively tells the guest that it's (probably) an SEV-ES guest and also gives
the guest the opportunity to sanity check the emulated CPUID values provided by
the VMM.

In other words, this patch is flawed, but commit eab696d8e8b9 was also flawed by
conditioning the SEV path on CPUID.0x80000000.

Given that #VC can be handled cleanly, the kernel should be able to handle a #GP
at this point.  So I think the proper fix is to change __rdmsr() to
native_read_msr_safe(), or an open coded variant if necessary, and drop the CPUID
checks for SEV.

The other alternative is to admit that the VMM is still trusted for SEV guests
and take this patch as is (with a reworded changelog).  This probably has my
vote, I don't see much value in pretending that the VMM can't exfiltrate data
from an SEV guest.  In fact, a malicious VMM is probably more likely to get
access to interesting data by _not_ lying about SEV being enabled, because lying
about SEV itself will hose the guest sooner than later.

>  		return;
>  
>  	me_mask = 1UL << (ebx & 0x3f);
>  
> +	/* Check the SEV MSR whether SEV or SME is enabled */
> +	sev_status   = __rdmsr(MSR_AMD64_SEV);
> +	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
> +
>  	/* Check if memory encryption is enabled */
>  	if (feature_mask == AMD_SME_BIT) {
>  		/*
> -- 
> 2.23.0
> 
