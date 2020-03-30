Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7D0198193
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 18:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgC3Qpz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 Mar 2020 12:45:55 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:49443 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726085AbgC3Qpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 12:45:55 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 20742839-1500050 
        for multiple; Mon, 30 Mar 2020 17:45:27 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200330163514.GA4184@sultan-box.localdomain>
References: <20200330033057.2629052-1-sultan@kerneltoast.com> <20200330033057.2629052-3-sultan@kerneltoast.com> <158558564835.3228.8789679707542626662@build.alporthouse.com> <20200330163514.GA4184@sultan-box.localdomain>
Cc:     stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To:     Sultan Alsawaf <sultan@kerneltoast.com>
Subject: Re: [PATCH 2/2] drm/i915/gt: Schedule request retirement when timeline idles
From:   Chris Wilson <chris@chris-wilson.co.uk>
Message-ID: <158558672536.3228.14244416875154195837@build.alporthouse.com>
User-Agent: alot/0.8.1
Date:   Mon, 30 Mar 2020 17:45:25 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Sultan Alsawaf (2020-03-30 17:35:14)
> On Mon, Mar 30, 2020 at 05:27:28PM +0100, Chris Wilson wrote:
> > Quoting Sultan Alsawaf (2020-03-30 04:30:57)
> > > +static void engine_retire(struct work_struct *work)
> > > +{
> > > +       struct intel_engine_cs *engine =
> > > +               container_of(work, typeof(*engine), retire_work);
> > > +       struct intel_timeline *tl = xchg(&engine->retire, NULL);
> > > +
> > > +       do {
> > > +               struct intel_timeline *next = xchg(&tl->retire, NULL);
> > > +
> > > +               /*
> > > +                * Our goal here is to retire _idle_ timelines as soon as
> > > +                * possible (as they are idle, we do not expect userspace
> > > +                * to be cleaning up anytime soon).
> > > +                *
> > > +                * If the timeline is currently locked, either it is being
> > > +                * retired elsewhere or about to be!
> > > +                */
> > 
> > iirc the backport requires the retirement to be wrapped in struct_mutex
> > 
> > mutex_lock(&engine->i915->drm.struct_mutex);
> > 
> > > +               if (mutex_trylock(&tl->mutex)) {
> > > +                       retire_requests(tl);
> > > +                       mutex_unlock(&tl->mutex);
> > > +               }
> > 
> > mutex_unlock(&engine->i915->drm.struct_mutex);
> > 
> > Now the question is whether that was for 5.3 or 5.4. I think 5.3 is
> > where the changes were more severe and where we switch to the 4.19
> > approach.
> > 
> > > +               intel_timeline_put(tl);
> > > +
> > > +               GEM_BUG_ON(!next);
> > > +               tl = ptr_mask_bits(next, 1);
> > > +       } while (tl);
> > > +}
> 
> In 5.4, the existing retirement instances don't hold
> `&engine->i915->drm.struct_mutex`, however it is held in 5.3. So it looks like
> this is fine as-is for 5.4.

git agrees.

commit e5dadff4b09376e8ed92ecc0c12f1b9b3b1fbd19
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Aug 15 21:57:09 2019 +0100

    drm/i915: Protect request retirement with timeline->mutex

is in v5.4, so we should be safe to retire without the struct_mutex.
-Chris
