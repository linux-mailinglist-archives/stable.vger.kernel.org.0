Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073EC4BA83E
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 19:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbiBQS34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 13:29:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiBQS3z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 13:29:55 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5F93899
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 10:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645122580; x=1676658580;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZESTdfIDbSmIb9I/yPThSPDo6X1sZN0f05BAmB7Yonw=;
  b=nAzGZIz75q8ymuKtFgH/MCVHcYxhJnPjflSqKLhTwWdrroOcjdHt1ou9
   Fr4BSNGdmJ3AXPRlQlJoXPiGxFwTWE4tdrtc1B0iIoQx7fGJY8FoCdfX0
   +MnPocXhGAeXQ45CoAyelR5haB0ipK3J3KUww1xezXNxigOSIDN/g6wMQ
   vAersf2XCb3CmhUPKxw6HG1xkd/Nm3g1i97PCV33w8Lk5rf4olYKICFRL
   tJXt/RQUszHOasC9jfOL22xwx0QHuR6G1hncTHc99iLZdKd+zYocLQEdB
   G/vKPgVg4PiUuZ4E1ocgyEmJLIHRhEawLeuj/+e/SEL95sAxdopeU6Dxn
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="311686338"
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="311686338"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 10:29:40 -0800
X-IronPort-AV: E=Sophos;i="5.88,376,1635231600"; 
   d="scan'208";a="704941052"
Received: from unknown (HELO intel.com) ([10.237.72.65])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 10:29:39 -0800
Date:   Thu, 17 Feb 2022 20:29:53 +0200
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/6] drm/i915: Fix bw atomic check when switching
 between SAGV vs. no SAGV
Message-ID: <20220217182953.GA3823@intel.com>
References: <20220216174250.4449-1-ville.syrjala@linux.intel.com>
 <20220216174250.4449-3-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216174250.4449-3-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 16, 2022 at 07:42:46PM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> If the only thing that is changing is SAGV vs. no SAGV but
> the number of active planes and the total data rates end up
> unchanged we currently bail out of intel_bw_atomic_check()
> early and forget to actually compute the new WGV point
> mask and thus won't actually enable/disable SAGV as requested.
> This ends up poorly if we end up running with SAGV enabled
> when we shouldn't. Usually ends up in underruns.
> To fix this let's go through the QGV point mask computation
> if anyone else already added the bw state for us.
> 
> Cc: stable@vger.kernel.org
> Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> Fixes: 20f505f22531 ("drm/i915: Restrict qgv points which don't have enough bandwidth.")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>


Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_bw.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_bw.c b/drivers/gpu/drm/i915/display/intel_bw.c
> index 23aa8e06de18..d72ccee7d53b 100644
> --- a/drivers/gpu/drm/i915/display/intel_bw.c
> +++ b/drivers/gpu/drm/i915/display/intel_bw.c
> @@ -846,6 +846,13 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
>  	if (num_psf_gv_points > 0)
>  		mask |= REG_GENMASK(num_psf_gv_points - 1, 0) << ADLS_PSF_PT_SHIFT;
>  
> +	/*
> +	 * If we already have the bw state then recompute everything
> +	 * even if pipe data_rate / active_planes didn't change.
> +	 * Other things (such as SAGV) may have changed.
> +	 */
> +	new_bw_state = intel_atomic_get_new_bw_state(state);
> +
>  	for_each_oldnew_intel_crtc_in_state(state, crtc, old_crtc_state,
>  					    new_crtc_state, i) {
>  		unsigned int old_data_rate =
> -- 
> 2.34.1
> 
