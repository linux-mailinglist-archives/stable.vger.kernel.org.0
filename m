Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E412784DF
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 12:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgIYKSD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 25 Sep 2020 06:18:03 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:58840 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727521AbgIYKSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 06:18:03 -0400
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2020 06:18:01 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22533058-1500050 
        for multiple; Fri, 25 Sep 2020 11:01:38 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <6be94225-9d54-0a4b-d1d0-d5b46d8b6fdb@linux.intel.com>
References: <20200916094219.3878-1-chris@chris-wilson.co.uk> <20200916094219.3878-3-chris@chris-wilson.co.uk> <6be94225-9d54-0a4b-d1d0-d5b46d8b6fdb@linux.intel.com>
Subject: Re: [Intel-gfx] [PATCH 3/4] drm/i915/gt: Always send a pulse down the engine after disabling heartbeat
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
To:     Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Fri, 25 Sep 2020 11:01:38 +0100
Message-ID: <160102809807.30248.12041152856672975142@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Tvrtko Ursulin (2020-09-24 14:43:08)
> 
> On 16/09/2020 10:42, Chris Wilson wrote:
> > Currently, we check we can send a pulse prior to disabling the
> > heartbeat to verify that we can change the heartbeat, but since we may
> > re-evaluate execution upon changing the heartbeat interval we need another
> > pulse afterwards to refresh execution.
> > 
> > Fixes: 9a40bddd47ca ("drm/i915/gt: Expose heartbeat interval via sysfs")
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > Cc: <stable@vger.kernel.org> # v5.7+
> > ---
> >   drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c b/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
> > index 8ffdf676c0a0..d09df370f7cd 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_engine_heartbeat.c
> > @@ -192,10 +192,12 @@ int intel_engine_set_heartbeat(struct intel_engine_cs *engine,
> >       WRITE_ONCE(engine->props.heartbeat_interval_ms, delay);
> >   
> >       if (intel_engine_pm_get_if_awake(engine)) {
> > -             if (delay)
> > +             if (delay) {
> >                       intel_engine_unpark_heartbeat(engine);
> > -             else
> > +             } else {
> >                       intel_engine_park_heartbeat(engine);
> > +                     intel_engine_pulse(engine); /* recheck execution */
> > +             }
> >               intel_engine_pm_put(engine);
> >       }
> >   
> > 
> 
> I did not immediately get this one. Do we really need two pulses or 
> maybe we could re-order the code a bit and just undo the heartbeat park 
> if pulse after parking did not work?

We use the first pulse to determine if it's legal for the parameter to
be changed (checking we support the preemptive pulse to remove
non-persistent contexts). Then the second pulse after changing the
parameter to flush the changes through.

I like checking for support before making the change, although we could
try and fixup after failure, there would still be a window where the
change would be visible to the system. We don't need to use the pulse per
se for that check, that's pure convenience as it performs the checking
already.
-Chris
