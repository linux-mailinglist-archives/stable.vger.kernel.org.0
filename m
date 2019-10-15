Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F53DD7219
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 11:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfJOJWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 05:22:20 -0400
Received: from foss.arm.com ([217.140.110.172]:33332 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfJOJWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 05:22:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A33928;
        Tue, 15 Oct 2019 02:22:19 -0700 (PDT)
Received: from [192.168.0.9] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B04AB3F718;
        Tue, 15 Oct 2019 02:22:17 -0700 (PDT)
Subject: Re: [PATCH] sched/topology: Disable sched_asym_cpucapacity on domain
 destruction
To:     Valentin Schneider <valentin.schneider@arm.com>,
        Quentin Perret <qperret@google.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
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
From:   Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <c5fec41b-87f1-be4e-475f-69c7394f5467@arm.com>
Date:   Tue, 15 Oct 2019 11:22:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2b058430-1951-3d58-ebf4-8195a28ff233@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/10/2019 18:03, Valentin Schneider wrote:
> On 14/10/2019 14:52, Quentin Perret wrote:
>> Right, but that's not possible by definition -- static keys aren't
>> variables. The static keys for asym CPUs and for EAS are just to
>> optimize the case when they're disabled, but when they _are_ enabled,
>> you have no choice but do another per-rd check.
>>
> 
> Bleh, right, realized my nonsense after sending the email.
> 
>> And to clarify what I tried to say before, it might be possible to
>> 'count' the number of RDs that have SD_ASYM_CPUCAPACITY set using
>> static_branch_inc()/dec(), like we do for the SMT static key. I remember
>> trying to do something like that for EAS, but that was easier said than
>> done ... :)
>>
> 
> Gotcha, the reason I didn't go with this is that I wanted to maintain
> the relationship between the key and the flag (you either have both or none).
> It feels icky to have the key set and to have a NULL sd_asym_cpucapacity
> pointer.
> 
> An alternative might be to have a separate counter for asymmetric rd's,
> always disable the key on domain destruction and use that counter to figure
> out if we need to restore it. If we don't care about having a NULL SD
> pointer while the key is set, we could use the included counter as you're
> suggesting.

I still don't understand the benefit of the counter approach here.
sched_smt_present counts the number of cores with SMT. So in case you
have 2 SMT cores with 2 HW threads and you CPU hp out one CPU, you still
have sched_smt_present, although 1 CPU doesn't have a SMT thread sibling
anymore.

Valentin's patch makes sure that sched_asym_cpucapacity is correctly set
when the sd hierarchy is rebuild due to CPU hp. Including the unlikely
scenario that an asymmetric CPU capacity system (based on DT's
capacity-dmips-mhz values) turns normal SMT because of the max frequency
values of the CPUs involved.

Systems with a mix of asymmetric and symmetric CPU capacity rd's have to
live with the fact that wake_cap and misfit handling is enabled for
them. This should be the case already today.

There should be no SD_ASYM_CPUCAPACITY flag on the sd's of the CPUs of
the symmetric CPU capacity rd's. I.e. update_top_cache_domain() should
set sd_asym_cpucapacity=NULL for those CPUs.

So as a rule we could say even if a static key enables a code path, a
derefenced sd still has to be checked against NULL.
