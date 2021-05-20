Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A8438AEEA
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 14:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbhETMrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 08:47:45 -0400
Received: from foss.arm.com ([217.140.110.172]:50238 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241464AbhETMqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 08:46:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DB16314FF;
        Thu, 20 May 2021 05:44:38 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.7.235])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43FC83F73B;
        Thu, 20 May 2021 05:44:37 -0700 (PDT)
Date:   Thu, 20 May 2021 13:44:34 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kernel-team@android.com, stable@vger.kernel.org,
        Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] KVM: arm64: Prevent mixed-width VM creation
Message-ID: <20210520124434.GD17233@C02TD0UTHF1T.local>
References: <20210520122253.171545-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520122253.171545-1-maz@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 01:22:53PM +0100, Marc Zyngier wrote:
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
> ---
>  arch/arm64/kvm/reset.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 956cdc240148..1cf308be6ef3 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -166,6 +166,25 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_vcpu *tmp;
> +	int i;
> +
> +	/* Check that the vcpus are either all 32bit or all 64bit */
> +	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
> +		bool w;
> +
> +		w  = test_bit(KVM_ARM_VCPU_EL1_32BIT, tmp->arch.features);
> +		w ^= test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features);
> +
> +		if (w)
> +			return false;
> +	}

I think this is wrong for a single-cpu VM. In that case, the loop will
have a single iteration, and tmp == vcpu, so w must be 0 regardless of
the value of arch.features.

IIUC that doesn't prevent KVM_ARM_VCPU_EL1_32BIT being set when we don't
have the ARM64_HAS_32BIT_EL1 cap, unless that's checked elsewhere?

How about something like:

| static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
| {
| 	bool is_32bit = vcpu_features_32bit(vcpu);
| 	struct kvm_vcpu *tmp;
| 	int i;
| 
| 	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is_32bit)
| 		return false;
| 
| 	kvm_for_each_vcpu(i, tmp, vcpu->kvm) {
| 		if (is_32bit != vcpu_features_32bit(tmp))
| 			return false;
| 	}
| 
| 	return true;
| }

... with a helper in <asm/kvm_emulate.h> like:

| static bool vcpu_features_32bit(struct kvm_vcpu *vcpu)
| {
| 	return test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features);
| }

... or

| static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
| {
| 	return test_bit(feature, vcpu->arch.features);
| }

... so that we can avoid the line splitting required by the length of
the test_bit() expression?

Thanks,
Mark.

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
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
