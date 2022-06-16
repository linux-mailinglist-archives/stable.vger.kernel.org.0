Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B3B54DB67
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 09:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiFPHV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 03:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiFPHV0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 03:21:26 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CB25BE7F;
        Thu, 16 Jun 2022 00:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655364085; x=1686900085;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1mYg0twpCDJWukAX9HNrHpjTtlZ93/AhW3DWmO6Usa8=;
  b=FD7AoT249NIYqmd0L4+QnLWEFg3CtEjcy6a42dVTkPRo3Z/sScM0w7BC
   P3zuy2N3IyGidiJnQBfgyn9/2g1JwsOhK1Hg1lrktJtPPAinvc8n/WCM0
   vTVJPRHW9B8nWUWvbJTj+RBHRt1So9hNUJixma35pSy/1FQs2tl4oz6KX
   bl5vHUvMQHQPbhaxRrMTSRGwvdmv+mxSoIc/m3KkMKmoQlWqTeOGzQCps
   6a+ItgX10kIxVaOBwb2eNv/xfUQb67Kxev2ORE6GR9Bd6puWdVTvveY3H
   0XDaviTJD1vAj7nVD2BRkM6UH567qKF8+iYRyPg+94cUicbKXWyQ8unJJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="262207320"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="262207320"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 00:21:24 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="912044783"
Received: from mstokes1-mobl.ger.corp.intel.com (HELO [10.213.198.82]) ([10.213.198.82])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 00:21:19 -0700
Message-ID: <51e82b3b-b023-75dd-a039-e2941b426f1f@linux.intel.com>
Date:   Thu, 16 Jun 2022 08:21:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/6] drm/i915/gt: Ignore TLB invalidations on idle engines
Content-Language: en-US
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Fei Yang <fei.yang@intel.com>,
        =?UTF-8?Q?Micha=c5=82_Winiarski?= <michal.winiarski@intel.com>,
        Thomas Hellstrom <thomas.hellstrom@intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Ekstrand <jason@jlekstrand.net>,
        John Harrison <John.C.Harrison@Intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mauro.chehab@linux.intel.com,
        stable@vger.kernel.org
References: <cover.1655306128.git.mchehab@kernel.org>
 <ce7ddc900a5421e577ef446b6834ee69663c2d9a.1655306128.git.mchehab@kernel.org>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
In-Reply-To: <ce7ddc900a5421e577ef446b6834ee69663c2d9a.1655306128.git.mchehab@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/06/2022 16:27, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> As an extension of the current skip TLB invalidations,
> check if the device is powered down prior to any engine activity,
> 
> as, on such cases, all the TLBs were already invalidated, so an
> explicit TLB invalidation is not needed.
> 
> This becomes more significant  with GuC, as it can only do so when
> the connection to the GuC is awake.
> 
> Fixes: 7938d61591d3 ("drm/i915: Flush TLBs before releasing backing store")

Hmmm is this a fix or "an extension" as the commit text mentions both 
options?! GuC angle does not appear relevant for upstream yet so is cc: 
stable really required is the question.

Regards,

Tvrtko

> 
> Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
> Cc: Fei Yang <fei.yang@intel.com>
> Cc: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: stable@vger.kernel.org
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
> ---
> 
> See [PATCH 0/6] at: https://lore.kernel.org/all/cover.1655306128.git.mchehab@kernel.org/
> 
>   drivers/gpu/drm/i915/gem/i915_gem_pages.c | 10 +++++----
>   drivers/gpu/drm/i915/gt/intel_gt.c        | 26 +++++++++++++++++------
>   drivers/gpu/drm/i915/gt/intel_gt_pm.h     |  3 +++
>   3 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> index 97c820eee115..6835279943df 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> @@ -6,14 +6,15 @@
>   
>   #include <drm/drm_cache.h>
>   
> +#include "gt/intel_gt.h"
> +#include "gt/intel_gt_pm.h"
> +
>   #include "i915_drv.h"
>   #include "i915_gem_object.h"
>   #include "i915_scatterlist.h"
>   #include "i915_gem_lmem.h"
>   #include "i915_gem_mman.h"
>   
> -#include "gt/intel_gt.h"
> -
>   void __i915_gem_object_set_pages(struct drm_i915_gem_object *obj,
>   				 struct sg_table *pages,
>   				 unsigned int sg_page_sizes)
> @@ -217,10 +218,11 @@ __i915_gem_object_unset_pages(struct drm_i915_gem_object *obj)
>   
>   	if (test_and_clear_bit(I915_BO_WAS_BOUND_BIT, &obj->flags)) {
>   		struct drm_i915_private *i915 = to_i915(obj->base.dev);
> +		struct intel_gt *gt = to_gt(i915);
>   		intel_wakeref_t wakeref;
>   
> -		with_intel_runtime_pm_if_active(&i915->runtime_pm, wakeref)
> -			intel_gt_invalidate_tlbs(to_gt(i915));
> +		with_intel_gt_pm_if_awake(gt, wakeref)
> +			intel_gt_invalidate_tlbs(gt);
>   	}
>   
>   	return pages;
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt.c b/drivers/gpu/drm/i915/gt/intel_gt.c
> index f33290358c51..d5ed6a6ac67c 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt.c
> +++ b/drivers/gpu/drm/i915/gt/intel_gt.c
> @@ -11,6 +11,7 @@
>   
>   #include "i915_drv.h"
>   #include "intel_context.h"
> +#include "intel_engine_pm.h"
>   #include "intel_engine_regs.h"
>   #include "intel_gt.h"
>   #include "intel_gt_buffer_pool.h"
> @@ -1216,6 +1217,7 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>   	struct drm_i915_private *i915 = gt->i915;
>   	struct intel_uncore *uncore = gt->uncore;
>   	struct intel_engine_cs *engine;
> +	intel_engine_mask_t awake, tmp;
>   	enum intel_engine_id id;
>   	const i915_reg_t *regs;
>   	unsigned int num = 0;
> @@ -1239,12 +1241,27 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>   
>   	GEM_TRACE("\n");
>   
> -	assert_rpm_wakelock_held(&i915->runtime_pm);
> -
>   	mutex_lock(&gt->tlb_invalidate_lock);
>   	intel_uncore_forcewake_get(uncore, FORCEWAKE_ALL);
>   
> +	awake = 0;
>   	for_each_engine(engine, gt, id) {
> +		struct reg_and_bit rb;
> +
> +		if (!intel_engine_pm_is_awake(engine))
> +			continue;
> +
> +		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
> +		if (!i915_mmio_reg_offset(rb.reg))
> +			continue;
> +
> +		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
> +		awake |= engine->mask;
> +	}
> +
> +	for_each_engine_masked(engine, gt, awake, tmp) {
> +		struct reg_and_bit rb;
> +
>   		/*
>   		 * HW architecture suggest typical invalidation time at 40us,
>   		 * with pessimistic cases up to 100us and a recommendation to
> @@ -1252,13 +1269,8 @@ void intel_gt_invalidate_tlbs(struct intel_gt *gt)
>   		 */
>   		const unsigned int timeout_us = 100;
>   		const unsigned int timeout_ms = 4;
> -		struct reg_and_bit rb;
>   
>   		rb = get_reg_and_bit(engine, regs == gen8_regs, regs, num);
> -		if (!i915_mmio_reg_offset(rb.reg))
> -			continue;
> -
> -		intel_uncore_write_fw(uncore, rb.reg, rb.bit);
>   		if (__intel_wait_for_register_fw(uncore,
>   						 rb.reg, rb.bit, 0,
>   						 timeout_us, timeout_ms,
> diff --git a/drivers/gpu/drm/i915/gt/intel_gt_pm.h b/drivers/gpu/drm/i915/gt/intel_gt_pm.h
> index bc898df7a48c..a334787a4939 100644
> --- a/drivers/gpu/drm/i915/gt/intel_gt_pm.h
> +++ b/drivers/gpu/drm/i915/gt/intel_gt_pm.h
> @@ -55,6 +55,9 @@ static inline void intel_gt_pm_might_put(struct intel_gt *gt)
>   	for (tmp = 1, intel_gt_pm_get(gt); tmp; \
>   	     intel_gt_pm_put(gt), tmp = 0)
>   
> +#define with_intel_gt_pm_if_awake(gt, wf) \
> +	for (wf = intel_gt_pm_get_if_awake(gt); wf; intel_gt_pm_put_async(gt), wf = 0)
> +
>   static inline int intel_gt_pm_wait_for_idle(struct intel_gt *gt)
>   {
>   	return intel_wakeref_wait_for_idle(&gt->wakeref);
