Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0346222038
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 12:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgGPKDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 06:03:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:54304 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgGPKDa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 06:03:30 -0400
IronPort-SDR: 0mM5XsW9vFNy/NZgJMiQHklnSgbuYlkw0j1qkhQ5Dm+h6/8sg3J+cs9RWUEM8M0/NNxIVz9lwx
 YOmh3VWvPmHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="234208833"
X-IronPort-AV: E=Sophos;i="5.75,358,1589266800"; 
   d="scan'208";a="234208833"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 03:03:29 -0700
IronPort-SDR: CjkEgKeL1rWeDNATVoYWrFHNf+t7ESyN5H2rd5YMsF3akOJvGvt4GEvqxjfr+sZyUusUwtFPdC
 09i3UOFwdiQw==
X-IronPort-AV: E=Sophos;i="5.75,358,1589266800"; 
   d="scan'208";a="460424077"
Received: from unknown (HELO [10.249.34.86]) ([10.249.34.86])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 03:03:28 -0700
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Provide the perf pmu.module
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200716094643.31410-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <1f4e4566-53eb-a91d-fa3e-0576324042fa@linux.intel.com>
Date:   Thu, 16 Jul 2020 11:03:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716094643.31410-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/07/2020 10:46, Chris Wilson wrote:
> Rather than manually implement our own module reference counting for perf
> pmu events, finally realise that there is a module parameter to struct
> pmu for this very purpose.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/gpu/drm/i915/i915_pmu.c | 7 ++-----
>   1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
> index 28bc5f13ae52..056994224c6b 100644
> --- a/drivers/gpu/drm/i915/i915_pmu.c
> +++ b/drivers/gpu/drm/i915/i915_pmu.c
> @@ -445,8 +445,6 @@ static void i915_pmu_event_destroy(struct perf_event *event)
>   		container_of(event->pmu, typeof(*i915), pmu.base);
>   
>   	drm_WARN_ON(&i915->drm, event->parent);
> -
> -	module_put(THIS_MODULE);
>   }
>   
>   static int
> @@ -538,10 +536,8 @@ static int i915_pmu_event_init(struct perf_event *event)
>   	if (ret)
>   		return ret;
>   
> -	if (!event->parent) {
> -		__module_get(THIS_MODULE);
> +	if (!event->parent)
>   		event->destroy = i915_pmu_event_destroy;
> -	}
>   
>   	return 0;
>   }
> @@ -1130,6 +1126,7 @@ void i915_pmu_register(struct drm_i915_private *i915)
>   	if (!pmu->base.attr_groups)
>   		goto err_attr;
>   
> +	pmu->base.module	= THIS_MODULE;
>   	pmu->base.task_ctx_nr	= perf_invalid_context;
>   	pmu->base.event_init	= i915_pmu_event_init;
>   	pmu->base.add		= i915_pmu_event_add;
> 

Okay!

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
