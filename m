Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE75596B28
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 10:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiHQIMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 04:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiHQIMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 04:12:47 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD89257E06
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 01:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660723965; x=1692259965;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ok/NeemBAwPZbF/TT7fU0YSvlhre9yyG3srbVD0h6+U=;
  b=Ni6kHIcrc+XgV3t6DGBqkj4aGWUKEg0DJdj3vugSmu/y22ELRBapnLGD
   u4NykqjJWpOL1tYOz/tmmIh6sPAePSLaiFpfupYGdwJ5El0ioKqxC8WRf
   PBAU27TbePEUm/o+pGQSTSpo0Z4PHs4AnFdqPKuF2Qz2bqlwFTquFX2KT
   tDwjXZKNnkldDzxTWsf9DSXrok5XQDfPIIw3Xg+yCPeFE3LpaVKN/tU4v
   UEN2xPYANRs28nHWuQdbhmY+evcWV8i3sKVWiCfrjtiWRY1ExPgo7Vzux
   8U2w8qYmuEv4OicIe4qK2qUcOPbW95pJUOociQbQjTRKXQ7Hr3ybnHrxU
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="356431737"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="356431737"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 01:12:45 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="607349943"
Received: from unknown (HELO intel.com) ([10.237.72.65])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 01:12:44 -0700
Date:   Wed, 17 Aug 2022 11:13:20 +0300
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [RESEND 1/3] drm/i915/dsi: filter invalid backlight
 and CABC ports
Message-ID: <YvyjILz4bXhvPjdZ@intel.com>
References: <cover.1660664162.git.jani.nikula@intel.com>
 <b0f4f087866257d280eb97d6bcfcefd109cc5fa2.1660664162.git.jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0f4f087866257d280eb97d6bcfcefd109cc5fa2.1660664162.git.jani.nikula@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 16, 2022 at 06:37:20PM +0300, Jani Nikula wrote:
> Avoid using ports that aren't initialized in case the VBT backlight or
> CABC ports have invalid values. This fixes a NULL pointer dereference of
> intel_dsi->dsi_hosts[port] in such cases.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>

Would be interesting to figure out which one of those actually fixed the
https://gitlab.freedesktop.org/drm/intel/-/issues/6476 issue, this one
or next one.

Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

> ---
>  drivers/gpu/drm/i915/display/icl_dsi.c | 7 +++++++
>  drivers/gpu/drm/i915/display/vlv_dsi.c | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
> index 5dcfa7feffa9..885c74f60366 100644
> --- a/drivers/gpu/drm/i915/display/icl_dsi.c
> +++ b/drivers/gpu/drm/i915/display/icl_dsi.c
> @@ -2070,7 +2070,14 @@ void icl_dsi_init(struct drm_i915_private *dev_priv)
>  	else
>  		intel_dsi->ports = BIT(port);
>  
> +	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.bl_ports & ~intel_dsi->ports))
> +		intel_connector->panel.vbt.dsi.bl_ports &= intel_dsi->ports;
> +
>  	intel_dsi->dcs_backlight_ports = intel_connector->panel.vbt.dsi.bl_ports;
> +
> +	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.cabc_ports & ~intel_dsi->ports))
> +		intel_connector->panel.vbt.dsi.cabc_ports &= intel_dsi->ports;
> +
>  	intel_dsi->dcs_cabc_ports = intel_connector->panel.vbt.dsi.cabc_ports;
>  
>  	for_each_dsi_port(port, intel_dsi->ports) {
> diff --git a/drivers/gpu/drm/i915/display/vlv_dsi.c b/drivers/gpu/drm/i915/display/vlv_dsi.c
> index b9b1fed99874..35136d26e517 100644
> --- a/drivers/gpu/drm/i915/display/vlv_dsi.c
> +++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
> @@ -1933,7 +1933,14 @@ void vlv_dsi_init(struct drm_i915_private *dev_priv)
>  	else
>  		intel_dsi->ports = BIT(port);
>  
> +	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.bl_ports & ~intel_dsi->ports))
> +		intel_connector->panel.vbt.dsi.bl_ports &= intel_dsi->ports;
> +
>  	intel_dsi->dcs_backlight_ports = intel_connector->panel.vbt.dsi.bl_ports;
> +
> +	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.cabc_ports & ~intel_dsi->ports))
> +		intel_connector->panel.vbt.dsi.cabc_ports &= intel_dsi->ports;
> +
>  	intel_dsi->dcs_cabc_ports = intel_connector->panel.vbt.dsi.cabc_ports;
>  
>  	/* Create a DSI host (and a device) for each port. */
> -- 
> 2.34.1
> 
