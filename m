Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EDE2784F2
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 12:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgIYKVZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 25 Sep 2020 06:21:25 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:58953 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727521AbgIYKVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 06:21:25 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22533138-1500050 
        for multiple; Fri, 25 Sep 2020 11:05:07 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <e665fc1d-1b9d-a6ee-1798-df32d1296118@linux.intel.com>
References: <20200916094219.3878-1-chris@chris-wilson.co.uk> <20200916094219.3878-4-chris@chris-wilson.co.uk> <e665fc1d-1b9d-a6ee-1798-df32d1296118@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH 4/4] drm/i915/gem: Always test execution status on closing the context
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Fri, 25 Sep 2020 11:05:06 +0100
Message-ID: <160102830667.30248.7803662790481339170@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Tvrtko Ursulin (2020-09-24 15:26:56)
> 
> On 16/09/2020 10:42, Chris Wilson wrote:
> > Verify that if a context is active at the time it is closed, that it is
> > either persistent and preemptible (with hangcheck running) or it shall
> > be removed from execution.
> > 
> > Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
> > Testcase: igt/gem_ctx_persistence/heartbeat-close
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > Cc: <stable@vger.kernel.org> # v5.7+
> > ---
> >   drivers/gpu/drm/i915/gem/i915_gem_context.c | 48 +++++----------------
> >   1 file changed, 10 insertions(+), 38 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
> > index a548626fa8bc..4fd38101bb56 100644
> > --- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
> > +++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
> > @@ -390,24 +390,6 @@ __context_engines_static(const struct i915_gem_context *ctx)
> >       return rcu_dereference_protected(ctx->engines, true);
> >   }
> >   
> > -static bool __reset_engine(struct intel_engine_cs *engine)
> > -{
> > -     struct intel_gt *gt = engine->gt;
> > -     bool success = false;
> > -
> > -     if (!intel_has_reset_engine(gt))
> > -             return false;
> > -
> > -     if (!test_and_set_bit(I915_RESET_ENGINE + engine->id,
> > -                           &gt->reset.flags)) {
> > -             success = intel_engine_reset(engine, NULL) == 0;
> > -             clear_and_wake_up_bit(I915_RESET_ENGINE + engine->id,
> > -                                   &gt->reset.flags);
> > -     }
> > -
> > -     return success;
> > -}
> > -
> >   static void __reset_context(struct i915_gem_context *ctx,
> >                           struct intel_engine_cs *engine)
> >   {
> > @@ -431,12 +413,7 @@ static bool __cancel_engine(struct intel_engine_cs *engine)
> >        * kill the banned context, we fallback to doing a local reset
> >        * instead.
> >        */
> > -     if (IS_ACTIVE(CONFIG_DRM_I915_PREEMPT_TIMEOUT) &&
> > -         !intel_engine_pulse(engine))
> > -             return true;
> > -
> > -     /* If we are unable to send a pulse, try resetting this engine. */
> > -     return __reset_engine(engine);
> > +     return intel_engine_pulse(engine) == 0;
> 
> Where is the path now which actually resets the currently running 
> workload (engine) of a non-persistent context? Pulse will be sent and 
> then rely on hangcheck but otherwise let it run?

If the pulse fails, we just call intel_handle_error() on the engine. On
looking at this code again, I could not justify the open-coding of the
engine reset fragment of the general error handler, especially as we end
up taking that route anyway for device resets. (Unlike inside the
tasklet, there's no atomicity concerns on this engine-reset path.)
-Chris
