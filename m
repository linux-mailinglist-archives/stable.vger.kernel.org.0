Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D66335CEF9
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244580AbhDLQyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:54:06 -0400
Received: from foss.arm.com ([217.140.110.172]:55888 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245663AbhDLQv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:51:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF20512FC;
        Mon, 12 Apr 2021 09:51:40 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CB453F73B;
        Mon, 12 Apr 2021 09:51:38 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Fully zero the vcpu state on reset
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        stable@vger.kernel.org
References: <20210409173257.3031729-1-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <977338ef-9b06-1fec-9075-5e9cbdb89bc2@arm.com>
Date:   Mon, 12 Apr 2021 17:51:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210409173257.3031729-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 4/9/21 6:32 PM, Marc Zyngier wrote:
> On vcpu reset, we expect all the registers to be brought back
> to their initial state, which happens to be a bunch of zeroes.
>
> However, some recent commit broke this, and is now leaving a bunch
> of registers (such as the FP state) with whatever was left by the
> guest. My bad.
>
> Zero the reset of the state (32bit SPSRs and FPSIMD state).
>
> Cc: stable@vger.kernel.org
> Fixes: e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>
> Notes:
>     v2: Only reset the FPSIMD state and the AArch32 SPSRs to avoid
>     corrupting CNTVOFF in creative ways.

I missed that last time, sorry.

>
>  arch/arm64/kvm/reset.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index bd354cd45d28..4b5acd84b8c8 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -242,6 +242,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  
>  	/* Reset core registers */
>  	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
> +	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
> +	vcpu->arch.ctxt.spsr_abt = 0;
> +	vcpu->arch.ctxt.spsr_und = 0;
> +	vcpu->arch.ctxt.spsr_irq = 0;
> +	vcpu->arch.ctxt.spsr_fiq = 0;

Checked, and the only fields not touched by the change from struct kvm_cpu_context
are sys_regs and __hyp_running_cpu. __hyp_running_cpu is assumed to be NULL for a
guest and it doesn't change during the lifetime of a VCPU; it is set to NULL when
struct kvm_vcpu is allocated.

CNTVOFF_EL2 is not accessible to userspace (it's not in the sys_reg_descs and in
the invariant_sys_regs arrays), so it's not necessary to reset it in case
userspace changed it. Same for the other registers that are part of the VCPU
context, but are not in sys_reg_descs.

I think it's a good choice to skip zeroing the system registers. I compared
vcpu->arch.ctxt.sys_regs with sys_regs_descs, there were quite a few registers
that were part of the vcpu context (pointer authentication registers, virtual
timer registers, and others) and not part of sys_regs_descs. If someone adds a
register to the VCPU context, but not to sys_regs_descs, I think it would have
been easy to miss the fact that KVM_ARM_VCPU_INIT zeroes it.

Hopefully I haven't missed anything:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>  	vcpu_gp_regs(vcpu)->pstate = pstate;
>  
>  	/* Reset system registers */
