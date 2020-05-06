Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750E01C7253
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 16:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgEFOAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 10:00:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:61205 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgEFOAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 10:00:33 -0400
IronPort-SDR: IjuicuGQbtyzdumAbdASbhin4NpAdm8U5p8Iw7nqxHbeITROEXb/luc0qPaRgrB9fk40P+hBZw
 CmJ+qOOg47yg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 07:00:29 -0700
IronPort-SDR: 9af6WEPCfv0v2vNuVHY4PYhboxUg8DMxPNenCF2JQWFbpNkiZJoJ0Hob1m+4FiBJkGbjpEeF+O
 zabwQ60OM0BQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,359,1583222400"; 
   d="scan'208";a="461768893"
Received: from ramaling-i9x.iind.intel.com (HELO intel.com) ([10.99.66.154])
  by fmsmga006.fm.intel.com with ESMTP; 06 May 2020 07:00:23 -0700
Date:   Wed, 6 May 2020 19:30:16 +0530
From:   Ramalingam C <ramalingam.c@intel.com>
To:     Sean Paul <sean@poorly.run>
Cc:     dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        juston.li@intel.com, ville.syrjala@linux.intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, daniel.vetter@ffwll.ch,
        seanpaul@chromium.org, Chris Wilson <chris@chris-wilson.co.uk>,
        stable@vger.kernel.org
Subject: Re: [PATCH v6 01/16] drm/i915: Fix sha_text population code
Message-ID: <20200506140016.GA30925@intel.com>
References: <20200429195502.39919-1-sean@poorly.run>
 <20200429195502.39919-2-sean@poorly.run>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200429195502.39919-2-sean@poorly.run>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-04-29 at 15:54:47 -0400, Sean Paul wrote:
> From: Sean Paul <seanpaul@chromium.org>
> 
> This patch fixes a few bugs:
> 
> 1- We weren't taking into account sha_leftovers when adding multiple
>    ksvs to sha_text. As such, we were or'ing the end of ksv[j - 1] with
>    the beginning of ksv[j]
> 
> 2- In the sha_leftovers == 2 and sha_leftovers == 3 case, bstatus was
>    being placed on the wrong half of sha_text, overlapping the leftover
>    ksv value
> 
> 3- In the sha_leftovers == 2 case, we need to manually terminate the
>    byte stream with 0x80 since the hardware doesn't have enough room to
>    add it after writing M0
> 
> The upside is that all of the HDCP supported HDMI repeaters I could
> find on Amazon just strip HDCP anyways, so it turns out to be _really_
> hard to hit any of these cases without an MST hub, which is not (yet)
> supported. Oh, and the sha_leftovers == 1 case works perfectly!
> 
> Fixes: ee5e5e7a5e0f (drm/i915: Add HDCP framework + base implementation)
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Ramalingam C <ramalingam.c@intel.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sean Paul <seanpaul@chromium.org>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: intel-gfx@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v4.17+
> Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
Just reconfirming my R-b here.

Reviewed-by: Ramalingam C <ramalingam.c@intel.com>
> Signed-off-by: Sean Paul <seanpaul@chromium.org>
> Link: https://patchwork.freedesktop.org/patch/msgid/20191203173638.94919-2-sean@poorly.run #v1
> Link: https://patchwork.freedesktop.org/patch/msgid/20191212190230.188505-2-sean@poorly.run #v2
> Link: https://patchwork.freedesktop.org/patch/msgid/20200117193103.156821-2-sean@poorly.run #v3
> Link: https://patchwork.freedesktop.org/patch/msgid/20200218220242.107265-2-sean@poorly.run #v4
> Link: https://patchwork.freedesktop.org/patch/msgid/20200305201236.152307-2-sean@poorly.run #v5
> 
> Changes in v2:
> -None
> Changes in v3:
> -None
> Changes in v4:
> -Rebased on intel_de_write changes
> Changes in v5:
> -None
> Changes in v6:
> -None
> ---
>  drivers/gpu/drm/i915/display/intel_hdcp.c | 26 +++++++++++++++++------
>  include/drm/drm_hdcp.h                    |  3 +++
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_hdcp.c b/drivers/gpu/drm/i915/display/intel_hdcp.c
> index 2cbc4619b4ce..525658fd201f 100644
> --- a/drivers/gpu/drm/i915/display/intel_hdcp.c
> +++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
> @@ -336,8 +336,10 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
>  
>  		/* Fill up the empty slots in sha_text and write it out */
>  		sha_empty = sizeof(sha_text) - sha_leftovers;
> -		for (j = 0; j < sha_empty; j++)
> -			sha_text |= ksv[j] << ((sizeof(sha_text) - j - 1) * 8);
> +		for (j = 0; j < sha_empty; j++) {
> +			u8 off = ((sizeof(sha_text) - j - 1 - sha_leftovers) * 8);
> +			sha_text |= ksv[j] << off;
> +		}
>  
>  		ret = intel_write_sha_text(dev_priv, sha_text);
>  		if (ret < 0)
> @@ -435,7 +437,7 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
>  		/* Write 32 bits of text */
>  		intel_de_write(dev_priv, HDCP_REP_CTL,
>  			       rep_ctl | HDCP_SHA1_TEXT_32);
> -		sha_text |= bstatus[0] << 24 | bstatus[1] << 16;
> +		sha_text |= bstatus[0] << 8 | bstatus[1];
>  		ret = intel_write_sha_text(dev_priv, sha_text);
>  		if (ret < 0)
>  			return ret;
> @@ -450,17 +452,29 @@ int intel_hdcp_validate_v_prime(struct intel_connector *connector,
>  				return ret;
>  			sha_idx += sizeof(sha_text);
>  		}
> +
> +		/*
> +		 * Terminate the SHA-1 stream by hand. For the other leftover
> +		 * cases this is appended by the hardware.
> +		 */
> +		intel_de_write(dev_priv, HDCP_REP_CTL,
> +			       rep_ctl | HDCP_SHA1_TEXT_32);
> +		sha_text = DRM_HDCP_SHA1_TERMINATOR << 24;
> +		ret = intel_write_sha_text(dev_priv, sha_text);
> +		if (ret < 0)
> +			return ret;
> +		sha_idx += sizeof(sha_text);
>  	} else if (sha_leftovers == 3) {
> -		/* Write 32 bits of text */
> +		/* Write 32 bits of text (filled from LSB) */
>  		intel_de_write(dev_priv, HDCP_REP_CTL,
>  			       rep_ctl | HDCP_SHA1_TEXT_32);
> -		sha_text |= bstatus[0] << 24;
> +		sha_text |= bstatus[0];
>  		ret = intel_write_sha_text(dev_priv, sha_text);
>  		if (ret < 0)
>  			return ret;
>  		sha_idx += sizeof(sha_text);
>  
> -		/* Write 8 bits of text, 24 bits of M0 */
> +		/* Write 8 bits of text (filled from LSB), 24 bits of M0 */
>  		intel_de_write(dev_priv, HDCP_REP_CTL,
>  			       rep_ctl | HDCP_SHA1_TEXT_8);
>  		ret = intel_write_sha_text(dev_priv, bstatus[1]);
> diff --git a/include/drm/drm_hdcp.h b/include/drm/drm_hdcp.h
> index c6bab4986a65..fe58dbb46962 100644
> --- a/include/drm/drm_hdcp.h
> +++ b/include/drm/drm_hdcp.h
> @@ -29,6 +29,9 @@
>  /* Slave address for the HDCP registers in the receiver */
>  #define DRM_HDCP_DDC_ADDR			0x3A
>  
> +/* Value to use at the end of the SHA-1 bytestream used for repeaters */
> +#define DRM_HDCP_SHA1_TERMINATOR		0x80
> +
>  /* HDCP register offsets for HDMI/DVI devices */
>  #define DRM_HDCP_DDC_BKSV			0x00
>  #define DRM_HDCP_DDC_RI_PRIME			0x08
> -- 
> Sean Paul, Software Engineer, Google / Chromium OS
> 
