Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B12F737B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 12:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfKKL73 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 11 Nov 2019 06:59:29 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:57838 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726810AbfKKL73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 06:59:29 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 19158690-1500050 
        for multiple; Mon, 11 Nov 2019 11:59:26 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <e6237915-eac0-1339-12b3-bd79c567edad@linux.intel.com>
Cc:     stable@vger.kernel.org
References: <20191109105356.5273-1-chris@chris-wilson.co.uk>
 <0285daa4-eeb5-b1e1-8b4d-d7220024d429@linux.intel.com>
 <157346538997.28106.15260731624402142184@skylake-alporthouse-com>
 <e6237915-eac0-1339-12b3-bd79c567edad@linux.intel.com>
Message-ID: <157347356151.28106.4177551454597329092@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH] drm/i915/pmu: "Frequency" is reported as accumulated
 cycles
Date:   Mon, 11 Nov 2019 11:59:21 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Tvrtko Ursulin (2019-11-11 10:40:17)
> 
> On 11/11/2019 09:43, Chris Wilson wrote:
> > Quoting Tvrtko Ursulin (2019-11-11 09:11:03)
> >>
> >> On 09/11/2019 10:53, Chris Wilson wrote:
> >>> We report "frequencies" (actual-frequency, requested-frequency) as the
> >>> number of accumulated cycles so that the average frequency over that
> >>> period may be determined by the user. This means the units we report to
> >>> the user are Mcycles (or just M), not MHz.
> >>>
> >>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> >>> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> >>> Cc: stable@vger.kernel.org
> >>> ---
> >>>    drivers/gpu/drm/i915/i915_pmu.c | 4 ++--
> >>>    1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
> >>> index 4804775644bf..9b02be0ad4e6 100644
> >>> --- a/drivers/gpu/drm/i915/i915_pmu.c
> >>> +++ b/drivers/gpu/drm/i915/i915_pmu.c
> >>> @@ -908,8 +908,8 @@ create_event_attributes(struct i915_pmu *pmu)
> >>>                const char *name;
> >>>                const char *unit;
> >>>        } events[] = {
> >>> -             __event(I915_PMU_ACTUAL_FREQUENCY, "actual-frequency", "MHz"),
> >>> -             __event(I915_PMU_REQUESTED_FREQUENCY, "requested-frequency", "MHz"),
> >>> +             __event(I915_PMU_ACTUAL_FREQUENCY, "actual-frequency", "M"),
> >>> +             __event(I915_PMU_REQUESTED_FREQUENCY, "requested-frequency", "M"),
> >>>                __event(I915_PMU_INTERRUPTS, "interrupts", NULL),
> >>>                __event(I915_PMU_RC6_RESIDENCY, "rc6-residency", "ns"),
> >>>        };
> >>>
> >>
> >> MHz was wrong yes. But is 'M' established or would 'Mcycles' be better?
> > 
> > The only place where "cycles" pops up is in the perf ui, the other
> > events that I thought were similar in nature are unitless. As the
> > 'cycle' itself is not an SI base unit as it is a mere count.
> > 
> > ~o~ I have no idea ~o~
> 
> But if the argument if that 'cycle' is not SI then neither is 'M'. So I 
> think I would prefer 'Mcycles'. Nevertheless, I guess a strange 'M' is 
> better than wrong 'MHz'.

Yeah, I'm really tempted to say we should just remove the M as well but
what a waste of bits!

I think 'M' is understandable from context, whereas MHz was quite
misleading in perf stat :)

Still, if we ever get any feedback, it should be easy to fix :)
-Chris
