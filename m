Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1490B60FF58
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiJ0RdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiJ0RdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:33:17 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5C61A5B14
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666891996; x=1698427996;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=j7ZGxJaC4WLHqCzQAANm1wQNRKqS91MWqszoBYz0Gz0=;
  b=LG34en4NUcHc+ixCx/ue2Lcq9GCnEOtO3DTrzqX+zI0vZROvceaHjsJ7
   4yhqTAY9ZSEdcHL20F3V5gvY2yC4Gh5hhQzCYvuTCOcVdG/YfMNtt05rF
   qC6JKcSHCFeyNT/70cqHRetUnjgTJQJsrvmZ206RfrSYB/MRhBH6HN1M2
   fHvqSc73IufSSw6IK7juTOddKM6liwWXgPK1T5v2UvZDskxU5dmlRvHwl
   zx0l2UAJc9wNiqgG4LYbpxNvbJfpfH7sFfTjnl+jW4dPgNUGox8L7oByf
   zcR/yhfDMw6mlU//rhVITUG4a7f6KWUXp+LJyDhJOwzXzQwn9G1Bu7eS3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="288689949"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="288689949"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 10:33:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="663703451"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="663703451"
Received: from ekalugin-mobl.ger.corp.intel.com (HELO localhost) ([10.252.28.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 10:33:06 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 2/8] drm/i915/sdvo: Setup DDC fully before
 output init
In-Reply-To: <Y1qbv7RUZehBt4fy@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221026101134.20865-1-ville.syrjala@linux.intel.com>
 <20221026101134.20865-3-ville.syrjala@linux.intel.com>
 <87pmedcp07.fsf@intel.com> <Y1qake1Ow8eOCj6n@intel.com>
 <Y1qbv7RUZehBt4fy@intel.com>
Date:   Thu, 27 Oct 2022 20:33:04 +0300
Message-ID: <87a65h9nov.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Oct 2022, Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com=
> wrote:
> On Thu, Oct 27, 2022 at 05:49:53PM +0300, Ville Syrj=C3=A4l=C3=A4 wrote:
>> On Thu, Oct 27, 2022 at 05:36:24PM +0300, Jani Nikula wrote:
>> > On Wed, 26 Oct 2022, Ville Syrjala <ville.syrjala@linux.intel.com> wro=
te:
>> > > From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>> > >
>> > > Call intel_sdvo_select_ddc_bus() before initializing any
>> > > of the outputs. And before that is functional (assuming no VBT)
>> > > we have to set up the controlled_outputs thing. Otherwise DDC
>> > > won't be functional during the output init but LVDS really
>> > > needs it for the fixed mode setup.
>> > >
>> > > Note that the whole multi output support still looks very
>> > > bogus, and more work will be needed to make it correct.
>> > > But for now this should at least fix the LVDS EDID fixed mode
>> > > setup.
>> > >
>> > > Cc: stable@vger.kernel.org
>> > > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7301
>> > > Fixes: aa2b88074a56 ("drm/i915/sdvo: Fix multi function encoder stuf=
f")
>> > > Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.co=
m>
>> > > ---
>> > >  drivers/gpu/drm/i915/display/intel_sdvo.c | 31 +++++++++-----------=
---
>> > >  1 file changed, 12 insertions(+), 19 deletions(-)
>> > >
>> > > diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu=
/drm/i915/display/intel_sdvo.c
>> > > index c6200a91a777..ccf81d616cb4 100644
>> > > --- a/drivers/gpu/drm/i915/display/intel_sdvo.c
>> > > +++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
>> > > @@ -2746,13 +2746,10 @@ intel_sdvo_dvi_init(struct intel_sdvo *intel=
_sdvo, int device)
>> > >  	if (!intel_sdvo_connector)
>> > >  		return false;
>> > >=20=20
>> > > -	if (device =3D=3D 0) {
>> > > -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_TMDS0;
>> > > +	if (device =3D=3D 0)
>> > >  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_TMDS0;
>> > > -	} else if (device =3D=3D 1) {
>> > > -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_TMDS1;
>> > > +	else if (device =3D=3D 1)
>> > >  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_TMDS1;
>> > > -	}
>> > >=20=20
>> > >  	intel_connector =3D &intel_sdvo_connector->base;
>> > >  	connector =3D &intel_connector->base;
>> > > @@ -2807,7 +2804,6 @@ intel_sdvo_tv_init(struct intel_sdvo *intel_sd=
vo, int type)
>> > >  	encoder->encoder_type =3D DRM_MODE_ENCODER_TVDAC;
>> > >  	connector->connector_type =3D DRM_MODE_CONNECTOR_SVIDEO;
>> > >=20=20
>> > > -	intel_sdvo->controlled_output |=3D type;
>> > >  	intel_sdvo_connector->output_flag =3D type;
>> > >=20=20
>> > >  	if (intel_sdvo_connector_init(intel_sdvo_connector, intel_sdvo) < =
0) {
>> > > @@ -2848,13 +2844,10 @@ intel_sdvo_analog_init(struct intel_sdvo *in=
tel_sdvo, int device)
>> > >  	encoder->encoder_type =3D DRM_MODE_ENCODER_DAC;
>> > >  	connector->connector_type =3D DRM_MODE_CONNECTOR_VGA;
>> > >=20=20
>> > > -	if (device =3D=3D 0) {
>> > > -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_RGB0;
>> > > +	if (device =3D=3D 0)
>> > >  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_RGB0;
>> > > -	} else if (device =3D=3D 1) {
>> > > -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_RGB1;
>> > > +	else if (device =3D=3D 1)
>> > >  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_RGB1;
>> > > -	}
>> > >=20=20
>> > >  	if (intel_sdvo_connector_init(intel_sdvo_connector, intel_sdvo) < =
0) {
>> > >  		kfree(intel_sdvo_connector);
>> > > @@ -2884,13 +2877,10 @@ intel_sdvo_lvds_init(struct intel_sdvo *inte=
l_sdvo, int device)
>> > >  	encoder->encoder_type =3D DRM_MODE_ENCODER_LVDS;
>> > >  	connector->connector_type =3D DRM_MODE_CONNECTOR_LVDS;
>> > >=20=20
>> > > -	if (device =3D=3D 0) {
>> > > -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_LVDS0;
>> > > +	if (device =3D=3D 0)
>> > >  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_LVDS0;
>> > > -	} else if (device =3D=3D 1) {
>> > > -		intel_sdvo->controlled_output |=3D SDVO_OUTPUT_LVDS1;
>> > > +	else if (device =3D=3D 1)
>> > >  		intel_sdvo_connector->output_flag =3D SDVO_OUTPUT_LVDS1;
>> > > -	}
>> > >=20=20
>> > >  	if (intel_sdvo_connector_init(intel_sdvo_connector, intel_sdvo) < =
0) {
>> > >  		kfree(intel_sdvo_connector);
>> > > @@ -2945,8 +2935,14 @@ static u16 intel_sdvo_filter_output_flags(u16=
 flags)
>> > >  static bool
>> > >  intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
>> > >  {
>> > > +	struct drm_i915_private *i915 =3D to_i915(intel_sdvo->base.base.de=
v);
>> > > +
>> > >  	flags =3D intel_sdvo_filter_output_flags(flags);
>> > >=20=20
>> > > +	intel_sdvo->controlled_output =3D flags;
>> > > +
>> > > +	intel_sdvo_select_ddc_bus(i915, intel_sdvo);
>> >=20
>> > AFAICT the ->controlled_outputs member could now be removed and just
>> > passed by value here.
>>=20
>> Hmm. True. Though the whole thing is utter garbage anyway.
>> intel_sdvo_guess_ddc_bus() really expects controlled_outputs
>> to contain only a single bit. I guess it kinda works by luck
>> most or the time, at least for single output devices.
>> I suppose I can still include the controlled_outputs nukage
>> into this patch.
>
> On second though I think I'll do it as a followup. Less chance
> of backport conflicts that way.

That's completely fine, it was just an observation.

BR,
Jani.


--=20
Jani Nikula, Intel Open Source Graphics Center
