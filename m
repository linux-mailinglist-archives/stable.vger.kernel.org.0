Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92C32D9F66
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440499AbgLNSm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:42:27 -0500
Received: from mga18.intel.com ([134.134.136.126]:32249 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439866AbgLNSmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 13:42:19 -0500
IronPort-SDR: xMEcqO/4B+FGDURMZ3NFCUjt9igcCOddQKuLtCCin5n4NtyjkVSDI2SbpbV3MzyZ6HdUvhTOaD
 PVkRwqrpq/OA==
X-IronPort-AV: E=McAfee;i="6000,8403,9834"; a="162504387"
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="162504387"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 10:41:33 -0800
IronPort-SDR: ezoYwt+zcz1slJEgjW9HXjzSOBaD/U4TND1tKwZMsFWASZhl7mD1TDcYXaXfUv8z/qP3grTCxX
 bo1LZnnM/cBg==
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="411362244"
Received: from rchatre-mobl3.amr.corp.intel.com (HELO [10.212.45.112]) ([10.212.45.112])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 10:41:32 -0800
Subject: Re: [PATCH 2/3] x86/resctrl: Update PQR_ASSOC MSR synchronously when
 moving task to resource group
To:     Valentin Schneider <valentin.schneider@arm.com>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, bp@alien8.de,
        tony.luck@intel.com, kuo-lang.tseng@intel.com, shakeelb@google.com,
        mingo@redhat.com, babu.moger@amd.com, james.morse@arm.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1607036601.git.reinette.chatre@intel.com>
 <c8eebc438e057e4bc2ce00256664b7bb0561b323.1607036601.git.reinette.chatre@intel.com>
 <jhjlfe4t6jq.mognet@arm.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <e250875b-1c86-660c-b9f0-4060842939bf@intel.com>
Date:   Mon, 14 Dec 2020 10:41:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <jhjlfe4t6jq.mognet@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Valentin,

On 12/11/2020 12:46 PM, Valentin Schneider wrote:
> 
> On 03/12/20 23:25, Reinette Chatre wrote:
>> Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
>> Reported-by: Shakeel Butt <shakeelb@google.com>
>> Reported-by: Valentin Schneider <valentin.schneider@arm.com>
>> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> Reviewed-by: Tony Luck <tony.luck@intel.com>
>> Cc: stable@vger.kernel.org
> 
> Some pedantic comments below; with James' task_curr() + task_cpu()
> suggestion:
> 
> Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>

Thank you very much.


>> ---
...

>> +	if (rdtgrp->type == RDTCTRL_GROUP) {
>> +		tsk->closid = rdtgrp->closid;
>> +		tsk->rmid = rdtgrp->mon.rmid;
>> +	} else if (rdtgrp->type == RDTMON_GROUP) {
>> +		if (rdtgrp->mon.parent->closid == tsk->closid) {
>>                        tsk->rmid = rdtgrp->mon.rmid;
>> -		} else if (rdtgrp->type == RDTMON_GROUP) {
>> -			if (rdtgrp->mon.parent->closid == tsk->closid) {
>> -				tsk->rmid = rdtgrp->mon.rmid;
>> -			} else {
>> -				rdt_last_cmd_puts("Can't move task to different control group\n");
>> -				ret = -EINVAL;
>> -			}
>> +		} else {
>> +			rdt_last_cmd_puts("Can't move task to different control group\n");
>> +			return -EINVAL;
>>                }
>> +	} else {
>> +		rdt_last_cmd_puts("Invalid resource group type\n");
>> +		return -EINVAL;
>>        }
> 
> James already pointed out this should be a WARN_ON_ONCE(), but is that the
> right place to assert rdtgrp->type validity?
> 
> I see only a single assignment to rdtgrp->type in mkdir_rdt_prepare();
> could we fail the group creation there instead if the passed rtype is
> invalid?

Yes, there is that single assignment in mkdir_rdt_prepare() and looking 
at how mkdir_rdt_prepare() is called it is only ever called with 
RDTMON_GROUP or RDTCTRL_GROUP. This additional error checking was added 
as part of this fix but unrelated to the fix itself. Since you and James 
both pointed out flaws with it and it is unnecessary I will remove it 
here and maintain the original checking that continues to be sufficient.

>> -	return ret;
>> +
>> +	/*
>> +	 * By now, the task's closid and rmid are set. If the task is current
>> +	 * on a CPU, the PQR_ASSOC MSR needs to be updated to make the resource
>> +	 * group go into effect. If the task is not current, the MSR will be
>> +	 * updated when the task is scheduled in.
>> +	 */
>> +	update_task_closid_rmid(tsk);
> 
> We need the above writes to be compile-ordered before the IPI is sent.
> There *is* a preempt_disable() down in smp_call_function_single() that
> gives us the required barrier(), can we deem that sufficient or would we
> want one before update_task_closid_rmid() for the sake of clarity?
> 

Apologies, it is not clear to me why the preempt_disable() would be 
insufficient. If it is not then there may be a few other areas (where 
resctrl calls smp_call_function_xxx()) that needs to be re-evaluated.

Thank you very much

Reinette

