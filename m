Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B2E1E4918
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 18:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389272AbgE0QC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 12:02:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:47318 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389267AbgE0QC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 12:02:57 -0400
IronPort-SDR: giN0bVhIN/CJ39dZgnBKVjhzc9yuR2IsO7i+rrgs3rggtLNlfjCGYLEnJpLN/eFqUgxwRFxJdV
 Pc1M1eY7KrLw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 09:02:56 -0700
IronPort-SDR: 3nKPDyImPi/2WAGvtXNER2/vs3n5Y6UHn04K1YXE3MmbKRoGoj9GyZJbXjExGVbYJGMzxcHd+6
 KD/81HdHVLqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,441,1583222400"; 
   d="scan'208";a="442575042"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 27 May 2020 09:02:56 -0700
Received: from [10.251.8.26] (kliang2-mobl.ccr.corp.intel.com [10.251.8.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id BF2595802C9;
        Wed, 27 May 2020 09:02:55 -0700 (PDT)
Subject: Re: [PATCH] perf/x86/intel/uncore: Fix oops when counting IMC uncore
 events on some TGL
To:     David Laight <David.Laight@ACULAB.COM>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "ak@linux.intel.com" <ak@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <1590582647-90675-1-git-send-email-kan.liang@linux.intel.com>
 <869fafc80da84d188678c1cbb0267a0b@AcuMS.aculab.com>
 <ed3d86b7-2f75-cfe9-bc74-5f2c29ef2540@linux.intel.com>
 <d64c3c684ccd46daa5bb326dbbb277b0@AcuMS.aculab.com>
 <9f0ed889-590e-6f7a-85bd-c4be43e993f3@linux.intel.com>
 <a891f75d599c4978ba941de73c6a667b@AcuMS.aculab.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <e58d0b8f-3ade-4952-ff49-15eec0ad95df@linux.intel.com>
Date:   Wed, 27 May 2020 12:02:54 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <a891f75d599c4978ba941de73c6a667b@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/27/2020 11:17 AM, David Laight wrote:
> From: Liang, Kan
>> Sent: 27 May 2020 16:01
>> On 5/27/2020 10:51 AM, David Laight wrote:
>>> From: Liang, Kan
>>>> Sent: 27 May 2020 15:47
>>>> On 5/27/2020 8:59 AM, David Laight wrote:
>>>>> From: kan.liang@linux.intel.com
>>>>>> Sent: 27 May 2020 13:31
>>>>>>
>>>>>> From: Kan Liang <kan.liang@linux.intel.com>
>>>>>>
>>>>>> When counting IMC uncore events on some TGL machines, an oops will be
>>>>>> triggered.
>>>>>>      [ 393.101262] BUG: unable to handle page fault for address:
>>>>>>      ffffb45200e15858
>>>>>>      [ 393.101269] #PF: supervisor read access in kernel mode
>>>>>>      [ 393.101271] #PF: error_code(0x0000) - not-present page
>>>>>>
>>>>>> Current perf uncore driver still use the IMC MAP SIZE inherited from
>>>>>> SNB, which is 0x6000.
>>>>>> However, the offset of IMC uncore counters for some TGL machines is
>>>>>> larger than 0x6000, e.g. 0xd8a0.
>>>>>>
>>>>>> Enlarge the IMC MAP SIZE for TGL to 0xe000.
>>>>>
>>>>> Replacing one 'random' constant with a different one
>>>>> doesn't seem like a proper fix.
>>>>>
>>>>> Surely the actual bounds of the 'memory' area are properly
>>>>> defined somewhere.
>>>>> Or at least should come from a table.
>>>>>
>>>>> You also need to verify that the offsets are within the mapped area.
>>>>> An unexpected offset shouldn't try to access an invalid address.
>>>>
>>>> Thanks for the review.
>>>>
>>>> I agree that we should add a check before mapping the area to prevent
>>>> the issue happens again.
>>>>
>>>> I think the check should be a generic check for all platforms which try
>>>> to map an area, not just for TGL. I will submit a separate patch for the
>>>> check.
>>>
>>> You need a check that the actual access is withing the mapped area.
>>> So instead of getting an OOPS you get a error.
>>>
>>> This is after you've mapped it.
>>
>> Sure. Will add a WARN_ONCE() before the actual access.
> 
> No that will still panic some systems.
> pr_warn() is all you need.
>

If we print a warning for each access, there will be too many warnings.
I think I will use pr_warn_once instead.

Thanks,
Kan
