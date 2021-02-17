Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7BE31D78F
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 11:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhBQKaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 05:30:06 -0500
Received: from foss.arm.com ([217.140.110.172]:55582 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhBQKaE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Feb 2021 05:30:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 282A51042;
        Wed, 17 Feb 2021 02:29:18 -0800 (PST)
Received: from [10.57.61.90] (unknown [10.57.61.90])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D0B73F73B;
        Wed, 17 Feb 2021 02:29:15 -0800 (PST)
Subject: Re: [PATCH] thermal: cpufreq_cooling: freq_qos_update_request()
 returns < 0 on error
To:     Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amitk@kernel.org>
Cc:     Amit Daniel Kachhap <amit.kachhap@gmail.com>,
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
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <91749e19-9091-1292-b8aa-c923efa8021d@arm.com>
Date:   Wed, 17 Feb 2021 10:29:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b2b7e84944937390256669df5a48ce5abba0c1ef.1613540713.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Viresh,

On 2/17/21 5:48 AM, Viresh Kumar wrote:
> freq_qos_update_request() returns 1 if the effective constraint value
> has changed, 0 if the effective constraint value has not changed, or a
> negative error code on failures.
> 
> The frequency constraints for CPUs can be set by different parts of the
> kernel. If the maximum frequency constraint set by other parts of the
> kernel are set at a lower value than the one corresponding to cooling
> state 0, then we will never be able to cool down the system as
> freq_qos_update_request() will keep on returning 0 and we will skip
> updating cpufreq_state and thermal pressure.

To be precised, thermal pressure signal is not so important in this
mechanism and the 'cpufreq_state' has changed recently:

236761f19a4f373354  thermal/drivers/cpufreq_cooling: Update 
cpufreq_state only if state has changed

> 
> Fix that by doing the updates even in the case where
> freq_qos_update_request() returns 0, as we have effectively set the
> constraint to a new value even if the consolidated value of the
> actual constraint is unchanged because of external factors.
> 
> Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
> Reported-by: Thara Gopinath <thara.gopinath@linaro.org>
> Fixes: f12e4f66ab6a ("thermal/cpu-cooling: Update thermal pressure in case of a maximum frequency capping")

I'm not sure if that f12e4f is the root cause.

> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Guys,
> 
> This needs to go in 5.12-rc.
> 
> Thara, please give this a try and give your tested-by :).
> 
>   drivers/thermal/cpufreq_cooling.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)


Anyway, the fix LGTM. I will have to make sure that I'm CC'ed for these
topic, so I can have a look (I missed somehow 236761f19)

Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>

Regards,
Lukasz
