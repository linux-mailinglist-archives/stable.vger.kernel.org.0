Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A0848C734
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 16:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbiALP1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 10:27:36 -0500
Received: from mga12.intel.com ([192.55.52.136]:18452 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245740AbiALP1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jan 2022 10:27:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642001254; x=1673537254;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IPzQ1seZQyyplo99PQB+zisMVjDJiAJoC4gSimmGlck=;
  b=O280LJfQL6o9pM7XHRW9sSlvOUHxvjMXU6DGo9O+4dVMDWry6m4/LiCq
   QjhMQHLzgrSDBEwsUDIPqWjnVGnWkPotHFKCGcEcbSRqADex6N2jRqlq7
   KeOv1Iv0ky4z45bIEulcQpQdUReEEIZqy6QUfVptO0gKimOpI7jMgBIpb
   od9dPtMDhr+u7H0+swfQSwzVWkl+8e2EGUz8NBk45QmhcGuDrK1wJcslo
   hbDeAw7TmgmUzHjgixJoQlw7kK5C4pSEK7/sm+BMqrSfxLp7dH8ZkXdIo
   GjBYKbiUJ3zxWaKAVSs4Bp40otU2txr0NOIRl5tWHU1jdTo5xpvA/MjLu
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="223738346"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="223738346"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 07:26:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="490764405"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga002.jf.intel.com with ESMTP; 12 Jan 2022 07:26:41 -0800
Received: from [10.212.251.158] (kliang2-MOBL.ccr.corp.intel.com [10.212.251.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 6201F58072B;
        Wed, 12 Jan 2022 07:26:40 -0800 (PST)
Message-ID: <abf04b7b-54c4-c82e-9a3b-53e97b73e90d@linux.intel.com>
Date:   Wed, 12 Jan 2022 10:26:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] perf/x86/intel: Add a quirk for the calculation of the
 number of counters on Alder Lake
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        damarion@cisco.com, edison_chan_gz@hotmail.com,
        ray.kinsella@intel.com, stable@vger.kernel.org
References: <1641925238-149288-1-git-send-email-kan.liang@linux.intel.com>
 <Yd6lSH41fqcpUS+P@hirez.programming.kicks-ass.net>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <Yd6lSH41fqcpUS+P@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/12/2022 4:54 AM, Peter Zijlstra wrote:
> On Tue, Jan 11, 2022 at 10:20:38AM -0800, kan.liang@linux.intel.com wrote:
>> From: Kan Liang <kan.liang@linux.intel.com>
>>
>> For some Alder Lake machine with all E-cores disabled in a BIOS, the
>> below warning may be triggered.
>>
>> [ 2.010766] hw perf events fixed 5 > max(4), clipping!
>>
>> Current perf code relies on the CPUID leaf 0xA and leaf 7.EDX[15] to
>> calculate the number of the counters and follow the below assumption.
>>
>> For a hybrid configuration, the leaf 7.EDX[15] (X86_FEATURE_HYBRID_CPU)
>> is set. The leaf 0xA only enumerate the common counters. Linux perf has
>> to manually add the extra GP counters and fixed counters for P-cores.
>> For a non-hybrid configuration, the X86_FEATURE_HYBRID_CPU should not
>> be set. The leaf 0xA enumerates all counters.
>>
>> However, that's not the case when all E-cores are disabled in a BIOS.
>> Although there are only P-cores in the system, the leaf 7.EDX[15]
>> (X86_FEATURE_HYBRID_CPU) is still set. But the leaf 0xA is updated
>> to enumerate all counters of P-cores. The inconsistency triggers the
>> warning.
>>
>> Several software ways were considered to handle the inconsistency.
>> - Drop the leaf 0xA and leaf 7.EDX[15] CPUID enumeration support.
>>    Hardcode the number of counters. This solution may be a problem for
>>    virtualization. A hypervisor cannot control the number of counters
>>    in a Linux guest via changing the guest CPUID enumeration anymore.
>> - Find another CPUID bit that is also updated with E-cores disabled.
>>    There may be a problem in the virtualization environment too. Because
>>    a hypervisor may disable the feature/CPUID bit.
>> - The P-cores have a maximum of 8 GP counters and 4 fixed counters on
>>    ADL. The maximum number can be used to detect the case.
>>    This solution is implemented in this patch.
> 
> ARGH!! This is horrific :-(
> 
> This is also the N-th problem with hybrid enumeration; is there a plan
> to fix all that for the next generation or are we going to keep muddling
> things?

Yes, that's annoying. We are working on it for the future generation.
The internal validation team is also enhancing the test case to test 
different configurations.

> 
>> Fixes: ee72a94ea4a6 ("perf/x86/intel: Fix fixed counter check warning for some Alder Lake")
>> Reported-by: Damjan Marion (damarion) <damarion@cisco.com>
>> Tested-by: Damjan Marion (damarion) <damarion@cisco.com>
>> Reported-by: Chan Edison <edison_chan_gz@hotmail.com>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   arch/x86/events/intel/core.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index 187906e..f1201e8 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -6239,6 +6239,18 @@ __init int intel_pmu_init(void)
>>   			pmu->num_counters = x86_pmu.num_counters;
>>   			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
>>   		}
>> +
>> +		/* Quirk: For some Alder Lake machine, when all E-cores are disabled in
>> +		 * a BIOS, the leaf 0xA will enumerate all counters of P-cores. However,
>> +		 * the X86_FEATURE_HYBRID_CPU is still set. The above codes will
>> +		 * mistakenly add extra counters for P-cores. Correct the number of
>> +		 * counters here.
>> +		 */
> 
> I fixed that comment style for you.

Ah, sorry for that. Thanks!

Kan

> 
>> +		if ((pmu->num_counters > 8) || (pmu->num_counters_fixed > 4)) {
>> +			pmu->num_counters = x86_pmu.num_counters;
>> +			pmu->num_counters_fixed = x86_pmu.num_counters_fixed;
>> +		}
>> +
>>   		pmu->max_pebs_events = min_t(unsigned, MAX_PEBS_EVENTS, pmu->num_counters);
>>   		pmu->unconstrained = (struct event_constraint)
>>   					__EVENT_CONSTRAINT(0, (1ULL << pmu->num_counters) - 1,
>> -- 
>> 2.7.4
>>
