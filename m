Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F93C6A7C60
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 09:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCBISr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 03:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCBISq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 03:18:46 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557074C10;
        Thu,  2 Mar 2023 00:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677745125; x=1709281125;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=AJIhha6A26LHvReUGAtEuYQT9YfWAbHpjTV7TVDTj3E=;
  b=c98wXtisgdsRO2zu/gIyiKDSsQkGYm0XwNqGFPgRKHXoWAgBibXl3boS
   VTNf9yTdBe0HywU8fpMzJi6Gd2liH7CJbAYnZfobYqw03MibTWH2y06SB
   W3VKbPWo5frWtrsrcOcU225ANxe614peOn3+jw/C6bz7vmTCLLibqTTUi
   fz18Rbf209Fua0ovW0HPvbQxuQfaT9zFc1HbxrTHzXv5Zuq3tnlcnOnqQ
   Eb9YP9EwEWHFD+PTS4Bt97+CpAYE+1rRQjnCv6As5ay1Tve9efPLs2EXL
   L40zEilUzY1BEQdIfaxQnFc8NBowGNp5piYrbR0GgoAI+mXI19P8OVFTU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="318454256"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="318454256"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 00:18:43 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="743755672"
X-IronPort-AV: E=Sophos;i="5.98,227,1673942400"; 
   d="scan'208";a="743755672"
Received: from martamon-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.57.129])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 00:17:33 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Johan Hovold <johan+linaro@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     Douglas Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        dri-devel@lists.freedesktop.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: Re: [PATCH] drm/edid: fix info leak when failing to get panel id
In-Reply-To: <20230302074704.11371-1-johan+linaro@kernel.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230302074704.11371-1-johan+linaro@kernel.org>
Date:   Thu, 02 Mar 2023 10:17:30 +0200
Message-ID: <874jr3worp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 02 Mar 2023, Johan Hovold <johan+linaro@kernel.org> wrote:
> Make sure to clear the transfer buffer before fetching the EDID to
> avoid leaking slab data to the logs on errors that leave the buffer
> unchanged.
>
> Fixes: 69c7717c20cc ("drm/edid: Dump the EDID when drm_edid_get_panel_id() has an error")
> Cc: stable@vger.kernel.org	# 6.2
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/drm_edid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> index 3841aba17abd..8707fe72a028 100644
> --- a/drivers/gpu/drm/drm_edid.c
> +++ b/drivers/gpu/drm/drm_edid.c
> @@ -2797,7 +2797,7 @@ u32 drm_edid_get_panel_id(struct i2c_adapter *adapter)
>  	 * the EDID then we'll just return 0.
>  	 */
>  
> -	base_block = kmalloc(EDID_LENGTH, GFP_KERNEL);
> +	base_block = kzalloc(EDID_LENGTH, GFP_KERNEL);
>  	if (!base_block)
>  		return 0;

-- 
Jani Nikula, Intel Open Source Graphics Center
