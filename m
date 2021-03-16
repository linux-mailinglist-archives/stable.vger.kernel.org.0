Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F1C33DD18
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 20:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbhCPTF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 15:05:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:46564 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240263AbhCPTE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 15:04:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615921497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uyf6E+H1YXI0cL9QhZdsFGXH1uBKRc1Kbk7vPe0D4QU=;
        b=LGrMMbKyRb2b6FFkgR+sG8KdCwdkavBwtqJ4lXhQ7/WZlRl57kw4zBq9FoLPzTkvClzcr2
        j8ykwSOvCyG0F8QWahP0B6BO3ToT+Kv3+XQnRyvoa3QggFjqaOZVaTWkkxCTU0ZUhYe8bA
        l9tvmkxnJ3VkIG0yPlwajaJ3MhOCQVw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 37CE0AC24;
        Tue, 16 Mar 2021 19:04:57 +0000 (UTC)
Message-ID: <8bee31ec7d936b6b70549d35207aacbd40508dfd.camel@suse.com>
Subject: Re: drm/i915/ilk-glk: Fix link training on links with LTTPRs
From:   Santiago Zarate <santiago.zarate@suse.com>
To:     Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org
Cc:     Takashi Iwai <tiwai@suse.de>, stable@vger.kernel.org
Date:   Tue, 16 Mar 2021 20:04:56 +0100
In-Reply-To: <20210316165426.3388513-1-imre.deak@intel.com>
References: <20210316165426.3388513-1-imre.deak@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested-By: Santiago Zarate <santiago.zarate@suse.com>

Tested with kernel built in obs, see
https://apibugzilla.suse.com/show_bug.cgi?id=1183294#c19 for more
details

Regards, 

Santiago

On Tue, 2021-03-16 at 18:54 +0200, Imre Deak wrote:
> The spec requires to use at least 3.2ms for the AUX timeout period if
> there are LT-tunable PHY Repeaters on the link (2.11.2). An upcoming
> spec update makes this more specific, by requiring a 3.2ms minimum
> timeout period for the LTTPR detection reading the 0xF0000-0xF0007
> range (3.6.5.1).
> 
> Accordingly disable LTTPR detection until GLK, where the maximum
> timeout
> we can set is only 1.6ms.
> 
> Link training in the non-transparent mode is known to fail at least on
> some SKL systems with a WD19 dock on the link, which exposes an LTTPR
> (see the References below). While this could have different reasons
> besides the too short AUX timeout used, not detecting LTTPRs (and so
> not
> using the non-transparent LT mode) fixes link training on these
> systems.
> 
> While at it add a code comment about the platform specific maximum
> timeout values.
> 
> Reported-by: Takashi Iwai <tiwai@suse.de>
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/3166
> Fixes: b30edfd8d0b4 ("drm/i915: Switch to LTTPR non-transparent mode
> link training")
> Cc: <stable@vger.kernel.org> # v5.11
> Cc: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_dp_aux.c           | 7 +++++++
>  drivers/gpu/drm/i915/display/intel_dp_link_training.c | 8 ++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c
> b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> index eaebf123310a..b581e8acce07 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> @@ -133,6 +133,7 @@ static u32 g4x_get_aux_send_ctl(struct intel_dp
> *intel_dp,
>         else
>                 precharge = 5;
>  
> +       /* Max timeout value on ILK-BDW: 1.6ms */
>         if (IS_BROADWELL(dev_priv))
>                 timeout = DP_AUX_CH_CTL_TIME_OUT_600us;
>         else
> @@ -159,6 +160,12 @@ static u32 skl_get_aux_send_ctl(struct intel_dp
> *intel_dp,
>         enum phy phy = intel_port_to_phy(i915, dig_port->base.port);
>         u32 ret;
>  
> +       /*
> +        * Max timeout values:
> +        * SKL-GLK: 1.6ms
> +        * CNL: 3.2ms
> +        * ICL+: 4ms
> +        */
>         ret = DP_AUX_CH_CTL_SEND_BUSY |
>               DP_AUX_CH_CTL_DONE |
>               DP_AUX_CH_CTL_INTERRUPT |
> diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> index 19ba7c7cbaab..de6d70a29b47 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> @@ -123,10 +123,18 @@ intel_dp_set_lttpr_transparent_mode(struct
> intel_dp *intel_dp, bool enable)
>   */
>  int intel_dp_lttpr_init(struct intel_dp *intel_dp)
>  {
> +       struct drm_i915_private *i915 = dp_to_i915(intel_dp);
>         int lttpr_count;
>         bool ret;
>         int i;
>  
> +       /*
> +        * Detecting LTTPRs must be avoided on platforms with an AUX
> timeout
> +        * period < 3.2ms. (see DP Standard v2.0, 2.11.2, 3.6.6.1).
> +        */
> +       if (INTEL_GEN(i915) < 10)
> +               return 0;
> +
>         if (intel_dp_is_edp(intel_dp))
>                 return 0;
>  


