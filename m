Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D583DF372
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 19:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237764AbhHCRB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 13:01:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:48522 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237666AbhHCRBM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 13:01:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="274790378"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="274790378"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:00:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="479596495"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 03 Aug 2021 10:00:40 -0700
Received: from [10.212.187.158] (kliang2-MOBL.ccr.corp.intel.com [10.212.187.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 8D65658093B;
        Tue,  3 Aug 2021 10:00:39 -0700 (PDT)
Subject: Re: [PATCH V2] perf/x86/intel: Apply mid ACK for small core
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org, ak@linux.intel.com,
        stable@vger.kernel.org
References: <1627997128-57891-1-git-send-email-kan.liang@linux.intel.com>
 <YQlY2o62E5A9xcdq@hirez.programming.kicks-ass.net>
 <9b0cb4ec-e8b8-3739-7b8d-e1c05785023a@linux.intel.com>
 <YQlsIvh7vwLt3f6g@hirez.programming.kicks-ass.net>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <20f884f0-bf32-a8a0-1636-674d1b3a4715@linux.intel.com>
Date:   Tue, 3 Aug 2021 13:00:38 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQlsIvh7vwLt3f6g@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/3/2021 12:17 PM, Peter Zijlstra wrote:
> On Tue, Aug 03, 2021 at 11:20:20AM -0400, Liang, Kan wrote:
>>
>>
>> On 8/3/2021 10:55 AM, Peter Zijlstra wrote:
>>> On Tue, Aug 03, 2021 at 06:25:28AM -0700, kan.liang@linux.intel.com wrote:
>>>> From: Kan Liang <kan.liang@linux.intel.com>
>>>>
>>>> A warning as below may be occasionally triggered in an ADL machine when
>>>> these conditions occur,
>>>> - Two perf record commands run one by one. Both record a PEBS event.
>>>> - Both runs on small cores.
>>>> - They have different adaptive PEBS configuration (PEBS_DATA_CFG).
>>>>
>>>> [  673.663291] WARNING: CPU: 4 PID: 9874 at
>>>> arch/x86/events/intel/ds.c:1743
>>>> setup_pebs_adaptive_sample_data+0x55e/0x5b0
>>>> [  673.663348] RIP: 0010:setup_pebs_adaptive_sample_data+0x55e/0x5b0
>>>> [  673.663357] Call Trace:
>>>> [  673.663357]  <NMI>
>>>> [  673.663357]  intel_pmu_drain_pebs_icl+0x48b/0x810
>>>> [  673.663360]  perf_event_nmi_handler+0x41/0x80
>>>> [  673.663368]  </NMI>
>>>> [  673.663370]  __perf_event_task_sched_in+0x2c2/0x3a0
>>>>
>>>> Different from the big core, the small core requires the ACK right
>>>> before re-enabling counters in the NMI handler, otherwise a stale PEBS
>>>> record may be dumped into the later NMI handler, which trigger the
>>>> warning.
>>>>
>>>> Add a new mid_ack flag to track the case. Add all PMI handler bits in
>>>> the struct x86_hybrid_pmu to track the bits for different types of PMUs.
>>>> Apply mid ACK for the small cores on an Alder Lake machine.
>>>
>>> Why do we need a new option? Why isn't early (as in not late) good
>>> enough?
>>>
>>
>> The early ACK can fix this issue, however it triggers a spurious NMI during
>> the stress test. I'm told to do the ACK right before re-enabling counters
>> for small cores. That indeed fixes all the issues.
> 
> Any chance that would also work for the chips that now use late_ack?
>

Let me check and do some tests.

Thanks,
Kan
