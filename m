Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53FBD6D294
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 19:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfGRRLN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 18 Jul 2019 13:11:13 -0400
Received: from mail.fireflyinternet.com ([109.228.58.192]:53254 "EHLO
        fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727623AbfGRRLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 13:11:13 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 17405310-1500050 
        for multiple; Thu, 18 Jul 2019 18:11:10 +0100
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
From:   Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20190717114536.22937-1-ville.syrjala@linux.intel.com>
Cc:     Stefan Gottwald <gottwald@igel.com>, stable@vger.kernel.org
References: <20190717114536.22937-1-ville.syrjala@linux.intel.com>
Message-ID: <156346986821.24728.11327521093920045776@skylake-alporthouse-com>
User-Agent: alot/0.6
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Make sure cdclk is high enough for DP
 audio on VLV/CHV
Date:   Thu, 18 Jul 2019 18:11:08 +0100
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Ville Syrjala (2019-07-17 12:45:36)
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> On VLV/CHV there is some kind of linkage between the cdclk frequency
> and the DP link frequency. The spec says:
> "For DP audio configuration, cdclk frequency shall be set to
>  meet the following requirements:
>  DP Link Frequency(MHz) | Cdclk frequency(MHz)
>  270                    | 320 or higher
>  162                    | 200 or higher"
> 
> I suspect that would more accurately be expressed as
> "cdclk >= DP link clock", and in any case we can express it like
> that in the code because of the limited set of cdclk and link
> frequencies we support.
> 
> Without this we can end up in a situation where the cdclk
> is too low and enabling DP audio will kill the pipe. Happens
> eg. with 2560x1440 modes where the 266MHz cdclk is sufficient
> to pump the pixels (241.5 MHz dotclock) but is too low for
> the DP audio due to the link frequency being 270 MHz.
> 
> Cc: stable@vger.kernel.org
> Tested-by: Stefan Gottwald <gottwald@igel.com>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111149
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_cdclk.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_cdclk.c b/drivers/gpu/drm/i915/display/intel_cdclk.c
> index d0581a1ac243..93b0d190c184 100644
> --- a/drivers/gpu/drm/i915/display/intel_cdclk.c
> +++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
> @@ -2262,6 +2262,17 @@ int intel_crtc_compute_min_cdclk(const struct intel_crtc_state *crtc_state)
>         if (crtc_state->has_audio && INTEL_GEN(dev_priv) >= 9)
>                 min_cdclk = max(2 * 96000, min_cdclk);
>  
> +       /*
> +        * "For DP audio configuration, cdclk frequency shall be set to
> +        *  meet the following requirements:
> +        *  DP Link Frequency(MHz) | Cdclk frequency(MHz)
> +        *  270                    | 320 or higher
> +        *  162                    | 200 or higher"
> +        */
> +       if ((IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv)) &&
> +           intel_crtc_has_dp_encoder(crtc_state) && crtc_state->has_audio)
> +               min_cdclk = max(crtc_state->port_clock, min_cdclk);

I tracked port_clock down to being the dp link clock (162 or 270) so
that part of the story checks out.

Judging by the rest of the function, I buy that the cdclk and link clock
may be inscrutably tied together, and accept the test result that the
cdclk must be at least the link clock with audio enabled.

It may be that a corner case does require a higher frequency (rather
than just bumping from 266 to 270), but for here and now
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris
