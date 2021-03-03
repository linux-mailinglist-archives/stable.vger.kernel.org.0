Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10B732C832
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376955AbhCDAey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:54 -0500
Received: from mga17.intel.com ([192.55.52.151]:17986 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1386961AbhCCTyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 14:54:52 -0500
IronPort-SDR: mD0oRJhUw9+/t3qNen+pL9KzBb3wo0GzwIwwmNGOJ4aLkWVEc3okkyjRPzhpTDTKt0LSK2ttVB
 m0XJQ8Nop69A==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="167167152"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="167167152"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 11:53:03 -0800
IronPort-SDR: R6iyP80M2hDdAwzW5JY4jBh3y+pIwOyZybQib2owkYHoShjNulOA3CDxBZc8mYFtKpNscgEq0o
 l0ioqUQuaNIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="406585782"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2021 11:53:03 -0800
Received: from [10.252.139.65] (kliang2-MOBL.ccr.corp.intel.com [10.252.139.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 43E9D580814;
        Wed,  3 Mar 2021 11:53:02 -0800 (PST)
Subject: Re: [PATCH] Revert "perf/x86: Allow zero PEBS status with only single
 active event"
To:     Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, eranian@google.com,
        ak@linux.intel.com, stable@vger.kernel.org
References: <1614778938-93092-1-git-send-email-kan.liang@linux.intel.com>
 <YD/cnnuh/AHOL8hV@hirez.programming.kicks-ass.net>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <9484ab6e-a6e5-bb72-106f-ed904e50fc0c@linux.intel.com>
Date:   Wed, 3 Mar 2021 14:53:00 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YD/cnnuh/AHOL8hV@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/3/2021 1:59 PM, Peter Zijlstra wrote:
> On Wed, Mar 03, 2021 at 05:42:18AM -0800, kan.liang@linux.intel.com wrote:
> 
>> For some old CPUs (HSW and earlier), the PEBS status in a PEBS record
>> may be mistakenly set to 0. To minimize the impact of the defect, the
>> commit was introduced to try to avoid dropping the PEBS record for some
>> cases. It adds a check in the intel_pmu_drain_pebs_nhm(), and updates
>> the local pebs_status accordingly. However, it doesn't correct the PEBS
>> status in the PEBS record, which may trigger the crash, especially for
>> the large PEBS.
>>
>> It's possible that all the PEBS records in a large PEBS have the PEBS
>> status 0. If so, the first get_next_pebs_record_by_bit() in the
>> __intel_pmu_pebs_event() returns NULL. The at = NULL. Since it's a large
>> PEBS, the 'count' parameter must > 1. The second
>> get_next_pebs_record_by_bit() will crash.
>>
>> Two solutions were considered to fix the crash.
>> - Keep the SW workaround and add extra checks in the
>>    get_next_pebs_record_by_bit() to workaround the issue. The
>>    get_next_pebs_record_by_bit() is a critical path. The extra checks
>>    will bring extra overhead for the latest CPUs which don't have the
>>    defect. Also, the defect can only be observed on some old CPUs
>>    (For example, the issue can be reproduced on an HSW client, but I
>>    didn't observe the issue on my Haswell server machine.). The impact
>>    of the defect should be limit.
>>    This solution is dropped.
>> - Drop the SW workaround and revert the commit.
>>    It seems that the commit never works, because the PEBS status in the
>>    PEBS record never be changed. The get_next_pebs_record_by_bit() only
>>    checks the PEBS status in the PEBS record. The record is dropped
>>    eventually. Reverting the commit should not change the current
>>    behavior.
> 
>> +++ b/arch/x86/events/intel/ds.c
>> @@ -2000,18 +2000,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
>>   			continue;
>>   		}
>>   
>> -		/*
>> -		 * On some CPUs the PEBS status can be zero when PEBS is
>> -		 * racing with clearing of GLOBAL_STATUS.
>> -		 *
>> -		 * Normally we would drop that record, but in the
>> -		 * case when there is only a single active PEBS event
>> -		 * we can assume it's for that event.
>> -		 */
>> -		if (!pebs_status && cpuc->pebs_enabled &&
>> -			!(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
>> -			pebs_status = cpuc->pebs_enabled;
> 
> Wouldn't something like:
> 
> 			pebs_status = p->status = cpus->pebs_enabled;
>

I didn't consider it as a potential solution in this patch because I 
don't think it's a proper way that SW modifies the buffer, which is 
supposed to be manipulated by the HW.
It's just a personal preference. I don't see any issue here. We may try it.

Vince, could you please help check whether Peter's suggestion fixes the 
crash?

Thanks,
Kan

> actually fix things without adding overhead?
> 
