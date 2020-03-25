Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB5192A91
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 14:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgCYN57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 09:57:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35981 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgCYN56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 09:57:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id j29so1186882pgl.3;
        Wed, 25 Mar 2020 06:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UK1bTCjwWjERwUjBRJwj5mEVh+i6Cx+AtXtd2ZWguHU=;
        b=Q/dc46LQGtihMg+xa069FnlVeBFJlEXwOOxRsN753Z76Ne+z3LYxYWJo+L2lbE4Fad
         V8XGq5vBzJ3l731HxKxH7DycOAPc4jt4XvcddsqYX54/QkwEhfDo5D2mioTZne9cmn0t
         IrJCKQtpaMzg2S4OffZC3m45QnCt84BLX/RcKdP2iCejB8B4zsH8cBAiAxe0j4P0sK3w
         hayhiQFYu446lMreJKPDtWo3aMGr2eReEg2XvLIkS1uVUjuAoegZxwVZgx+0YbgywaVp
         i5Ag/5207lNwTiQRmfIblk4IbgfhPbVU9J/ukNCUnj8wlxigklgS3N3iL9Lf5kvx0hm+
         mCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UK1bTCjwWjERwUjBRJwj5mEVh+i6Cx+AtXtd2ZWguHU=;
        b=T2yhMQLKRLybwRvNEIcuD8RGNm1t+knSuIIl01ybfTnxIgBUtnSmZHu4O+nboYv3w4
         C95IPS9xjPvIxpOdjTfIJH8o1zYBzv7D8/V2FVBt+miDPCQBQa00chG8Po4Hnupy8J2d
         KhPcvfWh3Ihfl5pDz14/sv368q4vBGSPUBxcW+NV9b7mTfLELQWiaVYD3lKoRPBLu3R2
         OllnN8h+1Cge/jKyCEfSJSZSPA4i0espkKL+Pttxony55dAVjF72mjAeVWSlZYraV96k
         FVDIqeFg7WReWh/uFmDm/+dHrKqWN1OuZV72WGCXbrTP+I/yE4kZnxdIz9BjC1U9HOEd
         PT/Q==
X-Gm-Message-State: ANhLgQ3bp2gQ4LZcmYK+EOHr2dh+0gzSLCUBpXaqNbj2O9w5nuPRc6X9
        QLUMHUXX18S9Ar0F4Q9TGcA=
X-Google-Smtp-Source: ADFU+vslu82Vg7HGoUVYAIPV1Q8ize5C9abSZMr6O3jjfgTuW8qGRtcVRrvTGKOjfabRs/GBBMWYtw==
X-Received: by 2002:a65:5b49:: with SMTP id y9mr3204412pgr.153.1585144677478;
        Wed, 25 Mar 2020 06:57:57 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:1a:efeb::a31c])
        by smtp.gmail.com with ESMTPSA id a19sm18841126pfk.110.2020.03.25.06.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 06:57:57 -0700 (PDT)
Subject: Re: [PATCH] x86/Hyper-V: Fix hv sched clock function return wrong
 time unit
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Yubo Xie <yuboxie@microsoft.com>, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tianyu Lan <Tianyu.Lan@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        liuwe@microsoft.com, daniel.lezcano@linaro.org, tglx@linutronix.de,
        michael.h.kelley@microsoft.com
References: <20200324151935.15814-1-yuboxie@microsoft.com>
 <87ftdx7nxv.fsf@vitty.brq.redhat.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <039e126f-f00d-d7e1-aa92-c049c9e3333b@gmail.com>
Date:   Wed, 25 Mar 2020 21:57:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87ftdx7nxv.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vitaly:
     Thanks for your review.

On 3/24/2020 11:49 PM, Vitaly Kuznetsov wrote:
> Yubo Xie <ltykernel@gmail.com> writes:
> 
>> sched clock callback should return time with nano second as unit
>> but current hv callback returns time with 100ns. Fix it.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Yubo Xie <yuboxie@microsoft.com>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> Fixes: adb87ff4f96c ("clocksource/drivers/hyperv: Allocate Hyper-V TSC page statically")
> 
> I don't think this is the right commit to reference,
> 
> commit bd00cd52d5be655a2f217e2ed74b91a71cb2b14f
> Author: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Date:   Wed Aug 14 20:32:16 2019 +0800
> 
>      clocksource/drivers/hyperv: Add Hyper-V specific sched clock function
> 
> looks like the one.

Sorry. You are right. Will update in the next version.

> 
>> ---
>>   drivers/clocksource/hyperv_timer.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
>> index 9d808d595ca8..662ed978fa24 100644
>> --- a/drivers/clocksource/hyperv_timer.c
>> +++ b/drivers/clocksource/hyperv_timer.c
>> @@ -343,7 +343,8 @@ static u64 notrace read_hv_clock_tsc_cs(struct clocksource *arg)
>>   
>>   static u64 read_hv_sched_clock_tsc(void)
>>   {
>> -	return read_hv_clock_tsc() - hv_sched_clock_offset;
>> +	return (read_hv_clock_tsc() - hv_sched_clock_offset)
>> +		* (NSEC_PER_SEC / HV_CLOCK_HZ);
>>   }
>>   
>>   static void suspend_hv_clock_tsc(struct clocksource *arg)
>> @@ -398,7 +399,8 @@ static u64 notrace read_hv_clock_msr_cs(struct clocksource *arg)
>>   
>>   static u64 read_hv_sched_clock_msr(void)
>>   {
>> -	return read_hv_clock_msr() - hv_sched_clock_offset;
>> +	return (read_hv_clock_msr() - hv_sched_clock_offset)
>> +		* (NSEC_PER_SEC / HV_CLOCK_HZ);
>>   }
> 
> kvmclock seems to have the same (pre-patch) code ...


kvm sched clock gets time from pvclock_clocksource_read() and
the time unit is nanosecond. So there is such issue in KVM code.

> 
>>   
>>   static struct clocksource hyperv_cs_msr = {
> 
