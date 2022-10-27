Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F90F60FA83
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 16:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbiJ0OhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 10:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbiJ0OhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 10:37:07 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA8A18A012
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 07:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666881427; x=1698417427;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=7YAs5PhW0G7oUUlur2e0PsV8vZfw98hyXf5PrUtYBhg=;
  b=NjzdPcciSN7CavIv/lemmsNx/rvN+rOyrCugLC/jVz4im5ayNA6fZfkp
   d7okoS4v3616Enm3+t5itp6E5Ng3tqVlKAMUXjSvOCqRo6AOa4x7CCoks
   RVamRp1MYVft41iNdca+HrecMKcq0Utkv4ITidn2MIcvyDcAPwtJfhUgv
   rzG6rM96d/eUMopAwjex6My7JPYQn+zin1/mmCHYJmaqSHDUmWawdBYQG
   7Iib63zKy38r8+IzAOzJPcrWaSHpNteQyVs6val4xKcgm04YlOR0qXZc9
   NB66hv0a6fh/BErYik+pjthai0ejfw2Tu6KPbACZFiviZUlte3e8S/sKU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="288635035"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="288635035"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 07:32:48 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="663635998"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="663635998"
Received: from jnikula-mobl4.fi.intel.com (HELO localhost) ([10.237.66.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 07:32:46 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/8] drm/i915/sdvo: Filter out invalid
 outputs more sensibly
In-Reply-To: <20221026101134.20865-2-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221026101134.20865-1-ville.syrjala@linux.intel.com>
 <20221026101134.20865-2-ville.syrjala@linux.intel.com>
Date:   Thu, 27 Oct 2022 17:32:42 +0300
Message-ID: <87sfj9cp6d.fsf@intel.com>
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

On Wed, 26 Oct 2022, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>
> We try to filter out the corresponding xxx1 output
> if the xxx0 output is not present. But the way that is
> being done is pretty awkward. Make it less so.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_sdvo.c | 29 ++++++++++++++++++-----
>  1 file changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/=
i915/display/intel_sdvo.c
> index cf8e80936d8e..c6200a91a777 100644
> --- a/drivers/gpu/drm/i915/display/intel_sdvo.c
> +++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
> @@ -2925,16 +2925,33 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdv=
o, int device)
>  	return false;
>  }
>=20=20
> -static bool
> -intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
> +static u16 intel_sdvo_filter_output_flags(u16 flags)
>  {
> +	flags &=3D SDVO_OUTPUT_MASK;
> +
>  	/* SDVO requires XXX1 function may not exist unless it has XXX0 functio=
n.*/
> +	if (!(flags & SDVO_OUTPUT_TMDS0))
> +		flags &=3D ~SDVO_OUTPUT_TMDS1;
> +
> +	if (!(flags & SDVO_OUTPUT_RGB0))
> +		flags &=3D ~SDVO_OUTPUT_RGB1;
> +
> +	if (!(flags & SDVO_OUTPUT_LVDS0))
> +		flags &=3D ~SDVO_OUTPUT_LVDS1;
> +
> +	return flags;
> +}
> +
> +static bool
> +intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
> +{
> +	flags =3D intel_sdvo_filter_output_flags(flags);
>=20=20
>  	if (flags & SDVO_OUTPUT_TMDS0)
>  		if (!intel_sdvo_dvi_init(intel_sdvo, 0))
>  			return false;
>=20=20
> -	if ((flags & SDVO_TMDS_MASK) =3D=3D SDVO_TMDS_MASK)
> +	if (flags & SDVO_OUTPUT_TMDS1)
>  		if (!intel_sdvo_dvi_init(intel_sdvo, 1))
>  			return false;
>=20=20
> @@ -2955,7 +2972,7 @@ intel_sdvo_output_setup(struct intel_sdvo *intel_sd=
vo, u16 flags)
>  		if (!intel_sdvo_analog_init(intel_sdvo, 0))
>  			return false;
>=20=20
> -	if ((flags & SDVO_RGB_MASK) =3D=3D SDVO_RGB_MASK)
> +	if (flags & SDVO_OUTPUT_RGB1)
>  		if (!intel_sdvo_analog_init(intel_sdvo, 1))
>  			return false;
>=20=20
> @@ -2963,11 +2980,11 @@ intel_sdvo_output_setup(struct intel_sdvo *intel_=
sdvo, u16 flags)
>  		if (!intel_sdvo_lvds_init(intel_sdvo, 0))
>  			return false;
>=20=20
> -	if ((flags & SDVO_LVDS_MASK) =3D=3D SDVO_LVDS_MASK)
> +	if (flags & SDVO_OUTPUT_LVDS1)
>  		if (!intel_sdvo_lvds_init(intel_sdvo, 1))
>  			return false;
>=20=20
> -	if ((flags & SDVO_OUTPUT_MASK) =3D=3D 0) {
> +	if (flags =3D=3D 0) {
>  		unsigned char bytes[2];
>=20=20
>  		intel_sdvo->controlled_output =3D 0;

--=20
Jani Nikula, Intel Open Source Graphics Center
