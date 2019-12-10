Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D8711835F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 10:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfLJJSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 04:18:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44126 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726975AbfLJJSC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 04:18:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575969481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwMyxUw+/mSFbkl5BEsUf1e5k5JSpB6gcLmT1T2v/3Y=;
        b=Dg6kjy9V38vqK1QNqe+Uc5huV8Jl4L2kwvLk7I2so2IkOP8ZRmByMvfavovtMKTaa5AgvF
        8TziRj3SGF8y6uIWRooqIU02jqoXOeCz2uNTFwXtS89G06Ha/qOqDbGPQKfSnAlFYEZ8F8
        zrlRsXbhG1wXtQq5v83OvbVfW9m2JII=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-Hyy18C8MP0GSx5oYoHHnyA-1; Tue, 10 Dec 2019 04:17:59 -0500
Received: by mail-wm1-f72.google.com with SMTP id q26so388749wmq.8
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 01:17:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LwMyxUw+/mSFbkl5BEsUf1e5k5JSpB6gcLmT1T2v/3Y=;
        b=LioYQ910sYWWQdFmjNs0CJl5Qh/LXgMWBy60YCMfvj/M988QcrpH0UERiAJrF9xc0R
         BI4rHvKZo9oR3ZDGKxCJ3V0mA74XWUV6TuOp02/PAcr1v9FRMtbFUF/b6u2EeyOVKDHs
         xBjs4FgqBYTM3/TfF7YGqIml//xCqElNK7BWp18dAmWPr56e3oOiCfY69xM3SlTzyS68
         wpct4U34dVx0PKyg5t+XG6oZgjCVFygIMSVx0zFWpgZy5jZbB1XuNj/kCAKaT/5biPpR
         MH2Tr8oRjs3TuKaPh6WsNVuSJvkm4/JMu8I82H0Ybd2NBU6lA6mvNK9y48yLVFjUHBZk
         gXkQ==
X-Gm-Message-State: APjAAAWkM26gOtvaVD+PJuwQx+EQVov9ro5V43G9aPuSvRVijhyZTpxG
        IO2d2b2lqkn4V2lFQSPK+2izDn9AHcWUesrFoC5/VH7N8Lad5n1KVSj4BYd4CHE17K+3yH99D/h
        ObHIalfGswjlg3rzS
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr1868032wrw.255.1575969477749;
        Tue, 10 Dec 2019 01:17:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqyT0r5sAsbVRhAQAWw4X6A3mFDEuojh7E3PXeWsyr9m82fngl68lEwBeshDLcB23QXVcTSFww==
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr1868009wrw.255.1575969477478;
        Tue, 10 Dec 2019 01:17:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id h127sm2412586wme.31.2019.12.10.01.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 01:17:56 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table reserved
 bits
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, stable@vger.kernel.org
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
 <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7b885f53-e0d3-2036-6a06-9cdcbb738ae2@redhat.com>
Date:   Tue, 10 Dec 2019 10:17:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
Content-Language: en-US
X-MC-Unique: Hyy18C8MP0GSx5oYoHHnyA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04/12/19 16:57, Tom Lendacky wrote:
> On 12/4/19 9:40 AM, Paolo Bonzini wrote:
>> The comment in kvm_get_shadow_phys_bits refers to MKTME, but the same is actually
>> true of SME and SEV.  Just use CPUID[0x8000_0008].EAX[7:0] unconditionally if
>> available, it is simplest and works even if memory is not encrypted.
> 
> This isn't correct for AMD. The reduction in physical addressing is
> correct. You can't set, e.g. bit 45, in the nested page table, because
> that will be considered a reserved bit and generate an NPF. When memory
> encryption is enabled today, bit 47 is the encryption indicator bit and
> bits 46:43 must be zero or else an NPF is generated. The hardware uses
> these bits internally based on the whether running as the hypervisor or
> based on the ASID of the guest.

kvm_get_shadow_phys_bits() must be conservative in that:

1) if a bit is reserved it _can_ return a value higher than its index

2) if a bit is used by the processor (for physical address or anything
else) it _must_ return a value higher than its index.

In the SEV case we're not obeying (2), because the function returns 43
when the C bit is bit 47.  The patch fixes that.

Paolo

> 
> Thanks,
> Tom
> 
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/mmu/mmu.c | 20 ++++++++++++--------
>>  1 file changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 6f92b40d798c..1e4ee4f8de5f 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -538,16 +538,20 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
>>  static u8 kvm_get_shadow_phys_bits(void)
>>  {
>>  	/*
>> -	 * boot_cpu_data.x86_phys_bits is reduced when MKTME is detected
>> -	 * in CPU detection code, but MKTME treats those reduced bits as
>> -	 * 'keyID' thus they are not reserved bits. Therefore for MKTME
>> -	 * we should still return physical address bits reported by CPUID.
>> +	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
>> +	 * in CPU detection code, but the processor treats those reduced bits as
>> +	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
>> +	 * the physical address bits reported by CPUID.
>>  	 */
>> -	if (!boot_cpu_has(X86_FEATURE_TME) ||
>> -	    WARN_ON_ONCE(boot_cpu_data.extended_cpuid_level < 0x80000008))
>> -		return boot_cpu_data.x86_phys_bits;
>> +	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
>> +		return cpuid_eax(0x80000008) & 0xff;
>>  
>> -	return cpuid_eax(0x80000008) & 0xff;
>> +	/*
>> +	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
>> +	 * custom CPUID.  Proceed with whatever the kernel found since these features
>> +	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
>> +	 */
>> +	return boot_cpu_data.x86_phys_bits;
>>  }
>>  
>>  static void kvm_mmu_reset_all_pte_masks(void)
>>
> 

