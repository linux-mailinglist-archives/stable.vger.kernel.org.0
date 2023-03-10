Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444AA6B3B9F
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 11:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCJKDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 05:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCJKDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 05:03:33 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470EB4C6F1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 02:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678442611; x=1709978611;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eP0YCTCAptTv7pP6RC1xoEguOd6vW+VfaR1cffo4ETM=;
  b=L6zLyf45Psh/XzI/6iqIjkLQzDY0FB8fmb9MNenwSIyJkG3Y4mUhF1cy
   Y1MLMWDF/yajESR8r6FsKODcp9Pezm83KjXBz+QvbdFQ+gWHivNPuf9ho
   RTmxqumvRXYjg5cPt07Tx0/nwyUGMeoAFB5r9ZV221NkHQyeI/weihHAp
   iB6CYebgkvIONuMMYAVVXgLO5BIPxHUDp/ESywDpR4RWT2FgEmYZx+A9N
   aX7/bJ1Dd0Y02yWrpmIImhFMeZncZWKEYZRmH8HbNsReWpYWRoAZ91g38
   w6NuomTFStwWWE4QvclUOvpcd/WfVkPAgGvYgSFj6gQoCYDXcRDrkOrNr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="325046882"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="325046882"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 02:03:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="627754539"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="627754539"
Received: from mnatali-mobl1.ger.corp.intel.com (HELO [10.252.14.224]) ([10.252.14.224])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 02:03:28 -0800
Message-ID: <2f708245-bfef-65b1-1c55-0e4ae48a3994@intel.com>
Date:   Fri, 10 Mar 2023 10:03:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.8.0
Subject: Re: [PATCH v4 5/5] drm/i915/gt: Make sure that errors are propagated
 through request chains
Content-Language: en-GB
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
References: <20230308094106.203686-1-andi.shyti@linux.intel.com>
 <20230308094106.203686-6-andi.shyti@linux.intel.com>
From:   Matthew Auld <matthew.auld@intel.com>
In-Reply-To: <20230308094106.203686-6-andi.shyti@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/03/2023 09:41, Andi Shyti wrote:
> Currently, when we perform operations such as clearing or copying
> large blocks of memory, we generate multiple requests that are
> executed in a chain.
> 
> However, if one of these requests fails, we may not realize it
> unless it happens to be the last request in the chain. This is
> because errors are not properly propagated.
> 
> For this we need to keep propagating the chain of fence
> notification in order to always reach the final fence associated
> to the final request.
> 
> To address this issue, we need to ensure that the chain of fence
> notifications is always propagated so that we can reach the final
> fence associated with the last request. By doing so, we will be
> able to detect any memory operation  failures and determine
> whether the memory is still invalid.
> 
> On copy and clear migration signal fences upon completion.
> 
> On copy and clear migration, signal fences upon request
> completion to ensure that we have a reliable perpetuation of the
> operation outcome.
> 
> Fixes: cf586021642d80 ("drm/i915/gt: Pipelined page migration")
> Reported-by: Matthew Auld <matthew.auld@intel.com>
> Suggested-by: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Matthew Auld <matthew.auld@intel.com>
> ---
>   drivers/gpu/drm/i915/gt/intel_migrate.c | 41 ++++++++++++++++++-------
>   1 file changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
> index 3f638f1987968..0031e7b1b4704 100644
> --- a/drivers/gpu/drm/i915/gt/intel_migrate.c
> +++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
> @@ -742,13 +742,19 @@ intel_context_migrate_copy(struct intel_context *ce,
>   			dst_offset = 2 * CHUNK_SZ;
>   	}
>   
> +	/*
> +	 * While building the chain of requests, we need to ensure
> +	 * that no one can sneak into the timeline unnoticed.
> +	 */
> +	mutex_lock(&ce->timeline->mutex);
> +

Hmm, this looks different/new from the previous version. Why do we only 
do this for the copy and not the clear btw? Both should be conceptually 
the same. Sorry if I'm misunderstanding something here.

>   	do {
>   		int len;
>   
> -		rq = i915_request_create(ce);
> +		rq = i915_request_create_locked(ce);
>   		if (IS_ERR(rq)) {
>   			err = PTR_ERR(rq);
> -			goto out_ce;
> +			break;
>   		}
>   
>   		if (deps) {
> @@ -878,10 +884,14 @@ intel_context_migrate_copy(struct intel_context *ce,
>   
>   		/* Arbitration is re-enabled between requests. */
>   out_rq:
> -		if (*out)
> +		i915_sw_fence_await(&rq->submit);
> +		i915_request_get(rq);
> +		i915_request_add_locked(rq);
> +		if (*out) {
> +			i915_sw_fence_complete(&(*out)->submit);
>   			i915_request_put(*out);
> -		*out = i915_request_get(rq);
> -		i915_request_add(rq);
> +		}
> +		*out = rq;
>   
>   		if (err)
>   			break;
> @@ -905,7 +915,10 @@ intel_context_migrate_copy(struct intel_context *ce,
>   		cond_resched();
>   	} while (1);
>   
> -out_ce:
> +	mutex_unlock(&ce->timeline->mutex);
> +
> +	if (*out)
> +		i915_sw_fence_complete(&(*out)->submit);
>   	return err;
>   }
>   
> @@ -1005,7 +1018,7 @@ intel_context_migrate_clear(struct intel_context *ce,
>   		rq = i915_request_create(ce);
>   		if (IS_ERR(rq)) {
>   			err = PTR_ERR(rq);
> -			goto out_ce;
> +			break;
>   		}
>   
>   		if (deps) {
> @@ -1056,17 +1069,23 @@ intel_context_migrate_clear(struct intel_context *ce,
>   
>   		/* Arbitration is re-enabled between requests. */
>   out_rq:
> -		if (*out)
> -			i915_request_put(*out);
> -		*out = i915_request_get(rq);
> +		i915_sw_fence_await(&rq->submit);
> +		i915_request_get(rq);
>   		i915_request_add(rq);
> +		if (*out) {
> +			i915_sw_fence_complete(&(*out)->submit);
> +			i915_request_put(*out);
> +		}
> +		*out = rq;
> +
>   		if (err || !it.sg || !sg_dma_len(it.sg))
>   			break;
>   
>   		cond_resched();
>   	} while (1);
>   
> -out_ce:
> +	if (*out)
> +		i915_sw_fence_complete(&(*out)->submit);
>   	return err;
>   }
>   
