Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DFC16C453
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 15:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbgBYOsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 09:48:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:17340 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729377AbgBYOsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Feb 2020 09:48:18 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 06:48:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,484,1574150400"; 
   d="scan'208";a="231475139"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga008.fm.intel.com with SMTP; 25 Feb 2020 06:48:14 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 25 Feb 2020 16:48:14 +0200
Date:   Tue, 25 Feb 2020 16:48:14 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Stone <daniels@collabora.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@intel.com>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>
Subject: Re: [Intel-gfx] [PATCH] drm: avoid spurious EBUSY due to nonblocking
 atomic modesets
Message-ID: <20200225144814.GC13686@intel.com>
References: <20200225115024.2386811-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200225115024.2386811-1-daniel.vetter@ffwll.ch>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 25, 2020 at 12:50:24PM +0100, Daniel Vetter wrote:
> When doing an atomic modeset with ALLOW_MODESET drivers are allowed to
> pull in arbitrary other resources, including CRTCs (e.g. when
> reconfiguring global resources).
> 
> But in nonblocking mode userspace has then no idea this happened,
> which can lead to spurious EBUSY calls, both:
> - when that other CRTC is currently busy doing a page_flip the
>   ALLOW_MODESET commit can fail with an EBUSY
> - on the other CRTC a normal atomic flip can fail with EBUSY because
>   of the additional commit inserted by the kernel without userspace's
>   knowledge
> 
> For blocking commits this isn't a problem, because everyone else will
> just block until all the CRTC are reconfigured. Only thing userspace
> can notice is the dropped frames without any reason for why frames got
> dropped.
> 
> Consensus is that we need new uapi to handle this properly, but no one
> has any idea what exactly the new uapi should look like. As a stop-gap
> plug this problem by demoting nonblocking commits which might cause
> issues by including CRTCs not in the original request to blocking
> commits.
> 
> v2: Add comments and a WARN_ON to enforce this only when allowed - we
> don't want to silently convert page flips into blocking plane updates
> just because the driver is buggy.
> 
> v3: Fix inverted WARN_ON (Pekka).
> 
> References: https://lists.freedesktop.org/archives/dri-devel/2018-July/182281.html
> Bugzilla: https://gitlab.freedesktop.org/wayland/weston/issues/24#note_9568
> Cc: Daniel Stone <daniel@fooishbar.org>
> Cc: Pekka Paalanen <pekka.paalanen@collabora.co.uk>
> Cc: stable@vger.kernel.org
> Reviewed-by: Daniel Stone <daniels@collabora.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/gpu/drm/drm_atomic.c | 34 +++++++++++++++++++++++++++++++---
>  1 file changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
> index 9ccfbf213d72..4c035abf98b8 100644
> --- a/drivers/gpu/drm/drm_atomic.c
> +++ b/drivers/gpu/drm/drm_atomic.c
> @@ -1362,15 +1362,43 @@ EXPORT_SYMBOL(drm_atomic_commit);
>  int drm_atomic_nonblocking_commit(struct drm_atomic_state *state)
>  {
>  	struct drm_mode_config *config = &state->dev->mode_config;
> -	int ret;
> +	unsigned requested_crtc = 0;
> +	unsigned affected_crtc = 0;
> +	struct drm_crtc *crtc;
> +	struct drm_crtc_state *crtc_state;
> +	bool nonblocking = true;
> +	int ret, i;
> +
> +	/*
> +	 * For commits that allow modesets drivers can add other CRTCs to the
> +	 * atomic commit, e.g. when they need to reallocate global resources.
> +	 *
> +	 * But when userspace also requests a nonblocking commit then userspace
> +	 * cannot know that the commit affects other CRTCs, which can result in
> +	 * spurious EBUSY failures. Until we have better uapi plug this by
> +	 * demoting such commits to blocking mode.
> +	 */
> +	for_each_new_crtc_in_state(state, crtc, crtc_state, i)
> +		requested_crtc |= drm_crtc_mask(crtc);
>  
>  	ret = drm_atomic_check_only(state);
>  	if (ret)
>  		return ret;
>  
> -	DRM_DEBUG_ATOMIC("committing %p nonblocking\n", state);
> +	for_each_new_crtc_in_state(state, crtc, crtc_state, i)
> +		affected_crtc |= drm_crtc_mask(crtc);
> +
> +	if (affected_crtc != requested_crtc) {
> +		/* adding other CRTC is only allowed for modeset commits */
> +		WARN_ON(!state->allow_modeset);

Not sure that's really true. What if the driver needs to eg.
redistribute FIFO space or something between the pipes? Or do we
expect drivers to now examine state->allow_modeset to figure out
if they're allowed to do certain things?

> +
> +		DRM_DEBUG_ATOMIC("demoting %p to blocking mode to avoid EBUSY\n", state);
> +		nonblocking = false;
> +	} else {
> +		DRM_DEBUG_ATOMIC("committing %p nonblocking\n", state);
> +	}
>  
> -	return config->funcs->atomic_commit(state->dev, state, true);
> +	return config->funcs->atomic_commit(state->dev, state, nonblocking);
>  }
>  EXPORT_SYMBOL(drm_atomic_nonblocking_commit);
>  
> -- 
> 2.24.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel
