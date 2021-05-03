Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8EB3710A4
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 05:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhECDOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 23:14:05 -0400
Received: from mga12.intel.com ([192.55.52.136]:32498 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232377AbhECDOF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 23:14:05 -0400
IronPort-SDR: aRFKyM+uLGO7XrRuSstfc01ekQ+C2HoQgJsB2kY1KOJPR/YVg6TsFAsLb+0CGLUTv5UAgFGczV
 BY0oGo8mlnSw==
X-IronPort-AV: E=McAfee;i="6200,9189,9972"; a="177182983"
X-IronPort-AV: E=Sophos;i="5.82,268,1613462400"; 
   d="scan'208";a="177182983"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2021 20:13:12 -0700
IronPort-SDR: DlWEuVc0GsZ3l2+sap/HNaJbO6bnemkBr3ic7xwnaYf3UstWJiIJgYMNDV7JDDnl61Yd449exs
 SRFm40MiPnQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,268,1613462400"; 
   d="scan'208";a="389370171"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga006.jf.intel.com with SMTP; 02 May 2021 20:13:08 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 03 May 2021 06:13:08 +0300
Date:   Mon, 3 May 2021 06:13:08 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        =?iso-8859-1?B?Suly9G1l?= de Bretagne 
        <jerome.debretagne@gmail.com>, David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sean Paul <sean@poorly.run>
Subject: Re: [PATCH 1/2] drm/dp: Handle zeroed port counts in
 drm_dp_read_downstream_info()
Message-ID: <YI9qRPkSDGrLAaFg@intel.com>
References: <20210430223428.10514-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210430223428.10514-1-lyude@redhat.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 30, 2021 at 06:34:27PM -0400, Lyude Paul wrote:
> While the DP specification isn't entirely clear on if this should be
> allowed or not, some branch devices report having downstream ports present
> while also reporting a downstream port count of 0. So to avoid breaking
> those devices, we need to handle this in drm_dp_read_downstream_info().
> 
> So, to do this we assume there's no downstream port info when the
> downstream port count is 0.
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Tested-by: Jérôme de Bretagne <jerome.debretagne@gmail.com>
> Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/3416
> Fixes: 3d3721ccb18a ("drm/i915/dp: Extract drm_dp_read_downstream_info()")
> Cc: <stable@vger.kernel.org> # v5.10+
> ---
>  drivers/gpu/drm/drm_dp_helper.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_dp_helper.c b/drivers/gpu/drm/drm_dp_helper.c
> index cb56d74e9d38..27c8c5bdf7d9 100644
> --- a/drivers/gpu/drm/drm_dp_helper.c
> +++ b/drivers/gpu/drm/drm_dp_helper.c
> @@ -682,7 +682,14 @@ int drm_dp_read_downstream_info(struct drm_dp_aux *aux,
>  	    !(dpcd[DP_DOWNSTREAMPORT_PRESENT] & DP_DWN_STRM_PORT_PRESENT))
>  		return 0;
>  
> +	/* Some branches advertise having 0 downstream ports, despite also advertising they have a
> +	 * downstream port present. The DP spec isn't clear on if this is allowed or not, but since
> +	 * some branches do it we need to handle it regardless.
> +	 */
>  	len = drm_dp_downstream_port_count(dpcd);
> +	if (!len)
> +		return 0;
> +

Seems sane enough.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

>  	if (dpcd[DP_DOWNSTREAMPORT_PRESENT] & DP_DETAILED_CAP_INFO_AVAILABLE)
>  		len *= 4;
>  
> -- 
> 2.30.2
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Ville Syrjälä
Intel
