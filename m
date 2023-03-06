Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC176AC7E2
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 17:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCFQ1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 11:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCFQ1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 11:27:21 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC283C38
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 08:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678120007; x=1709656007;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=oAmlWZKHrfhIRRnq9G8W0ZvXDZS/yhaddDnWBU+E70E=;
  b=Tnd+we0AfW54LD2qLIsXnLixK3KwZswUdh2kjzvlZovm5IwVkjc7Z7io
   /C3/gzaHwnSLVBLKTR8Hgw+Ag6sSpDD0sUWRKDTPT9DzR20mThs4P0K5c
   /+Zqyu6vhjjZz+/5kiJpKDyvSkx4tUGJNdFuO1xkA0fhmtJQmthirMS6H
   GLwgABE2AUPbatnxo8UqVnBNYGhApd4OiJN7k74b0NkS4OZyHRfQrhfwy
   pV4VyBH4m2G452sVfXd/gVXgr1hMO/hcxmZb6kSpb1FtiYdHprgye7LmL
   Q45wOGmfTfb6kT1QYnSZWirec0KybamhAp14qL7j/LK4ZmUgEoSY6Kwgf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="315996262"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="315996262"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 08:25:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="819358816"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="819358816"
Received: from bholthau-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.58.77])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 08:25:03 -0800
From:   Jani Nikula <jani.nikula@intel.com>
To:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915/dsi: fix DSS CTL register offsets for TGL+
In-Reply-To: <Y/9xf6SkV1fG4JSA@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20230301151409.1581574-1-jani.nikula@intel.com>
 <Y/9xf6SkV1fG4JSA@intel.com>
Date:   Mon, 06 Mar 2023 18:25:01 +0200
Message-ID: <87fsahu9sy.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Mar 2023, Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com=
> wrote:
> On Wed, Mar 01, 2023 at 05:14:09PM +0200, Jani Nikula wrote:
>> On TGL+ the DSS control registers are at different offsets, and there's
>> one per pipe. Fix the offsets to fix dual link DSI for TGL+.
>>=20
>> There would be helpers for this in the DSC code, but just do the quick
>> fix now for DSI. Long term, we should probably move all the DSS handling
>> into intel_vdsc.c, so exporting the helpers seems counter-productive.
>
> I'm not entirely happy with intel_vdsc.c since it handles
> both the hardware VDSC block (which includes DSS, and so
> also uncompressed joiner and MSO), and also some actual
> DSC calculations/etc. Might be nice to have a cleaner
> split of some sort.
>
> That also reminds me that MSO+dsc/joiner is probably going
> to fail miserably given that neither side knows about the
> other and both poke the DSS registers.
>
>>=20
>> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8232
>> Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> ---
>>  drivers/gpu/drm/i915/display/icl_dsi.c | 18 +++++++++++++++---
>>  1 file changed, 15 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i9=
15/display/icl_dsi.c
>> index b5316715bb3b..5a17ab3f0d1a 100644
>> --- a/drivers/gpu/drm/i915/display/icl_dsi.c
>> +++ b/drivers/gpu/drm/i915/display/icl_dsi.c
>> @@ -277,9 +277,21 @@ static void configure_dual_link_mode(struct intel_e=
ncoder *encoder,
>>  {
>>  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.dev);
>>  	struct intel_dsi *intel_dsi =3D enc_to_intel_dsi(encoder);
>> +	i915_reg_t dss_ctl1_reg, dss_ctl2_reg;
>>  	u32 dss_ctl1;
>>=20=20
>> -	dss_ctl1 =3D intel_de_read(dev_priv, DSS_CTL1);
>> +	/* FIXME: Move all DSS handling to intel_vdsc.c */
>> +	if (DISPLAY_VER(dev_priv) >=3D 12) {
>> +		struct intel_crtc *crtc =3D to_intel_crtc(pipe_config->uapi.crtc);
>> +
>> +		dss_ctl1_reg =3D ICL_PIPE_DSS_CTL1(crtc->pipe);
>> +		dss_ctl2_reg =3D ICL_PIPE_DSS_CTL2(crtc->pipe);
>> +	} else {
>> +		dss_ctl1_reg =3D DSS_CTL1;
>> +		dss_ctl2_reg =3D DSS_CTL2;
>> +	}
>> +
>> +	dss_ctl1 =3D intel_de_read(dev_priv, dss_ctl1_reg);
>
> Side note: should get rid of this rmw to make sure the thing
> fully configuerd the way we want...
>
> Anyways, this seems fine for now:
> Reviewed-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>

Thanks, pushed to din.

BR,
Jani.

>
>>  	dss_ctl1 |=3D SPLITTER_ENABLE;
>>  	dss_ctl1 &=3D ~OVERLAP_PIXELS_MASK;
>>  	dss_ctl1 |=3D OVERLAP_PIXELS(intel_dsi->pixel_overlap);
>> @@ -299,14 +311,14 @@ static void configure_dual_link_mode(struct intel_=
encoder *encoder,
>>=20=20
>>  		dss_ctl1 &=3D ~LEFT_DL_BUF_TARGET_DEPTH_MASK;
>>  		dss_ctl1 |=3D LEFT_DL_BUF_TARGET_DEPTH(dl_buffer_depth);
>> -		intel_de_rmw(dev_priv, DSS_CTL2, RIGHT_DL_BUF_TARGET_DEPTH_MASK,
>> +		intel_de_rmw(dev_priv, dss_ctl2_reg, RIGHT_DL_BUF_TARGET_DEPTH_MASK,
>>  			     RIGHT_DL_BUF_TARGET_DEPTH(dl_buffer_depth));
>>  	} else {
>>  		/* Interleave */
>>  		dss_ctl1 |=3D DUAL_LINK_MODE_INTERLEAVE;
>>  	}
>>=20=20
>> -	intel_de_write(dev_priv, DSS_CTL1, dss_ctl1);
>> +	intel_de_write(dev_priv, dss_ctl1_reg, dss_ctl1);
>>  }
>>=20=20
>>  /* aka DSI 8X clock */
>> --=20
>> 2.39.1

--=20
Jani Nikula, Intel Open Source Graphics Center
