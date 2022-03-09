Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5764D3958
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 19:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbiCITAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiCITAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:00:36 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623709E57D
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 10:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646852377; x=1678388377;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=p/eiDETu/mTqfvyDVjzbt5AGoIF2xiYOgPu8BrcsE8U=;
  b=OwLS3eX+eSFWRiWE9KqAiZqLNLdOFjcZXU8Icd6TjQjkQW2rxJwHE86S
   wGwLENNvKLLloXN5Jbffl7YsOUXNBpKP5KleEIx5e/D+19gQeGz0v2b0e
   fEK7EE8uV0eezoy5pSkjVJ7L8oIAc/hKcPrwC496ov9v0cREOIAtp7NzS
   p1eHr0+6WiX8MB/lZKNjxy35lev/g9giPY7mpHvxHrZ3Haa/W5BN3Ii6Z
   u2JAfi+hqi5ahVGHxmbKVMBWwl+Qs/x8ZMA9GesJfFYiQ38n7XFqhaueT
   x0G5P7INEBSBKgIblEzRfe/ejDJ5jdbYFgQ5enX3yaCgQ8SFocbYkPven
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="315781998"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="315781998"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 10:59:36 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="554249784"
Received: from unknown (HELO intel.com) ([10.237.72.65])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 10:59:35 -0800
Date:   Wed, 9 Mar 2022 20:59:59 +0200
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 6/8] drm/i915: Fix PSF GV point mask when SAGV is not
 possible
Message-ID: <20220309185959.GA9439@intel.com>
References: <20220309164948.10671-1-ville.syrjala@linux.intel.com>
 <20220309164948.10671-7-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220309164948.10671-7-ville.syrjala@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 06:49:46PM +0200, Ville Syrjala wrote:
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Don't just mask off all the PSF GV points when SAGV gets disabled.
> This should in fact cause the Pcode to reject the request since
> at least one PSF point must remain enabled at all times.

Good point, however I think this is not the full fix:

BSpec says:

"At least one GV point of each type must always remain unmasked."

and

"The GV point of each type providing the highest bandwidth 
 for display must always remain unmasked."

So I guess we should then also choose thr PSF GV point with
the highest bandwidth as well.

Stan


> 
> Cc: stable@vger.kernel.org
> Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
> Fixes: 192fbfb76744 ("drm/i915: Implement PSF GV point support")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_bw.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_bw.c b/drivers/gpu/drm/i915/display/intel_bw.c
> index ad1564ca7269..adf58c58513b 100644
> --- a/drivers/gpu/drm/i915/display/intel_bw.c
> +++ b/drivers/gpu/drm/i915/display/intel_bw.c
> @@ -992,7 +992,8 @@ int intel_bw_atomic_check(struct intel_atomic_state *state)
>  	 * cause.
>  	 */
>  	if (!intel_can_enable_sagv(dev_priv, new_bw_state)) {
> -		allowed_points = BIT(max_bw_point);
> +		allowed_points &= ADLS_PSF_PT_MASK;
> +		allowed_points |= BIT(max_bw_point);
>  		drm_dbg_kms(&dev_priv->drm, "No SAGV, using single QGV point %d\n",
>  			    max_bw_point);
>  	}
> -- 
> 2.34.1
> 
