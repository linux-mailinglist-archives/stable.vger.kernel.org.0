Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F53B3410BD
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 00:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCRXSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 19:18:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:59460 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhCRXRy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 19:17:54 -0400
IronPort-SDR: UfdjQZeWOtKXhZ0hF9eDFMS0JKLHPNzQkLf9XvHQW1qBpE/sHok61PkDh4zAVXtYf+v6AFLvht
 /dfJ3GFbYADw==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="189163945"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="189163945"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 16:17:54 -0700
IronPort-SDR: JBRA5cS8Mw+fh0J1hjdspjJJYVPiCoZZYcgr7HxegipoIM+6IYkSyqxwYo5kpDz8g+UHrsbkOh
 HnuanII/P5TQ==
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="406549132"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 16:17:52 -0700
Date:   Fri, 19 Mar 2021 01:17:49 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     "Almahallawy, Khaled" <khaled.almahallawy@intel.com>
Cc:     "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "lyude@redhat.com" <lyude@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "mail@bodograumann.de" <mail@bodograumann.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "santiago.zarate@suse.com" <santiago.zarate@suse.com>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: Re: [PATCH v2 1/3] drm/i915/ilk-glk: Fix link training on links with
 LTTPRs
Message-ID: <20210318231749.GA23036@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210317184901.4029798-1-imre.deak@intel.com>
 <20210317184901.4029798-2-imre.deak@intel.com>
 <YFOO4FOmOB8yp3me@intel.com>
 <20210318174907.GE4128033@ideak-desk.fi.intel.com>
 <20210318180645.GG4128033@ideak-desk.fi.intel.com>
 <e1e9f9ea76071af914b37352fc201d09f378a55b.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1e9f9ea76071af914b37352fc201d09f378a55b.camel@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 12:04:54AM +0200, Almahallawy, Khaled wrote:
> On Thu, 2021-03-18 at 20:06 +0200, Imre Deak wrote:
> > On Thu, Mar 18, 2021 at 07:49:13PM +0200, Imre Deak wrote:
> > > On Thu, Mar 18, 2021 at 07:33:20PM +0200, Ville Syrjälä wrote:
> > > > On Wed, Mar 17, 2021 at 08:48:59PM +0200, Imre Deak wrote:
> > > > > The spec requires to use at least 3.2ms for the AUX timeout
> > > > > period if
> > > > > there are LT-tunable PHY Repeaters on the link (2.11.2). An
> > > > > upcoming
> > > > > spec update makes this more specific, by requiring a 3.2ms
> > > > > minimum
> > > > > timeout period for the LTTPR detection reading the 0xF0000-
> > > > > 0xF0007
> > > > > range (3.6.5.1).
> > > >
> > > > I'm pondering if we could reduce the timeout after having
> > > > determined
> > > > wherther LTTPRs are present or not? But maybe that wouldn't
> > > > really speed
> > > > up anything since we can't reduce the timeout until after
> > > > detecting
> > > > *something*. And once there is something there we shouldn't
> > > > really get
> > > > any more timeouts I guess. So probably a totally stupid idea.
> > >
> > > Right, if something is connected it would take anyway as much time
> > > as it
> > > takes for the sink to reply whether or not we decreased the
> > > timeout.
> > >
> > > However if nothing is connected, we have the excessive timeout
> > > Khaled
> > > already noticed (160 * 4ms = 6.4 sec on ICL+). I think to improve
> > > that
> > > we could scale the total number of retries by making it
> > > total_timeout/platform_specific_timeout (letting total_timeout=2sec
> > > for
> > > instance) or just changing the drm retry logic to be time based
> > > instead
> > > of the number of retries we use atm.
> >
> > Doh, reducing simply the HW timeouts would be enough to fix this.
> 
> What about Lyude's suggestion (
> https://patchwork.freedesktop.org/patch/420369/#comment_756572)
> to drop the retries in intel_dp_aux_xfer()
> /* Must try at least 3 times according to DP spec */
> for (try = 0; try < 5; try++) {
> 
> And use only the retries in drm_dpcd_access?

I think it would work if we can make the retries configurable and set it
to
	retries = total_timeout / platform_specific_timeout_per_retry

where total_timeout would be something reasonable like 1 sec.

> 
> Thanks
> Khaled
> 
> >
> > > > Anyways, this seems about the only thing we can do given the
> > > > limited
> > > > hw capabilities.
> > > > Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > >
> > > > > Accordingly disable LTTPR detection until GLK, where the
> > > > > maximum timeout
> > > > > we can set is only 1.6ms.
> > > > >
> > > > > Link training in the non-transparent mode is known to fail at
> > > > > least on
> > > > > some SKL systems with a WD19 dock on the link, which exposes an
> > > > > LTTPR
> > > > > (see the References below). While this could have different
> > > > > reasons
> > > > > besides the too short AUX timeout used, not detecting LTTPRs
> > > > > (and so not
> > > > > using the non-transparent LT mode) fixes link training on these
> > > > > systems.
> > > > >
> > > > > While at it add a code comment about the platform specific
> > > > > maximum
> > > > > timeout values.
> > > > >
> > > > > v2: Add a comment about the g4x maximum timeout as well.
> > > > > (Ville)
> > > > >
> > > > > Reported-by: Takashi Iwai <tiwai@suse.de>
> > > > > Reported-and-tested-by: Santiago Zarate <
> > > > > santiago.zarate@suse.com>
> > > > > Reported-and-tested-by: Bodo Graumann <mail@bodograumann.de>
> > > > > References:
> > > > > https://gitlab.freedesktop.org/drm/intel/-/issues/3166
> > > > > Fixes: b30edfd8d0b4 ("drm/i915: Switch to LTTPR non-transparent
> > > > > mode link training")
> > > > > Cc: <stable@vger.kernel.org> # v5.11
> > > > > Cc: Takashi Iwai <tiwai@suse.de>
> > > > > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > > > > ---
> > > > >  drivers/gpu/drm/i915/display/intel_dp_aux.c       |  7 +++++++
> > > > >  .../gpu/drm/i915/display/intel_dp_link_training.c | 15
> > > > > ++++++++++++---
> > > > >  2 files changed, 19 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > index eaebf123310a..10fe17b7280d 100644
> > > > > --- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > +++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
> > > > > @@ -133,6 +133,7 @@ static u32 g4x_get_aux_send_ctl(struct
> > > > > intel_dp *intel_dp,
> > > > >  else
> > > > >  precharge = 5;
> > > > >
> > > > > +/* Max timeout value on G4x-BDW: 1.6ms */
> > > > >  if (IS_BROADWELL(dev_priv))
> > > > >  timeout = DP_AUX_CH_CTL_TIME_OUT_600us;
> > > > >  else
> > > > > @@ -159,6 +160,12 @@ static u32 skl_get_aux_send_ctl(struct
> > > > > intel_dp *intel_dp,
> > > > >  enum phy phy = intel_port_to_phy(i915, dig_port-
> > > > > >base.port);
> > > > >  u32 ret;
> > > > >
> > > > > +/*
> > > > > + * Max timeout values:
> > > > > + * SKL-GLK: 1.6ms
> > > > > + * CNL: 3.2ms
> > > > > + * ICL+: 4ms
> > > > > + */
> > > > >  ret = DP_AUX_CH_CTL_SEND_BUSY |
> > > > >        DP_AUX_CH_CTL_DONE |
> > > > >        DP_AUX_CH_CTL_INTERRUPT |
> > > > > diff --git
> > > > > a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > > > > b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > > > > index 19ba7c7cbaab..c0e25c75c105 100644
> > > > > --- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > > > > +++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > > > > @@ -82,6 +82,18 @@ static void
> > > > > intel_dp_read_lttpr_phy_caps(struct intel_dp *intel_dp,
> > > > >
> > > > >  static bool intel_dp_read_lttpr_common_caps(struct intel_dp
> > > > > *intel_dp)
> > > > >  {
> > > > > +struct drm_i915_private *i915 = dp_to_i915(intel_dp);
> > > > > +
> > > > > +if (intel_dp_is_edp(intel_dp))
> > > > > +return false;
> > > > > +
> > > > > +/*
> > > > > + * Detecting LTTPRs must be avoided on platforms with
> > > > > an AUX timeout
> > > > > + * period < 3.2ms. (see DP Standard v2.0, 2.11.2,
> > > > > 3.6.6.1).
> > > > > + */
> > > > > +if (INTEL_GEN(i915) < 10)
> > > > > +return false;
> > > > > +
> > > > >  if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
> > > > >    intel_dp-
> > > > > >lttpr_common_caps) < 0) {
> > > > >  memset(intel_dp->lttpr_common_caps, 0,
> > > > > @@ -127,9 +139,6 @@ int intel_dp_lttpr_init(struct intel_dp
> > > > > *intel_dp)
> > > > >  bool ret;
> > > > >  int i;
> > > > >
> > > > > -if (intel_dp_is_edp(intel_dp))
> > > > > -return 0;
> > > > > -
> > > > >  ret = intel_dp_read_lttpr_common_caps(intel_dp);
> > > > >  if (!ret)
> > > > >  return 0;
> > > > > --
> > > > > 2.25.1
> > > >
> > > > --
> > > > Ville Syrjälä
> > > > Intel
