Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BA73588A1
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 17:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhDHPg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 11:36:29 -0400
Received: from foss.arm.com ([217.140.110.172]:51910 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231953AbhDHPg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 11:36:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64F18D6E;
        Thu,  8 Apr 2021 08:36:17 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 52BE03F694;
        Thu,  8 Apr 2021 08:36:16 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: Fully zero the vcpu state on reset
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
References: <20210407181308.2265808-1-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <c34842b2-215a-e9d0-7d9d-a8cd64ed1171@arm.com>
Date:   Thu, 8 Apr 2021 16:36:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407181308.2265808-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 4/7/21 7:13 PM, Marc Zyngier wrote:
> On vcpu reset, we expect all the registers to be brought back
> to their initial state, which happens to be a bunch of zeroes.
>
> However, some recent commit broke this, and is now leaving a bunch
> of registers (such as a FP state) with whatever was left by the
> guest. My bad.
>
> Just zero the whole vcpu context on reset. It is more than we
> strictly need, but at least we won't miss anything. This also
> zeroes the __hyp_running_vcpu pointer, which is always NULL
> for a vcpu anyway.

Had a look at struct kvm_cpu_context and indeed the only field which doesn't
represent a guest register is __hyp_running_vcpu. Did a grep for all the places
where __hyp_running_vcpu is used, and indeed the assumption is that for a guest
the pointer is NULL, as __sysreg_restore_el1_state() relies on it.

>
> Cc: stable@vger.kernel.org
> Fixes: e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/reset.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index bd354cd45d28..ef1c49a1a3ad 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -240,8 +240,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  		break;
>  	}
>  
> -	/* Reset core registers */
> -	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
> +	/* Zero all registers */
> +	memset(&vcpu->arch.ctxt, 0, sizeof(vcpu->arch.ctxt));

Checked that code earlier in the function does not touch the guest registers from
vcpu->arch.ctxt, to make sure we're not overwriting other reset values by mistake.
Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>  	vcpu_gp_regs(vcpu)->pstate = pstate;
>  
>  	/* Reset system registers */
