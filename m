Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D366167D444
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 19:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjAZSf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 13:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjAZSf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 13:35:58 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CB637F14
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 10:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674758157; x=1706294157;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=zM9He63UWNCs7R2yKxiBXX0qwpN+VmtHbOyPH9x8kz4=;
  b=ZhG7S28+lcbbc8FhFLZIHElANwtN2Od/slVbgVrX848fkbHvuGxUP7rI
   iIQEzycvSfNGuGRkZD3S47TlMU/U5iMjdIWsc0EONzVMmOtNNs5fnMn+7
   5UKJ85hhOKWgmfZkkie+79RasRFvfeOG26jKiWK6qJYNwed4woBC0vkRd
   TtRdeemL17v9gAFwGInvVyAPUxTXwqUPIgNUxIifsBBW8CPpe+nJsgipz
   tSDnhXBY7Hmu24mq5EBdjl3OHTO7PSgqOSwuapZWCoSykB/4KkpykyJD5
   l7zPwYdFGJiMUit3r9JjDVqsL0vq5I6OVENTLj9bajlkNaFvTRSPT8D9M
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="310505281"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="310505281"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:34:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="695221555"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="695221555"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.55])
  by orsmga001.jf.intel.com with SMTP; 26 Jan 2023 10:34:28 -0800
Received: by stinkbox (sSMTP sendmail emulation); Thu, 26 Jan 2023 20:34:28 +0200
Date:   Thu, 26 Jan 2023 20:34:28 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Imre Deak <imre.deak@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v2 1/9] drm/i915/dp_mst: Add the MST topology
 state for modesetted CRTCs
Message-ID: <Y9LHtN4I40fR92k+@intel.com>
References: <20230125114852.748337-2-imre.deak@intel.com>
 <20230126091310.1154148-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230126091310.1154148-1-imre.deak@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 26, 2023 at 11:13:10AM +0200, Imre Deak wrote:
> Add the MST topology for a CRTC to the atomic state if the driver
> needs to force a modeset on the CRTC after the encoder compute config
> functions are called.
> 
> Later the MST encoder's disable hook also adds the state, but that isn't
> guaranteed to work (since in that hook getting the state may fail, which
> can't be handled there). This should fix that, while a later patch fixes
> the use of the MST state in the disable hook.
> 
> v2: Add missing forward struct declartions, caught by hdrtest.
> 
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: stable@vger.kernel.org # 6.1
> Signed-off-by: Imre Deak <imre.deak@intel.com>

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_display.c |  4 +++
>  drivers/gpu/drm/i915/display/intel_dp_mst.c  | 37 ++++++++++++++++++++
>  drivers/gpu/drm/i915/display/intel_dp_mst.h  |  4 +++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> index 717ca3d7890d3..d3994e2a7d636 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -5934,6 +5934,10 @@ int intel_modeset_all_pipes(struct intel_atomic_state *state,
>  		if (ret)
>  			return ret;
>  
> +		ret = intel_dp_mst_add_topology_state_for_crtc(state, crtc);
> +		if (ret)
> +			return ret;
> +
>  		ret = intel_atomic_add_affected_planes(state, crtc);
>  		if (ret)
>  			return ret;
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> index 8b0e4defa3f10..ba29c294b7c1b 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
> @@ -1223,3 +1223,40 @@ bool intel_dp_mst_is_slave_trans(const struct intel_crtc_state *crtc_state)
>  	return crtc_state->mst_master_transcoder != INVALID_TRANSCODER &&
>  	       crtc_state->mst_master_transcoder != crtc_state->cpu_transcoder;
>  }
> +
> +/**
> + * intel_dp_mst_add_topology_state_for_crtc - add MST topology state for a CRTC
> + * @state: atomic state
> + * @crtc: CRTC
> + *
> + * Add the MST topology state for @crtc to @state.
> + *
> + * Returns 0 on success, negative error code on failure.
> + */
> +int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state *state,
> +					     struct intel_crtc *crtc)
> +{
> +	struct drm_connector *_connector;
> +	struct drm_connector_state *conn_state;
> +	int i;
> +
> +	for_each_new_connector_in_state(&state->base, _connector, conn_state, i) {
> +		struct drm_dp_mst_topology_state *mst_state;
> +		struct intel_connector *connector = to_intel_connector(_connector);
> +
> +		if (conn_state->crtc != &crtc->base)
> +			continue;
> +
> +		if (!connector->mst_port)
> +			continue;
> +
> +		mst_state = drm_atomic_get_mst_topology_state(&state->base,
> +							      &connector->mst_port->mst_mgr);
> +		if (IS_ERR(mst_state))
> +			return PTR_ERR(mst_state);
> +
> +		mst_state->pending_crtc_mask |= drm_crtc_mask(&crtc->base);
> +	}
> +
> +	return 0;
> +}
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.h b/drivers/gpu/drm/i915/display/intel_dp_mst.h
> index f7301de6cdfb3..f1815bb722672 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_mst.h
> +++ b/drivers/gpu/drm/i915/display/intel_dp_mst.h
> @@ -8,6 +8,8 @@
>  
>  #include <linux/types.h>
>  
> +struct intel_atomic_state;
> +struct intel_crtc;
>  struct intel_crtc_state;
>  struct intel_digital_port;
>  struct intel_dp;
> @@ -18,5 +20,7 @@ int intel_dp_mst_encoder_active_links(struct intel_digital_port *dig_port);
>  bool intel_dp_mst_is_master_trans(const struct intel_crtc_state *crtc_state);
>  bool intel_dp_mst_is_slave_trans(const struct intel_crtc_state *crtc_state);
>  bool intel_dp_mst_source_support(struct intel_dp *intel_dp);
> +int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state *state,
> +					     struct intel_crtc *crtc);
>  
>  #endif /* __INTEL_DP_MST_H__ */
> -- 
> 2.37.1

-- 
Ville Syrjälä
Intel
