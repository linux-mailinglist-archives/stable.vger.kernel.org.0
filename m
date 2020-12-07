Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212C92D1C07
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 22:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgLGVZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 16:25:35 -0500
Received: from mga04.intel.com ([192.55.52.120]:3683 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgLGVZf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 16:25:35 -0500
IronPort-SDR: PzKWmiwReFtVwJ9TpbcPtlPF51IBLx4u465/Zu2YQBXQiUr+C2q21h3SizR51j9x8l/F4ByxiR
 G+UDCHEp9v+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="171207577"
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="171207577"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 13:24:54 -0800
IronPort-SDR: N/28dJUJNMCdJSszU2y/GklgeDWZuupTNFrDjIll6ESPmRcvHXN3YvNatn9tUolilbsIYqK7/b
 Xu1bc6jrBy0A==
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="437100464"
Received: from rchatre-mobl3.amr.corp.intel.com (HELO [10.209.61.193]) ([10.209.61.193])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 13:24:52 -0800
Subject: Re: [PATCH 1/3] x86/resctrl: Move setting task's active CPU in a mask
 into helpers
To:     Borislav Petkov <bp@alien8.de>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, tony.luck@intel.com,
        kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        james.morse@arm.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <cover.1607036601.git.reinette.chatre@intel.com>
 <77973e75a10bf7ef9b33c664544667deee9e1a8e.1607036601.git.reinette.chatre@intel.com>
 <20201207182912.GF20489@zn.tnic>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <db6bea7e-b60b-2859-aa35-c3d2d5356eaa@intel.com>
Date:   Mon, 7 Dec 2020 13:24:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207182912.GF20489@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Borislav,

Thank you very much for your review.

On 12/7/2020 10:29 AM, Borislav Petkov wrote:
> On Thu, Dec 03, 2020 at 03:25:48PM -0800, Reinette Chatre wrote:
>> From: Fenghua Yu <fenghua.yu@intel.com>
>>
>> The code of setting the CPU on which a task is running in a CPU mask is
>> moved into a couple of helpers.
> 
> Pls read section "2) Describe your changes" in
> Documentation/process/submitting-patches.rst for more details.
> 
> More specifically:
> 
> "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
> instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
> to do frotz", as if you are giving orders to the codebase to change
> its behaviour."
> 
>> The new helper task_on_cpu() will be reused shortly.
> 
> "reused shortly"? I don't think so.


How about:
"Move the setting of the CPU on which a task is running in a CPU mask 
into a couple of helpers.

There is no functional change. This is a preparatory change for the fix 
in the following patch from where the Fixes tag is copied."

> 
>>
>> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> Reviewed-by: Tony Luck <tony.luck@intel.com>
>> Cc: stable@vger.kernel.org
> 
> Fixes?
> 
> I guess the same commit from the other two:
> 
> Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
> 
> ?

Correct. I will add it. The addition to the commit message above aims to 
explain a Fixes tag to a patch with no functional changes.


>> ---
>>   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 47 +++++++++++++++++++-------
>>   1 file changed, 34 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> index 6f4ca4bea625..68db7d2dec8f 100644
>> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
>> @@ -525,6 +525,38 @@ static void rdtgroup_remove(struct rdtgroup *rdtgrp)
>>   	kfree(rdtgrp);
>>   }
>>   
>> +#ifdef CONFIG_SMP
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
>> +	if (t->on_cpu) {
>> +		*cpu = task_cpu(t);
> 
> Why have an I/O parameter when you can make it simply:
> 
> static int task_on_cpu(struct task_struct *t)
> {
> 	if (t->on_cpu)
> 		return task_cpu(t);
> 
> 	return -1;
> }
> 
>> +
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> +static void set_task_cpumask(struct task_struct *t, struct cpumask *mask)
>> +{
>> +	int cpu;
>> +
>> +	if (mask && task_on_cpu(t, &cpu))
>> +		cpumask_set_cpu(cpu, mask);
> 
> And that you can turn into:
> 
> 	if (!mask)
> 		return;
> 
> 	cpu = task_on_cpu(t);
> 	if (cpu < 0)
> 		return;
> 
> 	cpumask_set_cpu(cpu, mask);
> 
> Readable and simple.
> 
> Hmm?
> 

Will do. Thank you very much.

Reinette
