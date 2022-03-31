Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49464ED28A
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 06:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiCaEPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 00:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiCaEOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 00:14:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98410210474;
        Wed, 30 Mar 2022 20:51:57 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KTTny1shXzCr6s;
        Thu, 31 Mar 2022 11:49:42 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.21; Thu, 31 Mar 2022 11:51:55 +0800
Subject: Re: [PATCH] KVM: x86/pmu: Update AMD PMC smaple period to fix guest
 NMI-watchdog
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Hankland <ehankland@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20220329134632.6064-1-likexu@tencent.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <516a87a9-71d3-a4a7-83bf-1d8e36745e61@huawei.com>
Date:   Thu, 31 Mar 2022 11:51:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20220329134632.6064-1-likexu@tencent.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

helped to Cc stable@ list...

On 2022/3/29 21:46, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
>
> NMI-watchdog is one of the favorite features of kernel developers,
> but it does not work in AMD guest even with vPMU enabled and worse,
> the system misrepresents this capability via /proc.
>
> This is a PMC emulation error. KVM does not pass the latest valid
> value to perf_event in time when guest NMI-watchdog is running, thus
> the perf_event corresponding to the watchdog counter will enter the
> old state at some point after the first guest NMI injection, forcing
> the hardware register PMC0 to be constantly written to 0x800000000001.
>
> Meanwhile, the running counter should accurately reflect its new value
> based on the latest coordinated pmc->counter (from vPMC's point of view)
> rather than the value written directly by the guest.
>
> Fixes: 168d918f2643 ("KVM: x86: Adjust counter sample period after a wrmsr")
> Reported-by: Dongli Cao <caodongli@kingsoft.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/kvm/pmu.h           | 9 +++++++++
>   arch/x86/kvm/svm/pmu.c       | 1 +
>   arch/x86/kvm/vmx/pmu_intel.c | 8 ++------
>   3 files changed, 12 insertions(+), 6 deletions(-)
Recently I also met the "NMI watchdog not working on AMD guest"
issue, I have tested this patch locally and it helps.

Reviewed-by: Yanan Wang <wangyanan55@huawei.com>
Tested-by: Yanan Wang <wangyanan55@huawei.com>

Thanks,
Yanan
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 7a7b8d5b775e..5e7e8d163b98 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -140,6 +140,15 @@ static inline u64 get_sample_period(struct kvm_pmc *pmc, u64 counter_value)
>   	return sample_period;
>   }
>   
> +static inline void pmc_update_sample_period(struct kvm_pmc *pmc)
> +{
> +	if (!pmc->perf_event || pmc->is_paused)
> +		return;
> +
> +	perf_event_period(pmc->perf_event,
> +			  get_sample_period(pmc, pmc->counter));
> +}
> +
>   void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel);
>   void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int fixed_idx);
>   void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx);
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 24eb935b6f85..b14860863c39 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -257,6 +257,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
>   	if (pmc) {
>   		pmc->counter += data - pmc_read_counter(pmc);
> +		pmc_update_sample_period(pmc);
>   		return 0;
>   	}
>   	/* MSR_EVNTSELn */
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index efa172a7278e..e64046fbcdca 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -431,15 +431,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			    !(msr & MSR_PMC_FULL_WIDTH_BIT))
>   				data = (s64)(s32)data;
>   			pmc->counter += data - pmc_read_counter(pmc);
> -			if (pmc->perf_event && !pmc->is_paused)
> -				perf_event_period(pmc->perf_event,
> -						  get_sample_period(pmc, data));
> +			pmc_update_sample_period(pmc);
>   			return 0;
>   		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
>   			pmc->counter += data - pmc_read_counter(pmc);
> -			if (pmc->perf_event && !pmc->is_paused)
> -				perf_event_period(pmc->perf_event,
> -						  get_sample_period(pmc, data));
> +			pmc_update_sample_period(pmc);
>   			return 0;
>   		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
>   			if (data == pmc->eventsel)

