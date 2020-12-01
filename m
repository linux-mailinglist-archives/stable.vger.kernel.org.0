Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79232CA765
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 16:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgLAPtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 10:49:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728965AbgLAPtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 10:49:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606837656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MRH/stvju5NbFs2b6YWVq3MAJCO6jlQDFVSaWBShKTU=;
        b=FxWg1GPv8r0ZLGUa40ktXvmxQ7sgIcBgGdbEgiuqaBrmvuRBraTezwnSyjg6a9g/ULZwAD
        GPqBEmNM3Fe2EtmongnN87MF1CRM3XRNuuJ6zAvmBNbdyS1XQgpFrWIANO8hCxTeHRf7yg
        gfxdWHQRw8VlRbDPXfYO4X7MiiH9NNQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-FuN1WfY3OlqD3X7G5U8xbA-1; Tue, 01 Dec 2020 10:47:35 -0500
X-MC-Unique: FuN1WfY3OlqD3X7G5U8xbA-1
Received: by mail-ej1-f70.google.com with SMTP id bm18so1437843ejb.6
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 07:47:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MRH/stvju5NbFs2b6YWVq3MAJCO6jlQDFVSaWBShKTU=;
        b=Mlb89g/TYRwrtHkyKop94YeOWBQE7NWAn8KofkFdq8EvSv4ueYiUYr3zsB9YpuBt8J
         MYeOlu5+o8oH4b4ZR0KdYMQjy8owpA4QkFUDMSw98QdAb7s4zevNqZuGO7+kg+cwiMQG
         YABCvsgCzjWA7GkHl3twEuy0fukeU0JIi2ntyX3gNLbEVZmyxoytE4j7yJFeMWBHIH/E
         C5Qpy8f/UBaterDnSj5/K20w1tbJ6qxHY86Zk82nQTqpw+KetpZ9WJbJfzC+9bC6HoMK
         rul5o6Vi4EWjBwMl4DfPeEjJBEG0+u6S+zxqoiBQorAVOdqNgxM9/prsAVdI2HSwYVu9
         lU1Q==
X-Gm-Message-State: AOAM530vnMgpsuD/c9j28N28MEiprV+BHpA1iSi2bYeJs2U2fm9/gsmX
        ze6t+md6mqhRvot9lhMVXGDc4+8uX0BnrhB1vgOQg3BnKOFW2y2WkQctJdYuI+fT3n6zbTa0/IA
        9ajvhJhUDq5DfH90V
X-Received: by 2002:a17:906:dbd8:: with SMTP id yc24mr3468356ejb.313.1606837654030;
        Tue, 01 Dec 2020 07:47:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/zEjvU6TLLp3wCA7XHVTPu3PvPf+F/CNFvZbQZlpDSDheIu5IrKKCcbmrZSZI4qnGhhGkkw==
X-Received: by 2002:a17:906:dbd8:: with SMTP id yc24mr3468338ejb.313.1606837653755;
        Tue, 01 Dec 2020 07:47:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n22sm109505edo.43.2020.12.01.07.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 07:47:32 -0800 (PST)
Subject: Re: [PATCH 4.19 08/57] KVM: x86: Fix split-irqchip vs interrupt
 injection window request
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Nikos Tsironis <ntsironis@arrikto.com>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084648.690944071@linuxfoundation.org> <20201201153337.GA23661@amd>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f83a4f26-f6eb-2be6-0111-39ac066a45f8@redhat.com>
Date:   Tue, 1 Dec 2020 16:47:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201201153337.GA23661@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/12/20 16:33, Pavel Machek wrote:
> Hi!
> 
>> - in order to tell userspace we will inject its interrupt ("IRQ
>>    window open" i.e. kvm_vcpu_ready_for_interrupt_injection), both
>>    KVM and the vCPU need to be ready to accept the interrupt.
>>
>> ... and this is what the patch implements.
>>
>> Reported-by: David Woodhouse <dwmw@amazon.co.uk>
>> Analyzed-by: David Woodhouse <dwmw@amazon.co.uk>
>> Cc: stable@vger.kernel.org
> 
> This makes no difference for -stable, but the patch is confused about
> types:
> 
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3351,21 +3351,23 @@ static int kvm_vcpu_ioctl_set_lapic(stru
>>   
>>   static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>>   {
>> +	/*
>> +	 * We can accept userspace's request for interrupt injection
>> +	 * as long as we have a place to store the interrupt number.
>> +	 * The actual injection will happen when the CPU is able to
>> +	 * deliver the interrupt.
>> +	 */
>> +	if (kvm_cpu_has_extint(vcpu))
>> +		return false;
> 
> Since function is "static int" it should probably return 0.

Other way round, it should return static bool. :)  At least it's 
consistently returning a boolean expression, never e.g. negative errno.

Paolo

