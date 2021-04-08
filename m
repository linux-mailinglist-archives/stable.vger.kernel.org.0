Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F91357FBA
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 11:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhDHJqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 05:46:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:65396 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231526AbhDHJqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 05:46:10 -0400
IronPort-SDR: 41n6wvK8JMiuPw7e3rd6VKKict9znRktPuPVziAlXhfgraurcQ+KZYJbVq/vDZPKqIereP7AZg
 SiQcEJIMbpcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="190297870"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="190297870"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 02:45:59 -0700
IronPort-SDR: UigdVX/N05m7yt7W4YwlhEF3a9siLtZO3DtdQB8EiWx6OEPnqBb6nrrU2gSUO+kv3Hozr9jHm0
 B43285QvQsQw==
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="458756758"
Received: from unknown (HELO intel.com) ([10.237.72.91])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 02:45:55 -0700
Date:   Thu, 8 Apr 2021 12:48:42 +0300
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Don't zero out the Y plane's watermarks
Message-ID: <20210408094842.GA14051@intel.com>
References: <20210327005945.4929-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210327005945.4929-1-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 27, 2021 at 02:59:45AM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Don't zero out the watermarks for the Y plane since we've already
> computed them when computing the UV plane's watermarks (since the
> UV plane always appears before ethe Y plane when iterating through
> the planes).
> 
> This leads to allocating no DDB for the Y plane since .min_ddb_alloc
> also gets zeroed. And that of course leads to underruns when scanning
> out planar formats.
> 
> We really need to re-enable the pre-merge pixel format tests or else
> I'll just keep breaking this stuff...

Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

> 
> Cc: stable@vger.kernel.org
> Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> Fixes: dbf71381d733 ("drm/i915: Nuke intel_atomic_crtc_state_for_each_plane_state() from skl+ wm code")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/intel_pm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
> index b2aede2be89d..49c19acdb7c6 100644
> --- a/drivers/gpu/drm/i915/intel_pm.c
> +++ b/drivers/gpu/drm/i915/intel_pm.c
> @@ -5511,12 +5511,12 @@ static int icl_build_plane_wm(struct intel_crtc_state *crtc_state,
>  	struct skl_plane_wm *wm = &crtc_state->wm.skl.raw.planes[plane_id];
>  	int ret;
>  
> -	memset(wm, 0, sizeof(*wm));
> -
>  	/* Watermarks calculated in master */
>  	if (plane_state->planar_slave)
>  		return 0;
>  
> +	memset(wm, 0, sizeof(*wm));
> +
>  	if (plane_state->planar_linked_plane) {
>  		const struct drm_framebuffer *fb = plane_state->hw.fb;
>  		enum plane_id y_plane_id = plane_state->planar_linked_plane->id;
> -- 
> 2.26.2
> 
