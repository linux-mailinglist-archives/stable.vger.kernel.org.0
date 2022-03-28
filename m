Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75C14E9EFA
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 20:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245224AbiC1ScC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 14:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244803AbiC1ScB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 14:32:01 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B9C54FAA;
        Mon, 28 Mar 2022 11:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648492220; x=1680028220;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r3i5UaWM0bgiovmA6dltplhk6QvrIpD/lMvovcgfU9k=;
  b=PwfRatwoPEIERsCvQqLrzmIvGF2b4z3jrMKXrKRQ+LWimXkqqRHqg7VN
   QMUZQrYp2Y5AvIn45ke/y5BU0Uhf5RmixT9c3kmSAMjECt5l3Oo16gq9h
   n8nWYLGotCDq/LiNlcco7QZYPufM7nHv5219WPDyAPrIReBrcv2+4IgJv
   P5Z/2v35es9NLsNFKujB1uTSjmMrjjEwwuPIT4MhGYqGGnd2XAblWfHXs
   k/huBVkVb31mXRkWb7tfnEUm/6TgKkjnCE7ZR5eKIi4wL9eMdQ3DJ9OOf
   E2MPipHEZKIlDMqCt5RH08xqWGg2H4jtCyvsgf6xWt/SmqBroSaYS3kAX
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="239009503"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="239009503"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 11:30:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="694456299"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 28 Mar 2022 11:30:19 -0700
Received: from [10.209.5.67] (kliang2-MOBL.ccr.corp.intel.com [10.209.5.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 0221158095F;
        Mon, 28 Mar 2022 11:30:18 -0700 (PDT)
Message-ID: <6d922fe2-cf8a-87fa-600d-a55c8d23da26@linux.intel.com>
Date:   Mon, 28 Mar 2022 14:30:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] perf/x86/intel: Don't extend the pseudo-encoding to GP
 counters
Content-Language: en-US
To:     Stephane Eranian <eranian@google.com>
Cc:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <1648482543-14923-1-git-send-email-kan.liang@linux.intel.com>
 <CABPqkBQS_VW4isEXBXzukWyUGqZSnR1G8c0p+MvK-MCVTjV2Ww@mail.gmail.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CABPqkBQS_VW4isEXBXzukWyUGqZSnR1G8c0p+MvK-MCVTjV2Ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/28/2022 1:11 PM, Stephane Eranian wrote:
> On Mon, Mar 28, 2022 at 8:50 AM <kan.liang@linux.intel.com> wrote:
>>
>> From: Kan Liang <kan.liang@linux.intel.com>
>>
>> The INST_RETIRED.PREC_DIST event (0x0100) doesn't count on SPR.
>> perf stat -e cpu/event=0xc0,umask=0x0/,cpu/event=0x0,umask=0x1/ -C0
>>
>>   Performance counter stats for 'CPU(s) 0':
>>
>>             607,246      cpu/event=0xc0,umask=0x0/
>>                   0      cpu/event=0x0,umask=0x1/
>>
>> The encoding for INST_RETIRED.PREC_DIST is pseudo-encoding, which
>> doesn't work on the generic counters. However, current perf extends its
>> mask to the generic counters.
>>
>> The pseudo event-code for a fixed counter must be 0x00. Check and avoid
>> extending the mask for the fixed counter event which using the
>> pseudo-encoding, e.g., ref-cycles and PREC_DIST event.
>>
>> With the patch,
>> perf stat -e cpu/event=0xc0,umask=0x0/,cpu/event=0x0,umask=0x1/ -C0
>>
>>   Performance counter stats for 'CPU(s) 0':
>>
>>             583,184      cpu/event=0xc0,umask=0x0/
>>             583,048      cpu/event=0x0,umask=0x1/
>>
>> Fixes: 2de71ee153ef ("perf/x86/intel: Fix ICL/SPR INST_RETIRED.PREC_DIST encodings")
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>> Cc: stable@vger.kernel.org
>> ---
>>   arch/x86/events/intel/core.c      | 6 +++++-
>>   arch/x86/include/asm/perf_event.h | 5 +++++
>>   2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>> index db32ef6..1d2e49d 100644
>> --- a/arch/x86/events/intel/core.c
>> +++ b/arch/x86/events/intel/core.c
>> @@ -5668,7 +5668,11 @@ static void intel_pmu_check_event_constraints(struct event_constraint *event_con
>>                          /* Disabled fixed counters which are not in CPUID */
>>                          c->idxmsk64 &= intel_ctrl;
>>
>> -                       if (c->idxmsk64 != INTEL_PMC_MSK_FIXED_REF_CYCLES)
>> +                       /*
>> +                        * Don't extend the pseudo-encoding to the
>> +                        * generic counters
>> +                        */
>> +                       if (!use_fixed_pseudo_encoding(c->code))
>>                                  c->idxmsk64 |= (1ULL << num_counters) - 1;
>>                  }
>>                  c->idxmsk64 &=
>> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
>> index 48e6ef56..cd85f03 100644
>> --- a/arch/x86/include/asm/perf_event.h
>> +++ b/arch/x86/include/asm/perf_event.h
>> @@ -242,6 +242,11 @@ struct x86_pmu_capability {
>>   #define INTEL_PMC_IDX_FIXED_SLOTS      (INTEL_PMC_IDX_FIXED + 3)
>>   #define INTEL_PMC_MSK_FIXED_SLOTS      (1ULL << INTEL_PMC_IDX_FIXED_SLOTS)
>>
>> +static inline bool use_fixed_pseudo_encoding(u64 code)
>> +{
>> +       return !(code & 0xff);
>> +}
>> +
> I ack the problem.
> 
> That does not take into account the old encoding for PREC_DIST 0x01c0
> which is also forced to
> fixed counter0 on ICL and should not be extended.

The old encoding is not documented in the ICL event list now. The only 
PREC_DIST event for ICL is using the pseudo encoding.

   {
     "EventCode": "0x00",
     "UMask": "0x01",
     "EventName": "INST_RETIRED.PREC_DIST",
     "BriefDescription": "Precise instruction retired event with a 
reduced effect of PEBS shadow in IP distribution",
     "PublicDescription": "A version of INST_RETIRED that allows for a 
more unbiased distribution of samples across instructions retired. It 
utilizes the Precise Distribution of Instructions Retired (PDIR) feature 
to mitigate some bias in how retired instructions get sampled. Use on 
Fixed Counter 0.",
     "Counter": "Fixed counter 0",

Ideally, I think we should remove the old encoding 0x01c0 from the 
constraints table rather than force it to fixed counter 0 only.
If so, that should be a separate patch.

> 
> That also limits the options for the SLOTS events which can be
> measured by a GP. Yet to work
> with PERF_METRICS, it has to be programmed into fixed counter 3.

For the SLOTS event which can only work with PERF_METRICS, the current 
perf already limit it as below.
FIXED_EVENT_CONSTRAINT(0x0400, 3),	/* SLOTS */
No behavior is changed with this patch.

For the GP version of SLOTS, it's 0x01a4. According to the event list, 
it can be scheduled on all GP counters. So it's not added into the 
constraints table.

     "EventCode": "0xa4",
     "UMask": "0x01",
     "EventName": "TOPDOWN.SLOTS_P",
     "BriefDescription": "TMA slots available for an unhalted logical 
processor. General counter - architectural event",
     "PublicDescription": "Counts the number of available slots for an 
unhalted logical processor. The event increments by machine-width of the 
narrowest pipeline as employed by the Top-down Microarchitecture 
Analysis method. The count is distributed among unhalted logical 
processors (hyper-threads) who share the same physical core.",
     "Counter": "0,1,2,3,4,5,6,7",
     "PEBScounters": "0,1,2,3,4,5,6,7",

Even we finally decide to extend the 0x01a4 to the fixed counter 3 and 
add an entry FIXED_EVENT_CONSTRAINT(0x01a4, 3) in the constraints table. 
This patch doesn't limit it.

Thanks,
Kan

> 
>>   /*
>>    * We model BTS tracing as another fixed-mode PMC.
>>    *
>> --
>> 2.7.4
>>
