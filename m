Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B43612B4B3
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 14:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfL0NCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 08:02:07 -0500
Received: from foss.arm.com ([217.140.110.172]:35284 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfL0NCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 08:02:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9C8B1FB;
        Fri, 27 Dec 2019 05:02:06 -0800 (PST)
Received: from [10.37.8.128] (unknown [10.37.8.128])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BDCA03F68F;
        Fri, 27 Dec 2019 05:02:03 -0800 (PST)
Subject: Re: [PATCH 1/3] KVM: arm64: correct PSTATE on exception entry
To:     Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, maz@kernel.org
Cc:     Drew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-2-mark.rutland@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <bace4197-a723-5312-3990-84232aab30d9@arm.com>
Date:   Fri, 27 Dec 2019 13:01:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191220150549.31948-2-mark.rutland@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 12/20/19 3:05 PM, Mark Rutland wrote:
> When KVM injects an exception into a guest, it generates the PSTATE
> value from scratch, configuring PSTATE.{M[4:0],DAIF}, and setting all
> other bits to zero.
>
> This isn't correct, as the architecture specifies that some PSTATE bits
> are (conditionally) cleared or set upon an exception, and others are
> unchanged from the original context.
>
> This patch adds logic to match the architectural behaviour. To make this
> simple to follow/audit/extend, documentation references are provided,
> and bits are configured in order of their layout in SPSR_EL2. This
> layout can be seen in the diagram on ARM DDI 0487E.a page C5-429.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Cc: Drew Jones <drjones@redhat.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/include/uapi/asm/ptrace.h |  1 +
>  arch/arm64/kvm/inject_fault.c        | 69 +++++++++++++++++++++++++++++++++---
>  2 files changed, 65 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
> index 7ed9294e2004..d1bb5b69f1ce 100644
> --- a/arch/arm64/include/uapi/asm/ptrace.h
> +++ b/arch/arm64/include/uapi/asm/ptrace.h
> @@ -49,6 +49,7 @@
>  #define PSR_SSBS_BIT	0x00001000
>  #define PSR_PAN_BIT	0x00400000
>  #define PSR_UAO_BIT	0x00800000
> +#define PSR_DIT_BIT	0x01000000
>  #define PSR_V_BIT	0x10000000
>  #define PSR_C_BIT	0x20000000
>  #define PSR_Z_BIT	0x40000000
> diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> index a9d25a305af5..270d91c05246 100644
> --- a/arch/arm64/kvm/inject_fault.c
> +++ b/arch/arm64/kvm/inject_fault.c
> @@ -14,9 +14,6 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/esr.h>
>  
> -#define PSTATE_FAULT_BITS_64 	(PSR_MODE_EL1h | PSR_A_BIT | PSR_F_BIT | \
> -				 PSR_I_BIT | PSR_D_BIT)
> -
>  #define CURRENT_EL_SP_EL0_VECTOR	0x0
>  #define CURRENT_EL_SP_ELx_VECTOR	0x200
>  #define LOWER_EL_AArch64_VECTOR		0x400
> @@ -50,6 +47,68 @@ static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
>  	return vcpu_read_sys_reg(vcpu, VBAR_EL1) + exc_offset + type;
>  }
>  
> +/*
> + * When an exception is taken, most PSTATE fields are left unchanged in the
> + * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
> + * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
> + * layouts, so we don't need to shuffle these for exceptions from AArch32 EL0.
> + *
> + * For the SPSR_ELx layout for AArch64, see ARM DDI 0487E.a page C5-429.
> + * For the SPSR_ELx layout for AArch32, see ARM DDI 0487E.a page C5-426.

The commit message mentions only the SPSR_ELx layout for AArch64.

> + *
> + * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
> + * MSB to LSB.
> + */
> +static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> +	unsigned long old, new;
> +
> +	old = *vcpu_cpsr(vcpu);
> +	new = 0;
> +
> +	new |= (old & PSR_N_BIT);
> +	new |= (old & PSR_Z_BIT);
> +	new |= (old & PSR_C_BIT);
> +	new |= (old & PSR_V_BIT);
> +
> +	// TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
> +
> +	new |= (old & PSR_DIT_BIT);
> +
> +	// PSTATE.UAO is set to zero upon any exception to AArch64
> +	// See ARM DDI 0487E.a, page D5-2579.
> +
> +	// PSTATE.PAN is unchanged unless overridden by SCTLR_ELx.SPAN
> +	// See ARM DDI 0487E.a, page D5-2578.
> +	new |= (old & PSR_PAN_BIT);
> +	if (sctlr & SCTLR_EL1_SPAN)
> +		new |= PSR_PAN_BIT;

On page D13-3264, it is stated that the PAN bit is set unconditionally if
SCTLR_EL1.SPAN is clear, not set.

> +
> +	// PSTATE.SS is set to zero upon any exception to AArch64
> +	// See ARM DDI 0487E.a, page D2-2452.
> +
> +	// PSTATE.IL is set to zero upon any exception to AArch64
> +	// See ARM DDI 0487E.a, page D1-2306.
> +
> +	// PSTATE.SSBS is set to SCTLR_ELx.DSSBS upon any exception to AArch64
> +	// See ARM DDI 0487E.a, page D13-3258
> +	if (sctlr & SCTLR_ELx_DSSBS)
> +		new |= PSR_SSBS_BIT;
> +
> +	// PSTATE.BTYPE is set to zero upon any exception to AArch64
> +	// See ARM DDI 0487E.a, pages D1-2293 to D1-2294.
> +
> +	new |= PSR_D_BIT;
> +	new |= PSR_A_BIT;
> +	new |= PSR_I_BIT;
> +	new |= PSR_F_BIT;
> +
> +	new |= PSR_MODE_EL1h;
> +
> +	return new;
> +}
> +
>  static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
>  {
>  	unsigned long cpsr = *vcpu_cpsr(vcpu);
> @@ -59,7 +118,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
>  	vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
>  	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
>  
> -	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
> +	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
>  	vcpu_write_spsr(vcpu, cpsr);
>  
>  	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
> @@ -94,7 +153,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
>  	vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
>  	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
>  
> -	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
> +	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
>  	vcpu_write_spsr(vcpu, cpsr);
>  
>  	/*

I've also checked the ARM ARM pages mentioned in the comments, and the
references are correct. The SPSR_EL2 layouts for exceptions taken from AArch64,
respectively AArch32, states are compatible with the way we create the SPSR_EL2
that will be used for eret'ing to the guest, just like the comment says.

I have a suggestion. I think that in ARM ARM, shuffling things between sections
happens a lot less often than adding/removing things from one particular
section, so the pages referenced are more likely to change in later versions.
How about referencing the section instead of the exact page? Something like:
"This layout can be seen in the diagram on ARM DDI 0487E.a, section C5.2.18,
when an exception is taken from AArch64 state"?

Thanks,
Alex
