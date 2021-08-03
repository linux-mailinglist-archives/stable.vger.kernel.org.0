Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B20A3DE9E4
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 11:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235141AbhHCJoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 05:44:54 -0400
Received: from foss.arm.com ([217.140.110.172]:45558 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235139AbhHCJoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 05:44:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0D9E11D4;
        Tue,  3 Aug 2021 02:44:42 -0700 (PDT)
Received: from [192.168.1.13] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B563B3F40C;
        Tue,  3 Aug 2021 02:44:39 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] PM: EM: Increase energy calculation precision
To:     Lukasz Luba <lukasz.luba@arm.com>, peterz@infradead.org,
        vincent.guittot@linaro.org
Cc:     linux-kernel@vger.kernel.org, Chris.Redpath@arm.com,
        morten.rasmussen@arm.com, qperret@google.com,
        linux-pm@vger.kernel.org, stable@vger.kernel.org,
        rjw@rjwysocki.net, viresh.kumar@linaro.org, mingo@redhat.com,
        juri.lelli@redhat.com, rostedt@goodmis.org, segall@google.com,
        mgorman@suse.de, bristot@redhat.com, CCj.Yeh@mediatek.com
References: <20210720094153.31097-1-lukasz.luba@arm.com>
 <20210720094153.31097-2-lukasz.luba@arm.com>
 <3a98d39b-d607-03d2-819b-5150f6755c96@arm.com>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <461df215-8f78-2f29-aaba-636aebb21337@arm.com>
Date:   Tue, 3 Aug 2021 11:44:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <3a98d39b-d607-03d2-819b-5150f6755c96@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/08/2021 08:21, Lukasz Luba wrote:
> Hi Peter, Vincent,
> 
> Gentle ping.
> 
> 
> On 7/20/21 10:41 AM, Lukasz Luba wrote:

[...]

>> There are corner cases when the EAS energy calculation for two
>> Performance
>> Domains (PDs) return the same value. The EAS compares these values to
>> choose smaller one. It might happen that this values are equal due to
>> rounding error. In such scenario, we need better resolution, e.g. 1000
>> times better. To provide this possibility increase the resolution in the
>> em_perf_state::cost for 64-bit architectures. The costs for increasing
>> resolution in 32-bit architectures are pretty high (64-bit division) and
>> the returns do not justify the increased costs.

s/The costs ... increased costs./The cost of increasing resolution on
32-bit is pretty high (64-bit division) and is not justified since there
are no new 32bit big.LITTLE EAS systems expected which would benefit
from this higher resolution./ ?

>> This patch allows to avoid the rounding to milli-Watt errors, which might
>> occur in EAS energy estimation for each Performance Domains (PD). The

s/Performance Domains (PD)/PD.

[...]

>> Scenario:
>> Low utilized system e.g. ~200 sum_util for PD0 and ~220 for PD1. There
>> are quite a few small tasks ~10-15 util. These tasks would suffer for
>> the rounding error. Such system utilization has been seen while playing
>> some simple games. In such condition our partner reported 5..10mA less
>> battery drain.

Hard to digest: Maybe s/Such system ... battery drain./These utilization
values are typical when running games on Android. One of our partners
has reported 5..10mA less battery drain when running with increased
resolution./ ?

>>
>> Some details:
>> We have two Perf Domains (PDs): PD0 (big) and PD1 (little)

s/Perf Domains (PDs)/PDs

[...]

>> 2. Difference in the the last find_energy_efficient_cpu(): margin filter.

s/in the the last find_energy_efficient_cpu(): margin filter/in the 6%
energy margin filter at the end of find_energy_efficient_cpu()/ ?

>> With this patch the margin comparison also has better resolution,
>> so it's possible to have better task placement thanks to that.
>>
>> Fixes: 27871f7a8a341ef ("PM: Introduce an Energy Model management
>> framework")
>> Reported-by: CCJ Yeh <CCj.Yeh@mediatek.com>
>> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
>> ---
>>   include/linux/energy_model.h | 16 ++++++++++++++++
>>   kernel/power/energy_model.c  |  3 ++-
>>   2 files changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/energy_model.h b/include/linux/energy_model.h
>> index 3f221dbf5f95..1834752c5617 100644
>> --- a/include/linux/energy_model.h
>> +++ b/include/linux/energy_model.h
>> @@ -53,6 +53,22 @@ struct em_perf_domain {
>>   #ifdef CONFIG_ENERGY_MODEL
>>   #define EM_MAX_POWER 0xFFFF
>>   +/*
>> + * Increase resolution of energy estimation calculations for 64-bit
>> + * architectures. The extra resolution improves decision made by EAS
>> for the
>> + * task placement when two Performance Domains might provide similar
>> energy
>> + * estimation values (w/o better resolution the values could be equal).
>> + *
>> + * We increase resolution only if we have enough bits to allow this
>> increased
>> + * resolution (i.e. 64-bit). The costs for increasing resolution when
>> 32-bit
>> + * are pretty high and the returns do not justify the increased costs.
>> + */
>> +#ifdef CONFIG_64BIT
>> +#define em_scale_power(p) ((p) * 1000)
>> +#else
>> +#define em_scale_power(p) (p)
>> +#endif
>> +
>>   struct em_data_callback {
>>       /**
>>        * active_power() - Provide power at the next performance state of
>> diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
>> index 0f4530b3a8cd..bf312c04c514 100644
>> --- a/kernel/power/energy_model.c
>> +++ b/kernel/power/energy_model.c
>> @@ -170,7 +170,8 @@ static int em_create_perf_table(struct device
>> *dev, struct em_perf_domain *pd,
>>       /* Compute the cost of each performance state. */
>>       fmax = (u64) table[nr_states - 1].frequency;
>>       for (i = 0; i < nr_states; i++) {
>> -        table[i].cost = div64_u64(fmax * table[i].power,
>> +        unsigned long power_res = em_scale_power(table[i].power);
>> +        table[i].cost = div64_u64(fmax * power_res,
>>                         table[i].frequency);
>>       }

Otherwise, LGTM.

Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>

This is now an EM only patch (Task scheduler (i.e. CFS/EAS) is only
effected via compute_energy() -> em_cpu_energy().
