Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695DA342709
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 21:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhCSUiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 16:38:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:6677 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230218AbhCSUiQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 16:38:16 -0400
IronPort-SDR: U9DPkm02JEwcv6Is613IdhD8AL+2uTs44vMXWfS4R8v0a90V+/F70js5YlIFLnPUj0HCHA+T4r
 DSz1ZtGBv+6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="189999611"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="189999611"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 13:38:16 -0700
IronPort-SDR: ZtW1sZ2GZPxnsYeWWy1Bb8hEipWx5hzJC4WehDcyQhpjX+Yja/3+kaOq/cuCHR+cJJzwZtEa5/
 daiwoSGyomMA==
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="450994903"
Received: from labuser-z97x-ud5h.jf.intel.com (HELO labuser-Z97X-UD5H) ([10.165.21.211])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 13:38:16 -0700
Date:   Fri, 19 Mar 2021 13:44:27 -0700
From:   "Navare, Manasi" <manasi.d.navare@intel.com>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Animesh Manna <animesh.manna@intel.com>,
        Vandita Kulkarni <vandita.kulkarni@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/dsc: fix DSS CTL register usage for ICL DSI
 transcoders
Message-ID: <20210319204421.GA6043@labuser-Z97X-UD5H>
References: <20210319115333.8330-1-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319115333.8330-1-jani.nikula@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 01:53:33PM +0200, Jani Nikula wrote:
> Use the correct DSS CTL registers for ICL DSI transcoders.
> 
> As a side effect, this also brings back the sanity check for trying to
> use pipe DSC registers on pipe A on ICL.
> 
> Fixes: 8a029c113b17 ("drm/i915/dp: Modify VDSC helpers to configure DSC for Bigjoiner slave")
> References: http://lore.kernel.org/r/87eegxq2lq.fsf@intel.com

Thanks Jani for the detailed review comments here and explanation on what
broke the DSI DSC on < Gen 12 platforms.

> Cc: Manasi Navare <manasi.d.navare@intel.com>
> Cc: Animesh Manna <animesh.manna@intel.com>
> Cc: Vandita Kulkarni <vandita.kulkarni@intel.com>
> Cc: <stable@vger.kernel.org> # v5.11+
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> 
> ---
> 
> Untested, I don't have the platform.
> ---
>  drivers/gpu/drm/i915/display/intel_vdsc.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_vdsc.c b/drivers/gpu/drm/i915/display/intel_vdsc.c
> index f58cc5700784..a86c57d117f2 100644
> --- a/drivers/gpu/drm/i915/display/intel_vdsc.c
> +++ b/drivers/gpu/drm/i915/display/intel_vdsc.c
> @@ -1014,20 +1014,14 @@ static i915_reg_t dss_ctl1_reg(const struct intel_crtc_state *crtc_state)
>  {
>  	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
>  
> -	if (crtc_state->cpu_transcoder == TRANSCODER_EDP)
> -		return DSS_CTL1;
> -
> -	return ICL_PIPE_DSS_CTL1(pipe);
> +	return is_pipe_dsc(crtc_state) ? ICL_PIPE_DSS_CTL1(pipe) : DSS_CTL1;

Yes using is_pipe_dsc() makes sense here in order to select proper DSS_CTL regs
for DSI.

Reviewed-by: Manasi Navare <manasi.d.navare@intel.com>

Manasi

>  }
>  
>  static i915_reg_t dss_ctl2_reg(const struct intel_crtc_state *crtc_state)
>  {
>  	enum pipe pipe = to_intel_crtc(crtc_state->uapi.crtc)->pipe;
>  
> -	if (crtc_state->cpu_transcoder == TRANSCODER_EDP)
> -		return DSS_CTL2;
> -
> -	return ICL_PIPE_DSS_CTL2(pipe);
> +	return is_pipe_dsc(crtc_state) ? ICL_PIPE_DSS_CTL2(pipe) : DSS_CTL2;
>  }
>  
>  void intel_dsc_enable(struct intel_encoder *encoder,
> -- 
> 2.20.1
> 
