Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1730A1ACECA
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 19:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgDPRgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 13:36:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:42247 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbgDPRgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 13:36:50 -0400
IronPort-SDR: U80Y4mR5nyZ1KWDhIkMJnTphkDecLtBp+B9NNbPBbhorE+eoM6FgHGJzGfKvxMvxEOmXmAKmy6
 nubXqEtzy3HQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 10:36:49 -0700
IronPort-SDR: bYcMqP7HHeFuyMHxyG2Cy/+9vdE3DmC7lIFJbp3qnzvpgt9XWYaneT880u5jTfPqaavYiHzmuL
 OPHinUX3Hxog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="364065411"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga001.fm.intel.com with SMTP; 16 Apr 2020 10:36:46 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 16 Apr 2020 20:36:45 +0300
Date:   Thu, 16 Apr 2020 20:36:45 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm: Fix page flip ioctl format check
Message-ID: <20200416173645.GK6112@intel.com>
References: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
 <20200416170814.GI4796@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200416170814.GI4796@pendragon.ideasonboard.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 16, 2020 at 08:08:14PM +0300, Laurent Pinchart wrote:
> Hi Ville,
> 
> Thank you for the patch.
> 
> On Thu, Apr 16, 2020 at 08:04:20PM +0300, Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > Revert back to comparing fb->format->format instead fb->format for the
> > page flip ioctl. This check was originally only here to disallow pixel
> > format changes, but when we changed it to do the pointer comparison
> > we potentially started to reject some (but definitely not all) modifier
> > changes as well. In fact the current behaviour depends on whether the
> > driver overrides the format info for a specific format+modifier combo.
> > Eg. on i915 this now rejects compression vs. no compression changes but
> > does not reject any other tiling changes. That's just inconsistent
> > nonsense.
> > 
> > The main reason we have to go back to the old behaviour is to fix page
> > flipping with Xorg. At some point Xorg got its atomic rights taken away
> > and since then we can't page flip between compressed and non-compressed
> > fbs on i915. Currently we get no page flipping for any games pretty much
> > since Mesa likes to use compressed buffers. Not sure how compositors are
> > working around this (don't use one myself). I guess they must be doing
> > something to get non-compressed buffers instead. Either that or
> > somehow no one noticed the tearing from the blit fallback.
> > 
> > Looking back at the original discussion on this change we pretty much
> > just did it in the name of skipping a few extra pointer dereferences.
> > However, I've decided not to revert the whole thing in case someone
> > has since started to depend on these changes. None of the other checks
> > are relevant for i915 anyways.
> 
> Do display controller usually support changing modifiers for page flips
> ? I understand from the information about that i915 does, but is that
> usual ? Could there be drivers that really on this check to reject
> modifier changes, and that aren't prepared to handle them if they are
> not rejected by the core ? I'm not opposed to this change, but I'd like
> to carefully consider the fallout.

After a bit of grepping I can't actually see any other driver providing
a .get_format_info() hook. So looks like there is no change in behaviour
for any other driver. Based on that we could even do a full revert, but
meh.

> 
> > Cc: stable@vger.kernel.org
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Fixes: dbd4d5761e1f ("drm: Replace 'format->format' comparisons to just 'format' comparisons")
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> >  drivers/gpu/drm/drm_plane.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
> > index d6ad60ab0d38..f2ca5315f23b 100644
> > --- a/drivers/gpu/drm/drm_plane.c
> > +++ b/drivers/gpu/drm/drm_plane.c
> > @@ -1153,7 +1153,7 @@ int drm_mode_page_flip_ioctl(struct drm_device *dev,
> >  	if (ret)
> >  		goto out;
> >  
> > -	if (old_fb->format != fb->format) {
> > +	if (old_fb->format->format != fb->format->format) {
> >  		DRM_DEBUG_KMS("Page flip is not allowed to change frame buffer format.\n");
> >  		ret = -EINVAL;
> >  		goto out;
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Ville Syrjälä
Intel
