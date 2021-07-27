Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186403D80F3
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 23:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhG0VKC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 17:10:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49014 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232643AbhG0VIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 17:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627420122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TUpUKaHU71NYL6/47as07mmBCcnbbXJebfKydCKE4tk=;
        b=f10rzjpeX/QnzOkvue8r3z1fBx3nLM6NliSZv6A/yX6zt9Q9e0fGQ2bfUYH13RYZWdxaSo
        d/Ya3HInZhACm5zNpw0Hutb7uhviW/BJZrU3f0hIQBbnEvDX2FkapQKXtsMTYlX4p/vyE8
        WDMudzqXl2eu3qN+X7uTq631PeWrkJU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-BMKQf9HNMPmW1L6anWe69w-1; Tue, 27 Jul 2021 17:08:41 -0400
X-MC-Unique: BMKQf9HNMPmW1L6anWe69w-1
Received: by mail-ed1-f70.google.com with SMTP id b88-20020a509f610000b02903ab1f22e1dcso68261edf.23
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 14:08:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TUpUKaHU71NYL6/47as07mmBCcnbbXJebfKydCKE4tk=;
        b=ISvAfL2PSN4c7JU5+YJ/DBus4EeuEADpB2hZdumzL4XE/5Ode6vxLVDM9xEPhPF0WQ
         vJuB7c7uCblYH076refqVO5Mk9zvjoiskhHHqkTkh5XBFEpPRXGrBKGjC4051v4Im9vW
         Oy7jyiTthlbKCM4wUXOCiPZKjZP7dDuKtLXPY0nAZDbSQmKwC8m+wxs1G+znQGAQJjkt
         Vj7FOeH3XRGomHso1ruMlLEfn/Nev+FEy3HGgSqzOvC8dYHVONcJ+ZwZ4EdybaCXO6J6
         xZ90fd4myh70QUN707rseAkM6/u36V1cLc4LNA4BSKktWGFSY5ZsKIO7IIC+xINyywFm
         jKjA==
X-Gm-Message-State: AOAM5309mbdWFrqBTeTK6KaF/9/uaA00ILgDUyoJ6bIJSdMH2L2AbO0r
        pFTgqMt6ykJDfEduTAEffFnYdG6Iyt1/78jmcvOz3rcNm2S7mMkVDDkVwZHdYZYnJ5KizbeEEdx
        3kgKzOwGOhNbbHc5S
X-Received: by 2002:a50:fd17:: with SMTP id i23mr30313189eds.270.1627420120369;
        Tue, 27 Jul 2021 14:08:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk1VtOYP3rrDEaPWF4C6xsoU2R3/eMAg1NRsJWDrGHre7V3ZZhApRMbe+bviVTVGcOJBusTg==
X-Received: by 2002:a50:fd17:: with SMTP id i23mr30313172eds.270.1627420120204;
        Tue, 27 Jul 2021 14:08:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id u5sm1701982edv.64.2021.07.27.14.08.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 14:08:39 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org, Stas Sergeev <stsp2@yandex.ru>
References: <20210727170620.1643969-1-pbonzini@redhat.com>
 <YQBzgtBXZ4SIz9jF@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] KVM: x86: accept userspace interrupt only if no event
 is injected
Message-ID: <9ae42cf8-e3e5-b8aa-ba86-d680feb09830@redhat.com>
Date:   Tue, 27 Jul 2021 23:08:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQBzgtBXZ4SIz9jF@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/07/21 22:58, Sean Christopherson wrote:
>> ---
>>   arch/x86/kvm/x86.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 4116567f3d44..5e921f1e00db 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4358,8 +4358,18 @@ static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>>   
>>   static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>>   {
>> +	/*
>> +	 * Do not cause an interrupt window exit if an exception
>> +	 * is pending or an event needs reinjection; userspace
>> +	 * might want to inject the interrupt manually using KVM_SET_REGS
>> +	 * or KVM_SET_SREGS.  For that to work, we must be at an
>> +	 * instruction boundary and with no events half-injected.
>> +	 */
>>   	return kvm_arch_interrupt_allowed(vcpu) &&
>> -		kvm_cpu_accept_dm_intr(vcpu);
>> +		kvm_cpu_accept_dm_intr(vcpu) &&
> 
> Opportunistically align this indentation?

Yep, good idea.

>> +	        !kvm_event_needs_reinjection(vcpu)
> 
> Missing &&, apparently the mysterious cherry-pick didn't go so well :-)

Well, yeah.  The only way I can excuse myself, is by not being the kind 
of person that yells for such stupid things...

Paolo

