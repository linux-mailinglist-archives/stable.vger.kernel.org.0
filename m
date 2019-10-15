Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCF4D76E9
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 14:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfJOM45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 08:56:57 -0400
Received: from foss.arm.com ([217.140.110.172]:38268 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfJOM45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 08:56:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43406337;
        Tue, 15 Oct 2019 05:56:56 -0700 (PDT)
Received: from [192.168.0.9] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB1B43F718;
        Tue, 15 Oct 2019 05:56:54 -0700 (PDT)
Subject: Re: [PATCH] sched/topology: Disable sched_asym_cpucapacity on domain
 destruction
To:     Quentin Perret <qperret@google.com>
Cc:     Valentin Schneider <valentin.schneider@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Quentin Perret <qperret@qperret.net>,
        "# v4 . 16+" <stable@vger.kernel.org>
References: <20191014114710.22142-1-valentin.schneider@arm.com>
 <20191014121648.GA53234@google.com>
 <CAKfTPtDoBrE=npY_Ay1pucdXsW1yQr1UiaCGq1DXKa2VmNqcUg@mail.gmail.com>
 <fe5977ab-0a70-e705-fcca-246c7dc3d23f@arm.com>
 <20191014135256.GA85340@google.com>
 <2b058430-1951-3d58-ebf4-8195a28ff233@arm.com>
 <c5fec41b-87f1-be4e-475f-69c7394f5467@arm.com>
 <20191015110704.GB242992@google.com>
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <6d16200d-f9ee-6209-d528-c4c7cfd7fb5a@arm.com>
Date:   Tue, 15 Oct 2019 14:56:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191015110704.GB242992@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/10/2019 13:07, Quentin Perret wrote:
> On Tuesday 15 Oct 2019 at 11:22:12 (+0200), Dietmar Eggemann wrote:
>> I still don't understand the benefit of the counter approach here.
>> sched_smt_present counts the number of cores with SMT. So in case you
>> have 2 SMT cores with 2 HW threads and you CPU hp out one CPU, you still
>> have sched_smt_present, although 1 CPU doesn't have a SMT thread sibling
>> anymore.
> 
> Right, and we want something similar for the asym static key I think.
> That is, it should be enabled if _at least one_ RD is asymmetric.
> 
>> Valentin's patch makes sure that sched_asym_cpucapacity is correctly set
>> when the sd hierarchy is rebuild due to CPU hp.
> 
> As mentioned in a previous email, I think this patch is broken in case
> you have multiple asymmetric RDs, but counting should fix it, though it
> might not be that easy to implement.

Correct, now I see your point! Can be easily recreated on JUNO setting
up two exclusive cpusets, each with one big CPU and then hp'ing one of them.

And partition_sched_domains_locked()/build_perf_domains() handles this
by distinguishing existing vs. new PDs and or'ing has_eas.

>> Including the unlikely
>> scenario that an asymmetric CPU capacity system (based on DT's
>> capacity-dmips-mhz values) turns normal SMT because of the max frequency
>> values of the CPUs involved.
> 
> I'm not sure what you meant here ?

The rebuild of the sd hierarchy after we know the max frequency values
of the CPUs from CpuFreq (2. SD hierarchy build on asym CPU capacity
systems with CPUfreq).

E.g on Juno when you set capacity-dmips-mhz_{big;little}=791;1024 with
max_CPU_freq_{big;little}=1,100,000;850,000.

It's a theoretical case and might not even work due to rounding errors.

>> Systems with a mix of asymmetric and symmetric CPU capacity rd's have to
>> live with the fact that wake_cap and misfit handling is enabled for
>> them. This should be the case already today.
>>
>> There should be no SD_ASYM_CPUCAPACITY flag on the sd's of the CPUs of
>> the symmetric CPU capacity rd's. I.e. update_top_cache_domain() should
>> set sd_asym_cpucapacity=NULL for those CPUs.
>>
>> So as a rule we could say even if a static key enables a code path, a
>> derefenced sd still has to be checked against NULL.
> 
> Right, that's already true today, and I don't see a possible alternative
> to that. Same thing for the EAS static key and the pd list btw.

Agreed.
