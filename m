Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D541FE35A7
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 16:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409415AbfJXOez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 10:34:55 -0400
Received: from foss.arm.com ([217.140.110.172]:53044 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732293AbfJXOez (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Oct 2019 10:34:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B797E28;
        Thu, 24 Oct 2019 07:34:41 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 464373F6C4;
        Thu, 24 Oct 2019 07:34:40 -0700 (PDT)
Subject: Re: [PATCH for-stable-4.14 42/48] arm64: Always enable spectre-v2
 vulnerability detection
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Will Deacon <will.deacon@arm.com>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
 <20191024124833.4158-43-ard.biesheuvel@linaro.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b41df418-2e09-ac29-92cd-3910f0c05c50@arm.com>
Date:   Thu, 24 Oct 2019 15:34:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191024124833.4158-43-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 10/24/19 1:48 PM, Ard Biesheuvel wrote:
> From: Jeremy Linton <jeremy.linton@arm.com>
>
> [ Upstream commit 8c1e3d2bb44cbb998cb28ff9a18f105fee7f1eb3 ]
>
> Ensure we are always able to detect whether or not the CPU is affected
> by Spectre-v2, so that we can later advertise this to userspace.
>
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/kernel/cpu_errata.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index bf6d8aa9b45a..647c533cfd90 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -76,7 +76,6 @@ cpu_enable_trap_ctr_access(const struct arm64_cpu_capabilities *__unused)
>  	config_sctlr_el1(SCTLR_EL1_UCT, 0);
>  }
>  
> -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
>  #include <asm/mmu_context.h>
>  #include <asm/cacheflush.h>
>  
> @@ -217,11 +216,11 @@ static int detect_harden_bp_fw(void)
>  	    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
>  		cb = qcom_link_stack_sanitization;
>  
> -	install_bp_hardening_cb(cb, smccc_start, smccc_end);
> +	if (IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR))
> +		install_bp_hardening_cb(cb, smccc_start, smccc_end);
>  
>  	return 1;
>  }
> -#endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
>  
>  DEFINE_PER_CPU_READ_MOSTLY(u64, arm64_ssbd_callback_required);
>  
> @@ -457,7 +456,6 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
>  	.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,			\
>  	CAP_MIDR_RANGE_LIST(midr_list)
>  
> -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
>  /*
>   * List of CPUs that do not need any Spectre-v2 mitigation at all.
>   */
> @@ -489,6 +487,12 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
>  	if (!need_wa)
>  		return false;
>  
> +	if (!IS_ENABLED(CONFIG_HARDEN_BRANCH_PREDICTOR)) {
> +		pr_warn_once("spectrev2 mitigation disabled by kernel configuration\n");
> +		__hardenbp_enab = false;

This breaks when building, because __hardenbp_enab is declared in the next patch:

$ make -j32 defconfig && make -j32

[..]
arch/arm64/kernel/cpu_errata.c: In function ‘check_branch_predictor’:
arch/arm64/kernel/cpu_errata.c:492:3: error: ‘__hardenbp_enab’ undeclared (first
use in this function)
   __hardenbp_enab = false;
   ^~~~~~~~~~~~~~~
arch/arm64/kernel/cpu_errata.c:492:3: note: each undeclared identifier is reported
only once for each function it appears in
make[1]: *** [scripts/Makefile.build:326: arch/arm64/kernel/cpu_errata.o] Error 1
make[1]: *** Waiting for unfinished jobs....

Thanks,
Alex

> +		return false;
> +	}
> +
>  	/* forced off */
>  	if (__nospectre_v2) {
>  		pr_info_once("spectrev2 mitigation disabled by command line option\n");
> @@ -500,7 +504,6 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
>  
>  	return (need_wa > 0);
>  }
> -#endif
>  
>  const struct arm64_cpu_capabilities arm64_errata[] = {
>  #if	defined(CONFIG_ARM64_ERRATUM_826319) || \
> @@ -640,13 +643,11 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  		ERRATA_MIDR_ALL_VERSIONS(MIDR_CORTEX_A73),
>  	},
>  #endif
> -#ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
>  	{
>  		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
>  		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
>  		.matches = check_branch_predictor,
>  	},
> -#endif
>  	{
>  		.desc = "Speculative Store Bypass Disable",
>  		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
