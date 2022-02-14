Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F98F4B5854
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343740AbiBNRRa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 12:17:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242400AbiBNRR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 12:17:29 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C70149FB8
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 09:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644859041; x=1676395041;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=rdU8K9FsX9XyQYq9NprInI1xXPNrp55CNAt/hDfMzUI=;
  b=cnLTQKPmS21L1mwU2YJ2/GDWViGj8RQ1jz1ibobBTBNX4BzMW62of7MS
   vq/XVT41bnAlPKjQ+4WZYeirxhQsHU8TjkkMn1fab/oSjQRgf9nDNl797
   iBEUcPHVqaLW4Joen6IVcMOBpYtSgNpi91Bfpj4Nw0fnbhG+3XyqS+AQ6
   F7wnyQnBMq7AHUXgE0iNE35JxrGaJY4Nwd5lOQPoNKNYNiKxLiwtSeBjc
   Q8U4nDs74gMvvROwdEvx17HJBCOlI778LS4EAKEp+ne4VI7tIFpv9TtOS
   G6Gvi1bkQKNrFoFLemujr2hODGCeXAnH6/zsY2SYDFf/F+/y90pvbMccD
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="247732250"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="247732250"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 09:17:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="495836780"
Received: from unknown (HELO intel.com) ([10.237.72.65])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 09:17:18 -0800
Date:   Mon, 14 Feb 2022 19:17:32 +0200
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/6] drm/i915: Widen the QGV point mask
Message-ID: <20220214171732.GA25816@intel.com>
References: <20220214091811.13725-1-ville.syrjala@linux.intel.com>
 <20220214091811.13725-4-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220214091811.13725-4-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 14, 2022 at 11:18:08AM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> adlp+ adds some extra bits to the QGV point mask. The code attempts
> to handle that but forgot to actually make sure we can store those
> bits in the bw state. Fix it.
> 
> Cc: stable@vger.kernel.org
> Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> Fixes: 192fbfb76744 ("drm/i915: Implement PSF GV point support")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_bw.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_bw.h b/drivers/gpu/drm/i915/display/intel_bw.h
> index 46c6eecbd917..0ceaed1c9656 100644
> --- a/drivers/gpu/drm/i915/display/intel_bw.h
> +++ b/drivers/gpu/drm/i915/display/intel_bw.h
> @@ -30,19 +30,19 @@ struct intel_bw_state {
>  	 */
>  	u8 pipe_sagv_reject;
>  
> +	/* bitmask of active pipes */
> +	u8 active_pipes;
> +
>  	/*
>  	 * Current QGV points mask, which restricts
>  	 * some particular SAGV states, not to confuse
>  	 * with pipe_sagv_mask.
>  	 */
> -	u8 qgv_points_mask;
> +	u16 qgv_points_mask;

Weird, that this went unnoticed. Don't we have static analyzer for such
purposes? Wonder if it should catch and warn about this, because in
intel_bw_atomic_check we have u32 bitmask, which is then getting packed
in 8 bit field.
Probably bitmask type width used in intel_bw_atomic_check should match
that one, so that there would be less room for confusion.

Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

>  
>  	unsigned int data_rate[I915_MAX_PIPES];
>  	u8 num_active_planes[I915_MAX_PIPES];
>  
> -	/* bitmask of active pipes */
> -	u8 active_pipes;
> -
>  	int min_cdclk;
>  };
>  
> -- 
> 2.34.1
> 
