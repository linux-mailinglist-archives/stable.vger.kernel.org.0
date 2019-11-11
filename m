Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713DFF725C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 11:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfKKKkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 05:40:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:13996 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbfKKKkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 05:40:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 02:40:19 -0800
X-IronPort-AV: E=Sophos;i="5.68,292,1569308400"; 
   d="scan'208";a="197631034"
Received: from mpotanix-mobl2.ccr.corp.intel.com (HELO [10.252.20.183]) ([10.252.20.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 11 Nov 2019 02:40:18 -0800
Subject: Re: [Intel-gfx] [PATCH] drm/i915/pmu: "Frequency" is reported as
 accumulated cycles
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20191109105356.5273-1-chris@chris-wilson.co.uk>
 <0285daa4-eeb5-b1e1-8b4d-d7220024d429@linux.intel.com>
 <157346538997.28106.15260731624402142184@skylake-alporthouse-com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <e6237915-eac0-1339-12b3-bd79c567edad@linux.intel.com>
Date:   Mon, 11 Nov 2019 10:40:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <157346538997.28106.15260731624402142184@skylake-alporthouse-com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/11/2019 09:43, Chris Wilson wrote:
> Quoting Tvrtko Ursulin (2019-11-11 09:11:03)
>>
>> On 09/11/2019 10:53, Chris Wilson wrote:
>>> We report "frequencies" (actual-frequency, requested-frequency) as the
>>> number of accumulated cycles so that the average frequency over that
>>> period may be determined by the user. This means the units we report to
>>> the user are Mcycles (or just M), not MHz.
>>>
>>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>    drivers/gpu/drm/i915/i915_pmu.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
>>> index 4804775644bf..9b02be0ad4e6 100644
>>> --- a/drivers/gpu/drm/i915/i915_pmu.c
>>> +++ b/drivers/gpu/drm/i915/i915_pmu.c
>>> @@ -908,8 +908,8 @@ create_event_attributes(struct i915_pmu *pmu)
>>>                const char *name;
>>>                const char *unit;
>>>        } events[] = {
>>> -             __event(I915_PMU_ACTUAL_FREQUENCY, "actual-frequency", "MHz"),
>>> -             __event(I915_PMU_REQUESTED_FREQUENCY, "requested-frequency", "MHz"),
>>> +             __event(I915_PMU_ACTUAL_FREQUENCY, "actual-frequency", "M"),
>>> +             __event(I915_PMU_REQUESTED_FREQUENCY, "requested-frequency", "M"),
>>>                __event(I915_PMU_INTERRUPTS, "interrupts", NULL),
>>>                __event(I915_PMU_RC6_RESIDENCY, "rc6-residency", "ns"),
>>>        };
>>>
>>
>> MHz was wrong yes. But is 'M' established or would 'Mcycles' be better?
> 
> The only place where "cycles" pops up is in the perf ui, the other
> events that I thought were similar in nature are unitless. As the
> 'cycle' itself is not an SI base unit as it is a mere count.
> 
> ~o~ I have no idea ~o~

But if the argument if that 'cycle' is not SI then neither is 'M'. So I 
think I would prefer 'Mcycles'. Nevertheless, I guess a strange 'M' is 
better than wrong 'MHz'.

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
