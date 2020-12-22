Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7FF2E0D35
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 17:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgLVQUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 11:20:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:53139 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbgLVQUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 11:20:40 -0500
IronPort-SDR: wJ3qN26PD/dNR4HkCZVWga8B/kNYAl/K99WjNWd5MyjxrDrtkilx/yEKvdVHy9ph/Mq7VZ/yu0
 wWpX5p4cYBgw==
X-IronPort-AV: E=McAfee;i="6000,8403,9842"; a="162944845"
X-IronPort-AV: E=Sophos;i="5.78,439,1599548400"; 
   d="scan'208";a="162944845"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 08:19:58 -0800
IronPort-SDR: 12rptsdCJSkXnNELEo6p7KKDIZMPPCuDrn4JQ5o5p0l7PODcnORGkAM8Vx9HwFeJbacaokFhYf
 curmvMTQegVg==
X-IronPort-AV: E=Sophos;i="5.78,439,1599548400"; 
   d="scan'208";a="344269264"
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.132.204]) ([10.249.132.204])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2020 08:19:53 -0800
Subject: Re: [PATCH 0/4] sched/idle: Fix missing need_resched() checks after
 rcu_idle_enter()
To:     Frederic Weisbecker <frederic@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linux PM <linux-pm@vger.kernel.org>
References: <20201222013712.15056-1-frederic@kernel.org>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <4de33f1a-890b-4d29-20e8-a1163b9c1bf7@intel.com>
Date:   Tue, 22 Dec 2020 17:19:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201222013712.15056-1-frederic@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/22/2020 2:37 AM, Frederic Weisbecker wrote:
> With Paul, we've been thinking that the idle loop wasn't twisted enough
> yet to deserve 2020.
>
> rcutorture, after some recent parameter changes, has been complaining
> about a hung task.
>
> It appears that rcu_idle_enter() may wake up a NOCB kthread but this
> happens after the last generic need_resched() check. Some cpuidle drivers
> fix it by chance but many others don't.
>
> Here is a proposed bunch of fixes. I will need to also fix the
> rcu_user_enter() case, likely using irq_work, since nohz_full requires
> irq work to support self IPI.
>
> Also more generally, this raise the question of local task wake_up()
> under disabled interrupts. When a wake up occurs in a preempt disabled
> section, it gets handled by the outer preempt_enable() call. There is no
> similar mechanism when a wake up occurs with interrupts disabled. I guess
> it is assumed to be handled, at worst, in the next tick. But a local irq
> work would provide instant preemption once IRQs are re-enabled. Of course
> this would only make sense in CONFIG_PREEMPTION, and when the tick is
> disabled...
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	sched/idle
>
> HEAD: f2fa6e4a070c1535b9edc9ee097167fd2b15d235
>
> Thanks,
> 	Frederic
> ---
>
> Frederic Weisbecker (4):
>        sched/idle: Fix missing need_resched() check after rcu_idle_enter()
>        cpuidle: Fix missing need_resched() check after rcu_idle_enter()
>        ARM: imx6q: Fix missing need_resched() check after rcu_idle_enter()
>        ACPI: processor: Fix missing need_resched() check after rcu_idle_enter()
>
>
>   arch/arm/mach-imx/cpuidle-imx6q.c |  7 ++++++-
>   drivers/acpi/processor_idle.c     | 10 ++++++++--
>   drivers/cpuidle/cpuidle.c         | 33 +++++++++++++++++++++++++--------
>   kernel/sched/idle.c               | 18 ++++++++++++------
>   4 files changed, 51 insertions(+), 17 deletions(-)

Please feel free to add

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

to all patches in the series.

Thanks!


