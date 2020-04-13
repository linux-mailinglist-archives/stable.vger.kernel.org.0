Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6277E1A683E
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 16:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgDMOhe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 10:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbgDMOhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 10:37:33 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BECC0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 07:37:31 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id d17so3459269wrg.11
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 07:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KWq2JBD+oglExwAHX9Kz6zHQQS5n3gajUHOgSRJZ2R0=;
        b=JUycSQzxhSXq+tiVr8mBWBMCxROrBqp4tqb9XiuKp4R9mR3ECLn9nKwhycMzkElttt
         pjG/VMGPpERcq2ZaGjmWIrFirOuG2SuDnSX/xYeOeQJuAHpY5aJnGcMrKK57qk5roQgb
         MKIHHcSItH3r8fIS/8LQe1HFDGl74jDFDqUs/j5pNg3TeX92vwihQJ4QMuMAqDPZody5
         QMxh109GVZdknPjJBbX7/1Jcx/p0IE3b9J2NVDOl9Z1NVXgY+dBpXAZGQ6fQCnUkXezW
         FCffGPatphP21QMlQJkdqtFBzUgMSe8d4HGH4Uw7q2QMKxPrIwgm1bw4WuWYDlNJzKvm
         11yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=KWq2JBD+oglExwAHX9Kz6zHQQS5n3gajUHOgSRJZ2R0=;
        b=RLQjy6+/Gwu+pVNX+QQCJzhm9xOVOtpUeYj7sfWlByQfy9/a1Zdto1mxrtMJ8QnLap
         +JiLV3eMWquAm71AnPACOtCSBfpSBJ+/uArIhVodIIS+lzSoK6+FkbY7rjdGVI8Bw7GA
         sAXDEhoyLngk167L9qIJpLPq4q+Q0EjszSiDXHbnzxzNTCW+DqViPcgeZlCaXtA6H5iw
         2n2woymoz4OOXTYE2blaxXukrpigYgHBRJ83I1gRGMy2Xa1yGLT/H+vADJp87Qxu+/p5
         06MEAg9O5PW3xd/IR7UZpy6sgSImaTBfc55ufzk+iOCaxnnPZ0rQP0lYqKKPWJeW85cm
         DZYw==
X-Gm-Message-State: AGi0PuZgyqMJyKqhDAoJc9lH9ZRoNSUwjXPUckBKdlnqmCjicrdP0exe
        1NlTs+Vwwp7UL1KdGKAz6Zg2b8woEgE=
X-Google-Smtp-Source: APiQypJXhDZEySu9ek6tfbW5dzVCMNNX0DyH9w7v2A+VXhDV8cr6YIf1e3x+zn96sXZVAZ08/+cXCA==
X-Received: by 2002:adf:df01:: with SMTP id y1mr18804345wrl.401.1586788649766;
        Mon, 13 Apr 2020 07:37:29 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id x18sm14373600wmi.29.2020.04.13.07.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 07:37:29 -0700 (PDT)
Date:   Mon, 13 Apr 2020 16:37:28 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] drm/i915/gt: Schedule request retirement when
 timeline idles
Message-ID: <20200413143728.GA709872@eldamar.local>
References: <20200407202856.GA2026@sultan-box.localdomain>
 <20200407204345.3498-1-sultan@kerneltoast.com>
 <20200412074851.GA2703@sultan-book.localdomain>
 <20200412075607.GA2709076@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200412075607.GA2709076@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[note not involved in the respective patch, but noticed your question
and saw the context]

On Sun, Apr 12, 2020 at 09:56:07AM +0200, Greg KH wrote:
> On Sun, Apr 12, 2020 at 12:48:51AM -0700, Sultan Alsawaf wrote:
> > On Tue, Apr 07, 2020 at 01:43:45PM -0700, Sultan Alsawaf wrote:
> > > From: Chris Wilson <chris@chris-wilson.co.uk>
> > > 
> > > The major drawback of commit 7e34f4e4aad3 ("drm/i915/gen8+: Add RC6 CTX
> > > corruption WA") is that it disables RC6 while Skylake (and friends) is
> > > active, and we do not consider the GPU idle until all outstanding
> > > requests have been retired and the engine switched over to the kernel
> > > context. If userspace is idle, this task falls onto our background idle
> > > worker, which only runs roughly once a second, meaning that userspace has
> > > to have been idle for a couple of seconds before we enable RC6 again.
> > > Naturally, this causes us to consume considerably more energy than
> > > before as powersaving is effectively disabled while a display server
> > > (here's looking at you Xorg) is running.
> > > 
> > > As execlists will get a completion event as each context is completed,
> > > we can use this interrupt to queue a retire worker bound to this engine
> > > to cleanup idle timelines. We will then immediately notice the idle
> > > engine (without userspace intervention or the aid of the background
> > > retire worker) and start parking the GPU. Thus during light workloads,
> > > we will do much more work to idle the GPU faster...  Hopefully with
> > > commensurate power saving!
> > > 
> > > v2: Watch context completions and only look at those local to the engine
> > > when retiring to reduce the amount of excess work we perform.
> > > 
> > > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=112315
> > > References: 7e34f4e4aad3 ("drm/i915/gen8+: Add RC6 CTX corruption WA")
> > > References: 2248a28384fe ("drm/i915/gen8+: Add RC6 CTX corruption WA")
> > > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> > > Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> > > Link: https://patchwork.freedesktop.org/patch/msgid/20191125105858.1718307-3-chris@chris-wilson.co.uk
> > > (cherry picked from commit 4f88f8747fa43c97c3b3712d8d87295ea757cc51)
> > > 
> > > For the backport to 5.4, struct_mutex needs to be held while retiring so
> > > that retirement doesn't race with vma destruction.
> > > Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
> > > ---
> > >  drivers/gpu/drm/i915/gt/intel_engine_cs.c     |  2 +
> > >  drivers/gpu/drm/i915/gt/intel_engine_types.h  |  8 ++
> > >  drivers/gpu/drm/i915/gt/intel_lrc.c           |  8 ++
> > >  drivers/gpu/drm/i915/gt/intel_timeline.c      |  1 +
> > >  .../gpu/drm/i915/gt/intel_timeline_types.h    |  3 +
> > >  drivers/gpu/drm/i915/i915_request.c           | 75 +++++++++++++++++++
> > >  drivers/gpu/drm/i915/i915_request.h           |  4 +
> > >  7 files changed, 101 insertions(+)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/gt/intel_engine_cs.c b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> > > index 4ce8626b140e..f732a2177cd0 100644
> > > --- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> > > +++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
> > > @@ -600,6 +600,7 @@ static int intel_engine_setup_common(struct intel_engine_cs *engine)
> > >  	intel_engine_init_hangcheck(engine);
> > >  	intel_engine_init_cmd_parser(engine);
> > >  	intel_engine_init__pm(engine);
> > > +	intel_engine_init_retire(engine);
> > >  
> > >  	intel_engine_pool_init(&engine->pool);
> > >  
> > > @@ -807,6 +808,7 @@ void intel_engine_cleanup_common(struct intel_engine_cs *engine)
> > >  
> > >  	cleanup_status_page(engine);
> > >  
> > > +	intel_engine_fini_retire(engine);
> > >  	intel_engine_pool_fini(&engine->pool);
> > >  	intel_engine_fini_breadcrumbs(engine);
> > >  	intel_engine_cleanup_cmd_parser(engine);
> > > diff --git a/drivers/gpu/drm/i915/gt/intel_engine_types.h b/drivers/gpu/drm/i915/gt/intel_engine_types.h
> > > index c77c9518c58b..1eb7189f88e1 100644
> > > --- a/drivers/gpu/drm/i915/gt/intel_engine_types.h
> > > +++ b/drivers/gpu/drm/i915/gt/intel_engine_types.h
> > > @@ -471,6 +471,14 @@ struct intel_engine_cs {
> > >  
> > >  	struct intel_engine_execlists execlists;
> > >  
> > > +	/*
> > > +	 * Keep track of completed timelines on this engine for early
> > > +	 * retirement with the goal of quickly enabling powersaving as
> > > +	 * soon as the engine is idle.
> > > +	 */
> > > +	struct intel_timeline *retire;
> > > +	struct work_struct retire_work;
> > > +
> > >  	/* status_notifier: list of callbacks for context-switch changes */
> > >  	struct atomic_notifier_head context_status_notifier;
> > >  
> > > diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> > > index 66f6d1a897f2..a1538c8f7922 100644
> > > --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> > > +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> > > @@ -606,6 +606,14 @@ __execlists_schedule_out(struct i915_request *rq,
> > >  {
> > >  	struct intel_context * const ce = rq->hw_context;
> > >  
> > > +	/*
> > > +	 * If we have just completed this context, the engine may now be
> > > +	 * idle and we want to re-enter powersaving.
> > > +	 */
> > > +	if (list_is_last(&rq->link, &ce->timeline->requests) &&
> > > +	    i915_request_completed(rq))
> > > +		intel_engine_add_retire(engine, ce->timeline);
> > > +
> > >  	intel_engine_context_out(engine);
> > >  	execlists_context_status_change(rq, INTEL_CONTEXT_SCHEDULE_OUT);
> > >  	intel_gt_pm_put(engine->gt);
> > > diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
> > > index 9cb01d9828f1..63515e3caaf2 100644
> > > --- a/drivers/gpu/drm/i915/gt/intel_timeline.c
> > > +++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
> > > @@ -282,6 +282,7 @@ void intel_timeline_fini(struct intel_timeline *timeline)
> > >  {
> > >  	GEM_BUG_ON(atomic_read(&timeline->pin_count));
> > >  	GEM_BUG_ON(!list_empty(&timeline->requests));
> > > +	GEM_BUG_ON(timeline->retire);
> > >  
> > >  	if (timeline->hwsp_cacheline)
> > >  		cacheline_free(timeline->hwsp_cacheline);
> > > diff --git a/drivers/gpu/drm/i915/gt/intel_timeline_types.h b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
> > > index 2b1baf2fcc8e..adf2d14ef647 100644
> > > --- a/drivers/gpu/drm/i915/gt/intel_timeline_types.h
> > > +++ b/drivers/gpu/drm/i915/gt/intel_timeline_types.h
> > > @@ -65,6 +65,9 @@ struct intel_timeline {
> > >  	 */
> > >  	struct i915_active_request last_request;
> > >  
> > > +	/** A chain of completed timelines ready for early retirement. */
> > > +	struct intel_timeline *retire;
> > > +
> > >  	/**
> > >  	 * We track the most recent seqno that we wait on in every context so
> > >  	 * that we only have to emit a new await and dependency on a more
> > > diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> > > index 0d39038898d4..35457fda350c 100644
> > > --- a/drivers/gpu/drm/i915/i915_request.c
> > > +++ b/drivers/gpu/drm/i915/i915_request.c
> > > @@ -600,6 +600,81 @@ static void retire_requests(struct intel_timeline *tl)
> > >  			break;
> > >  }
> > >  
> > > +static void engine_retire(struct work_struct *work)
> > > +{
> > > +	struct intel_engine_cs *engine =
> > > +		container_of(work, typeof(*engine), retire_work);
> > > +	struct intel_timeline *tl = xchg(&engine->retire, NULL);
> > > +
> > > +	do {
> > > +		struct intel_timeline *next = xchg(&tl->retire, NULL);
> > > +
> > > +		/*
> > > +		 * Our goal here is to retire _idle_ timelines as soon as
> > > +		 * possible (as they are idle, we do not expect userspace
> > > +		 * to be cleaning up anytime soon).
> > > +		 *
> > > +		 * If the timeline is currently locked, either it is being
> > > +		 * retired elsewhere or about to be!
> > > +		 */
> > > +		mutex_lock(&engine->i915->drm.struct_mutex);
> > > +		if (mutex_trylock(&tl->mutex)) {
> > > +			retire_requests(tl);
> > > +			mutex_unlock(&tl->mutex);
> > > +		}
> > > +		mutex_unlock(&engine->i915->drm.struct_mutex);
> > > +		intel_timeline_put(tl);
> > > +
> > > +		GEM_BUG_ON(!next);
> > > +		tl = ptr_mask_bits(next, 1);
> > > +	} while (tl);
> > > +}
> > > +
> > > +static bool add_retire(struct intel_engine_cs *engine,
> > > +		       struct intel_timeline *tl)
> > > +{
> > > +	struct intel_timeline *first;
> > > +
> > > +	/*
> > > +	 * We open-code a llist here to include the additional tag [BIT(0)]
> > > +	 * so that we know when the timeline is already on a
> > > +	 * retirement queue: either this engine or another.
> > > +	 *
> > > +	 * However, we rely on that a timeline can only be active on a single
> > > +	 * engine at any one time and that add_retire() is called before the
> > > +	 * engine releases the timeline and transferred to another to retire.
> > > +	 */
> > > +
> > > +	if (READ_ONCE(tl->retire)) /* already queued */
> > > +		return false;
> > > +
> > > +	intel_timeline_get(tl);
> > > +	first = READ_ONCE(engine->retire);
> > > +	do
> > > +		tl->retire = ptr_pack_bits(first, 1, 1);
> > > +	while (!try_cmpxchg(&engine->retire, &first, tl));
> > > +
> > > +	return !first;
> > > +}
> > > +
> > > +void intel_engine_add_retire(struct intel_engine_cs *engine,
> > > +			     struct intel_timeline *tl)
> > > +{
> > > +	if (add_retire(engine, tl))
> > > +		schedule_work(&engine->retire_work);
> > > +}
> > > +
> > > +void intel_engine_init_retire(struct intel_engine_cs *engine)
> > > +{
> > > +	INIT_WORK(&engine->retire_work, engine_retire);
> > > +}
> > > +
> > > +void intel_engine_fini_retire(struct intel_engine_cs *engine)
> > > +{
> > > +	flush_work(&engine->retire_work);
> > > +	GEM_BUG_ON(engine->retire);
> > > +}
> > > +
> > >  static noinline struct i915_request *
> > >  request_alloc_slow(struct intel_timeline *tl, gfp_t gfp)
> > >  {
> > > diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
> > > index 3a3e7bbf19ff..40caa2f3f4a4 100644
> > > --- a/drivers/gpu/drm/i915/i915_request.h
> > > +++ b/drivers/gpu/drm/i915/i915_request.h
> > > @@ -445,5 +445,9 @@ static inline bool i915_request_has_nopreempt(const struct i915_request *rq)
> > >  }
> > >  
> > >  bool i915_retire_requests(struct drm_i915_private *i915);
> > > +void intel_engine_init_retire(struct intel_engine_cs *engine);
> > > +void intel_engine_add_retire(struct intel_engine_cs *engine,
> > > +			     struct intel_timeline *tl);
> > > +void intel_engine_fini_retire(struct intel_engine_cs *engine);
> > >  
> > >  #endif /* I915_REQUEST_H */
> > > -- 
> > > 2.26.0
> > > 
> > 
> > Hi Greg,
> > 
> > Could you queue this one up as well?
> 
> What is the git commit id of this in Linus's tree?

This appears to be 4f88f8747fa43c97c3b3712d8d87295ea757cc51 upstream,
but there is as well this comment added:

> For the backport to 5.4, struct_mutex needs to be held while retiring so
> that retirement doesn't race with vma destruction.
> Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>

Regards,
Salvatore
