Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC37FA845E
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 15:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfIDNTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 09:19:07 -0400
Received: from mga05.intel.com ([192.55.52.43]:29334 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727900AbfIDNTH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 09:19:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 06:19:06 -0700
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="176940991"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 06:19:02 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Baolin Wang <baolin.wang@linaro.org>, stable@vger.kernel.org,
        chris@chris-wilson.co.uk, airlied@linux.ie
Cc:     vincent.guittot@linaro.org, arnd@arndb.de, baolin.wang@linaro.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, orsonzhai@gmail.com
Subject: Re: [BACKPORT 4.14.y 1/8] drm/i915/fbdev: Actually configure untiled displays
In-Reply-To: <5723d9006de706582fb46f9e1e3eb8ce168c2126.1567492316.git.baolin.wang@linaro.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1567492316.git.baolin.wang@linaro.org> <5723d9006de706582fb46f9e1e3eb8ce168c2126.1567492316.git.baolin.wang@linaro.org>
Date:   Wed, 04 Sep 2019 16:18:59 +0300
Message-ID: <878sr442t8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 03 Sep 2019, Baolin Wang <baolin.wang@linaro.org> wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
>
> If we skipped all the connectors that were not part of a tile, we would
> leave conn_seq=0 and conn_configured=0, convincing ourselves that we
> had stagnated in our configuration attempts. Avoid this situation by
> starting conn_seq=ALL_CONNECTORS, and repeating until we find no more
> connectors to configure.
>
> Fixes: 754a76591b12 ("drm/i915/fbdev: Stop repeating tile configuration on stagnation")
> Reported-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190215123019.32283-1-chris@chris-wilson.co.uk
> Cc: <stable@vger.kernel.org> # v3.19+
> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>

Please look into the scripts to avoid picking up stuff that has
subsequently been reverted:

commit 9fa246256e09dc30820524401cdbeeaadee94025
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Apr 24 10:47:56 2019 +1000

    Revert "drm/i915/fbdev: Actually configure untiled displays"
    
    This reverts commit d179b88deb3bf6fed4991a31fd6f0f2cad21fab5.
    
    This commit is documented to break userspace X.org modesetting driver in certain configurations.
    
    The X.org modesetting userspace driver is broken. No fixes are available yet. In order for this patch to be applied it either needs a config option or a workaround developed.
    
    This has been reported a few times, saying it's a userspace problem is clearly against the regression rules.
    
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=109806
    Signed-off-by: Dave Airlie <airlied@redhat.com>
    Cc: <stable@vger.kernel.org> # v3.19+



BR,
Jani.


> ---
>  drivers/gpu/drm/i915/intel_fbdev.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_fbdev.c b/drivers/gpu/drm/i915/intel_fbdev.c
> index da2d309..14eb8a0 100644
> --- a/drivers/gpu/drm/i915/intel_fbdev.c
> +++ b/drivers/gpu/drm/i915/intel_fbdev.c
> @@ -326,8 +326,8 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
>  				    bool *enabled, int width, int height)
>  {
>  	struct drm_i915_private *dev_priv = to_i915(fb_helper->dev);
> -	unsigned long conn_configured, conn_seq, mask;
>  	unsigned int count = min(fb_helper->connector_count, BITS_PER_LONG);
> +	unsigned long conn_configured, conn_seq;
>  	int i, j;
>  	bool *save_enabled;
>  	bool fallback = true, ret = true;
> @@ -345,10 +345,9 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
>  		drm_modeset_backoff(&ctx);
>  
>  	memcpy(save_enabled, enabled, count);
> -	mask = GENMASK(count - 1, 0);
> +	conn_seq = GENMASK(count - 1, 0);
>  	conn_configured = 0;
>  retry:
> -	conn_seq = conn_configured;
>  	for (i = 0; i < count; i++) {
>  		struct drm_fb_helper_connector *fb_conn;
>  		struct drm_connector *connector;
> @@ -361,7 +360,8 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
>  		if (conn_configured & BIT(i))
>  			continue;
>  
> -		if (conn_seq == 0 && !connector->has_tile)
> +		/* First pass, only consider tiled connectors */
> +		if (conn_seq == GENMASK(count - 1, 0) && !connector->has_tile)
>  			continue;
>  
>  		if (connector->status == connector_status_connected)
> @@ -465,8 +465,10 @@ static bool intel_fb_initial_config(struct drm_fb_helper *fb_helper,
>  		conn_configured |= BIT(i);
>  	}
>  
> -	if ((conn_configured & mask) != mask && conn_configured != conn_seq)
> +	if (conn_configured != conn_seq) { /* repeat until no more are found */
> +		conn_seq = conn_configured;
>  		goto retry;
> +	}
>  
>  	/*
>  	 * If the BIOS didn't enable everything it could, fall back to have the

-- 
Jani Nikula, Intel Open Source Graphics Center
