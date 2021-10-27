Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEAA43CBE4
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 16:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242534AbhJ0OV5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 27 Oct 2021 10:21:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:22590 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242437AbhJ0OVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 10:21:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="253721655"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="253721655"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 07:19:22 -0700
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="497888118"
Received: from smaharan-mobl.gar.corp.intel.com (HELO localhost) ([10.251.214.195])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 07:19:19 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Fix type1 DVI DP dual mode adapter heuristic for modern platforms
In-Reply-To: <YXkX4zWnnVxbhuU1@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20211025142147.23897-1-ville.syrjala@linux.intel.com> <87cznsjbic.fsf@intel.com> <YXkX4zWnnVxbhuU1@intel.com>
Date:   Wed, 27 Oct 2021 17:19:16 +0300
Message-ID: <87mtmuh7ob.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 27 Oct 2021, Ville Syrjälä <ville.syrjala@linux.intel.com> wrote:
> On Tue, Oct 26, 2021 at 02:01:15PM +0300, Jani Nikula wrote:
>> On Mon, 25 Oct 2021, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
>> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>> >
>> > Looks like we never updated intel_bios_is_port_dp_dual_mode() when
>> > the VBT port mapping became erratic on modern platforms. This
>> > is causing us to look up the wrong child device and thus throwing
>> > the heuristic off (ie. we might end looking at a child device for
>> > a genuine DP++ port when we were supposed to look at one for a
>> > native HDMI port).
>> >
>> > Fix it up by not using the outdated port_mapping[] in
>> > intel_bios_is_port_dp_dual_mode() and rely on
>> > intel_bios_encoder_data_lookup() instead.
>> 
>> It's just crazy, we have like 7 port_mapping tables in intel_bios.c,
>> what happened?!
>> 
>> I wish we could unify all of this more.
>> 
>> >
>> > Cc: stable@vger.kernel.org
>> > Tested-by: Randy Dunlap <rdunlap@infradead.org>
>> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4138
>> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
>> > ---
>> >  drivers/gpu/drm/i915/display/intel_bios.c | 85 +++++++++++++++++------
>> >  1 file changed, 63 insertions(+), 22 deletions(-)
>> >
>> > diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
>> > index f9776ca85de3..2b1423a43437 100644
>> > --- a/drivers/gpu/drm/i915/display/intel_bios.c
>> > +++ b/drivers/gpu/drm/i915/display/intel_bios.c
>> > @@ -1707,6 +1707,39 @@ static void sanitize_aux_ch(struct intel_bios_encoder_data *devdata,
>> >  	child->aux_channel = 0;
>> >  }
>> >  
>> > +static u8 dvo_port_type(u8 dvo_port)
>> > +{
>> > +	switch (dvo_port) {
>> > +	case DVO_PORT_HDMIA:
>> > +	case DVO_PORT_HDMIB:
>> > +	case DVO_PORT_HDMIC:
>> > +	case DVO_PORT_HDMID:
>> > +	case DVO_PORT_HDMIE:
>> > +	case DVO_PORT_HDMIF:
>> > +	case DVO_PORT_HDMIG:
>> > +	case DVO_PORT_HDMIH:
>> > +	case DVO_PORT_HDMII:
>> > +		return DVO_PORT_HDMIA;
>> > +	case DVO_PORT_DPA:
>> > +	case DVO_PORT_DPB:
>> > +	case DVO_PORT_DPC:
>> > +	case DVO_PORT_DPD:
>> > +	case DVO_PORT_DPE:
>> > +	case DVO_PORT_DPF:
>> > +	case DVO_PORT_DPG:
>> > +	case DVO_PORT_DPH:
>> > +	case DVO_PORT_DPI:
>> > +		return DVO_PORT_DPA;
>> > +	case DVO_PORT_MIPIA:
>> > +	case DVO_PORT_MIPIB:
>> > +	case DVO_PORT_MIPIC:
>> > +	case DVO_PORT_MIPID:
>> > +		return DVO_PORT_MIPIA;
>> > +	default:
>> > +		return dvo_port;
>> > +	}
>> > +}
>> > +
>> >  static enum port __dvo_port_to_port(int n_ports, int n_dvo,
>> >  				    const int port_mapping[][3], u8 dvo_port)
>> >  {
>> > @@ -2623,35 +2656,17 @@ bool intel_bios_is_port_edp(struct drm_i915_private *i915, enum port port)
>> >  	return false;
>> >  }
>> >  
>> > -static bool child_dev_is_dp_dual_mode(const struct child_device_config *child,
>> > -				      enum port port)
>> > +static bool child_dev_is_dp_dual_mode(const struct child_device_config *child)
>> >  {
>> > -	static const struct {
>> > -		u16 dp, hdmi;
>> > -	} port_mapping[] = {
>> > -		/*
>> > -		 * Buggy VBTs may declare DP ports as having
>> > -		 * HDMI type dvo_port :( So let's check both.
>> > -		 */
>> > -		[PORT_B] = { DVO_PORT_DPB, DVO_PORT_HDMIB, },
>> > -		[PORT_C] = { DVO_PORT_DPC, DVO_PORT_HDMIC, },
>> > -		[PORT_D] = { DVO_PORT_DPD, DVO_PORT_HDMID, },
>> > -		[PORT_E] = { DVO_PORT_DPE, DVO_PORT_HDMIE, },
>> > -		[PORT_F] = { DVO_PORT_DPF, DVO_PORT_HDMIF, },
>> > -	};
>> > -
>> > -	if (port == PORT_A || port >= ARRAY_SIZE(port_mapping))
>> > -		return false;
>> > -
>> >  	if ((child->device_type & DEVICE_TYPE_DP_DUAL_MODE_BITS) !=
>> >  	    (DEVICE_TYPE_DP_DUAL_MODE & DEVICE_TYPE_DP_DUAL_MODE_BITS))
>> >  		return false;
>> >  
>> > -	if (child->dvo_port == port_mapping[port].dp)
>> > +	if (dvo_port_type(child->dvo_port) == DVO_PORT_DPA)
>> >  		return true;
>> 
>> I wonder, why do we care about dvo_port here, while we ignore the dvo
>> port DP/HDMI/DSI difference in parse_ddi_port()? I'm not really entirely
>> happy about adding another dvo port check method. :/
>
> Because VBTs suck and sometimes a DP++ port is declared as DP (as
> it should) but sometimes it's declared as HDMI instead. Hence the
> additional "do we has aux ch?" check for the dvo_port==HDMI case to
> make it at least try not to match native HDMI ports. I'm not sure
> whether we could just always do the AUX CH check and ignore the
> dvo_port entirely. Would need to look through a bunch of VBTs to
> get some idea I suppose. But that would be too much change for a
> bugfix anyway.
>
> IIRC the other idea of just looking at the device_type bits was a
> bust on at least vlv/chv.

*sad trombone*

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

The bikeshedding is that I think we should convert
child_dev_is_dp_dual_mode() to the same style as the other
intel_bios_encoder_supports_*() functions. And we could add the dual
mode in "Port %c VBT info" logging in parse_ddi_port() too.

In the long run I'd like to ensure encoder->devdata is non-NULL and
valid for more platforms, so we could just call
intel_bios_encoder_supports_dual_mode(encoder->devdata) directly, so we
don't have to loop over ports every time.

Anyway, all of this is just musing for future, can be follow-up.

BR,
Jani.




>
>> 
>> >  
>> >  	/* Only accept a HDMI dvo_port as DP++ if it has an AUX channel */
>> > -	if (child->dvo_port == port_mapping[port].hdmi &&
>> > +	if (dvo_port_type(child->dvo_port) == DVO_PORT_HDMIA &&
>> >  	    child->aux_channel != 0)
>> >  		return true;
>> >  
>> > @@ -2661,10 +2676,36 @@ static bool child_dev_is_dp_dual_mode(const struct child_device_config *child,
>> >  bool intel_bios_is_port_dp_dual_mode(struct drm_i915_private *i915,
>> >  				     enum port port)
>> >  {
>> > +	static const struct {
>> > +		u16 dp, hdmi;
>> > +	} port_mapping[] = {
>> > +		/*
>> > +		 * Buggy VBTs may declare DP ports as having
>> > +		 * HDMI type dvo_port :( So let's check both.
>> > +		 */
>> > +		[PORT_B] = { DVO_PORT_DPB, DVO_PORT_HDMIB, },
>> > +		[PORT_C] = { DVO_PORT_DPC, DVO_PORT_HDMIC, },
>> > +		[PORT_D] = { DVO_PORT_DPD, DVO_PORT_HDMID, },
>> > +		[PORT_E] = { DVO_PORT_DPE, DVO_PORT_HDMIE, },
>> > +		[PORT_F] = { DVO_PORT_DPF, DVO_PORT_HDMIF, },
>> > +	};
>> >  	const struct intel_bios_encoder_data *devdata;
>> >  
>> > +	if (HAS_DDI(i915)) {
>> > +		const struct intel_bios_encoder_data *devdata;
>> > +
>> > +		devdata = intel_bios_encoder_data_lookup(i915, port);
>> > +
>> > +		return devdata && child_dev_is_dp_dual_mode(&devdata->child);
>> > +	}
>> > +
>> > +	if (port == PORT_A || port >= ARRAY_SIZE(port_mapping))
>> > +		return false;
>> > +
>> >  	list_for_each_entry(devdata, &i915->vbt.display_devices, node) {
>> > -		if (child_dev_is_dp_dual_mode(&devdata->child, port))
>> > +		if ((devdata->child.dvo_port == port_mapping[port].dp ||
>> > +		     devdata->child.dvo_port == port_mapping[port].hdmi) &&
>> > +		    child_dev_is_dp_dual_mode(&devdata->child))
>> >  			return true;
>> >  	}
>> 
>> -- 
>> Jani Nikula, Intel Open Source Graphics Center

-- 
Jani Nikula, Intel Open Source Graphics Center
