Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C034017A81A
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 15:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgCEOup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 09:50:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:6410 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbgCEOup (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 09:50:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 06:50:43 -0800
X-IronPort-AV: E=Sophos;i="5.70,518,1574150400"; 
   d="scan'208";a="234431635"
Received: from srware-mobl.ger.corp.intel.com (HELO [10.252.25.112]) ([10.252.25.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 05 Mar 2020 06:50:42 -0800
Subject: Re: [PATCH] drm/i915: Return early for await_start on same timeline
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200305134822.2750496-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <c61922a0-3c3b-8945-324b-31384a73dbae@linux.intel.com>
Date:   Thu, 5 Mar 2020 14:50:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305134822.2750496-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 05/03/2020 13:48, Chris Wilson wrote:
> Requests within a timeline are ordered by that timeline, so awaiting for
> the start of a request within the timeline is a no-op. This used to work
> by falling out of the mutex_trylock() as the signaler and waiter had the
> same timeline and not returning an error.
> 
> Fixes: 6a79d848403d ("drm/i915: Lock signaler timeline while navigating")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v5.5+
> ---
>   drivers/gpu/drm/i915/i915_request.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
> index 46dae33c1a20..ca5361eb1f0b 100644
> --- a/drivers/gpu/drm/i915/i915_request.c
> +++ b/drivers/gpu/drm/i915/i915_request.c
> @@ -837,8 +837,8 @@ i915_request_await_start(struct i915_request *rq, struct i915_request *signal)
>   	struct dma_fence *fence;
>   	int err;
>   
> -	GEM_BUG_ON(i915_request_timeline(rq) ==
> -		   rcu_access_pointer(signal->timeline));
> +	if (i915_request_timeline(rq) == rcu_access_pointer(signal->timeline))
> +		return 0;
>   
>   	if (i915_request_started(signal))
>   		return 0;
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
