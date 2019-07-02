Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCDD5CF70
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfGBMal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:30:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:23714 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfGBMak (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 08:30:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jul 2019 05:30:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,443,1557212400"; 
   d="scan'208";a="174578458"
Received: from gaia.fi.intel.com ([10.237.72.192])
  by orsmga002.jf.intel.com with ESMTP; 02 Jul 2019 05:30:39 -0700
Received: by gaia.fi.intel.com (Postfix, from userid 1000)
        id 180995C166E; Tue,  2 Jul 2019 15:30:34 +0300 (EEST)
From:   Mika Kuoppala <mika.kuoppala@linux.intel.com>
To:     Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v7 3/3] drm/i915/icl: whitelist PS_(DEPTH|INVOCATION)_COUNT
In-Reply-To: <20190628120720.21682-4-lionel.g.landwerlin@intel.com>
References: <20190628120720.21682-1-lionel.g.landwerlin@intel.com> <20190628120720.21682-4-lionel.g.landwerlin@intel.com>
Date:   Tue, 02 Jul 2019 15:30:34 +0300
Message-ID: <87woh039g5.fsf@gaia.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Lionel Landwerlin <lionel.g.landwerlin@intel.com> writes:

> The same tests failing on CFL+ platforms are also failing on ICL.
> Documentation doesn't list the
> WaAllowPMDepthAndInvocationCountAccessFromUMD workaround for ICL but
> applying it fixes the same tests as CFL.

Didn't find more documentation either but I have asked
for the wa author for update.

>
> v2: Use only one whitelist entry (Lionel)
>
> Signed-off-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
> Tested-by:  Anuj Phogat <anuj.phogat@gmail.com>
> Cc: stable@vger.kernel.org

The register offsets are the same so we can't really do
harm with this so we go with the evidence,

Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

> ---
>  drivers/gpu/drm/i915/gt/intel_workarounds.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> index b117583e38bb..a908d829d6bd 100644
> --- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
> +++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
> @@ -1138,6 +1138,19 @@ static void icl_whitelist_build(struct intel_engine_cs *engine)
>  
>  		/* WaEnableStateCacheRedirectToCS:icl */
>  		whitelist_reg(w, GEN9_SLICE_COMMON_ECO_CHICKEN1);
> +
> +		/*
> +		 * WaAllowPMDepthAndInvocationCountAccessFromUMD:icl
> +		 *
> +		 * This covers 4 register which are next to one another :
> +		 *   - PS_INVOCATION_COUNT
> +		 *   - PS_INVOCATION_COUNT_UDW
> +		 *   - PS_DEPTH_COUNT
> +		 *   - PS_DEPTH_COUNT_UDW
> +		 */
> +		whitelist_reg_ext(w, PS_INVOCATION_COUNT,
> +				  RING_FORCE_TO_NONPRIV_RD |
> +				  RING_FORCE_TO_NONPRIV_RANGE_4);
>  		break;
>  
>  	case VIDEO_DECODE_CLASS:
> -- 
> 2.21.0.392.gf8f6787159e
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
