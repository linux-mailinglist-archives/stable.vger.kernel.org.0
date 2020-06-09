Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133EA1F39F2
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 13:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgFILl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 07:41:26 -0400
Received: from foss.arm.com ([217.140.110.172]:40974 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgFILl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 07:41:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 788251FB;
        Tue,  9 Jun 2020 04:41:25 -0700 (PDT)
Received: from [10.57.11.57] (unknown [10.57.11.57])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 048F93F66F;
        Tue,  9 Jun 2020 04:41:23 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com, James Morse <james.morse@arm.com>,
        stable@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200609084921.1448445-1-maz@kernel.org>
 <20200609084921.1448445-2-maz@kernel.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <7c173265-3f8e-51df-d700-7e3658a0e4d8@arm.com>
Date:   Tue, 9 Jun 2020 12:41:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609084921.1448445-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-09 09:49, Marc Zyngier wrote:
> AArch32 CP1x registers are overlayed on their AArch64 counterparts
> in the vcpu struct. This leads to an interesting problem as they
> are stored in their CPU-local format, and thus a CP1x register
> doesn't "hit" the lower 32bit portion of the AArch64 register on
> a BE host.
> 
> To workaround this unfortunate situation, introduce a bias trick
> in the vcpu_cp1x() accessors which picks the correct half of the
> 64bit register.
> 
> Cc: stable@vger.kernel.org
> Reported-by: James Morse <james.morse@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/kvm_host.h | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 59029e90b557..e80c0e06f235 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -404,8 +404,14 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
>    * CP14 and CP15 live in the same array, as they are backed by the
>    * same system registers.
>    */
> -#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r)])
> -#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r)])
> +#ifdef CPU_BIG_ENDIAN

Ahem... I think you're missing a "CONFIG_" there ;)

Bonus trickery - for a 0 or 1 value you can simply use IS_ENABLED().

Robin.

> +#define CPx_OFFSET	1
> +#else
> +#define CPx_OFFSET	0
> +#endif
> +
> +#define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_OFFSET])
> +#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_OFFSET])
>   
>   struct kvm_vm_stat {
>   	ulong remote_tlb_flush;
> 
