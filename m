Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104131E1D54
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 10:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgEZI3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 04:29:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:31179 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728467AbgEZI3w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 04:29:52 -0400
IronPort-SDR: 67/BinwUiVtw+bUS7IROl+82SE4nV9/wmhd2ePe/D3TaplNcbbHEdv/EONUds3EuDp6xZxTgiU
 kTXeDFHQ/jfQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 01:29:51 -0700
IronPort-SDR: PdH2TkbgXlSkzwslOc+Dk14MdFhjk0yibPX3c9I5HRmJWLRBeguiO+k7GWQqpI+xHzOLz6zOL/
 2Dr0l4iDc/5Q==
X-IronPort-AV: E=Sophos;i="5.73,436,1583222400"; 
   d="scan'208";a="468211825"
Received: from ggueta-mobl.ger.corp.intel.com (HELO [10.214.234.171]) ([10.214.234.171])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 01:29:50 -0700
Subject: Re: [Intel-gfx] [PATCH 1/4] drm/i915/gt: Do not schedule normal
 requests immediately along virtual
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200525202901.32244-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <35df1c6a-dc43-b123-c80c-8d1af00ea1b4@linux.intel.com>
Date:   Tue, 26 May 2020 09:29:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200525202901.32244-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 25/05/2020 21:28, Chris Wilson wrote:
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
> Fixes: 6d06779e8672 ("drm/i915: Load balancing across a virtual engine")
> Testcase: igt/gem_exec_balancer/sliced
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.3+
> ---
>   drivers/gpu/drm/i915/i915_request.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index c282719ad3ac..51588209bddd 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -1074,7 +1074,7 @@ i915_request_await_request(struct i915_request *to, struct i915_request *from)
>   			return ret;
>   	}
>   
> -	if (to->engine == from->engine)
> +	if (is_power_of_2(to->execution_mask | READ_ONCE(from->execution_mask)))
>   		ret = i915_sw_fence_await_sw_fence_gfp(&to->submit,
>   						       &from->submit,
>   						       I915_FENCE_GFP);
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
