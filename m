Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572E3596B1F
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 10:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiHQINV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 04:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiHQINU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 04:13:20 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C601E25EF
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 01:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660723998; x=1692259998;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1NaFZJcBPAr4eN464fxypplM0r7Voafi3SVV9MmvYKw=;
  b=MW/0SdXQCpBxfYkXwbzbwOIljzExuFUsWuB3sicf6VdIl3aerpIr5siY
   waEdelzkcIDBHKUfUqkBZeObU0w3MKx4Io3x19UkLTvw7szfHzRC5IQ9J
   F9KuFFggP0PyALcKG8mb3GIudWVhByFygkTebpKnPSyt3VlrtMKCHnslU
   cB3d0Oe6f2yRVhbGrIHxOdOT89geacP7o9dGRrrkkdz1u5jiN3RZSd8ir
   wXQp575WvxmEA6aoYVI7Wzwc/6q3oGW2VOT5j9UHamTNJ0RwbOviWacUq
   JCYUYclt7qaKsKG3BcgUFl+BoC7TwbzzijB5W/4cib7c63iGi0Ra8zwX3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="354178489"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="354178489"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 01:13:17 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="696689375"
Received: from unknown (HELO intel.com) ([10.237.72.65])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 01:13:16 -0700
Date:   Wed, 17 Aug 2022 11:13:59 +0300
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [RESEND 2/3] drm/i915/dsi: fix dual-link DSI
 backlight and CABC ports for display 11+
Message-ID: <YvyjR3x5kNAEfBOk@intel.com>
References: <cover.1660664162.git.jani.nikula@intel.com>
 <8c462718bcc7b36a83e09d0a5eef058b6bc8b1a2.1660664162.git.jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c462718bcc7b36a83e09d0a5eef058b6bc8b1a2.1660664162.git.jani.nikula@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 06:37:21PM +0300, Jani Nikula wrote:
> The VBT dual-link DSI backlight and CABC still use ports A and C, both
> in Bspec and code, while display 11+ DSI only supports ports A and
> B. Assume port C actually means port B for display 11+ when parsing VBT.
> 
> Bspec: 20154
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6476
> Cc: stable@vger.kernel.org
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>

Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

> ---
>  drivers/gpu/drm/i915/display/intel_bios.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
> index 51dde5bfd956..198a2f4920cc 100644
> --- a/drivers/gpu/drm/i915/display/intel_bios.c
> +++ b/drivers/gpu/drm/i915/display/intel_bios.c
> @@ -1596,6 +1596,8 @@ static void parse_dsi_backlight_ports(struct drm_i915_private *i915,
>  				      struct intel_panel *panel,
>  				      enum port port)
>  {
> +	enum port port_bc = DISPLAY_VER(i915) >= 11 ? PORT_B : PORT_C;
> +
>  	if (!panel->vbt.dsi.config->dual_link || i915->vbt.version < 197) {
>  		panel->vbt.dsi.bl_ports = BIT(port);
>  		if (panel->vbt.dsi.config->cabc_supported)
> @@ -1609,11 +1611,11 @@ static void parse_dsi_backlight_ports(struct drm_i915_private *i915,
>  		panel->vbt.dsi.bl_ports = BIT(PORT_A);
>  		break;
>  	case DL_DCS_PORT_C:
> -		panel->vbt.dsi.bl_ports = BIT(PORT_C);
> +		panel->vbt.dsi.bl_ports = BIT(port_bc);
>  		break;
>  	default:
>  	case DL_DCS_PORT_A_AND_C:
> -		panel->vbt.dsi.bl_ports = BIT(PORT_A) | BIT(PORT_C);
> +		panel->vbt.dsi.bl_ports = BIT(PORT_A) | BIT(port_bc);
>  		break;
>  	}
>  
> @@ -1625,12 +1627,12 @@ static void parse_dsi_backlight_ports(struct drm_i915_private *i915,
>  		panel->vbt.dsi.cabc_ports = BIT(PORT_A);
>  		break;
>  	case DL_DCS_PORT_C:
> -		panel->vbt.dsi.cabc_ports = BIT(PORT_C);
> +		panel->vbt.dsi.cabc_ports = BIT(port_bc);
>  		break;
>  	default:
>  	case DL_DCS_PORT_A_AND_C:
>  		panel->vbt.dsi.cabc_ports =
> -					BIT(PORT_A) | BIT(PORT_C);
> +					BIT(PORT_A) | BIT(port_bc);
>  		break;
>  	}
>  }
> -- 
> 2.34.1
> 
