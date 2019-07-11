Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05968654DD
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 13:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfGKLB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 07:01:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:9065 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbfGKLB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jul 2019 07:01:26 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 04:01:25 -0700
X-IronPort-AV: E=Sophos;i="5.63,478,1557212400"; 
   d="scan'208";a="168599446"
Received: from rdvivi-losangeles.jf.intel.com (HELO intel.com) ([10.7.196.65])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 04:01:25 -0700
Date:   Thu, 11 Jul 2019 04:02:01 -0700
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Revert "drm/i915: Enable PSR2 by
 default"
Message-ID: <20190711110201.GD9599@intel.com>
References: <20190711092254.1719-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190711092254.1719-1-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 10:22:54AM +0100, Chris Wilson wrote:
> Multiple users are reporting black screens upon boot, after resume, or
> frozen after a short period of idleness. A black screen on boot is a
> critical issue so disable psr2 again until resolved.
> 
> This reverts commit 8f6e87d6d561f10cfa48a687345512419839b6d8.
> 
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111088

I agree it is critical, but unfortunately this revert won't solve the issue.

[    1.954886] [drm:intel_psr_init_dpcd [i915]] eDP panel supports PSR version 1
[    2.003686] [drm:intel_psr_enable_locked [i915]] Enabling PSR1

Users are claiming the regression is only on 5.2 with 5.1 working well
and PSR1 is enabled by default since 5.0.

A bisect would be good, but it seems a hard issue to reproduce as well
what makes things more difficult.

> Fixes: 8f6e87d6d561 ("drm/i915: Enable PSR2 by default")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
> Cc: José Roberto de Souza <jose.souza@intel.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: stable@vger.kernel.org #v5.2
> ---
>  drivers/gpu/drm/i915/display/intel_psr.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
> index 69d908e6a050..ddde4da2de33 100644
> --- a/drivers/gpu/drm/i915/display/intel_psr.c
> +++ b/drivers/gpu/drm/i915/display/intel_psr.c
> @@ -83,6 +83,9 @@ static bool intel_psr2_enabled(struct drm_i915_private *dev_priv,
>  	case I915_PSR_DEBUG_DISABLE:
>  	case I915_PSR_DEBUG_FORCE_PSR1:
>  		return false;
> +	case I915_PSR_DEBUG_DEFAULT:
> +		if (i915_modparams.enable_psr <= 0)
> +			return false;
>  	default:
>  		return crtc_state->has_psr2;
>  	}
> -- 
> 2.22.0
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
