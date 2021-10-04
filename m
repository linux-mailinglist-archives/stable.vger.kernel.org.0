Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F9542073F
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 10:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhJDIZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 04:25:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:45507 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230238AbhJDIZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 04:25:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="205468150"
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="205468150"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 01:23:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="621770538"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga001.fm.intel.com with SMTP; 04 Oct 2021 01:23:30 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 04 Oct 2021 11:23:29 +0300
Date:   Mon, 4 Oct 2021 11:23:29 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, airlied@linux.ie, mripard@kernel.org,
        maarten.lankhorst@linux.intel.com, kernel@amanoeldawod.com,
        dirty.ice.hu@gmail.com, michael+lkml@stapelberg.ch,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxime Ripard <maxime@cerno.tech>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/fbdev: Clamp fbdev surface size if too large
Message-ID: <YVq6AffkPKB62aGF@intel.com>
References: <20211004081506.6791-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211004081506.6791-1-tzimmermann@suse.de>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 10:15:06AM +0200, Thomas Zimmermann wrote:
> Clamp the fbdev surface size of the available maximum height to avoid
> failing to init console emulation. An example error is shown below.
> 
>   bad framebuffer height 2304, should be >= 768 && <= 768
>   [drm] Initialized simpledrm 1.0.0 20200625 for simple-framebuffer.0 on minor 0
>   simple-framebuffer simple-framebuffer.0: [drm] *ERROR* fbdev: Failed to setup generic emulation (ret=-22)
> 
> This is especially a problem with drivers that have very small screen
> sizes and cannot over-allocate at all.
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
> ---
>  drivers/gpu/drm/drm_fb_helper.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index 6860223f0068..364f11900b37 100644
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
> +		drm_warn(dev, "Fbdev over-allocation too large; clamping height to %d\n",
> +			 config->max_height);

drm_warn() seems a bit excessive. drm_info()?

Or could just have no printk and use a simple min() perhaps.

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
