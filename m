Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51ECEFDA7
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 13:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388222AbfKEMv5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 07:51:57 -0500
Received: from mga04.intel.com ([192.55.52.120]:64062 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388008AbfKEMv4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 07:51:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 04:51:56 -0800
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="195809553"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 05 Nov 2019 04:51:53 -0800
Subject: Re: [PATCH] KVM: X86: Dynamically allocating MSR number
 lists(msrs_to_save[], emulated_msrs[], msr_based_features[])
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20191105092031.8064-1-chenyi.qiang@intel.com>
 <4a5fd5b4-64b7-726a-57a5-a5c669ce84f6@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <477da390-4bdb-c25d-24b1-5b57c3bf78bb@intel.com>
Date:   Tue, 5 Nov 2019 20:51:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4a5fd5b4-64b7-726a-57a5-a5c669ce84f6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/5/2019 7:30 PM, Paolo Bonzini wrote:
> On 05/11/19 10:20, Chenyi Qiang wrote:
>> The three msr number lists(msrs_to_save[], emulated_msrs[] and
>> msr_based_features[]) are global arrays of kvm.ko, which are
>> initialized/adjusted (copy supported MSRs forward to override the
>> unsupported MSRs) when installing kvm-{intel,amd}.ko, but it doesn't
>> reset these three arrays to their initial value when uninstalling
>> kvm-{intel,amd}.ko. Thus, at the next installation, kvm-{intel,amd}.ko
>> will initialize the modified arrays with some MSRs lost and some MSRs
>> duplicated.
>>
>> So allocate and initialize these three MSR number lists dynamically when
>> installing kvm-{intel,amd}.ko and free them when uninstalling.
>>
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   arch/x86/kvm/x86.c | 86 ++++++++++++++++++++++++++++++----------------
>>   1 file changed, 57 insertions(+), 29 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ff395f812719..08efcf6351cc 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1132,13 +1132,15 @@ EXPORT_SYMBOL_GPL(kvm_rdpmc);
>>    * List of msr numbers which we expose to userspace through KVM_GET_MSRS
>>    * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
>>    *
>> - * This list is modified at module load time to reflect the
>> + * The three msr number lists(msrs_to_save, emulated_msrs, msr_based_features)
>> + * are allocated and initialized at module load time and freed at unload time.
>> + * msrs_to_save is selected from the msrs_to_save_all to reflect the
>>    * capabilities of the host cpu. This capabilities test skips MSRs that are
>> - * kvm-specific. Those are put in emulated_msrs; filtering of emulated_msrs
>> + * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
>>    * may depend on host virtualization features rather than host cpu features.
>>    */
>>   
>> -static u32 msrs_to_save[] = {
>> +const u32 msrs_to_save_all[] = {
> 
> This can remain static.

How about static const u32 msrs_to_save_all[] ?

Or you think static is enough?

>>   	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
>>   	MSR_STAR,
>>   #ifdef CONFIG_X86_64
>> @@ -1179,9 +1181,10 @@ static u32 msrs_to_save[] = {
>>   	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
>>   };
>>   
>> +static u32 *msrs_to_save;
> 
> You can use ARRAY_SIZE to allocate the destination arrays statically.

It's much better, then we don't need to allocation and free.

> Paolo
> 
