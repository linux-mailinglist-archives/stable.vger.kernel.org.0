Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8066DF66E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 15:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjDLNEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 09:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjDLNEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 09:04:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D3E4EF2
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 06:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681304687; x=1712840687;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+vfO5vfOeKbHHyY+aPIlI/pNdTJqkSIshp1Ptu35OHk=;
  b=HgMdPBjP+HByzFi2v4A7Q2Pc7JWTXUympbhI7DSG7WtOObfFZwSpeYT1
   EZjRJNT+SKc7WTLwpEOAZNaoqSQQF5tH15nb3gka5cf4HF7g92UPCZ/0a
   PG0TNBQ/39LQyy2CvARs0gH4wUuFDm9+Om1Ke5aWiB7vP6lwfdMvzywNV
   jAfXGSMlToBnHrswsuQhuvFRKQWwn85swAMBKY4KlIgbvLxLK8X0eVQUl
   2XCGj7T8pr5Tb3ve3go56Ox0bmJowRoHxqdRfwLhl+6ywOb/FnhHnC2Y3
   vK3tAzcYjklQIepkhH29f06k9C2Vv1WUKav8jxkncUlHk/fXIZyK3/jFe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="324251411"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="324251411"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 06:04:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="688944649"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="688944649"
Received: from ahajda-mobl.ger.corp.intel.com (HELO [10.213.31.124]) ([10.213.31.124])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 06:04:33 -0700
Message-ID: <04f9e2ac-0967-1e26-fbfc-da7ff54c9a62@intel.com>
Date:   Wed, 12 Apr 2023 15:04:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH v5 2/5] drm/i915: Create the locked version of the request
 create
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
 <20230412113308.812468-3-andi.shyti@linux.intel.com>
From:   Andrzej Hajda <andrzej.hajda@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298
 Gdansk - KRS 101882 - NIP 957-07-52-316
In-Reply-To: <20230412113308.812468-3-andi.shyti@linux.intel.com>
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
> Make version of the request creation that doesn't hold any
> lock.
>
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
> ---
>   drivers/gpu/drm/i915/i915_request.c | 38 +++++++++++++++++++++--------
>   drivers/gpu/drm/i915/i915_request.h |  2 ++
>   2 files changed, 30 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 630a732aaecca..58662360ac34e 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -1028,15 +1028,11 @@ __i915_request_create(struct intel_context *ce, gfp_t gfp)
>   	return ERR_PTR(ret);
>   }
>   
> -struct i915_request *
> -i915_request_create(struct intel_context *ce)
> +static struct i915_request *
> +__i915_request_create_locked(struct intel_context *ce)
>   {
> +	struct intel_timeline *tl = ce->timeline;
>   	struct i915_request *rq;
> -	struct intel_timeline *tl;
> -
> -	tl = intel_context_timeline_lock(ce);
> -	if (IS_ERR(tl))
> -		return ERR_CAST(tl);
>   
>   	/* Move our oldest request to the slab-cache (if not in use!) */
>   	rq = list_first_entry(&tl->requests, typeof(*rq), link);
> @@ -1046,16 +1042,38 @@ i915_request_create(struct intel_context *ce)
>   	intel_context_enter(ce);
>   	rq = __i915_request_create(ce, GFP_KERNEL);
>   	intel_context_exit(ce); /* active reference transferred to request */
> +
>   	if (IS_ERR(rq))
> -		goto err_unlock;
> +		return rq;
>   
>   	/* Check that we do not interrupt ourselves with a new request */
>   	rq->cookie = lockdep_pin_lock(&tl->mutex);
>   
>   	return rq;
> +}
> +
> +struct i915_request *
> +i915_request_create_locked(struct intel_context *ce)
> +{
> +	intel_context_assert_timeline_is_locked(ce->timeline);
> +
> +	return __i915_request_create_locked(ce);
> +}

I wonder if we really need to have such granularity? Leaving only 
i915_request_create_locked and removing __i915_request_create_locked 
would simplify little bit the code,
I guess the cost of calling intel_context_assert_timeline_is_locked 
twice sometimes is not big, or maybe it can be re-arranged, up to you.

Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>

Regards
Andrzej


> +
> +struct i915_request *
> +i915_request_create(struct intel_context *ce)
> +{
> +	struct i915_request *rq;
> +	struct intel_timeline *tl;
> +
> +	tl = intel_context_timeline_lock(ce);
> +	if (IS_ERR(tl))
> +		return ERR_CAST(tl);
> +
> +	rq = __i915_request_create_locked(ce);
> +	if (IS_ERR(rq))
> +		intel_context_timeline_unlock(tl);
>   
> -err_unlock:
> -	intel_context_timeline_unlock(tl);
>   	return rq;
>   }
>   
> diff --git a/drivers/gpu/drm/i915/i915_request.h b/drivers/gpu/drm/i915/i915_request.h
> index f5e1bb5e857aa..bb48bd4605c03 100644
> --- a/drivers/gpu/drm/i915/i915_request.h
> +++ b/drivers/gpu/drm/i915/i915_request.h
> @@ -374,6 +374,8 @@ struct i915_request * __must_check
>   __i915_request_create(struct intel_context *ce, gfp_t gfp);
>   struct i915_request * __must_check
>   i915_request_create(struct intel_context *ce);
> +struct i915_request * __must_check
> +i915_request_create_locked(struct intel_context *ce);
>   
>   void __i915_request_skip(struct i915_request *rq);
>   bool i915_request_set_error_once(struct i915_request *rq, int error);

