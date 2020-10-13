Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F2F28D17B
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 17:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731282AbgJMPsY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 13 Oct 2020 11:48:24 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:62602 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731256AbgJMPsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 11:48:22 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 22704345-1500050 
        for multiple; Tue, 13 Oct 2020 16:47:49 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201007120329.17076-1-ville.syrjala@linux.intel.com>
References: <20201007120329.17076-1-ville.syrjala@linux.intel.com>
Subject: Re: [PATCH 1/3] drm/i915: Mark ininitial fb obj as WT on eLLC machines to avoid rcu lockup during fbdev init
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Tue, 13 Oct 2020 16:47:49 +0100
Message-ID: <160260406924.2946.14780529118115559847@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

See subject, s/ininitial/iniital/

Quoting Ville Syrjala (2020-10-07 13:03:27)
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Currently we leave the cache_level of the initial fb obj
> set to NONE. This means on eLLC machines the first pin_to_display()
> will try to switch it to WT which requires a vma unbind+bind.
> If that happens during the fbdev initialization rcu does not
> seem operational which causes the unbind to get stuck. To
> most appearances this looks like a dead machine on boot.
> 
> Avoid the unbind by already marking the object cache_level
> as WT when creating it. We still do an excplicit ggtt pin
> which will rewrite the PTEs anyway, so they will match whatever
> cache level we set.
> 
> Cc: <stable@vger.kernel.org> # v5.7+
> Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2381
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_display.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> index 907e1d155443..00c08600c60a 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -3445,6 +3445,14 @@ initial_plane_vma(struct drm_i915_private *i915,
>         if (IS_ERR(obj))
>                 return NULL;
>  
> +       /*
> +        * Mark it WT ahead of time to avoid changing the
> +        * cache_level during fbdev initialization. The
> +        * unbind there would get stuck waiting for rcu.
> +        */
> +       i915_gem_object_set_cache_coherency(obj, HAS_WT(i915) ?
> +                                           I915_CACHE_WT : I915_CACHE_NONE);

Ok, I've been worrying about whether there were any more side-effects,
but I think it all comes out in the wash. The proof is definitely in the
eating, and we will know soon enough if we break someone's virtual
terminal.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris
