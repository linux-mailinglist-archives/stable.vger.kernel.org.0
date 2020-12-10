Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F4C2D4F50
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 01:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgLJAVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 19:21:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:36194 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbgLJAVp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 19:21:45 -0500
IronPort-SDR: CYyZ9VI5IIH0+FxkxgZeQDry18bj6WRYU45AQlU8lBADPZszQm4SWKt5vN+Y/+BKMfjK4o/Fa4
 vl/X3UFdTo2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="170663419"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="170663419"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 16:21:04 -0800
IronPort-SDR: FEzWeizcvfYARXbqtdQBrILs6Vjy9Q2rQKgF29O6pmYYV2aoMKuK6DhFBiNMhakmsaeq+bg6UA
 tIJQpBQogaCg==
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="438054504"
Received: from rchatre-mobl3.amr.corp.intel.com (HELO [10.209.138.37]) ([10.209.138.37])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 16:21:04 -0800
Subject: Re: [PATCH 1/3] x86/resctrl: Move setting task's active CPU in a mask
 into helpers
To:     James Morse <james.morse@arm.com>, fenghua.yu@intel.com
Cc:     tglx@linutronix.de, bp@alien8.de, tony.luck@intel.com,
        kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1607036601.git.reinette.chatre@intel.com>
 <77973e75a10bf7ef9b33c664544667deee9e1a8e.1607036601.git.reinette.chatre@intel.com>
 <a782d2f3-d2f6-795f-f4b1-9462205fd581@arm.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <d38430c5-3d65-2c8a-d267-fb99b666d5ea@intel.com>
Date:   Wed, 9 Dec 2020 16:21:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <a782d2f3-d2f6-795f-f4b1-9462205fd581@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi James,

Thank you very much for your review.

On 12/9/2020 8:47 AM, James Morse wrote:
> Hi Reinette, Fenghua,
> 
> On 03/12/2020 23:25, Reinette Chatre wrote:
>> From: Fenghua Yu <fenghua.yu@intel.com>
>>
>> The code of setting the CPU on which a task is running in a CPU mask is
>> moved into a couple of helpers. The new helper task_on_cpu() will be
>> reused shortly.
> 
>> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> index 6f4ca4bea625..68db7d2dec8f 100644
>> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> @@ -525,6 +525,38 @@ static void rdtgroup_remove(struct rdtgroup *rdtgrp)
> 
>> +#ifdef CONFIG_SMP
> 
> (using IS_ENABLED(CONFIG_SMP) lets the compiler check all the code in one go, then
> dead-code-remove the stuff that will never happen... its also easier on the eye!)

Thank you for catching this. New fix (see below) uses this.

>> +/* Get the CPU if the task is on it. */
>> +static bool task_on_cpu(struct task_struct *t, int *cpu)
>> +{
>> +	/*
>> +	 * This is safe on x86 w/o barriers as the ordering of writing to
>> +	 * task_cpu() and t->on_cpu is reverse to the reading here. The
>> +	 * detection is inaccurate as tasks might move or schedule before
>> +	 * the smp function call takes place. In such a case the function
>> +	 * call is pointless, but there is no other side effect.
>> +	 */
> 
>> +	if (t->on_cpu) {
> 
> kernel/sched/core.c calls out that there can be two tasks on one CPU with this set.
> (grep astute)
> I think that means this series will falsely match the old task for a CPU while the
> scheduler is running, and IPI it unnecessarily.
> 
> task_curr() is the helper that knows not to do this.
> 

Thank you very much for catching this. I did not know this. This exposes 
an issue with the current implementation of moving tasks as part of 
directory removal. I now plan to replace this patch with a new fix to 
address this new issue you exposed: the fix will replace the current 
usage of t->on_cpu with task_curr(). Since I also follow your suggestion 
for patch #2 this original patch is no longer needed, which is something 
Borislav also suggested but I could not see a way to do it at the time.

This new fix does seem to fall into the "This could be a problem.." 
category of issues referred to in stable-kernel-rules.rst so while I 
plan on adding a Fixes tag I plan to not cc the stable team on this one. 
I am unsure about the right thing to do here so if you have an opinion I 
would appreciate it.

What do you think of this replacement patch (that will be moved to end 
of series)?

Reinette

----8<------
x86/resctrl: Replace t->on_cpu with task_curr() to prevent unnecessary IPI

James reported in [1] that there could be two tasks running on the same CPU
with t->on_cpu set. Using t->on_cpu as a test if a task is running on a
CPU may thus match the old task for a CPU while the scheduler is
running and IPI it unnecessarily.

task_curr() is the correct helper to use. While doing so move the #ifdef
check of the CONFIG_SMP symbol to be a C conditional used to determine
if this helper should be used so ensure the code is always checked for
correctness by the compiler.

[1] 
https://lore.kernel.org/lkml/a782d2f3-d2f6-795f-f4b1-9462205fd581@arm.com

Fixes: 0efc89be9471 ("x86/intel_rdt: Update task closid immediately on 
CPU in rmdir and unmount")
Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
  arch/x86/kernel/cpu/resctrl/rdtgroup.c | 14 ++------------
  1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c 
b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 5e5a49f38fa1..c64fb37f0aec 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2317,19 +2317,9 @@ static void rdt_move_group_tasks(struct rdtgroup 
*from, struct rdtgroup *to,
  			t->closid = to->closid;
  			t->rmid = to->mon.rmid;

-#ifdef CONFIG_SMP
-			/*
-			 * This is safe on x86 w/o barriers as the ordering
-			 * of writing to task_cpu() and t->on_cpu is
-			 * reverse to the reading here. The detection is
-			 * inaccurate as tasks might move or schedule
-			 * before the smp function call takes place. In
-			 * such a case the function call is pointless, but
-			 * there is no other side effect.
-			 */
-			if (mask && t->on_cpu)
+			/* If the task is on a CPU, set the CPU in the mask. */
+			if (IS_ENABLED(CONFIG_SMP) && mask && task_curr(t))
  				cpumask_set_cpu(task_cpu(t), mask);
-#endif
  		}
  	}
  	read_unlock(&tasklist_lock);







