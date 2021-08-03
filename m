Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C9A3DEA78
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 12:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbhHCKIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 06:08:48 -0400
Received: from foss.arm.com ([217.140.110.172]:46402 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235066AbhHCKIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 06:08:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 276111515;
        Tue,  3 Aug 2021 03:08:37 -0700 (PDT)
Received: from [10.57.9.94] (unknown [10.57.9.94])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51AC03F40C;
        Tue,  3 Aug 2021 03:08:32 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] PM: EM: Increase energy calculation precision
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc:     peterz@infradead.org, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org, Chris.Redpath@arm.com,
        morten.rasmussen@arm.com, qperret@google.com,
        linux-pm@vger.kernel.org, stable@vger.kernel.org,
        rjw@rjwysocki.net, viresh.kumar@linaro.org, mingo@redhat.com,
        juri.lelli@redhat.com, rostedt@goodmis.org, segall@google.com,
        mgorman@suse.de, bristot@redhat.com, CCj.Yeh@mediatek.com
References: <20210720094153.31097-1-lukasz.luba@arm.com>
 <20210720094153.31097-2-lukasz.luba@arm.com>
 <3a98d39b-d607-03d2-819b-5150f6755c96@arm.com>
 <461df215-8f78-2f29-aaba-636aebb21337@arm.com>
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <82d9d384-80e0-f5ec-cb09-6804a713a690@arm.com>
Date:   Tue, 3 Aug 2021 11:08:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <461df215-8f78-2f29-aaba-636aebb21337@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/3/21 10:44 AM, Dietmar Eggemann wrote:
> On 02/08/2021 08:21, Lukasz Luba wrote:
>> Hi Peter, Vincent,
>>
>> Gentle ping.
>>
>>
>> On 7/20/21 10:41 AM, Lukasz Luba wrote:
> 
> [...]
> 
>>> There are corner cases when the EAS energy calculation for two
>>> Performance
>>> Domains (PDs) return the same value. The EAS compares these values to
>>> choose smaller one. It might happen that this values are equal due to
>>> rounding error. In such scenario, we need better resolution, e.g. 1000
>>> times better. To provide this possibility increase the resolution in the
>>> em_perf_state::cost for 64-bit architectures. The costs for increasing
>>> resolution in 32-bit architectures are pretty high (64-bit division) and
>>> the returns do not justify the increased costs.
> 
> s/The costs ... increased costs./The cost of increasing resolution on
> 32-bit is pretty high (64-bit division) and is not justified since there
> are no new 32bit big.LITTLE EAS systems expected which would benefit
> from this higher resolution./ ?

Sounds better indeed.

> 
>>> This patch allows to avoid the rounding to milli-Watt errors, which might
>>> occur in EAS energy estimation for each Performance Domains (PD). The
> 
> s/Performance Domains (PD)/PD.

OK

> 
> [...]
> 
>>> Scenario:
>>> Low utilized system e.g. ~200 sum_util for PD0 and ~220 for PD1. There
>>> are quite a few small tasks ~10-15 util. These tasks would suffer for
>>> the rounding error. Such system utilization has been seen while playing
>>> some simple games. In such condition our partner reported 5..10mA less
>>> battery drain.
> 
> Hard to digest: Maybe s/Such system ... battery drain./These utilization
> values are typical when running games on Android. One of our partners
> has reported 5..10mA less battery drain when running with increased
> resolution./ ?

Sounds good.

> 
>>>
>>> Some details:
>>> We have two Perf Domains (PDs): PD0 (big) and PD1 (little)
> 
> s/Perf Domains (PDs)/PDs

OK

> 
> [...]
> 
>>> 2. Difference in the the last find_energy_efficient_cpu(): margin filter.
> 
> s/in the the last find_energy_efficient_cpu(): margin filter/in the 6%
> energy margin filter at the end of find_energy_efficient_cpu()/ ?

OK

[snip]

> 
> Otherwise, LGTM.
> 
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>

Thank you Dietmar for the review. I'm going to send the v3.

> 
> This is now an EM only patch (Task scheduler (i.e. CFS/EAS) is only
> effected via compute_energy() -> em_cpu_energy().
> 

True it's EM only now, so I will ask Rafael to pick it.
