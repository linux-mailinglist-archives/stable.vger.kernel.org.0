Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E703B56AD71
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 23:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbiGGV1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 17:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236465AbiGGV13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 17:27:29 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047352CCB6;
        Thu,  7 Jul 2022 14:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657229249; x=1688765249;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PXbXvmkubPpAjg6VkvBTx8tBZLxZ+6mUsGiUQ/hzeUU=;
  b=N8XvqArhI+vGv/JkGtbIGmAYaawACtyVTfXnm/r1SbT1Bd4ldRY+Qn9r
   O1dn5Wk30D36nSG2ZzwLxBeBKGFL2t+E6Xw7JY9BTGUZkmf0XSmytSl4/
   nUvaf0NMyB0euCmLssQB6l0WVmOXj9EU88U5bi8n7gv/CQNmdGHsb8TYH
   5M7K+Wh6y+cCqhWtCvj/F1Re8mEGVa73ELJ5iizITw98x4GUlVjHseYT1
   QKh6d3Ab0S7yZCgLJ9OAcc1dmpxuGDGAFS2ItUtYjRbwv6ZzQ7yMxS1WA
   2zkJhUJUbwPmzODT+CSxM/z/JLD9icqDFfiN7zt/mvYenitLEQB2vDrce
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="281674605"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="281674605"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 14:27:28 -0700
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="651297085"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.16.170]) ([10.213.16.170])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 14:27:24 -0700
Message-ID: <4be08bb8-2068-c3b1-3663-5dfb69a66f17@intel.com>
Date:   Thu, 7 Jul 2022 23:27:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [Intel-gfx] [PATCH v3 1/2] drm/i915/gt: Serialize GRDOM access
 between multiple engine resets
Content-Language: en-US
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Chris Wilson <chris.p.wilson@intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Andi Shyti <andi.shyti@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
References: <cover.1656921701.git.mchehab@kernel.org>
 <ccc54757d89d38af35e5c5885edfb980c7b227f6.1656921701.git.mchehab@kernel.org>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <ccc54757d89d38af35e5c5885edfb980c7b227f6.1656921701.git.mchehab@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.07.2022 10:09, Mauro Carvalho Chehab wrote:
> From: Chris Wilson <chris.p.wilson@intel.com>
> 
> Don't allow two engines to be reset in parallel, as they would both
> try to select a reset bit (and send requests to common registers)
> and wait on that register, at the same time. Serialize control of
> the reset requests/acks using the uncore->lock, which will also ensure
> that no other GT state changes at the same time as the actual reset.
> 
> Cc: stable@vger.kernel.org # Up to 4.4
> Reported-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Reviewed-by: Andi Shyti <andi.shyti@intel.com>
> Acked-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Regards
Andrzej

> ---
> 
> To avoid mailbombing on a large number of people, only mailing lists were C/C on the cover.
> See [PATCH v3 0/2] at: https://lore.kernel.org/all/cover.1656921701.git.mchehab@kernel.org/
> 
>   drivers/gpu/drm/i915/gt/intel_reset.c | 37 ++++++++++++++++++++-------
>   1 file changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_reset.c b/drivers/gpu/drm/i915/gt/intel_reset.c
> index a5338c3fde7a..c68d36fb5bbd 100644
> --- a/drivers/gpu/drm/i915/gt/intel_reset.c
> +++ b/drivers/gpu/drm/i915/gt/intel_reset.c
> @@ -300,9 +300,9 @@ static int gen6_hw_domain_reset(struct intel_gt *gt, u32 hw_domain_mask)
>   	return err;
>   }
>   
> -static int gen6_reset_engines(struct intel_gt *gt,
> -			      intel_engine_mask_t engine_mask,
> -			      unsigned int retry)
> +static int __gen6_reset_engines(struct intel_gt *gt,
> +				intel_engine_mask_t engine_mask,
> +				unsigned int retry)
>   {
>   	struct intel_engine_cs *engine;
>   	u32 hw_mask;
> @@ -321,6 +321,20 @@ static int gen6_reset_engines(struct intel_gt *gt,
>   	return gen6_hw_domain_reset(gt, hw_mask);
>   }
>   
> +static int gen6_reset_engines(struct intel_gt *gt,
> +			      intel_engine_mask_t engine_mask,
> +			      unsigned int retry)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&gt->uncore->lock, flags);
> +	ret = __gen6_reset_engines(gt, engine_mask, retry);
> +	spin_unlock_irqrestore(&gt->uncore->lock, flags);
> +
> +	return ret;
> +}
> +
>   static struct intel_engine_cs *find_sfc_paired_vecs_engine(struct intel_engine_cs *engine)
>   {
>   	int vecs_id;
> @@ -487,9 +501,9 @@ static void gen11_unlock_sfc(struct intel_engine_cs *engine)
>   	rmw_clear_fw(uncore, sfc_lock.lock_reg, sfc_lock.lock_bit);
>   }
>   
> -static int gen11_reset_engines(struct intel_gt *gt,
> -			       intel_engine_mask_t engine_mask,
> -			       unsigned int retry)
> +static int __gen11_reset_engines(struct intel_gt *gt,
> +				 intel_engine_mask_t engine_mask,
> +				 unsigned int retry)
>   {
>   	struct intel_engine_cs *engine;
>   	intel_engine_mask_t tmp;
> @@ -583,8 +597,11 @@ static int gen8_reset_engines(struct intel_gt *gt,
>   	struct intel_engine_cs *engine;
>   	const bool reset_non_ready = retry >= 1;
>   	intel_engine_mask_t tmp;
> +	unsigned long flags;
>   	int ret;
>   
> +	spin_lock_irqsave(&gt->uncore->lock, flags);
> +
>   	for_each_engine_masked(engine, gt, engine_mask, tmp) {
>   		ret = gen8_engine_reset_prepare(engine);
>   		if (ret && !reset_non_ready)
> @@ -612,17 +629,19 @@ static int gen8_reset_engines(struct intel_gt *gt,
>   	 * This is best effort, so ignore any error from the initial reset.
>   	 */
>   	if (IS_DG2(gt->i915) && engine_mask == ALL_ENGINES)
> -		gen11_reset_engines(gt, gt->info.engine_mask, 0);
> +		__gen11_reset_engines(gt, gt->info.engine_mask, 0);
>   
>   	if (GRAPHICS_VER(gt->i915) >= 11)
> -		ret = gen11_reset_engines(gt, engine_mask, retry);
> +		ret = __gen11_reset_engines(gt, engine_mask, retry);
>   	else
> -		ret = gen6_reset_engines(gt, engine_mask, retry);
> +		ret = __gen6_reset_engines(gt, engine_mask, retry);
>   
>   skip_reset:
>   	for_each_engine_masked(engine, gt, engine_mask, tmp)
>   		gen8_engine_reset_cancel(engine);
>   
> +	spin_unlock_irqrestore(&gt->uncore->lock, flags);
> +
>   	return ret;
>   }
>   

