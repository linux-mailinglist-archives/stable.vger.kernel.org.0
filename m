Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C53298DC3
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 14:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421929AbgJZNZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 09:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1421879AbgJZNZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 09:25:39 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DB6F207DE;
        Mon, 26 Oct 2020 13:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603718738;
        bh=jd8Q4kdtlWtB7AqNBmkjiRnWiSHI9D/KJeUPOz0AWy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dDutW0cjwSot8W7ueOoUKhlVqjhB3NvSXX77NINI32JVn73xZ0rWMtxzgygBDDEOa
         kHgcprUXPxAEii0VTmxURoKug47KR2ZzRLq8SFN3W5hbyF4rwuAfW+qrcY+OJlHZV6
         m0/ID1gn5yRTapIXHf0c9zeLqHrviQWbsqs5nLmA=
Date:   Mon, 26 Oct 2020 13:25:33 +0000
From:   Will Deacon <will@kernel.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't
 return SMCCC_RET_NOT_REQUIRED
Message-ID: <20201026132533.GC24349@willie-the-truck>
References: <20201023154751.1973872-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023154751.1973872-1-swboyd@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 23, 2020 at 08:47:50AM -0700, Stephen Boyd wrote:
> According to the SMCCC spec[1](7.5.2 Discovery) the
> ARM_SMCCC_ARCH_WORKAROUND_1 function id only returns 0, 1, and
> SMCCC_RET_NOT_SUPPORTED.
> 
>  0 is "workaround required and safe to call this function"
>  1 is "workaround not required but safe to call this function"
>  SMCCC_RET_NOT_SUPPORTED is "might be vulnerable or might not be, who knows, I give up!"
> 
> SMCCC_RET_NOT_SUPPORTED might as well mean "workaround required, except
> calling this function may not work because it isn't implemented in some
> cases". Wonderful. We map this SMC call to
> 
>  0 is SPECTRE_MITIGATED
>  1 is SPECTRE_UNAFFECTED
>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
> 
> For KVM hypercalls (hvc), we've implemented this function id to return
> SMCCC_RET_NOT_SUPPORTED, 0, and SMCCC_RET_NOT_REQUIRED. One of those
> isn't supposed to be there. Per the code we call
> arm64_get_spectre_v2_state() to figure out what to return for this
> feature discovery call.
> 
>  0 is SPECTRE_MITIGATED
>  SMCCC_RET_NOT_REQUIRED is SPECTRE_UNAFFECTED
>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
> 
> Let's clean this up so that KVM tells the guest this mapping:
> 
>  0 is SPECTRE_MITIGATED
>  1 is SPECTRE_UNAFFECTED
>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
> 
> Note: SMCCC_RET_NOT_AFFECTED is 1 but isn't part of the SMCCC spec
> 
> Cc: Andre Przywara <andre.przywara@arm.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://developer.arm.com/documentation/den0028/latest [1]
> Fixes: c118bbb52743 ("arm64: KVM: Propagate full Spectre v2 workaround state to KVM guests")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> I see that before commit c118bbb52743 ("arm64: KVM: Propagate full
> Spectre v2 workaround state to KVM guests") we had this mapping:
> 
>  0 is SPECTRE_MITIGATED
>  SMCCC_RET_NOT_SUPPORTED is SPECTRE_VULNERABLE
> 
> so the return value '1' wasn't there then. Once the commit was merged we
> introduced the notion of NOT_REQUIRED here when it shouldn't have been
> introduced.
> 
> Changes from v2:
>  * Moved define to header file and used it
> 
> Changes from v1:
>  * Way longer commit text, more background (sorry)
>  * Dropped proton-pack part because it was wrong
>  * Rebased onto other patch accepted upstream
> 
>  arch/arm64/kernel/proton-pack.c | 2 --
>  arch/arm64/kvm/hypercalls.c     | 2 +-
>  include/linux/arm-smccc.h       | 2 ++
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
> index 25f3c80b5ffe..c18eb7d41274 100644
> --- a/arch/arm64/kernel/proton-pack.c
> +++ b/arch/arm64/kernel/proton-pack.c
> @@ -135,8 +135,6 @@ static enum mitigation_state spectre_v2_get_cpu_hw_mitigation_state(void)
>  	return SPECTRE_VULNERABLE;
>  }
>  
> -#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	(1)
> -
>  static enum mitigation_state spectre_v2_get_cpu_fw_mitigation_state(void)
>  {
>  	int ret;
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 9824025ccc5c..25ea4ecb6449 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -31,7 +31,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  				val = SMCCC_RET_SUCCESS;
>  				break;
>  			case SPECTRE_UNAFFECTED:
> -				val = SMCCC_RET_NOT_REQUIRED;
> +				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
>  				break;
>  			}
>  			break;
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index 15c706fb0a37..0e50ba3e88d7 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -86,6 +86,8 @@
>  			   ARM_SMCCC_SMC_32,				\
>  			   0, 0x7fff)
>  
> +#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1

I thought we'd stick this in asm/spectre.h, but here is also good:

Acked-by: Will Deacon <will@kernel.org>

Will
