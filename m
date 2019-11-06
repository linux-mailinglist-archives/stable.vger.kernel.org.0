Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCCDF1C99
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 18:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732202AbfKFRix convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 6 Nov 2019 12:38:53 -0500
Received: from mail.fireflyinternet.com ([109.228.58.192]:62362 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732141AbfKFRix (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 12:38:53 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 19105437-1500050 
        for multiple; Wed, 06 Nov 2019 17:38:48 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20191106172349.11987-1-ville.syrjala@linux.intel.com>
Cc:     stable@vger.kernel.org
References: <20191106172349.11987-1-ville.syrjala@linux.intel.com>
Message-ID: <157306192625.26738.4881106515096173919@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Don't oops in dumb_create ioctl if we have
 no crtcs
Date:   Wed, 06 Nov 2019 17:38:46 +0000
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Ville Syrjala (2019-11-06 17:23:49)
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Make sure we have a crtc before probing its primary plane's
> max stride. Initially I thought we can't get this far without
> crtcs, but looks like we can via the dumb_create ioctl.
> 
> Not sure if we shouldn't disable dumb buffer support entirely
> when we have no crtcs, but that would require some amount of work
> as the only thing currently being checked is dev->driver->dumb_create
> which we'd have to convert to some device specific dynamic thing.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Fixes: aa5ca8b7421c ("drm/i915: Align dumb buffer stride to 4k to allow for gtt remapping")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_display.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> index 1f93860fb897..331030765ca9 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -2543,6 +2543,9 @@ u32 intel_plane_fb_max_stride(struct drm_i915_private *dev_priv,
>          * the highest stride limits of them all.
>          */
>         crtc = intel_get_crtc_for_pipe(dev_priv, PIPE_A);
> +       if (!crtc)
> +               return 0;
> +

Callers:
intel_fb_max_stride -> intel_framebuffer_init, not used if no display
intel_fb_stride_alignment,
	0 -> intel_tile_size() alignment. ok ->
	intel_framebuffer_init, not used as no display

-> i915_gem_dumb_create -> args->pitch = PAGE_ALIGN()

Ok, not as horrible as I feared when I saw return 0 from max_stride!

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris
