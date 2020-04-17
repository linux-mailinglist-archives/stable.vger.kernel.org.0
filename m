Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFF31ADE9C
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 15:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730686AbgDQNl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 09:41:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:41588 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730656AbgDQNl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 09:41:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A531DAFF0;
        Fri, 17 Apr 2020 13:41:23 +0000 (UTC)
Subject: Re: [PATCH v3 1/9] xen/events: avoid removing an event channel while
 handling it
To:     Jan Beulich <jbeulich@suse.com>
Cc:     security@xen.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, stable@vger.kernel.org
References: <20200417115454.24931-1-jgross@suse.com>
 <20200417115454.24931-2-jgross@suse.com>
 <e0d90bd4-c7f3-f411-6ebe-c1f524185fae@suse.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <2cbf99a5-6ae8-422f-fd0c-727341be80f2@suse.com>
Date:   Fri, 17 Apr 2020 15:41:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <e0d90bd4-c7f3-f411-6ebe-c1f524185fae@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17.04.20 14:26, Jan Beulich wrote:
> On 17.04.2020 13:54, Juergen Gross wrote:
>> @@ -603,6 +611,7 @@ static void __unbind_from_irq(unsigned int irq)
>>   {
>>   	evtchn_port_t evtchn = evtchn_from_irq(irq);
>>   	struct irq_info *info = irq_get_handler_data(irq);
>> +	unsigned long flags;
>>   
>>   	if (info->refcnt > 0) {
>>   		info->refcnt--;
>> @@ -610,8 +619,10 @@ static void __unbind_from_irq(unsigned int irq)
>>   			return;
>>   	}
>>   
>> +	write_lock_irqsave(&evtchn_rwlock, flags);
> 
> This placement looks odd - it doesn't guard the earlier if()
> (i.e. isn't covering as wide a scope as one might expect)
> but also isn't inside ...
> 
>>   	if (VALID_EVTCHN(evtchn)) {
> 
> ... this if(), which would be the minimal locked region needed).

Right, I can move the lock inside this if ().

> While you have a comment at the declaration of the lock, I'd
> recommend to have another one here clarifying that the less
> than expected locked region is because the lock is to guard
> only against removal, not also against other races (which I
> assume are taken care of by other means).

Indeed, there is mutex_lock(&irq_mapping_update_lock) around all
invocations of __unbind_from_irq().

> 
>> -		unsigned int cpu = cpu_from_irq(irq);
>> +		unsigned int cpu = cpu_from_irq(irq);;
> 
> Stray and unwanted change?

Yes.

> 
>> @@ -629,6 +640,8 @@ static void __unbind_from_irq(unsigned int irq)
>>   		xen_irq_info_cleanup(info);
>>   	}
>>   
>> +	write_unlock_irqrestore(&evtchn_rwlock, flags);
>> +
>>   	xen_free_irq(irq);
>>   }
>>   
>> @@ -1219,6 +1232,8 @@ static void __xen_evtchn_do_upcall(void)
>>   	struct vcpu_info *vcpu_info = __this_cpu_read(xen_vcpu);
>>   	int cpu = smp_processor_id();
>>   
>> +	read_lock(&evtchn_rwlock);
>> +
>>   	do {
>>   		vcpu_info->evtchn_upcall_pending = 0;
>>   
>> @@ -1229,6 +1244,8 @@ static void __xen_evtchn_do_upcall(void)
>>   		virt_rmb(); /* Hypervisor can set upcall pending. */
>>   
>>   	} while (vcpu_info->evtchn_upcall_pending);
>> +
>> +	read_unlock(&evtchn_rwlock);
>>   }
> 
> So you guard against removal, but not against insertion - is
> insertion done in a way that partial setup is never a problem?
> (Looking at in particular the FIFO code I can't easily
> convince myself this is the case.)

The IRQ related to the event channel is enabled only after the
event channel is setup completely. This is done by request_irq()
or similar calls (e.g. request_threaded_irq()).

I'll add a comment explaining that.


Juergen
