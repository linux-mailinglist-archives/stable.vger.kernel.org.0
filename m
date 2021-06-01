Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659C3397489
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 15:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbhFANt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 09:49:28 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6117 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbhFANt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 09:49:28 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FvYLh6cJtzYnjB;
        Tue,  1 Jun 2021 21:45:00 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 21:47:44 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 21:47:43 +0800
Subject: Re: [PATCH stable-5.12.y backport 1/2] KVM: arm64: Commit pending PC
 adjustemnts before returning to userspace
To:     Marc Zyngier <maz@kernel.org>
CC:     <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
        <alexandru.elisei@arm.com>, <wanghaibin.wang@huawei.com>
References: <20210601111238.1059-1-yuzenghui@huawei.com>
 <20210601111238.1059-2-yuzenghui@huawei.com> <87v96x24ir.wl-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <b7cf4102-17e8-f4f8-0314-0a06d7429b4c@huawei.com>
Date:   Tue, 1 Jun 2021 21:47:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87v96x24ir.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 2021/6/1 19:44, Marc Zyngier wrote:
> Hi Zenghui,
> 
> Thanks for having a go at the backport.
> 
> On Tue, 01 Jun 2021 12:12:37 +0100,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>
>> From: Marc Zyngier <maz@kernel.org>
>>
>> commit 26778aaa134a9aefdf5dbaad904054d7be9d656d upstream.
>>
>> KVM currently updates PC (and the corresponding exception state)
>> using a two phase approach: first by setting a set of flags,
>> then by converting these flags into a state update when the vcpu
>> is about to enter the guest.
>>
>> However, this creates a disconnect with userspace if the vcpu thread
>> returns there with any exception/PC flag set. In this case, the exposed
>> context is wrong, as userspace doesn't have access to these flags
>> (they aren't architectural). It also means that these flags are
>> preserved across a reset, which isn't expected.
>>
>> To solve this problem, force an explicit synchronisation of the
>> exception state on vcpu exit to userspace. As an optimisation
>> for nVHE systems, only perform this when there is something pending.
>>
>> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
>> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
>> Tested-by: Zenghui Yu <yuzenghui@huawei.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Cc: stable@vger.kernel.org # 5.11
>> [yuz: stable-5.12.y backport: add __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc
>>  macro manually and keep it consistent with mainline]
> 
> I'd rather you allocated a new number here, irrespective of what
> mainline has (rational below).
> 
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>>  arch/arm64/include/asm/kvm_asm.h   |  1 +
>>  arch/arm64/kvm/arm.c               | 11 +++++++++++
>>  arch/arm64/kvm/hyp/exception.c     |  4 ++--
>>  arch/arm64/kvm/hyp/nvhe/hyp-main.c |  8 ++++++++
>>  4 files changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>> index a8578d650bb6..d7f769bb6c9c 100644
>> --- a/arch/arm64/include/asm/kvm_asm.h
>> +++ b/arch/arm64/include/asm/kvm_asm.h
>> @@ -57,6 +57,7 @@
>>  #define __KVM_HOST_SMCCC_FUNC___kvm_get_mdcr_el2		12
>>  #define __KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs		13
>>  #define __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_aprs		14
>> +#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			21
> 
> This is going to generate a larger than necessary host_hcall array in
> hyp/nvhe/hyp-main.c, which we're trying to keep tightly packed for
> obvious reasons.

It isn't obvious to me ;-). But this creates some invalid entries
(HVC handlers) in the host_hcall array, which is not good. I'll change
__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc to 15. Thanks for your reminder.

> With this nit fixed:
> 
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thanks!

Zenghui
