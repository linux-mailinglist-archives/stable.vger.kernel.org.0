Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FEE340C82
	for <lists+stable@lfdr.de>; Thu, 18 Mar 2021 19:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229467AbhCRSJR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Mar 2021 14:09:17 -0400
Received: from mga18.intel.com ([134.134.136.126]:62667 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232555AbhCRSJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Mar 2021 14:09:09 -0400
IronPort-SDR: F3iOQZVVCQgu89NM0jdxDyRwg+QR/hYh0R+jB1MRbZ7rkbb7h4H3ubU0Obk9IYhTQgp28aSC5O
 SD3PSyvP6xiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="177334345"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="177334345"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 11:09:08 -0700
IronPort-SDR: GtM4yFDaXV3w4heKIccONaAJu1dfyd3Lzkaifu9fScWXnkFCiFVCt0ZX6hfSJ32bzWIYosz+uV
 C+yqqTN7ifZQ==
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="606279899"
Received: from ideak-desk.fi.intel.com ([10.237.68.141])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 11:09:07 -0700
Date:   Thu, 18 Mar 2021 20:09:03 +0200
From:   Imre Deak <imre.deak@intel.com>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] drm/i915: Disable LTTPR support when the LTTPR
 rev < 1.4
Message-ID: <20210318180903.GH4128033@ideak-desk.fi.intel.com>
Reply-To: imre.deak@intel.com
References: <20210317184901.4029798-1-imre.deak@intel.com>
 <20210317184901.4029798-4-imre.deak@intel.com>
 <YFOVKoReLkmB7ZuQ@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YFOVKoReLkmB7ZuQ@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 18, 2021 at 08:00:10PM +0200, Ville Syrjälä wrote:
> On Wed, Mar 17, 2021 at 08:49:01PM +0200, Imre Deak wrote:
> > By the specification the 0xF0000 - 0xF02FF range is only valid if the
> > LTTPR revision at 0xF0000 is at least 1.4. Disable the LTTPR support
> > otherwise.
> > 
> > Fixes: 7b2a4ab8b0ef ("drm/i915: Switch to LTTPR transparent mode link training")
> > Cc: <stable@vger.kernel.org> # v5.11
> > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  .../gpu/drm/i915/display/intel_dp_link_training.c  | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > index d8d90903226f..d92eb192c89d 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > +++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
> > @@ -100,17 +100,23 @@ static bool intel_dp_read_lttpr_common_caps(struct intel_dp *intel_dp)
> >  		return false;
> >  
> >  	if (drm_dp_read_lttpr_common_caps(&intel_dp->aux,
> > -					  intel_dp->lttpr_common_caps) < 0) {
> > -		intel_dp_reset_lttpr_common_caps(intel_dp);
> > -		return false;
> > -	}
> > +					  intel_dp->lttpr_common_caps) < 0)
> > +		goto reset_caps;
> 
> BTW just noticed this oddball thing in the spec:
> "DPTX shall read specific registers within the LTTPR field (DPCD
>  Addresses F0000h through F0004h; see Table 2-198) to determine
>  whether any LTTPR(s) are present and if so, how many. This read
>  shall be in the form of a 5-byte native AUX Read transaction."
> 
> Why exactly 5 bytes? I have no idea. Doesn't really make sense.
> Just wondering if we really need to respect that and some LTTPRs
> would fsck things up if we read more...

I pointed this out to spec people and the new version (2.1) will require
this to be 8 bytes. But yes, I do hope no existing ones depend on this
being 5 bytes.

> Anyways
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> >  
> >  	drm_dbg_kms(&dp_to_i915(intel_dp)->drm,
> >  		    "LTTPR common capabilities: %*ph\n",
> >  		    (int)sizeof(intel_dp->lttpr_common_caps),
> >  		    intel_dp->lttpr_common_caps);
> >  
> > +	/* The minimum value of LT_TUNABLE_PHY_REPEATER_FIELD_DATA_STRUCTURE_REV is 1.4 */
> > +	if (intel_dp->lttpr_common_caps[0] < 0x14)
> > +		goto reset_caps;
> > +
> >  	return true;
> > +
> > +reset_caps:
> > +	intel_dp_reset_lttpr_common_caps(intel_dp);
> > +	return false;
> >  }
> >  
> >  static bool
> > -- 
> > 2.25.1
> 
> -- 
> Ville Syrjälä
> Intel
