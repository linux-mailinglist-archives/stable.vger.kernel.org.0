Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7AB1C0F38
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 10:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgEAIOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 04:14:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:57482 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728363AbgEAIOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 04:14:48 -0400
IronPort-SDR: Z9wuePn7KAfzWoJtJpCMfrXygmCByoJ1BHUu3LD5xM68i5g7Tp7iZfSWPISQ9WuiIGBNtRIQgR
 OytQ8EXW7Iqw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 01:14:48 -0700
IronPort-SDR: vo7Ltg8COPziTclbV6FwQnkWCuCfZ7jDHYuSm0AnYUCf/I26BU4vNGAzx/182ekJYQ/K//CB96
 WiXBbN+uifKA==
X-IronPort-AV: E=Sophos;i="5.73,339,1583222400"; 
   d="scan'208";a="247444258"
Received: from stal1-mobl.ger.corp.intel.com (HELO [10.214.218.50]) ([10.214.218.50])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2020 01:14:47 -0700
Subject: Re: [Intel-gfx] [PATCH] drm/i915/pmu: Keep a reference to module
 while active
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200430183324.23984-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <0faabfb0-25f2-ce38-f454-afcd68c039f9@linux.intel.com>
Date:   Fri, 1 May 2020 09:14:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200430183324.23984-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 30/04/2020 19:33, Chris Wilson wrote:
> While a perf event is open, keep a reference to the module so we don't
> remove the driver internals mid-sampling.
> 
> Testcase: igt/perf_pmu/module-unload
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/gpu/drm/i915/i915_pmu.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
> index 83c6a8ccd2cb..e991a707bdb7 100644
> --- a/drivers/gpu/drm/i915/i915_pmu.c
> +++ b/drivers/gpu/drm/i915/i915_pmu.c
> @@ -442,6 +442,7 @@ static u64 count_interrupts(struct drm_i915_private *i915)
>   static void i915_pmu_event_destroy(struct perf_event *event)
>   {
>   	WARN_ON(event->parent);
> +	module_put(THIS_MODULE);
>   }
>   
>   static int
> @@ -533,8 +534,10 @@ static int i915_pmu_event_init(struct perf_event *event)
>   	if (ret)
>   		return ret;
>   
> -	if (!event->parent)
> +	if (!event->parent) {
> +		__module_get(THIS_MODULE);
>   		event->destroy = i915_pmu_event_destroy;
> +	}
>   
>   	return 0;
>   }
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
