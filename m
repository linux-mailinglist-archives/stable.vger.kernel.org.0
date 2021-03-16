Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330AA33DDA6
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 20:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhCPTgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 15:36:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:15392 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234578AbhCPTgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 15:36:23 -0400
IronPort-SDR: xZaYZg6U09MJHi6wuLDK1JTkAmOCLoG6r713l63DnN6hWhS7JyL0tNcU5NtgvtBszZUBU6F1EO
 /CcWSNg3tfRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="185961788"
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="185961788"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 12:36:23 -0700
IronPort-SDR: YlPW8nGkqmnwpAIgp6+sxTQuGd0EZQUBpZ8PsWsnlwT9lZAHg55TQrGtp5p18TK3jNIvLZaie5
 mPaX0qmz/G+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,254,1610438400"; 
   d="scan'208";a="440186335"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2021 12:36:23 -0700
Received: from [10.254.95.225] (kliang2-MOBL.ccr.corp.intel.com [10.254.95.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 22A385808A6;
        Tue, 16 Mar 2021 12:36:21 -0700 (PDT)
Subject: Re: [PATCH] Revert "perf/x86: Allow zero PEBS status with only single
 active event"
To:     Stephane Eranian <eranian@google.com>
Cc:     Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        "stable # 4 . 5" <stable@vger.kernel.org>
References: <1614778938-93092-1-git-send-email-kan.liang@linux.intel.com>
 <YD/cnnuh/AHOL8hV@hirez.programming.kicks-ass.net>
 <9484ab6e-a6e5-bb72-106f-ed904e50fc0c@linux.intel.com>
 <YD/vy2RnkWZYiJHP@hirez.programming.kicks-ass.net>
 <CAM9d7cjbSGC_mac0CuU3xnDN=bkJ81W+FLn5XSvxbaHb5HL6Fw@mail.gmail.com>
 <c0fa23c1-bd49-8b98-a61b-5b34ae6a7a78@linux.intel.com>
 <CABPqkBTdv-3ZFYy+=K3yYL1ccniC7TNHwv4TGysrxSHuR=_TOA@mail.gmail.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <a2c46da1-e725-d4e3-09af-3da0bc3f6fc9@linux.intel.com>
Date:   Tue, 16 Mar 2021 15:36:19 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CABPqkBTdv-3ZFYy+=K3yYL1ccniC7TNHwv4TGysrxSHuR=_TOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/16/2021 2:34 PM, Stephane Eranian wrote:
> On Tue, Mar 16, 2021 at 5:28 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>
>>
>>
>> On 3/16/2021 3:22 AM, Namhyung Kim wrote:
>>> Hi Peter and Kan,
>>>
>>> On Thu, Mar 4, 2021 at 5:22 AM Peter Zijlstra <peterz@infradead.org> wrote:
>>>>
>>>> On Wed, Mar 03, 2021 at 02:53:00PM -0500, Liang, Kan wrote:
>>>>> On 3/3/2021 1:59 PM, Peter Zijlstra wrote:
>>>>>> On Wed, Mar 03, 2021 at 05:42:18AM -0800, kan.liang@linux.intel.com wrote:
>>>>
>>>>>>> +++ b/arch/x86/events/intel/ds.c
>>>>>>> @@ -2000,18 +2000,6 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs, struct perf_sample_d
>>>>>>>                             continue;
>>>>>>>                     }
>>>>>>> -         /*
>>>>>>> -          * On some CPUs the PEBS status can be zero when PEBS is
>>>>>>> -          * racing with clearing of GLOBAL_STATUS.
>>>>>>> -          *
>>>>>>> -          * Normally we would drop that record, but in the
>>>>>>> -          * case when there is only a single active PEBS event
>>>>>>> -          * we can assume it's for that event.
>>>>>>> -          */
>>>>>>> -         if (!pebs_status && cpuc->pebs_enabled &&
>>>>>>> -                 !(cpuc->pebs_enabled & (cpuc->pebs_enabled-1)))
>>>>>>> -                 pebs_status = cpuc->pebs_enabled;
>>>>>>
>>>>>> Wouldn't something like:
>>>>>>
>>>>>>                       pebs_status = p->status = cpus->pebs_enabled;
>>>>>>
>>>>>
>>>>> I didn't consider it as a potential solution in this patch because I don't
>>>>> think it's a proper way that SW modifies the buffer, which is supposed to be
>>>>> manipulated by the HW.
>>>>
>>>> Right, but then HW was supposed to write sane values and it doesn't do
>>>> that either ;-)
>>>>
>>>>> It's just a personal preference. I don't see any issue here. We may try it.
>>>>
>>>> So I mostly agree with you, but I think it's a shame to unsupport such
>>>> chips, HSW is still a plenty useable chip today.
>>>
>>> I got a similar issue on ivybridge machines which caused kernel crash.
>>> My case it's related to the branch stack with PEBS events but I think
>>> it's the same issue.  And I can confirm that the above approach of
>>> updating p->status fixed the problem.
>>>
>>> I've talked to Stephane about this, and he wants to make it more
>>> robust when we see stale (or invalid) PEBS records.  I'll send the
>>> patch soon.
>>>
>>
>> Hi Namhyung,
>>
>> In case you didn't see it, I've already submitted a patch to fix the
>> issue last Friday.
>> https://lore.kernel.org/lkml/1615555298-140216-1-git-send-email-kan.liang@linux.intel.com/
>> But if you have a more robust proposal, please feel free to submit it.
>>
> This fixes the problem on the older systems. The other problem we
> identified related to the
> PEBS sample processing code is that you can end up with uninitialized
> perf_sample_data
> struct passed to perf_event_overflow():
> 
>   setup_pebs_fixed_sample_data(pebs, data)
> {
>          if (!pebs)
>                  return;
>          perf_sample_data_init(data);  <<< must be moved before the if (!pebs)
>          ...
> }
> 
> __intel_pmu_pebs_event(pebs, data)
> {
>          setup_sample(pebs, data)
>          perf_event_overflow(data);
>          ...
> }
> 
> If there is any other reason to get a pebs = NULL in fix_sample_data()
> or adaptive_sample_data(), then
> you must call perf_sample_data_init(data) BEFORE you return otherwise
> you end up in perf_event_overflow()
> with uninitialized data and you may die as follows:
> 
> [<ffffffff812f283d>] ? perf_output_copy+0x4d/0xb0
> [<ffffffff812e0fb1>] perf_output_sample+0x561/0xab0
> [<ffffffff812e0952>] ? __perf_event_header__init_id+0x112/0x130
> [<ffffffff812e1be1>] ? perf_prepare_sample+0x1b1/0x730
> [<ffffffff812e21b9>] perf_event_output_forward+0x59/0x80
> [<ffffffff812e0634>] ? perf_event_update_userpage+0xf4/0x110
> [<ffffffff812e4468>] perf_event_overflow+0x88/0xe0
> [<ffffffff810175b8>] __intel_pmu_pebs_event+0x328/0x380
> 
> This all stems from get_next_pebs_record_by_bit()  potentially
> returning NULL but the NULL is not handled correctly
> by the callers. This is what I'd like to see cleaned up in
> __intel_pmu_pebs_event() to  avoid future problems.
> 

Got it. Yes, we need another patch to correctly handle the potentially
returning NULL. Thanks for pointing it out.

Thanks,
Kan
