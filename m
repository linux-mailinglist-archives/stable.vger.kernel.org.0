Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99492A4721
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbgKCN7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:59:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:41000 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727986AbgKCN6O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 08:58:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604411892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4tAgfDjpBMR+qSnc1MkiG5FfxRM5aK21s8veR+9mj5w=;
        b=HudxpmGStHwp8jGHSPWTEindOOe91aMGcAvFKZ1Ar2V1liOp437LXNPe6EmpZGZC3BmsBQ
        t7xlUONGGyvbOsunexBikb1ar80lDd1mUYc3pGxZ9s+bqtbdAptt+Kd/oGa6H7GnDrXkzT
        tBOE8zG6+kCLVm5SdUWRdkdl9FYfQdU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D13A2ABF4;
        Tue,  3 Nov 2020 13:58:12 +0000 (UTC)
Subject: Re: [PATCH 02/13] xen/events: avoid removing an event channel while
 handling it
To:     Pavel Machek <pavel@denx.de>, marmarek@invisiblethingslab.com,
        luke1337@theori.io, sstabellini@kernel.org, wl@xen.org,
        Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
References: <20201103084150.8625-1-jgross@suse.com>
 <20201103084150.8625-3-jgross@suse.com> <20201103131501.GA30723@duo.ucw.cz>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <66f6fc98-6005-b70d-4036-32a3599ca6c9@suse.com>
Date:   Tue, 3 Nov 2020 14:58:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201103131501.GA30723@duo.ucw.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03.11.20 14:15, Pavel Machek wrote:
> Hi!
> 
>> Today it can happen that an event channel is being removed from the
>> system while the event handling loop is active. This can lead to a
>> race resulting in crashes or WARN() splats when trying to access the
>> irq_info structure related to the event channel.
>>
>> Fix this problem by using a rwlock taken as reader in the event
>> handling loop and as writer when deallocating the irq_info structure.
>>
>> As the observed problem was a NULL dereference in evtchn_from_irq()
>> make this function more robust against races by testing the irq_info
>> pointer to be not NULL before dereferencing it.
>>
>> And finally make all accesses to evtchn_to_irq[row][col] atomic ones
>> in order to avoid seeing partial updates of an array element in irq
>> handling. Note that irq handling can be entered only for event channels
>> which have been valid before, so any not populated row isn't a problem
>> in this regard, as rows are only ever added and never removed.
>>
>> This is XSA-331.
>>
>> This is upstream commit 073d0552ead5bfc7a3a9c01de590e924f11b5dd2
> 
> This one is mismerged.

Thanks for noticing!

Greg, do you want me to send the series again or only this patch?


Juergen

> 
> 
>> @@ -1242,6 +1269,8 @@ static void __xen_evtchn_do_upcall(void)
>>   	int cpu = get_cpu();
>>   	unsigned count;
>>   
>> +	read_lock(&evtchn_rwlock);
>> +
>>   	do {
>>   		vcpu_info->evtchn_upcall_pending = 0;
>>   
>> @@ -1256,6 +1285,8 @@ static void __xen_evtchn_do_upcall(void)
>>   		__this_cpu_write(xed_nesting_count, 0);
>>   	} while (count != 1 || vcpu_info->evtchn_upcall_pending);
>>   
>> +	read_unlock(&evtchn_rwlock);
>> +
>>   out:
> 
> read_unlock needs to be after the out: label. Or better yet, goto can
> be avoided.
> 
> Best regards,
> 								Pavel
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> index cef70f4b52ef..ba36bdd49d22 100644
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -1556,8 +1556,8 @@ static void __xen_evtchn_do_upcall(void)
>   	do {
>   		vcpu_info->evtchn_upcall_pending = 0;
>   
> -		if (__this_cpu_inc_return(xed_nesting_count) - 1)
> -			goto out;
> +		if (__this_cpu_inc_return(xed_nesting_count) != 1)
> +			break;
>   
>   		xen_evtchn_handle_events(cpu, &ctrl);
>   
> @@ -1568,8 +1568,6 @@ static void __xen_evtchn_do_upcall(void)
>   	} while (count != 1 || vcpu_info->evtchn_upcall_pending);
>   
>   	read_unlock(&evtchn_rwlock);
> -
> -out:
>   	/*
>   	 * Increment irq_epoch only now to defer EOIs only for
>   	 * xen_irq_lateeoi() invocations occurring from inside the loop
> 
> 

