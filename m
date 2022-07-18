Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0D65783A2
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 15:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbiGRNYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 09:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235493AbiGRNYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 09:24:09 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECD0D118;
        Mon, 18 Jul 2022 06:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658150648; x=1689686648;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qqcHWk/lAUf+5mgRAPx2mVBoNbfUdleZV6DkpswyZto=;
  b=RgE/wuNZzLDxY899CkpLfBlh3PFTGbqT7hPuSi/tc/NSGF7xiHfDqtjB
   g6Xg52Fd3e1gBY6cMFw2zU1QOczMHuAe8G+p8hw5oYCDBOMY2qzZMWJK1
   3Hn02mR1pPzSdT+LZ7t8lp7uA5uAQMCbc+MgNnB1l9Nvjei4oEQnSmGSh
   1Onx9n0WZqce9fOhadIbpDR0b+Syvq1jyBvZFzW0K9aRqHW6WTwxAJagf
   njqHlAWXYg3PwWI17qW8OIpqyi7holw7ymQwsspg6SHRUJYNaIfqqRD6o
   5i8Au2Zzh36ZuCWfQfW5+TfcV76Esf/PKCoq4g4efySIABDxGgej13oMQ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10411"; a="350179116"
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="350179116"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 06:24:08 -0700
X-IronPort-AV: E=Sophos;i="5.92,281,1650956400"; 
   d="scan'208";a="686733003"
Received: from smyint-mobl1.amr.corp.intel.com (HELO [10.212.107.15]) ([10.212.107.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2022 06:24:04 -0700
Message-ID: <f4e26591-a680-6557-c91c-63f6061bfd2d@linux.intel.com>
Date:   Mon, 18 Jul 2022 14:24:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 03/21] drm/i915/gt: Invalidate TLB of the OA unit at
 TLB invalidations
Content-Language: en-US
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fei Yang <fei.yang@intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>
References: <cover.1657800199.git.mchehab@kernel.org>
 <44ec6a01ef2e82184abbb075b9c8a09297fa120c.1657800199.git.mchehab@kernel.org>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <44ec6a01ef2e82184abbb075b9c8a09297fa120c.1657800199.git.mchehab@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 14/07/2022 13:06, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Ensure that the TLB of the OA unit is also invalidated
> on gen12 HW, as just invalidating the TLB of an engine is not
> enough.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Fei Yang <fei.yang@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko

> ---
> 
> To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
> See [PATCH v2 00/21] at: https://lore.kernel.org/all/cover.1657800199.git.mchehab@kernel.org/
> 
>   drivers/gpu/drm/i915/gt/intel_gt.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
> index c4d43da84d8e..1d84418e8676 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt.c
> +++ b/drivers/gpu/drm/i915/gt/intel_gt.c
> @@ -11,6 +11,7 @@
>   #include "pxp/intel_pxp.h"
>   
>   #include "i915_drv.h"
> +#include "i915_perf_oa_regs.h"
>   #include "intel_context.h"
>   #include "intel_engine_pm.h"
>   #include "intel_engine_regs.h"
> @@ -969,6 +970,15 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>   		awake |= engine->mask;
>   	}
>   
> +	/* Wa_2207587034:tgl,dg1,rkl,adl-s,adl-p */
> +	if (awake &&
> +	    (IS_TIGERLAKE(i915) ||
> +	     IS_DG1(i915) ||
> +	     IS_ROCKETLAKE(i915) ||
> +	     IS_ALDERLAKE_S(i915) ||
> +	     IS_ALDERLAKE_P(i915)))
> +		intel_uncore_write_fw(uncore, GEN12_OA_TLB_INV_CR, 1);
> +
>   	spin_unlock_irq(&uncore->lock);
>   
>   	for_each_engine_masked(engine, gt, awake, tmp) {
