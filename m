Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EB05A5E0B
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 10:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiH3I1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 04:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiH3I1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 04:27:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F59A405E
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 01:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661848065; x=1693384065;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=97HEzabJSGeV78mcHWkuDXfM2OXyv5A7RT29pUq8p5M=;
  b=idDNvJnqgkahE8AZMr5BYsN9pjQWTGuU3CMiY9ojUippzniYoWg2vueo
   VRDHhhjE6FGFaq1GSmq8TtwKWW5pgsfPmVfJZGhXTw+oK8xAsZSX9oa2N
   XHx/rm6N4lPSZI9ysv/HlWqFJRbnnVY5BIfO/TiPURG2iNPkLov/Fm6JN
   +ZHqD2kFiD1hPXGFYWTVifmxkhmiX5GEYNrLb9DWGbtMHI2aiTsOqfTLC
   8qZIhk1MGX4DHnFMOh/PbZER4mZ1giHCW0jvfmQ+/+SAU9+bPQtxlwijD
   0Ejh8q2gBzhVIwpvm0yiJ1szAu+k3tLZoaq5lo9M55D3tksph5XsF2xiw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="321245057"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="321245057"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 01:27:44 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="672753013"
Received: from amrabet-mobl.ger.corp.intel.com (HELO localhost) ([10.252.41.211])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 01:27:35 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/bios: Copy the whole MIPI sequence
 block
In-Reply-To: <20220829135834.8585-1-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20220829135834.8585-1-ville.syrjala@linux.intel.com>
Date:   Tue, 30 Aug 2022 11:27:27 +0300
Message-ID: <87o7w2dtlc.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Aug 2022, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>
> Turns out the MIPI sequence block version number and
> new block size fields are considered part of the block
> header and are not included in the reported new block size
> field itself. Bump up the block size appropriately so that
> we'll copy over the last five bytes of the block as well.
>
> For this particular machine those last five bytes included
> parts of the GPIO op for the backlight on sequence, causing
> the backlight no longer to turn back on:
>
>  		Sequence 6 - MIPI_SEQ_BACKLIGHT_ON
>  			Delay: 20000 us
> -			GPIO index 0, number 0, set 0 (0x00)
> +			GPIO index 1, number 70, set 1 (0x01)
>
> Cc: stable@vger.kernel.org
> Fixes: e163cfb4c96d ("drm/i915/bios: Make copies of VBT data blocks")
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6652
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> ---
>  drivers/gpu/drm/i915/display/intel_bios.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/=
i915/display/intel_bios.c
> index 81d6cfbd2615..d493d04f4049 100644
> --- a/drivers/gpu/drm/i915/display/intel_bios.c
> +++ b/drivers/gpu/drm/i915/display/intel_bios.c
> @@ -479,6 +479,13 @@ init_bdb_block(struct drm_i915_private *i915,
>=20=20
>  	block_size =3D get_blocksize(block);
>=20=20
> +	/*
> +	 * Version number and new block size are considered
> +	 * part of the header for MIPI sequenece block v3+.
> +	 */

Quoth Bspec, "This field specifies the size of this entire data
structure excluding this header." Okay.

> +	if (section_id =3D=3D BDB_MIPI_SEQUENCE && *(const u8 *)block >=3D 3)
> +		block_size +=3D 5;
> +

Since we need to look at the header later, we can't just use data +
5. Okay.

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

I just don't get the whole sequence block u32 size thing, because the
vbt header and bdb header still have u16, and they're supposed to cover
the entire vbt and all bdb data blocks. And this is what we check
anyway.

>  	entry =3D kzalloc(struct_size(entry, data, max(min_size, block_size) + =
3),
>  			GFP_KERNEL);
>  	if (!entry) {

--=20
Jani Nikula, Intel Open Source Graphics Center
