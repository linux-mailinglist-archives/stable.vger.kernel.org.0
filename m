Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDB831D7AD
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 11:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhBQKqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 05:46:48 -0500
Received: from foss.arm.com ([217.140.110.172]:55806 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhBQKqo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 05:46:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 50CF31042;
        Wed, 17 Feb 2021 02:45:58 -0800 (PST)
Received: from [10.57.61.90] (unknown [10.57.61.90])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96EDF3F73B;
        Wed, 17 Feb 2021 02:45:55 -0800 (PST)
Subject: Re: [PATCH] thermal: cpufreq_cooling: freq_qos_update_request()
 returns < 0 on error
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     Amit Kucheria <amitk@kernel.org>,
        Amit Daniel Kachhap <amit.kachhap@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Javi Merino <javi.merino@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "v5 . 7+" <stable@vger.kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <b2b7e84944937390256669df5a48ce5abba0c1ef.1613540713.git.viresh.kumar@linaro.org>
 <91749e19-9091-1292-b8aa-c923efa8021d@arm.com>
 <20210217103911.n34zzjttyso7dlco@vireshk-i7>
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <0b276055-e93a-3e08-5eee-662008d8db6c@arm.com>
Date:   Wed, 17 Feb 2021 10:45:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20210217103911.n34zzjttyso7dlco@vireshk-i7>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/17/21 10:39 AM, Viresh Kumar wrote:
> On 17-02-21, 10:29, Lukasz Luba wrote:
>> On 2/17/21 5:48 AM, Viresh Kumar wrote:
>>> freq_qos_update_request() returns 1 if the effective constraint value
>>> has changed, 0 if the effective constraint value has not changed, or a
>>> negative error code on failures.
>>>
>>> The frequency constraints for CPUs can be set by different parts of the
>>> kernel. If the maximum frequency constraint set by other parts of the
>>> kernel are set at a lower value than the one corresponding to cooling
>>> state 0, then we will never be able to cool down the system as
>>> freq_qos_update_request() will keep on returning 0 and we will skip
>>> updating cpufreq_state and thermal pressure.
>>
>> To be precised, thermal pressure signal is not so important in this
>> mechanism and the 'cpufreq_state' has changed recently:
> 
> Right, I wasn't concerned only about no thermal cooling, but both
> thermal cooling and pressure.
> 
>> 236761f19a4f373354  thermal/drivers/cpufreq_cooling: Update cpufreq_state
>> only if state has changed
> 
> This moved the assignment to a more logical place for me, i.e. not to
> do that on errors, just that the block in which it landed may not get
> called at all :(
> 
>>> Fix that by doing the updates even in the case where
>>> freq_qos_update_request() returns 0, as we have effectively set the
>>> constraint to a new value even if the consolidated value of the
>>> actual constraint is unchanged because of external factors.
>>>
>>> Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
>>> Reported-by: Thara Gopinath <thara.gopinath@linaro.org>
>>> Fixes: f12e4f66ab6a ("thermal/cpu-cooling: Update thermal pressure in case of a maximum frequency capping")
>>
>> I'm not sure if that f12e4f is the root cause.
> 
> Hmm, depends on how we define the problem :)
> 
> If this was just about thermal-cooling not happening, then may be yes,
> but to me it is rather about mishandled return value of
> freq_qos_update_request() which has more than one side effects and so
> I went for the main commit.
> 
> This is also important as f12e4f66ab6a got merged in 5.7 and 236761f19
> merged in 5.11 and this patch needs to get applied in stable kernels
> since 5.7 to fix it all.
> 

'to fix it all' - I agree
