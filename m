Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C2DF6DBA
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 06:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbfKKFKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 00:10:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:31379 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbfKKFKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 00:10:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 21:10:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,291,1569308400"; 
   d="scan'208";a="207021996"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.239.198.110]) ([10.239.198.110])
  by orsmga006.jf.intel.com with ESMTP; 10 Nov 2019 21:10:49 -0800
Subject: Re: [PATCH v2] KVM: X86: Fix initialization of MSR
 lists(msrs_to_save[], emulated_msrs[] and msr_based_features[])
From:   cqiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20191106063520.1915-1-chenyi.qiang@intel.com>
Message-ID: <7a148552-f5d2-2415-c33d-a162e095a3e5@intel.com>
Date:   Mon, 11 Nov 2019 13:10:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191106063520.1915-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ping for comments :)

On 11/6/2019 2:35 PM, Chenyi Qiang wrote:
> The three MSR lists(msrs_to_save[], emulated_msrs[] and
> msr_based_features[]) are global arrays of kvm.ko, which are
> adjusted (copy supported MSRs forward to override the unsupported MSRs)
> when insmod kvm-{intel,amd}.ko, but it doesn't reset these three arrays
> to their initial value when rmmod kvm-{intel,amd}.ko. Thus, at the next
> installation, kvm-{intel,amd}.ko will do operations on the modified
> arrays with some MSRs lost and some MSRs duplicated.
> 
> So define three constant arrays to hold the initial MSR lists and
> initialize msrs_to_save[], emulated_msrs[] and msr_based_features[]
> based on the constant arrays.
> 
> Cc: stable@vger.kernel.org
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v2:
>   - define initial MSR lists with static const.
>   - change the dynamic allocation of supported MSR lists to static allocation.
> 
>   arch/x86/kvm/x86.c | 51 +++++++++++++++++++++++++---------------------
>   1 file changed, 28 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 89621025577a..0b4b6db5b13f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1138,13 +1138,15 @@ EXPORT_SYMBOL_GPL(kvm_rdpmc);
>    * List of msr numbers which we expose to userspace through KVM_GET_MSRS
>    * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
>    *
> - * This list is modified at module load time to reflect the
> + * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
> + * extract the supported MSRs from the related const lists.
> + * msrs_to_save is selected from the msrs_to_save_all to reflect the
>    * capabilities of the host cpu. This capabilities test skips MSRs that are
> - * kvm-specific. Those are put in emulated_msrs; filtering of emulated_msrs
> + * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
>    * may depend on host virtualization features rather than host cpu features.
>    */
>   
> -static u32 msrs_to_save[] = {
> +static const u32 msrs_to_save_all[] = {
>   	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
>   	MSR_STAR,
>   #ifdef CONFIG_X86_64
> @@ -1185,9 +1187,10 @@ static u32 msrs_to_save[] = {
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
>   };
>   
> +static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
>   static unsigned num_msrs_to_save;
>   
> -static u32 emulated_msrs[] = {
> +static const u32 emulated_msrs_all[] = {
>   	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
>   	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
>   	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
> @@ -1226,7 +1229,7 @@ static u32 emulated_msrs[] = {
>   	 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
>   	 * We always support the "true" VMX control MSRs, even if the host
>   	 * processor does not, so I am putting these registers here rather
> -	 * than in msrs_to_save.
> +	 * than in msrs_to_save_all.
>   	 */
>   	MSR_IA32_VMX_BASIC,
>   	MSR_IA32_VMX_TRUE_PINBASED_CTLS,
> @@ -1245,13 +1248,14 @@ static u32 emulated_msrs[] = {
>   	MSR_KVM_POLL_CONTROL,
>   };
>   
> +static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
>   static unsigned num_emulated_msrs;
>   
>   /*
>    * List of msr numbers which are used to expose MSR-based features that
>    * can be used by a hypervisor to validate requested CPU features.
>    */
> -static u32 msr_based_features[] = {
> +static const u32 msr_based_features_all[] = {
>   	MSR_IA32_VMX_BASIC,
>   	MSR_IA32_VMX_TRUE_PINBASED_CTLS,
>   	MSR_IA32_VMX_PINBASED_CTLS,
> @@ -1276,6 +1280,7 @@ static u32 msr_based_features[] = {
>   	MSR_IA32_ARCH_CAPABILITIES,
>   };
>   
> +static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
>   static unsigned int num_msr_based_features;
>   
>   static u64 kvm_get_arch_capabilities(void)
> @@ -5131,19 +5136,19 @@ static void kvm_init_msr_list(void)
>   	unsigned i, j;
>   
>   	BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
> -			 "Please update the fixed PMCs in msrs_to_save[]");
> +			 "Please update the fixed PMCs in msrs_to_saved_all[]");
>   
>   	perf_get_x86_pmu_capability(&x86_pmu);
>   
> -	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
> -		if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
> +	for (i = j = 0; i < ARRAY_SIZE(msrs_to_save_all); i++) {
> +		if (rdmsr_safe(msrs_to_save_all[i], &dummy[0], &dummy[1]) < 0)
>   			continue;
>   
>   		/*
>   		 * Even MSRs that are valid in the host may not be exposed
>   		 * to the guests in some cases.
>   		 */
> -		switch (msrs_to_save[i]) {
> +		switch (msrs_to_save_all[i]) {
>   		case MSR_IA32_BNDCFGS:
>   			if (!kvm_mpx_supported())
>   				continue;
> @@ -5171,17 +5176,17 @@ static void kvm_init_msr_list(void)
>   			break;
>   		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B: {
>   			if (!kvm_x86_ops->pt_supported() ||
> -				msrs_to_save[i] - MSR_IA32_RTIT_ADDR0_A >=
> +				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
>   				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
>   				continue;
>   			break;
>   		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
> -			if (msrs_to_save[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
> +			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
>   			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>   				continue;
>   			break;
>   		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
> -			if (msrs_to_save[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> +			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>   			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>   				continue;
>   		}
> @@ -5189,31 +5194,31 @@ static void kvm_init_msr_list(void)
>   			break;
>   		}
>   
> -		if (j < i)
> -			msrs_to_save[j] = msrs_to_save[i];
> +		if (j <= i)
> +			msrs_to_save[j] = msrs_to_save_all[i];
>   		j++;
>   	}
>   	num_msrs_to_save = j;
>   
> -	for (i = j = 0; i < ARRAY_SIZE(emulated_msrs); i++) {
> -		if (!kvm_x86_ops->has_emulated_msr(emulated_msrs[i]))
> +	for (i = j = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
> +		if (!kvm_x86_ops->has_emulated_msr(emulated_msrs_all[i]))
>   			continue;
>   
> -		if (j < i)
> -			emulated_msrs[j] = emulated_msrs[i];
> +		if (j <= i)
> +			emulated_msrs[j] = emulated_msrs_all[i];
>   		j++;
>   	}
>   	num_emulated_msrs = j;
>   
> -	for (i = j = 0; i < ARRAY_SIZE(msr_based_features); i++) {
> +	for (i = j = 0; i < ARRAY_SIZE(msr_based_features_all); i++) {
>   		struct kvm_msr_entry msr;
>   
> -		msr.index = msr_based_features[i];
> +		msr.index = msr_based_features_all[i];
>   		if (kvm_get_msr_feature(&msr))
>   			continue;
>   
> -		if (j < i)
> -			msr_based_features[j] = msr_based_features[i];
> +		if (j <= i)
> +			msr_based_features[j] = msr_based_features_all[i];
>   		j++;
>   	}
>   	num_msr_based_features = j;
> 
