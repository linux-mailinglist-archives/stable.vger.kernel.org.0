Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E7F6DF677
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 15:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjDLNGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 09:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjDLNGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 09:06:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C99F468D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 06:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681304808; x=1712840808;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+ww8atLLfpRWtd8sUrbkyYsv02NvvBO8i6kXHEmZG50=;
  b=SXOjm0b/S0ERwIx80lQhGPXX2kV7pnkSiz+CxD5CTIDUEDCQht5UtZWu
   Iuos5aCEgH4gLGsx5MKBcLXsFTbiyCJO+dCiqnLKI6WxJslZL6PVUJj2m
   YRmpSgNmuYg8XEU4Xv4igFZDtL65eIHay00CoRrLaayRaJ/+6ugCdifMS
   A5SoTwUKZdpaDvE1hqYjAOvwOtPc0zawPwvJk8Aym0aiBX4OoqPzwxubi
   Qebw1EYfgYobzOppk61Zu238rpNlmjrXfDwgxaVIT7LJ8v0ssoUhgsHkj
   c41Eeo8VhhNq14pg5Hde0gf5jl/d0RLw+9V798n+7ZxIHAdiS6i7v8XVh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="406716244"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="406716244"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 06:06:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="753521730"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="753521730"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.31.124]) ([10.213.31.124])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 06:06:44 -0700
Message-ID: <d00d6c70-67a7-0bed-eeb2-96260da4beec@intel.com>
Date:   Wed, 12 Apr 2023 15:06:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH v5 3/5] drm/i915: Create the locked version of the request
 add
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
References: <20230412113308.812468-1-andi.shyti@linux.intel.com>
 <20230412113308.812468-4-andi.shyti@linux.intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20230412113308.812468-4-andi.shyti@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12.04.2023 13:33, Andi Shyti wrote:
> i915_request_add() assumes that the timeline is locked whtn the
*when
> function is called. Before exiting it releases the lock. But in
> the next commit we have one case where releasing the timeline
> mutex is not necessary and we don't want that.
>
> Make a new i915_request_add_locked() version of the function
> where the lock is not released.
>
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: stable@vger.kernel.org

Have you looked for other potential users of these new helpers?

Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Regards
Andrzej

> ---
>   drivers/gpu/drm/i915/i915_request.c | 14 +++++++++++---
>   drivers/gpu/drm/i915/i915_request.h |  1 +
>   2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 58662360ac34e..21032b3b9d330 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -1852,13 +1852,13 @@ void __i915_request_queue(struct i915_request *rq,
>   	local_bh_enable(); /* kick tasklets */
>   }
>   
> -void i915_request_add(struct i915_request *rq)
> +void i915_request_add_locked(struct i915_request *rq)
>   {
>   	struct intel_timeline * const tl = i915_request_timeline(rq);
>   	struct i915_sched_attr attr = {};
>   	struct i915_gem_context *ctx;
>   
> -	lockdep_assert_held(&tl->mutex);
> +	intel_context_assert_timeline_is_locked(tl);
>   	lockdep_unpin_lock(&tl->mutex, rq->cookie);
>   
>   	trace_i915_request_add(rq);
> @@ -1873,7 +1873,15 @@ void i915_request_add(struct i915_request *rq)
>   
>   	__i915_request_queue(rq, &attr);
>   
> -	mutex_unlock(&tl->mutex);
> +}
> +
> +void i915_request_add(struct i915_request *rq)
> +{
> +	struct intel_timeline * const tl = i915_request_timeline(rq);
> +
> +	i915_request_add_locked(rq);
> +
> +	intel_context_timeline_unlock(tl);
>   }
>   
>   static unsigned long local_clock_ns(unsigned int *cpu)
> diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
> index bb48bd4605c03..29e3a37c300a7 100644
> --- a/drivers/gpu/drm/i915/i915_request.h
> +++ b/drivers/gpu/drm/i915/i915_request.h
> @@ -425,6 +425,7 @@ int i915_request_await_deps(struct i915_request *rq, const struct i915_deps *dep
>   int i915_request_await_execution(struct i915_request *rq,
>   				 struct dma_fence *fence);
>   
> +void i915_request_add_locked(struct i915_request *rq);
>   void i915_request_add(struct i915_request *rq);
>   
>   bool __i915_request_submit(struct i915_request *request);

