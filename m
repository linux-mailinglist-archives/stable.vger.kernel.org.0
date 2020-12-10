Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4982D4F56
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 01:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgLJAX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 19:23:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:61808 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbgLJAX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 19:23:27 -0500
IronPort-SDR: jdcODoGk6OMLv+5qDpPBT03te4Uq62hHY2Kp8cj77rQ8dD9gWifbhkco9XtKWZy66verlE5WYE
 CK7AzNJ6Z7SQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="174289941"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="174289941"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 16:22:41 -0800
IronPort-SDR: /w738SZkgdSi771IstL0KiZ8zfnFp2c4e0jkaPoidamDh/jCErTVjDmAEsl62urQPd7QRtWpTg
 e7ADkT5P0SCg==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="438054773"
Received: from rchatre-mobl3.amr.corp.intel.com (HELO [10.209.138.37]) ([10.209.138.37])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 16:22:40 -0800
Subject: Re: [PATCH 2/3] x86/resctrl: Update PQR_ASSOC MSR synchronously when
 moving task to resource group
To:     James Morse <james.morse@arm.com>, fenghua.yu@intel.com
Cc:     tglx@linutronix.de, bp@alien8.de, tony.luck@intel.com,
        kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1607036601.git.reinette.chatre@intel.com>
 <c8eebc438e057e4bc2ce00256664b7bb0561b323.1607036601.git.reinette.chatre@intel.com>
 <97610014-12a8-c389-e7e6-f655caf61d0d@arm.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <d80e3d5d-1db2-0f47-dbf3-dfc607e1b451@intel.com>
Date:   Wed, 9 Dec 2020 16:22:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <97610014-12a8-c389-e7e6-f655caf61d0d@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi James,

On 12/9/2020 8:51 AM, James Morse wrote:
> Hi Reinette, Fenghua,
> 
> Subject nit: I think 'use IPI instead of task_work() to update PQR_ASSOC_MSR' conveys the
> guts of this change more quickly!

Sure. Thank you. A small change is that I plan to write "PQR_ASSOC MSR" 
instead to closer match the name.

> 
> On 03/12/2020 23:25, Reinette Chatre wrote:
>> From: Fenghua Yu <fenghua.yu@intel.com>
>>
>> Currently when moving a task to a resource group the PQR_ASSOC MSR
>> is updated with the new closid and rmid in an added task callback.
>> If the task is running the work is run as soon as possible. If the
>> task is not running the work is executed later
> 
>> in the kernel exit path when the kernel returns to the task again.
> 
> kernel exit makes me thing of user-space... is it enough to just say:
> "by __switch_to() when task is next run"?

I do not think that would be accurate. The paragraph to which you are 
proposing the change states the current context, before the fix, when 
task_work_add() is still used to update PQR_ASSOC. The "kernel exit" 
text you refer to is quite close to task_work_add()'s comments and 
indeed refers to the work that is run before returning to user space. If 
a function name would make things clearer perhaps adding 
exit_to_user_mode_loop() instead? Changing the text to __switch_to() 
does not reflect the context described here since __switch_to() is what 
is called when task is context switched back from where 
resctrl_sched_in() is called, not the queued work being described here.

>> Updating the PQR_ASSOC MSR as soon as possible on the CPU a moved task
>> is running is the right thing to do. Queueing work for a task that is
>> not running is unnecessary (the PQR_ASSOC MSR is already updated when the
>> task is scheduled in) and causing system resource waste with the way in
>> which it is implemented: Work to update the PQR_ASSOC register is queued
>> every time the user writes a task id to the "tasks" file, even if the task
>> already belongs to the resource group. This could result in multiple pending
>> work items associated with a single task even if they are all identical and
>> even though only a single update with most recent values is needed.
>> Specifically, even if a task is moved between different resource groups
>> while it is sleeping then it is only the last move that is relevant but
>> yet a work item is queued during each move.
>> This unnecessary queueing of work items could result in significant system
>> resource waste, especially on tasks sleeping for a long time. For example,
>> as demonstrated by Shakeel Butt in [1] writing the same task id to the
>> "tasks" file can quickly consume significant memory. The same problem
>> (wasted system resources) occurs when moving a task between different
>> resource groups.
>>
>> As pointed out by Valentin Schneider in [2] there is an additional issue with
>> the way in which the queueing of work is done in that the task_struct update
>> is currently done after the work is queued, resulting in a race with the
>> register update possibly done before the data needed by the update is available.
>>
>> To solve these issues, the PQR_ASSOC MSR is updated in a synchronous way
>> right after the new closid and rmid are ready during the task movement,
>> only if the task is running. If a moved task is not running nothing is
>> done since the PQR_ASSOC MSR will be updated next time the task is scheduled.
>> This is the same way used to update the register when tasks are moved as
>> part of resource group removal.
> 
> (as t->on_cpu is already used...)
> 
> Reviewed-by: James Morse <james.morse@arm.com>

Thank you very much. I do plan to follow your suggestion below though.


>> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> index 68db7d2dec8f..9d62f1fadcc3 100644
>> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> @@ -525,6 +525,16 @@ static void rdtgroup_remove(struct rdtgroup *rdtgrp)
> 
> 
>> +static void update_task_closid_rmid(struct task_struct *t)
>>   {
>> +	int cpu;
>>   
>> +	if (task_on_cpu(t, &cpu))
>> +		smp_call_function_single(cpu, _update_task_closid_rmid, t, 1);
> 
> 
> I think:
> |	if (task_curr(t))
> |		smp_call_function_single(task_cpu(t), _update_task_closid_rmid, t, 1);
> 
> here would make for an easier backport as it doesn't depend on the previous patch.
> 

Will do, thank you very much.

The previous patch has now become a bugfix in its own right after you 
pointed out the issue with using t->on_cpu. In addressing that I plan to 
remove the helpers found in patch #1 so backporting should continue to 
be easier.

> 
>> +}
> 
> [...]
> 
>>   static int __rdtgroup_move_task(struct task_struct *tsk,
>>   				struct rdtgroup *rdtgrp)
>>   {
> 
>> +	if (rdtgrp->type == RDTCTRL_GROUP) {
>> +		tsk->closid = rdtgrp->closid;
>> +		tsk->rmid = rdtgrp->mon.rmid;
>> +	} else if (rdtgrp->type == RDTMON_GROUP) {
> 
> [...]
> 
>> +	} else {
> 
>> +		rdt_last_cmd_puts("Invalid resource group type\n");
>> +		return -EINVAL;
> 
> Wouldn't this be a kernel bug?
> I'd have thought there would be a WARN_ON_ONCE() here to make it clear this isn't
> user-space's fault!

You are right, this would be a kernel bug. I'll add a WARN_ON_ONCE().

> 
> 
>>   	}
>> -	return ret;
>> +
>> +	/*
>> +	 * By now, the task's closid and rmid are set. If the task is current
>> +	 * on a CPU, the PQR_ASSOC MSR needs to be updated to make the resource
>> +	 * group go into effect. If the task is not current, the MSR will be
>> +	 * updated when the task is scheduled in.
>> +	 */
>> +	update_task_closid_rmid(tsk);
>> +
>> +	return 0;
>>   }
> 

Thank you very much.

Reinette

