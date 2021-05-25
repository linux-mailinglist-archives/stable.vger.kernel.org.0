Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA2C38FDA7
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 11:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhEYJWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 05:22:34 -0400
Received: from foss.arm.com ([217.140.110.172]:53704 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232458AbhEYJWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 05:22:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 592C56D;
        Tue, 25 May 2021 02:21:04 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.37.142])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F3913F73D;
        Tue, 25 May 2021 02:21:01 -0700 (PDT)
Date:   Tue, 25 May 2021 10:20:54 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Steven Price <steven.price@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Prevent mixed-width VM creation
Message-ID: <20210525092054.GA31646@C02TD0UTHF1T.local>
References: <20210524170752.1549797-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524170752.1549797-1-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 06:07:52PM +0100, Marc Zyngier wrote:
> It looks like we have tolerated creating mixed-width VMs since...
> forever. However, that was never the intention, and we'd rather
> not have to support that pointless complexity.
> 
> Forbid such a setup by making sure all the vcpus have the same
> register width.
> 
> Reported-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org

Looks good to me!

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
> 
> Notes:
>     v2: Fix missing check against ARM64_HAS_32BIT_EL1 (Mark)
> 
>  arch/arm64/include/asm/kvm_emulate.h |  5 +++++
>  arch/arm64/kvm/reset.c               | 28 ++++++++++++++++++++++++----
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f612c090f2e4..01b9857757f2 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -463,4 +463,9 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
>  	vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
>  }
>  
> +static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
> +{
> +	return test_bit(feature, vcpu->arch.features);
> +}
> +
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 956cdc240148..d37ebee085cf 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -166,6 +166,25 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu *tmp;
> +	bool is32bit;
> +	int i;
> +
> +	is32bit = vcpu_has_feature(vcpu, KVM_ARM_VCPU_EL1_32BIT);
> +	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
> +		return false;
> +
> +	/* Check that the vcpus are either all 32bit or all 64bit */
> +	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> +		if (vcpu_has_feature(tmp, KVM_ARM_VCPU_EL1_32BIT) != is32bit)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  /**
>   * kvm_reset_vcpu - sets core registers and sys_regs to reset value
>   * @vcpu: The VCPU pointer
> @@ -217,13 +236,14 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> +	if (!vcpu_allowed_register_width(vcpu)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
>  	switch (vcpu->arch.target) {
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
> -			if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1)) {
> -				ret = -EINVAL;
> -				goto out;
> -			}
>  			pstate = VCPU_RESET_PSTATE_SVC;
>  		} else {
>  			pstate = VCPU_RESET_PSTATE_EL1;
> -- 
> 2.30.2
> 
