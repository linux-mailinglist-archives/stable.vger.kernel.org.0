Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1131145F95D
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 02:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241900AbhK0B0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 20:26:46 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:50834 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346730AbhK0BYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 20:24:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyQ7PKr_1637976089;
Received: from 192.168.43.193(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UyQ7PKr_1637976089)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 27 Nov 2021 09:21:30 +0800
Message-ID: <2091ec8e-299a-8b3d-596e-75cf4b68fde1@linux.alibaba.com>
Date:   Sat, 27 Nov 2021 09:21:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH] KVM: MMU: shadow nested paging does not have PKU
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20211126132131.26077-1-pbonzini@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <20211126132131.26077-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021/11/26 21:21, Paolo Bonzini wrote:
> Initialize the mask for PKU permissions as if CR4.PKE=0, avoiding
> incorrect interpretations of the nested hypervisor's page tables.

I think the AMD64 volume2 Architecture Programmer’s Manual does not
specify it, but it seems that for a sane NPT walk, PKU should not work
in NPT.

I once planed to set
	
	cr0 = X86_CR0_PG | X86_CR0_WP;
	cr4 = cr4 & ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);

It adds X86_CR0_WP and removes smep smap just because it is always usermode
access, and it has no meaning for CR0_WP, smep, smap.  Setting it like this
ways can reduce the role combination.

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5942e9c6dd6e..a33b5361bc67 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4855,7 +4855,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>   	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
>   	struct kvm_mmu_role_regs regs = {
>   		.cr0 = cr0,
> -		.cr4 = cr4,
> +		.cr4 = cr4 & ~X86_CR4_PKE,
>   		.efer = efer,
>   	};
>   	union kvm_mmu_role new_role;
> @@ -4919,7 +4919,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
>   	context->direct_map = false;
>   
>   	update_permission_bitmask(context, true);
> -	update_pkru_bitmask(context);
> +	context->pkru_mask = 0;

It is not worth to optimize it since update_pkru_bitmask() will also just
set context->pkru_mask = 0 and then return.

>   	reset_rsvds_bits_mask_ept(vcpu, context, execonly);
>   	reset_ept_shadow_zero_bits_mask(vcpu, context, execonly);
>   }
> 
