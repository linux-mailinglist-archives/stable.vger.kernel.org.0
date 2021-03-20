Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B938342BA8
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhCTLM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:12:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:2210 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhCTLMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Mar 2021 07:12:05 -0400
IronPort-SDR: aBFXi6r/yM+eIRQ5XF0aMH5bm6fyFeob7L9lfG9Ogs6zK0pbabAthaTV9q25T5qLLVpz6Yn10g
 RrL9TwPw1Ssw==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="210061161"
X-IronPort-AV: E=Sophos;i="5.81,264,1610438400"; 
   d="scan'208";a="210061161"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2021 00:45:17 -0700
IronPort-SDR: d2LX6O7IdrbwDk02cN8ollVqye0QMxAiRKk3aAy/1gH9C7q/2fxdcN9d9O3hpu+xprts+uaDM/
 jrpCP3FL2JLA==
X-IronPort-AV: E=Sophos;i="5.81,264,1610438400"; 
   d="scan'208";a="413794319"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2021 00:45:15 -0700
Date:   Sat, 20 Mar 2021 09:45:11 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     "Almahallawy, Khaled" <khaled.almahallawy@intel.com>
Cc:     "lyude@redhat.com" <lyude@redhat.com>,
        "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "mail@bodograumann.de" <mail@bodograumann.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "santiago.zarate@suse.com" <santiago.zarate@suse.com>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: Re: [PATCH v2 1/3] drm/i915/ilk-glk: Fix link training on links with
 LTTPRs
Message-ID: <20210320074511.GB361797@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210318174907.GE4128033@ideak-desk.fi.intel.com>
 <20210318180645.GG4128033@ideak-desk.fi.intel.com>
 <e1e9f9ea76071af914b37352fc201d09f378a55b.camel@intel.com>
 <20210318231749.GA23036@ideak-desk.fi.intel.com>
 <ce79f22e1f7f7e6bf4424e5f9d2d657d8215480d.camel@redhat.com>
 <20210319172941.GI94006@ideak-desk.fi.intel.com>
 <b5d3fce1421f152db70a775241739df7d7dd364f.camel@redhat.com>
 <20210319210715.GP94006@ideak-desk.fi.intel.com>
 <20210320071538.GA361797@ideak-desk.fi.intel.com>
 <3dc2e6acda0cfc98efb79931f1241969a9b69712.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3dc2e6acda0cfc98efb79931f1241969a9b69712.camel@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 20, 2021 at 09:40:52AM +0200, Almahallawy, Khaled wrote:
> On Sat, 2021-03-20 at 09:15 +0200, Imre Deak wrote:
> > On Fri, Mar 19, 2021 at 11:07:21PM +0200, Imre Deak wrote:
> > > On Fri, Mar 19, 2021 at 04:44:26PM -0400, Lyude Paul wrote:
> > > > > > > [...]
> > > > > > > I think it would work if we can make the retries
> > > > > > > configurable and set it
> > > > > > > to
> > > > > > >         retries = total_timeout /
> > > > > > > platform_specific_timeout_per_retry
> > > > > > >
> > > > > > > where total_timeout would be something reasonable like 1
> > > > > > > sec.
> > > > > >
> > > > > > I actually think I'm more open to the idea of configurable
> > > > > > retries after
> > > > > > learning that apparently this is a thing that the i2c
> > > > > > subsystem does - so
> > > > > > there's more precedence for it in the rest of the kernel than
> > > > > > I originally
> > > > > > thought.
> > > > > >
> > > > > > I'm still curious if we need these extra retries in here
> > > > > > though - there seems
> > > > > > to
> > > > > > be one set of retries that is actually platform specific, and
> > > > > > then just a
> > > > > > random
> > > > > > set of 5 retries that don't seem to have anything to do with
> > > > > > platform specific
> > > > > > behavior - so I think it'd still be worth giving a shot at
> > > > > > getting rid of that
> > > > >
> > > > > The platform specific part of the timeout is the one desctibed
> > > > > in the
> > > > > maximum timeout values comments.
> > > >
> > > > You mean the
> > > >
> > > > /* Must try at least 3 times according to DP spec */
> > > > for (try = 0; try < 5; try++) {
> > > >
> > > > bit? I thought that wasn't related to platform specific retries
> > > > at all, since
> > > > the code in that loop seems to only reference parts of the DP
> > > > spec, and that the
> > > >
> > > > while ((aux_clock_divider = intel_dp-
> > > > >get_aux_clock_divider(intel_dp, clock++))) {
> > > >
> > > > Loop was the portion that was platform specific, since it prompts
> > > > the driver to
> > > > retry the transaction with different aux clock divider rates
> > > > depending on the
> > > > platform in use. Feel free to correct me if I'm wrong though.
> > >
> > > Nope. I meant every HW transaction will have a platform specific
> > > timeout. For instance it's 1.6ms on SKL, but 4ms on ICL. So now
> > > since
> > > the overall retry count is 32 * 5 = 160, on SKL we'll retry for
> > > ~2.6
> > > seconds, on ICL we'll retry for ~6.4 seconds (disregarding now the
> > > extra
> > > 400usec delay inserted by drm_dp_dpcd_access(), which adds a fixed
> > > ~1.3ms delay).
> >
> > Err, looks like I missed some coffee. Max total timeouts atm, which
> > we
> > would need to make the same on all platforms:
> >
> > g4x-glk: 5 * 32 * 1.6ms + 32 * 400us = 268.8ms
> > cnl    : 5 * 32 * 3.2ms + 32 * 400us = 524.8ms
> > icl+   : 5 * 32 * 4ms   + 32 * 400us = 652.8ms
> >
> 
> 
> Apology if I'm missing something. but in drm_dpcd_access() I think it
> is 500us not 400us?!

Ah, yes, or more like 600us so need to add 6.4ms to all of the above
figures.

> #define AUX_RETRY_INTERVAL 500 /* us */
> 
> if (ret != 0 && ret != -ETIMEDOUT) {
> usleep_range(AUX_RETRY_INTERVAL,
>      AUX_RETRY_INTERVAL + 100);
> }
> 
> Thanks
> Khaled
> 
> > > This is what I think should be normalized, so that we have the same
> > > amount of overall maximum timeout period on all platforms.
> > >
> > > > Also - with the timeouts we're seeing, does the LTTPR return NAKs
> > > > at all? That's
> > > > still another thing I had suggested alternate workarounds for so
> > > > that we could
> > > > terminate transactions immediately on NAKs, so I wonder if that
> > > > could save time
> > > > here as well.
> > >
> > > There's not much LTTPR specific in that wrt. what sinks would do
> > > normally (no NAKs for read, only for writes) except LTTPRs may
> > > rewrite
> > > NAKs to ACKs to account for buggy monitors returning NAKs when
> > > reading
> > > the 0xf0000 -> range. But I'd suggest not dealing with this aspect
> > > now,
> > > just sanitize the above retry thing, as you suggested, remove the
> > > i915
> > > retry loop and make the drm retry loop configurable.
> > >
> > > (In any case I also had the idea to stop transactions early when
> > > HPD
> > >  gets deasserted, but not sure if that's completely robust.)
> > >
> > > > > > > > Thanks
> > > > > > > > Khaled
> > > > > > > >
> > > > > > > > > > > Anyways, this seems about the only thing we can do
> > > > > > > > > > > given the
> > > > > > > > > > > limited
> > > > > > > > > > > hw capabilities.
> > > > > > > > > > > Reviewed-by: Ville Syrjälä <
> > > > > > > > > > > ville.syrjala@linux.intel.com>
> > > > > > > > > > >
> > > > > > > > > > > > Accordingly disable LTTPR detection until GLK,
> > > > > > > > > > > > where the
> > > > > > > > > > > > maximum timeout
> > > > > > > > > > > > we can set is only 1.6ms.
> > > > > > > > > > > >
> > > > > > > > > > > > Link training in the non-transparent mode is
> > > > > > > > > > > > known to fail at
> > > > > > > > > > > > least on
> > > > > > > > > > > > some SKL systems with a WD19 dock on the link,
> > > > > > > > > > > > which exposes an
> > > > > > > > > > > > LTTPR
> > > > > > > > > > > > (see the References below). While this could have
> > > > > > > > > > > > different
> > > > > > > > > > > > reasons
> > > > > > > > > > > > besides the too short AUX timeout used, not
> > > > > > > > > > > > detecting LTTPRs
> > > > > > > > > > > > (and so not
> > > > > > > > > > > > using the non-transparent LT mode) fixes link
> > > > > > > > > > > > training on these
> > > > > > > > > > > > systems.
> > > > > > > > > > > >
> > > > > > > > > > > > While at it add a code comment about the platform
> > > > > > > > > > > > specific
> > > > > > > > > > > > maximum
> > > > > > > > > > > > timeout values.
> > > > > > > > > > > >
> > > > > > > > > > > > v2: Add a comment about the g4x maximum timeout
> > > > > > > > > > > > as well.
> > > > > > > > > > > > (Ville)
> > > > > > > > > > > >
> > > > > > > > > > > > Reported-by: Takashi Iwai <tiwai@suse.de>
> > > > > > > > > > > > Reported-and-tested-by: Santiago Zarate <
> > > > > > > > > > > > santiago.zarate@suse.com>
> > > > > > > > > > > > Reported-and-tested-by: Bodo Graumann <
> > > > > > > > > > > > mail@bodograumann.de>
> > > > > > > > > > > > References:
> > > > > > > > > > > > https://gitlab.freedesktop.org/drm/intel/-/issues/3166
> > > > > > > > > > > > Fixes: b30edfd8d0b4 ("drm/i915: Switch to LTTPR
> > > > > > > > > > > > non-transparent
> > > > > > > > > > > > mode link training")
> > > > > > > > > > > > Cc: <stable@vger.kernel.org> # v5.11
> > > > > > > > > > > > Cc: Takashi Iwai <tiwai@suse.de>
> > > > > > > > > > > > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > > > > > > > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > >  drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > > > > > > > >   |  7 +++++++
> > > > > > > > > > > >  .../gpu/drm/i915/display/intel_dp_link_training.
> > > > > > > > > > > > c | 15
> > > > > > > > > > > > ++++++++++++---
> > > > > > > > > > > >  2 files changed, 19 insertions(+), 3 deletions(-
> > > > > > > > > > > > )
> > > > > > > > > > > >
> > > > > > > > > > > > diff --git
> > > > > > > > > > > > a/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > > > > > > > > b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > > > > > > > > index eaebf123310a..10fe17b7280d 100644
> > > > > > > > > > > > --- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > > > > > > > > +++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > > > > > > > > @@ -133,6 +133,7 @@ static u32
> > > > > > > > > > > > g4x_get_aux_send_ctl(struct
> > > > > > > > > > > > intel_dp *intel_dp,
> > > > > > > > > > > >  else
> > > > > > > > > > > >  precharge = 5;
> > > > > > > > > > > >
> > > > > > > > > > > > +/* Max timeout value on G4x-BDW: 1.6ms */
> > > > > > > > > > > >  if (IS_BROADWELL(dev_priv))
> > > > > > > > > > > >  timeout = DP_AUX_CH_CTL_TIME_OUT_600us;
> > > > > > > > > > > >  else
> > > > > > > > > > > > @@ -159,6 +160,12 @@ static u32
> > > > > > > > > > > > skl_get_aux_send_ctl(struct
> > > > > > > > > > > > intel_dp *intel_dp,
> > > > > > > > > > > >  enum phy phy = intel_port_to_phy(i915, dig_port-
> > > > > > > > > > > > > base.port);
> > > > > > > > > > > >  u32 ret;
> > > > > > > > > > > >
> > > > > > > > > > > > +/*
> > > > > > > > > > > > + * Max timeout values:
> > > > > > > > > > > > + * SKL-GLK: 1.6ms
> > > > > > > > > > > > + * CNL: 3.2ms
> > > > > > > > > > > > + * ICL+: 4ms
> > > > > > > > > > > > + */
> > > > > > > > > > > >  ret = DP_AUX_CH_CTL_SEND_BUSY |
> > > > > > > > > > > >        DP_AUX_CH_CTL_DONE |
> > > > > > > > > > > >        DP_AUX_CH_CTL_INTERRUPT |
> > > > > > > > > > > > diff --git
> > > > > > > > > > > > a/drivers/gpu/drm/i915/display/intel_dp_link_trai
> > > > > > > > > > > > ning.c
> > > > > > > > > > > > b/drivers/gpu/drm/i915/display/intel_dp_link_trai
> > > > > > > > > > > > ning.c
> > > > > > > > > > > > index 19ba7c7cbaab..c0e25c75c105 100644
> > > > > > > > > > > > ---
> > > > > > > > > > > > a/drivers/gpu/drm/i915/display/intel_dp_link_trai
> > > > > > > > > > > > ning.c
> > > > > > > > > > > > +++
> > > > > > > > > > > > b/drivers/gpu/drm/i915/display/intel_dp_link_trai
> > > > > > > > > > > > ning.c
> > > > > > > > > > > > @@ -82,6 +82,18 @@ static void
> > > > > > > > > > > > intel_dp_read_lttpr_phy_caps(struct intel_dp
> > > > > > > > > > > > *intel_dp,
> > > > > > > > > > > >
> > > > > > > > > > > >  static bool
> > > > > > > > > > > > intel_dp_read_lttpr_common_caps(struct intel_dp
> > > > > > > > > > > > *intel_dp)
> > > > > > > > > > > >  {
> > > > > > > > > > > > +struct drm_i915_private *i915 =
> > > > > > > > > > > > dp_to_i915(intel_dp);
> > > > > > > > > > > > +
> > > > > > > > > > > > +if (intel_dp_is_edp(intel_dp))
> > > > > > > > > > > > +return false;
> > > > > > > > > > > > +
> > > > > > > > > > > > +/*
> > > > > > > > > > > > + * Detecting LTTPRs must be avoided on platforms
> > > > > > > > > > > > with
> > > > > > > > > > > > an AUX timeout
> > > > > > > > > > > > + * period < 3.2ms. (see DP Standard v2.0,
> > > > > > > > > > > > 2.11.2,
> > > > > > > > > > > > 3.6.6.1).
> > > > > > > > > > > > + */
> > > > > > > > > > > > +if (INTEL_GEN(i915) < 10)
> > > > > > > > > > > > +return false;
> > > > > > > > > > > > +
> > > > > > > > > > > >  if (drm_dp_read_lttpr_common_caps(&intel_dp-
> > > > > > > > > > > > >aux,
> > > > > > > > > > > >    intel_dp-
> > > > > > > > > > > > > lttpr_common_caps) < 0) {
> > > > > > > > > > > >  memset(intel_dp->lttpr_common_caps, 0,
> > > > > > > > > > > > @@ -127,9 +139,6 @@ int
> > > > > > > > > > > > intel_dp_lttpr_init(struct intel_dp
> > > > > > > > > > > > *intel_dp)
> > > > > > > > > > > >  bool ret;
> > > > > > > > > > > >  int i;
> > > > > > > > > > > >
> > > > > > > > > > > > -if (intel_dp_is_edp(intel_dp))
> > > > > > > > > > > > -return 0;
> > > > > > > > > > > > -
> > > > > > > > > > > >  ret = intel_dp_read_lttpr_common_caps(intel_dp);
> > > > > > > > > > > >  if (!ret)
> > > > > > > > > > > >  return 0;
> > > > > > > > > > > > --
> > > > > > > > > > > > 2.25.1
> > > > > > > > > > >
> > > > > > > > > > > --
> > > > > > > > > > > Ville Syrjälä
> > > > > > > > > > > Intel
> > > > > >
> > > > > > --
> > > > > > Sincerely,
> > > > > >    Lyude Paul (she/her)
> > > > > >    Software Engineer at Red Hat
> > > > > >
> > > > > > Note: I deal with a lot of emails and have a lot of bugs on
> > > > > > my plate. If
> > > > > > you've
> > > > > > asked me a question, are waiting for a review/merge on a
> > > > > > patch, etc. and I
> > > > > > haven't responded in a while, please feel free to send me
> > > > > > another email to
> > > > > > check
> > > > > > on my status. I don't bite!
> > > > > >
> > > >
> > > > --
> > > > Sincerely,
> > > >    Lyude Paul (she/her)
> > > >    Software Engineer at Red Hat
> > > >
> > > > Note: I deal with a lot of emails and have a lot of bugs on my
> > > > plate. If you've
> > > > asked me a question, are waiting for a review/merge on a patch,
> > > > etc. and I
> > > > haven't responded in a while, please feel free to send me another
> > > > email to check
> > > > on my status. I don't bite!
> > > >
