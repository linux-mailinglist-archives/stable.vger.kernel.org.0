Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0876117A39A
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 12:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgCELEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 06:04:05 -0500
Received: from mga17.intel.com ([192.55.52.151]:52395 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgCELEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 06:04:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 03:04:04 -0800
X-IronPort-AV: E=Sophos;i="5.70,517,1574150400"; 
   d="scan'208";a="234381443"
Received: from srware-mobl.ger.corp.intel.com (HELO [10.252.25.112]) ([10.252.25.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Mar 2020 03:04:03 -0800
Subject: Re: [PATCH] drm/i915: Actually emit the await_start
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200305104210.2619967-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <4f6d9c73-3ca3-121e-2230-99e31903d58f@linux.intel.com>
Date:   Thu, 5 Mar 2020 11:04:00 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305104210.2619967-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 05/03/2020 10:42, Chris Wilson wrote:
> Fix the inverted test to emit the wait on the end of the previous
> request if we /haven't/ already.
> 
> Fixes: 6a79d848403d ("drm/i915: Lock signaler timeline while navigating")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.5+
> ---
>   drivers/gpu/drm/i915/i915_request.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 4bfe68edfc81..46dae33c1a20 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -882,7 +882,7 @@ i915_request_await_start(struct i915_request *rq, struct i915_request *signal)
>   		return 0;
>   
>   	err = 0;
> -	if (intel_timeline_sync_is_later(i915_request_timeline(rq), fence))
> +	if (!intel_timeline_sync_is_later(i915_request_timeline(rq), fence))
>   		err = i915_sw_fence_await_dma_fence(&rq->submit,
>   						    fence, 0,
>   						    I915_FENCE_GFP);
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
