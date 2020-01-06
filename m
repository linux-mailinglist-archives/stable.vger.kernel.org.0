Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E961313E6
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 15:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgAFOmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 09:42:11 -0500
Received: from mga03.intel.com ([134.134.136.65]:51113 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgAFOmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 09:42:11 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 06:42:11 -0800
X-IronPort-AV: E=Sophos;i="5.69,402,1571727600"; 
   d="scan'208";a="222266635"
Received: from kumarjai-mobl1.ger.corp.intel.com (HELO [10.251.83.12]) ([10.251.83.12])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 06 Jan 2020 06:42:10 -0800
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Mark up virtual engine
 uabi_instance
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org
References: <20200106123921.2543886-1-chris@chris-wilson.co.uk>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <7af25d92-8320-88d5-d705-b42347e8204f@linux.intel.com>
Date:   Mon, 6 Jan 2020 14:42:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200106123921.2543886-1-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 06/01/2020 12:39, Chris Wilson wrote:
> Be sure to initialise the uabi_instance on the virtual engine to the
> special invalid value, just in case we ever peek at it from the uAPI.
> 
> Reported-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Fixes: 750e76b4f9f6 ("drm/i915/gt: Move the [class][inst] lookup for engines onto the GT")
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> Cc: <stable@vger.kernel.org> # v5.4+
> ---
>   drivers/gpu/drm/i915/gt/intel_lrc.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index 170b5a0139a3..f07d93514a7c 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -4601,9 +4601,11 @@ intel_execlists_create_virtual(struct intel_engine_cs **siblings,
>   	ve->base.gt = siblings[0]->gt;
>   	ve->base.uncore = siblings[0]->uncore;
>   	ve->base.id = -1;
> +
>   	ve->base.class = OTHER_CLASS;
>   	ve->base.uabi_class = I915_ENGINE_CLASS_INVALID;
>   	ve->base.instance = I915_ENGINE_CLASS_INVALID_VIRTUAL;
> +	ve->base.uabi_instance = I915_ENGINE_CLASS_INVALID_VIRTUAL;
>   
>   	/*
>   	 * The decision on whether to submit a request using semaphores
> 

Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

Regards,

Tvrtko
