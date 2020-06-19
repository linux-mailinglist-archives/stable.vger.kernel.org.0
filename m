Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26C52003F4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 10:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbgFSIbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 04:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731276AbgFSIbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 04:31:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C08A20776;
        Fri, 19 Jun 2020 08:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592555468;
        bh=4c+8U9zZHUIof7MZbxfw1BQ0Knp/NHxTFeh8EnfEu+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YrjDQaws0EfOWD1L6hLdVR7S3sqXGwuBW49rZkIbiAgMq1azrhsGg7LgCPIc5GrFj
         o2Y78PdOGjewRTW8Pz0Dj8xj1Me29RZDxboXqNujzLB1ogajSF48v0tqiqLiVZ2O/t
         5qBbz3SgzQzjsmf8uZfdbZn+le6F5R6t+Onetqxg=
Date:   Fri, 19 Jun 2020 10:09:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>,
        Rafael Antognolli <rafael.antognolli@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>
Subject: Re: [PATCH] drm/i915/tgl: Make Wa_14010229206 permanent
Message-ID: <20200619080900.GD8425@kroah.com>
References: <20200618202701.729-1-rodrigo.vivi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618202701.729-1-rodrigo.vivi@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 01:27:00PM -0700, Rodrigo Vivi wrote:
> From: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>
> 
> commit 63d0f3ea8ebb67160eca281320d255c72b0cb51a upstream.
> 
> This workaround now applies to all steppings, not just A0.
> Wa_1409085225 is a temporary A0-only W/A however it is
> identical to Wa_14010229206 and hence the combined workaround
> is made permanent.
> Bspec: 52890
> 
> Signed-off-by: Swathi Dhanavanthri <swathi.dhanavanthri@intel.com>
> Tested-by: Rafael Antognolli <rafael.antognolli@intel.com>
> Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
> [mattrope: added missing blank line]
> Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20200326234955.16155-1-swathi.dhanavanthri@intel.com
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> ---
>  drivers/gpu/drm/i915/gt/intel_workarounds.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

What stable kernel(s) is this backport for?  You need to give us a hint
:)

thanks,

greg k-h

> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> index 5176ad1a3976..092a42367851 100644
> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> @@ -1379,12 +1379,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
>  			    GEN7_FF_THREAD_MODE,
>  			    GEN12_FF_TESSELATION_DOP_GATE_DISABLE);
>  
> -		/*
> -		 * Wa_1409085225:tgl
> -		 * Wa_14010229206:tgl
> -		 */
> -		wa_masked_en(wal, GEN9_ROW_CHICKEN4, GEN12_DISABLE_TDL_PUSH);
> -
>  		/* Wa_1408615072:tgl */
>  		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
>  			    VSUNIT_CLKGATE_DIS_TGL);
> @@ -1402,6 +1396,12 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
>  		wa_masked_en(wal,
>  			     GEN9_CS_DEBUG_MODE1,
>  			     FF_DOP_CLOCK_GATE_DISABLE);
> +
> +		/*
> +		 * Wa_1409085225:tgl
> +		 * Wa_14010229206:tgl
> +		 */
> +		wa_masked_en(wal, GEN9_ROW_CHICKEN4, GEN12_DISABLE_TDL_PUSH);
>  	}
>  
>  	if (IS_GEN(i915, 11)) {
> -- 
> 2.24.1
> 
