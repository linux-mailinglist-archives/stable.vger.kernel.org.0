Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE691EBB6B
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 14:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgFBMRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 08:17:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:4838 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgFBMRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 08:17:46 -0400
IronPort-SDR: r5MqEknFE+1D5ozB3gE8ZIUcM3+30wgcm4QE5DEKy1M3Y/FDPrqzXbmvqpXeaBMHp8z7/IE4xg
 hE52h19KceLg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 05:17:31 -0700
IronPort-SDR: /YCIvY6Q6bFBD48Ibm2cIdNeW7MWeUPdvDvdG3CAFb0EFrehnrYkF24T96v3dO2XnR47Ddb53g
 7QOooRC+JW/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,464,1583222400"; 
   d="scan'208";a="312268285"
Received: from unknown (HELO intel.com) ([10.223.74.178])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Jun 2020 05:17:29 -0700
Date:   Tue, 2 Jun 2020 17:36:34 +0530
From:   Anshuman Gupta <anshuman.gupta@intel.com>
To:     "Shankar, Uma" <uma.shankar@intel.com>
Cc:     "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [RFC] drm/i915: lpsp with hdmi/dp outputs
Message-ID: <20200602120633.GM4452@intel.com>
References: <20200601101516.21018-1-anshuman.gupta@intel.com>
 <E7C9878FBA1C6D42A1CA3F62AEB6945F82516D51@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E7C9878FBA1C6D42A1CA3F62AEB6945F82516D51@BGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-01 at 18:19:44 +0530, Shankar, Uma wrote:
> 
> 
> > -----Original Message-----
> > From: Intel-gfx <intel-gfx-bounces@lists.freedesktop.org> On Behalf Of
> > Anshuman Gupta
> > Sent: Monday, June 1, 2020 3:45 PM
> > To: intel-gfx@lists.freedesktop.org
> > Cc: stable@vger.kernel.org
> > Subject: [Intel-gfx] [RFC] drm/i915: lpsp with hdmi/dp outputs
> > 
> > Gen12 hw are failing to enable lpsp configuration due to PG3 was left on due to
> > valid usgae count of POWER_DOMAIN_AUDIO.
> > It is not required to get POWER_DOMAIN_AUDIO ref-count when enabling a crtc,
> > it should be always i915_audio_component request to get/put
> > AUDIO_POWER_DOMAIN.
> > 
> > Cc: stable@vger.kernel.org
> > Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
> > ---
> >  drivers/gpu/drm/i915/display/intel_display.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/display/intel_display.c
> > b/drivers/gpu/drm/i915/display/intel_display.c
> > index 6c3b11de2daf..f31a579d7a52 100644
> > --- a/drivers/gpu/drm/i915/display/intel_display.c
> > +++ b/drivers/gpu/drm/i915/display/intel_display.c
> > @@ -7356,7 +7356,11 @@ static u64 get_crtc_power_domains(struct
> > intel_crtc_state *crtc_state)
> >  		mask |= BIT_ULL(intel_encoder->power_domain);
> >  	}
> > 
> > -	if (HAS_DDI(dev_priv) && crtc_state->has_audio)
> > +	/*
> > +	 * Gen12 can drive lpsp on hdmi/dp outpus, it doesn't require to
> > +	 * enable AUDIO power in order to enable a crtc.
> > +	 */
> > +	if (INTEL_GEN(dev_priv) < 12 && HAS_DDI(dev_priv) &&
> > +crtc_state->has_audio)
> >  		mask |= BIT_ULL(POWER_DOMAIN_AUDIO);
> 
> As part of ddi_get_config we determine has_audio using power well enabled:
> pipe_config->has_audio =
>                 intel_ddi_is_audio_enabled(dev_priv, cpu_transcoder);
IMO AUDIO power will also be requested by i915_audio_component get request, 
we can always use HDMI display without audio playback, AUDIO power should be 
enabled when audio driver request for it. 
if we get AUDIO_POWER_DOMAIN while enabling crtc PG3 will always kept on till CRTC is disabled,
that is the issue required to be addressed here.
This is just RFC to initiate a discussion around it.
Thanks,
Anshuman Gupta.
> 
> If audio power domain is not enabled, we may end up with this as false.
> Later this may get checked in intel_enable_ddi_hdmi to call audio codec enable
> 
> if (crtc_state->has_audio)
>                 intel_audio_codec_enable(encoder, crtc_state, conn_state);
> 
> This may cause detection to fail. Please verify this usecase once and confirm.
> 
> Regards,
> Uma Shankar
> 
> >  	if (crtc_state->shared_dpll)
> > --
> > 2.26.2
> > 
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/intel-gfx
