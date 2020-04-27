Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6D51BAB69
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 19:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgD0RgR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 27 Apr 2020 13:36:17 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:49389 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726217AbgD0RgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 13:36:17 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 21038314-1500050 
        for multiple; Mon, 27 Apr 2020 18:36:13 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <875zdkltxv.fsf@gaia.fi.intel.com>
References: <20200427170513.24019-1-chris@chris-wilson.co.uk> <875zdkltxv.fsf@gaia.fi.intel.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915/execlists: Avoid reusing the same logical CC_ID
To:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Message-ID: <158800897227.17035.17598656242212150710@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Mon, 27 Apr 2020 18:36:12 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Mika Kuoppala (2020-04-27 18:28:12)
> Chris Wilson <chris@chris-wilson.co.uk> writes:
> 
> > Fixes: 2935ed5339c4 ("drm/i915: Remove logical HW ID")
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> > Cc: <stable@vger.kernel.org> # v5.5+
> > ---
> >  drivers/gpu/drm/i915/gt/intel_engine_types.h |  3 +--
> >  drivers/gpu/drm/i915/gt/intel_lrc.c          | 23 ++++++++++++++------
> >  drivers/gpu/drm/i915/i915_perf.c             |  3 +--
> >  drivers/gpu/drm/i915/selftests/i915_vma.c    |  2 +-
> >  4 files changed, 19 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
> > index bf395227c99f..a9fc3fbbe482 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
> > +++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
> > @@ -304,8 +304,7 @@ struct intel_engine_cs {
> >       u32 context_size;
> >       u32 mmio_base;
> >  
> > -     unsigned int context_tag;
> > -#define NUM_CONTEXT_TAG roundup_pow_of_two(2 * EXECLIST_MAX_PORTS)
> > +     unsigned long context_tag;
> >  
> >       struct rb_node uabi_node;
> >  
> > diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> > index 93a1b73ad96b..d68a04f2a9d5 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> > @@ -1404,13 +1404,16 @@ __execlists_schedule_in(struct i915_request *rq)
> >       ce->lrc_desc &= ~GENMASK_ULL(47, 37);
> >       if (ce->tag) {
> >               /* Use a fixed tag for OA and friends */
> > +             GEM_BUG_ON(ce->tag <= BITS_PER_TYPE(engine->context_tag));
> >               ce->lrc_desc |= (u64)ce->tag << 32;
> 
> I see danger here to completely trash the upper part our our lrc_desc.
> Is the ce->tag validated or should we add more enforcement in here?

It's a single special case atm.

It's a problem for tomorrow, but it'll probably mean a small ida if we
have multiple users who must dictate the CCID. Pita.

> 
> >       } else {
> >               /* We don't need a strict matching tag, just different values */
> > -             ce->lrc_desc |=
> > -                     (u64)(++engine->context_tag % NUM_CONTEXT_TAG) <<
> > -                     GEN11_SW_CTX_ID_SHIFT;
> > -             BUILD_BUG_ON(NUM_CONTEXT_TAG > GEN12_MAX_CONTEXT_HW_ID);
> > +             unsigned int tag = ffs(engine->context_tag);
> > +
> > +             clear_bit(tag - 1, &engine->context_tag);
> > +             ce->lrc_desc |= (u64)tag << GEN11_SW_CTX_ID_SHIFT;
> > +
> > +             BUILD_BUG_ON(BITS_PER_TYPE(engine->context_tag) > GEN12_MAX_CONTEXT_HW_ID);
> >       }
> >  
> >       __intel_gt_pm_get(engine->gt);
> > @@ -1452,7 +1455,8 @@ static void kick_siblings(struct i915_request *rq, struct intel_context *ce)
> >  
> >  static inline void
> >  __execlists_schedule_out(struct i915_request *rq,
> > -                      struct intel_engine_cs * const engine)
> > +                      struct intel_engine_cs * const engine,
> > +                      int tag)
> >  {
> >       struct intel_context * const ce = rq->context;
> >  
> > @@ -1470,6 +1474,9 @@ __execlists_schedule_out(struct i915_request *rq,
> >           i915_request_completed(rq))
> >               intel_engine_add_retire(engine, ce->timeline);
> >  
> > +     if (tag <= BITS_PER_TYPE(engine->context_tag))
> > +             set_bit(tag - 1, &engine->context_tag);
> > +
> >       intel_context_update_runtime(ce);
> >       intel_engine_context_out(engine);
> >       execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_OUT);
> > @@ -1495,15 +1502,17 @@ execlists_schedule_out(struct i915_request *rq)
> >  {
> >       struct intel_context * const ce = rq->context;
> >       struct intel_engine_cs *cur, *old;
> > +     int tag;
> >  
> >       trace_i915_request_out(rq);
> >  
> > +     tag = upper_32_bits(rq->context->lrc_desc);
> 
> There is more in the upper part than just a tag (sw field).
> So we need to only set/get a particular masked field.

We control the contents, though. Oops, but what I did forget was the
shift.
-Chris
