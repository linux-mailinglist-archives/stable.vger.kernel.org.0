Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD243BB8A6
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 10:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhGEIQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 04:16:40 -0400
Received: from foss.arm.com ([217.140.110.172]:40288 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGEIQk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 04:16:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B0FADD6E;
        Mon,  5 Jul 2021 01:14:03 -0700 (PDT)
Received: from [10.57.13.252] (unknown [10.57.13.252])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 702F53F694;
        Mon,  5 Jul 2021 01:14:02 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.12 62/80] sched/fair: Take thermal pressure into
 account while estimating energy
To:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg KH <greg@kroah.com>
References: <20210704230616.1489200-1-sashal@kernel.org>
 <20210704230616.1489200-62-sashal@kernel.org>
From:   Lukasz Luba <lukasz.luba@arm.com>
Message-ID: <54648043-4944-08f9-8ce8-8413d8037450@arm.com>
Date:   Mon, 5 Jul 2021 09:13:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20210704230616.1489200-62-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

+CC Greg

On 7/5/21 12:05 AM, Sasha Levin wrote:
> From: Lukasz Luba <lukasz.luba@arm.com>
> 
> [ Upstream commit 489f16459e0008c7a5c4c5af34bd80898aa82c2d ]
> 
> Energy Aware Scheduling (EAS) needs to be able to predict the frequency
> requests made by the SchedUtil governor to properly estimate energy used
> in the future. It has to take into account CPUs utilization and forecast
> Performance Domain (PD) frequency. There is a corner case when the max
> allowed frequency might be reduced due to thermal. SchedUtil is aware of
> that reduced frequency, so it should be taken into account also in EAS
> estimations.
> 
> SchedUtil, as a CPUFreq governor, knows the maximum allowed frequency of
> a CPU, thanks to cpufreq_driver_resolve_freq() and internal clamping
> to 'policy::max'. SchedUtil is responsible to respect that upper limit
> while setting the frequency through CPUFreq drivers. This effective
> frequency is stored internally in 'sugov_policy::next_freq' and EAS has
> to predict that value.
> 
> In the existing code the raw value of arch_scale_cpu_capacity() is used
> for clamping the returned CPU utilization from effective_cpu_util().
> This patch fixes issue with too big single CPU utilization, by introducing
> clamping to the allowed CPU capacity. The allowed CPU capacity is a CPU
> capacity reduced by thermal pressure raw value.
> 
> Thanks to knowledge about allowed CPU capacity, we don't get too big value
> for a single CPU utilization, which is then added to the util sum. The
> util sum is used as a source of information for estimating whole PD energy.
> To avoid wrong energy estimation in EAS (due to capped frequency), make
> sure that the calculation of util sum is aware of allowed CPU capacity.
> 
> This thermal pressure might be visible in scenarios where the CPUs are not
> heavily loaded, but some other component (like GPU) drastically reduced
> available power budget and increased the SoC temperature. Thus, we still
> use EAS for task placement and CPUs are not over-utilized.
> 
> Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Link: https://lore.kernel.org/r/20210614191128.22735-1-lukasz.luba@arm.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   kernel/sched/fair.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)

It has been picked up automatically right?
To make it fully working you need also this patch:
https://lore.kernel.org/linux-pm/20210614191030.22241-1-lukasz.luba@arm.com/

It makes sure that the thermal pressure signal gets proper
information also for CPUs which were offline and then wake-up.
It has a proper fix tagging with commit hash id.
That patch can be ported to stable: v5.6+
I can send it to stable list. Please let me know if you need
any help.

The same applies to patch which I found for v5.13-stable:
[PATCH AUTOSEL 5.13 65/85] sched/fair: Take thermal pressure into 
account while estimating energy
https://lore.kernel.org/stable/20210704230420.1488358-65-sashal@kernel.org/T/#u

Regards,
Lukasz
