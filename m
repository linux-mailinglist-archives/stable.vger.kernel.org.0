Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED201ECD24
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 12:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgFCKFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 06:05:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:30102 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgFCKFw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 06:05:52 -0400
IronPort-SDR: GdrM6clIx7TMhwc2oAYSWHBeB59aKUECRD9hKG2Th9b/U1y1QWEHx8g+cD0CQyQOp1AfuyOc8p
 aLJgnscMgPjg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 03:05:51 -0700
IronPort-SDR: aGKqsFG6QYBsdex8XypsLUfdNcskzgd+owH3ClvYc78+3rstPTOjvwG9yuNlptUExynoGa9aBE
 AeAcvYxsE3pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,467,1583222400"; 
   d="scan'208";a="312553661"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with SMTP; 03 Jun 2020 03:05:48 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 03 Jun 2020 13:05:48 +0300
Date:   Wed, 3 Jun 2020 13:05:48 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Anshuman Gupta <anshuman.gupta@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: Re: [RFC] drm/i915: lpsp with hdmi/dp outputs
Message-ID: <20200603100548.GN6112@intel.com>
References: <20200601101516.21018-1-anshuman.gupta@intel.com>
 <20200601141132.GK6112@intel.com>
 <20200602122807.GN4452@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200602122807.GN4452@intel.com>
X-Patchwork-Hint: comment
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 05:58:07PM +0530, Anshuman Gupta wrote:
> On 2020-06-01 at 17:11:32 +0300, Ville Syrjälä wrote:
> > On Mon, Jun 01, 2020 at 03:45:16PM +0530, Anshuman Gupta wrote:
> > > Gen12 hw are failing to enable lpsp configuration due to PG3 was left on
> > > due to valid usgae count of POWER_DOMAIN_AUDIO.
> > > It is not required to get POWER_DOMAIN_AUDIO ref-count when enabling
> > > a crtc, it should be always i915_audio_component request to get/put
> > > AUDIO_POWER_DOMAIN.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
> > > ---
> > >  drivers/gpu/drm/i915/display/intel_display.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> > > index 6c3b11de2daf..f31a579d7a52 100644
> > > --- a/drivers/gpu/drm/i915/display/intel_display.c
> > > +++ b/drivers/gpu/drm/i915/display/intel_display.c
> > > @@ -7356,7 +7356,11 @@ static u64 get_crtc_power_domains(struct intel_crtc_state *crtc_state)
> > >  		mask |= BIT_ULL(intel_encoder->power_domain);
> > >  	}
> > >  
> > > -	if (HAS_DDI(dev_priv) && crtc_state->has_audio)
> > > +	/*
> > > +	 * Gen12 can drive lpsp on hdmi/dp outpus, it doesn't require to
> > > +	 * enable AUDIO power in order to enable a crtc
> > 
> > Nothing requires audio power to enable a crtc. What this is saying is
> > that if we want audio then we must enable the audio power. If you
> > didn't want audio then you wouldn't have .has_audio set.
> IMO i915_audio_component_get_power also enables audio power, and
> i915_audio_component_put_power releases the usage count based upon audio
> runtime idleness but here get_crtc_power_domains() gets the POWER_DOMAIN_AUDIO usages
> count, which will be released only when this crtc get disbaled.
> It may enable AUDIO power despite of fact that audio driver has released the
> usage count.
> Please correct me if i am wrong here.

The audio component stuff doesn't actually do the audio enable/disable
sequence.

> 
> > 
> > That said, looks like audio is moving into the always on well, but not
> > yet in tgl.
> Still some of audio functional stuff lies in PG3, not completely removed
> from PG3.
> Thanks,
> Anshuman Gupta.
> > 
> > .
> > > +	 */
> > > +	if (INTEL_GEN(dev_priv) < 12 && HAS_DDI(dev_priv) && crtc_state->has_audio)
> > >  		mask |= BIT_ULL(POWER_DOMAIN_AUDIO);
> > >  
> > >  	if (crtc_state->shared_dpll)
> > > -- 
> > > 2.26.2
> > 
> > -- 
> > Ville Syrjälä
> > Intel

-- 
Ville Syrjälä
Intel
