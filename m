Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB20614694C
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 14:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgAWNjJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 23 Jan 2020 08:39:09 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:59617 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726792AbgAWNjI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 08:39:08 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 19982861-1500050 
        for multiple; Thu, 23 Jan 2020 13:39:06 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     =?utf-8?b?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20200123132707.GK13686@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
References: <20200123125934.1401755-1-chris@chris-wilson.co.uk>
 <20200123132707.GK13686@intel.com>
Message-ID: <157978674377.19995.13523461350756168685@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gem: Detect overflow in calculating dumb
 buffer size
Date:   Thu, 23 Jan 2020 13:39:03 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Ville Syrjälä (2020-01-23 13:27:07)
> On Thu, Jan 23, 2020 at 12:59:34PM +0000, Chris Wilson wrote:
> > To multiply 2 u32 numbers to generate a u64 in C requires a bit of
> > forewarning for the compiler.
> > 
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Ramalingam C <ramalingam.c@intel.com>
> > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/i915/i915_gem.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> > index 0a20083321a3..ff79da5657f8 100644
> > --- a/drivers/gpu/drm/i915/i915_gem.c
> > +++ b/drivers/gpu/drm/i915/i915_gem.c
> > @@ -265,7 +265,10 @@ i915_gem_dumb_create(struct drm_file *file,
> >                                                   DRM_FORMAT_MOD_LINEAR))
> >               args->pitch = ALIGN(args->pitch, 4096);
> >  
> > -     args->size = args->pitch * args->height;
> > +     if (args->pitch < args->width)
> > +             return -EINVAL;
> > +
> > +     args->size = mul_u32_u32(args->pitch, args->height);
> 
> I thought something would have checked these against the mode_config
> fb limits already. But can't see code like that anywhere. Maybe we
> should just do that in the core?

While it is in uapi/drm_mode.h, is there any restriction that the dumb
buffer has to be used with a framebuffer? Not that I have a good use
case, just wondering if we need to be so proscriptive.

We create something that is compatible but presume we will need later
validation against HW.
-Chris
