Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02141EBBD4
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 14:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgFBMjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 08:39:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:16533 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbgFBMjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 08:39:04 -0400
IronPort-SDR: pNF6xHoxiLNHJbDEZRNxmM/vwWDf/ZLU4PCAMmu69KbK8acAk7Qacen4QziThTKAfUkVMSCPtC
 t4zaaZ2qvNnw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 05:39:04 -0700
IronPort-SDR: Z9sHacOZ9QTw0AsV1gTFkw9Nrt9+lvNyQ6O9Op+uwX0tH76MgM8id8OjJ68nwjV7G8snC+eilC
 E+aLCHeXU5tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,464,1583222400"; 
   d="scan'208";a="303995536"
Received: from unknown (HELO intel.com) ([10.223.74.178])
  by fmsmga002.fm.intel.com with ESMTP; 02 Jun 2020 05:39:02 -0700
Date:   Tue, 2 Jun 2020 17:58:07 +0530
From:   Anshuman Gupta <anshuman.gupta@intel.com>
To:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Subject: Re: [RFC] drm/i915: lpsp with hdmi/dp outputs
Message-ID: <20200602122807.GN4452@intel.com>
References: <20200601101516.21018-1-anshuman.gupta@intel.com>
 <20200601141132.GK6112@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200601141132.GK6112@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-01 at 17:11:32 +0300, Ville Syrjälä wrote:
> On Mon, Jun 01, 2020 at 03:45:16PM +0530, Anshuman Gupta wrote:
> > Gen12 hw are failing to enable lpsp configuration due to PG3 was left on
> > due to valid usgae count of POWER_DOMAIN_AUDIO.
> > It is not required to get POWER_DOMAIN_AUDIO ref-count when enabling
> > a crtc, it should be always i915_audio_component request to get/put
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
> > diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> > index 6c3b11de2daf..f31a579d7a52 100644
> > --- a/drivers/gpu/drm/i915/display/intel_display.c
> > +++ b/drivers/gpu/drm/i915/display/intel_display.c
> > @@ -7356,7 +7356,11 @@ static u64 get_crtc_power_domains(struct intel_crtc_state *crtc_state)
> >  		mask |= BIT_ULL(intel_encoder->power_domain);
> >  	}
> >  
> > -	if (HAS_DDI(dev_priv) && crtc_state->has_audio)
> > +	/*
> > +	 * Gen12 can drive lpsp on hdmi/dp outpus, it doesn't require to
> > +	 * enable AUDIO power in order to enable a crtc
> 
> Nothing requires audio power to enable a crtc. What this is saying is
> that if we want audio then we must enable the audio power. If you
> didn't want audio then you wouldn't have .has_audio set.
IMO i915_audio_component_get_power also enables audio power, and
i915_audio_component_put_power releases the usage count based upon audio
runtime idleness but here get_crtc_power_domains() gets the POWER_DOMAIN_AUDIO usages
count, which will be released only when this crtc get disbaled.
It may enable AUDIO power despite of fact that audio driver has released the
usage count.
Please correct me if i am wrong here.

> 
> That said, looks like audio is moving into the always on well, but not
> yet in tgl.
Still some of audio functional stuff lies in PG3, not completely removed
from PG3.
Thanks,
Anshuman Gupta.
> 
> .
> > +	 */
> > +	if (INTEL_GEN(dev_priv) < 12 && HAS_DDI(dev_priv) && crtc_state->has_audio)
> >  		mask |= BIT_ULL(POWER_DOMAIN_AUDIO);
> >  
> >  	if (crtc_state->shared_dpll)
> > -- 
> > 2.26.2
> 
> -- 
> Ville Syrjälä
> Intel
