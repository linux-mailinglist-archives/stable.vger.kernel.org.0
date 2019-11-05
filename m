Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5235AEFDDC
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 14:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388008AbfKEND3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 08:03:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52658 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388871AbfKEND2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 08:03:28 -0500
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC65DC04BD48
        for <stable@vger.kernel.org>; Tue,  5 Nov 2019 13:03:27 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id z5so7694600wma.5
        for <stable@vger.kernel.org>; Tue, 05 Nov 2019 05:03:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s7UMiwSx+vCiQjpH1QH7fQTluqrllTrzln6sUvQq3Uc=;
        b=KIrpQIFyVIjzA+fPcV3j/K9Jqu73QGkg9IG+Wi2TvzbrbEq8A09odheHy0daXXOf7s
         xCuL9FVd5Fo3hF8NUhc+tL27yTBe5CxYF3L0jo7H5s1WPZaB4nKoDAFKIPaHQW5hT31o
         zb5EbVtBhxCmowZkWtBqWGyjVYLb69ePe1sDu/pMDz28a00b+ZlpjM3FLrsbx00jlmxJ
         ImKCr4YnygfOFAw/lD1Y+xv5P/JlgzkhU+qLdcrXYayQziT/HJeGlXBx/1G8fbykh175
         BUAD4m0nWticvyHpLp0FgPx6BgPsFheAwPfXr+t+2Vlqo1SNP3krd8w7kBZn8RR1v6WH
         h3kg==
X-Gm-Message-State: APjAAAUHX1vGIIoUXVhS4gtzuKcch0Cj4eFoNIq4QSAkQ5I/uWvRKhrF
        5LLlGOqbFXVsLEblZwpOuqTXzopcFCoVmrZOCDtutOAzG7EbbOpmqebKrpQkyTkDKd/QsZNSIdZ
        bu8W4jolD0vi/jrx0
X-Received: by 2002:a1c:b4c1:: with SMTP id d184mr3820334wmf.37.1572959006051;
        Tue, 05 Nov 2019 05:03:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqx16e5pDAWyvVgPQ8cAhoSxNFTGA1ROTMRgZcN07Kx4kU+NmaBv5X2cRoseLCNG7rIflA/IHQ==
X-Received: by 2002:a1c:b4c1:: with SMTP id d184mr3820285wmf.37.1572959005723;
        Tue, 05 Nov 2019 05:03:25 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id i71sm27566438wri.68.2019.11.05.05.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 05:03:25 -0800 (PST)
Subject: Re: [PATCH] KVM: X86: Dynamically allocating MSR number
 lists(msrs_to_save[], emulated_msrs[], msr_based_features[])
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
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
 <477da390-4bdb-c25d-24b1-5b57c3bf78bb@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <cd930947-2621-550c-8a41-e1a396650928@redhat.com>
Date:   Tue, 5 Nov 2019 14:03:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <477da390-4bdb-c25d-24b1-5b57c3bf78bb@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05/11/19 13:51, Xiaoyao Li wrote:
> On 11/5/2019 7:30 PM, Paolo Bonzini wrote:
>> On 05/11/19 10:20, Chenyi Qiang wrote:
>>> The three msr number lists(msrs_to_save[], emulated_msrs[] and
>>> msr_based_features[]) are global arrays of kvm.ko, which are
>>> initialized/adjusted (copy supported MSRs forward to override the
>>> unsupported MSRs) when installing kvm-{intel,amd}.ko, but it doesn't
>>> reset these three arrays to their initial value when uninstalling
>>> kvm-{intel,amd}.ko. Thus, at the next installation, kvm-{intel,amd}.ko
>>> will initialize the modified arrays with some MSRs lost and some MSRs
>>> duplicated.
>>>
>>> So allocate and initialize these three MSR number lists dynamically when
>>> installing kvm-{intel,amd}.ko and free them when uninstalling.
>>>
>>> Cc: stable@vger.kernel.org
>>> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>>   arch/x86/kvm/x86.c | 86 ++++++++++++++++++++++++++++++----------------
>>>   1 file changed, 57 insertions(+), 29 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index ff395f812719..08efcf6351cc 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -1132,13 +1132,15 @@ EXPORT_SYMBOL_GPL(kvm_rdpmc);
>>>    * List of msr numbers which we expose to userspace through
>>> KVM_GET_MSRS
>>>    * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
>>>    *
>>> - * This list is modified at module load time to reflect the
>>> + * The three msr number lists(msrs_to_save, emulated_msrs,
>>> msr_based_features)
>>> + * are allocated and initialized at module load time and freed at
>>> unload time.
>>> + * msrs_to_save is selected from the msrs_to_save_all to reflect the
>>>    * capabilities of the host cpu. This capabilities test skips MSRs
>>> that are
>>> - * kvm-specific. Those are put in emulated_msrs; filtering of
>>> emulated_msrs
>>> + * kvm-specific. Those are put in emulated_msrs_all; filtering of
>>> emulated_msrs
>>>    * may depend on host virtualization features rather than host cpu
>>> features.
>>>    */
>>>   -static u32 msrs_to_save[] = {
>>> +const u32 msrs_to_save_all[] = {
>>
>> This can remain static.
> 
> How about static const u32 msrs_to_save_all[] ?
> 
> Or you think static is enough?

"static const" is best indeed (that's what I meant, but I wasn't very
clear).

Paolo

>>>       MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP,
>>> MSR_IA32_SYSENTER_EIP,
>>>       MSR_STAR,
>>>   #ifdef CONFIG_X86_64
>>> @@ -1179,9 +1181,10 @@ static u32 msrs_to_save[] = {
>>>       MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
>>>   };
>>>   +static u32 *msrs_to_save;
>>
>> You can use ARRAY_SIZE to allocate the destination arrays statically.
> 
> It's much better, then we don't need to allocation and free.
> 
>> Paolo
>>

