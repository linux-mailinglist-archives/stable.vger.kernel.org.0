Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2994A2D472C
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 17:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731241AbgLIQwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 11:52:10 -0500
Received: from foss.arm.com ([217.140.110.172]:37546 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729345AbgLIQwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 11:52:05 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 538871FB;
        Wed,  9 Dec 2020 08:51:19 -0800 (PST)
Received: from [192.168.2.21] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F70D3F68F;
        Wed,  9 Dec 2020 08:51:17 -0800 (PST)
Subject: Re: [PATCH 2/3] x86/resctrl: Update PQR_ASSOC MSR synchronously when
 moving task to resource group
To:     Reinette Chatre <reinette.chatre@intel.com>, fenghua.yu@intel.com
Cc:     tglx@linutronix.de, bp@alien8.de, tony.luck@intel.com,
        kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1607036601.git.reinette.chatre@intel.com>
 <c8eebc438e057e4bc2ce00256664b7bb0561b323.1607036601.git.reinette.chatre@intel.com>
From:   James Morse <james.morse@arm.com>
Message-ID: <97610014-12a8-c389-e7e6-f655caf61d0d@arm.com>
Date:   Wed, 9 Dec 2020 16:51:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <c8eebc438e057e4bc2ce00256664b7bb0561b323.1607036601.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Reinette, Fenghua,

Subject nit: I think 'use IPI instead of task_work() to update PQR_ASSOC_MSR' conveys the
guts of this change more quickly!

On 03/12/2020 23:25, Reinette Chatre wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Currently when moving a task to a resource group the PQR_ASSOC MSR
> is updated with the new closid and rmid in an added task callback.
> If the task is running the work is run as soon as possible. If the
> task is not running the work is executed later

> in the kernel exit path when the kernel returns to the task again.

kernel exit makes me thing of user-space... is it enough to just say:
"by __switch_to() when task is next run"?


> Updating the PQR_ASSOC MSR as soon as possible on the CPU a moved task
> is running is the right thing to do. Queueing work for a task that is
> not running is unnecessary (the PQR_ASSOC MSR is already updated when the
> task is scheduled in) and causing system resource waste with the way in
> which it is implemented: Work to update the PQR_ASSOC register is queued
> every time the user writes a task id to the "tasks" file, even if the task
> already belongs to the resource group. This could result in multiple pending
> work items associated with a single task even if they are all identical and
> even though only a single update with most recent values is needed.
> Specifically, even if a task is moved between different resource groups
> while it is sleeping then it is only the last move that is relevant but
> yet a work item is queued during each move.
> This unnecessary queueing of work items could result in significant system
> resource waste, especially on tasks sleeping for a long time. For example,
> as demonstrated by Shakeel Butt in [1] writing the same task id to the
> "tasks" file can quickly consume significant memory. The same problem
> (wasted system resources) occurs when moving a task between different
> resource groups.
> 
> As pointed out by Valentin Schneider in [2] there is an additional issue with
> the way in which the queueing of work is done in that the task_struct update
> is currently done after the work is queued, resulting in a race with the
> register update possibly done before the data needed by the update is available.
> 
> To solve these issues, the PQR_ASSOC MSR is updated in a synchronous way
> right after the new closid and rmid are ready during the task movement,
> only if the task is running. If a moved task is not running nothing is
> done since the PQR_ASSOC MSR will be updated next time the task is scheduled.
> This is the same way used to update the register when tasks are moved as
> part of resource group removal.

(as t->on_cpu is already used...)

Reviewed-by: James Morse <james.morse@arm.com>


> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 68db7d2dec8f..9d62f1fadcc3 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -525,6 +525,16 @@ static void rdtgroup_remove(struct rdtgroup *rdtgrp)


> +static void update_task_closid_rmid(struct task_struct *t)
>  {
> +	int cpu;
>  
> +	if (task_on_cpu(t, &cpu))
> +		smp_call_function_single(cpu, _update_task_closid_rmid, t, 1);


I think:
|	if (task_curr(t))
|		smp_call_function_single(task_cpu(t), _update_task_closid_rmid, t, 1);

here would make for an easier backport as it doesn't depend on the previous patch.


> +}

[...]

>  static int __rdtgroup_move_task(struct task_struct *tsk,
>  				struct rdtgroup *rdtgrp)
>  {

> +	if (rdtgrp->type == RDTCTRL_GROUP) {
> +		tsk->closid = rdtgrp->closid;
> +		tsk->rmid = rdtgrp->mon.rmid;
> +	} else if (rdtgrp->type == RDTMON_GROUP) {

[...]

> +	} else {

> +		rdt_last_cmd_puts("Invalid resource group type\n");
> +		return -EINVAL;

Wouldn't this be a kernel bug?
I'd have thought there would be a WARN_ON_ONCE() here to make it clear this isn't
user-space's fault!


>  	}
> -	return ret;
> +
> +	/*
> +	 * By now, the task's closid and rmid are set. If the task is current
> +	 * on a CPU, the PQR_ASSOC MSR needs to be updated to make the resource
> +	 * group go into effect. If the task is not current, the MSR will be
> +	 * updated when the task is scheduled in.
> +	 */
> +	update_task_closid_rmid(tsk);
> +
> +	return 0;
>  }


Thanks,

James
