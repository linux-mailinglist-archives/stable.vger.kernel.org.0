Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1AD3931F2
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhE0PNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:13:47 -0400
Received: from [110.188.70.11] ([110.188.70.11]:46805 "EHLO spam2.hygon.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S235400AbhE0PNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:13:46 -0400
Received: from MK-FE.hygon.cn ([172.23.18.61])
        by spam2.hygon.cn with ESMTP id 14RF9B2Q005775;
        Thu, 27 May 2021 23:09:11 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from cncheex01.Hygon.cn ([172.23.18.10])
        by MK-FE.hygon.cn with ESMTP id 14RF97TT002292;
        Thu, 27 May 2021 23:09:07 +0800 (GMT-8)
        (envelope-from puwen@hygon.cn)
Received: from [192.168.1.193] (172.23.18.44) by cncheex01.Hygon.cn
 (172.23.18.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Thu, 27 May
 2021 23:09:03 +0800
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
To:     Sean Christopherson <seanjc@google.com>
CC:     <x86@kernel.org>, <joro@8bytes.org>, <thomas.lendacky@amd.com>,
        <dave.hansen@linux.intel.com>, <peterz@infradead.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@suse.de>,
        <hpa@zytor.com>, <jroedel@suse.de>, <sashal@kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <stable@vger.kernel.org>
References: <20210526072424.22453-1-puwen@hygon.cn>
 <YK6E5NnmRpYYDMTA@google.com>
From:   Pu Wen <puwen@hygon.cn>
Message-ID: <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
Date:   Thu, 27 May 2021 23:08:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <YK6E5NnmRpYYDMTA@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.23.18.44]
X-ClientProxiedBy: cncheex02.Hygon.cn (172.23.18.12) To cncheex01.Hygon.cn
 (172.23.18.10)
X-MAIL: spam2.hygon.cn 14RF9B2Q005775
X-DNSRBL: 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/5/27 1:27, Sean Christopherson wrote:
> On Wed, May 26, 2021, Pu Wen wrote:
>> The first two bits of the CPUID leaf 0x8000001F EAX indicate whether
>> SEV or SME is supported respectively. It's better to check whether
>> SEV or SME is supported before checking the SEV MSR(0xc0010131) to
>> see whether SEV or SME is enabled.
>>
>> This also avoid the MSR reading failure on the first generation Hygon
>> Dhyana CPU which does not support SEV or SME.
>>
>> Fixes: eab696d8e8b9 ("x86/sev: Do not require Hypervisor CPUID bit for SEV guests")
>> Cc: <stable@vger.kernel.org> # v5.10+
>> Signed-off-by: Pu Wen <puwen@hygon.cn>
>> ---
>>   arch/x86/mm/mem_encrypt_identity.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
>> index a9639f663d25..470b20208430 100644
>> --- a/arch/x86/mm/mem_encrypt_identity.c
>> +++ b/arch/x86/mm/mem_encrypt_identity.c
>> @@ -504,10 +504,6 @@ void __init sme_enable(struct boot_params *bp)
>>   #define AMD_SME_BIT	BIT(0)
>>   #define AMD_SEV_BIT	BIT(1)
>>   
>> -	/* Check the SEV MSR whether SEV or SME is enabled */
>> -	sev_status   = __rdmsr(MSR_AMD64_SEV);
>> -	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
>> -
>>   	/*
>>   	 * Check for the SME/SEV feature:
>>   	 *   CPUID Fn8000_001F[EAX]
>> @@ -519,11 +515,16 @@ void __init sme_enable(struct boot_params *bp)
>>   	eax = 0x8000001f;
>>   	ecx = 0;
>>   	native_cpuid(&eax, &ebx, &ecx, &edx);
>> -	if (!(eax & feature_mask))
>> +	/* Check whether SEV or SME is supported */
>> +	if (!(eax & (AMD_SEV_BIT | AMD_SME_BIT)))
> 
> Hmm, checking CPUID at all before MSR_AMD64_SEV is flawed for SEV, e.g. the VMM
> doesn't need to pass-through CPUID to attack the guest, it can lie directly.
> 
> SEV-ES is protected by virtue of CPUID interception being reflected as #VC, which
> effectively tells the guest that it's (probably) an SEV-ES guest and also gives
> the guest the opportunity to sanity check the emulated CPUID values provided by
> the VMM.
> 
> In other words, this patch is flawed, but commit eab696d8e8b9 was also flawed by
> conditioning the SEV path on CPUID.0x80000000.

Yes, so I think we'd better admit that the VMM is still trusted for SEV guests
as you mentioned below.

> 
> Given that #VC can be handled cleanly, the kernel should be able to handle a #GP
> at this point.  So I think the proper fix is to change __rdmsr() to
> native_read_msr_safe(), or an open coded variant if necessary, and drop the CPUID

Reading MSR_AMD64_SEV which is not implemented on Hygon Dhyana CPU will cause
the kernel reboot, and native_read_msr_safe() has no help.

> checks for SEV.
> 
> The other alternative is to admit that the VMM is still trusted for SEV guests

Agree with that.

-- 
Regards,
Pu Wen

> and take this patch as is (with a reworded changelog).  This probably has my
> vote, I don't see much value in pretending that the VMM can't exfiltrate data
> from an SEV guest.  In fact, a malicious VMM is probably more likely to get
> access to interesting data by _not_ lying about SEV being enabled, because lying
> about SEV itself will hose the guest sooner than later.
> 
>>   		return;
>>   
>>   	me_mask = 1UL << (ebx & 0x3f);
>>   
>> +	/* Check the SEV MSR whether SEV or SME is enabled */
>> +	sev_status   = __rdmsr(MSR_AMD64_SEV);
>> +	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
>> +
>>   	/* Check if memory encryption is enabled */
>>   	if (feature_mask == AMD_SME_BIT) {
>>   		/*
>> -- 
>> 2.23.0
>>
