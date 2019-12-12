Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 138FE11C9F6
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 10:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfLLJzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 04:55:40 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:49364 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728282AbfLLJzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 04:55:39 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifLC0-0007AX-PZ; Thu, 12 Dec 2019 10:55:32 +0100
To:     Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Ensure 'params' is initialised when looking  up sys register
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 12 Dec 2019 09:55:32 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <james.morse@arm.com>,
        <suzuki.poulose@arm.com>, <kernel-team@android.com>,
        <stable@vger.kernel.org>, Vijaya Kumar K <vijaya.kumar@cavium.com>
In-Reply-To: <20191212094049.12437-1-will@kernel.org>
References: <20191212094049.12437-1-will@kernel.org>
Message-ID: <a4b931f697b2fc7ec6ef5356b84a3939@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, kernel-team@android.com, stable@vger.kernel.org, vijaya.kumar@cavium.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-12-12 09:40, Will Deacon wrote:
> Commit 4b927b94d5df ("KVM: arm/arm64: vgic: Introduce 
> find_reg_by_id()")
> introduced 'find_reg_by_id()', which looks up a system register only 
> if
> the 'id' index parameter identifies a valid system register. As part 
> of
> the patch, existing callers of 'find_reg()' were ported over to the 
> new
> interface, but this breaks 'index_to_sys_reg_desc()' in the case that 
> the
> initial lookup in the vCPU target table fails because we will then 
> call
> into 'find_reg()' for the system register table with an uninitialised
> 'param' as the key to the lookup.
>
> GCC 10 is bright enough to spot this (amongst a tonne of false 
> positives,
> but hey!):
>
>   | arch/arm64/kvm/sys_regs.c: In function 
> ‘index_to_sys_reg_desc.part.0.isra’:
>   | arch/arm64/kvm/sys_regs.c:983:33: warning: ‘params.Op2’ may be 
> used uninitialized in this function [-Wmaybe-uninitialized]
>   |   983 |   (u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2);
>   | [...]
>
> Revert the hunk of 4b927b94d5df which breaks 
> 'index_to_sys_reg_desc()' so
> that the old behaviour of checking the index upfront is restored.

Huhuh... Well spotted GCC 10! And thanks Will for the fix.

>
> Cc: <stable@vger.kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> Fixes: 4b927b94d5df ("KVM: arm/arm64: vgic: Introduce 
> find_reg_by_id()")
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 46822afc57e0..01a515e0171e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2360,8 +2360,11 @@ static const struct sys_reg_desc
> *index_to_sys_reg_desc(struct kvm_vcpu *vcpu,
>  	if ((id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM64_SYSREG)
>  		return NULL;
>
> +	if (!index_to_params(id, &params))
> +		return NULL;
> +
>  	table = get_target_table(vcpu->arch.target, true, &num);
> -	r = find_reg_by_id(id, &params, table, num);
> +	r = find_reg(&params, table, num);
>  	if (!r)
>  		r = find_reg(&params, sys_reg_descs, ARRAY_SIZE(sys_reg_descs));

Applied, thanks.

         M.
-- 
Jazz is not dead. It just smells funny...
