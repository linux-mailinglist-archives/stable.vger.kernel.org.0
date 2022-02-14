Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF374B4D68
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349279AbiBNKwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:52:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349383AbiBNKvy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:51:54 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F5F69CCF
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 02:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644833784; x=1676369784;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZLSQbYy/k+4wVRVOROLuhteAPRKfUCpphzihZWyy6uY=;
  b=D8Oy11PlTzH4rF4WepUyS06yyJn3PnznQj6f/dxayzrGdxjZwOcflBSA
   3gD8pY6CgFSmyeaKhgeWd6wrHnHPGGbwFfwVGCSE39itt+SxuvT2WiA9R
   2dBN46zgSG+Np6DCYmQFFLa44tKxdgpxFgRJPgyBnm042ILPHxvPOYGDM
   wiHrnysvLzXt3sJpIifdzp6X+62fy5abBMkT2p+lMBSnSJ/xypJOUdseG
   bGEKWT8LUjaTQ0G1UBtVTFyAeflh6OXGvbLw4OnTKtBu1Gyq+NjnQS3p9
   QyLTO1mzWmYzfOdDZIcSiGrx9/rLGbksmTaGSKoZ/eX71AXieSyZ6moqT
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10257"; a="233607713"
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="233607713"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 02:16:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,367,1635231600"; 
   d="scan'208";a="495384198"
Received: from unknown (HELO intel.com) ([10.237.72.65])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 02:16:22 -0800
Date:   Mon, 14 Feb 2022 12:16:36 +0200
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/6] drm/i915: Correctly populate use_sagv_wm for all
 pipes
Message-ID: <20220214101636.GA25003@intel.com>
References: <20220214091811.13725-1-ville.syrjala@linux.intel.com>
 <20220214091811.13725-2-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220214091811.13725-2-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 11:18:06AM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> When changing between SAGV vs. no SAGV on tgl+ we have to
> update the use_sagv_wm flag for all the crtcs or else
> an active pipe not already in the state will end up using
> the wrong watermarks. That is especially bad when we end up
> with the tighter non-SAGV watermarks with SAGV enabled.
> Usually ends up in underruns.

Probably valid point. Just noticed that we have this constant 
confusion, between cases when we have to update only crtc
which are added to the state(i.e only those which changed)
versus cases when everything has to be updated, regardless 
if its in the state or not.

I think it didn't ever caused underruns however, which is
strange - currently we mostly hit underruns once due to 
some PSR magic. Might be we just are lucky enough to get
all crtcs added to the state for some other reasons.

Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

Stan

> 
> Cc: stable@vger.kernel.org
> Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> Fixes: 7241c57d3140 ("drm/i915: Add TGL+ SAGV support")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/intel_pm.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
> index 1179bf31f743..d8eb553ffad3 100644
> --- a/drivers/gpu/drm/i915/intel_pm.c
> +++ b/drivers/gpu/drm/i915/intel_pm.c
> @@ -4009,6 +4009,17 @@ static int intel_compute_sagv_mask(struct intel_atomic_state *state)
>  			return ret;
>  	}
>  
> +	if (intel_can_enable_sagv(dev_priv, new_bw_state) !=
> +	    intel_can_enable_sagv(dev_priv, old_bw_state)) {
> +		ret = intel_atomic_serialize_global_state(&new_bw_state->base);
> +		if (ret)
> +			return ret;
> +	} else if (new_bw_state->pipe_sagv_reject != old_bw_state->pipe_sagv_reject) {
> +		ret = intel_atomic_lock_global_state(&new_bw_state->base);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	for_each_new_intel_crtc_in_state(state, crtc,
>  					 new_crtc_state, i) {
>  		struct skl_pipe_wm *pipe_wm = &new_crtc_state->wm.skl.optimal;
> @@ -4024,17 +4035,6 @@ static int intel_compute_sagv_mask(struct intel_atomic_state *state)
>  			intel_can_enable_sagv(dev_priv, new_bw_state);
>  	}
>  
> -	if (intel_can_enable_sagv(dev_priv, new_bw_state) !=
> -	    intel_can_enable_sagv(dev_priv, old_bw_state)) {
> -		ret = intel_atomic_serialize_global_state(&new_bw_state->base);
> -		if (ret)
> -			return ret;
> -	} else if (new_bw_state->pipe_sagv_reject != old_bw_state->pipe_sagv_reject) {
> -		ret = intel_atomic_lock_global_state(&new_bw_state->base);
> -		if (ret)
> -			return ret;
> -	}
> -
>  	return 0;
>  }
>  
> -- 
> 2.34.1
> 
