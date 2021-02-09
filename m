Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B276314BCD
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 10:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhBIJg0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 9 Feb 2021 04:36:26 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:64784 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229710AbhBIJeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 04:34:24 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.69.177;
Received: from localhost (unverified [78.156.69.177]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 23819370-1500050 
        for multiple; Tue, 09 Feb 2021 09:33:10 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210209021918.16234-2-ville.syrjala@linux.intel.com>
References: <20210209021918.16234-1-ville.syrjala@linux.intel.com> <20210209021918.16234-2-ville.syrjala@linux.intel.com>
Subject: Re: [PATCH 2/3] drm/i915: Fix overlay frontbuffer tracking
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Tue, 09 Feb 2021 09:33:11 +0000
Message-ID: <161286319138.7943.3229337601047523963@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Ville Syrjala (2021-02-09 02:19:17)
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> We don't have a persistent fb holding a reference to the frontbuffer
> object, so every time we do the get+put we throw the frontbuffer object
> immediately away. And so the next time around we get a pristine
> frontbuffer object with bits==0 even for the old vma. This confuses
> the frontbuffer tracking code which understandably expects the old
> frontbuffer to have the overlay's bit set.
> 
> Fix this by hanging on to the frontbuffer reference until the next
> flip. And just to make this a bit more clear let's track the frontbuffer
> explicitly instead of just grabbing it via the old vma.
> 
> Cc: stable@vger.kernel.org
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1136
> Fixes: da42104f589d ("drm/i915: Hold reference to intel_frontbuffer as we track activity")

Maybe more apropos, same kernel though
Fixes: 8e7cb1799b4f ("drm/i915: Extract intel_frontbuffer active tracking")

Ok, so this definitely used to be swapping between the
obj->frontbuffer_bits and so used to have a persistent reference.
Keeping the frontbuffer tracking with the overlay makes even more sense.

> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>

> ---
>  drivers/gpu/drm/i915/display/intel_overlay.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_overlay.c b/drivers/gpu/drm/i915/display/intel_overlay.c
> index 9c0113f15b58..ef8f44f5e751 100644
> --- a/drivers/gpu/drm/i915/display/intel_overlay.c
> +++ b/drivers/gpu/drm/i915/display/intel_overlay.c
> @@ -183,6 +183,7 @@ struct intel_overlay {
>         struct intel_crtc *crtc;
>         struct i915_vma *vma;
>         struct i915_vma *old_vma;
> +       struct intel_frontbuffer *frontbuffer;
>         bool active;
>         bool pfit_active;
>         u32 pfit_vscale_ratio; /* shifted-point number, (1<<12) == 1.0 */
> @@ -283,21 +284,19 @@ static void intel_overlay_flip_prepare(struct intel_overlay *overlay,
>                                        struct i915_vma *vma)
>  {
>         enum pipe pipe = overlay->crtc->pipe;
> -       struct intel_frontbuffer *from = NULL, *to = NULL;
> +       struct intel_frontbuffer *frontbuffer = NULL;
>  
>         drm_WARN_ON(&overlay->i915->drm, overlay->old_vma);
>  
> -       if (overlay->vma)
> -               from = intel_frontbuffer_get(overlay->vma->obj);
>         if (vma)
> -               to = intel_frontbuffer_get(vma->obj);
> +               frontbuffer = intel_frontbuffer_get(vma->obj);
>  
> -       intel_frontbuffer_track(from, to, INTEL_FRONTBUFFER_OVERLAY(pipe));
> +       intel_frontbuffer_track(overlay->frontbuffer, frontbuffer,
> +                               INTEL_FRONTBUFFER_OVERLAY(pipe));
>  
> -       if (to)
> -               intel_frontbuffer_put(to);
> -       if (from)
> -               intel_frontbuffer_put(from);
> +       if (overlay->frontbuffer)
> +               intel_frontbuffer_put(overlay->frontbuffer);
> +       overlay->frontbuffer = frontbuffer;

And this will drop the ref on overlay->frontbuffer as we flip to NULL on
shutdown.

Now if only someone still had the code to expose sprites instead of
overlays.
-Chris
