Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D571AE4BC
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 20:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgDQS2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 14:28:39 -0400
Received: from mga06.intel.com ([134.134.136.31]:28878 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgDQS2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 14:28:38 -0400
IronPort-SDR: mS+ervBbGEXc4GzNqGes3J0xOVrYGuWu6BhqlJxb5RWWRGWuwxXqv2J1ULqIVVI9/OBFFhkplT
 XJP3jO+px7WA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:28:38 -0700
IronPort-SDR: V9FV1aztj3YODmKpHxiQG+8utpy9tAVRywC/JHnthL/wcvoiaOSryR5C+MH4l6QITld3joGzUx
 BxTPKP26LMlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="244777861"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga007.fm.intel.com with SMTP; 17 Apr 2020 11:28:35 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 17 Apr 2020 21:28:34 +0300
Date:   Fri, 17 Apr 2020 21:28:34 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] drm: Fix page flip ioctl format check
Message-ID: <20200417182834.GS6112@intel.com>
References: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
 <20200417152310.GQ3456981@phenom.ffwll.local>
 <20200417154313.GO6112@intel.com>
 <CAKMK7uGBWyPtm0dva=Ndk6xJx7nUKJ20kn8S37iFB8s85WWmdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uGBWyPtm0dva=Ndk6xJx7nUKJ20kn8S37iFB8s85WWmdw@mail.gmail.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 17, 2020 at 08:10:26PM +0200, Daniel Vetter wrote:
> On Fri, Apr 17, 2020 at 5:43 PM Ville Syrjälä
> <ville.syrjala@linux.intel.com> wrote:
> >
> > On Fri, Apr 17, 2020 at 05:23:10PM +0200, Daniel Vetter wrote:
> > > On Thu, Apr 16, 2020 at 08:04:20PM +0300, Ville Syrjala wrote:
> > > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > >
> > > > Revert back to comparing fb->format->format instead fb->format for the
> > > > page flip ioctl. This check was originally only here to disallow pixel
> > > > format changes, but when we changed it to do the pointer comparison
> > > > we potentially started to reject some (but definitely not all) modifier
> > > > changes as well. In fact the current behaviour depends on whether the
> > > > driver overrides the format info for a specific format+modifier combo.
> > > > Eg. on i915 this now rejects compression vs. no compression changes but
> > > > does not reject any other tiling changes. That's just inconsistent
> > > > nonsense.
> > > >
> > > > The main reason we have to go back to the old behaviour is to fix page
> > > > flipping with Xorg. At some point Xorg got its atomic rights taken away
> > > > and since then we can't page flip between compressed and non-compressed
> > > > fbs on i915. Currently we get no page flipping for any games pretty much
> > > > since Mesa likes to use compressed buffers. Not sure how compositors are
> > > > working around this (don't use one myself). I guess they must be doing
> > > > something to get non-compressed buffers instead. Either that or
> > > > somehow no one noticed the tearing from the blit fallback.
> > >
> > > Mesa only uses compressed buffers if you enable modifiers, and there's a
> > > _loooooooooooot_ more that needs to be fixed in Xorg to enable that for
> > > real. Like real atomic support.
> >
> > Why would you need atomic for modifiers? Xorg doesn't even have
> > any sensible framework for atomic and I suspect it never will.
> 
> Frankly if no one cares about atomic in X I don't think we should do
> work-arounds for lack of atomic in X.
> 
> > > Without modifiers all you get is X tiling,
> > > and that works just fine.
> > >
> > > Which would also fix this issue here you're papering over.
> > >
> > > So if this is the entire reason for this, I'm inclined to not do this.
> > > Current Xorg is toast wrt modifiers, that's not news.
> >
> > Works just fine. Also pretty sure modifiers are even enabled by
> > default now in modesetting.
> 
> Y/CSS is harder to scan out, you need to verify with TEST_ONLY whether
> it works. Otherwise good chances for some oddball black screens on
> configurations that worked before. Which is why all non-atomic
> compositors reverted modifiers by default again.

Y alone is hard to scanout also, and yet we do nothing to reject that.
It's just an inconsistent mess.

If we really want to keep this check then we should rewrite it
to be explicit:

if (old_fb->format->format != new_fb->format->format ||
    is_ccs(old_fb->modifier) != is_ccs(new_fb->modifier))
    return -EINVAL;

Now it's just a random thing that may even stop doing what it's
currently doing if anyone touches their .get_format_info()
implementation.

> 
> > And as stated the current check doesn't have consistent behaviour
> > anyway. You can still flip between different modifiers as long a the
> > driver doesn't override .get_format_info() for one of them. The *only*
> > case where that happens is CCS on i915. There is no valid reason to
> > special case that one.
> 
> The thing is, you need atomic to make CCS work reliably enough for
> compositors and distros to dare enabling it by default.

If it's not enabled by default then there is no harm in letting people
explicitly enable it and get better performance.

> CCS flipping
> works with atomic. I really see no point in baking this in with as
> uapi.

It's just going back to the original intention of the check.
Heck, the debug message doesn't even match what it's doing now.

> Just fix Xorg.

Be serious. No one is going to rewrite all the randr code to be atomic.

> -Daniel
> 
> >
> > > -Daniel
> > >
> > > >
> > > > Looking back at the original discussion on this change we pretty much
> > > > just did it in the name of skipping a few extra pointer dereferences.
> > > > However, I've decided not to revert the whole thing in case someone
> > > > has since started to depend on these changes. None of the other checks
> > > > are relevant for i915 anyways.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > Fixes: dbd4d5761e1f ("drm: Replace 'format->format' comparisons to just 'format' comparisons")
> > > > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > ---
> > > >  drivers/gpu/drm/drm_plane.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
> > > > index d6ad60ab0d38..f2ca5315f23b 100644
> > > > --- a/drivers/gpu/drm/drm_plane.c
> > > > +++ b/drivers/gpu/drm/drm_plane.c
> > > > @@ -1153,7 +1153,7 @@ int drm_mode_page_flip_ioctl(struct drm_device *dev,
> > > >     if (ret)
> > > >             goto out;
> > > >
> > > > -   if (old_fb->format != fb->format) {
> > > > +   if (old_fb->format->format != fb->format->format) {
> > > >             DRM_DEBUG_KMS("Page flip is not allowed to change frame buffer format.\n");
> > > >             ret = -EINVAL;
> > > >             goto out;
> > > > --
> > > > 2.24.1
> > > >
> > > > _______________________________________________
> > > > dri-devel mailing list
> > > > dri-devel@lists.freedesktop.org
> > > > https://lists.freedesktop.org/mailman/listinfo/dri-devel
> > >
> > > --
> > > Daniel Vetter
> > > Software Engineer, Intel Corporation
> > > http://blog.ffwll.ch
> >
> > --
> > Ville Syrjälä
> > Intel
> 
> 
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

-- 
Ville Syrjälä
Intel
