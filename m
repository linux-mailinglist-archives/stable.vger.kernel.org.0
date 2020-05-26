Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542041E2641
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 18:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbgEZQAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 12:00:10 -0400
Received: from mga17.intel.com ([192.55.52.151]:41703 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731296AbgEZQAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 12:00:10 -0400
IronPort-SDR: kf4kJqg4q/pdrtEHTLeEioz0ugThh+Srp0H6c1a/VgTOmheeYSIdjumF0gYrsn5qogtyLW6uhn
 zszC/okuic2A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 09:00:10 -0700
IronPort-SDR: /xMX7MeWVDBMfA1QwkUxAKPhUW4Ga/TkN/rB5Z3QhGAmfgwmGZC1GBz5yVcXqkgkx6l5mo4AsH
 fvXeiBkLClPw==
X-IronPort-AV: E=Sophos;i="5.73,437,1583222400"; 
   d="scan'208";a="468349222"
Received: from ggueta-mobl.ger.corp.intel.com (HELO [10.214.234.171]) ([10.214.234.171])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 09:00:08 -0700
Subject: Re: [Intel-gfx] [PATCH 2/2] drm/i915/gt: Do not schedule normal
 requests immediately along virtual
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200526090753.11329-1-chris@chris-wilson.co.uk>
 <20200526090753.11329-2-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <6016e5c6-cd09-dd3f-b102-49e76fa28518@linux.intel.com>
Date:   Tue, 26 May 2020 17:00:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200526090753.11329-2-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 26/05/2020 10:07, Chris Wilson wrote:
> When we push a virtual request onto the HW, we update the rq->engine to
> point to the physical engine. A request that is then submitted by the
> user that waits upon the virtual engine, but along the physical engine
> in use, will then see that it is due to be submitted to the same engine
> and take a shortcut (and be queued without waiting for the completion
> fence). However, the virtual request may be preempted (either by higher
> priority users, or by timeslicing) and removed from the physical engine
> to be migrated over to one of its siblings. The dependent normal request
> however is oblivious to the removal of the virtual request and remains
> queued to execute on HW, believing that once it reaches the head of its
> queue all of its predecessors will have completed executing!
> 
> v2: Beware restriction of signal->execution_mask prior to submission.
> 
> Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
> Testcase: igt/gem_exec_balancer/sliced
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.3+
> ---
>   drivers/gpu/drm/i915/i915_request.c | 25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 33bbad623e02..0b07ccc7e9bc 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -1237,6 +1237,25 @@ i915_request_await_execution(struct i915_request *rq,
>   	return 0;
>   }
>   
> +static int
> +await_request_submit(struct i915_request *to, struct i915_request *from)
> +{
> +	/*
> +	 * If we are waiting on a virtual engine, then it may be
> +	 * constrained to execute on a single engine *prior* to submission.
> +	 * When it is submitted, it will be first submitted to the virtual
> +	 * engine and then passed to the physical engine. We cannot allow
> +	 * the waiter to be submitted immediately to the physical engine
> +	 * as it may then bypass the virtual request.
> +	 */
> +	if (to->engine == READ_ONCE(from->engine))
> +		return i915_sw_fence_await_sw_fence_gfp(&to->submit,
> +							&from->submit,
> +							I915_FENCE_GFP);
> +	else

When can engines be different and the mask test below brought us here?

Regards,

Tvrtko

> +		return __i915_request_await_execution(to, from, NULL);
> +}
> +
>   static int
>   i915_request_await_request(struct i915_request *to, struct i915_request *from)
>   {
> @@ -1258,10 +1277,8 @@ i915_request_await_request(struct i915_request *to, struct i915_request *from)
>   			return ret;
>   	}
>   
> -	if (to->engine == READ_ONCE(from->engine))
> -		ret = i915_sw_fence_await_sw_fence_gfp(&to->submit,
> -						       &from->submit,
> -						       I915_FENCE_GFP);
> +	if (is_power_of_2(to->execution_mask | READ_ONCE(from->execution_mask)))
> +		ret = await_request_submit(to, from);
>   	else
>   		ret = emit_semaphore_wait(to, from, I915_FENCE_GFP);
>   	if (ret < 0)
> 
