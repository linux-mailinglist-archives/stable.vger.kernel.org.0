Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0441C94F8
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgEGPYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 11:24:04 -0400
Received: from mga14.intel.com ([192.55.52.115]:16765 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgEGPYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 11:24:04 -0400
IronPort-SDR: h4tid4VpFKGXm4disc7NK4Z4mgIRd5yhZbxZpu++6/yvILR8T7nH33XrGh7UuR5SJ/hCLsCnwD
 T50yZ0czP5aA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 08:24:02 -0700
IronPort-SDR: B1cfkzwMs+Q6fWgsLVxLg0tBTn9mIVW8O0a0O5wehlfIQEH4Kyb317XSBD45c1GZL0YJ1yVCPL
 UpXVTuetq2DA==
X-IronPort-AV: E=Sophos;i="5.73,364,1583222400"; 
   d="scan'208";a="435325951"
Received: from nstgemme-mobl1.ger.corp.intel.com (HELO [10.252.42.100]) ([10.252.42.100])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 08:24:01 -0700
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/i915: Mark concurrent submissions
 with a weak-dependency
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200507082124.1673-1-chris@chris-wilson.co.uk>
 <f5d72c82-7a9e-3142-f297-b2231f2e9b9f@linux.intel.com>
 <158886364344.20858.57212288691515302@build.alporthouse.com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <2ea266b4-64a7-e494-65e9-6435d4455a71@linux.intel.com>
Date:   Thu, 7 May 2020 16:23:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <158886364344.20858.57212288691515302@build.alporthouse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 07/05/2020 16:00, Chris Wilson wrote:
> Quoting Tvrtko Ursulin (2020-05-07 15:53:08)
>> On 07/05/2020 09:21, Chris Wilson wrote:
>>> We recorded the dependencies for WAIT_FOR_SUBMIT in order that we could
>>> correctly perform priority inheritance from the parallel branches to the
>>> common trunk. However, for the purpose of timeslicing and reset
>>> handling, the dependency is weak -- as we the pair of requests are
>>> allowed to run in parallel and not in strict succession. So for example
>>> we do need to suspend one if the other hangs.
>>>
>>> The real significance though is that this allows us to rearrange
>>> groups of WAIT_FOR_SUBMIT linked requests along the single engine, and
>>> so can resolve user level inter-batch scheduling dependencies from user
>>> semaphores.
>>>
>>> Fixes: c81471f5e95c ("drm/i915: Copy across scheduler behaviour flags across submit fences")
>>> Testcase: igt/gem_exec_fence/submit
>>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>> Cc: <stable@vger.kernel.org> # v5.6+
>>> ---
>>>    drivers/gpu/drm/i915/gt/intel_lrc.c         | 9 +++++++++
>>>    drivers/gpu/drm/i915/i915_request.c         | 8 ++++++--
>>>    drivers/gpu/drm/i915/i915_scheduler.c       | 6 +++---
>>>    drivers/gpu/drm/i915/i915_scheduler.h       | 3 ++-
>>>    drivers/gpu/drm/i915/i915_scheduler_types.h | 1 +
>>>    5 files changed, 21 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
>>> index dc3f2ee7136d..10109f661bcb 100644
>>> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
>>> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
>>> @@ -1880,6 +1880,9 @@ static void defer_request(struct i915_request *rq, struct list_head * const pl)
>>>                        struct i915_request *w =
>>>                                container_of(p->waiter, typeof(*w), sched);
>>>    
>>> +                     if (p->flags & I915_DEPENDENCY_WEAK)
>>> +                             continue;
>>> +
>>
>> I did not quite get it - submit fence dependency would mean different
>> engines, so the below check (w->engine != rq->engine) would effectively
>> have the same effect. What am I missing?
> 
> That submit fences can be between different contexts on the same engine.
> The example (from mesa) is where we have two interdependent clients
> which are using their own userlevel scheduling inside each batch, i.e.
> waiting on semaphores.

But if submit fence was used that means the waiter should never be 
submitted ahead of the signaler. And with this change it could get ahead 
in the priolist, no?

Regards,

Tvrtko
