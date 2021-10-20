Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5196D434523
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 08:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhJTGbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 02:31:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:22873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229715AbhJTGbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Oct 2021 02:31:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634711351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tW3hW/s6nfgh+U2u9259sakKZVN9ayfCr3/bbe1Xo7Q=;
        b=Qa0qpa4lqKrbPJo33QyRSeyHVD/TA2hA+CYMSOYdICiutxfhLU//5czV+lkGRVvXx5//WF
        eL9Xk9ZT9n5gvDU8HB1TWxCxZ6OgAdROXzi63/K4bub1urWbD02DEPqSwmxacBtAOrVJTU
        /ine3jWLFA1YACO71Qwnr7Yj26uJ/0o=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-RAThHMRvPwqfS4um65W6sg-1; Wed, 20 Oct 2021 02:29:09 -0400
X-MC-Unique: RAThHMRvPwqfS4um65W6sg-1
Received: by mail-wm1-f69.google.com with SMTP id c5-20020a05600c0ac500b0030dba7cafc9so3613412wmr.5
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 23:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tW3hW/s6nfgh+U2u9259sakKZVN9ayfCr3/bbe1Xo7Q=;
        b=tJNH/Ti25/lLUI94nFZ2ha/sLd+xZCe3J0TrczypajGSXdYs8rI/F8BbnOz0aqN2zn
         E1KcUgKkusI0q9oWVuWfE4ofSRrNDyGgqb/D3i9iC6jGh2idPqnKSRIBgyN81yxLgxnz
         FRACQ1SBT9pHZqz7RcjQm10bCL4roAAVTTJs6xr9iIJ8lrVAu6vv6+tcdWgj0DUBIpvW
         5HLZCuaC/oE45F0cY9yu3QFNOfzrykARnN1OC8OKJaOi0Nf0GfvnclCvWiLvIDOo+5MZ
         6u4KC7XJgI/I/zG3fbvktKFWuh20R+Vv4YA3WQd5RMJfYARMd2K6mVChPUkLsJ1LauvZ
         4ZdQ==
X-Gm-Message-State: AOAM531umM9lvfUn9qt4D4dIBVG17JKexOzMD7xhfVRraZ5iigmX4+AL
        UX3tomtM5E7LTKxsvZEAHt3JBKXSZYmX51eeaLvnjMKoDFJlvRX2F57/wk1leq+9+We+IfDkBKz
        Io+MdVphSaF3+xW1R
X-Received: by 2002:adf:8bcf:: with SMTP id w15mr50375110wra.144.1634711348296;
        Tue, 19 Oct 2021 23:29:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwArbU0K2xQ1RlN8mwuYS/ET2wxgAM6vKPBaiqbfvql4zYBtUA6C0l0qN0fp8WltzEzQBycqg==
X-Received: by 2002:adf:8bcf:: with SMTP id w15mr50375073wra.144.1634711348023;
        Tue, 19 Oct 2021 23:29:08 -0700 (PDT)
Received: from [192.168.100.42] ([82.142.24.54])
        by smtp.gmail.com with ESMTPSA id o12sm1041970wrv.78.2021.10.19.23.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 23:29:07 -0700 (PDT)
Message-ID: <2a13119c-ccec-1dd5-8cf6-da07a9d8fe6f@redhat.com>
Date:   Wed, 20 Oct 2021 08:29:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2] KVM: PPC: Defer vtime accounting 'til after IRQ
 handling
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kurz <groug@kaod.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@ozlabs.org>,
        stable@vger.kernel.org
References: <20211007142856.41205-1-lvivier@redhat.com>
 <875yu17rxk.fsf@mpe.ellerman.id.au>
 <d7f59d0e-eac2-7978-4067-9258c8b1aefe@redhat.com>
 <1634263564.zfj0ajf8eh.astroid@bobo.none>
From:   Laurent Vivier <lvivier@redhat.com>
In-Reply-To: <1634263564.zfj0ajf8eh.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/10/2021 04:23, Nicholas Piggin wrote:
> Excerpts from Laurent Vivier's message of October 13, 2021 7:30 pm:
>> On 13/10/2021 01:18, Michael Ellerman wrote:
>>> Laurent Vivier <lvivier@redhat.com> writes:
>>>> Commit 112665286d08 moved guest_exit() in the interrupt protected
>>>> area to avoid wrong context warning (or worse), but the tick counter
>>>> cannot be updated and the guest time is accounted to the system time.
>>>>
>>>> To fix the problem port to POWER the x86 fix
>>>> 160457140187 ("Defer vtime accounting 'til after IRQ handling"):
>>>>
>>>> "Defer the call to account guest time until after servicing any IRQ(s)
>>>>    that happened in the guest or immediately after VM-Exit.  Tick-based
>>>>    accounting of vCPU time relies on PF_VCPU being set when the tick IRQ
>>>>    handler runs, and IRQs are blocked throughout the main sequence of
>>>>    vcpu_enter_guest(), including the call into vendor code to actually
>>>>    enter and exit the guest."
>>>>
>>>> Fixes: 112665286d08 ("KVM: PPC: Book3S HV: Context tracking exit guest context before enabling irqs")
>>>> Cc: npiggin@gmail.com
>>>> Cc: <stable@vger.kernel.org> # 5.12
>>>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>>>> ---
>>>>
>>>> Notes:
>>>>       v2: remove reference to commit 61bd0f66ff92
>>>>           cc stable 5.12
>>>>           add the same comment in the code as for x86
>>>>
>>>>    arch/powerpc/kvm/book3s_hv.c | 24 ++++++++++++++++++++----
>>>>    1 file changed, 20 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>>>> index 2acb1c96cfaf..a694d1a8f6ce 100644
>>>> --- a/arch/powerpc/kvm/book3s_hv.c
>>>> +++ b/arch/powerpc/kvm/book3s_hv.c
>>> ...
>>>> @@ -4506,13 +4514,21 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u64 time_limit,
>>>>    
>>>>    	srcu_read_unlock(&kvm->srcu, srcu_idx);
>>>>    
>>>> +	context_tracking_guest_exit();
>>>> +
>>>>    	set_irq_happened(trap);
>>>>    
>>>>    	kvmppc_set_host_core(pcpu);
>>>>    
>>>> -	guest_exit_irqoff();
>>>> -
>>>>    	local_irq_enable();
>>>> +	/*
>>>> +	 * Wait until after servicing IRQs to account guest time so that any
>>>> +	 * ticks that occurred while running the guest are properly accounted
>>>> +	 * to the guest.  Waiting until IRQs are enabled degrades the accuracy
>>>> +	 * of accounting via context tracking, but the loss of accuracy is
>>>> +	 * acceptable for all known use cases.
>>>> +	 */
>>>> +	vtime_account_guest_exit();
>>>
>>> This pops a warning for me, running guest(s) on Power8:
>>>    
>>>     [  270.745303][T16661] ------------[ cut here ]------------
>>>     [  270.745374][T16661] WARNING: CPU: 72 PID: 16661 at arch/powerpc/kernel/time.c:311 vtime_account_kernel+0xe0/0xf0
>>
>> Thank you, I missed that...
>>
>> My patch is wrong, I have to add vtime_account_guest_exit() before the local_irq_enable().
> 
> I thought so because if we take an interrupt after exiting the guest that
> should be accounted to kernel not guest.
> 
>>
>> arch/powerpc/kernel/time.c
>>
>>    305 static unsigned long vtime_delta(struct cpu_accounting_data *acct,
>>    306                                  unsigned long *stime_scaled,
>>    307                                  unsigned long *steal_time)
>>    308 {
>>    309         unsigned long now, stime;
>>    310
>>    311         WARN_ON_ONCE(!irqs_disabled());
>> ...
>>
>> But I don't understand how ticks can be accounted now if irqs are still disabled.
>>
>> Not sure it is as simple as expected...
> 
> I don't know all the timer stuff too well. The
> !CONFIG_VIRT_CPU_ACCOUNTING case is relying on PF_VCPU to be set when
> the host timer interrupt runs irqtime_account_process_tick runs so it
> can accumulate that tick to the guest?
> 
> That probably makes sense then, but it seems like we need that in a
> different place. Timer interrupts are not guaranteed to be the first one
> to occur when interrupts are enabled.
> 
> Maybe a new tick_account_guest_exit() and move PF_VCPU clearing to that
> for tick based accounting. Call it after local_irq_enable and call the
> vtime accounting before it. Would that work?

Hi Nick,

I think I will not have the time to have a look to fix that?

Could you try?

Thanks,
Laurent

