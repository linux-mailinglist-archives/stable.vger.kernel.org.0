Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3A031D99D
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 13:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhBQMkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 07:40:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232054AbhBQMko (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 07:40:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613565557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kwzuaEiyZVFka2eJypdxbP/82eiOfBso28jOiH9AUKA=;
        b=iXz2bYeH5iMia/Ot/2I5X8JRbhZvFyaBqUN+5JHv2j1QKZDbVbwtQBoh1a9WC6RHhUG9Xs
        GsQ8AU/i3zqk3xyEJzlFWxf1Tqh9MtCZ5AGjoWu53P0fqZM3RRbIqy1Mhit5x8/KED46Lm
        EdviOl+4DtKwGqRj/qnWiX/xhTyAmUY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-ROvJL4uPNcuXSh-lToagtg-1; Wed, 17 Feb 2021 07:39:15 -0500
X-MC-Unique: ROvJL4uPNcuXSh-lToagtg-1
Received: by mail-wr1-f71.google.com with SMTP id s18so16691780wrf.0
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 04:39:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kwzuaEiyZVFka2eJypdxbP/82eiOfBso28jOiH9AUKA=;
        b=ZfwH2MC/N6olQTSzAMHwBWiVAlqX2DEMNGXik5SN+vosjtr5EgCU2/9h3G2B0BSKiN
         F88N/lR8vYG0aowPgmR69YpTkxPrMNjNNTYk5UCUOlweqDXqjb8Dl9emPvZ71JDmNS/x
         2um90aYKOb3DB4LV+5U83MUySag3v0Gv2NIOrvDJR52smP+SvuBCOr96lmIbSdxlhHKH
         EgsLISAMIGo2HoxPpoFhka1uMiwp+82je9jkhkCr7Gp+2lIfZ7lngGAPpOZSj9O/RrSR
         M1M3BrR0fX1Zlamx9uCgDAHNje9lAi9l1LKlRVhRBiIjeUSHWuGAb5AsvmSFr4y5/6Jl
         +PjA==
X-Gm-Message-State: AOAM533DVFB1hObb+uu5Ygl+nhCXKz/SyoIeLouzrM3LxTPnB3F8t1UL
        C6Bc5dBMkMHP5tyuNcqkHiQNo72MUsw4/TARRRjMxHM5sWmIQE/Ka7Y1zpSVMjNyncmBEMIa5CN
        A1P2fS77B39DCfEcj
X-Received: by 2002:a5d:6d06:: with SMTP id e6mr29079245wrq.425.1613565554499;
        Wed, 17 Feb 2021 04:39:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyO5RgFyzDPvAHit3t+NX64+MftZ0LYDX+9zlVjN9Y5gHiRobFmdiybihEJ1xt5TVIQb5QkHg==
X-Received: by 2002:a5d:6d06:: with SMTP id e6mr29079219wrq.425.1613565554288;
        Wed, 17 Feb 2021 04:39:14 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c2sm3660265wrx.70.2021.02.17.04.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 04:39:13 -0800 (PST)
Subject: Re: [PATCH for 5.4] Fix unsynchronized access to sev members through
 svm_register_enc_region
To:     Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Peter Gonda <pgonda@google.com>, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210208164855.772287-1-pgonda@google.com>
 <2ddf06e9-a541-3d9c-3a0c-db557a04afcc@linux.vnet.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9b271d5a-28b5-bd7e-87d1-c1698aabe6fc@redhat.com>
Date:   Wed, 17 Feb 2021 13:39:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2ddf06e9-a541-3d9c-3a0c-db557a04afcc@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/02/21 10:18, Dov Murik wrote:
> Hi Peter,
> 
> On 08/02/2021 18:48, Peter Gonda wrote:
>> commit 19a23da53932bc8011220bd8c410cb76012de004 upstream.
>>
>> Grab kvm->lock before pinning memory when registering an encrypted
>> region; sev_pin_memory() relies on kvm->lock being held to ensure
>> correctness when checking and updating the number of pinned pages.
>>
>> Add a lockdep assertion to help prevent future regressions.
>>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: Brijesh Singh <brijesh.singh@amd.com>
>> Cc: Sean Christopherson <seanjc@google.com>
>> Cc: x86@kernel.org
>> Cc: kvm@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
>> Signed-off-by: Peter Gonda <pgonda@google.com>
>>
>> V2
>>   - Fix up patch description
>>   - Correct file paths svm.c -> sev.c
>>   - Add unlock of kvm->lock on sev_pin_memory error
>>
>> V1
>>   - https://lore.kernel.org/kvm/20210126185431.1824530-1-pgonda@google.com/
>>
>> Message-Id: <20210127161524.2832400-1-pgonda@google.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/svm.c | 18 +++++++++++-------
>>   1 file changed, 11 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 2b506904be02..93c89f1ffc5d 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -1830,6 +1830,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>>   	struct page **pages;
>>   	unsigned long first, last;
>>
>> +	lockdep_assert_held(&kvm->lock);
>> +
>>   	if (ulen == 0 || uaddr + ulen < uaddr)
>>   		return NULL;
>>
>> @@ -7086,12 +7088,21 @@ static int svm_register_enc_region(struct kvm *kvm,
>>   	if (!region)
>>   		return -ENOMEM;
>>
>> +	mutex_lock(&kvm->lock);
>>   	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>>   	if (!region->pages) {
>>   		ret = -ENOMEM;
>> +		mutex_unlock(&kvm->lock);
>>   		goto e_free;
>>   	}
>>
>> +	region->uaddr = range->addr;
>> +	region->size = range->size;
>> +
>> +	mutex_lock(&kvm->lock);
> 
> This extra mutex_lock call doesn't appear in the upstream patch (committed
> as 19a23da5393), but does appear in the 5.4 and 4.19 backports.  Is it
> needed here?

Ouch.  No it isn't and it's an insta-deadlock.  Let me send a fix.

Paolo

> -Dov
> 
> 
>> +	list_add_tail(&region->list, &sev->regions_list);
>> +	mutex_unlock(&kvm->lock);
>> +
>>   	/*
>>   	 * The guest may change the memory encryption attribute from C=0 -> C=1
>>   	 * or vice versa for this memory range. Lets make sure caches are
>> @@ -7100,13 +7111,6 @@ static int svm_register_enc_region(struct kvm *kvm,
>>   	 */
>>   	sev_clflush_pages(region->pages, region->npages);
>>
>> -	region->uaddr = range->addr;
>> -	region->size = range->size;
>> -
>> -	mutex_lock(&kvm->lock);
>> -	list_add_tail(&region->list, &sev->regions_list);
>> -	mutex_unlock(&kvm->lock);
>> -
>>   	return ret;
>>
>>   e_free:
>>
> 

