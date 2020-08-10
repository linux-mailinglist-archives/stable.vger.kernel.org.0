Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5132407CD
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 16:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgHJOrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 10:47:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:7735 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbgHJOrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 10:47:21 -0400
IronPort-SDR: LlS/wbmE54YM8XUPPyPXiA6IqZePut+3CA6Xir8rvoH6JuyCoDN1XHvnn6IbvWb5baXCVsM9cP
 5iJMEv7I7o0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9708"; a="238375922"
X-IronPort-AV: E=Sophos;i="5.75,457,1589266800"; 
   d="scan'208";a="238375922"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 07:47:19 -0700
IronPort-SDR: 1mWDLBi3hbirNy6kMkQPhTRClHMkh6Z15RH8fXzb54yxJi2SwO7zS2xFFn7pnLUOQdlPMvdB/V
 WkVv99Asi19A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,457,1589266800"; 
   d="scan'208";a="326530843"
Received: from chadjitt-mobl1.ger.corp.intel.com (HELO [10.249.44.177]) ([10.249.44.177])
  by fmsmga002.fm.intel.com with ESMTP; 10 Aug 2020 07:47:18 -0700
Subject: Re: [PATCH] drm/i915/display: Fix NV12 sub plane atomic state
To:     Uma Shankar <uma.shankar@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     alex.zuo@intel.com, Abhishek Kumar <abhishek4.kumar@intel.com>,
        stable@vger.kernel.org
References: <20200810151602.20757-1-uma.shankar@intel.com>
From:   Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Message-ID: <c73e1ba2-dec8-c95c-dbb4-efeffe21cfb4@linux.intel.com>
Date:   Mon, 10 Aug 2020 16:47:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200810151602.20757-1-uma.shankar@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Op 10-08-2020 om 17:16 schreef Uma Shankar:
> From: Abhishek Kumar <abhishek4.kumar@intel.com>
>
> For NV12 display sub plane is also configured and drivers internally
> create plane atomic state. Driver copies all of the param of main
> plane atomic state to sub planer atomic state but in sub plane
> atomic state crtc is not added ,so when drm atomic state is configured
> for commit ,fake commit handler is created for sub plane and also
> state is not cleared when NV12 buffer is not displayed.
>
> Fixes: 1f594b209fe1 ("drm/i915: Remove special case slave handling during hw programming")
> Change-Id: I447b16bf433dfb5b43b2e4cade258fc775aee065
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Abhishek Kumar <abhishek4.kumar@intel.com>
> Signed-off-by: Uma Shankar <uma.shankar@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_display.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> index 522c772a2111..76da2189b01d 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -12502,6 +12502,7 @@ static int icl_check_nv12_planes(struct intel_crtc_state *crtc_state)
>  	struct intel_atomic_state *state = to_intel_atomic_state(crtc_state->uapi.state);
>  	struct intel_plane *plane, *linked;
>  	struct intel_plane_state *plane_state;
> +	int ret;
>  	int i;
>  
>  	if (INTEL_GEN(dev_priv) < 11)
> @@ -12576,6 +12577,11 @@ static int icl_check_nv12_planes(struct intel_crtc_state *crtc_state)
>  		linked_state->uapi.src = plane_state->uapi.src;
>  		linked_state->uapi.dst = plane_state->uapi.dst;
>  
> +		/* Update Linked plane crtc same as of main plane */
> +		ret = drm_atomic_set_crtc_for_plane(&linked_state->uapi, plane_state->uapi.crtc);
> +		if(ret)
> +			return ret;
> +
>  		if (icl_is_hdr_plane(dev_priv, plane->id)) {
>  			if (linked->id == PLANE_SPRITE5)
>  				plane_state->cus_ctl |= PLANE_CUS_PLANE_7;

That shouldnt be done, uapi.crtc should be NULL for the slave plane.

