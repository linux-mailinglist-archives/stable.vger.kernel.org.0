Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31DE26D370
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 20:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfGRSFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 14:05:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:32499 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbfGRSFA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 14:05:00 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 11:04:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,279,1559545200"; 
   d="scan'208";a="169925652"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by fmsmga007.fm.intel.com with SMTP; 18 Jul 2019 11:04:56 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 18 Jul 2019 21:04:56 +0300
Date:   Thu, 18 Jul 2019 21:04:56 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org,
        Stefan Gottwald <gottwald@igel.com>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Make sure cdclk is high enough for
 DP audio on VLV/CHV
Message-ID: <20190718180456.GE5942@intel.com>
References: <20190717114536.22937-1-ville.syrjala@linux.intel.com>
 <156346986821.24728.11327521093920045776@skylake-alporthouse-com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <156346986821.24728.11327521093920045776@skylake-alporthouse-com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 06:11:08PM +0100, Chris Wilson wrote:
> Quoting Ville Syrjala (2019-07-17 12:45:36)
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > On VLV/CHV there is some kind of linkage between the cdclk frequency
> > and the DP link frequency. The spec says:
> > "For DP audio configuration, cdclk frequency shall be set to
> >  meet the following requirements:
> >  DP Link Frequency(MHz) | Cdclk frequency(MHz)
> >  270                    | 320 or higher
> >  162                    | 200 or higher"
> > 
> > I suspect that would more accurately be expressed as
> > "cdclk >= DP link clock", and in any case we can express it like
> > that in the code because of the limited set of cdclk and link
> > frequencies we support.
> > 
> > Without this we can end up in a situation where the cdclk
> > is too low and enabling DP audio will kill the pipe. Happens
> > eg. with 2560x1440 modes where the 266MHz cdclk is sufficient
> > to pump the pixels (241.5 MHz dotclock) but is too low for
> > the DP audio due to the link frequency being 270 MHz.
> > 
> > Cc: stable@vger.kernel.org
> > Tested-by: Stefan Gottwald <gottwald@igel.com>
> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111149
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> >  drivers/gpu/drm/i915/display/intel_cdclk.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/display/intel_cdclk.c b/drivers/gpu/drm/i915/display/intel_cdclk.c
> > index d0581a1ac243..93b0d190c184 100644
> > --- a/drivers/gpu/drm/i915/display/intel_cdclk.c
> > +++ b/drivers/gpu/drm/i915/display/intel_cdclk.c
> > @@ -2262,6 +2262,17 @@ int intel_crtc_compute_min_cdclk(const struct intel_crtc_state *crtc_state)
> >         if (crtc_state->has_audio && INTEL_GEN(dev_priv) >= 9)
> >                 min_cdclk = max(2 * 96000, min_cdclk);
> >  
> > +       /*
> > +        * "For DP audio configuration, cdclk frequency shall be set to
> > +        *  meet the following requirements:
> > +        *  DP Link Frequency(MHz) | Cdclk frequency(MHz)
> > +        *  270                    | 320 or higher
> > +        *  162                    | 200 or higher"
> > +        */
> > +       if ((IS_VALLEYVIEW(dev_priv) || IS_CHERRYVIEW(dev_priv)) &&
> > +           intel_crtc_has_dp_encoder(crtc_state) && crtc_state->has_audio)
> > +               min_cdclk = max(crtc_state->port_clock, min_cdclk);
> 
> I tracked port_clock down to being the dp link clock (162 or 270) so
> that part of the story checks out.
> 
> Judging by the rest of the function, I buy that the cdclk and link clock
> may be inscrutably tied together, and accept the test result that the
> cdclk must be at least the link clock with audio enabled.
> 
> It may be that a corner case does require a higher frequency (rather
> than just bumping from 266 to 270), but for here and now

Yeah there could be some extra headroom required. But our cdclk
can only be 200, 266, 320 or 400 MHz (and 200 won't actually get used
due to inexplicable display failure when try to use it). So in practice
we going to actually get bumped 162->266 and 270->320 here. I should
have expressed that better in the commit message.

> Acked-by: Chris Wilson <chris@chris-wilson.co.uk>

Thanks. I amended the explanation a bit and pushed to dinq.

-- 
Ville Syrjälä
Intel
