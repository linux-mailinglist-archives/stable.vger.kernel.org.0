Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFF96DD612
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 10:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDKI7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 04:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDKI67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 04:58:59 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEB31BC9
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 01:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681203538; x=1712739538;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zbOtIQMf42c2SHzFMrB8hRwMktqs8MpIonzBrCcu15Q=;
  b=O7lwwbZzzexDjpJIxYMZudcIiOq+MxshZUjbJfcZ7YyxsCEty9P1ambJ
   ws0rotwpcCdMQrcC22wMLYTkKVyWYPKP0gKpQUaDgQZGSaMsYQsP6kAin
   E9vMYoXRLGjEB7XAsRj+d5pZthLR4DsqJ60lEBR942FVVxEECOjGGhiaw
   53fHtesDSANk5VgTo942MDZj9m6kaBINSePkLgArFIonKLuVG+FuLi57v
   li0Akn5OuUCKf+69vAseFBVFfnjrfk7H5/CKW7pD7h0OGuasEm3ihZSLb
   i9McIjEDojEJgYi6o54cjjmz/xCjyX2bo31KsCYwThBj7p3aivUbz4xKL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="327661805"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="327661805"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 01:58:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="682002558"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="682002558"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.1.115]) ([10.213.1.115])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 01:58:56 -0700
Message-ID: <3e306d18-de86-8903-2116-6443c26672ab@intel.com>
Date:   Tue, 11 Apr 2023 10:58:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [Intel-gfx] [PATCH v4 1/5] drm/i915: Throttle for ringspace prior
 to taking the timeline mutex
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Andi Shyti <andi.shyti@kernel.org>,
        Matthew Auld <matthew.auld@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>
References: <20230308094106.203686-1-andi.shyti@linux.intel.com>
 <20230308094106.203686-2-andi.shyti@linux.intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20230308094106.203686-2-andi.shyti@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.03.2023 10:41, Andi Shyti wrote:
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> Before taking exclusive ownership of the ring for emitting the request,
> wait for space in the ring to become available. This allows others to
> take the timeline->mutex to make forward progresses while userspace is
> blocked.
> 
> In particular, this allows regular clients to issue requests on the
> kernel context, potentially filling the ring, but allow the higher
> priority heartbeats and pulses to still be submitted without being
> blocked by the less critical work.
> 
> Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
> Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>

Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Regards
Andrzej
> ---
>   drivers/gpu/drm/i915/gt/intel_context.c | 41 +++++++++++++++++++++++++
>   drivers/gpu/drm/i915/gt/intel_context.h |  2 ++
>   drivers/gpu/drm/i915/i915_request.c     |  3 ++
>   3 files changed, 46 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_context.c b/drivers/gpu/drm/i915/gt/intel_context.c
> index 2aa63ec521b89..59cd612a23561 100644
> --- a/drivers/gpu/drm/i915/gt/intel_context.c
> +++ b/drivers/gpu/drm/i915/gt/intel_context.c
> @@ -626,6 +626,47 @@ bool intel_context_revoke(struct intel_context *ce)
>   	return ret;
>   }
>   
> +int intel_context_throttle(const struct intel_context *ce)
> +{
> +	const struct intel_ring *ring = ce->ring;
> +	const struct intel_timeline *tl = ce->timeline;
> +	struct i915_request *rq;
> +	int err = 0;
> +
> +	if (READ_ONCE(ring->space) >= SZ_1K)
> +		return 0;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_reverse(rq, &tl->requests, link) {
> +		if (__i915_request_is_complete(rq))
> +			break;
> +
> +		if (rq->ring != ring)
> +			continue;
> +
> +		/* Wait until there will be enough space following that rq */
> +		if (__intel_ring_space(rq->postfix,
> +				       ring->emit,
> +				       ring->size) < ring->size / 2) {
> +			if (i915_request_get_rcu(rq)) {
> +				rcu_read_unlock();
> +
> +				if (i915_request_wait(rq,
> +						      I915_WAIT_INTERRUPTIBLE,
> +						      MAX_SCHEDULE_TIMEOUT) < 0)
> +					err = -EINTR;
> +
> +				rcu_read_lock();
> +				i915_request_put(rq);
> +			}
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return err;
> +}
> +
>   #if IS_ENABLED(CONFIG_DRM_I915_SELFTEST)
>   #include "selftest_context.c"
>   #endif
> diff --git a/drivers/gpu/drm/i915/gt/intel_context.h b/drivers/gpu/drm/i915/gt/intel_context.h
> index 0a8d553da3f43..f919a66cebf5b 100644
> --- a/drivers/gpu/drm/i915/gt/intel_context.h
> +++ b/drivers/gpu/drm/i915/gt/intel_context.h
> @@ -226,6 +226,8 @@ static inline void intel_context_exit(struct intel_context *ce)
>   		ce->ops->exit(ce);
>   }
>   
> +int intel_context_throttle(const struct intel_context *ce);
> +
>   static inline struct intel_context *intel_context_get(struct intel_context *ce)
>   {
>   	kref_get(&ce->ref);
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 630a732aaecca..72aed544f8714 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -1034,6 +1034,9 @@ i915_request_create(struct intel_context *ce)
>   	struct i915_request *rq;
>   	struct intel_timeline *tl;
>   
> +	if (intel_context_throttle(ce))
> +		return ERR_PTR(-EINTR);
> +
>   	tl = intel_context_timeline_lock(ce);
>   	if (IS_ERR(tl))
>   		return ERR_CAST(tl);

