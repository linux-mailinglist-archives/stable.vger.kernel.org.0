Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BA033D3D5
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 13:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhCPM3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 08:29:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:62150 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231506AbhCPM2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 08:28:52 -0400
IronPort-SDR: i2em6qd87UX7yKcNRHvJkcPT5/T7NGaPdKHgsR8EfBPIUHs/qt81ZUo7Ec5AM5a73vH7z1ipcm
 0F7MsS9m6n3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="253265374"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="253265374"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 05:28:50 -0700
IronPort-SDR: 2kKqY//LRbKf7xAiLvdRj4sGT+zHhuq455Q6WSEGjswsq3qAqx408dNahVYIbIqYVGBend9yYO
 cgQD76y1OO0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="590637279"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 16 Mar 2021 05:28:50 -0700
Received: from [10.254.95.225] (kliang2-MOBL.ccr.corp.intel.com [10.254.95.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 408665807EA;
        Tue, 16 Mar 2021 05:28:49 -0700 (PDT)
Subject: Re: [PATCH] Revert "perf/x86: Allow zero PEBS status with only single
 active event"
To:     Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        "stable # 4 . 5" <stable@vger.kernel.org>
References: <1614778938-93092-1-git-send-email-kan.liang@linux.intel.com>
 <YD/cnnuh/AHOL8hV@hirez.programming.kicks-ass.net>
 <9484ab6e-a6e5-bb72-106f-ed904e50fc0c@linux.intel.com>
 <YD/vy2RnkWZYiJHP@hirez.programming.kicks-ass.net>
 <CAM9d7cjbSGC_mac0CuU3xnDN=bkJ81W+FLn5XSvxbaHb5HL6Fw@mail.gmail.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <c0fa23c1-bd49-8b98-a61b-5b34ae6a7a78@linux.intel.com>
Date:   Tue, 16 Mar 2021 08:28:47 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAM9d7cjbSGC_mac0CuU3xnDN=bkJ81W+FLn5XSvxbaHb5HL6Fw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/16/2021 3:22 AM, Namhyung Kim wrote:
> Hi Peter and Kan,
> 
> On Thu, Mar 4, 2021 at 5:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> On Wed, Mar 03, 2021 at 02:53:00PM -0500, Liang, Kan wrote:
>>> On 3/3/2021 1:59 PM, Peter Zijlstra wrote:
>>>> On Wed, Mar 03, 2021 at 05:42:18AM -0800, kan.liang@linux.intel.com wrote:
>>
>>>>> +++ b/arch/x86/events/intel/ds.c
>>>>> @@ -2000,18 +2000,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
>>>>>                            continue;
>>>>>                    }
>>>>> -         /*
>>>>> -          * On some CPUs the PEBS status can be zero when PEBS is
>>>>> -          * racing with clearing of GLOBAL_STATUS.
>>>>> -          *
>>>>> -          * Normally we would drop that record, but in the
>>>>> -          * case when there is only a single active PEBS event
>>>>> -          * we can assume it's for that event.
>>>>> -          */
>>>>> -         if (!pebs_status && cpuc->pebs_enabled &&
>>>>> -                 !(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
>>>>> -                 pebs_status = cpuc->pebs_enabled;
>>>>
>>>> Wouldn't something like:
>>>>
>>>>                      pebs_status = p->status = cpus->pebs_enabled;
>>>>
>>>
>>> I didn't consider it as a potential solution in this patch because I don't
>>> think it's a proper way that SW modifies the buffer, which is supposed to be
>>> manipulated by the HW.
>>
>> Right, but then HW was supposed to write sane values and it doesn't do
>> that either ;-)
>>
>>> It's just a personal preference. I don't see any issue here. We may try it.
>>
>> So I mostly agree with you, but I think it's a shame to unsupport such
>> chips, HSW is still a plenty useable chip today.
> 
> I got a similar issue on ivybridge machines which caused kernel crash.
> My case it's related to the branch stack with PEBS events but I think
> it's the same issue.  And I can confirm that the above approach of
> updating p->status fixed the problem.
> 
> I've talked to Stephane about this, and he wants to make it more
> robust when we see stale (or invalid) PEBS records.  I'll send the
> patch soon.
> 

Hi Namhyung,

In case you didn't see it, I've already submitted a patch to fix the 
issue last Friday.
https://lore.kernel.org/lkml/1615555298-140216-1-git-send-email-kan.liang@linux.intel.com/
But if you have a more robust proposal, please feel free to submit it.

BTW: The patch set from last Friday also fixed another bug found by the 
perf_fuzzer test. You may be interested.

Thanks,
Kan

