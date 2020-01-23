Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D361146A08
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 14:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgAWN6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 08:58:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:17700 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgAWN6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 08:58:42 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 05:58:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,354,1574150400"; 
   d="scan'208";a="288314808"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga001.fm.intel.com with SMTP; 23 Jan 2020 05:58:39 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 23 Jan 2020 15:58:38 +0200
Date:   Thu, 23 Jan 2020 15:58:38 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gem: Detect overflow in calculating
 dumb buffer size
Message-ID: <20200123135838.GQ13686@intel.com>
References: <20200123125934.1401755-1-chris@chris-wilson.co.uk>
 <20200123132707.GK13686@intel.com>
 <157978674377.19995.13523461350756168685@skylake-alporthouse-com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157978674377.19995.13523461350756168685@skylake-alporthouse-com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 23, 2020 at 01:39:03PM +0000, Chris Wilson wrote:
> Quoting Ville Syrjälä (2020-01-23 13:27:07)
> > On Thu, Jan 23, 2020 at 12:59:34PM +0000, Chris Wilson wrote:
> > > To multiply 2 u32 numbers to generate a u64 in C requires a bit of
> > > forewarning for the compiler.
> > > 
> > > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > > Cc: Ramalingam C <ramalingam.c@intel.com>
> > > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/gpu/drm/i915/i915_gem.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> > > index 0a20083321a3..ff79da5657f8 100644
> > > --- a/drivers/gpu/drm/i915/i915_gem.c
> > > +++ b/drivers/gpu/drm/i915/i915_gem.c
> > > @@ -265,7 +265,10 @@ i915_gem_dumb_create(struct drm_file *file,
> > >                                                   DRM_FORMAT_MOD_LINEAR))
> > >               args->pitch = ALIGN(args->pitch, 4096);
> > >  
> > > -     args->size = args->pitch * args->height;
> > > +     if (args->pitch < args->width)
> > > +             return -EINVAL;
> > > +
> > > +     args->size = mul_u32_u32(args->pitch, args->height);
> > 
> > I thought something would have checked these against the mode_config
> > fb limits already. But can't see code like that anywhere. Maybe we
> > should just do that in the core?
> 
> While it is in uapi/drm_mode.h, is there any restriction that the dumb
> buffer has to be used with a framebuffer? Not that I have a good use
> case, just wondering if we need to be so proscriptive.

I think the general concensus has been that anything else is an abuse
of the interface (not that it has stopped people from doing it IIRC).

But maybe there's some good use for it that I can't think up.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> 
> We create something that is compatible but presume we will need later
> validation against HW.
> -Chris

-- 
Ville Syrjälä
Intel
