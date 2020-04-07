Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0611A16CF
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 22:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgDGU3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 16:29:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43434 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGU3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 16:29:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id s4so2253060pgk.10
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 13:28:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=52dfhTEprLZ4VO9vJr5iE7T2tAl7/ERfzBJa/Kmr6dQ=;
        b=f3sDIQNrS/CoL831bodR8SkvTjsjiowkDTLHqcCdx318N0GgfdBXXpKMbMSQYEIzJ5
         xL2HI32lYSucvcgRj6474LfhQPiJG/EVk/GHJgX8Cdxkcggf5+32uOaFWXBkRLczyZaV
         9qi89nCnhEsijOpfnONikEiSZ+jJyRCy8Pv1Jn14V8A9bxu8WwzB42qEDkMTNLhFN1Bw
         RXtXz1SXJR3yekq5mGHOBg28GhyjvPj5StucmVthtKTFC5xb/qhbGQWik9Lg15tqETsL
         F/dxNytRDcFbsHXNrfzBRqWbmRG5zcxAuq+U0fgZruKNWpsIwedL1ImQFq/ZUAkAkMtc
         vUaw==
X-Gm-Message-State: AGi0PuaB8/wBznr81rd+yYKeSbezgUjPy7ov26o45I9cDxB9LlfZR2aw
        OYqCENYcaKGc69mdJlO7jnA=
X-Google-Smtp-Source: APiQypIUR2i/To/r3pVyhsdpz/N3kKqYA5FbZH4teCH/jWt2PEz6UdW/tWyBikH4cWn/QZBP0QeRHg==
X-Received: by 2002:a63:5716:: with SMTP id l22mr3757051pgb.164.1586291339448;
        Tue, 07 Apr 2020 13:28:59 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id z6sm2325591pjt.42.2020.04.07.13.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 13:28:58 -0700 (PDT)
Date:   Tue, 7 Apr 2020 13:28:56 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: Re: [PATCH 2/2] drm/i915/gt: Schedule request retirement when
 timeline idles
Message-ID: <20200407202856.GA2026@sultan-box.localdomain>
References: <20200330033057.2629052-1-sultan@kerneltoast.com>
 <20200330033057.2629052-3-sultan@kerneltoast.com>
 <158558564835.3228.8789679707542626662@build.alporthouse.com>
 <20200330163514.GA4184@sultan-box.localdomain>
 <158558672536.3228.14244416875154195837@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158558672536.3228.14244416875154195837@build.alporthouse.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 05:45:25PM +0100, Chris Wilson wrote:
> Quoting Sultan Alsawaf (2020-03-30 17:35:14)
> > On Mon, Mar 30, 2020 at 05:27:28PM +0100, Chris Wilson wrote:
> > > Quoting Sultan Alsawaf (2020-03-30 04:30:57)
> > > > +static void engine_retire(struct work_struct *work)
> > > > +{
> > > > +       struct intel_engine_cs *engine =
> > > > +               container_of(work, typeof(*engine), retire_work);
> > > > +       struct intel_timeline *tl = xchg(&engine->retire, NULL);
> > > > +
> > > > +       do {
> > > > +               struct intel_timeline *next = xchg(&tl->retire, NULL);
> > > > +
> > > > +               /*
> > > > +                * Our goal here is to retire _idle_ timelines as soon as
> > > > +                * possible (as they are idle, we do not expect userspace
> > > > +                * to be cleaning up anytime soon).
> > > > +                *
> > > > +                * If the timeline is currently locked, either it is being
> > > > +                * retired elsewhere or about to be!
> > > > +                */
> > > 
> > > iirc the backport requires the retirement to be wrapped in struct_mutex
> > > 
> > > mutex_lock(&engine->i915->drm.struct_mutex);
> > > 
> > > > +               if (mutex_trylock(&tl->mutex)) {
> > > > +                       retire_requests(tl);
> > > > +                       mutex_unlock(&tl->mutex);
> > > > +               }
> > > 
> > > mutex_unlock(&engine->i915->drm.struct_mutex);
> > > 
> > > Now the question is whether that was for 5.3 or 5.4. I think 5.3 is
> > > where the changes were more severe and where we switch to the 4.19
> > > approach.
> > > 
> > > > +               intel_timeline_put(tl);
> > > > +
> > > > +               GEM_BUG_ON(!next);
> > > > +               tl = ptr_mask_bits(next, 1);
> > > > +       } while (tl);
> > > > +}
> > 
> > In 5.4, the existing retirement instances don't hold
> > `&engine->i915->drm.struct_mutex`, however it is held in 5.3. So it looks like
> > this is fine as-is for 5.4.
> 
> git agrees.
> 
> commit e5dadff4b09376e8ed92ecc0c12f1b9b3b1fbd19
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Thu Aug 15 21:57:09 2019 +0100
> 
>     drm/i915: Protect request retirement with timeline->mutex
> 
> is in v5.4, so we should be safe to retire without the struct_mutex.
> -Chris

No, you were right; `&engine->i915->drm.struct_mutex` needs to be held in 5.4,
otherwise retirement races with vma destruction. I'll send an updated patch.

Sultan
