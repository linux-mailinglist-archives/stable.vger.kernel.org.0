Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A7E127F71
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 16:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfLTPg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 10:36:56 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:58176 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727444AbfLTPg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 10:36:56 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iiKKd-0000nh-69; Fri, 20 Dec 2019 16:36:47 +0100
To:     Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/3] KVM: arm/arm64: correct AArch32 SPSR on exception  entry
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 20 Dec 2019 15:36:47 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Drew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, <stable@vger.kernel.org>
In-Reply-To: <20191220150549.31948-4-mark.rutland@arm.com>
References: <20191220150549.31948-1-mark.rutland@arm.com>
 <20191220150549.31948-4-mark.rutland@arm.com>
Message-ID: <8e3719bf81f135508eac2378bfee60f2@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, drjones@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, peter.maydell@linaro.org, suzuki.poulose@arm.com, will@kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Mark,

On 2019-12-20 15:05, Mark Rutland wrote:
> Confusingly, there are three SPSR layouts that a kernel may need to 
> deal
> with:
>
> (1) An AArch64 SPSR_ELx view of an AArch64 pstate
> (2) An AArch64 SPSR_ELx view of an AArch32 pstate
> (3) An AArch32 SPSR_* view of an AArch32 pstate
>
> When the KVM AArch32 support code deals with SPSR_{EL2,HYP}, it's 
> either
> dealing with #2 or #3 consistently. On arm64 the PSR_AA32_* 
> definitions
> match the AArch64 SPSR_ELx view, and on arm the PSR_AA32_* 
> definitions
> match the AArch32 SPSR_* view.
>
> However, when we inject an exception into an AArch32 guest, we have 
> to
> synthesize the AArch32 SPSR_* that the guest will see. Thus, an 
> AArch64
> host needs to synthesize layout #3 from layout #2.
>
> This patch adds a new host_spsr_to_spsr32() helper for this, and 
> makes
> use of it in the KVM AArch32 support code. For arm64 we need to 
> shuffle
> the DIT bit around, and remove the SS bit, while for arm we can use 
> the
> value as-is.
>
> I've open-coded the bit manipulation for now to avoid having to 
> rework
> the existing PSR_* definitions into PSR64_AA32_* and PSR32_AA32_*
> definitions. I hope to perform a more thorough refactoring in future 
> so
> that we can handle pstate view manipulation more consistently across 
> the
> kernel tree.
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
>  arch/arm/include/asm/kvm_emulate.h   |  5 +++++
>  arch/arm64/include/asm/kvm_emulate.h | 32 
> ++++++++++++++++++++++++++++++++
>  virt/kvm/arm/aarch32.c               |  6 +++---
>  3 files changed, 40 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/include/asm/kvm_emulate.h
> b/arch/arm/include/asm/kvm_emulate.h
> index dee2567661ed..b811576bc456 100644
> --- a/arch/arm/include/asm/kvm_emulate.h
> +++ b/arch/arm/include/asm/kvm_emulate.h
> @@ -53,6 +53,11 @@ static inline void vcpu_write_spsr(struct kvm_vcpu
> *vcpu, unsigned long v)
>  	*__vcpu_spsr(vcpu) = v;
>  }
>
> +static inline unsigned long host_spsr_to_spsr32(unsigned long spsr)
> +{
> +	return spsr;
> +}
> +
>  static inline unsigned long vcpu_get_reg(struct kvm_vcpu *vcpu,
>  					 u8 reg_num)
>  {
> diff --git a/arch/arm64/include/asm/kvm_emulate.h
> b/arch/arm64/include/asm/kvm_emulate.h
> index d69c1efc63e7..98672938f9f9 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -204,6 +204,38 @@ static inline void vcpu_write_spsr(struct
> kvm_vcpu *vcpu, unsigned long v)
>  		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = v;
>  }
>
> +/*
> + * The layout of SPSR for an AArch32 state is different when
> observed from an
> + * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates
> the AArch32
> + * view given an AArch64 view.
> + *
> + * In ARM DDI 0487E.a see:
> + *
> + * - The AArch64 view (SPSR_EL2) in section C5.2.18, page C5-426
> + * - The AArch32 view (SPSR_abt) in section G8.2.126, page G8-6256
> + * - The AArch32 view (SPSR_und) in section G8.2.132, page G8-6280
> + *
> + * Which show the following differences:
> + *
> + * | Bit | AA64 | AA32 | Notes                       |
> + * +-----+------+------+-----------------------------|
> + * | 24  | DIT  | J    | J is RES0 in ARMv8          |
> + * | 21  | SS   | DIT  | SS doesn't exist in AArch32 |
> + *
> + * ... and all other bits are (currently) common.
> + */
> +static inline unsigned long host_spsr_to_spsr32(unsigned long spsr)
> +{
> +	const unsigned long overlap = BIT(24) | BIT(21);
> +	unsigned long dit = !!(spsr & PSR_AA32_DIT_BIT);
> +
> +	spsr &= overlap;

Are you sure this is what you want to do? This doesn't leave
that many bits set in SPSR... :-/

> +
> +	spsr |= dit << 21;
> +
> +	return spsr;
> +}
> +
>  static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
>  {
>  	u32 mode;
> diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
> index 17bcde5c2451..115210e64682 100644
> --- a/virt/kvm/arm/aarch32.c
> +++ b/virt/kvm/arm/aarch32.c
> @@ -128,15 +128,15 @@ static unsigned long get_except32_cpsr(struct
> kvm_vcpu *vcpu, u32 mode)
>
>  static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32
> vect_offset)
>  {
> -	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
> -	bool is_thumb = (new_spsr_value & PSR_AA32_T_BIT);
> +	unsigned long spsr = *vcpu_cpsr(vcpu);
> +	bool is_thumb = (spsr & PSR_AA32_T_BIT);
>  	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
>  	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
>
>  	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
>
>  	/* Note: These now point to the banked copies */
> -	vcpu_write_spsr(vcpu, new_spsr_value);
> +	vcpu_write_spsr(vcpu, host_spsr_to_spsr32(spsr));
>  	*vcpu_reg32(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
>
>  	/* Branch to exception vector */

Apart from what I believe is a missing ~ above, this looks good.

         M.
-- 
Jazz is not dead. It just smells funny...
