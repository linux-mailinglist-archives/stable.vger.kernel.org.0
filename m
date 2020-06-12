Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806961F78A5
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 15:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgFLNSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 09:18:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:38050 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgFLNSv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 09:18:51 -0400
IronPort-SDR: +7Fv6QmoLVygIsD/iQi0rb7MfGgSzEwZqLCxGHHoLqyGh5FXZU0OdBpdQKYHMTKpx+Mq+0hF5J
 XaOSR0xMWk2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2020 06:18:51 -0700
IronPort-SDR: qETB9wsTG2QDem+fXPVyRz5ckcGm36fR/YJhjv0zbtrjKUe5jpGoqdTBqvdZOiBZzN6OkrOvul
 5GpZ1cUWwUUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,503,1583222400"; 
   d="scan'208";a="315129349"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 12 Jun 2020 06:18:48 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 12 Jun 2020 16:18:48 +0300
Date:   Fri, 12 Jun 2020 16:18:48 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Imre Deak <imre.deak@intel.com>
Cc:     intel-gfx@lists.freedesktop.org,
        Kunal Joshi <kunal1.joshi@intel.com>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/icl+: Fix hotplug interrupt
 disabling after storm detection
Message-ID: <20200612131848.GH6112@intel.com>
References: <20200612121731.19596-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200612121731.19596-1-imre.deak@intel.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 03:17:31PM +0300, Imre Deak wrote:
> Atm, hotplug interrupts on TypeC ports are left enabled after detecting
> an interrupt storm, fix this.
> 
> Reported-by: Kunal Joshi <kunal1.joshi@intel.com>
> References: https://gitlab.freedesktop.org/drm/intel/-/issues/351
> Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/1964
> Cc: Kunal Joshi <kunal1.joshi@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_irq.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index 8e823ba25f5f..710224d930c5 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -3132,6 +3132,7 @@ static void gen11_hpd_irq_setup(struct drm_i915_private *dev_priv)
>  
>  	val = I915_READ(GEN11_DE_HPD_IMR);
>  	val &= ~hotplug_irqs;
> +	val |= ~enabled_irqs & hotplug_irqs;
>  	I915_WRITE(GEN11_DE_HPD_IMR, val);
>  	POSTING_READ(GEN11_DE_HPD_IMR);

Wondering if we should add a function for this just
for consistency with all the other platforms. Alhthough
we don't strictly need one since we have no other users
of this register. So maybe not.

Anyways, patch is
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>

>  
> -- 
> 2.23.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Ville Syrjälä
Intel
