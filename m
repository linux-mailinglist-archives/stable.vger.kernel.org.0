Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488A0535EB9
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 12:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350387AbiE0K4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 06:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345057AbiE0Kz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 06:55:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DA2AF315;
        Fri, 27 May 2022 03:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653648956; x=1685184956;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yc4S0u2C2VhURypEc36HrClevcfxM811/nQDJ6YeXwQ=;
  b=LosCs00tdiDokxzpAiT1l1udtO319vEwXFFRiC1kZago+EWrbB/YgvDD
   uecHdGNB+/NTFd6Spm4DiJYGQmMKWC61TD2Io5/X/cnGkoj1CxWdfPGnc
   mWgJSA7MiG5iDu0QQSFRSFpNCxsIvlOavqVnnfnyDwXF6SjYVpCI6snjH
   MtPPTWSaMu+jU8D5oQmTdJ5SIO2txr288AaaeqNH98o9rWvAscSbXch8n
   xh9nImndfhztJu6mc5gEO5yGwHErrcXDBBMnRX5dc3elUuIkjv936UNmv
   jNCs/M4J0qNmkH7bl0ubarufsIscnFi9EDcSEU/rzvu+tsgPEmxEx1YsD
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="256520205"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="256520205"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 03:55:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="574524669"
Received: from dnanduri-mobl.ger.corp.intel.com (HELO [10.213.215.174]) ([10.213.215.174])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 03:55:44 -0700
Message-ID: <d981f429-d01f-4576-2e5c-0ae153d24df1@linux.intel.com>
Date:   Fri, 27 May 2022 11:55:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] drm/i915: don't flush TLB on GEN8
Content-Language: en-US
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Jani Nikula <jani.nikula@intel.com>, stable@vger.kernel.org
References: <b6417c5bf1b0ee8e093712264f325bd1268ed1e4.1653642514.git.mchehab@kernel.org>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <b6417c5bf1b0ee8e093712264f325bd1268ed1e4.1653642514.git.mchehab@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/05/2022 10:09, Mauro Carvalho Chehab wrote:
> i915 selftest hangcheck is causing the i915 driver timeouts, as
> reported by Intel CI:
> 
> 	http://gfx-ci.fi.intel.com/cibuglog-ng/issuefilterassoc/24297?query_key=42a999f48fa6ecce068bc8126c069be7c31153b4
> 
> When such test runs, the only output is:
> 
> 	[   68.811639] i915: Performing live selftests with st_random_seed=0xe138eac7 st_timeout=500
> 	[   68.811792] i915: Running hangcheck
> 	[   68.811859] i915: Running intel_hangcheck_live_selftests/igt_hang_sanitycheck
> 	[   68.816910] i915 0000:00:02.0: [drm] Cannot find any crtc or sizes
> 	[   68.841597] i915: Running intel_hangcheck_live_selftests/igt_reset_nop
> 	[   69.346347] igt_reset_nop: 80 resets
> 	[   69.362695] i915: Running intel_hangcheck_live_selftests/igt_reset_nop_engine
> 	[   69.863559] igt_reset_nop_engine(rcs0): 709 resets
> 	[   70.364924] igt_reset_nop_engine(bcs0): 903 resets
> 	[   70.866005] igt_reset_nop_engine(vcs0): 659 resets
> 	[   71.367934] igt_reset_nop_engine(vcs1): 549 resets
> 	[   71.869259] igt_reset_nop_engine(vecs0): 553 resets
> 	[   71.882592] i915: Running intel_hangcheck_live_selftests/igt_reset_idle_engine
> 	[   72.383554] rcs0: Completed 16605 idle resets
> 	[   72.884599] bcs0: Completed 18641 idle resets
> 	[   73.385592] vcs0: Completed 17517 idle resets
> 	[   73.886658] vcs1: Completed 15474 idle resets
> 	[   74.387600] vecs0: Completed 17983 idle resets
> 	[   74.387667] i915: Running intel_hangcheck_live_selftests/igt_reset_active_engine
> 	[   74.889017] rcs0: Completed 747 active resets
> 	[   75.174240] intel_engine_reset(bcs0) failed, err:-110
> 	[   75.174301] bcs0: Completed 525 active resets
> 
> After that, the machine just silently hangs.
> 
> The root cause is that the flush TLB logic is not working as
> expected on GEN8.
> 
> Tested on an Intel NUC5i7RYB with an i7-5557U Broadwell CPU.
> 
> This patch partially reverts the logic by skipping GEN8 from
> the TLB cache flush.

Since I am pretty sure no such failures were spotted when merging the 
feature I assume the failure is sporadic and/or limited to some 
configurations? Do you have any details there? Because it is an 
important security issue we should not revert it lightly.

Regards,

Tvrtko

> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: Sushma Venkatesh Reddy <sushma.venkatesh.reddy@intel.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Jon Bloomfield <jon.bloomfield@intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Jani Nikula <jani.nikula@intel.com>
> Cc: stable@vger.kernel.org # Kernel 5.17 and upper
> 
> Fixes: 494c2c9b630e ("drm/i915: Flush TLBs before releasing backing store")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> ---
> 
> Patch resent, as the first version was using an old email. That's what happens
> when writing patches on old test machines ;-)
> 
>   drivers/gpu/drm/i915/gt/intel_gt.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
> index 034182f85501..7965a77e5046 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt.c
> +++ b/drivers/gpu/drm/i915/gt/intel_gt.c
> @@ -1191,10 +1191,10 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>   	if (GRAPHICS_VER(i915) == 12) {
>   		regs = gen12_regs;
>   		num = ARRAY_SIZE(gen12_regs);
> -	} else if (GRAPHICS_VER(i915) >= 8 && GRAPHICS_VER(i915) <= 11) {
> +	} else if (GRAPHICS_VER(i915) > 8 && GRAPHICS_VER(i915) <= 11) {
>   		regs = gen8_regs;
>   		num = ARRAY_SIZE(gen8_regs);
> -	} else if (GRAPHICS_VER(i915) < 8) {
> +	} else if (GRAPHICS_VER(i915) <= 8) {
>   		return;
>   	}
>   
