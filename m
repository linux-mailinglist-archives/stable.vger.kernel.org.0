Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E73F82D0F
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 09:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfHFHqr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 6 Aug 2019 03:46:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:52055 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfHFHqr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 03:46:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 00:40:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,352,1559545200"; 
   d="scan'208";a="192605995"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.150])
  by fmsmga001.fm.intel.com with ESMTP; 06 Aug 2019 00:40:18 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     =?utf-8?Q?Jos=C3=A9?= Roberto de Souza <jose.souza@intel.com>,
        stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Rodrigo Vivi <rodrigo.vivi@intel.com>,
        =?utf-8?Q?Jos=C3=A9?= Roberto de Souza <jose.souza@intel.com>,
        Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        =?utf-8?Q?Fran=C3=A7ois?= Guerraz <kubrick@fgv6.net>
Subject: Re: [PATCH] drm/i915/vbt: Fix VBT parsing for the PSR section
In-Reply-To: <20190805224951.6523-1-jose.souza@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <156498469082135@kroah.com> <20190805224951.6523-1-jose.souza@intel.com>
Date:   Tue, 06 Aug 2019 10:44:33 +0300
Message-ID: <87mugmkaam.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 05 Aug 2019, José Roberto de Souza <jose.souza@intel.com> wrote:
> From: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
>

commit 6d61f716a01ec0e134de38ae97e71d6fec5a6ff6 upstream.

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
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190717223451.2595-1-dhinakaran.pandiyan@intel.com
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> (cherry picked from commit 6d61f716a01ec0e134de38ae97e71d6fec5a6ff6)
> ---
>
> Sending it for Dhinakaran, let me know if something is wrong.
>
>  drivers/gpu/drm/i915/intel_bios.c     | 2 +-
>  drivers/gpu/drm/i915/intel_vbt_defs.h | 6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
> index 1dc8d03ff127..ee6fa75d65a2 100644
> --- a/drivers/gpu/drm/i915/intel_bios.c
> +++ b/drivers/gpu/drm/i915/intel_bios.c
> @@ -762,7 +762,7 @@ parse_psr(struct drm_i915_private *dev_priv, const struct bdb_header *bdb)
>  	}
>  
>  	if (bdb->version >= 226) {
> -		u32 wakeup_time = psr_table->psr2_tp2_tp3_wakeup_time;
> +		u32 wakeup_time = psr->psr2_tp2_tp3_wakeup_time;
>  
>  		wakeup_time = (wakeup_time >> (2 * panel_type)) & 0x3;
>  		switch (wakeup_time) {
> diff --git a/drivers/gpu/drm/i915/intel_vbt_defs.h b/drivers/gpu/drm/i915/intel_vbt_defs.h
> index fdbbb9a53804..796c070bbe6f 100644
> --- a/drivers/gpu/drm/i915/intel_vbt_defs.h
> +++ b/drivers/gpu/drm/i915/intel_vbt_defs.h
> @@ -772,13 +772,13 @@ struct psr_table {
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

-- 
Jani Nikula, Intel Open Source Graphics Center
