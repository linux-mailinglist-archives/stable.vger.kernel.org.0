Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27461E3AEC
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 09:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgE0HuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 03:50:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:54859 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729052AbgE0HuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 03:50:08 -0400
IronPort-SDR: +ajmWPESgsR7J+iwA07b/Z32wJoSEz+IWwV7EWG8xXkp851Oy3QirQu1c4wQfFJvheVahLWCYD
 QWldQv4rvwkQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 00:50:07 -0700
IronPort-SDR: FkbB/jBrunNjcJP/pHlZ7hGNUJ3uMGd1NY4lbhv3BmUZKHuZ4N7H+ipw/VehG+bVvajVyDEv/r
 A2M0ggI9dzKw==
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="291510381"
Received: from gkazakev-mobl1.ger.corp.intel.com (HELO [10.214.254.180]) ([10.214.254.180])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 00:50:05 -0700
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915/gt: Do not schedule normal
 requests immediately along virtual
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200526090753.11329-1-chris@chris-wilson.co.uk>
 <20200526090753.11329-2-chris@chris-wilson.co.uk>
 <2f6be936-043d-23f7-873f-6c2228f2abe5@linux.intel.com>
 <159056303478.21924.12941497462148590096@build.alporthouse.com>
 <4447522d-704e-33b1-7d8a-fef095781200@linux.intel.com>
 <159056564189.24269.17952997651487673956@build.alporthouse.com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <9061a41f-6f2c-e5e6-bd33-8d91c4e058f7@linux.intel.com>
Date:   Wed, 27 May 2020 08:50:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <159056564189.24269.17952997651487673956@build.alporthouse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/05/2020 08:47, Chris Wilson wrote:
> Quoting Tvrtko Ursulin (2020-05-27 08:32:05)
>>
>> On 27/05/2020 08:03, Chris Wilson wrote:
>>> Quoting Tvrtko Ursulin (2020-05-27 07:51:44)
>>>>
>>>> On 26/05/2020 10:07, Chris Wilson wrote:
>>>>> When we push a virtual request onto the HW, we update the rq->engine to
>>>>> point to the physical engine. A request that is then submitted by the
>>>>> user that waits upon the virtual engine, but along the physical engine
>>>>> in use, will then see that it is due to be submitted to the same engine
>>>>> and take a shortcut (and be queued without waiting for the completion
>>>>> fence). However, the virtual request may be preempted (either by higher
>>>>> priority users, or by timeslicing) and removed from the physical engine
>>>>> to be migrated over to one of its siblings. The dependent normal request
>>>>> however is oblivious to the removal of the virtual request and remains
>>>>> queued to execute on HW, believing that once it reaches the head of its
>>>>> queue all of its predecessors will have completed executing!
>>>>>
>>>>> v2: Beware restriction of signal->execution_mask prior to submission.
>>>>>
>>>>> Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
>>>>> Testcase: igt/gem_exec_balancer/sliced
>>>>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>>>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>>>> Cc: <stable@vger.kernel.org> # v5.3+
>>>>> ---
>>>>>     drivers/gpu/drm/i915/i915_request.c | 25 +++++++++++++++++++++----
>>>>>     1 file changed, 21 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
>>>>> index 33bbad623e02..0b07ccc7e9bc 100644
>>>>> --- a/drivers/gpu/drm/i915/i915_request.c
>>>>> +++ b/drivers/gpu/drm/i915/i915_request.c
>>>>> @@ -1237,6 +1237,25 @@ i915_request_await_execution(struct i915_request *rq,
>>>>>         return 0;
>>>>>     }
>>>>>     
>>>>> +static int
>>>>> +await_request_submit(struct i915_request *to, struct i915_request *from)
>>>>> +{
>>>>> +     /*
>>>>> +      * If we are waiting on a virtual engine, then it may be
>>>>> +      * constrained to execute on a single engine *prior* to submission.
>>>>> +      * When it is submitted, it will be first submitted to the virtual
>>>>> +      * engine and then passed to the physical engine. We cannot allow
>>>>> +      * the waiter to be submitted immediately to the physical engine
>>>>> +      * as it may then bypass the virtual request.
>>>>> +      */
>>>>> +     if (to->engine == READ_ONCE(from->engine))
>>>>> +             return i915_sw_fence_await_sw_fence_gfp(&to->submit,
>>>>> +                                                     &from->submit,
>>>>> +                                                     I915_FENCE_GFP);
>>>>> +     else
>>>>> +             return __i915_request_await_execution(to, from, NULL);
>>>>
>>>> If I am following correctly this branch will be the virtual <-> physical
>>>> or virtual <-> virtual dependency on the same physical engine. Why is
>>>> await_execution sufficient in this case? Is there something preventing
>>>> timeslicing between the two (not wanted right!) once from start
>>>> execution (not finishes).
>>>
>>> Timeslicing is only between independent requests. When we expire a
>>> request, we also expire all of its waiters along the same engine, so
>>> that the execution order remains intact.
>>
>> Via scheduler dependencies - they are enough?
> 
> Yes.

Okay, I really need to use this all more often rather than just review..

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko


