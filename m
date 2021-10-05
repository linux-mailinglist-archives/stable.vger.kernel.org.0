Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E59421FA4
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 09:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhJEHuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 03:50:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:31264 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232591AbhJEHuN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 03:50:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="212612147"
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="212612147"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2021 00:48:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,348,1624345200"; 
   d="scan'208";a="457976420"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga002.jf.intel.com with SMTP; 05 Oct 2021 00:48:08 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 05 Oct 2021 10:48:07 +0300
Date:   Tue, 5 Oct 2021 10:48:07 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, airlied@linux.ie, mripard@kernel.org,
        maarten.lankhorst@linux.intel.com, kernel@amanoeldawod.com,
        dirty.ice.hu@gmail.com, michael+lkml@stapelberg.ch,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>, stable@vger.kernel.org
Subject: Re: [PATCH v2] drm/fbdev: Clamp fbdev surface size if too large
Message-ID: <YVwDN6vYfvo0wzSX@intel.com>
References: <20211005070355.7680-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211005070355.7680-1-tzimmermann@suse.de>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 05, 2021 at 09:03:55AM +0200, Thomas Zimmermann wrote:
> Clamp the fbdev surface size of the available maximumi height to avoid
> failing to init console emulation. An example error is shown below.
> 
>   bad framebuffer height 2304, should be >= 768 && <= 768
>   [drm] Initialized simpledrm 1.0.0 20200625 for simple-framebuffer.0 on minor 0
>   simple-framebuffer simple-framebuffer.0: [drm] *ERROR* fbdev: Failed to setup generic emulation (ret=-22)
> 
> This is especially a problem with drivers that have very small screen
> sizes and cannot over-allocate at all.
> 
> v2:
> 	* reduce warning level (Ville)
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
> Reported-by: Amanoel Dawod <kernel@amanoeldawod.com>
> Reported-by: Zoltán Kővágó <dirty.ice.hu@gmail.com>
> Reported-by: Michael Stapelberg <michael+lkml@stapelberg.ch>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Maxime Ripard <maxime@cerno.tech>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.14+

Looks sane.
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> ---
>  drivers/gpu/drm/drm_fb_helper.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index 6860223f0068..3b5661cf6c2b 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -1508,6 +1508,7 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
>  {
>  	struct drm_client_dev *client = &fb_helper->client;
>  	struct drm_device *dev = fb_helper->dev;
> +	struct drm_mode_config *config = &dev->mode_config;
>  	int ret = 0;
>  	int crtc_count = 0;
>  	struct drm_connector_list_iter conn_iter;
> @@ -1665,6 +1666,11 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
>  	/* Handle our overallocation */
>  	sizes.surface_height *= drm_fbdev_overalloc;
>  	sizes.surface_height /= 100;
> +	if (sizes.surface_height > config->max_height) {
> +		drm_dbg_kms(dev, "Fbdev over-allocation too large; clamping height to %d\n",
> +			    config->max_height);
> +		sizes.surface_height = config->max_height;
> +	}
>  
>  	/* push down into drivers */
>  	ret = (*fb_helper->funcs->fb_probe)(fb_helper, &sizes);
> -- 
> 2.33.0

-- 
Ville Syrjälä
Intel
