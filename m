Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813331ACE66
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 19:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgDPRIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 13:08:31 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:45476 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgDPRIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Apr 2020 13:08:30 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C473B97D;
        Thu, 16 Apr 2020 19:08:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1587056907;
        bh=K0mOM4H6FgfHW3pGrtqvqk5/8aQTEAC2tBSYLPwGdzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KP+bGVGExbrP/7TaCTeVbAB56HRP2M7DQSQ+VDGMOJ8oFIuBbhbYyjE2nPdnwNuoO
         YHQxCjpa6RU9imTzUKOfg5weDArn+38tcLPINFIZllCTPFtBOILUdWI+YVdy7tEYva
         setK70L3qusC8eSBsedTEIJjjh36YBPLxEVO93mo=
Date:   Thu, 16 Apr 2020 20:08:14 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm: Fix page flip ioctl format check
Message-ID: <20200416170814.GI4796@pendragon.ideasonboard.com>
References: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ville,

Thank you for the patch.

On Thu, Apr 16, 2020 at 08:04:20PM +0300, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Revert back to comparing fb->format->format instead fb->format for the
> page flip ioctl. This check was originally only here to disallow pixel
> format changes, but when we changed it to do the pointer comparison
> we potentially started to reject some (but definitely not all) modifier
> changes as well. In fact the current behaviour depends on whether the
> driver overrides the format info for a specific format+modifier combo.
> Eg. on i915 this now rejects compression vs. no compression changes but
> does not reject any other tiling changes. That's just inconsistent
> nonsense.
> 
> The main reason we have to go back to the old behaviour is to fix page
> flipping with Xorg. At some point Xorg got its atomic rights taken away
> and since then we can't page flip between compressed and non-compressed
> fbs on i915. Currently we get no page flipping for any games pretty much
> since Mesa likes to use compressed buffers. Not sure how compositors are
> working around this (don't use one myself). I guess they must be doing
> something to get non-compressed buffers instead. Either that or
> somehow no one noticed the tearing from the blit fallback.
> 
> Looking back at the original discussion on this change we pretty much
> just did it in the name of skipping a few extra pointer dereferences.
> However, I've decided not to revert the whole thing in case someone
> has since started to depend on these changes. None of the other checks
> are relevant for i915 anyways.

Do display controller usually support changing modifiers for page flips
? I understand from the information about that i915 does, but is that
usual ? Could there be drivers that really on this check to reject
modifier changes, and that aren't prepared to handle them if they are
not rejected by the core ? I'm not opposed to this change, but I'd like
to carefully consider the fallout.

> Cc: stable@vger.kernel.org
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Fixes: dbd4d5761e1f ("drm: Replace 'format->format' comparisons to just 'format' comparisons")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/drm_plane.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
> index d6ad60ab0d38..f2ca5315f23b 100644
> --- a/drivers/gpu/drm/drm_plane.c
> +++ b/drivers/gpu/drm/drm_plane.c
> @@ -1153,7 +1153,7 @@ int drm_mode_page_flip_ioctl(struct drm_device *dev,
>  	if (ret)
>  		goto out;
>  
> -	if (old_fb->format != fb->format) {
> +	if (old_fb->format->format != fb->format->format) {
>  		DRM_DEBUG_KMS("Page flip is not allowed to change frame buffer format.\n");
>  		ret = -EINVAL;
>  		goto out;

-- 
Regards,

Laurent Pinchart
