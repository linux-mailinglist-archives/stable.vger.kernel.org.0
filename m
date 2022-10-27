Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132DA60FA88
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 16:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbiJ0Ohk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 10:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiJ0Ohj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 10:37:39 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6435E18A011
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 07:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666881457; x=1698417457;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=U68yAmRdDbeopclea4MrNpT5//vNzAPsh/mRNap50ng=;
  b=XwSxQG1tNyTOPtk8unTQlvavQW+pTI8umvq27msuM/vi4CgVmOY5/zAb
   oexhU2RdJ2TowWt3LH8aBz0b7V79PIvUexgRnFcNLX2WgkbzvHUuAF+Ho
   S8Um9JNiAT1C2QMzN1ekr1q95Lsmvs5Rr1rYE5ahAerJnNIxEd7xN9nIP
   teOxyas+YNoAERRt59zDbh3EySVQIENOb7aIES+wmpA83bWAgagkatuSR
   /g/4QvqT4iJZX35VOubkAKVXaCbALuSN0MvDdEMFmNlYwRgW3xw/ycTFJ
   TRB6yMKKiER5+VkIQlZP9KdOu3MGq9rIWeXTHG+GNZxd3Dyd5dWxxiaA/
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="291541755"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="291541755"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 07:37:14 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="634928495"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="634928495"
Received: from jnikula-mobl4.fi.intel.com (HELO localhost) ([10.237.66.147])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 07:37:12 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 3/8] drm/i915/sdvo: Grab mode_config.mutex
 during LVDS init to avoid WARNs
In-Reply-To: <20221026101134.20865-4-ville.syrjala@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221026101134.20865-1-ville.syrjala@linux.intel.com>
 <20221026101134.20865-4-ville.syrjala@linux.intel.com>
Date:   Thu, 27 Oct 2022 17:37:08 +0300
Message-ID: <87mt9hcoyz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Oct 2022, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
>
> drm_mode_probed_add() is unhappy about being called w/o
> mode_config.mutex. Grab it during LVDS fixed mode setup
> to silence the WARNs.
>
> Cc: stable@vger.kernel.org
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7301
> Fixes: aa2b88074a56 ("drm/i915/sdvo: Fix multi function encoder stuff")
> Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>

Reviewed-by: Jani Nikula <jani.nikula@intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_sdvo.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/=
i915/display/intel_sdvo.c
> index ccf81d616cb4..1eaaa7ec580e 100644
> --- a/drivers/gpu/drm/i915/display/intel_sdvo.c
> +++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
> @@ -2899,8 +2899,12 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo=
, int device)
>  	intel_panel_add_vbt_sdvo_fixed_mode(intel_connector);
>=20=20
>  	if (!intel_panel_preferred_fixed_mode(intel_connector)) {
> +		mutex_lock(&i915->drm.mode_config.mutex);
> +
>  		intel_ddc_get_modes(connector, &intel_sdvo->ddc);
>  		intel_panel_add_edid_fixed_modes(intel_connector, false);
> +
> +		mutex_unlock(&i915->drm.mode_config.mutex);
>  	}
>=20=20
>  	intel_panel_init(intel_connector);

--=20
Jani Nikula, Intel Open Source Graphics Center
