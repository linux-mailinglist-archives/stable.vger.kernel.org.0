Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53C2554BC7
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 15:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357533AbiFVNu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 09:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbiFVNu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 09:50:56 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02382F01C;
        Wed, 22 Jun 2022 06:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655905855; x=1687441855;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=3CohyWmUtUrTBDe+BBE5Y7WDYYBZ1KvVKXJdpbgQSK4=;
  b=IddE3mk8uIEVU7Cg9GnCssuaErFul+OLkFL5C4+K7fOv33Fwyw4COL6V
   fC/IUYzYgboyHJX/6IIfBBPNdZVvK8onIDABob53mls0Z4BWWgMcSQ/rj
   D7sW0CXwknUUJzIjycbVSaHZ7IMbDE7Zy2MZZmPOPPoXN2HKH8j8AemBz
   fzhj0pCr25WuVHd2P5yHAAqMn5CE739O1JQgjGnn/0xqrOJ1sLNmNSoWw
   B7Z4lj3D4EYkU7UJiSNqZ5unRv8y3A8/CWzj/tyXSY1+SNmw5kBYLf8Qy
   Hi0Xtjm+IgR3fWsbzijPmKEPLi200eERO8T+kPEdG2YOSDgpHeyDDpmr+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="269139957"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="269139957"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 06:50:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730356568"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.163])
  by fmsmga001.fm.intel.com with SMTP; 22 Jun 2022 06:50:50 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 22 Jun 2022 16:50:50 +0300
Date:   Wed, 22 Jun 2022 16:50:50 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     drawat.floss@gmail.com, airlied@linux.ie, daniel@ffwll.ch,
        linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org,
        jani.nikula@linux.intel.com,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/hyperv-drm: Include framebuffer and EDID headers
Message-ID: <YrMeOiMIg89Pwr7R@intel.com>
References: <20220622083413.12573-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220622083413.12573-1-tzimmermann@suse.de>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 22, 2022 at 10:34:13AM +0200, Thomas Zimmermann wrote:
> Fix a number of compile errors by including the correct header
> files. Examples are shown below.
> 
>   ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c: In function 'hyperv_blit_to_vram_rect':
>   ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c:25:48: error: invalid use of undefined type 'struct drm_framebuffer'
>    25 |         struct hyperv_drm_device *hv = to_hv(fb->dev);
>       |                                                ^~
> 
>   ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c: In function 'hyperv_connector_get_modes':
>   ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c:59:17: error: implicit declaration of function 'drm_add_modes_noedid' [-Werror=implicit-function-declaration]
>    59 |         count = drm_add_modes_noedid(connector,
>       |                 ^~~~~~~~~~~~~~~~~~~~
> 
>   ../drivers/gpu/drm/hyperv/hyperv_drm_modeset.c:62:9: error: implicit declaration of function 'drm_set_preferred_mode'; did you mean 'drm_mm_reserve_node'? [-Werror=implicit-function-declaration]
>    62 |         drm_set_preferred_mode(connector, hv->preferred_width,
>       |         ^~~~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 76c56a5affeb ("drm/hyperv: Add DRM driver for hyperv synthetic video device")

Presumably should be
Fixes: 720cf96d8fec ("drm: Drop drm_framebuffer.h from drm_crtc.h")
Fixes: 255490f9150d ("drm: Drop drm_edid.h from drm_crtc.h")

Mea culpa

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> Cc: Deepak Rawat <drawat.floss@gmail.com>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: linux-hyperv@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.14+
> ---
>  drivers/gpu/drm/hyperv/hyperv_drm_modeset.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c b/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c
> index 27f4fcb058f9..b8e64dd8d3a6 100644
> --- a/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c
> +++ b/drivers/gpu/drm/hyperv/hyperv_drm_modeset.c
> @@ -7,9 +7,11 @@
>  
>  #include <drm/drm_damage_helper.h>
>  #include <drm/drm_drv.h>
> +#include <drm/drm_edid.h>
>  #include <drm/drm_fb_helper.h>
>  #include <drm/drm_format_helper.h>
>  #include <drm/drm_fourcc.h>
> +#include <drm/drm_framebuffer.h>
>  #include <drm/drm_gem_atomic_helper.h>
>  #include <drm/drm_gem_framebuffer_helper.h>
>  #include <drm/drm_gem_shmem_helper.h>
> -- 
> 2.36.1

-- 
Ville Syrjälä
Intel
