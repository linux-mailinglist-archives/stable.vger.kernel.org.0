Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C242A0828
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 15:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgJ3Onu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 10:43:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:62349 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbgJ3Onu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 10:43:50 -0400
IronPort-SDR: wR6JV0c4TYxhP3zU0Q0wgudr709aJi/z9/mxMawCsdntsjekn1fJzbYqv7h6uWwo65Y/FZqR5d
 tiDgl55AhbMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="253323613"
X-IronPort-AV: E=Sophos;i="5.77,433,1596524400"; 
   d="scan'208";a="253323613"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2020 07:43:49 -0700
IronPort-SDR: 3sNntcel3Mt5MdolL+3ZJfoZkbkDPOMwyJKTBvktwKLoWskwvT/ejKmqeo6P+0xe+PIdt4ohQs
 mXOnfaPGEUjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,433,1596524400"; 
   d="scan'208";a="361866344"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 30 Oct 2020 07:43:47 -0700
Received: by stinkbox (sSMTP sendmail emulation); Fri, 30 Oct 2020 16:43:46 +0200
Date:   Fri, 30 Oct 2020 16:43:46 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/modes: Switch to 64bit maths to avoid integer
 overflow
Message-ID: <20201030144346.GJ6112@intel.com>
References: <20201022194256.30978-1-ville.syrjala@linux.intel.com>
 <160406758530.15070.9622609556730885347@build.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160406758530.15070.9622609556730885347@build.alporthouse.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 02:19:45PM +0000, Chris Wilson wrote:
> Quoting Ville Syrjala (2020-10-22 20:42:56)
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > The new >8k CEA modes have dotclocks reaching 5.94 GHz, which
> > means our clock*1000 will now overflow the 32bit unsigned
> > integer. Switch to 64bit maths to avoid it.
> > 
> > Cc: stable@vger.kernel.org
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> > An interesting question how many other place might suffer from similar
> > overflows. I think i915 should be mostly OK. The one place I know we use
> > Hz instead kHz is the hsw DPLL code, which I would prefer we also change
> > to use kHz. The other concern is whether we have any potential overflows
> > before we check this against the platform's max dotclock.
> > 
> > I do have this unreviewed igt series 
> > https://patchwork.freedesktop.org/series/69531/ which extends the
> > current testing with some other forms of invalid modes. Could probably
> > extend that with a mode.clock=INT_MAX test to see if anything else might
> > trip up.
> > 
> > No idea about other drivers.
> > 
> >  drivers/gpu/drm/drm_modes.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
> > index 501b4fe55a3d..511cde5c7fa6 100644
> > --- a/drivers/gpu/drm/drm_modes.c
> > +++ b/drivers/gpu/drm/drm_modes.c
> > @@ -762,7 +762,7 @@ int drm_mode_vrefresh(const struct drm_display_mode *mode)
> >         if (mode->htotal == 0 || mode->vtotal == 0)
> >                 return 0;
> >  
> > -       num = mode->clock * 1000;
> > +       num = mode->clock;
> >         den = mode->htotal * mode->vtotal;
> 
> You don't want to promote den to u64 while you are here? We are at
> 8kx4k, throw in dblscan and some vscan, and we could soon have wacky
> refresh rates.

i915 has 16kx8k hard limit currently, and we reject vscan>1
(wish we could also reject DBLSCAN). So we should not hit
that, at least not yet. Other drivers might not be so strict
I guess.

I have a nagging feeling that other places are in danger of
overflows if we try to push the current limits significantly.
But I guess no real harm in going full 64bit here, except
maybe making it a bit slower.

-- 
Ville Syrjälä
Intel
