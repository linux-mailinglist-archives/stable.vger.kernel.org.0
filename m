Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5AE6D47E
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 21:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfGRTN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 15:13:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:40177 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfGRTN4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 15:13:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 12:13:55 -0700
X-IronPort-AV: E=Sophos;i="5.64,279,1559545200"; 
   d="scan'208";a="162167979"
Received: from rdvivi-losangeles.jf.intel.com (HELO intel.com) ([10.7.196.65])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jul 2019 12:13:55 -0700
Date:   Thu, 18 Jul 2019 12:14:30 -0700
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR
 section
Message-ID: <20190718191430.GB30177@intel.com>
References: <20190717223451.2595-1-dhinakaran.pandiyan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190717223451.2595-1-dhinakaran.pandiyan@intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 03:34:51PM -0700, Dhinakaran Pandiyan wrote:
> A single 32-bit PSR2 training pattern field follows the sixteen element
> array of PSR table entries in the VBT spec. But, we incorrectly define
> this PSR2 field for each of the PSR table entries. As a result, the PSR1
> training pattern duration for any panel_type != 0 will be parsed
> incorrectly. Secondly, PSR2 training pattern durations for VBTs with bdb
> version >= 226 will also be wrong.
> 
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: José Roberto de Souza <jose.souza@intel.com>
> Cc: stable@vger.kernel.org
> Cc: stable@vger.kernel.org #v5.2
> Fixes: 88a0d9606aff ("drm/i915/vbt: Parse and use the new field with PSR2 TP2/3 wakeup time")
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111088
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204183
> Signed-off-by: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
> Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
> Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Tested-by: François Guerraz <kubrick@fgv6.net>

pushed, thanks for the patches, reviews and tests.

> ---
>  Drivers/gpu/drm/i915/display/intel_bios.c     | 2 +-
>  drivers/gpu/drm/i915/display/intel_vbt_defs.h | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
> index 21501d565327..b416b394b641 100644
> --- a/drivers/gpu/drm/i915/display/intel_bios.c
> +++ b/drivers/gpu/drm/i915/display/intel_bios.c
> @@ -766,7 +766,7 @@ parse_psr(struct drm_i915_private *dev_priv, const struct bdb_header *bdb)
>  	}
>  
>  	if (bdb->version >= 226) {
> -		u32 wakeup_time = psr_table->psr2_tp2_tp3_wakeup_time;
> +		u32 wakeup_time = psr->psr2_tp2_tp3_wakeup_time;
>  
>  		wakeup_time = (wakeup_time >> (2 * panel_type)) & 0x3;
>  		switch (wakeup_time) {
> diff --git a/drivers/gpu/drm/i915/display/intel_vbt_defs.h b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
> index 93f5c9d204d6..09cd37fb0b1c 100644
> --- a/drivers/gpu/drm/i915/display/intel_vbt_defs.h
> +++ b/drivers/gpu/drm/i915/display/intel_vbt_defs.h
> @@ -481,13 +481,13 @@ struct psr_table {
>  	/* TP wake up time in multiple of 100 */
>  	u16 tp1_wakeup_time;
>  	u16 tp2_tp3_wakeup_time;
> -
> -	/* PSR2 TP2/TP3 wakeup time for 16 panels */
> -	u32 psr2_tp2_tp3_wakeup_time;
>  } __packed;
>  
>  struct bdb_psr {
>  	struct psr_table psr_table[16];
> +
> +	/* PSR2 TP2/TP3 wakeup time for 16 panels */
> +	u32 psr2_tp2_tp3_wakeup_time;
>  } __packed;
>  
>  /*
> -- 
> 2.17.1
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
